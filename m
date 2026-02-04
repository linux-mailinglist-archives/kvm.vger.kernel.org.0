Return-Path: <kvm+bounces-70207-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0GIQIadgg2mJlQMAu9opvQ
	(envelope-from <kvm+bounces-70207-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:07:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E9E3EE7F18
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:07:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4D6C33062A8E
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 15:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 072E02D8771;
	Wed,  4 Feb 2026 15:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GfbatY/P"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C9B2BE7C6;
	Wed,  4 Feb 2026 15:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217388; cv=none; b=kIDjLzxDNPChmYZxGhrpKPoReYqxObdgJ1ulGDrbEh8MO75muEBIWljiY32ii9CIedOAC10Aqwv9PXbny2aIWa645G/rdMEHZPcAXvDR5LRn0853kvREBkRVQyu/nc0QyZQzp2reiVnens+JHRdVGCAH1qVy4WnVqOzfwMfe+RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217388; c=relaxed/simple;
	bh=XiJC+dgpeN0nkfz9rXcWIsTcC94PX6+Be7SR1bEWOqk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ULlej0L547TYLl+AjEWbiiM8i9fVa7n/gZxEo8kIPpVenrgO/QnDB9pyZ3VLFNREbcHySNUdTrZvt6T97IO9LYBwdyxnRChB/guTESZVvskqFW3iVkurucQeXHgQb/KflyLopjIlIYUZc4Tn98dTHW/wsPvobZLNIh5y242GHCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GfbatY/P; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 614EXS4i032144;
	Wed, 4 Feb 2026 15:03:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=ufdMq9iwyIpf0yWqmDgz1kPlXoBmi3QxlxbPo3bq7
	+U=; b=GfbatY/P4jNkHXsfSMbPNoNUeQy2ZSb/pnbwadSJIHhlR8jRLfeMhJxgt
	/fuoB76Aq2S6Guh/agxtXkDNMeuv/35TJj9xwd4T3O5nm6CzoJSSVt/NLRUukX9T
	xsBaOWegESA5Ls6jmfnLUeRHmPg+j1ts+5Av4xJV12pYpkrsUl28YTtVx8X7zbcX
	UWq8nWvtWotc/l1Twp9f119yAIPCtGWtrRIcmGDjdvr+EVNp6dSPW5LzCIs9zELs
	FH7jF0ZgCCBky1fSV23m0s6rCxMIZxiq6ep7AroKCaUsdRJ70BXf0zzcgLIYpO8T
	WdXZ3VlnCRA7EMdDsbzb9KNXtd+Fw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19dtad67-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:04 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 614D1fOY004411;
	Wed, 4 Feb 2026 15:03:03 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1wjjwk8c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:03 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 614F2xwT49873294
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Feb 2026 15:02:59 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8174320043;
	Wed,  4 Feb 2026 15:02:59 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3593C2004D;
	Wed,  4 Feb 2026 15:02:59 +0000 (GMT)
Received: from p-imbrenda.aag-de.ibm.com (unknown [9.52.223.175])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Feb 2026 15:02:59 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@kernel.org,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v7 00/29] KVM: s390: gmap rewrite, the real deal
Date: Wed,  4 Feb 2026 16:02:29 +0100
Message-ID: <20260204150259.60425-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDExMyBTYWx0ZWRfXxm+RJkB9E6rq
 wmjQEJkDJy8EqmznOASPWMATkZB75/loCCD4cQ8SQ8LKiRSgV+9EQHTJjnc4zPeJE/MNbzDr9cq
 blWTekoc6yX2KpOsXvd4oR7qKtntB+2h1gPl8qUUD5P7QoKEXv3YaLisvAuhxqhJr4zPV6o89IF
 z9kaAkjD0ROlP/WryOnaCyFGl28CM1LXknShy3hR1uGMoRa579LZ10cPFE8LYTUNV4wWr1ZdFni
 K5JmPU+T1H3BCmFfXOzGG4o8iBxPkkqiDuwDoZCnroOU4LP6rIx+9xDwO+eWXnoEXadvVdtNwit
 jO4kmzTF2PGLJ1MjH56KVSXrnBL6rL6Ik1HXV+G2Cpgita4yFI2NT6hgsrJ6+tcG35hLWfXH5DM
 Nv6KZdyhvliGHUpE9e3cnfpX3OTs4Zon7cRncbr5AD8HUR+mAOt8hKg8SWlEvGoXleuOtQ/Ch58
 VHYo4eL1IFRSk0bXflQ==
