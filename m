Return-Path: <kvm+bounces-874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B47AF7E3DE2
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 13:31:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B609281078
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 12:31:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F3FE30CE4;
	Tue,  7 Nov 2023 12:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZkCYtm3M"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130B92FE38
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 12:31:29 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C55E7D96;
	Tue,  7 Nov 2023 04:31:26 -0800 (PST)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7BRhND017238;
	Tue, 7 Nov 2023 12:31:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=5EiULUsxjUipTZz+Oru/qxPfC/GESTOX18GxKi2oKFA=;
 b=ZkCYtm3Md8hWjsYoWT/ZAynKH3CBvATEyhlUh4VePjJVXd4O6ItG88AThpMPOSMNLprR
 33wKyiNDlEpCTlCkiTGSfYNSGBqX5h1hIvdPHwv3Vj91UsF4Bh3p3Z24ycZq/6FXpZb1
 tczAp2/xaA3OBcvccK7unSgYXk9SHp6x1EdV2Kuwafpe7hgBAUY3dsZLaqA+fFtOB5wY
 4YgSq9MPG6qyWe1l2HdLSlh60SnEtZb6gjaG4bWb5ux1ucYiABGAxY1amf/Yl4Scf5fw
 IOS+r8RcIPCcROe/3OvRXA92Q7va7xU1pXQpGHxU17czAG29Hj2rKXWRioRGP1JRf8li pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u7mck1pa0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 12:31:26 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A7CBgB0018571;
	Tue, 7 Nov 2023 12:31:25 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u7mck1p9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 12:31:25 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7BuQYn016964;
	Tue, 7 Nov 2023 12:31:24 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u6301qy5w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 12:31:24 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A7CVLqQ22479522
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Nov 2023 12:31:22 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C67EF20043;
	Tue,  7 Nov 2023 12:31:21 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 681AF20040;
	Tue,  7 Nov 2023 12:31:21 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 Nov 2023 12:31:21 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Cc: kvm@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v2 0/4] KVM: s390: Fix minor bugs in STFLE shadowing
Date: Tue,  7 Nov 2023 13:31:14 +0100
Message-Id: <20231107123118.778364-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XfCGbxIhiP0ALGB2V9JmlUys1f7Nuzpk
X-Proofpoint-ORIG-GUID: DI-UtI7qZ2kqTnXslzNdTXrouzSuLwf3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-07_02,2023-11-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 suspectscore=0 phishscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070103

v1 -> v2 (range-diff below):
 * pick up tags (thanks {Claudio, David})
 * drop Fixes tag on cleanup patch, change message (thanks David)
 * drop Fixes tag on second patch since the length of the facility list
   copied wasn't initially specified and only clarified in later
   revisions
 * use READ/WRITE_ONCE (thanks {David, Heiko})

Improve the STFLE vsie implementation.
Firstly, fix a bug concerning the identification if the guest is
intending to use interpretive execution for STFLE for its guest.
Secondly, decrease the amount of guest memory accessed to the
minimum.
Also do some (optional) cleanups.

Nina Schoetterl-Glausch (4):
  KVM: s390: vsie: Fix STFLE interpretive execution identification
  KVM: s390: vsie: Fix length of facility list shadowed
  KVM: s390: cpu model: Use proper define for facility mask size
  KVM: s390: Minor refactor of base/ext facility lists

 arch/s390/include/asm/facility.h |  6 +++++
 arch/s390/include/asm/kvm_host.h |  2 +-
 arch/s390/kernel/Makefile        |  2 +-
 arch/s390/kernel/facility.c      | 21 +++++++++++++++
 arch/s390/kvm/kvm-s390.c         | 44 ++++++++++++++------------------
 arch/s390/kvm/vsie.c             | 15 +++++++++--
 6 files changed, 61 insertions(+), 29 deletions(-)
 create mode 100644 arch/s390/kernel/facility.c

Range-diff against v1:
1:  cffe5f1c29d1 ! 1:  de77a2c36786 KVM: s390: vsie: Fix STFLE interpretive execution identification
    @@ Commit message
         Perform the check before applying the address mask instead of after.
     
         Fixes: 66b630d5b7f2 ("KVM: s390: vsie: support STFLE interpretation")
    +    Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
    +    Acked-by: David Hildenbrand <david@redhat.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## arch/s390/kvm/vsie.c ##
2:  8ef9965c4671 ! 2:  f3b189627e96 KVM: s390: vsie: Fix length of facility list shadowed
    @@ Commit message
         The memory following the facility list need not be accessible, in which
         case we'd wrongly inject a validity intercept.
     
    -    Fixes: 66b630d5b7f2 ("KVM: s390: vsie: support STFLE interpretation")
    +    Acked-by: David Hildenbrand <david@redhat.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## arch/s390/include/asm/facility.h ##
    @@ arch/s390/kernel/facility.c (new)
     +
     +unsigned int stfle_size(void)
     +{
    -+	static unsigned int size = 0;
    ++	static unsigned int size;
     +	u64 dummy;
    ++	unsigned int r;
     +
    -+	if (!size) {
    -+		size = __stfle_asm(&dummy, 1) + 1;
    ++	r = READ_ONCE(size);
    ++	if (!r) {
    ++		r = __stfle_asm(&dummy, 1) + 1;
    ++		WRITE_ONCE(size, r);
     +	}
    -+	return size;
    ++	return r;
     +}
     +EXPORT_SYMBOL(stfle_size);
     
3:  4104a7c218f1 ! 3:  4907bb8fb2bc KVM: s390: cpu model: Use previously unused constant
    @@ Metadata
     Author: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## Commit message ##
    -    KVM: s390: cpu model: Use previously unused constant
    +    KVM: s390: cpu model: Use proper define for facility mask size
     
    -    No point in defining a size for the mask if we're not going to use it.
    +    Use the previously unused S390_ARCH_FAC_MASK_SIZE_U64 instead of
    +    S390_ARCH_FAC_LIST_SIZE_U64 for defining the fac_mask array.
    +    Note that both values are the same, there is no functional change.
     
    -    Fixes: 9d8d578605b4 ("KVM: s390: use facilities and cpu_id per KVM")
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## arch/s390/include/asm/kvm_host.h ##
4:  b6a18de5a089 = 4:  2745898a22c3 KVM: s390: Minor refactor of base/ext facility lists

base-commit: 05d3ef8bba77c1b5f98d941d8b2d4aeab8118ef1
-- 
2.39.2


