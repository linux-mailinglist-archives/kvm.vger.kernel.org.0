Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEA8215F8E5
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 22:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgBNVrW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 16:47:22 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:36666 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728336AbgBNVrW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 16:47:22 -0500
Received: by mail-il1-f195.google.com with SMTP id b15so9305981iln.3
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 13:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XSp1PAQazgk+XM1bOQr94nFzEBo47E8po1PZwIgf7ro=;
        b=aUIr5leFvUZEzrI5yr2U/nN4v7CNNSytl3c7YGDOnOxWoXf59ky1U8fp1HoYTnLG/3
         /jydw3gNcnUsF4PaIBMrpXSWK1MqK+4Ui0ltUKG/fnl0Sg/TFAvf2vFU/8RdH3zGgJX1
         cEEw2J6bxSFYZNF0sTxzB5jKNLEeYvypha9F8oaZQrFZRTBOP40Ai4CazriUuLP28rOI
         /16RBLpV8UmN+We0K9jsbOjWVKemAxXTC0HvIrx3SkU10P65L1O5k+aYckl+ypbx37kU
         kWLtjyKBVTCV5oolsU4+q08euweK4NmfTeN63UCoSWKttNaBNPJu1oou036d4CMNHoyf
         0igg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XSp1PAQazgk+XM1bOQr94nFzEBo47E8po1PZwIgf7ro=;
        b=h6IdWUweLtUW350Kklx5YgtavPxdTjsHtb5gS7e7kjDhQkbrtvpgoufNPmbpVDdvmy
         bABJS7IGeIQhoA4v4K6AI0+BCvXH6TfTnzg8WsHczaHpiXRLQCbtb6Ndu8Wl0oLlmKlp
         zqD8dxpkqO2VF63S1lTK/5cx0z74G5xJRUDQfJTOrC13tEBAY6691p33ttFS/gyEst5+
         CcCIcDofGWKlunoBoHp/yAnPfrXu/P7k/0HQGfsAFFM9MepRLCWM9qX27+SQ9JAxvrEy
         SNIFQmBIyiybbCVdxGtf6cAds/fV9vHJe40VYOby/MgaTQbth2mp3bG2SIjV5TDU9lge
         pI9w==
X-Gm-Message-State: APjAAAXEkt9Ca/KORcLFYPLvItJAHdsh0Fy8sSs1U430bHcTasDU7aPE
        opnivwrrgH8duiVG9LV3+sg3XcZozWsSyWjVEZM=
X-Google-Smtp-Source: APXvYqyc2oy+IbPgVLdVPOmnmm+KLSiZ5a10T5GblQcFkM+M7nPY6xOWMlRPq4DJoic4yg5bssKa75F84a/QZz14OVU=
X-Received: by 2002:a92:4a0a:: with SMTP id m10mr5044617ilf.84.1581716839982;
 Fri, 14 Feb 2020 13:47:19 -0800 (PST)
MIME-Version: 1.0
References: <20200213213036.207625-1-olvaffe@gmail.com> <8fdb85ea-6441-9519-ae35-eaf91ffe8741@redhat.com>
 <CAPaKu7T8VYXTMc1_GOzJnwBaZSG214qNoqRr8c7Z4Lb3B7dtTg@mail.gmail.com>
 <b82cd76c-0690-c13b-cf2c-75d7911c5c61@redhat.com> <20200214195229.GF20690@linux.intel.com>