X-Proofpoint-GUID: yWpY_TRJrJmmdP9qtvxh6f1Ub1JZiEC0
X-Proofpoint-ORIG-GUID: yWpY_TRJrJmmdP9qtvxh6f1Ub1JZiEC0
X-Authority-Analysis: v=2.4 cv=LesxKzfi c=1 sm=1 tr=0 ts=69835fa8 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=s0Iii0BFI7l5Z9uEpy8A:9
 a=VKjadluECVzL0IhF:21
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_04,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 adultscore=0 suspectscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2602040113
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70207-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: E9E3EE7F18
X-Rspamd-Action: no action

This series is the last big series of the gmap rewrite. It introduces
the new code and actually uses it. The old code is then removed.

KVM on s390 will now use the mmu_notifier, like most other
architectures. The gmap address space is now completely separate from
userspace; no level of the page tables is shared between guest mapping
and userspace.

One of the biggest advantages is that the page size of userspace is
completely independent of the page size used by the guest. Userspace
can mix normal pages, THPs, hugetlbfs, and more.

It's now possible to have nested guests and guests with huge pages
running on the same host. In fact, it's possible to have a nested
guest on a guest with huge pages. Transparent hugepages are also
possible.

Patches 1 to 11 are mostly preparations; introducing some new bits and
functions, and moving code around.

Patches 12 to 21 are the meat of the new gmap code; page table management
functions and gmap management. This is the code that will be used to
manage guest memory.

Patch 24 is unfortunately big; the existing code is converted to use
the new gmap and all references to the old gmap are removed. This needs
to be done all at once, unfortunately, hence the size of the patch.

Patch 25 and 26 remove all the now unused code.

Patch 27 and 28 allow for 1M pages to be used to back guests, and add
some more functions that are useful for testing.

Patch 29 contains selftests for the storage key interface introduced in
the patch 28

v6->v7:
* Added selftests for the newly introduced KEYOP ioctl
* Fix the bugs found by the newly introduced selftests
* Fix a bug in the memslot removal code
* Fix a few bugs in vSIE shadowing/deshawoding code
* Fix deadlock between shadowing code and normal fault handling
* Added proper locking for memslot manipulation operations
* Added capability for the KEYOP ioctl, and API documentation
* Minor documentation fixes
* Fixed many style issues in comments
* Fixed regression with ucontrol VMs

v5->v6:
* Added a mutex to avoid races during import-like operations in
  protected guests
* The functions uv_convert_from_secure_folio() and uv_destroy_folio()
  now work on the whole folio, and not just its first page
* Added warnings if uv_convert_from_secure_pte() fails in ptep_*()
* Changed the way shadow gmaps do reference counting
* Use a bitmap for gmap flags, instead of individual bool variables
* Rework the make_secure logic to work on gmap only, and not on
  userspace addresses
* Some refactorings
* Rebased onto 6.19-rc2
* Added more comments
* Minor style fixes

v4->v5:
* fix some locking issues
* fix comments and documentation

v3->v4:
* dat_link() can now return -ENOMEM when appropriate
* fixed a few vSIE races that led to use-after-free or deadlocks
* split part of the previous patch 23 and move it after patch 17, merge
  the rest of the patch into patch 19
* fix -ENOMEM handling in handle_pfmf() and handle_sske()

v2->v3:
* Add lots of small comments and cosmetic fixes
* Rename some functions to improve clarity
* Remove unused helper functions and macros
* Rename inline asm constraints labels to make them more understandable
* Refactor the code to pre-allocate the page tables (using custom
  caches) when sleeping is allowed, use the cached pages when holding
  spinlocks and handle gracefully allocation failures (i.e. retry
  instead of killing the guest)
