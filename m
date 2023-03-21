Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B7C6C3C09
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 21:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjCUUka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 16:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjCUUk2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 16:40:28 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3098C38B6F
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 13:40:24 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z4-20020a25bb04000000b00b392ae70300so17684252ybg.21
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 13:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679431223;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0VX2E2VBZDgPxkrBwL/o7IsICeL0Ay1k7ukDuibN754=;
        b=cO/TfLh+R21jum42uldyQsoc0byLEIbZo2aTYdGQ0UwhRAZwKM8devfr5JPlGBvMiL
         vHuBsxVUfdDfowGDb1TXE8z4n2phAj4My2jjmSZEGWgSUwgFYlyPYL/X30fRuT7S+tmQ
         WxhCjiPT5ppqUyMZYC2Km4iub2gHIpIkztrcA9+nKKX8980IRyiSPkmPdTsMFbmYCf6i
         GIfSD2ZToNIYl90qyf19vqQi7i9ZshDi2pVpVpkrQ7i0f0fOJmxEvIS/YtO0fDOR+nhU
         VvbXv55uHDeKrJuMzNPNuaA7lpU/T1Bb3+G1uwcbGpBQSNxJEHdTwb4EZT8Zu4Xh0J/J
         gu9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679431223;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0VX2E2VBZDgPxkrBwL/o7IsICeL0Ay1k7ukDuibN754=;
        b=rtpQCrauq+wXe4yMFb6/zycW3UyshdasJglJb44gSr09t6iPsnTtAVqDvqsAmQ6bTK
         n6UXOecKoGCbIdjttbyTU9P1ZeOWkYs8lT6q8/a2feRYrBoG8k0dIrqxSVDt0mDUChms
         IGc98OMHVaBwqTbgBtixctPwcsKQ6ssT2Il0+nvBAHir/zA0NSH5LUkWubSiUnfnV9fd
         Ieb104e4YDVf1oErbzJWeheMjs3t4UcDAUgDlS+NVFQiXeG2++FYLQOWVmcMRwNWUVFi
         DQa/Njvr+9haxd74G5bU2tHqlsO+tZkdXLmPdGZo7DDvtdXQJSRQq5IIEcJnQA+lLBtj
         EHxA==
X-Gm-Message-State: AAQBX9cykpXy+gWw8wvWArL2Y2Pztmelb1HzeJmbNY14m5gu5nkCh4wu
        DYLjF5B0a5BdF6FLoHTXj9IYdAFn+Dc=
X-Google-Smtp-Source: AKy350YxucAejzFE+MvN2YR+VKNN6JvkSM+4jcZN3l6smrHeyez9vPSHpHLwK7WhRO/FCwCRBLNPKCbOWVg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ad11:0:b0:544:51f7:83c5 with SMTP id
 l17-20020a81ad11000000b0054451f783c5mr1993947ywh.1.1679431223453; Tue, 21 Mar
 2023 13:40:23 -0700 (PDT)
Date:   Tue, 21 Mar 2023 13:40:21 -0700
In-Reply-To: <ZBoMIJipRtmvsNXg@google.com>
Mime-Version: 1.0
References: <20230211014626.3659152-1-vipinsh@google.com> <ZBTwX5790zwl5721@google.com>
 <ZBj9L2VUjEbWbgcS@google.com> <CAHVum0feM8hnD-+dXF4jiug8tmpm9GBAh619Xf279LNSm=Jozw@mail.gmail.com>
 <ZBoMIJipRtmvsNXg@google.com>
Message-ID: <ZBoWNdwGho5bZ+Kz@google.com>
Subject: Re: [Patch v3 0/7] Optimize clear dirty log
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, bgardon@google.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023, Sean Christopherson wrote:
> On Tue, Mar 21, 2023, Vipin Sharma wrote:
> > On Mon, Mar 20, 2023 at 5:41=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Fri, Mar 17, 2023, Sean Christopherson wrote:
> > > > Did a cursory glance, looks good.  I'll do a more thorough pass nex=
t week and get
> > > > it queued up if all goes well.  No need for a v4 at this point, I'l=
l fixup David's
> > > > various nits when applying.
> > >
> > > Ooof, that ended up being painful.  In hindsight, I should have asked=
 for a v4,
> > > but damage done, and it's my fault for throwing you a big blob of cod=
e in the
> > > first place.
> > >
> > > I ended up splitting the "interesting" patches into three each:
> > >
> > >   1. Switch to the atomic-AND
> > >   2. Drop the access-tracking / dirty-logging (as appropriate)
> > >   3. Drop the call to __handle_changed_spte()
> > >
> > > because logically they are three different things (although obviously=
 related).
> > >
> > > I have pushed the result to kvm-x86/mmu, but haven't merged to kvm-x8=
6/next or
> > > sent thanks because it's not yet tested.  I'll do testing tomorrow, b=
ut if you
> > > can take a look in the meantime to make sure I didn't do something co=
mpletely
> > > boneheaded, it'd be much appreciated.
> >=20
> >=20
> > Thanks for refactoring the patches. I reviewed the commits, no obvious
> > red flags from my side. Few small nits I found:
> >=20
> > commit e534a94eac07 ("KVM: x86/mmu: Use kvm_ad_enabled() to determine
> > if TDP MMU SPTEs need wrprot")
> >  - kvm_ad_enabled() should be outside the loop.
>=20
> Hmm, I deliberately left it inside the loop, but I agree that it would be=
 better
> to hoist it out in that commit.
>=20
> > commit 69032b5d71ef (" KVM: x86/mmu: Atomically clear SPTE dirty state
> > in the clear-dirty-log flow")
> >  - MMU_WARN_ON(kvm_ad_enabled() &&
> > spte_ad_need_write_protect(iter.old_spte) should be after
> > if(iter.level > PG_LEVEL_4k...)
>=20
> Ah, hrm.  This was also deliberate, but looking at the diff I agree that =
relative
> to the diff, it's an unnecessary/unrelated change.  I think what I'll do =
is
> land the assertion above the "if (iter.level > PG_LEVEL_4K ||" in the abo=
ve
> commit that switches to kvm_ad_enabled().  That way there shouldn't be an=
y change
> for the assertion in this commit.

Aha!  Even better, split this into yet one more patch to dedup the guts bef=
ore
switching to the atomic-AND, and give clear_dirty_gfn_range() the same trea=
tment.
That further isolates the changes, provides solid justification for hoistin=
g the
kvm_ad_enabled() check out of the loop (it's basically guaranteed to be a s=
ingle
memory read that hits the L1), and keeps clear_dirty_gfn_range() and
clear_dirty_pt_masked() as similar as is reasonably possible.

Speaking of which, I'll send a patch to remove the redundant is_shadow_pres=
ent_pte()
check in clear_dirty_gfn_range(), that's already handled by tdp_root_for_ea=
ch_leaf_pte().
