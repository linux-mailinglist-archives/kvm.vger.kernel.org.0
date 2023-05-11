Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51406FFCEC
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 01:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239497AbjEKXD0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 19:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239214AbjEKXDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 19:03:21 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED1BE74
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:03:18 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba69d93a6b5so3609926276.1
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683846198; x=1686438198;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G7in9pHI8f4PbQncUNnm7irUkPJSlHoe9VFQrVjPC7s=;
        b=tlr7jb7AGBJLC1tGipYMA+NIE4W3qmlQdmY6GWrzLWsGWnOTLjaPHHlQG+JucDh8Qh
         Q+VUON7noOWe1bBTJLFWP8puzEqijn6x7iGqKtaf9KUTnJocCwIq8bQ4zF4ncz61ZUGV
         nIHRFyH+MjsY730vxId7VHLbcvyRGoDaRelSW10OrS6ersh1m09qWmIwdCDpEBmNK6ei
         d6zSU5NXO5rdsbAuzikE+DvT55dlDlrAAaWpeQnkwAGG0fYAdvmwXqV5dGWS3kPWcdMF
         u2iSGm/rtbBHvcFaFQcphfbZ8bqMKYu0jmywqpH7Ckh7xisCgK+GQqSuL5CH54Cv6zlp
         sNvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683846198; x=1686438198;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G7in9pHI8f4PbQncUNnm7irUkPJSlHoe9VFQrVjPC7s=;
        b=BoTuyfh4WtzwQwGd44zPaU0SH6XPSVmvYHS3yxtfdH25MPDWQwztZ9mEWwyq7h1Rgp
         /ocukIeATfbT1WTY2FWrYONsHwZecp1Xkhk56pRZZWgyNqwQxYECffpnOxjd9QM5s+mt
         hIRYwyiberrv2lESzxvInqa5R+r3MSFkYe5fSpjFO+L8IPMS9ocX7viuYvXN2qd337jb
         kYLHxs4mvxp1ZDQvTkT8fRe82kr8MQNFfkifzM1HABaZ2AL/gv1rPciaNYsHDhc4ukGU
         xlsPU9FMX6Nui4YsVaC6qt8xSTQdV19Qzt4pRapHjTRMe9WkraU3a6cKjKTl7hBMPXG6
         LybQ==
X-Gm-Message-State: AC+VfDy0K8zcI3FmbUlpihiDjbR3zY/X9PM5YE9mRHiSu7Q+K8JEa1yj
        /24fFGPdWSritqnTpPWgs2jU4QbFTmI=
X-Google-Smtp-Source: ACHHUZ43vzdgen2cveEeuKc+w92V7EeydHPKvEDKQRhBlrxAUEbdBd/WS3cmrriiVF0Dek+gyLX5N7OBccE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:21c5:0:b0:ba6:e7ee:bb99 with SMTP id
 h188-20020a2521c5000000b00ba6e7eebb99mr976041ybh.12.1683846198249; Thu, 11
 May 2023 16:03:18 -0700 (PDT)
Date:   Thu, 11 May 2023 16:03:16 -0700
In-Reply-To: <fa16b58fb9a8a0a3ad192963a66e327e74b387e5.camel@intel.com>
Mime-Version: 1.0
References: <20230503182852.3431281-1-seanjc@google.com> <20230503182852.3431281-3-seanjc@google.com>
 <06715227566b520d4a445466f091dc28a0b8cd95.camel@intel.com>
 <ZFPQodNs0Cn9YDXT@google.com> <fa16b58fb9a8a0a3ad192963a66e327e74b387e5.camel@intel.com>
Message-ID: <ZF10NPeLviOKtsxT@google.com>
Subject: Re: [PATCH 2/5] KVM: SVM: Use kvm_pat_valid() directly instead of kvm_mtrr_valid()
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 05, 2023, Kai Huang wrote:
> On Thu, 2023-05-04 at 08:34 -0700, Sean Christopherson wrote:
> > On Wed, May 03, 2023, Kai Huang wrote:
> > > > for better or worse, KVM doesn't apply the "zap
> > > > SPTEs" logic to guest PAT changes when the VM has a passthrough device
> > > > with non-coherent DMA.
> > > 
> > > Is it a bug?
> > 
> > No.  KVM's MTRR behavior is using a heuristic to try not to break the VM: if the
> > VM has non-coherent DMA, then honor UC mapping in the MTRRs as such mappings may
> > be coverage the non-coherent DMA.
> > 
> > From vmx_get_mt_mask():
> > 
> > 	/* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
> > 	 * memory aliases with conflicting memory types and sometimes MCEs.
> > 	 * We have to be careful as to what are honored and when.
> > 
> > The PAT is problematic because it is referenced via the guest PTEs, versus the
> > MTRRs being tied to the guest physical address, e.g. different virtual mappings
> > for the same physical address can yield different memtypes via the PAT.  My head
> > hurts just thinking about how that might interact with shadow paging :-)
> > 
> > Even the MTRRs are somewhat sketchy because they are technically per-CPU, i.e.
> > two vCPUs could have different memtypes for the same physical address.  But in
> > practice, sane software/firmware uses consistent MTRRs across all CPUs.
> 
> Agreed on all above odds.
> 
> But I think the answer to my question is actually we simply don't _need_ to zap
> SPTEs (with non-coherent DMA) when guest's IA32_PAT is changed:
> 
> 1) If EPT is enabled, IIUC guest's PAT is already horned.  VMCS's GUEST_IA32_PAT
> always reflects the IA32_PAT that guest wants to set.  EPT's memtype bits are
> set according to guest's MTRR.  That means guest changing IA32_PAT doesn't need
> to zap EPT PTEs as "EPT PTEs essentially only replaces guest's MTRRs".

Ah, yes, you're correct.  I thought KVM _always_ set the "ignore guest PAT" bit
in the EPT PTEs, but KVM honors guest PAT when non-coherent DMA is present and
CR0.CD=0.

> 2) If EPT is disabled, looking at the code, if I read correctly, the
> 'shadow_memtype_mask' is 0 for Intel, in which case KVM won't try to set any PAT
> memtype bit in shadow MMU PTE, which means the true PAT memtype is always WB and
> guest's memtype is never horned (guest's MTRRs are also never actually used by
> HW), which should be fine I guess??  My brain refused to go further :)

Yep.  It's entirely possible that VT-d without snoop control simply doesn't work
with shadow paging, but no one has ever cared.

> But anyway back to my question, I think "changing guest's IA32_PAT" shouldn't
> result in needing to "zap SPTEs".
