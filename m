Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6AD51DCA7
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 17:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443250AbiEFQBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 12:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443241AbiEFQB3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 12:01:29 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFD46D4C7
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 08:57:44 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 15so6448250pgf.4
        for <kvm@vger.kernel.org>; Fri, 06 May 2022 08:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BH6y7X/82o8jIZUQV4ebaHgoKtpRylvhrmOIif0JHwU=;
        b=FQhYcGmNfKHc1nnYiFgAXEoKwFxv8E28pcK4R/dONCWBEiC1KWQT83UhrS3Ajqa5VF
         v1SWMP9e6Rg+48/I+dc2lGF88e6H4ntTd5o420D6U++RSzF1rIMH6/KCT3fxL+5fArcE
         Gp4H0ZVou5JZiL+9Xp+BAY5cGWZCLXT8Mim+gAw57kqy4ZPdAFgaSzxpcGDuoTOAWprM
         rvywKTsamApwQjG3U6DSE1Rh2s4AnO9KZGHKMYlbV7HmlPgH8ZQwvzWoUgyP+5xVLxMp
         TKgJKkAvLDit+a+mwShx7MiCTMMsauXQxEQABZ5QRmBrX2F+NIc+CYZx7sne5erKdKYq
         7o+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BH6y7X/82o8jIZUQV4ebaHgoKtpRylvhrmOIif0JHwU=;
        b=sQhAdpIvjRoUteJxt362lB5G/P2rA2qTB+RBbET0PVipB0jNx0Uj2tVdkRf32Oo8IZ
         OIFBEJxPwZEbeqQkI+hlPyWN8Q7kQ/+nE3JsSa6m7y+CvuyME+o68WSUmHu9ePtvNtu8
         L5mpDlj9BZYTZLebmIFE1869Xy+QYX+RIj7RYDtZsUW3Nas7Hx2EBjALr9cpA+BcQxmC
         s7LtaXpuHiAh7NyhJm+IaNqa1+YK32zqMN8WrxVPQ59CL4Nz+7Gqb5vFr9EW2ypzs7D8
         Ri4nRsviZ66wPiJBmqCTJIX+HVMkBapazD//2lUzhZaHhCB8AB0wYIaCaumLZ9vhAT5g
         Uflw==
X-Gm-Message-State: AOAM53174n/wynVqfjAs9ng0S/hw6iASO2LoqdQVaiKeCy0TjiBBhh57
        iuLqvoYPPGHT8rF7Qxp0q7xnB6zbsLSi6pqAIJq+6w==
X-Google-Smtp-Source: ABdhPJzNvlbxqVqoMGNz5y2CN+HqEdAlvGnqMhpxWV4GqovWrOQCGE/1RxMaOtDYaNPYBFkT+NVxyrcy8oC2CTVA74E=
X-Received: by 2002:a63:1117:0:b0:399:2df0:7fb9 with SMTP id
 g23-20020a631117000000b003992df07fb9mr3434149pgl.40.1651852663992; Fri, 06
 May 2022 08:57:43 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1649219184.git.kai.huang@intel.com> <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
 <ecf718abf864bbb2366209f00d4315ada090aedc.camel@intel.com>
 <de24ac7e-349c-e49a-70bb-31b9bc867b10@intel.com> <9b388f54f13b34fe684ef77603fc878952e48f87.camel@intel.com>
 <d98ca73b-2d2d-757d-e937-acc83cfedfb0@intel.com> <c90a10763969077826f42be6f492e3a3e062326b.camel@intel.com>
 <fc1ca04d94ad45e79c0297719d5ef50a7c33c352.camel@intel.com>
 <664f8adeb56ba61774f3c845041f016c54e0f96e.camel@intel.com>
 <1b681365-ef98-ec78-96dc-04e28316cf0e@intel.com> <8bf596b45f68363134f431bcc550e16a9a231b80.camel@intel.com>
 <6bb89ca6e7346f4334f06ea293f29fd12df70fe4.camel@intel.com>
 <CAPcyv4iP3hcNNDxNdPT+iB0E4aUazfqFWwaa_dtHpVf+qKPNcQ@mail.gmail.com>
 <cbb2ea1343079aee546fb44cd59c82f66c875d76.camel@intel.com>
 <CAPcyv4jNYqPA2HBaO+9a+ije4jnb6a3Sx_1knrmRF9HCCXQuqg@mail.gmail.com>
 <b40b3658e1fc7ec15d2adafe7f9562d42bc256f3.camel@intel.com>
 <CAPcyv4hdM+0zntuTez9n1-dJ_ODsF_TxAct=VpTs-tWJzBPJqQ@mail.gmail.com> <b0d1ed15d8bf99efe1c49182f4a98f4a23f61d0d.camel@intel.com>
