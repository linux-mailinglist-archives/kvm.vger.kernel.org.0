Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A614070C2
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 20:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhIJSFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 14:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhIJSFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 14:05:23 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9492CC061574
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 11:04:12 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id r4so5567748ybp.4
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 11:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FdiZIU18HRQNVcUBqI1gOpJDuHw72fPqFgD0vfSbxiM=;
        b=OftdWZEwD9jdXht+HSnlAwhydSymZg+fXMuExwKIPpWPSdPet2l673kSg8FcGtw/6d
         q/A8Jammz5TZedHA0AghaMGGChHtT4/kVWecAClUWj5q1tcoBkPQ91R8uZfezyXn1maC
         dYBLtWCRik7kgp43oQveNCvzkjyyNnCZtQRG8fAd0m1JyDBsgXnolXRZtTMW7Nd24Dm9
         /R+toReJ9Jkosf8Ny7n9oy64MKoI6hxdAt9vg8RHkQ6J5ZouUO23IUvUJGlNZsriSIUT
         y/mncKScphEyMFh6hYP3TjUIv7at+65xBbQO8YlIAu7cB6/3mLMu/squbAehr5XeI1qJ
         osVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FdiZIU18HRQNVcUBqI1gOpJDuHw72fPqFgD0vfSbxiM=;
        b=p41jP2rsoYPG1R/ShtCX2cWr9f64ybDzmYsghu8sQtw+kwKE1YvxVnuZ6zMEKTzeHN
         GP4GdfA0VZSavW5E0/rs+uOUkfbOlDy527SbRznwetJ0h4ulMcbjJf48ipcY4lHQU5uD
         U2u/mjAV6tC+05slEqztqhrKe+lMwkmofhlR80U17CUkTVSg6FuQxILMC24WHJr/qf07
         g2qz3LAaKSpn85GJRH7CAlHGadmEiau++DfBb3W0LuSfELenmuYcIX1DdCoVTOis+MZG
         LnJff0J12qf5P8IkLrPB9Rc6RdadqqNryccgydt1MaGvY2MIqmgXiC33dZLBvYy30h4l
         AElQ==
X-Gm-Message-State: AOAM5339BwcInnv/vAeUkxWMxunVuQDgbD1s9Xoi3r8Tpow+OXbHj+DY
        itW2VhWrUhDfLteZVnUFJQKuy8zZ0DU0c1iORjM7MA==
X-Google-Smtp-Source: ABdhPJzWgdNOv8FFFa8yER05OfPRQry5w0Mk8yQAnalMrVdKBP5XCEEVprWbGAlMxK82fvaBzfD7oAiOSSVboVdVasw=
X-Received: by 2002:a25:8093:: with SMTP id n19mr12994954ybk.414.1631297049652;
 Fri, 10 Sep 2021 11:04:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com> <20210909013818.1191270-10-rananta@google.com>
 <20210909075643.fhngqu6tqrpe33gl@gator> <CAJHc60wRkUyKEdY0ok0uC7r=P0FME+Lb7oapz+AKbjaNDhFHyA@mail.gmail.com>
 <20210910081001.4gljsvmcovvoylwt@gator>
In-Reply-To: <20210910081001.4gljsvmcovvoylwt@gator>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Fri, 10 Sep 2021 11:03:58 -0700
Message-ID: <CAJHc60yhg7oYiJpHJK27M7=qo0CMOX+Qj9+q-ZHgTVhWr_76aA@mail.gmail.com>
Subject: Re: [PATCH v4 09/18] KVM: arm64: selftests: Add guest support to get
 the vcpuid
