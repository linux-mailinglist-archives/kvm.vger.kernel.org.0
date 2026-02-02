Return-Path: <kvm+bounces-69915-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yBbCGJolgWnsEQMAu9opvQ
	(envelope-from <kvm+bounces-69915-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:30:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0222DD22AC
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:30:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1D8083035D44
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 708B9354AEE;
	Mon,  2 Feb 2026 22:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VhVKhscF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE82353ECE
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071426; cv=none; b=j+EqTk5T2T1TIISyut74FwqO66KdvVf6BYtqperXBcRQfPFXRVJZnvBBWRgbk3xiZCfwpnrMKMwelwKgdghH30aOIYjRVriBZu/FB7R8yBl8ivZ3uYkNd/251qWXY87409QXCprNzV139Q6tG2qFZJX64lL9wW52Ql13MGJ6NH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071426; c=relaxed/simple;
	bh=uSbCIOBOEf0Jbc1TJu+Uo31WNZmK8IMWR8LoTzKYbHI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=W9skwWbLFMKdKXh5VFqQykHQoH4o+j7RTDneYyAdO4VC2glgHbs/lWUBW4sLQ80NFrxAduygCbFfcuovjrjIeqaMjRO4X04GAVrz1lu0yDxu6VDpuybdZmLZJ0XU5TkSnIsBycjEXzdTQooGeKAhwr8icYJUp0L4tf2eGnjw4bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VhVKhscF; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34e70e2e363so5188123a91.1
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071423; x=1770676223; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zTHZdye+hOtZPjhoVi1/P3piDNtewPIJyZBVqqIicdA=;
        b=VhVKhscFBRcjyWXd4ZbEO+3iv3xVOA2HsrLH0awdshxYzlBSaU+NhELpUkGdjgtwUY
         ph/k+MNvzUErKehkZfVXZxNxOEcmpFL2+q/sw7pP3nTagIBAud6gqAaxQXD8+b+5lhR7
         K6Bu7mVwPvqS7t7aFzhIIryvHg9Nt8yOuM0o9ER+FIUbM65+hEISRIg1Dmkhzv3nowoV
         BkMVjz0Z9XIY4vylL0gSvJcYIMH2JbaPZXoSaR2nniBi9HswyiZpu2IPE231O47vG/0N
         Ij4H0QMMMiOzLVSmdHOoKlxapBL6hq773YDM0v9ZmoQb4uX25ELFGcgYU2Gjrv81LBMq
         3auw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071423; x=1770676223;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zTHZdye+hOtZPjhoVi1/P3piDNtewPIJyZBVqqIicdA=;
        b=fowSNWrfUs1Nw1o/7ZzFmMTL2SNveCiexVo74QaVVgYPJuUKRvK1zJX2BqG6Eicz2y
         r9gTl9i5fgwBby9N+P/08Xqfm52HctBmwXTa/9IwAH9MU7LFHA05+H+Zx+tEyZIiPxcV
         2fK3omXhS9X2qABVpH8YiMhIZ6kftBlW+hNB+/WUJtx7HA+LuuGwHCWWwXYJyV93ZsH8
         pGyU/CBIuk2BCWRG9X3N1KxBTcEAS0SxT8q6L+b/6juo3hqSsiw3iP16C55BwspjtkI5
         VFCvNU8gZtu0ojx2/vKikhoNXBdYOe73ELF6ngvnsdziTBh0k8lQc3TWYRqvy0I9FmZc
         iASQ==
X-Gm-Message-State: AOJu0Yyh8kl1FoYgK/KFiJdNqrLpZW4s/oosL/QpumYTLKJGdVl8JMSX
	KLr/Mcer01MgXEkmk7AniAxHTyHCSvl+ITP+DcTJK3GSImy41yyTJSE1UhGjzchJeYgGZW4nlLZ
	c21d6zzcNOPcJPx3R9FC183FdvaWCm+CsYjqGjeP49KaKjUKLrJVCNIuq9I9sYEq6BYEglxahMM
	b8xLxBUGzqWwoHAJLGbf0hUxukANrnKQmo/q66RJeFkIrtg4beo9qBbtO7+1Q=
X-Received: from pjbgn7.prod.google.com ([2002:a17:90a:c787:b0:349:8a6d:dfd1])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:6c3:b0:352:cd58:c8ce with SMTP id 98e67ed59e1d1-3543b3e4ba3mr11808970a91.32.1770071422709;
 Mon, 02 Feb 2026 14:30:22 -0800 (PST)
Date: Mon,  2 Feb 2026 14:29:38 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <cover.1769725905.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 00/37] guest_memfd: In-place conversion support
From: Ackerley Tng <ackerleytng@google.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	bp@alien8.de, brauner@kernel.org, chao.p.peng@intel.com, 
	chao.p.peng@linux.intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com, 
	ira.weiny@intel.com, jgg@nvidia.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, maobibo@loongson.cn, mathieu.desnoyers@efficios.com, 
	maz@kernel.org, mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, prsampat@amd.com, qperret@google.com, 
	ricarkol@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shivankg@amd.com, shuah@kernel.org, 
	steven.price@arm.com, tabba@google.com, tglx@linutronix.de, 
	vannapurve@google.com, vbabka@suse.cz, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-69915-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_GT_50(0.00)[51];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0222DD22AC
