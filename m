Return-Path: <kvm+bounces-21904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 37425937125
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 01:38:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 937D028215C
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEBF3146A8B;
	Thu, 18 Jul 2024 23:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aFPQNVUD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4451DA3D;
	Thu, 18 Jul 2024 23:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721345897; cv=none; b=MIgmVJKag8kqFZ1eLi8keTs3COuSSqWeK5mBLtG7hWgxbXRNp8D6YKR8ll3hVS2YwnOms5OERTJbWH+qbOzKbldmIOGgpeSB2UxK3VQmUiHqSuk33XHzOS8aiQ+Y7XPC4Gn8QEkDMwNXvGipHSOe32WEj0nN+hIA4Wc5j6FC+YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721345897; c=relaxed/simple;
	bh=SnF/sqnMhawiwKc6pgw+HwJ9UgCa3hHdfLptVNdyx/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FdGsUxrjJj7J6jnNJ5TNrWPBzNBDrXPkg82g1oUo5CImGRTubJkki2VTYEg4azdviT+MKoU6lJjgIfGOAFAlu2biPZ23SvyjfJaGS4tQCr0HxcJgLddE5J8hPjNIcOgG7gKFOXBIlwf5uZb3xjqqyzEF2NAa9qD3BmUvc3Sls7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aFPQNVUD; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721345895; x=1752881895;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SnF/sqnMhawiwKc6pgw+HwJ9UgCa3hHdfLptVNdyx/8=;
  b=aFPQNVUDG28y2G+P4VctBYUo2r6yRphH/ShQhG3AtnoKLt/Yp5Jkq1zw
   Fvw5y1tD/Mjjii8GemJCOpTfX2G3BI2Itt/W++XxprG3ms8tm2xfTmMzP
   1Szi8e/ujIv2AZse5h0hV2NC0MECOf4afyoY1gmIIt51RAcTKRv3u1nmx
   rYBQXv7XeeymXe3XJ+fC+LNmGv76PwbqlXKGToHN39m1LGL2JGzopwsqv
   4XaIMx4+5PqkXM8600nsMhalOySISx0sC0Fi8oTX61f/FaM4XtqquD+0z
   QzN7g25A+zQzby9yzqAjOe+AYwUOSKT3xYPR66IS9x56tsgyUCcm6PIhn
   w==;
X-CSE-ConnectionGUID: Mnr2f0vIRbeQetkNbxiLJQ==
X-CSE-MsgGUID: 2q8QwE6nQdCNpnfB8hoT3g==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="41470160"
X-IronPort-AV: E=Sophos;i="6.09,219,1716274800"; 
   d="scan'208";a="41470160"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 16:38:14 -0700
X-CSE-ConnectionGUID: 98E+IcsgSZKeSNp2mceL9w==
X-CSE-MsgGUID: ukVhfiJ9RCu/4V1iUeXyTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,219,1716274800"; 
   d="scan'208";a="50900124"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 16:38:15 -0700
Date: Thu, 18 Jul 2024 16:38:13 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH] KVM: x86: Add GPA limit check to
 kvm_arch_vcpu_pre_fault_memory()
Message-ID: <ZpmnZZrh21e9sjLU@ls.amr.corp.intel.com>
References: <f2a46971d37ee3bf32ff33dc730e16bf0f755410.1721091397.git.isaku.yamahata@intel.com>
 <ZpbVVyp3YvCJp3Am@google.com>
 <20240716234900.GF1900928@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240716234900.GF1900928@ls.amr.corp.intel.com>

On Tue, Jul 16, 2024 at 04:49:00PM -0700,
Isaku Yamahata <isaku.yamahata@intel.com> wrote:

> > > - For non-TDX case (DEFAULT_VM, SW_PROTECTED_VM, or SEV):
> > >   When the host supports 5-level TDP, KVM decides to use 4-level TDP if
> > >   cpuid_maxphyaddr() <= 48.  cpuid_maxhyaddr() check prevents
> > >   KVM_PRE_FAULT_MEMORY from passing GFN beyond mappable GFN.
> > 
> > Hardening against cpuid_maxphyaddr() should be out of scope.  We don't enforce
> > it for guest faults, e.g. KVM doesn't kill the guest if allow_smaller_maxphyaddr
> > is false and the GPA is supposed to be illegal.  And trying to enforce it here is
> > a fool's errand since userspace can simply do KVM_SET_CPUID2 to circumvent the
> > restriction.
> 
> Ok, I'll drop maxphys addr check.

Now Rick added a patch to check aliased GFN.  This patch and per-VM mmu_max_gfn
become unnecessarily.  Now I come up with update to pre_fault to test no
memslot case.
https://lore.kernel.org/kvm/20240718211230.1492011-19-rick.p.edgecombe@intel.com/

