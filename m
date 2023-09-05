Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158FE792FCB
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 22:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243223AbjIEUTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 16:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbjIEUTA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 16:19:00 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E629FCFE
        for <kvm@vger.kernel.org>; Tue,  5 Sep 2023 13:18:39 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-594e5e2e608so29169897b3.2
        for <kvm@vger.kernel.org>; Tue, 05 Sep 2023 13:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693945105; x=1694549905; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SKMnAp9f8EJc20n4vg/did2TL5InJz+rEZP+feSjN0k=;
        b=MgrkBZQvfca4vswOCBULKXhkU3IPwHPR8eorxO4KxnpXly8T0tsDgHGuFlm2l8EOaW
         +03vwC+Az6rxCmoPFOBirjnCwSQRSL+wBOE8HTrVGH806aBTs+IFM9vn/nm4H5NBHMSU
         qoh4GdNE33goEgIQXna9QDUNrdCE7WfarTGfxsA7VkukKeQOF6ZztCysBlpXBR2MT7ke
         W8q7Vu4Glhw/GYhK9bax1F2Jtu71VST0ZayMDMorox6V+EQStE8YqqPR1BI8BPqS/Ysw
         +qB3D0a1ZLHXPxtWFqJza3XZqKf9do16STZZseSixosbHH2JQ+TihKbzwK35WuAgVyYy
         dJrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693945105; x=1694549905;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SKMnAp9f8EJc20n4vg/did2TL5InJz+rEZP+feSjN0k=;
        b=jZT5yXw3Te0AjoFmE1MI9nVD6f+A3ghxEP5m3+WGhi3+T8Qd8vRQvTGzpaBooEFMFZ
         PwzoLStx3qGsemtsPWwbBPbiijVZ7mwc7Im4BqDHtfNa9wNq0oSh1vMMu7C5bHQbGeot
         +ZPLipRzODvmf0T/YqkhbbeC5yT58GaGkQ6JupbMseaOBlDxG7X57Odz6jq4EIzZ7Xnx
         FxZ1a4Z81lHYAqH4S61PkUmJJyXLd697uJXjqIt36TFiEGbsl2+QxRV9qaGiW3MM2eAa
         rmwBD3zTbI9XDlN2ufU1yVH87V8XAVP897byhQcmwlkH441bxoGMtKU0riNofjxOGaEw
         VorA==
X-Gm-Message-State: AOJu0YxOxKYdqn1expcPsFxd/V5y60HVp6qiOxRzCNZN7VGFYTonBYpP
        tmaAGp9N9P1MeD3gM+YusUN3e0xmBnk=
X-Google-Smtp-Source: AGHT+IFepumOsNdi8jAStIn5DzvkpJUSBmneVeq1kh6ElDXQoU7LqwxwQZX7KSyykOvZjEbMckvsQoANfBU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b38a:0:b0:595:4ab7:bd64 with SMTP id
 r132-20020a81b38a000000b005954ab7bd64mr370290ywh.7.1693945105293; Tue, 05 Sep
 2023 13:18:25 -0700 (PDT)
Date:   Tue, 5 Sep 2023 13:18:23 -0700
In-Reply-To: <ZPWBM5DDC6MKINUe@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230808085056.14644-1-yan.y.zhao@intel.com> <ZN0S28lkbo6+D7aF@google.com>
 <ZN1jBFBH4C2bFjzZ@yzhao56-desk.sh.intel.com> <ZN5elYQ5szQndN8n@google.com>
 <ZN9FQf343+kt1YsX@yzhao56-desk.sh.intel.com> <ZPWBM5DDC6MKINUe@yzhao56-desk.sh.intel.com>
