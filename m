Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8CF02FC065
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 20:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbhASTxf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 14:53:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57702 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729810AbhASTxM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 14:53:12 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JJqBEd140590;
        Tue, 19 Jan 2021 14:52:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=HEBdN8lbpr3SIK7UyL8oZxUuzKeTZ2/1D2AcPLYxDlQ=;
 b=aHnVcxgIIvZ0u5MKQYyy3I6uX8agqHc6cQL5LZ9lKYlkmxydwx46EOU5l/33pEs7On6B
 qTclfkcXXhXsQfWDoYgtSYQdzfPYlhpZoofhYUJgYeDsaNkU2f9nbr7Kz3MFpRI8Cj+h
 MECmdYB5zu7NcbYzsQHlt3hYiFRbP8acdfWGH7u7l0yla2a8ihJxDX2dKPyh84rjSRGS
 8kWDB+GN/QN89QgHdV6yn3HjqNxL2ZiC4maJzWzKvUC8YTgC9T+3zfYC11RsRDCHWBYv
 /CwQ4K+xk6KeL9AqvAmxBSuu+ZIgjcekKjbbeO1HIWKEUyojd0fv+yG7yUZrgRhvHadt Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3665y3004q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 14:52:31 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JJqTJR140934;
        Tue, 19 Jan 2021 14:52:31 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3665y30046-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 14:52:31 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JJq7PC029857;
        Tue, 19 Jan 2021 19:52:28 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 363t0y9qf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 19:52:28 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JJqPoG49086814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 19:52:26 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6CE042041;
        Tue, 19 Jan 2021 19:52:25 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 675B14203F;
        Tue, 19 Jan 2021 19:52:25 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.38.46])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jan 2021 19:52:25 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com, pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/3] s390x: css: pv: css test adaptation for PV
Date:   Tue, 19 Jan 2021 20:52:21 +0100
Message-Id: <1611085944-21609-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_09:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190106
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

To adapt the CSS I/O tests to protected virtualisation we need
utilities to:

1- allocate the I/O buffers in a private page using (patch 2)
   It must be in a dedicated page to avoid exporting code or
   guest private data to the host.

2- share the I/O buffers with the host (patch 1)
   This patch uses the page allocator reworked by Claudio.

The 2 first patches are the implementation of the tools,
patch 3 is the modification of the css.c test for PV.

regards,
Pierre

Pierre Morel (3):
  s390x: pv: implement routine to share/unshare memory
  s390x: define UV compatible I/O allocation
  s390x: css: pv: css test adaptation for PV

 lib/s390x/asm/uv.h    | 38 ++++++++++++++++++++++++++++++++
 lib/s390x/css.h       |  3 +--
 lib/s390x/css_lib.c   | 28 +++++++-----------------
 lib/s390x/malloc_io.c | 50 +++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/malloc_io.h | 18 ++++++++++++++++
 s390x/Makefile        |  1 +
 s390x/css.c           | 35 ++++++++++++++++++++----------
 7 files changed, 140 insertions(+), 33 deletions(-)
 create mode 100644 lib/s390x/malloc_io.c
 create mode 100644 lib/s390x/malloc_io.h

-- 
2.17.1

changelog:

from v2:

- use the page allocator reworked by Claudio

from v1:

- add the kvm-unit-test header

- correct checks for errors on Set/Remove Shared Access

- Add report for uv Set/Remove Shared Access

- zero the allocated I/O page before use

- free the page on error.