For non-x86 case, I'm not sure if we can expect what error.


From d62fc5170b17788041d364e6a17f97f01be4130e Mon Sep 17 00:00:00 2001
Message-ID: <d62fc5170b17788041d364e6a17f97f01be4130e.1721345479.git.isaku.yamahata@intel.com>
From: Isaku Yamahata <isaku.yamahata@intel.com>
Date: Wed, 29 May 2024 12:13:20 -0700
Subject: [PATCH] KVM: selftests: Update pre_fault_memory_test.c to test no
 memslot case

Add test cases to pass GPA to get ENOENT where no memslot is assigned.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
This tests passes for kvm queue branch, also with KVM TDX branch.
---
 .../selftests/kvm/pre_fault_memory_test.c     | 37 ++++++++++++++-----
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index 0350a8896a2f..8d057a0bc6fd 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -30,8 +30,8 @@ static void guest_code(uint64_t base_gpa)
 	GUEST_DONE();
 }
 
-static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 gpa, u64 size,
-			     u64 left)
+static void __pre_fault_memory(struct kvm_vcpu *vcpu, u64 gpa, u64 size,
+			       u64 left, int *ret, int *save_errno)
 {
 	struct kvm_pre_fault_memory range = {
 		.gpa = gpa,
@@ -39,21 +39,28 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 gpa, u64 size,
 		.flags = 0,
 	};
 	u64 prev;
-	int ret, save_errno;
 
 	do {
 		prev = range.size;
-		ret = __vcpu_ioctl(vcpu, KVM_PRE_FAULT_MEMORY, &range);
-		save_errno = errno;
-		TEST_ASSERT((range.size < prev) ^ (ret < 0),
+		*ret = __vcpu_ioctl(vcpu, KVM_PRE_FAULT_MEMORY, &range);
+		*save_errno = errno;
+		TEST_ASSERT((range.size < prev) ^ (*ret < 0),
 			    "%sexpecting range.size to change on %s",
-			    ret < 0 ? "not " : "",
-			    ret < 0 ? "failure" : "success");
-	} while (ret >= 0 ? range.size : save_errno == EINTR);
+			    *ret < 0 ? "not " : "",
+			    *ret < 0 ? "failure" : "success");
+	} while (*ret >= 0 ? range.size : *save_errno == EINTR);
 
 	TEST_ASSERT(range.size == left,
 		    "Completed with %lld bytes left, expected %" PRId64,
 		    range.size, left);
+}
+
+static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 gpa, u64 size,
+			     u64 left)
+{
+	int ret, save_errno;
+
+	__pre_fault_memory(vcpu, gpa, size, left, &ret, &save_errno);
 
 	if (left == 0)
 		__TEST_ASSERT_VM_VCPU_IOCTL(!ret, "KVM_PRE_FAULT_MEMORY", ret, vcpu->vm);
@@ -77,6 +84,7 @@ static void __test_pre_fault_memory(unsigned long vm_type, bool private)
 	uint64_t guest_test_phys_mem;
 	uint64_t guest_test_virt_mem;
 	uint64_t alignment, guest_page_size;
+	int ret, save_errno;
 
 	vm = vm_create_shape_with_one_vcpu(shape, &vcpu, guest_code);
 
@@ -101,6 +109,17 @@ static void __test_pre_fault_memory(unsigned long vm_type, bool private)
 	pre_fault_memory(vcpu, guest_test_phys_mem + SZ_2M, PAGE_SIZE * 2, PAGE_SIZE);
 	pre_fault_memory(vcpu, guest_test_phys_mem + TEST_SIZE, PAGE_SIZE, PAGE_SIZE);
 
+#ifdef __x86_64__
+	__pre_fault_memory(vcpu, guest_test_phy_mem - guest_page_size,
+			   guest_page_size, guest_page_size, &ret, &save_errno);
+	__TEST_ASSERT_VM_VCPU_IOCTL(ret && save_errno == ENOENT,
+				    "KVM_PRE_FAULT_MEMORY", ret, vcpu->vm);
+	__pre_fault_memory(vcpu, (vm->max_gfn + 1) << vm->page_shift,
+			   guest_page_size, guest_page_size, &ret, &save_errno);
+	__TEST_ASSERT_VM_VCPU_IOCTL(ret && save_errno == ENOENT,
+				    "KVM_PRE_FAULT_MEMORY", ret, vcpu->vm);
+#endif
+
 	vcpu_args_set(vcpu, 1, guest_test_virt_mem);
 	vcpu_run(vcpu);
 

base-commit: c8b8b8190a80b591aa73c27c70a668799f8db547
-- 
2.45.2



-- 
Isaku Yamahata <isaku.yamahata@intel.com>

