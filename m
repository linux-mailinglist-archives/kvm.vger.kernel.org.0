Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E28F4788F4
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 11:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbhLQKcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 05:32:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27752 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233340AbhLQKcB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Dec 2021 05:32:01 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BH8MMxA023088;
        Fri, 17 Dec 2021 10:32:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=oao7Jz8uKggZjpT9CaFKAb17yk9GUToMYWCZbOESldQ=;
 b=azMM8kTUtFbpXNcQxg1DFA2IIe7nTCHykHgrhSMu+504e5aQtuVZwMx6NO3ylpNqQU59
 rebWjXdt1QGil+OdEh71Yt/uzg2C6VcGRUJhS9Xpu1qL27I58gZWfM7foQ8xVyX/kd65
 2/ca17NFXK+oQKnDmpetd81sa8tYT5OfEIQeN5G5OJEmU2s/4UltMMRgRduNbRsjKGnS
 lCtLFR6trgHAFPvO5BLNYNlyvD6jLp9wKDOg0es0R30cNqgdwiYDAOYegpHJ2c66dPjH
 crGBIBK5oQR+LsT3YyqNQFDGL8ZpW2XKhekAEAF8SPj1BsPXsXjgQJ+y46EdnKi1wlbM YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d0pywtgfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 10:32:01 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BH9cJ0m014012;
        Fri, 17 Dec 2021 10:32:00 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d0pywtgf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 10:32:00 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BHADZiI005085;
        Fri, 17 Dec 2021 10:31:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3cy78erajr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 10:31:58 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BHAVtXh48300292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 10:31:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA8E5A406E;
        Fri, 17 Dec 2021 10:31:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90E4FA4064;
        Fri, 17 Dec 2021 10:31:54 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Dec 2021 10:31:54 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [PATCH kvm-unit-tests 0/2] s390x: diag288: Improve readability
Date:   Fri, 17 Dec 2021 11:31:35 +0100
Message-Id: <20211217103137.1293092-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Mz-htrlLYTfw1PA09XYu3adYWWbnUKlB
X-Proofpoint-ORIG-GUID: tOIP6_YLRX38DOkPYG8c1-Y7GF5-mePr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_04,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=569 mlxscore=0 phishscore=0 adultscore=0
 malwarescore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 spamscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112170060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I had a somewhat hard time figuring out what diag288 does, in particular what
the number 424 is. This is an attempt to fix that by improving the naming.

While looking at the code, I also noticed we're missing a clobber for
r0, addressing in this series as well.

Nico Boehr (2):
  s390x: diag288: Add missing clobber
  s390x: diag288: Improve readability

 s390x/diag288.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

-- 
2.31.1

