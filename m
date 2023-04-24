Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01436ED907
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 01:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbjDXXz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 19:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbjDXXzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 19:55:24 -0400
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBB349FD
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 16:55:23 -0700 (PDT)
Received: by mail-vk1-xa32.google.com with SMTP id 71dfb90a1353d-44062aa1b5bso1693045e0c.1
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 16:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682380522; x=1684972522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rIp06ywmX0lfxxI9OT2FwiSpXuGSU6q4dMRtZXHd20U=;
        b=VSR3MR/lpCZRqEQxMdSEB9m9wlwJlM3k+HH7FSqPbDpjJx977/r3olR7BuyQ3/16Ql
         s8N+sMD1s+jtsk7/62opG5ABBjstHJmiLhe2v+QPcsJ+U/zdXr2Z3t2A9kVGbazOWfL8
         kINMWjdo9ocOEikko54ju2zprRaNw0/ajTtKs/Ca4dWWPsh1p+O18xXpcFOAwDP39FcO
         GIeojA8KleffKcEUg3LwZ7FTdsFvR24laN4xb98+5yc/Suozu8MEQzdLhgGENfd2IjMe
         kvwjszy1Iq/D63qaYxsx9WTv3WWHMr7J0z1cSQArazTPgyrQDy+soL0bS74x1EuUYwSC
         mgsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682380522; x=1684972522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rIp06ywmX0lfxxI9OT2FwiSpXuGSU6q4dMRtZXHd20U=;
        b=PlX2Fc4Vr4EaW5VVDDGcU5RotQ5DwDa4ksTWbULrRGrbawyAuFVEHcdhriQHLgqeit
         waSo1AM3PNdvEs21slvTedcPOe4xL43whAb/uIzRNjI4aYPnq80XAwNMIhOTYhAtEc0Q
         vKTO+pV2IF9saFj+DUwXUAKIDAbYzQEIk1ChI+enom6Zc3sFwEN0KVvVdUs+iYV5B562
         8/XU8K2wwNYmznlo8x8EVFzk4y9mVF9yNDNuK4k0OVVDmIRuWio95ZtMXf/RgBJ6yxzi
         76mmk9c2riwgY+wdIirymwl3/KXVTmA2MbIwdqIlBSqUXeXRGtuSrEy5hEl1yZqnBGmF
         U+tg==
X-Gm-Message-State: AAQBX9eodCN97x4vTk79BjCF+HA0PRqZJfV8VexmtHnxb/1h8sWnWZ8U
        iU4S3ErlSCXoveyhW+qP5obPRkG5EzmmYJTHiWnr7w==
X-Google-Smtp-Source: AKy350ajS7Zyyl8dYKv9+2/hd1H3Pj9KTWPdcZoxEmEVlJ/pAtL7P8kNXRP16uhOeURa/a1kb//JjhBN+yuPxPJTRyY=
X-Received: by 2002:a1f:3fce:0:b0:43f:c5fc:b406 with SMTP id
 m197-20020a1f3fce000000b0043fc5fcb406mr3823429vka.5.1682380522423; Mon, 24
 Apr 2023 16:55:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230421214946.2571580-1-seanjc@google.com> <CALzav=f=TFoqpR5tPDPOujoO6Gix-+zL-sZyyZK27qJvGPP9dg@mail.gmail.com>
 <ZEM+09p7QBJR7DoI@google.com>
In-Reply-To: <ZEM+09p7QBJR7DoI@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 24 Apr 2023 16:54:56 -0700
Message-ID: <CALzav=cOB5rdwutrAa3eqFzHbdR-Dct0BAJWbExf1cTjUq2Mjw@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: Preserve TDP MMU roots until they are
 explicitly invalidated
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Fri, Apr 21, 2023 at 6:56=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Apr 21, 2023, David Matlack wrote:
> > On Fri, Apr 21, 2023 at 2:49=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > >  void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
> > >  {
> > >         struct kvm_mmu_page *root;
> > >
> > > -       lockdep_assert_held_write(&kvm->mmu_lock);
> > > -       list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
> > > -               if (!root->role.invalid &&
> > > -                   !WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root))) {
> > > +       /*
> > > +        * Note!  mmu_lock isn't held when destroying the VM!  There =
can't be
> > > +        * other references to @kvm, i.e. nothing else can invalidate=
 roots,
> > > +        * but walking the list of roots does need to be guarded agai=
nst roots
> > > +        * being deleted by the asynchronous zap worker.
> > > +        */
> > > +       rcu_read_lock();
> > > +
> > > +       list_for_each_entry_rcu(root, &kvm->arch.tdp_mmu_roots, link)=
 {
> >
> > I see that roots are removed from the list with list_del_rcu(), so I
> > agree this should be safe.
> >
> > KVM could, alternatively, acquire the mmu_lock in
> > kvm_mmu_uninit_tdp_mmu(), which would let us keep the lockdep
> > assertion and drop the rcu_read_lock() + comment. That might be worth
> > it in case someone accidentally adds a call to
> > kvm_tdp_mmu_invalidate_all_roots() without mmu_lock outside of VM
> > teardown. kvm_mmu_uninit_tdp_mmu() is not a particularly performance
> > sensitive path and adding the mmu_lock wouldn't add much overhead
> > anyway (it would block for at most a few milliseconds waiting for the
> > async work to reschedule).
>
> Heh, I actually started to ping you off-list to specifically discuss this=
 option,
> but then decided that not waiting those few milliseconds might be worthwh=
ile for
> some use cases.  I also couldn't quite convince myself that it would only=
 be a few
> milliseconds, e.g. if the worker is zapping a fully populated 5-level roo=
t, there
> are no other tasks scheduled on _its_ CPU, and CONFIG_PREEMPTION=3Dn (whi=
ch neuters
> rwlock_needbreak()).

Good point. At some point we're going to have to fix that.

>
> The other reason I opted for not taking mmu_lock is that, with the persis=
tent roots
> approach, I don't think it's actually strictly necessary for kvm_mmu_zap_=
all_fast()
> to invaliate roots while holding mmu_lock for write.  Holding slots_lock =
ensures
> that only a single task can be doing invalidations, versus the old model =
where
> putting the last reference to a root could happen just about anywhere.  A=
nd
> allocating a new root and zapping from mmu_noitifiers requires holding mm=
u_lock for
> write, so I _think_ we could getaway with holding mmu_lock for read.  May=
be.
>
> It's largely a moot point since kvm_mmu_zap_all_fast() needs to hold mmu_=
lock for
> write anyways to play nice with the shadow MMU, i.e. I don't expect us to=
 ever
> want to pursue a change in this area.  But at the same time I was struggl=
ing to
> write a comment explaining why the VM destruction path "had" to take mmu_=
lock.

Yeah, probably because it really isn't necessary :). It'd be nice to keep
around the lockdep assertion though for the other (and future)
callers. The cleanest options I can think of are:

1. Pass in a bool "vm_teardown" kvm_tdp_mmu_invalidate_all_roots() and
use that to gate the lockdep assertion.
2. Take the mmu_lock for read in kvm_mmu_uninit_tdp_mmu() and pass
down bool shared to kvm_tdp_mmu_invalidate_all_roots().

Both would satisfy your concern of not blocking teardown on the async
worker and my concern of keeping the lockdep check. I think I prefer
(1) since, as you point out, taking the mmu_lock at all is
unnecessary.