* Refactor the code for fault handling; it's now in a separate file,
  and it takes a callback that can be optionally called when all the
  relevant locks are still held
* Use assembler mnemonics instead of manually specifying the opcode
  where appropriate
* Remove the LEVEL_* enum, and use TABLE_TYPE_* macros instead;
  introduce new TABLE_TYPE_PAGE_TABLE
* Remove usage of cpu_has_idte() since it is being removed from the
  kernel
* Improve storage key handling and PGSTE locking
* Introduce struct guest_fault to represent the state of a guest fault
  that is being resolved
* Minor CMMA fixes


Claudio Imbrenda (29):
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

 Documentation/virt/kvm/api.rst           |   42 +
 MAINTAINERS                              |    2 -
 arch/s390/Kconfig                        |    3 -
 arch/s390/include/asm/dat-bits.h         |   32 +-
 arch/s390/include/asm/gmap.h             |  174 --
 arch/s390/include/asm/gmap_helpers.h     |    1 +
 arch/s390/include/asm/hugetlb.h          |    6 -
 arch/s390/include/asm/kvm_host.h         |    7 +
 arch/s390/include/asm/mmu.h              |   13 -
 arch/s390/include/asm/mmu_context.h      |    6 +-
 arch/s390/include/asm/page.h             |    4 -
 arch/s390/include/asm/pgalloc.h          |    4 -
 arch/s390/include/asm/pgtable.h          |  171 +-
 arch/s390/include/asm/tlb.h              |    3 -
 arch/s390/include/asm/uaccess.h          |   70 +-
 arch/s390/include/asm/uv.h               |    3 +-
 arch/s390/kernel/uv.c                    |  142 +-
 arch/s390/kvm/Kconfig                    |    2 +
 arch/s390/kvm/Makefile                   |    3 +-
 arch/s390/kvm/dat.c                      | 1391 ++++++++++++
 arch/s390/kvm/dat.h                      |  970 +++++++++
 arch/s390/kvm/diag.c                     |    2 +-
 arch/s390/kvm/faultin.c                  |  148 ++
 arch/s390/kvm/faultin.h                  |   92 +
 arch/s390/kvm/gaccess.c                  |  958 +++++----
 arch/s390/kvm/gaccess.h                  |   20 +-
 arch/s390/kvm/gmap-vsie.c                |  141 --
 arch/s390/kvm/gmap.c                     | 1235 +++++++++++
 arch/s390/kvm/gmap.h                     |  244 +++
 arch/s390/kvm/intercept.c                |   15 +-
 arch/s390/kvm/interrupt.c                |    6 +-
 arch/s390/kvm/kvm-s390.c                 |  954 ++++-----
 arch/s390/kvm/kvm-s390.h                 |   27 +-
 arch/s390/kvm/priv.c                     |  213 +-
 arch/s390/kvm/pv.c                       |  177 +-
 arch/s390/kvm/vsie.c                     |  192 +-
 arch/s390/lib/uaccess.c                  |  184 +-
 arch/s390/mm/Makefile                    |    1 -
 arch/s390/mm/fault.c                     |    4 +-
 arch/s390/mm/gmap.c                      | 2436 ----------------------
 arch/s390/mm/gmap_helpers.c              |   96 +-
 arch/s390/mm/hugetlbpage.c               |   24 -
 arch/s390/mm/page-states.c               |    1 +
 arch/s390/mm/pageattr.c                  |    7 -
 arch/s390/mm/pgalloc.c                   |   24 -
 arch/s390/mm/pgtable.c                   |  814 +-------
 include/uapi/linux/kvm.h                 |   11 +
 mm/khugepaged.c                          |    9 -
 tools/testing/selftests/kvm/Makefile.kvm |    1 +
 tools/testing/selftests/kvm/s390/keyop.c |  299 +++
 50 files changed, 5889 insertions(+), 5495 deletions(-)
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

-- 
2.52.0