X-Rspamd-Action: no action

Here's a second revision of guest_memfd In-place conversion support.

In this version, other than addressing comments from RFCv1 [1], the largest
change is that guest_memfd now does not avoid participation in LRU; it
participates in LRU by joining the unevictable list (no change from before this
series).

While checking for elevated refcounts during shared to private conversions,
guest_memfd will now do an lru_add_drain_all() if elevated refcounts were found,
before concluding that there are true users of the shared folio and erroring
out.

I'd still like feedback on these points, if any:

1. Having private/shared status stored in a maple tree (Thanks Michael for your
   support of using maple trees over xarrays for performance! [5]).
2. Having a new guest_memfd ioctl (not a vm ioctl) that performs conversions.
3. Using ioctls/structs/input attribute similar to the existing vm ioctl
   KVM_SET_MEMORY_ATTRIBUTES to perform conversions.
4. Storing requested attributes directly in the maple tree.
5. Using a KVM module-wide param to toggle between setting memory attributes via
   vm and guest_memfd ioctls (making them mututally exclusive - a single loaded
   KVM module can only do one of the two.).

This series is based on kvm/next as at 2026-01-21, and here's the tree for your
convenience:

https://github.com/googleprodkernel/linux-cc/commits/guest_memfd-inplace-conversion-v2

The "Don't set FGP_ACCESSED when getting folios" patch from RFCv1 is still
useful but no longer related to conversion, and was posted separately [6].

Older series:

+ RFCv1 is at [1]
+ Previous versions of this feature, part of other series, are available at
  [2][3][4].

[1] https://lore.kernel.org/all/cover.1760731772.git.ackerleytng@google.com/T/
[2] https://lore.kernel.org/all/bd163de3118b626d1005aa88e71ef2fb72f0be0f.1726009989.git.ackerleytng@google.com/
[3] https://lore.kernel.org/all/20250117163001.2326672-6-tabba@google.com/
[4] https://lore.kernel.org/all/b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com/
[5] https://lore.kernel.org/all/20250529054227.hh2f4jmyqf6igd3i@amd.com/
[6] https://lore.kernel.org/all/20260129172646.2361462-1-ackerleytng@google.com/

