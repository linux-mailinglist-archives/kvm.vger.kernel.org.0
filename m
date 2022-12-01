Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45AF163EF59
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 12:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbiLALWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 06:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiLALWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 06:22:32 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2A9A1C1E
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 03:19:45 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id k5so1544556pjo.5
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 03:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZCwPsFz1IkWwGG4R6t3UgktQUADEE2ekOmTBUSLj5QQ=;
        b=cIxLUszB2z5bDm5O0CmRTHxEYzyWtweVN5He5qGbjii8sSu3MqEsmM2PaHrtS53AEv
         HsJCakHaaMDd/oHj6+XqnYo+VZ3sc8SBDGDuSTPNs1oYP6Pjl+Vmb2MQ4U/56pakkxqc
         QkdVAf2BbA7hY/nqKF1jyJ9y6RT4+V8cOxF+05Ic39r/mrvBfFoKwh/KkrL8eMqVYoMq
         Z9bwAD/R7Tf86qqGpxqmZQ2ww7ZPxVS4pxNpSWn09ByMQkPYdJL0phA5qbBei79akHkE
         hq6XS0sZN8Kls7DA+PoR+49kUZy0OcWyGVUO9pyx9d5CCRKAftcUvAJU//gxgeJlDQjN
         91fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZCwPsFz1IkWwGG4R6t3UgktQUADEE2ekOmTBUSLj5QQ=;
        b=QGGzKC7uTQn/JLYo5N+U9z4j4RdwezVGNrvXu3BdBcqg+4JoJCOuozoh/v+KnISbcn
         fG0fmhLgySN6O4zN24XohYmf9BUwqpaS+zc8TXOzCikXp0vRNNzbRJKuNyLukoS2FeFx
         DJLcINeta/VxZPNgacBnu6dRHP7jtEaMSry8yBkMB/Yz5OlfhJv0sRB+QmvIELBiEN2o
         c7zkqrHIYbqmcuaAmG35jku7IRrbMxs0wdfU1w5p4EzyenFTutoTJcNatRJ4yhL+ya0q
         rvbQr3NsLD6X9FAXkb7ucHP/5+kmp+K2RbUvUnoAerYI5njt6V+SfcSpPWwDQGAUB0UI
         f32Q==
X-Gm-Message-State: ANoB5pnsX+7h+uZ+Y/dTGxYhCvp760eq3r0wgqJASITlaV7YlcdAn3FU
        295qbTVl5nKUOGDqmxiqbznqj2GscEQjF/52MZeFlg==
X-Google-Smtp-Source: AA0mqf7UMy6ysGlQ3+/XD7dS8P2MxrsQY9kPgeIfvGB5PlatZrFd4JuP5EubBXDXR1GXCt0u4WNeR+tJxXUh4lA1gDM=
X-Received: by 2002:a17:90a:460f:b0:218:c47f:ed9a with SMTP id
 w15-20020a17090a460f00b00218c47fed9amr50445242pjg.19.1669893584580; Thu, 01
 Dec 2022 03:19:44 -0800 (PST)
MIME-Version: 1.0
References: <20221201102728.69751-1-akihiko.odaki@daynix.com>
 <CAFEAcA_ORM9CpDCvPMs1XcZVhh_4fKE2wnaS_tp1s4DzZCHsXQ@mail.gmail.com> <a3cc1116-272d-a8e5-a131-7becf98115e0@daynix.com>
In-Reply-To: <a3cc1116-272d-a8e5-a131-7becf98115e0@daynix.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 1 Dec 2022 11:19:32 +0000
Message-ID: <CAFEAcA_ECpCV+6Z+jom-sP0PNQpoU0fFG_3L_70PrQEWrarH_g@mail.gmail.com>
Subject: Re: [PATCH] accel/kvm/kvm-all: Handle register access errors
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 1 Dec 2022 at 11:00, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>
> On 2022/12/01 19:40, Peter Maydell wrote:
> > On Thu, 1 Dec 2022 at 10:27, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
> >>
> >> A register access error typically means something seriously wrong
> >> happened so that anything bad can happen after that and recovery is
> >> impossible.
> >> Even failing one register access is catastorophic as
> >> architecture-specific code are not written so that it torelates such
> >> failures.
> >>
> >> Make sure the VM stop and nothing worse happens if such an error occurs.
> >>
> >> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> >
> > In a similar vein there was also
> > https://lore.kernel.org/all/20220617144857.34189-1-peterx@redhat.com/
> > back in June, which on the one hand was less comprehensive but on
> > the other does the plumbing to pass the error upwards rather than
> > reporting it immediately at point of failure.
> >
> > I'm in principle in favour but suspect we'll run into some corner
> > cases where we were happily ignoring not-very-important failures
> > (eg if you're running Linux as the host OS on a Mac M1 and your
> > host kernel doesn't have this fix:
> > https://lore.kernel.org/all/YnHz6Cw5ONR2e+KA@google.com/T/
> > then QEMU will go from "works by sheer luck" to "consistently
> > hits this error check"). So we should aim to land this extra
> > error checking early in the release cycle so we have plenty of
> > time to deal with any bug reports we get about it.

> Actually I found this problem when I tried to run QEMU with KVM on M2
> MacBook Air and encountered a failure described and fixed at:
> https://lore.kernel.org/all/20221201104914.28944-2-akihiko.odaki@daynix.com/

Ah, yeah, you're trying to run QEMU+KVM on a heterogenous cluster.
You need to force all the vCPUs to run on only a single host
CPU type. It's a shame the error-reporting for this situation
is not very good, but there's not really any way to tell in
advance, the best you get is an error at the point where a vCPU
happens to migrate over to a different host CPU.

> Although the affected register was not really important, QEMU couldn't
> run the guest well enough because kvm_arch_put_registers for ARM64 is
> written in a way that it fails early. I guess the situation is not so
> different for other architectures as well.

I think Arm is the only one that does this kind of "leave the
handling of the system registers up to the host kernel and treat
them as mostly black-box values to be passed around on migration"
approach. Most other architectures have QEMU know about specific system
registers in the vCPU and only ask the kernel about those, I think.

-- PMM
