Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695056C3B15
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 20:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjCUT5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 15:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjCUT52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 15:57:28 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0247923A7F
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 12:57:22 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 204-20020a250fd5000000b00b6d6655dc35so6022507ybp.6
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 12:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679428642;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MiypCBl0IDaRryt/YxFIweljGgieSnyIo2dWNnmsjjQ=;
        b=okcCvMv6Ww1nxIN+rhrgVDlupcKSfJfNCVkAnRzAGKnAfwqDYCcwNzlcSzOU31pOaC
         ylyhA5mn88HX8uGrhfM/sD/hVnExZLRbi4XnzfxlVhpn+l/1BsA8l5cLnWEavuBi9jji
         IeE7TnSuer2T5/+CqFJnKutSGAPACmWSr3NW8swj42LZ50wm42qjNshqTmKKLvrBIIj7
         vzcQj35I6/WawCJceNahBeqwljFDZVYf/Kale8huj+bqKV2VaUZQI9L5d+hJlUp7SGqv
         dk9YI1nDtDxNI7osg8xxu+2lx+yGfPGdwtmZ4Jc7p+k/WXjaM1AGStcXL1a4IOIOEeSH
         RmUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679428642;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MiypCBl0IDaRryt/YxFIweljGgieSnyIo2dWNnmsjjQ=;
        b=b1OkGrBYWv0pYHdBcu6h4rRPMN8gkDsLiQcGw2vUMjP+0FBj2qwKilFC3imaMFS9AR
         iJY7VMhe/7KFS9IpBOrEQWNOgtRRo0dFijWrifjpXDo5GCWDibDVA2m3Ey64YF6SUpKV
         hm9FcC0gnsmxMZhp3lGROdYIf785J2+Da/xN+72FKN6fUeoJeDiKpTO2AUgQpYktdesK
         n5eN7iI0H0RAQcbbRcmV0/oqxTuezpzobbCivrt7NhzRFGV9utp2c4pGF73o1jqE1+3X
         rZ0cWQ9hoba/0f2MeTLCkRUEZXIsiy8A6xyGf7CGtUUNw/ilWvdu0l8RXDVAJ/+PNSmh
         MEzg==
X-Gm-Message-State: AAQBX9cFwPtM9zViyAnQ93GDrpy2XaxQfPrKyoe2BcGTO6QSu85TqEo6
        MUNFCAm4/P122Z7wIZO/v59bIci/dac=
X-Google-Smtp-Source: AKy350bxapE6NR4K0XxcI0SLrIk3Qk4IPRYrLLkB0m/kvCendCvfpKumLS/YTyCaEDHsexdJOkQEHvABSlA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1003:b0:b3c:637f:ad00 with SMTP id
 w3-20020a056902100300b00b3c637fad00mr2494910ybt.5.1679428642184; Tue, 21 Mar
 2023 12:57:22 -0700 (PDT)
Date:   Tue, 21 Mar 2023 12:57:20 -0700
In-Reply-To: <CAHVum0feM8hnD-+dXF4jiug8tmpm9GBAh619Xf279LNSm=Jozw@mail.gmail.com>
Mime-Version: 1.0
References: <20230211014626.3659152-1-vipinsh@google.com> <ZBTwX5790zwl5721@google.com>
 <ZBj9L2VUjEbWbgcS@google.com> <CAHVum0feM8hnD-+dXF4jiug8tmpm9GBAh619Xf279LNSm=Jozw@mail.gmail.com>
Message-ID: <ZBoMIJipRtmvsNXg@google.com>
Subject: Re: [Patch v3 0/7] Optimize clear dirty log
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, bgardon@google.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023, Vipin Sharma wrote:
> On Mon, Mar 20, 2023 at 5:41=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Fri, Mar 17, 2023, Sean Christopherson wrote:
> > > Did a cursory glance, looks good.  I'll do a more thorough pass next =
week and get
> > > it queued up if all goes well.  No need for a v4 at this point, I'll =
fixup David's
> > > various nits when applying.
> >
> > Ooof, that ended up being painful.  In hindsight, I should have asked f=
or a v4,
> > but damage done, and it's my fault for throwing you a big blob of code =
in the
> > first place.
> >
> > I ended up splitting the "interesting" patches into three each:
> >
> >   1. Switch to the atomic-AND
> >   2. Drop the access-tracking / dirty-logging (as appropriate)
> >   3. Drop the call to __handle_changed_spte()
> >
> > because logically they are three different things (although obviously r=
elated).
> >
> > I have pushed the result to kvm-x86/mmu, but haven't merged to kvm-x86/=
next or
> > sent thanks because it's not yet tested.  I'll do testing tomorrow, but=
 if you
> > can take a look in the meantime to make sure I didn't do something comp=
letely
> > boneheaded, it'd be much appreciated.
>=20
>=20
> Thanks for refactoring the patches. I reviewed the commits, no obvious
> red flags from my side. Few small nits I found:
>=20
> commit e534a94eac07 ("KVM: x86/mmu: Use kvm_ad_enabled() to determine
> if TDP MMU SPTEs need wrprot")
>  - kvm_ad_enabled() should be outside the loop.

Hmm, I deliberately left it inside the loop, but I agree that it would be b=
etter
to hoist it out in that commit.

> commit 69032b5d71ef (" KVM: x86/mmu: Atomically clear SPTE dirty state
> in the clear-dirty-log flow")
>  - MMU_WARN_ON(kvm_ad_enabled() &&
> spte_ad_need_write_protect(iter.old_spte) should be after
> if(iter.level > PG_LEVEL_4k...)

Ah, hrm.  This was also deliberate, but looking at the diff I agree that re=
lative
to the diff, it's an unnecessary/unrelated change.  I think what I'll do is
land the assertion above the "if (iter.level > PG_LEVEL_4K ||" in the above
commit that switches to kvm_ad_enabled().  That way there shouldn't be any =
change
for the assertion in this commit.

> commit 93c375bb6aea ("KVM: x86/mmu: Bypass __handle_changed_spte()
> when clearing TDP MMU dirty bits")
>  - Needs new performance numbers. Adding MMU_WARN_ON() might change
> numbers. I will run a perf test on your mmu branch and see if
> something changes a lot.

It won't.  MMU_WARN_ON() is dead code without manual modification to define=
 MMU_DEBUG.
Part of the reason I used MMU_WARN_ON() was to remind myself to send a patc=
h/series
to overhaul MMU_WARN_ON[*].  My thought/hope is that a Kconfig will allow d=
evelopers
and testers to run with a pile of assertions and sanity checks without impa=
cting
the runtime overhead for production builds.

[*] https://lore.kernel.org/all/Yz4Qi7cn7TWTWQjj@google.com/
