Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E68241348
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 00:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbgHJWgj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 18:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbgHJWgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 18:36:38 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF3BC061787
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 15:36:36 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id qc22so11023319ejb.4
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 15:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rpjsDVuZ/MIM7F2tUTnpKK77d77WIkbPCXQTuIMBoSc=;
        b=SHDv3U5dXtJNdixIFoZCgbM1M+aXUCnilptBkFpapxmIbK2ZTeOXF8B1dbCFDaSkq1
         EVF1QxZgobcGfitOoxU5GjsX3QJy9F5Fgo4dM60xfNif+9KZRpJZ3UpEHfBnaCtHwf3b
         qVYjqFG718X65RRKpi19WlGlU5Z9fB9/1cseeW5foTc54KpBFdvdAktJdoyjZgm8i178
         2zbVH5PjFeB6qNUxpXqameMf/UXd0RecwF22rMhmpS3d29+HvAetToYFB/XLRSTbN2KN
         9Yz3LuJVq/fcnvowSvUtTxt5exNr+m7Ti5rlEZ+sSpy0Rk1VM9eIQGI4wVNsk4qTwbty
         6MEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rpjsDVuZ/MIM7F2tUTnpKK77d77WIkbPCXQTuIMBoSc=;
        b=ulf8yDUPpV3PlTDiBrRFijCkcCdUqzkbjRUoqdPY0+lbwEtcMatvD34pnm5BmAJn/T
         6mBDU2XDw2DsQC3HASvxKTUHIXDSeTP3fM44vqJPMUHwMxokUBUypqPG2DGpPxKwlgmA
         DJwlzVpKb4c1bmx/TxwDBDngZZKLnHPCsFrXxkDNP9cYYAq9oLpxarl0P66HpVR5BkCR
         a/5S66gEakW7P4GArfFA0tB1fP1ek7EDY7v0uYmnX8PsjDFS0/3d/jXFm4DsYQagxSXG
         vY+rl5QOseo2hfd87GWIpJ1pb8LOlkPQwnC6K/VWqqJYVGUHfiM3+kPq0sQiFVdYyqM+
         aVEw==
X-Gm-Message-State: AOAM5303JTdKi7XJs3ZB8DDdmt43YIatADR9WUv2OSPsg9a3S1jxLjH/
        xhI5EgTW990MQX+xgs/94/3gxdn4TxUAA/RnrrtBdQ==
X-Google-Smtp-Source: ABdhPJybBjUJPBkQOzfMF2tZeMoiN3r7g9y5uKLfBatvpMSlrbohK3itKfycbIvhcJ8Q9qvglJFf/Gj5nE64NdnqTnY=
X-Received: by 2002:a17:907:2115:: with SMTP id qn21mr24568538ejb.157.1597098994899;
 Mon, 10 Aug 2020 15:36:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200807155648.8602-1-graf@amazon.com> <20200807155648.8602-3-graf@amazon.com>