In-Reply-To: <b0d1ed15d8bf99efe1c49182f4a98f4a23f61d0d.camel@intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 6 May 2022 08:57:32 -0700
Message-ID: <CAPcyv4gfRFUdeSqQE51BKdunJvNMP_DkvthDLvX9v7=kOrN8uA@mail.gmail.com>
Subject: Re: [PATCH v3 00/21] TDX host kernel support
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Mike Rapoport <rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 5, 2022 at 6:47 PM Kai Huang <kai.huang@intel.com> wrote:
>
> On Thu, 2022-05-05 at 18:15 -0700, Dan Williams wrote:
> > On Thu, May 5, 2022 at 5:46 PM Kai Huang <kai.huang@intel.com> wrote:
> > >
> > > On Thu, 2022-05-05 at 17:22 -0700, Dan Williams wrote:
> > > > On Thu, May 5, 2022 at 3:14 PM Kai Huang <kai.huang@intel.com> wrote:
> > > > >
> > > > > Thanks for feedback!
> > > > >
> > > > > On Thu, 2022-05-05 at 06:51 -0700, Dan Williams wrote:
> > > > > > [ add Mike ]
> > > > > >
> > > > > >
> > > > > > On Thu, May 5, 2022 at 2:54 AM Kai Huang <kai.huang@intel.com> wrote:
> > > > > > [..]
> > > > > > >
> > > > > > > Hi Dave,
> > > > > > >
> > > > > > > Sorry to ping (trying to close this).
> > > > > > >
> > > > > > > Given we don't need to consider kmem-hot-add legacy PMEM after TDX module
> > > > > > > initialization, I think for now it's totally fine to exclude legacy PMEMs from
> > > > > > > TDMRs.  The worst case is when someone tries to use them as TD guest backend
> > > > > > > directly, the TD will fail to create.  IMO it's acceptable, as it is supposedly
> > > > > > > that no one should just use some random backend to run TD.
> > > > > >
> > > > > > The platform will already do this, right?
> > > > > >
> > > > >
> > > > > In the current v3 implementation, we don't have any code to handle memory
> > > > > hotplug, therefore nothing prevents people from adding legacy PMEMs as system
> > > > > RAM using kmem driver.  In order to guarantee all pages managed by page
> > > >
> > > > That's the fundamental question I am asking why is "guarantee all
> > > > pages managed by page allocator are TDX memory". That seems overkill
> > > > compared to indicating the incompatibility after the fact.
> > >
> > > As I explained, the reason is I don't want to modify page allocator to
> > > distinguish TDX and non-TDX allocation, for instance, having to have a ZONE_TDX
> > > and GFP_TDX.
> >
> > Right, TDX details do not belong at that level, but it will work
> > almost all the time if you do nothing to "guarantee" all TDX capable
> > pages all the time.
>
> "almost all the time" do you mean?
>
> >
> > > KVM depends on host's page fault handler to allocate the page.  In fact KVM only
> > > consumes PFN from host's page tables.  For now only RAM is TDX memory.  By
> > > guaranteeing all pages in page allocator is TDX memory, we can easily use
> > > anonymous pages as TD guest memory.
> >
> > Again, TDX capable pages will be the overwhelming default, why are you
> > worried about cluttering the memory hotplug path for nice corner
> > cases.
>
> Firstly perhaps I forgot to mention there are two concepts about TDX memory, so
> let me clarify first:
>
> 1) Convertible Memory Regions (CMRs).  This is reported by BIOS (thus static) to
> indicate which memory regions *can* be used as TDX memory.  This basically means
> all RAM during boot for now.
>
> 2) TD Memory Regions (TDMRs).  Memory pages in CMRs are not automatically TDX
> usable memory.  The TDX module needs to be configured which (convertible) memory
> regions can be used as TDX memory.  Kernel is responsible for choosing the
> ranges, and configure to the TDX module.  If a convertible memory page is not
> included into TDMRs, the TDX module will report error when it is assigned to  a
> TD.
>
> >
> > Consider the fact that end users can break the kernel by specifying
> > invalid memmap= command line options. The memory hotplug code does not
> > take any steps to add safety in those cases because there are already
> > too many ways it can go wrong. TDX is just one more corner case where
> > the memmap= user needs to be careful. Otherwise, it is up to the
> > platform firmware to make sure everything in the base memory map is
> > TDX capable, and then all you need is documentation about the failure
> > mode when extending "System RAM" beyond that baseline.
>
> So the fact is, if we don't include legacy PMEMs into TDMRs, and don't do
> anything in memory hotplug, then if user does kmem-hot-add legacy PMEMs as
> system RAM, a live TD may eventually be killed.
>
> If such case is a corner case that we don't need to guarantee, then even better.
> And we have an additional reason that those legacy PMEMs don't need to be in
> TDMRs.  As you suggested,  we can add some documentation to point out.
>
> But the point we want to do some code check and prevent memory hotplug is, as
> Dave said, we want this piece of code to work on *ANY* TDX capable machines,
> including future machines which may, i.e. supports NVDIMM/CLX memory as TDX
> memory.  If we don't do any code check in  memory hotplug in this series, then
> when this code runs in future platforms, user can plug NVDIMM or CLX memory as
> system RAM thus break the assumption "all pages in page allocator are TDX
> memory", which eventually leads to live TDs being killed potentially.
>
> Dave said we need to guarantee this code can work on *ANY* TDX machines.  Some
> documentation saying it only works one some platforms and you shouldn't do
> things on other platforms are not good enough:
>
> https://lore.kernel.org/lkml/cover.1649219184.git.kai.huang@intel.com/T/#m6df45b6e1702bb03dcb027044a0dabf30a86e471