To:     Andrew Jones <drjones@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 10, 2021 at 1:10 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Thu, Sep 09, 2021 at 10:10:56AM -0700, Raghavendra Rao Ananta wrote:
> > On Thu, Sep 9, 2021 at 12:56 AM Andrew Jones <drjones@redhat.com> wrote:
> > >
> > > On Thu, Sep 09, 2021 at 01:38:09AM +0000, Raghavendra Rao Ananta wrote:
> ...
> > > > +     for (i = 0; i < KVM_MAX_VCPUS; i++) {
> > > > +             vcpuid = vcpuid_map[i].vcpuid;
> > > > +             GUEST_ASSERT_1(vcpuid != VM_VCPUID_MAP_INVAL, mpidr);
> > >
> > > We don't want this assert if it's possible to have sparse maps, which
> > > it probably isn't ever going to be, but...
> > >
> > If you look at the way the array is arranged, the element with
> > VM_VCPUID_MAP_INVAL acts as a sentinel for us and all the proper
> > elements would lie before this. So, I don't think we'd have a sparse
> > array here.
>
> If we switch to my suggestion of adding map entries at vcpu-add time and
> removing them at vcpu-rm time, then the array may become sparse depending
> on the order of removals.
>
Oh, I get it now. But like you mentioned, we add entries to the map
while the vCPUs are getting added and then sync_global_to_guest()
later. This seems like a lot of maintainance, unless I'm interpreting
it wrong or not seeing an advantage.
I like your idea of coming up an arch-independent interface, however.
So I modified it similar to the familiar ucall interface that we have
and does everything in one shot to avoid any confusion:

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h
b/tools/testing/selftests/kvm/include/kvm_util.h
index 010b59b13917..0e87cb0c980b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -400,4 +400,24 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t
vcpu_id, struct ucall *uc);
 int vm_get_stats_fd(struct kvm_vm *vm);
 int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);

+#define VM_CPUID_MAP_INVAL -1
+
+struct vm_cpuid_map {
+       uint64_t hw_cpuid;
+       int vcpuid;
+};
+
+/*
+ * Create a vcpuid:hw_cpuid map and export it to the guest
+ *
+ * Input Args:
+ *   vm - KVM VM.
+ *
+ * Output Args: None
+ *
+ * Must be called after all the vCPUs are added to the VM
+ */
+void vm_cpuid_map_init(struct kvm_vm *vm);
+int guest_get_vcpuid(void);
+
 #endif /* SELFTEST_KVM_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c
b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index db64ee206064..e796bb3984a6 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -16,6 +16,8 @@

 static vm_vaddr_t exception_handlers;

+static struct vm_cpuid_map cpuid_map[KVM_MAX_VCPUS];
+
 static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
 {
        return (v + vm->page_size) & ~(vm->page_size - 1);
@@ -426,3 +428,42 @@ void vm_install_exception_handler(struct kvm_vm
*vm, int vector,
        assert(vector < VECTOR_NUM);
        handlers->exception_handlers[vector][0] = handler;
 }
+
+void vm_cpuid_map_init(struct kvm_vm *vm)
+{
+       int i = 0;
+       struct vcpu *vcpu;
+       struct vm_cpuid_map *map;
+
+       TEST_ASSERT(!list_empty(&vm->vcpus), "vCPUs must have been created\n");
+
+       list_for_each_entry(vcpu, &vm->vcpus, list) {
+               map = &cpuid_map[i++];
+               map->vcpuid = vcpu->id;
+               get_reg(vm, vcpu->id,
KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &map->hw_cpuid);
+               map->hw_cpuid &= MPIDR_HWID_BITMASK;
+       }
+
+       if (i < KVM_MAX_VCPUS)
+               cpuid_map[i].vcpuid = VM_CPUID_MAP_INVAL;
+
+       sync_global_to_guest(vm, cpuid_map);
+}
+
+int guest_get_vcpuid(void)
+{
+       int i, vcpuid;
+       uint64_t mpidr = read_sysreg(mpidr_el1) & MPIDR_HWID_BITMASK;
+
+       for (i = 0; i < KVM_MAX_VCPUS; i++) {
+               vcpuid = cpuid_map[i].vcpuid;
+
+               /* Was this vCPU added to the VM after the map was
initialized? */
+               GUEST_ASSERT_1(vcpuid != VM_CPUID_MAP_INVAL, mpidr);
+
+               if (mpidr == cpuid_map[i].hw_cpuid)
+                       return vcpuid;
+       }
+
+       /* We should not be reaching here */
+       GUEST_ASSERT_1(0, mpidr);
+       return -1;
+}

This would ensure that we don't have a sparse array and can use the
last non-vCPU element as a sentinal node.
If you still feel preparing the map as and when the vCPUs are created
makes more sense, I can go for it.

Regards,
Raghavendra
> Thanks,
> drew
>