In-Reply-To: <20200807155648.8602-3-graf@amazon.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Mon, 10 Aug 2020 15:36:23 -0700
Message-ID: <CAAAPnDF4nwsOV-mO6PLSnz5dV7ADgfHAzM6qjSh+byqZ+OGSeg@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] KVM: x86: Introduce allow list for MSR emulation
To:     Alexander Graf <graf@amazon.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        kvm list <kvm@vger.kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 7, 2020 at 8:57 AM Alexander Graf <graf@amazon.com> wrote:
>
> It's not desireable to have all MSRs always handled by KVM kernel space. Some
> MSRs would be useful to handle in user space to either emulate behavior (like
> uCode updates) or differentiate whether they are valid based on the CPU model.
>
> To allow user space to specify which MSRs it wants to see handled by KVM,
> this patch introduces a new ioctl to push allow lists of bitmaps into
> KVM. Based on these bitmaps, KVM can then decide whether to reject MSR access.
> With the addition of KVM_CAP_X86_USER_SPACE_MSR it can also deflect the
> denied MSR events to user space to operate on.
>
> If no allowlist is populated, MSR handling stays identical to before.
>
> Signed-off-by: KarimAllah Ahmed <karahmed@amazon.de>
> Signed-off-by: Alexander Graf <graf@amazon.com>
>
> ---
>
> v2 -> v3:
>
>   - document flags for KVM_X86_ADD_MSR_ALLOWLIST
>   - generalize exit path, always unlock when returning
>   - s/KVM_CAP_ADD_MSR_ALLOWLIST/KVM_CAP_X86_MSR_ALLOWLIST/g
>   - Add KVM_X86_CLEAR_MSR_ALLOWLIST
>
> v3 -> v4:
>   - lock allow check and clearing
>   - free bitmaps on clear
>
> v4 -> v5:
>
>   - use srcu
> ---
>  Documentation/virt/kvm/api.rst  |  91 ++++++++++++++++++
>  arch/x86/include/asm/kvm_host.h |  10 ++
>  arch/x86/include/uapi/asm/kvm.h |  15 +++
>  arch/x86/kvm/x86.c              | 160 ++++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h        |   5 +
>  5 files changed, 281 insertions(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 2ca38649b3d4..9cb36060f61c 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4697,6 +4697,82 @@ KVM_PV_VM_VERIFY
>    Verify the integrity of the unpacked image. Only if this succeeds,
>    KVM is allowed to start protected VCPUs.
>
> +4.126 KVM_X86_ADD_MSR_ALLOWLIST
> +-------------------------------
> +
> +:Capability: KVM_CAP_X86_MSR_ALLOWLIST
> +:Architectures: x86
> +:Type: vm ioctl
> +:Parameters: struct kvm_msr_allowlist
> +:Returns: 0 on success, < 0 on error
> +
> +::
> +
> +  struct kvm_msr_allowlist {
> +         __u32 flags;
> +         __u32 nmsrs; /* number of msrs in bitmap */
> +         __u32 base;  /* base address for the MSRs bitmap */
> +         __u32 pad;
> +
> +         __u8 bitmap[0]; /* a set bit allows that the operation set in flags */
> +  };

Couldn't the struct look like this given there are 3 flags and nmsrs
can't be greater than KVM_MSR_ALLOWLIST_MAX_LEN (0x600)
struct kvm_msr_allowlist {
        __u16 flags;
        __u16 nmsrs; /* number of msrs in bitmap */
        __u32 base;  /* base address for the MSRs bitmap */
        __u8 bitmap[0]; /* a set bit allows that the operation set in flags */
};



> +
> +flags values:
> +
> +KVM_MSR_ALLOW_READ
> +
> +  Filter read accesses to MSRs using the given bitmap. A 0 in the bitmap
> +  indicates that a read should immediately fail, while a 1 indicates that
> +  a read should be handled by the normal KVM MSR emulation logic.
> +
> +KVM_MSR_ALLOW_WRITE
> +
> +  Filter write accesses to MSRs using the given bitmap. A 0 in the bitmap
> +  indicates that a write should immediately fail, while a 1 indicates that
> +  a write should be handled by the normal KVM MSR emulation logic.
> +
> +KVM_MSR_ALLOW_READ | KVM_MSR_ALLOW_WRITE
> +
> +  Filter booth read and write accesses to MSRs using the given bitmap. A 0
> +  in the bitmap indicates that both reads and writes should immediately fail,
> +  while a 1 indicates that reads and writes should be handled by the normal
> +  KVM MSR emulation logic.

nit: Filter both

> +
> +This ioctl allows user space to define a set of bitmaps of MSR ranges to
> +specify whether a certain MSR access is allowed or not.
> +
> +If this ioctl has never been invoked, MSR accesses are not guarded and the
> +old KVM in-kernel emulation behavior is fully preserved.
> +
> +As soon as the first allow list was specified, only allowed MSR accesses
> +are permitted inside of KVM's MSR code.
> +
> +Each allowlist specifies a range of MSRs to potentially allow access on.
> +The range goes from MSR index [base .. base+nmsrs]. The flags field
> +indicates whether reads, writes or both reads and writes are permitted
> +by setting a 1 bit in the bitmap for the corresponding MSR index.
> +
> +If an MSR access is not permitted through the allow list, it generates a
> +#GP inside the guest. When combined with KVM_CAP_X86_USER_SPACE_MSR, that
> +allows user space to deflect and potentially handle various MSR accesses
> +into user space.
> +
> +4.124 KVM_X86_CLEAR_MSR_ALLOWLIST
> +---------------------------------
> +
> +:Capability: KVM_CAP_X86_MSR_ALLOWLIST
> +:Architectures: x86
> +:Type: vcpu ioctl
> +:Parameters: none
> +:Returns: 0
> +
> +This ioctl resets all internal MSR allow lists. After this call, no allow
> +list is present and the guest would execute as if no allow lists were set,
> +so all MSRs are considered allowed and thus handled by the in-kernel MSR
> +emulation logic.
> +
> +No vCPU may be in running state when calling this ioctl.
> +
>
>  5. The kvm_run structure
>  ========================
> @@ -6213,3 +6289,18 @@ writes to user space. It can be enabled on a VM level. If enabled, MSR
>  accesses that would usually trigger a #GP by KVM into the guest will
>  instead get bounced to user space through the KVM_EXIT_X86_RDMSR and
>  KVM_EXIT_X86_WRMSR exit notifications.
> +
> +8.25 KVM_CAP_X86_MSR_ALLOWLIST
> +------------------------------
> +
> +:Architectures: x86
> +
> +This capability indicates that KVM supports emulation of only select MSR
> +registers. With this capability exposed, KVM exports two new VM ioctls:
> +KVM_X86_ADD_MSR_ALLOWLIST which user space can call to specify bitmaps of MSR
> +ranges that KVM should emulate in kernel space and KVM_X86_CLEAR_MSR_ALLOWLIST
> +which user space can call to remove all MSR allow lists from the VM context.
> +
> +In combination with KVM_CAP_X86_USER_SPACE_MSR, this allows user space to
> +trap and emulate MSRs that are outside of the scope of KVM as well as
> +limit the attack surface on KVM's MSR emulation code.
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2f2307e71342..4b1ff7cb848f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -901,6 +901,13 @@ struct kvm_hv {
>         struct kvm_hv_syndbg hv_syndbg;
>  };
>
> +struct msr_bitmap_range {
> +       u32 flags;
> +       u32 nmsrs;
> +       u32 base;
> +       unsigned long *bitmap;
> +};
> +
>  enum kvm_irqchip_mode {
>         KVM_IRQCHIP_NONE,
>         KVM_IRQCHIP_KERNEL,       /* created with KVM_CREATE_IRQCHIP */
> @@ -1005,6 +1012,9 @@ struct kvm_arch {
>         /* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
>         bool user_space_msr_enabled;
>
> +       struct msr_bitmap_range msr_allowlist_ranges[10];
> +       int msr_allowlist_ranges_count;
> +
>         struct kvm_pmu_event_filter *pmu_event_filter;
>         struct task_struct *nx_lpage_recovery_thread;
>  };
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 0780f97c1850..c33fb1d72d52 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -192,6 +192,21 @@ struct kvm_msr_list {
>         __u32 indices[0];
>  };
>
> +#define KVM_MSR_ALLOW_READ  (1 << 0)
> +#define KVM_MSR_ALLOW_WRITE (1 << 1)
> +
> +/* Maximum size of the of the bitmap in bytes */

nit: "of the" is repeated twice

> +#define KVM_MSR_ALLOWLIST_MAX_LEN 0x600
> +
> +/* for KVM_X86_ADD_MSR_ALLOWLIST */
> +struct kvm_msr_allowlist {
> +       __u32 flags;
> +       __u32 nmsrs; /* number of msrs in bitmap */
> +       __u32 base;  /* base address for the MSRs bitmap */
> +       __u32 pad;
> +
> +       __u8 bitmap[0]; /* a set bit allows that the operation set in flags */
> +};
>
>  struct kvm_cpuid_entry {
>         __u32 function;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e1139124350f..a037da85d9d4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1472,6 +1472,39 @@ void kvm_enable_efer_bits(u64 mask)
>  }
>  EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
>
> +static bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
> +{
> +       struct kvm *kvm = vcpu->kvm;
> +       struct msr_bitmap_range *ranges = kvm->arch.msr_allowlist_ranges;
> +       u32 count = kvm->arch.msr_allowlist_ranges_count;
> +       u32 i;
> +       bool r = false;
> +       int idx;
> +
> +       /* MSR allowlist not set up, allow everything */
> +       if (!count)
> +               return true;
> +
> +       /* Prevent collision with clear_msr_allowlist */
> +       idx = srcu_read_lock(&kvm->srcu);
> +
> +       for (i = 0; i < count; i++) {
> +               u32 start = ranges[i].base;
> +               u32 end = start + ranges[i].nmsrs;
> +               u32 flags = ranges[i].flags;
> +               unsigned long *bitmap = ranges[i].bitmap;
> +
> +               if ((index >= start) && (index < end) && (flags & type)) {
> +                       r = !!test_bit(index - start, bitmap);
> +                       break;
> +               }
> +       }
> +
> +       srcu_read_unlock(&kvm->srcu, idx);
> +
> +       return r;
> +}
> +
>  /*
>   * Write @data into the MSR specified by @index.  Select MSR specific fault
>   * checks are bypassed if @host_initiated is %true.
> @@ -1483,6 +1516,9 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
>  {
>         struct msr_data msr;
>
> +       if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_ALLOW_WRITE))
> +               return -ENOENT;
> +
>         switch (index) {
>         case MSR_FS_BASE:
>         case MSR_GS_BASE:
> @@ -1528,6 +1564,9 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
>         struct msr_data msr;
>         int ret;
>
> +       if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_ALLOW_READ))
> +               return -ENOENT;
> +
>         msr.index = index;
>         msr.host_initiated = host_initiated;
>
> @@ -3550,6 +3589,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>         case KVM_CAP_EXCEPTION_PAYLOAD:
>         case KVM_CAP_SET_GUEST_DEBUG:
>         case KVM_CAP_X86_USER_SPACE_MSR:
> +       case KVM_CAP_X86_MSR_ALLOWLIST:
>                 r = 1;
>                 break;
>         case KVM_CAP_SYNC_REGS:
> @@ -5075,6 +5115,116 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>         return r;
>  }
>
> +static bool msr_range_overlaps(struct kvm *kvm, struct msr_bitmap_range *range)
> +{
> +       struct msr_bitmap_range *ranges = kvm->arch.msr_allowlist_ranges;
> +       u32 i, count = kvm->arch.msr_allowlist_ranges_count;
> +       bool r = false;
> +
> +       for (i = 0; i < count; i++) {
> +               u32 start = max(range->base, ranges[i].base);
> +               u32 end = min(range->base + range->nmsrs,
> +                             ranges[i].base + ranges[i].nmsrs);
> +
> +               if ((start < end) && (range->flags & ranges[i].flags)) {
> +                       r = true;
> +                       break;
> +               }
> +       }
> +
> +       return r;
> +}
> +
> +static int kvm_vm_ioctl_add_msr_allowlist(struct kvm *kvm, void __user *argp)
> +{
> +       struct msr_bitmap_range *ranges = kvm->arch.msr_allowlist_ranges;
> +       struct kvm_msr_allowlist __user *user_msr_allowlist = argp;
> +       struct msr_bitmap_range range;
> +       struct kvm_msr_allowlist kernel_msr_allowlist;
> +       unsigned long *bitmap = NULL;
> +       size_t bitmap_size;
> +       int r = 0;
> +
> +       if (copy_from_user(&kernel_msr_allowlist, user_msr_allowlist,
> +                          sizeof(kernel_msr_allowlist))) {
> +               r = -EFAULT;
> +               goto out;
> +       }
> +
> +       bitmap_size = BITS_TO_LONGS(kernel_msr_allowlist.nmsrs) * sizeof(long);
> +       if (bitmap_size > KVM_MSR_ALLOWLIST_MAX_LEN) {
> +               r = -EINVAL;
> +               goto out;
> +       }
> +
> +       bitmap = memdup_user(user_msr_allowlist->bitmap, bitmap_size);
> +       if (IS_ERR(bitmap)) {
> +               r = PTR_ERR(bitmap);
> +               goto out;
> +       }
> +
> +       range = (struct msr_bitmap_range) {
> +               .flags = kernel_msr_allowlist.flags,
> +               .base = kernel_msr_allowlist.base,
> +               .nmsrs = kernel_msr_allowlist.nmsrs,
> +               .bitmap = bitmap,
> +       };
> +
> +       if (range.flags & ~(KVM_MSR_ALLOW_READ | KVM_MSR_ALLOW_WRITE)) {
> +               r = -EINVAL;
> +               goto out;
> +       }
> +
> +       /*
> +        * Protect from concurrent calls to this function that could trigger
> +        * a TOCTOU violation on kvm->arch.msr_allowlist_ranges_count.
> +        */
> +       mutex_lock(&kvm->lock);
> +
> +       if (kvm->arch.msr_allowlist_ranges_count >=
> +           ARRAY_SIZE(kvm->arch.msr_allowlist_ranges)) {
> +               r = -E2BIG;
> +               goto out_locked;
> +       }
> +
> +       if (msr_range_overlaps(kvm, &range)) {
> +               r = -EINVAL;
> +               goto out_locked;
> +       }
> +
> +       /* Everything ok, add this range identifier to our global pool */
> +       ranges[kvm->arch.msr_allowlist_ranges_count] = range;
> +       /* Make sure we filled the array before we tell anyone to walk it */
> +       smp_wmb();
> +       kvm->arch.msr_allowlist_ranges_count++;
> +
> +out_locked:
> +       mutex_unlock(&kvm->lock);
> +out:
> +       if (r)
> +               kfree(bitmap);
> +
> +       return r;
> +}
> +
> +static int kvm_vm_ioctl_clear_msr_allowlist(struct kvm *kvm)
> +{
> +       int i;
> +       u32 count = kvm->arch.msr_allowlist_ranges_count;
> +       struct msr_bitmap_range ranges[10];
> +
> +       mutex_lock(&kvm->lock);
> +       kvm->arch.msr_allowlist_ranges_count = 0;
> +       memcpy(ranges, kvm->arch.msr_allowlist_ranges, count * sizeof(ranges[0]));
> +       mutex_unlock(&kvm->lock);
> +       synchronize_srcu(&kvm->srcu);
> +
> +       for (i = 0; i < count; i++)
> +               kfree(ranges[i].bitmap);
> +
> +       return 0;
> +}
> +
>  long kvm_arch_vm_ioctl(struct file *filp,
>                        unsigned int ioctl, unsigned long arg)
>  {
> @@ -5381,6 +5531,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
>         case KVM_SET_PMU_EVENT_FILTER:
>                 r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
>                 break;
> +       case KVM_X86_ADD_MSR_ALLOWLIST:
> +               r = kvm_vm_ioctl_add_msr_allowlist(kvm, argp);
> +               break;
> +       case KVM_X86_CLEAR_MSR_ALLOWLIST:
> +               r = kvm_vm_ioctl_clear_msr_allowlist(kvm);
> +               break;
>         default:
>                 r = -ENOTTY;
>         }
> @@ -10086,6 +10242,8 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm)
>
>  void kvm_arch_destroy_vm(struct kvm *kvm)
>  {
> +       int i;
> +
>         if (current->mm == kvm->mm) {
>                 /*
>                  * Free memory regions allocated on behalf of userspace,
> @@ -10102,6 +10260,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>         }
>         if (kvm_x86_ops.vm_destroy)
>                 kvm_x86_ops.vm_destroy(kvm);
> +       for (i = 0; i < kvm->arch.msr_allowlist_ranges_count; i++)
> +               kfree(kvm->arch.msr_allowlist_ranges[i].bitmap);
>         kvm_pic_destroy(kvm);
>         kvm_ioapic_destroy(kvm);
>         kvm_free_vcpus(kvm);
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 13fc7de1eb50..4d6bb06e0fb1 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1041,6 +1041,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_HALT_POLL 182
>  #define KVM_CAP_ASYNC_PF_INT 183
>  #define KVM_CAP_X86_USER_SPACE_MSR 184
> +#define KVM_CAP_X86_MSR_ALLOWLIST 185
>
>  #ifdef KVM_CAP_IRQ_ROUTING
>
> @@ -1542,6 +1543,10 @@ struct kvm_pv_cmd {
>  /* Available with KVM_CAP_S390_PROTECTED */
>  #define KVM_S390_PV_COMMAND            _IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
>
> +/* Available with KVM_CAP_X86_MSR_ALLOWLIST */
> +#define KVM_X86_ADD_MSR_ALLOWLIST      _IOW(KVMIO,  0xc6, struct kvm_msr_allowlist)
> +#define KVM_X86_CLEAR_MSR_ALLOWLIST    _IO(KVMIO,  0xc7)
> +
>  /* Secure Encrypted Virtualization command */
>  enum sev_cmd_id {
>         /* Guest initialization commands */
> --
> 2.17.1
>
>
>
>
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
>
>
>

I think you're missing logic to ensure the permission bitmap get's set
properly.  I hope I understand your change correct, but if userspace
clears a bit in the allow list (like in the selftest you wrote), you'd
expect that MSR to be sent to userspace for processing.  If the bit in
the permission bitmap for that same MSR gets cleared for whatever
reason, the guest won't exit to kvm on a rdmsr / wrmsr, and as a
result userspace will not end up being notified the MSR was read from
or written to.  To avoid this scenario you'll have to ensure that any
MSR userspace is expecting to encounter also has the bit set in the
permission bitmap.