Yes, the incompatible cases cannot be ignored, but I disagree that
they actively need to be prevented. One way to achieve that is to
explicitly enumerate TDX capable memory and document how mempolicy can
be used to avoid killing TDs.

> > > shmem to support a new fd-based backend which doesn't require having to mmap()
> > > TD guest memory to host userspace:
> > >
> > > https://lore.kernel.org/kvm/20220310140911.50924-1-chao.p.peng@linux.intel.com/
> > >
> > > Also, besides TD guest memory, there are some per-TD control data structures
> > > (which must be TDX memory too) need to be allocated for each TD.  Normal memory
> > > allocation APIs can be used for such allocation if we guarantee all pages in
> > > page allocator is TDX memory.
> >
> > You don't need that guarantee, just check it after the fact and fail
> > if that assertion fails. It should almost always be the case that it
> > succeeds and if it doesn't then something special is happening with
> > that system and the end user has effectively opt-ed out of TDX
> > operation.
>
> This doesn't guarantee consistent behaviour.  For instance, for one TD it can be
> created, while the second may fail.  We should provide a consistent service.

Yes, there needs to be enumeration and policy knobs to avoid failures,
hard coded "no memory hotplug" hacks do not seem the right enumeration
and policy knobs to me.

> The thing is anyway we need to configure some memory regions to the TDX module.
> To me there's no reason we don't want to guarantee all pages in page allocator
> are TDX memory.
>
> >
> > > > > allocator are all TDX memory, the v3 implementation needs to always include
> > > > > legacy PMEMs as TDX memory so that even people truly add  legacy PMEMs as system
> > > > > RAM, we can still guarantee all pages in page allocator are TDX memory.
> > > >
> > > > Why?
> > >
> > > If we don't include legacy PMEMs as TDX memory, then after they are hot-added as
> > > system RAM using kmem driver, the assumption of "all pages in page allocator are
> > > TDX memory" is broken.  A TD can be killed during runtime.
> >
> > Yes, that is what the end user asked for. If they don't want that to
> > happen then the policy decision about using kmem needs to be updated
> > in userspace, not hard code that policy decision towards TDX inside
> > the kernel.
>
> This is also fine to me.  But please also see above Dave's comment.

Dave is right, the implementation can not just ignore the conflict. To
me, enumeration plus error reporting allows for flexibility without
hard coding policy in the kernel.