Ackerley Tng (19):
  KVM: guest_memfd: Update kvm_gmem_populate() to use gmem attributes
  KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2
  KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
  KVM: guest_memfd: Handle lru_add fbatch refcounts during conversion
    safety check
  KVM: selftests: Update framework to use KVM_SET_MEMORY_ATTRIBUTES2
  KVM: selftests: Test using guest_memfd for guest private memory
  KVM: selftests: Test basic single-page conversion flow
  KVM: selftests: Test conversion flow when INIT_SHARED
  KVM: selftests: Test indexing in guest_memfd
  KVM: selftests: Test conversion before allocation
  KVM: selftests: Convert with allocated folios in different layouts
  KVM: selftests: Test precision of conversion
  KVM: selftests: Test that truncation does not change shared/private
    status
  KVM: selftests: Test conversion with elevated page refcount
  KVM: selftests: Reset shared memory after hole-punching
  KVM: selftests: Provide function to look up guest_memfd details from
    gpa
  KVM: selftests: Make TEST_EXPECT_SIGBUS thread-safe
  KVM: selftests: Update private_mem_conversions_test to mmap()
    guest_memfd
  KVM: selftests: Add script to exercise private_mem_conversions_test

Sean Christopherson (18):
  KVM: guest_memfd: Introduce per-gmem attributes, use to guard user
    mappings
  KVM: Rename KVM_GENERIC_MEMORY_ATTRIBUTES to KVM_VM_MEMORY_ATTRIBUTES
  KVM: Enumerate support for PRIVATE memory iff kvm_arch_has_private_mem
    is defined
  KVM: Stub in ability to disable per-VM memory attribute tracking
  KVM: guest_memfd: Wire up kvm_get_memory_attributes() to per-gmem
    attributes
  KVM: guest_memfd: Enable INIT_SHARED on guest_memfd for x86 Coco VMs
  KVM: Move KVM_VM_MEMORY_ATTRIBUTES config definition to x86
  KVM: Let userspace disable per-VM mem attributes, enable per-gmem
    attributes
  KVM: selftests: Create gmem fd before "regular" fd when adding memslot
  KVM: selftests: Rename guest_memfd{,_offset} to gmem_{fd,offset}
  KVM: selftests: Add support for mmap() on guest_memfd in core library
  KVM: selftests: Add selftests global for guest memory attributes
    capability
  KVM: selftests: Add helpers for calling ioctls on guest_memfd
  KVM: selftests: Test that shared/private status is consistent across
    processes
  KVM: selftests: Provide common function to set memory attributes
  KVM: selftests: Check fd/flags provided to mmap() when setting up
    memslot
  KVM: selftests: Update pre-fault test to work with per-guest_memfd
    attributes
  KVM: selftests: Update private memory exits test work with per-gmem
    attributes

 Documentation/virt/kvm/api.rst                |  72 ++-
 arch/x86/include/asm/kvm_host.h               |   2 +-
 arch/x86/kvm/Kconfig                          |  15 +-
 arch/x86/kvm/mmu/mmu.c                        |   4 +-
 arch/x86/kvm/x86.c                            |  13 +-
 include/linux/kvm_host.h                      |  53 +-
 include/trace/events/kvm.h                    |   4 +-
 include/uapi/linux/kvm.h                      |  17 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../kvm/guest_memfd_conversions_test.c        | 486 ++++++++++++++++++
 .../testing/selftests/kvm/guest_memfd_test.c  |  57 +-
 .../testing/selftests/kvm/include/kvm_util.h  | 128 ++++-
 .../testing/selftests/kvm/include/test_util.h |  31 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 130 +++--
 tools/testing/selftests/kvm/lib/test_util.c   |   7 -
 .../selftests/kvm/pre_fault_memory_test.c     |   2 +-
 .../kvm/x86/private_mem_conversions_test.c    |  48 +-
 .../kvm/x86/private_mem_conversions_test.py   | 152 ++++++
 .../kvm/x86/private_mem_kvm_exits_test.c      |  36 +-
 virt/kvm/Kconfig                              |   4 +-
 virt/kvm/guest_memfd.c                        | 399 +++++++++++++-
 virt/kvm/kvm_main.c                           | 104 +++-
 23 files changed, 1590 insertions(+), 176 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/guest_memfd_conversions_test.c
 create mode 100755 tools/testing/selftests/kvm/x86/private_mem_conversions_test.py

--
2.53.0.rc1.225.gd81095ad13-goog

