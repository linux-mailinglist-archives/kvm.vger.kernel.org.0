Return-Path: <kvm+bounces-31151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BB739C0E61
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 20:08:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACF471C21289
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 19:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E8F817BD6;
	Thu,  7 Nov 2024 19:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JqA801Ly"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7272E366
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 19:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731006497; cv=none; b=BebWSn6qSWu3rFp+G4/WbKCW6pEj++QXMM7kVqauJlbo8v0WV4OxBGG+YQ3qOQ4Y7smUNe7QYhOK5fPitmXk2+Ah/zHkr8GpPDM12LTnY8Nzd5cxD+Sc+NMRZ6ooFcL+Xv2Yy2JX3JhQWpbYyGNPO4Ib57HhAYgDje+M8Y+MvMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731006497; c=relaxed/simple;
	bh=KKlJt26DlBOl+oq4QbshDZTvQ0/YvhN59kXYaeOs3wI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kDZSCClozJyyU6i/tDVRC7qG/yeopf4q99/Eg5gwFIDBqWhy3p0ibyYc1ZR37y4ZO9zvNl8MZdgOHug39zp5rhsw5lim9od86XJEcmWMMPVbInosXRxJFv5cFlxJg7oxcSsuAb0RwzmjWfoJj5nRrTM4fB2+YJje984rEp+NXX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JqA801Ly; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 7 Nov 2024 11:08:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731006493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iVhaxqbRLOqWKRQjW0eS97SPLltjxLKNHVobfquR6RU=;
	b=JqA801LyALBLnpPRGUUDsee91B6Lop7Cv0Ok+XE0bFkk5177I+Y1/aT7OHrwbexlpFXv3+
	c/kDKtsXwmpnWuXUTv1kigZW0sneesxFjVgOmx6F7s3T1uSfytTU+X0HEMxzJWk1pXclX+
	mjuEF22ox+PporqaDecNBOVzczIcSTE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
	broonie@kernel.org, maz@kernel.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, joey.gouly@arm.com, shuah@kernel.org,
	pbonzini@redhat.com
Subject: Re: [PATCH  2/3] KVM: selftests: Introduce kvm_vm_dead_free
Message-ID: <Zy0QFhFsICeNt8kF@linux.dev>
References: <20241107094000.70705-1-eric.auger@redhat.com>
 <20241107094000.70705-3-eric.auger@redhat.com>
 <Zyz_KGtoXt0gnMM8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zyz_KGtoXt0gnMM8@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 07, 2024 at 09:55:52AM -0800, Sean Christopherson wrote:
> On Thu, Nov 07, 2024, Eric Auger wrote:
> > In case a KVM_REQ_VM_DEAD request was sent to a VM, subsequent
> > KVM ioctls will fail and cause test failure. This now happens
> > with an aarch64 vgic test where the kvm_vm_free() fails. Let's
> > add a new kvm_vm_dead_free() helper that does all the deallocation
> > besides the KVM_SET_USER_MEMORY_REGION2 ioctl.
> 
> Please no.  I don't want to bleed the kvm->vm_dead behavior all over selftests.
> The hack in __TEST_ASSERT_VM_VCPU_IOCTL() is there purely to provide users with
> a more helpful error message, it is most definitely not intended to be an "official"
> way to detect and react to the VM being dead.
> 
> IMO, tests that intentionally result in a dead VM should assert that subsequent
> VM/vCPU ioctls return -EIO, and that's all.  Attempting to gracefully free
> resources adds complexity and pollutes the core selftests APIs, with very little
> benefit.

Encouraging tests to explicitly leak resources to fudge around assertions
in the selftests library seems off to me.

IMO, the better approach would be to provide a helper that gives the
impression of freeing the VM but implicitly leaks it, paired with some
reasoning for it.

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index bc7c242480d6..75ad05c3c429 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -426,6 +426,7 @@ void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size);
 const char *vm_guest_mode_string(uint32_t i);
 
 void kvm_vm_free(struct kvm_vm *vmp);
+void __kvm_vm_free_dead(struct kvm_vm *vmp);
 void kvm_vm_restart(struct kvm_vm *vmp);
 void kvm_vm_release(struct kvm_vm *vmp);
 void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a2b7df5f1d39..34ed397d7811 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -771,6 +771,21 @@ void kvm_vm_free(struct kvm_vm *vmp)
 	free(vmp);
 }
 
+/*
+ * For use with the *extremely* uncommon case that a test expects a VM to be
+ * marked as dead.
+ *
+ * Deliberately leak the VM to avoid hacking up kvm_vm_free() to cope with a
+ * dead VM while giving the outward impression of 'doing the right thing'.
+ */
+void __kvm_vm_dead_free(struct kvm_vm *vmp)
+{
+	if (!vmp)
+		return;
+
+	TEST_ASSERT(vm_dead(vmp));
+}
+
 int kvm_memfd_alloc(size_t size, bool hugepages)
 {
 	int memfd_flags = MFD_CLOEXEC;

> Marking a VM dead should be a _very_ rare event; it's not something that I think
> we should encourage, i.e. we shouldn't make it easier to deal with.  Ideally,
> use of kvm_vm_dead() should be limited to things like sev_vm_move_enc_context_from(),
> where KVM needs to prever accessing the source VM to protect the host.  IMO, the
> vGIC case and x86's enter_smm() are hacks.  E.g. I don't see any reason why the
> enter_smm() case can't synthesize a triple fault.

The VGIC case is at least better than the alternative of slapping
bandaids all over the shop to cope with a half-baked VM and ensure we
tear it down correctly. Userspace is far up shit creek at the point the
VM is marked as dead, so I don't see any value in hobbling along
afterwards.

-- 
Thanks,
Oliver

