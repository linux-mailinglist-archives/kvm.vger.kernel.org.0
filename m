Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E67669B18
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 15:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjAMO6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 09:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjAMO5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 09:57:38 -0500
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6447BCFA
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 06:44:07 -0800 (PST)
Received: by mail-vk1-xa34.google.com with SMTP id l185so7093415vke.2
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 06:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NauUNFAcFTRwuvUiWUBd0XNhINI7VO3NGs/9L4ynMtE=;
        b=bkfjL2WGNDY/KQKg+5UoWRNxkXpr1kTKXOT5XirVwYB3BcMqCJCgJloLHzk7GSHs6F
         e2cZ5cWhEyeKGUi1mF/argbVVzphNpNDeDkmfv/zi4EmI+eULm0np3y6VNZNkXXn+UmT
         m6v+9kK+qoJcZwVP1eWaIz8BdG/h6HZ6jnmBv1mSd83opImUtJ54luRNI15Hex2zRTJN
         20sIq44RwrCwvjHurOClmqRx9aWkto8TFTZFfziXhfNUteg4z67hf0bvkabRWPcJyTKt
         jiTVW9gRVmwGdPOLpN7P41o6QJQrBQqBzRaIajK2NzcPatzXrLYL+W0xF8K/ZOguyDls
         vS+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NauUNFAcFTRwuvUiWUBd0XNhINI7VO3NGs/9L4ynMtE=;
        b=ScHK1hKpqN9ApiENVsVmH+xn3upyVXY0Fw2pBQnzJX42znvTJqZhy96srSFPw9RfC7
         dvoNgF+ahjoZQJPpROUdvQGw/A9T4PKmGEUV/eS1WOuug9vaZKP7ojfDZtFYtSh9Cv8V
         +Y89Dsc3fa4s7CCb0f73dHUxZUy+fwWsO2sflIJShFfLV8bJWB1YVdq9wp4PxAH+5zLX
         NVuUwSucNaAVQNXG9F3JAYZAuDR7brBtc1CFnZoM4/12qbMfexZJo7QGyHKZ4DiTOH2d
         jRA64R4BJQgK8CYgOTkvbnFvlEHQenvbn3aCTZZVOAn8NWgBRum2gQC3XHO+jk63c03b
         3PqA==
X-Gm-Message-State: AFqh2krt/6mbAX4KRvMfqvXQklVqCYlHj9tETNwgDGWXr9Pqu0agW1nI
        uWIY+vbF5IuQXIQGVeqyUHX9Bj6rRAAvWUoUSeuyqWqqJua6RW4J
X-Google-Smtp-Source: AMrXdXuj7tM51vsWN0DWg58zJ2mRvZ2YSYB4HknaiZkWqA/DtZHdnu5XqQRdY2+7iNjUt12JZG/dbOWu6hC8LX0h7ok=
X-Received: by 2002:a1f:2c0c:0:b0:3d0:a401:5ee9 with SMTP id
 s12-20020a1f2c0c000000b003d0a4015ee9mr10379847vks.38.1673621046440; Fri, 13
 Jan 2023 06:44:06 -0800 (PST)
MIME-Version: 1.0
References: <20221230162442.3781098-1-aaronlewis@google.com>
 <20221230162442.3781098-2-aaronlewis@google.com> <Y7R36wsXn3JqwfEv@google.com>
 <CAAAPnDHff-2XFdAgKdfTQnG_a4TCVqWN9wxEhUtiOfiOVMuRWA@mail.gmail.com>
 <c87904cb-ce6d-1cf4-5b58-4d588660e20f@intel.com> <Y8BPs2269itL+WQe@google.com>
 <a1308e46-c319-fb73-1fde-eb3b071c10e8@intel.com> <Y8Bcr9VBA/VLjAwd@google.com>
 <6f22cb44-1a29-cb41-51e3-cbe532686c54@intel.com> <Y8B5xIVChfatMio0@google.com>
 <f65d284f-4f06-739b-a555-37d2811acdf3@intel.com> <CAL715WKmJ1BSozF18MOp=jRvMh-28fLWqBJvg87MaK8aOh33cA@mail.gmail.com>