Message-ID: <ZPeND9WFHR2Xx8BM@google.com>
Subject: Re: [PATCH 0/2] KVM: x86/mmu: .change_pte() optimization in TDP MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 04, 2023, Yan Zhao wrote:
> ...
> > > Actually, I don't even completely understand how you're seeing CoW behavior in
> > > the first place.  No sane guest should blindly read (or execute) uninitialized
> > > memory.  IIUC, you're not running a Windows guest, and even if you are, AFAIK
> > > QEMU doesn't support Hyper-V's enlightment that lets the guest assume memory has
> > > been zeroed by the hypervisor.  If KSM is to blame, then my answer it to turn off
> > > KSM, because turning on KSM is antithetical to guest performance (not to mention
> > > that KSM is wildly insecure for the guest, especially given the number of speculative
> > > execution attacks these days).
> > I'm running a linux guest.
> > KSM is not turned on both in guest and host.
> > Both guest and host have turned on transparent huge page.
> > 
> > The guest first reads a GFN in a writable memslot (which is for "pc.ram"),
> > which will cause
> >     (1) KVM first sends a GUP without FOLL_WRITE, leaving a huge_zero_pfn or a zero-pfn
> >         mapped.
> >     (2) KVM calls get_user_page_fast_only() with FOLL_WRITE as the memslot is writable,
> >         which will fail
> > 
> > The guest then writes the GFN.
> > This step will trigger (huge pmd split for huge page case) and .change_pte().
> > 
> > My guest is surely a sane guest. But currently I can't find out why
> > certain pages are read before write.
> > Will return back to you the reason after figuring it out after my long vacation.
> Finally I figured out the reason.
> 
> Except 4 pages were read before written from vBIOS (I just want to skip finding
> out why vBIOS does this), the remaining thousands of pages were read before
> written from the guest Linux kernel.
> 
> If the guest kernel were configured with "CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y" or
> "CONFIG_INIT_ON_FREE_DEFAULT_ON=y", or booted with param "init_on_alloc=1" or
> "init_on_free=1", this read before written problem goes away.
> 
> However, turning on those configs has side effects as said in kernel config
> message:
> "all page allocator and slab allocator memory will be zeroed when allocated,
> eliminating many kinds of "uninitialized heap memory" flaws, especially
> heap content exposures. The performance impact varies by workload, but most
> cases see <1% impact. Some synthetic workloads have measured as high as 7%."
> 
> If without the above two configs, or if with init_on_alloc=0 && init_on_free=0,
> the root cause for all the reads of uninitialized heap memory are related to

Yeah, forcing the guest to pre-initialize all memory is a hack-a-fix and not a
real solution.

> page cache pages of the guest virtual devices (specifically the virtual IDE
> device in my case).

Why are you using IDE?  IDE is comically slow compared to VirtIO, and VirtIO has
been broadly supported for something like 15 years, even on Windows.

> The reason for this unconditional read of page into bounce buffer
> (caused by "swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE)")
> is explained in the code:
> 
> /*
>  * When dir == DMA_FROM_DEVICE we could omit the copy from the orig
>  * to the tlb buffer, if we knew for sure the device will
>  * overwrite the entire current content. But we don't. Thus
>  * unconditional bounce may prevent leaking swiotlb content (i.e.
>  * kernel memory) to user-space.
>  */
> 
> If we neglect this risk and do changes like
> -       swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE);
> +       if (dir != DMA_FROM_DEVICE)
> +               swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE);
> 
> the issue of pages read before written from guest kernel just went away.
> 
> I don't think it's a swiotlb bug, because to prevent leaking swiotlb
> content, if target page content is not copied firstly to the swiotlb's
> bounce buffer, then the bounce buffer needs to be initialized to 0.
> However, swiotlb_tbl_map_single() does not know whether the target page
> is initialized or not. Then, it would cause page content to be trimmed
> if device does not overwrite the entire memory.
> 
> > 
> > > 
> > > If there's something else going on, i.e. if your VM really is somehow generating
> > > reads before writes, and if we really want to optimize use cases that can't use
> > > hugepages for whatever reason, I would much prefer to do something like add a
> > > memslot flag to state that the memslot should *always* be mapped writable.  Because
> > Will check if this flag is necessary after figuring out the reason.
> As explained above, I think it's a valid and non-rare practice in guest kernel to
> cause read of uninitialized heap memory.

Heh, for some definitions of valid.  

> And the host admin may not know exactly when it's appropriate to apply the
> memslot flag.

Yeah, a memslot flag is too fine-grained.

> Do you think it's good to make the "always write_fault = true" solution enabled
> by default?

Sadly, probably not, because that would regress setups that do want to utilize
CoW, e.g. I'm pretty sure requesting everything to be writable would be a big
negative for KSM.

I do think we should add a KVM knob though.  Regardless of the validity or frequency
of the guest behavior, and even though userspace can also workaround this by
preallocating guest memory, I am struggling to think of any reason outside of KSM
where CoW semantics are desirable.

Ooh, actually, maybe we could do

	static bool <name_tbd> = !IS_ENABLED(CONFIG_KSM);

and then cross our fingers that that doesn't regress some other funky setups.
