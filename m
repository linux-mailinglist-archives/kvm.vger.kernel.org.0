Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC174CB53B
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 04:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbiCCC7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 21:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbiCCC7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 21:59:17 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC195DCE36;
        Wed,  2 Mar 2022 18:58:31 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id q8so4293198iod.2;
        Wed, 02 Mar 2022 18:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1H4fbbodFL+rmUux9zr3IzveyrIH4qejmueZOopSFSg=;
        b=Kn+3avd5LqetsWkpBJPiPKBACwyOVorChnB4+tsXtro6mJbJwxoOae6JK/+rNostCe
         uRhMqiHPo6muvKqG8tnESlPH+sSQ/mPAx+RbLdL3ghK/rZ7LrzIDKmfbysWgesD2BVIg
         1HfpkwiZzz2L/0zkG0QiJp68z7HD7QneSTYYGUv121SuQmYtCS1QpRFuTCHG8/ilZx1r
         neFmOCkEQtcOi3diu1HXk/OapCAsP00TDyPU6ZxqdgLXHzZng1RbhQqCwzQXVNhRlESQ
         5TN+43LGAAvIQihac/wibSwGwMMGgMMSdbhdK7mzlEmnrAAG4WAubdPun3XQiXoMJB8u
         Ufqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1H4fbbodFL+rmUux9zr3IzveyrIH4qejmueZOopSFSg=;
        b=eFtj1vDvx4CDVaXQC9KySuO7bO+3IryH0e5rQQ/iuQ680a2Vlsw/tYp+Xs950tf4aG
         MWtS1ejsq9C24mPSDMjEjkz3YjnwKKvWE7eglF2GICmI28UxFeRCxErDuXz85qyvpe46
         puO4tCRK2BuvgjclFhpKBKbS5YkQo+r6pl09wJf+sjuzlqWxoOi4wOllIY8n5ajPEnv9
         e02VjMQ0RZuZ3125jAyWrp0mSmtJB9acZBmkhLN906wvZTjFVdLbFZxshfIPMOgkyrGZ
         6VC8HZ1YbxT8RkSO0CJNdtxrk6q9hYeBBr3/pEyjh+GoArLp/mEvrCtekJW6E99oTiTA
         8nug==
X-Gm-Message-State: AOAM530SAjHhUyv0b9khqR7FeFTpfw57yWTdXrAHjVbywPV+uG6yCzCw
        cPU7RCUkzogc5HTYNF96nzeLiCBQNZYi1bnaYlQ=
X-Google-Smtp-Source: ABdhPJxM6u0ZGEggPTQ7pSChdE1EmALRR0gWb+iKx5lq+RjU2pcSXVpp3RaJkXEUJoBpFdnEytRHi9oB99BOzhOGQZM=
X-Received: by 2002:a02:a984:0:b0:317:36c9:b572 with SMTP id
 q4-20020a02a984000000b0031736c9b572mr14083601jam.252.1646276311176; Wed, 02
 Mar 2022 18:58:31 -0800 (PST)
MIME-Version: 1.0
References: <20220301063756.16817-1-flyingpeng@tencent.com>
 <Yh5d7XBD9D4FhEe3@google.com> <CAPm50a+p2pSjExDwPmGpZ_aTuxs=x6RZ4-AAD19RDQx2o-=NCw@mail.gmail.com>
 <YiAZ3wTICeLTVnJz@google.com>
In-Reply-To: <YiAZ3wTICeLTVnJz@google.com>
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Thu, 3 Mar 2022 10:56:59 +0800
Message-ID: <CAPm50aLJ51mm9JVpTMQCkNENX_9-Do5UeH5zxu-5byOcOFsJBg@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: Improve virtual machine startup performance
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 3, 2022 at 9:29 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Mar 02, 2022, Hao Peng wrote:
> > On Wed, Mar 2, 2022 at 1:54 AM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, Mar 01, 2022, Peng Hao wrote:
> > > >  From: Peng Hao <flyingpeng@tencent.com>
> > > >
> > > > vcpu 0 will repeatedly enter/exit the smm state during the startup
> > > > phase, and kvm_init_mmu will be called repeatedly during this process.
> > > > There are parts of the mmu initialization code that do not need to be
> > > > modified after the first initialization.
> > > >
> > > > Statistics on my server, vcpu0 when starting the virtual machine
> > > > Calling kvm_init_mmu more than 600 times (due to smm state switching).
> > > > The patch can save about 36 microseconds in total.
> > > >
> > > > Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> > > > ---
> > > > @@ -5054,7 +5059,7 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > > >  void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
> > > >  {
> > > >       kvm_mmu_unload(vcpu);
> > > > -     kvm_init_mmu(vcpu);
> > > > +     kvm_init_mmu(vcpu, false);
> > >
> > > This is wrong, kvm_mmu_reset_context() is the "big hammer" and is expected to
> > > unconditionally get the MMU to a known good state.  E.g. failure to initialize
> > > means this code:
> > >
> > >         context->shadow_root_level = kvm_mmu_get_tdp_level(vcpu);
> > >
> > > will not update the shadow_root_level as expected in response to userspace changing
> > > guest.MAXPHYADDR in such a way that KVM enables/disables 5-level paging.
> > >
> > Thanks for pointing this out. However, other than shadow_root_level,
> > other fields of context will not
> > change during the entire operation, such as
> > page_fault/sync_page/direct_map and so on under
> > the condition of tdp_mmu.
> > Is this patch still viable after careful confirmation of the fields
> > that won't be modified?
>
> No, passing around the "init" flag is a hack.
>
> But, we can achieve what you want simply by initializing the constant data once
> per vCPU.  There's a _lot_ of state that is constant for a given MMU now that KVM
> uses separate MMUs for L1 vs. L2 when TDP is enabled.  I should get patches posted
> tomorrow, just need to test (famous last words).
>
> Also, based on the number of SMM transitions, I'm guessing you're using SeaBIOS.
> Have you tried disabling CONFIG_CALL32_SMM, or CONFIG_USE_SMM altogether?  That
> might be an even better way to improve performance in your environment.
>

Both options are disabled in guest.
> Last question, do you happen to know why eliminating this code shaves 36us?  The
> raw writes don't seem like they'd take that long.  Maybe the writes to function
> pointers trigger stalls or mispredicts or something?  If you don't have an easy
> answer, don't bother investigating, I'm just curious.

I'm guessing it's because of the cache. At first, I wanted to replace
it with memcpy, if the modified fields are continuous enough, I can
use instructions such as erms/fsrm.