In-Reply-To: <CAL715WKmJ1BSozF18MOp=jRvMh-28fLWqBJvg87MaK8aOh33cA@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Fri, 13 Jan 2023 14:43:55 +0000
Message-ID: <CAAAPnDH21dqmHqiM2E3ph-qyEardx4-OkgRzRa27Qc3u2KQ+Zw@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
To:     Mingwei Zhang <mizhang@google.com>
Cc:     "Chang S. Bae" <chang.seok.bae@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, "bp@suse.de" <bp@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 13, 2023 at 12:26 AM Mingwei Zhang <mizhang@google.com> wrote:
>
> On Thu, Jan 12, 2023 at 1:33 PM Chang S. Bae <chang.seok.bae@intel.com> wrote:
> >
> > On 1/12/2023 1:21 PM, Mingwei Zhang wrote:
> > >
> > > The only comment I would have is that it seems not following the least
> > > privilege principle as host process (QEMU) may not have the motivation
> > > to do any matrix multiplication. But this is a minor one.
> > >
> > > Since this enabling once per-process, I am wondering when after
> > > invocation of arch_prctl(2), all of the host threads will have a larger
> > > fp_state? If so, that might be a sizeable overhead since host userspace
> > > may have lots of threads doing various of other things, i.e., they may
> > > not be vCPU threads.
> >
> > No, the permission request does not immediately result in the kernel's
> > XSAVE buffer expansion, but only when the state is about used. As
> > XFD-armed, the state use will raise #NM. Then, it will reallocate the
> > task's fpstate via this call chain:
> >
> > #NM --> handle_xfd_event() --> xfd_enable_feature() --> fpstate_realloc()
> >
> > Thanks,
> > Chang
>
> Thanks for the info. But I think you are talking about host level AMX
> enabling. This is known to me. I am asking about how AMX was enabled
> by QEMU and used by vCPU threads in the guest. After digging a little
> bit, I think I understand it now.
>
> So, it should be the following: (in fact, the guest fp_state is not
> allocated lazily but at the very beginning at KVM_SET_CPUID2 time).
>
>   kvm_set_cpuid() / kvm_set_cpuid2() ->
>     kvm_check_cpuid() ->
>       fpu_enable_guest_xfd_features() ->
>         __xfd_enable_feature() ->
>           fpstate_realloc()
>
> Note that KVM does intercept #NM for the guest, but only for the
> handling of XFD_ERR.
>
> Prior to the kvm_set_cpuid() or kvm_set_cpuid2() call, the QEMU thread
> should ask for permission via arch_prctl(REQ_XCOMP_GUEST_PERM) in
> order to become a vCPU thread. Otherwise, the above call sequence will
> fail. Fortunately, asking-for-guest-permission is only needed once per
> process (per-VM).
>
> Because of the above, the non-vCPU threads do not need to create a
> larger fp_state unless/until they invoke kvm_set_cpuid() or
> kvm_set_cpuid2().
>
> Now, I think that closes the loop for me.
>
> Thanks.
>
> -Mingwei

I'd still like to clean up CPUID.(EAX=0DH,ECX=0):EAX.XTILECFG[17] by
keeping it consistent with CPUID.(EAX=0DH,ECX=0):EAX.XTILEDATA[18] in
the guest, but it's not clear to me what the best way to do that is.
The crux of the issue is that xstate_get_guest_group_perm() returns
partial support for AMX when userspace doesn't call
prctl(ARCH_REQ_XCOMP_GUEST_PERM), I.e. the guest CPUID will report
XTILECFG=1 and XTILEDATA=0 in that case.  In that situation, XTILECFG
should be cleared for it to be consistent.  I can see two ways of
potentially doing that:

1. We can ensure that perm->__state_perm never stores partial support.

2. We can sanitize the bits in xstate_get_guest_group_perm() before
they are returned, to ensure KVM never sees partial support.

I like the idea of #1, but if that has negative effects on the host or
XFD I'm open to #2.  Though, XFD has its own field, so I thought that
wouldn't be an issue.  Would it work to set __state_perm and/or
default_features (what originally sets __state_perm) to a consistent
view, so partial support is never returned from
xstate_get_guest_group_perm()?
