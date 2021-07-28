Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94033D94AA
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 19:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhG1RzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 13:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbhG1RzP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 13:55:15 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDBEC061757
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 10:55:13 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id x15-20020a05683000cfb02904d1f8b9db81so2928325oto.12
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 10:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Zr0A5rYm7/3ByPoV6QgcMjy1AiPNIz1rGA7A6PPNK8=;
        b=q0YiAHqChPYJcUln95K5hRqhPpZyFaXuePIjuB36mJ9QQ0S0L3mi6tbwPSvUbDlwsT
         diMY+9VkKqOylQeP/wHOwsj+BdkrlHw2f7bs/pFasVy131LxV5hZxXK37sfUE3YjXc0d
         agtHJEsu7BmyaTTqRDdrirYdItf0wHoAXe1UGbB954zoSsS4Y9f6nOCEkwmw3FCkPauZ
         jvYoUm0TbZKgBFe033bPInq9drg4iti+xGhqRuQOcAdg1Nscynu/PHygZ3hMOkX8n50G
         /mmHzVoKeZIcb0THErabg/coB8yUScfJk4j3Vwcb257Ex6ronsS0mNJOwIy0/Ko4Sw93
         H51w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Zr0A5rYm7/3ByPoV6QgcMjy1AiPNIz1rGA7A6PPNK8=;
        b=mL72qbKb1w+sWbZuKVc+joPNs2KzHixuhRJYNs6tmxbtEefNs2sHhz1jOGv4xqcP9i
         Ir7BovSQsMcF9xb3YmUtPQY+diW3CyrnqP9d0zpoVYKNA5ZS8hNMQKLuR4JchGdWv00C
         b60And4IqviI8IQLSiadNm2gyOOXQaFExJy0DWLPkfjW0gIXEI+1oD7c3mZhJHZaUmCe
         pYUKTutHvoiuCf13ck2fJ6o0TzooFD20GIp/qj5jH7EHxWMxgvyLfqwF9vKFlbeZgijo
         bPRrH+Ww5vO6sgI0gSZSmziNTLEdKE5yhuUlIpdS+cWuUsnB+cWU5ikMF1w1Y1/pAuZe
         PAmA==
X-Gm-Message-State: AOAM5319S8VEMMsuZePIdWPFnkWrQRetwQruGMtH23q+24WIdehCFRfj
        8ABL23grWQOqSpe600X0hBUwOmkg8MazFY+TU5lRRQ==
X-Google-Smtp-Source: ABdhPJwZ3Afsmsr7Qat++dfFp3p5oZEMZDVy+aatS8iACVP8aQt+CseLqNuJpyKcbmIy/pw/itSAfw35fiSVtfKgOnQ=
X-Received: by 2002:a05:6830:242f:: with SMTP id k15mr909935ots.72.1627494912679;
 Wed, 28 Jul 2021 10:55:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210727161957.lxevvmy37azm2h7z@linux.intel.com>
 <YQBLZ/RrBFxE4G4w@google.com> <20210728065605.e4ql2hzrj5fkngux@linux.intel.com>
 <20210728072514.GA375@yzhao56-desk.sh.intel.com> <CANgfPd_Rt3udm8mUHzX=MaXPOafkXhUt++7ACNsG1PnPiLswnw@mail.gmail.com>
 <20210728172241.aizlvj2alvxfvd43@linux.intel.com>
In-Reply-To: <20210728172241.aizlvj2alvxfvd43@linux.intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 28 Jul 2021 10:55:01 -0700
Message-ID: <CANgfPd_o+HC80aqTQn7CA3o4rN2AFPDUp_Jxj9CQ6Rie9+yAug@mail.gmail.com>
Subject: Re: A question of TDP unloading.
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 10:23 AM Yu Zhang <yu.c.zhang@linux.intel.com> wrote:
>
> On Wed, Jul 28, 2021 at 09:23:53AM -0700, Ben Gardon wrote:
> > On Wed, Jul 28, 2021 at 12:40 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >
> > > On Wed, Jul 28, 2021 at 02:56:05PM +0800, Yu Zhang wrote:
> > > > Thanks a lot for your reply, Sean.
> > > >
> > > > On Tue, Jul 27, 2021 at 06:07:35PM +0000, Sean Christopherson wrote:
> > > > > On Wed, Jul 28, 2021, Yu Zhang wrote:
> > > > > > Hi all,
> > > > > >
> > > > > >   I'd like to ask a question about kvm_reset_context(): is there any
> > > > > >   reason that we must alway unload TDP root in kvm_mmu_reset_context()?
> >
> > I just realized I sent my response to Yu yesterday without reply-all.
> > Sending it again here for posterity. I'll add comments on the
> > discussion inline below too.
>
> Thanks Ben, I copied my reply here. With some gramar fixes. :)
>
> >
> > Hi Yu,
> >
> > I think the short answer here is no, there's no reason we can't keep
> > the root around for later.
> >
> > When developing the TDP MMU, we were primarily concerned about
> > performance post-boot, especially during migration or when
> > re-populating memory for demand paging. In these scenarios the guest
> > role doesn't really change and so the TDP MMU's shadow page tables
> > aren't torn down. In my initial testing, I thought I only ever
> > observed two TDP MMU roots be allocated over the life of the VM, but I
> > could be wrong.
>
> Well I observed more, may be because I am using OVMF? Note, the vCPU
> number is just one in my test.

