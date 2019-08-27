Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA29F9EA00
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 15:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbfH0Nty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 09:49:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22712 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729873AbfH0Nty (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Aug 2019 09:49:54 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7RDm1vj016534
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 09:49:53 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2un4fu49f3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 09:49:52 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 27 Aug 2019 14:49:50 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 27 Aug 2019 14:49:48 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7RDnlDi26280232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 13:49:47 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F62A52052;
        Tue, 27 Aug 2019 13:49:47 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id AF94652057;
        Tue, 27 Aug 2019 13:49:46 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 0/3] s390x: Add skey removal facility test
Date:   Tue, 27 Aug 2019 15:49:33 +0200
X-Mailer: git-send-email 2.17.0
X-TM-AS-GCONF: 00
x-cbid: 19082713-0012-0000-0000-000003437E2D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082713-0013-0000-0000-0000217DB71E
Message-Id: <20190827134936.1705-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-27_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=993 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908270149
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The storage key removal facility (skrf) is an anti-facility, which
makes skey related instructions result in a special operation
exception when they handle storage keys. E.g. pfmf in clearing mode
does not result in an exception, but pfmf key setting does.

The skrf is always active in protected virtualization guests and can
be emulated by KVM (expected to be upstreamed with the remaining hpage
patches).

Janosch Frank (3):
  s390x: Move pfmf to lib and make address void
  s390x: Storage key library functions now take void ptr addresses
  s390x: Add storage key removal facility

 lib/s390x/asm/mem.h |  40 ++++++++++++--
 s390x/Makefile      |   1 +
 s390x/pfmf.c        |  77 +++++++++++---------------
 s390x/skey.c        |  29 +++++-----
 s390x/skrf.c        | 130 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 212 insertions(+), 65 deletions(-)
 create mode 100644 s390x/skrf.c

-- 
2.17.0

