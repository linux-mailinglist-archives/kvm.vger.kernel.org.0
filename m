Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A241915F88D
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 22:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389054AbgBNVPk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 16:15:40 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:43221 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730337AbgBNVPk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 16:15:40 -0500
Received: by mail-il1-f196.google.com with SMTP id o13so335356ilg.10
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 13:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FXJ1JTNgU2E22b70yRrhJ6SPMIz5n/Z3sdORI4L9ty8=;
        b=jsrXdiHvNW2zQOd8aBV3t87/27otvjgZjd6NJ/B5m8BAwkxiejNryiAOp38AwF17a0
         PvyZh1E+koXs6hGBdR+rjPQQ2yOj6W3kLJl1xZ/zNYp3wgP1WDr8USFeN5+D+kwwfyLf
         KtLQZRiBzI0Nz3ZuaqMWBMOu9DLWMAEAPLMbxIPsa2F65EsutkvcVahd1+r76vDJEeAx
         C38KY20+aHbktRhYavj3Wyefm/4xJOCaoTvkFcAGz+0o+eKV2pHWunW/McOVcTZyXgF7
         F5Cx5KHHVB8R5DfETIV46Oa6IzhmTLAp6eQaJoL7ZMyd04IDhdcEsT3I3iZKGlIlTeGB
         p1BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FXJ1JTNgU2E22b70yRrhJ6SPMIz5n/Z3sdORI4L9ty8=;
        b=rLStV1G6N4HeHtUuBSwOoNV4uZW8QTdW9l4NezmUkQUrg8NKJK5U4qHZ2Ibfx8glto
         IspWeZNsMNyceq6Yzt8XdXnSex9E+hrrP+gFKiTUj1MNiXyWNqzFBMKJS9f0H5QI2pSQ
         6mHWkw8pdmTkWG+vH1aZjEOCxkTdTkQTcADvffkubpxpiF/4Ltz2ZDAk6M1b5YL5cGpo
         nzAg16TaCh+iAKILFP3TDMDkDD3FkjZgL2svYz9X7dcC1/t6T9G3+Eg04ioJpIUqWdz+
         KcFRdMIO9W5x0Tc66pJXWJwJfLpGtpChNSre94hEQJ17BozzQNbAi/xzO8o6HtEK0Wou
         vQdg==
X-Gm-Message-State: APjAAAX793QswjAmtyf9ZaBa9adyn6NbIvK/7Aw6BdW9M5BROzCfueXM
        S/ccKdmifElwnCku4kXeApscMbD653c1KkY6L5Q=
X-Google-Smtp-Source: APXvYqzQv0LLRRQ9ByBo7rV529L/iNIzaHjKCB6cgQtzDcXP6c42xPOa2yhHz978lz9Y+yhh+Wvkf03ZpP/XWK5tlp4=
X-Received: by 2002:a92:9e97:: with SMTP id s23mr5105396ilk.139.1581714939721;
 Fri, 14 Feb 2020 13:15:39 -0800 (PST)
MIME-Version: 1.0
References: <20200213213036.207625-1-olvaffe@gmail.com> <8fdb85ea-6441-9519-ae35-eaf91ffe8741@redhat.com>
 <CAPaKu7T8VYXTMc1_GOzJnwBaZSG214qNoqRr8c7Z4Lb3B7dtTg@mail.gmail.com> <b82cd76c-0690-c13b-cf2c-75d7911c5c61@redhat.com>
In-Reply-To: <b82cd76c-0690-c13b-cf2c-75d7911c5c61@redhat.com>
From:   Chia-I Wu <olvaffe@gmail.com>
Date:   Fri, 14 Feb 2020 13:15:28 -0800
Message-ID: <CAPaKu7TDtFwF5czdpke1v7NWKf61kw_jVp-E1qQPqs-qbZYnMw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] KVM: x86: honor guest memory type
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org,
        Gurchetan Singh <gurchetansingh@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 2:26 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 13/02/20 23:18, Chia-I Wu wrote:
> >
> > The bug you mentioned was probably this one
> >
> >   https://bugzilla.kernel.org/show_bug.cgi?id=104091
>
> Yes, indeed.
>
> > From what I can tell, the commit allowed the guests to create cached
> > mappings to MMIO regions and caused MCEs.  That is different than what
> > I need, which is to allow guests to create uncached mappings to system
> > ram (i.e., !kvm_is_mmio_pfn) when the host userspace also has uncached
> > mappings.  But it is true that this still allows the userspace & guest
> > kernel to create conflicting memory types.
>
> Right, the question is whether the MCEs were tied to MMIO regions
> specifically and if so why.
>
> An interesting remark is in the footnote of table 11-7 in the SDM.
> There, for the MTRR (EPT for us) memory type UC you can read:
>
>   The UC attribute comes from the MTRRs and the processors are not
>   required to snoop their caches since the data could never have
>   been cached. This attribute is preferred for performance reasons.
>
> There are two possibilities:
>
> 1) the footnote doesn't apply to UC mode coming from EPT page tables.
> That would make your change safe.
>
> 2) the footnote also applies when the UC attribute comes from the EPT
> page tables rather than the MTRRs.  In that case, the host should use
> UC as the EPT page attribute if and only if it's consistent with the host
> MTRRs; it would be more or less impossible to honor UC in the guest MTRRs.
> In that case, something like the patch below would be needed.
>
> It is not clear from the manual why the footnote would not apply to WC; that
> is, the manual doesn't say explicitly that the processor does not do snooping
> for accesses to WC memory.  But I guess that must be the case, which is why I
> used MTRR_TYPE_WRCOMB in the patch below.
>
> Either way, we would have an explanation of why creating cached mapping to
> MMIO regions would, and why in practice we're not seeing MCEs for guest RAM
> (the guest would have set WB for that memory in its MTRRs, not UC).
>
> One thing you didn't say: how would userspace use KVM_MEM_DMA?  On which
> regions would it be set?
It will be set for shmems that are mapped WC.

GPU/DRM drivers allocate shmems as DMA-able gpu buffers and allow the
userspace to map them cached or WC (I915_MMAP_WC or
AMDGPU_GEM_CREATE_CPU_GTT_USWC for example).  When a shmem is mapped
WC and is made available to the guest, we would like the ability to
map the region WC in the guest.


> Thanks,
>
> Paolo
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index dc331fb06495..2be6f7effa1d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6920,8 +6920,16 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>         }
>
>         cache = kvm_mtrr_get_guest_memory_type(vcpu, gfn);
> -
>  exit:
> +       if (cache == MTRR_TYPE_UNCACHABLE && !is_mmio) {
> +               /*
> +                * We cannot set UC in the EPT page tables as it can cause
> +                * machine check exceptions (??).  Hopefully the guest is
> +                * using PAT.
> +                */
> +               cache = MTRR_TYPE_WRCOMB;
> +       }
> +
>         return (cache << VMX_EPT_MT_EPTE_SHIFT) | ipat;
>  }
>
>
