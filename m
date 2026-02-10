Return-Path: <kvm+bounces-70730-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UL9lEhdQi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70730-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:34:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 618E011C818
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:34:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7DA0F300E4A4
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:34:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9464D3806CA;
	Tue, 10 Feb 2026 15:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="i04IeQcP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC312E2EF9;
	Tue, 10 Feb 2026 15:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737668; cv=none; b=NoxCeQY04Vi850XvOJWCD/RiUkq9/di6rqOV/TMWPwisH8vhrvmZKb5S11CDwTqz1ucOwLAjcDQYJmgp+M00nCbAtEDzPYZoHiQMjxgn0YIZjU7QwrunHJHx5rgfpn5mo40tEucoqS5TayxB3Kt55y75lccwsQBXTDZSB1LiWtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737668; c=relaxed/simple;
	bh=EMviT+WYQIwXAUgQ0YywqH1JYNXKOvoLHu9f1Z9ip1A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VK0B7M0nse2ndB7Ouy0ZNI331ATQitXaEuIlcUXIdTriNN2kMwjcM95YT4wSJh4jfkVVSQVNFIfXKahGsb7uR24BVNee8hXYn0iJax0vzL4u0DXvo6Idy1EEDVG1eFKtt9DU83qG/OJUdieULiHOl/lBjWllvLtWhdtMvC/gNcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=i04IeQcP; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61ABHxJX220316;
	Tue, 10 Feb 2026 15:34:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=cs7aCMljptkjCcpU/IFRRfmTicDzMdrn89ic24HUW
	a0=; b=i04IeQcPLdYpPybKTau13pymlFpURZRPYcHMNljSZmMIDV2Tliy+B7Iyz
	TzR1ruY+26iLZwFgCgcpRAyEFpFoMZIEpX3A8sMjE+qhQM6a0NDskW4j+QIqNRVl
	XvtiH7Mu5aE/BVbB4NUyoRTPR71VSb4U1R7p7VJmb33O+OMs4/SbCHBwfekSX/Kw
	UX3JXzJPHFtk0Sp2KfuuCOeIjgvzwe9kL858ZMwPF+WQ0WdljgTR7BbRnQLn0sIb
	2WAY4a2dEQ97MAnxxIu+kX6NSWYhQdHBVFtdDkEN098/UzY1p5CEESNfDBp/Owu6
	deJyuQOnrCmPqebjxJ5LY71k9Z2kA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696ucyb4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:23 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AEbFaP001499;
	Tue, 10 Feb 2026 15:34:22 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6gqn1ven-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:22 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYIIW19333446
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:18 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EC0F42004D;
	Tue, 10 Feb 2026 15:34:17 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A1122004B;
	Tue, 10 Feb 2026 15:34:17 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:17 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 00/36] KVM/s390: Three small patches, and a huge series
Date: Tue, 10 Feb 2026 16:33:41 +0100
Message-ID: <20260210153417.77403-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=KZnfcAYD c=1 sm=1 tr=0 ts=698b4fff cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=TBH9b2Q15OCi6qkdPXcA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfXyAoruUZ3NbMb
 hSGSQFuZVAINgy7hqN+Y1xA1Zk1cgR1vpPKVdAIoCLRJAqeZfnqdtuZYpE8QZBSbeaz28cSojrU
 ANSQEiH36gi0bqwr8bd5YK8xCBD0UhQS6iO+RS+szroP1TPRP1RscvUd/rbpba4Kd9n8GVKVvre
 BAxlc7PILg1/tk+xpNLf8WAgIDsTAY6gKnt+DJ83UjViWBJXWatSMN2PAPuJKz0++VAHct25O3b
 SDFStopeU3N1wDKkUn4lZU63DWNzWnS3yR/6OixeD2HeNWWIBn5TbN2NIRCLvJ8xE0YJX7kQy/7
 f59BOaRFXLEA0YTOwrLFHIPu80/LiQ29HKAR1saKTmtxZGZWLXALdITc6xzJdTNUvIWRUFWsOlb
 ebOwo72c9+HPu8B/AlT/Vq5uwkaeeo9Cmt/4amnKJxX5pif+3JQ/zwkr4LaSHFYDURwyWaq7vM6
 cbveAy9fYENEGMDFHHw==