Having just one vCPU is likely to lead to more thrash, but I'm
guessing a lot of these transitions happen before the guest starts
using multiple vCPUs anyway.

>
> >
> > For the TDP MMU root to be torn down, there also has to be no vCPU
> > using it. This probably happens in transitions to SMM and guest root
> > level changes, but I suspected that there would usually be at least
> > one vCPU in some "normal" mode, post boot. That may have been an
> > incorrect assumption.
> >
> > I think the easiest solution to this would be to just have the TDP MMU
> > roots track the life of the VM by adding an extra increment to their
> > reference count on allocation and an extra decrement when the VM is
> > torn down. However this introduces a problem because it increases the
> > amount of memory the TDP MMU is likely to be using for its page
> > tables. (It could use the memory either way but it would require some
> > surprising guest behavior.)
>
> So your suggestion is, once allocated, do not free the root page until
> the VM is destroyed?

Yeah, this wouldn't be a great solution for a production setting but
if you just want to quantify the impact of teardown it's an easy hack.

>
> >
> > I have a few questions about these unnecessary tear-downs during boot:
> > 1. How many teardowns did you observe, and how many different roles
> > did they represent? Just thrashing between two roles, or 12 different
> > roles?
>
> I saw 106 reloadings of the root TDP. Among them, 14 are caused by memslot
> changes. Remaining ones are caused by the context reset from CR0/CR4/EFER
> changes(85 for CR0 changes). And I believe most are using the same roles,
> because in legacy TDP, only 4 different TDP roots are allocated due to the
> context reset(and several more are caused by memslot updating). But in TDP
> MMU, that means 106 times of TDP root being torn down and reallocated.
>
> > 2. When the TDP MMU's page tables got torn down, how much memory did
> > they map / how big were they?
>
> I did not collect this in TDP MMU, but I once tried with legacy TDP. IIRC,
> there are only several SPs allocated in one TDP table when the context resets.

Ooof that's a lot of resets, though if there are only a handful of
pages mapped, it might not be a noticeable performance impact. I think
it'd be worth collecting some performance data to quantify the impact.

>
> > 3. If you hacked in the extra refcount increment I suggested above,
> > how much of a difference in boot time does it make?
>
> I have not tried this, but I think that proposal is let TDP MMU try to
> reuse previous root page with same mmu role with current context, just
> like the legacy TDP does?

Yeah, exactly. The TDP MMU is actually already designed to do this,
but it depends on another vCPU keeping the root's refcount elevated to
keep the root around.

>
> Actually I am curious, why would the root needs to be unloaded at all(even
> in the legacy TDP code)? Sean's reply mentioned that change of the mmu role
> is the reason, but I do not understand yet.

Will follow up on this below.

>
> >
> > For 2 and 3 I ask because if the guest hasn't accessed much of it's
> > memory early in boot, the paging structure won't be very large and
> > tearing it down / rebuilding it is pretty cheap.
>
> Agree. But I am a bit surprised to see so many CR0 changes in the boot time.
>
> >
> > We may find that we need some kind of page quota for the TDP MMU after
> > all, if we want to have a bunch of roots at the same time. If that's
> > the case, perhaps we should spawn another email thread to discuss how
> > that should work.
>
> Could we find a way to obviate the requirement of unloading(if unnecessary)?

Could you be more specific about what you mean by unloading? Do you
mean just not using the current paging structure for a bit or tearing
down the whole paging structure?

>
> >
> > Thanks for raising this issue!
> > Ben
> >
> > > > >
> > > > > The short answer is that mmu_role is changing, thus a new root shadow page is
> > > > > needed.
> > > >
> > > > I saw the mmu_role is recalculated, but I have not figured out how this
> > > > change would affect TDP. May I ask a favor to give an example? Thanks!
> >
> > One really simple example is if the guest started using SMM. In that
> > case it's a totally different address space, so we need a new EPT.
>
> Yes. I admit unloading the MMU is necessary for SMM. But what about the other
> scenarios? :)

I think there are certainly scenarios where unloading is not needed
but we do it anyway. There are probably many cases where there's room
for optimization here.
Knowing when it's okay to avoid the reload can be super complicated so
it's probably mostly a case of people not having had the time / perf
motivation to track down the details.
A reload once, early in boot, is probably cheap enough that you'd only
notice it doing a very directed microbenchmark. If not it'd certainly
be worth fixing.

>
> >
> > > >
> > > > I realized that if we only recalculate the mmu role, but do not unload
> > > > the TDP root(e.g., when guest efer.nx flips), base role of the SPs will
> > > > be inconsistent with the mmu context. But I do not understand why this
> > > > shall affect TDP.
> >
> > It might not always cause problems since TDP is less sensitive to this
> > kind of thing than shadow paging, but getting all the details right is
> > hard so we just took the conservative approach of handling all role
> > changes with a new root.
>
> I have the same feeling, but I doubt if it will *never* cause any problem. :)
>
> Another impact I can think of is: without unloading, the root_hpa will not
> be set to INVALID_PAGE, hence the kvm_mmu_load() will not be called before
> vcpu entry(which may reload guest CR3/PDPTRs as well). But I have no idea
> if this could cause any trouble or not.
>
> B.R.
> Yu
