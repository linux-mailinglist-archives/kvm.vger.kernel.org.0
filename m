Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274B77147E2
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 12:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbjE2K1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 06:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjE2K1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 06:27:47 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE7F9C
        for <kvm@vger.kernel.org>; Mon, 29 May 2023 03:27:46 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-514924ca903so2665112a12.2
        for <kvm@vger.kernel.org>; Mon, 29 May 2023 03:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685356065; x=1687948065;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vJNgW7Vc6NDnBKEQWZLCi+QAbMD7KTMTqInMEGtIc9c=;
        b=hemSZS+FE94+6En8EsFpBjhKr0XJ5fxgcWv0hM1OkLGAiNyY1P0lve9y0F0JP7PHXT
         S6X07r0pYClwXvcgG3O6euQvCIL2pGCLzv0Kjv2DThAPG36mrISWiOLtpprqQdtH9vBc
         DANp2xL5ve7VwVjHVUKHHAB/epE6wG/jJiK9BMCXVqDmJRDrYWTulZp9PK8l2WtCWre7
         wMVj6j7RogqSKERJ4rtP3n8cBQn6KWcPYi3lL08rzR/cXh5lUp5ftSu/JzowAQ3dGqP0
         7mU+Gw70zM12aXi0X43cbbnsdf5g9f5WALRAnLZMZ//B64MzUfJ4fHeQ/X9IrIOqDqWH
         0WwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685356065; x=1687948065;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vJNgW7Vc6NDnBKEQWZLCi+QAbMD7KTMTqInMEGtIc9c=;
        b=hlO8DC4tfaNCNkF2KfJCtxsIQTm4I9hAN+wXKj0QoCytfDsTLXYFugFGX/XX9RcnPE
         6M2V563rhjIgSA5PuCt2iwM4n4exNq2twMXJ+VyDRmrlAUz6l/9pZfvtvrpqS1k+FgSF
         NAFfR8jV08XRFSLfalWPU0GB2ODd14/WtQ9ChcchZoXQCMZDswSdyfwZCWQUQeCIG14c
         h04RxDXZqCqsBKkVwpn9jGPRwE4vMzYaijzQW/wBsMEscTfu6lUdYbe6Ns9Q/AHU3FDU
         Cl1dY7qDidZJMBUp+6LzJrjJCEGClSIoqR1EW40GRE394sy+Y4fEyOSAfxQcQoM5GaIA
         mYbQ==
X-Gm-Message-State: AC+VfDxHkDDPI1HdIO/3nf3mFUehuCTxmVPlfT9b15VA7wu4rxqPeetf
        wW6NYkkJJs8EgWiQq7DOXeB7mjzxHQgaUY36MZg+oQ==
X-Google-Smtp-Source: ACHHUZ65b6H40DUcBRg92a782Wc4ej9j+Qx5ZWA9ctSXo/ezzQFGGpzVlweWY4A5ZJTOf1SDBsWEVrVqepshf31hp2U=
X-Received: by 2002:a05:6402:657:b0:50d:b16d:d21 with SMTP id
 u23-20020a056402065700b0050db16d0d21mr7201385edx.3.1685356064872; Mon, 29 May
 2023 03:27:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230428095533.21747-1-cohuck@redhat.com> <87v8gkzi5v.fsf@redhat.com>
 <CABJz62MGU-49Ucs-CYsd2hdH8mejWtjXXBNcbs92Kx+V=T2EwA@mail.gmail.com>
In-Reply-To: <CABJz62MGU-49Ucs-CYsd2hdH8mejWtjXXBNcbs92Kx+V=T2EwA@mail.gmail.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 29 May 2023 11:27:15 +0100
Message-ID: <CAFEAcA-vFQRGsD0emmCwMfyVMd2YGhZL-k_U5x63=G9JaLo=GQ@mail.gmail.com>
Subject: Re: [PATCH v7 0/1] arm: enable MTE for QEMU + kvm
To:     Andrea Bolognani <abologna@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 29 May 2023 at 11:15, Andrea Bolognani <abologna@redhat.com> wrote:
>
> On Mon, May 22, 2023 at 02:04:28PM +0200, Cornelia Huck wrote:
> > On Fri, Apr 28 2023, Cornelia Huck <cohuck@redhat.com> wrote:
> > > Another open problem is mte vs mte3: tcg emulates mte3, kvm gives the guest
> > > whatever the host supports. Without migration support, this is not too much
> > > of a problem yet, but for compatibility handling, we'll need a way to keep
> > > QEMU from handing out mte3 for guests that might be migrated to a mte3-less
> > > host. We could tack this unto the mte property (specifying the version or
> > > max supported), or we could handle this via cpu properties if we go with
> > > handling compatibility via cpu models (sorting this out for kvm is probably
> > > going to be interesting in general.) In any case, I think we'll need a way
> > > to inform kvm of it.
> >
> > Before I start to figure out the initialization breakage, I think it
> > might be worth pointing to this open issue again. As Andrea mentioned in
> > https://listman.redhat.com/archives/libvir-list/2023-May/239926.html,
> > libvirt wants to provide a stable guest ABI, not only in the context of
> > migration compatibility (which we can handwave away via the migration
> > blocker.)
>
> Yeah, in order to guarantee a stable guest ABI it's critical that
> libvirt can ask for a *specific* version of MTE (MTE or MTE3) and
> either get exactly that version, or an error on QEMU's side.
>
> > The part I'm mostly missing right now is how to tell KVM to not present
> > mte3 to a guest while running on a mte3 capable host (i.e. the KVM
> > interface for that; it's more a case of "we don't have it right now",
> > though.) I'd expect it to be on the cpu level, rather than on the vm
> > level, but it's not there yet; we also probably want something that's
> > not fighting whatever tcg (or other accels) end up doing.
> >
> > I see several options here:
> > - Continue to ignore mte3 and its implications for now. The big risk is
> >   that someone might end up implementing support for MTE in libvirt again,
> >   with the same stable guest ABI issues as for this version.
> > - Add a "version" qualifier to the mte machine prop (probably with
> >   semantics similar to the gic stuff), with the default working with tcg
> >   as it does right now (i.e. defaulting to mte3). KVM would only support
> >   "no mte" or "same as host" (with no stable guest ABI guarantees) for
> >   now. I'm not sure how hairy this might get if we end up with a per-cpu
> >   configuration of mte (and other features) with kvm.
> > - Add cpu properties for mte and mte3. I think we've been there before
> >   :) It would likely match any KVM infrastructure well, but we gain
> >   interactions with the machine property. Also, there's a lot in the
> >   whole CPU model area that need proper figuring out first... if we go
> >   that route, we won't be able to add MTE support with KVM anytime soon,
> >   I fear.
> >
> > The second option might be the most promising, except for potential
> > future headaches; but a lot depends on where we want to be going with
> > cpu models for KVM in general.
>
> What are the arguments for/against making MTE a machine type option
> or CPU feature flag? IIUC on real hardware you get "mte" or "mte3"
> listed in /proc/cpuinfo, so a CPU feature would seem a pretty natural
> fit to me, but I seem to recall that Peter was pushing for keeping it
> a machine property instead.

The arguments for a machine property are:
 * MTE needs not just CPU support but also system level support
   (on real hardware there needs to be actual tag ram somewhere
   out there in the system; for TCG we need to create the tag
   RAM in the virt board code)
 * it's what we're already doing for TCG, so it keeps the UI
   consistent between TCG and KVM
 * it's what we already do for things like the virtualization
   extensions and TrustZone emulation (which also generally need
   to be supported not just by the CPU but also by the board)

thanks
-- PMM
