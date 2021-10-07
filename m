Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFACE424F7C
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 10:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240471AbhJGIxs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 04:53:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44012 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240446AbhJGIxr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 04:53:47 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1978JRsv030896;
        Thu, 7 Oct 2021 04:51:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=rqaqjGfaxg0wkxWPo8+X9xPVzO4rLO7jhGG6txauBes=;
 b=SWldBp4ZWcS8kljVqPhDuSZCYs+lgpzP0VWZyYBtNkhEJjwYHOKtlF6CMKzO7888c9JP
 LzcPoFzpB19wayEz6VqUWfxFT4Kxp+mhAQJJytpeMidz9+T1f9djTEcyUSxnYWE4s5W3
 P/Eb9S4Rfivk5/QYltniahNj4+M84cBuydIN5fWrNMm/gZ5wepD4WVuxN7L8qDqKmSNA
 NweBel0phKHTNvAOAazzMWwX/qP0/kRcGCysEV7IK/6iOJOJJhYXxjoieF4dErznaW05
 Ntu5iRz0x2uwY1+ylFE4DHiD7XfE6DpjoL+tq1QVc36eV002Tc/tHfdGuP8Mz5BVxroB 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bhcsd78sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:51:53 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1978AM1b029066;
        Thu, 7 Oct 2021 04:51:53 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bhcsd78sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:51:53 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1978hM2g004926;
        Thu, 7 Oct 2021 08:51:51 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3bef2ap0fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 08:51:51 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1978pfIn5505572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Oct 2021 08:51:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4F4EAE091;
        Thu,  7 Oct 2021 08:51:40 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B1DBAE08B;
        Thu,  7 Oct 2021 08:51:38 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Oct 2021 08:51:37 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 0/9] s390x: Cleanup and maintenance 2
Date:   Thu,  7 Oct 2021 08:50:18 +0000
Message-Id: <20211007085027.13050-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: q_CfBHyffj2tNLAQc7Ns5Cw2H7SIFWX-
X-Proofpoint-GUID: v5ru4rmCyzO5TGuHG7xtjUT9ybre40CY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here are a few more fixes and cleanups that improve readability and
architectural compliance.

v3:
	* Check CC == 1 for rc 0x100 query
	* ifndef the UV debug switch
	* Replaced tprot fix
	* Added a simple fix to the snippet lib linking problem

Janis Schoetterl-Glausch (1):
  lib: s390x: Add access key argument to tprot

Janosch Frank (8):
  s390x: uv: Tolerate 0x100 query return code
  s390x: uv-host: Fence a destroy cpu test on z15
  lib: s390x: uv: Fix share return value and print
  lib: s390x: uv: Add UVC_ERR_DEBUG switch
  lib: s390x: Print PGM code as hex
  s390x: Add sthyi cc==0 r2+1 verification
  s390x: snippets: Set stackptr and stacktop in cstart.S
  s390x: snippets: Define all things that are needed to link the lib

 lib/s390x/asm/arch_def.h  | 20 +++++++++++++++++---
 lib/s390x/asm/uv.h        | 21 +++++++++++++--------
 lib/s390x/interrupt.c     |  2 +-
 lib/s390x/sclp.c          |  2 +-
 s390x/skrf.c              |  3 +--
 s390x/snippets/c/cstart.S | 16 +++++++++++++++-
 s390x/snippets/c/flat.lds |  2 ++
 s390x/sthyi.c             | 20 +++++++++++---------
 s390x/uv-guest.c          |  4 +++-
 s390x/uv-host.c           | 19 ++++++++++++-------
 10 files changed, 76 insertions(+), 33 deletions(-)

-- 
2.30.2