In-Reply-To: <20200214195229.GF20690@linux.intel.com>
From:   Chia-I Wu <olvaffe@gmail.com>
Date:   Fri, 14 Feb 2020 13:47:08 -0800
Message-ID: <CAPaKu7Q4gehyhEgG_Nw=tiZiTh+7A8-uuXq1w4he6knp6NWErQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] KVM: x86: honor guest memory type
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Gurchetan Singh <gurchetansingh@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 11:52 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Feb 14, 2020 at 11:26:06AM +0100, Paolo Bonzini wrote:
> > On 13/02/20 23:18, Chia-I Wu wrote:
> > >
> > > The bug you mentioned was probably this one
> > >
> > >   https://bugzilla.kernel.org/show_bug.cgi?id=104091
> >
> > Yes, indeed.
> >
> > > From what I can tell, the commit allowed the guests to create cached
> > > mappings to MMIO regions and caused MCEs.  That is different than what
> > > I need, which is to allow guests to create uncached mappings to system
> > > ram (i.e., !kvm_is_mmio_pfn) when the host userspace also has uncached
> > > mappings.  But it is true that this still allows the userspace & guest
> > > kernel to create conflicting memory types.
>
> This is ok.
>
> > Right, the question is whether the MCEs were tied to MMIO regions
> > specifically and if so why.
>
> 99.99999% likelihood the answer is "yes".  Cacheable accesses to non-existent
> memory and most (all?) MMIO regions will cause a #MC.  This includes
> speculative accesses.
>
> Commit fd717f11015f ("KVM: x86: apply guest MTRR virtualization on host
> reserved pages") explicitly had a comment "1. MMIO: trust guest MTRR",
> which is basically a direct avenue to generating #MCs.
>
> IIRC, WC accesses to non-existent memory will also cause #MC, but KVM has
> bigger problems if it has PRESENT EPTEs pointing at garbage.
>
> > An interesting remark is in the footnote of table 11-7 in the SDM.
> > There, for the MTRR (EPT for us) memory type UC you can read:
> >
> >   The UC attribute comes from the MTRRs and the processors are not
> >   required to snoop their caches since the data could never have
> >   been cached. This attribute is preferred for performance reasons.
> >
> > There are two possibilities:
> >
> > 1) the footnote doesn't apply to UC mode coming from EPT page tables.
> > That would make your change safe.
> >
> > 2) the footnote also applies when the UC attribute comes from the EPT
> > page tables rather than the MTRRs.  In that case, the host should use
> > UC as the EPT page attribute if and only if it's consistent with the host
> > MTRRs; it would be more or less impossible to honor UC in the guest MTRRs.
> > In that case, something like the patch below would be needed.
>
> (2), the EPTs effectively replace the MTRRs.  The expectation being that
> the VMM will use always use EPT memtypes consistent with the MTRRs.
This is my understanding as well.

> > It is not clear from the manual why the footnote would not apply to WC; that
> > is, the manual doesn't say explicitly that the processor does not do snooping
> > for accesses to WC memory.  But I guess that must be the case, which is why I
> > used MTRR_TYPE_WRCOMB in the patch below.
>
> A few paragraphs below table 11-12 states:
>
>   In particular, a WC page must never be aliased to a cacheable page because
>   WC writes may not check the processor caches.
>
> > Either way, we would have an explanation of why creating cached mapping to
> > MMIO regions would, and why in practice we're not seeing MCEs for guest RAM
> > (the guest would have set WB for that memory in its MTRRs, not UC).
>
> Aliasing (physical) RAM with different memtypes won't cause #MC, just
> memory corruption.

What we need potentially gives the userspace (the guest kernel, to be
exact) the ability to create conflicting memory types.  If we can be
sure that the worst scenario is for a guest to corrupt its own memory,
by only allowing aliases on physical ram, that seems alright.

AFAICT, it is currently allowed on ARM (verified) and AMD (not
verified, but svm_get_mt_mask returns 0 which supposedly means the NPT
does not restrict what the guest PAT can do).  This diff would do the
trick for Intel without needing any uapi change:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e3394c839dea..88af11cc551a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6905,12 +6905,6 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu
*vcpu, gfn_t gfn, bool is_mmio)
                goto exit;
        }

-       if (!kvm_arch_has_noncoherent_dma(vcpu->kvm)) {
-               ipat = VMX_EPT_IPAT_BIT;
-               cache = MTRR_TYPE_WRBACK;
-               goto exit;
-       }
-
        if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
                ipat = VMX_EPT_IPAT_BIT;
                if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))



> > One thing you didn't say: how would userspace use KVM_MEM_DMA?  On which
> > regions would it be set?
> >
> > Thanks,
> >
> > Paolo
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index dc331fb06495..2be6f7effa1d 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6920,8 +6920,16 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> >       }
> >
> >       cache = kvm_mtrr_get_guest_memory_type(vcpu, gfn);
> > -
> >  exit:
> > +     if (cache == MTRR_TYPE_UNCACHABLE && !is_mmio) {
> > +             /*
> > +              * We cannot set UC in the EPT page tables as it can cause
> > +              * machine check exceptions (??).  Hopefully the guest is
> > +              * using PAT.
> > +              */
> > +             cache = MTRR_TYPE_WRCOMB;
>
> This is unnecessary.  Setting UC in the EPT tables will never directly lead
> to #MC.  Forcing WC is likely more dangerous.
>
> > +     }
> > +
> >       return (cache << VMX_EPT_MT_EPTE_SHIFT) | ipat;
> >  }
> >
> >
