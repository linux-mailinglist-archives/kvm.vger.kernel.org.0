Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472D44D0C4A
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 00:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344034AbiCGXuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 18:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344094AbiCGXuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 18:50:44 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A5931534
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 15:49:34 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id bu29so29266697lfb.0
        for <kvm@vger.kernel.org>; Mon, 07 Mar 2022 15:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+HV+Ci0qJtjgVMkQdTkkYhKKFn98HHEwEQ3QOExliA8=;
        b=k+XbHid5SoPRF9RbXl4EtPmVI98v19t1I1vtT5E5dQJO6WaUSx35+h51vHqhYs20rr
         Dg5tfI1ikotcHxP0LJiohsks2iUf4bU+R35/5Iyt+eF4QExNKgPt5Nkkqhe58zgBz4xE
         Ym8FTkJb1dTM25hqOp/7uS9quUqOQEGBgldLOD9XX+bQbdNZ/o3D/g2MycVI+oFvG1CH
         emgECcn5XFNw1QgcpX3J+QoNsihAmc0N0JA95u3aziuHxOywwJSWmSY+6dP6gyBvw+3V
         lR2PEt7xHNGQ7pe1uL4po/24+RECG6DUF5j+w+Aaz1tGAn45vcZAEtXyrzCPVBClEHAG
         rD+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+HV+Ci0qJtjgVMkQdTkkYhKKFn98HHEwEQ3QOExliA8=;
        b=XpxPTcWdefCgOZvUYbYc2kxRWhHqtvAUcC+Uy9kMpQO4/RifO095Mzt3CZA+niJYQx
         lXzb/ShSgYJeDEnDnjwlfjiPwaOR4acrobncVC8ZK24t20YDb8DW8tewWbNuVj1ztOYo
         MdCOhgNzOwW6O6YV/w68R3FMVkkywo0t3aPf+LQmG1sxXfvaskEj0DN7Z22n1ZR4T7Vh
         T/UqqUgLbhfmfhpY16eg0lY2KS/Q1Y5uh7kYaQtOFyY8pVswPESvMwxGkNQreI19/JE5
         LuvDx7lfa+d7QZlCC/Fo7OdiG9F1BYqN2kQ7wRsUC+uQvS6krpiGjAVBX1sWXVTDNbVE
         eTsA==
X-Gm-Message-State: AOAM532N7QELKqnTP0oJebI5hCV9FD38+5coR79LHZOdaRPZaYqpy53g
        ux10BTfYBLZlg1VLOXcwWZ/mjSnR1ZW41W37Q98jJw==
X-Google-Smtp-Source: ABdhPJxaPxjN8MsjQmHlhG3pV8/RqCE6os3e5JBxXe0ADfI4+gDRpEkfNIVcZzgycBHxAaBCqqHU93F3FCgtqyeE28M=
X-Received: by 2002:a19:674c:0:b0:448:3f49:e6d5 with SMTP id
 e12-20020a19674c000000b004483f49e6d5mr326936lfj.518.1646696972615; Mon, 07
 Mar 2022 15:49:32 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <20220203010051.2813563-20-dmatlack@google.com>
 <8735k84i6f.wl-maz@kernel.org> <CALzav=d9dRWCV=R8Ypvy4KzgzPQvd-7qhGTbxso5r9eTh9kkqw@mail.gmail.com>
 <CALzav=ccRmvCB+FsN64JujOVpb7-ocdzkiBrYLFGFRQUa7DbWQ@mail.gmail.com> <878rtotk3h.wl-maz@kernel.org>
In-Reply-To: <878rtotk3h.wl-maz@kernel.org>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 7 Mar 2022 15:49:06 -0800
Message-ID: <CALzav=e7vH87uyphgL8vXPMmn8vX8TmkpUY_3OWuRXrKFhy_ag@mail.gmail.com>
Subject: Re: [PATCH 19/23] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 5, 2022 at 8:55 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 04 Mar 2022 21:59:12 +0000,
> David Matlack <dmatlack@google.com> wrote:
> >
> > On Thu, Feb 24, 2022 at 11:20 AM David Matlack <dmatlack@google.com> wrote:
> > >
> > > On Thu, Feb 24, 2022 at 3:29 AM Marc Zyngier <maz@kernel.org> wrote:
> > > >
> > > > On Thu, 03 Feb 2022 01:00:47 +0000,
> > > > David Matlack <dmatlack@google.com> wrote:
> > > > >
> >
> > [...]
> >
> > > > >
> > > > >       /* Cache some mmu pages needed inside spinlock regions */
> > > > > -     struct kvm_mmu_memory_cache mmu_page_cache;
> > > > > +     DEFINE_KVM_MMU_MEMORY_CACHE(mmu_page_cache);
> > > >
> > > > I must say I'm really not a fan of the anonymous structure trick. I
> > > > can see why you are doing it that way, but it feels pretty brittle.
> > >
> > > Yeah I don't love it. It's really optimizing for minimizing the patch diff.
> > >
> > > The alternative I considered was to dynamically allocate the
> > > kvm_mmu_memory_cache structs. This would get rid of the anonymous
> > > struct and the objects array, and also eliminate the rather gross
> > > capacity hack in kvm_mmu_topup_memory_cache().
> > >
> > > The downsides of this approach is more code and more failure paths if
> > > the allocation fails.
> >
> > I tried changing all kvm_mmu_memory_cache structs to be dynamically
> > allocated, but it created a lot of complexity to the setup/teardown
> > code paths in x86, arm64, mips, and riscv (the arches that use the
> > caches). I don't think this route is worth it, especially since these
> > structs don't *need* to be dynamically allocated.
> >
> > When you said the anonymous struct feels brittle, what did you have in
> > mind specifically?
>
> I can perfectly see someone using a kvm_mmu_memory_cache and searching
> for a bit why they end-up with memory corruption. Yes, this would be a
> rookie mistake, but this are some expectations all over the kernel
> that DEFINE_* and the corresponding structure are the same object.

That is a good point. And that risk is very real given that
kvm_mmu_topup_memory_cache() assumes the capacity is
KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE if the capacity field is 0.

One way to mitigate this would be to get rid of the capacity hack in
kvm_mmu_topup_memory_cache() and require the capacity field be
explicitly initialized. That will make it harder to trip over this
and/or easier to debug because kvm_mmu_topup_memory_cache() can issue
a WARN() if the capacity is 0. Once you see that warning and go to
initialize the capacity field you'll realize why it needs to be set in
the first place. The diff will just be slightly larger to set capacity
for each cache.

>
> [...]
>
> > I see two alternatives to make this cleaner:
> >
> > 1. Dynamically allocate just this cache. The caches defined in
> > vcpu_arch will continue to use DEFINE_KVM_MMU_MEMORY_CACHE(). This
> > would get rid of the outer struct but require an extra memory
> > allocation.
> > 2. Move this cache to struct kvm_arch using
> > DEFINE_KVM_MMU_MEMORY_CACHE(). Then we don't need to stack allocate it
> > or dynamically allocate it.
> >
> > Do either of these approaches appeal to you more than the current one?
>
> Certainly, #2 feels more solid. Dynamic allocations (and the resulting
> pointer chasing) are usually costly in terms of performance, so I'd
> avoid it if at all possible.
>
> That being said, if it turns out that #2 isn't practical, I won't get
> in the way of your current approach. Moving kvm_mmu_memory_cache to
> core code was definitely a good cleanup, and I'm not overly excited
> with the perspective of *more* arch-specific code.

Ok I'll play with #2. Thanks for the feedback.

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