X-Proofpoint-ORIG-GUID: 53D5qIqjtfqOELPsfTW7n1GAxsn6hiDC
X-Proofpoint-GUID: 53D5qIqjtfqOELPsfTW7n1GAxsn6hiDC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602100128
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70730-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 618E011C818
X-Rspamd-Action: no action

Ciao Paolo, 

Today's pull request is rather large, as it (finally!) contains the gmap
rewrite.

It also contains 3 small items:
* vSIE performance improvement
* maintainership update for s390 vfio-pci
* small (but important) quality of life improvement for protected guests


The following changes since commit 9448598b22c50c8a5bb77a9103e2d49f134c9578:

  Linux 6.19-rc2 (2025-12-21 15:52:04 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-7.0-1

for you to fetch changes up to e3372ffb5f9e2dda3da259b768aab6271672b90d:

  KVM: s390: Increase permitted SE header size to 1 MiB (2026-02-10 12:21:30 +0100)

----------------------------------------------------------------
- gmap rewrite: completely new memory management for kvm/s390
- vSIE improvement
- maintainership change for s390 vfio-pci
- small quality of life improvement for protected guests

----------------------------------------------------------------
Arnd Bergmann (1):
      KVM: s390: Add explicit padding to struct kvm_s390_keyop

Claudio Imbrenda (32):
      KVM: s390: Refactor pgste lock and unlock functions
      KVM: s390: Add P bit in table entry bitfields, move union vaddress
      s390: Make UV folio operations work on whole folio
      s390: Move sske_frame() to a header
      KVM: s390: Add gmap_helper_set_unused()
      KVM: s390: Introduce import_lock
      KVM: s390: Export two functions
      s390/mm: Warn if uv_convert_from_secure_pte() fails
      KVM: s390: vsie: Pass gmap explicitly as parameter
      KVM: s390: Enable KVM_GENERIC_MMU_NOTIFIER
      KVM: s390: Rename some functions in gaccess.c
      KVM: s390: KVM-specific bitfields and helper functions
      KVM: s390: KVM page table management functions: allocation
      KVM: s390: KVM page table management functions: clear and replace
      KVM: s390: KVM page table management functions: walks
      KVM: s390: KVM page table management functions: storage keys
      KVM: s390: KVM page table management functions: lifecycle management
      KVM: s390: KVM page table management functions: CMMA
      KVM: s390: New gmap code
      KVM: s390: Add helper functions for fault handling
      KVM: s390: Add some helper functions needed for vSIE
      KVM: s390: Stop using CONFIG_PGSTE
      KVM: s390: Storage key functions refactoring
      KVM: s390: Switch to new gmap
      KVM: s390: Remove gmap from s390/mm
      KVM: S390: Remove PGSTE code from linux/s390 mm
      KVM: s390: Enable 1M pages for gmap
      KVM: s390: Storage key manipulation IOCTL
      KVM: s390: selftests: Add selftest for the KVM_S390_KEYOP ioctl
      KVM: s390: Use guest address to mark guest page dirty
      KVM: s390: vsie: Fix race in walk_guest_tables()
      KVM: s390: vsie: Fix race in acquire_gmap_shadow()

Eric Farman (2):
      KVM: s390: vsie: retry SIE when unable to get vsie_page
      MAINTAINERS: Replace backup for s390 vfio-pci

Steffen Eiden (1):
      KVM: s390: Increase permitted SE header size to 1 MiB

 Documentation/virt/kvm/api.rst           |   42 +
 MAINTAINERS                              |    5 +-
 arch/s390/Kconfig                        |    3 -
 arch/s390/include/asm/dat-bits.h         |   32 +-
 arch/s390/include/asm/gmap.h             |  174 ---
 arch/s390/include/asm/gmap_helpers.h     |    1 +
 arch/s390/include/asm/hugetlb.h          |    6 -
 arch/s390/include/asm/kvm_host.h         |    7 +
 arch/s390/include/asm/mmu.h              |   13 -
 arch/s390/include/asm/mmu_context.h      |    6 +-
 arch/s390/include/asm/page.h             |    4 -
 arch/s390/include/asm/pgalloc.h          |    4 -
 arch/s390/include/asm/pgtable.h          |  171 +--
 arch/s390/include/asm/tlb.h              |    3 -
 arch/s390/include/asm/uaccess.h          |   70 +-
 arch/s390/include/asm/uv.h               |    3 +-
 arch/s390/kernel/uv.c                    |  142 +-
 arch/s390/kvm/Kconfig                    |    2 +
 arch/s390/kvm/Makefile                   |    3 +-
 arch/s390/kvm/dat.c                      | 1391 +++++++++++++++++
 arch/s390/kvm/dat.h                      |  970 ++++++++++++
 arch/s390/kvm/diag.c                     |    2 +-
 arch/s390/kvm/faultin.c                  |  148 ++
 arch/s390/kvm/faultin.h                  |   92 ++
 arch/s390/kvm/gaccess.c                  |  961 +++++++-----
 arch/s390/kvm/gaccess.h                  |   20 +-
 arch/s390/kvm/gmap-vsie.c                |  141 --
 arch/s390/kvm/gmap.c                     | 1244 +++++++++++++++
 arch/s390/kvm/gmap.h                     |  244 +++
 arch/s390/kvm/intercept.c                |   15 +-
 arch/s390/kvm/interrupt.c                |   12 +-
 arch/s390/kvm/kvm-s390.c                 |  958 +++++-------
 arch/s390/kvm/kvm-s390.h                 |   27 +-
 arch/s390/kvm/priv.c                     |  213 +--
 arch/s390/kvm/pv.c                       |  177 ++-
 arch/s390/kvm/vsie.c                     |  202 +--
 arch/s390/lib/uaccess.c                  |  184 +--
 arch/s390/mm/Makefile                    |    1 -
 arch/s390/mm/fault.c                     |    4 +-
 arch/s390/mm/gmap.c                      | 2436 ------------------------------
 arch/s390/mm/gmap_helpers.c              |   96 +-
 arch/s390/mm/hugetlbpage.c               |   24 -
 arch/s390/mm/page-states.c               |    1 +
 arch/s390/mm/pageattr.c                  |    7 -
 arch/s390/mm/pgalloc.c                   |   24 -
 arch/s390/mm/pgtable.c                   |  814 +---------
 include/linux/kvm_host.h                 |    2 +
 include/uapi/linux/kvm.h                 |   12 +
 mm/khugepaged.c                          |    9 -
 tools/testing/selftests/kvm/Makefile.kvm |    1 +
 tools/testing/selftests/kvm/s390/keyop.c |  299 ++++
 51 files changed, 5920 insertions(+), 5502 deletions(-)
 delete mode 100644 arch/s390/include/asm/gmap.h
 create mode 100644 arch/s390/kvm/dat.c
 create mode 100644 arch/s390/kvm/dat.h
 create mode 100644 arch/s390/kvm/faultin.c
 create mode 100644 arch/s390/kvm/faultin.h
 delete mode 100644 arch/s390/kvm/gmap-vsie.c
 create mode 100644 arch/s390/kvm/gmap.c
 create mode 100644 arch/s390/kvm/gmap.h
 delete mode 100644 arch/s390/mm/gmap.c
 create mode 100644 tools/testing/selftests/kvm/s390/keyop.c

