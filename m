Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9185376D3F0
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 18:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjHBQpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 12:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjHBQpu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 12:45:50 -0400
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115EE1AC
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 09:45:49 -0700 (PDT)
Received: by mail-vk1-xa2e.google.com with SMTP id 71dfb90a1353d-48662837573so2375377e0c.2
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 09:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690994748; x=1691599548;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5RU+aSjB9EhysCp4tB2HQ/1SvSiC1E9VMvpDqxI/2dI=;
        b=f6yWemJYtMc8JObQD4O3ZZGcGL4zS1Rcttk49Vphqz1szqs3v9r0zie+fCSguGJPgQ
         l60aJUIK9XJSb1gpwU9dafiV0eF7TPV2vG5lj7tybfwgEFHewTcx4UyBJeWhnzUDQ19k
         /1YfqUDykGxl1Bis7Jnvy1lAPkqYtBQChMSyyiPpjgYjhrbaBO44J/HZA8G+ZU/13AGU
         5rRXOnkiKqcvkj3bahTcdfWrVY7/yMrajNjQYAWZkqyr+lGiG3xgYgqY7I6gKbXd4Ksc
         MvpI0H46VjGTFohAbTSQao7ip8Gsy681ZFUv70VCGQd66/vLm+friqWI7k7x5Z4xcAF2
         +5Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690994748; x=1691599548;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5RU+aSjB9EhysCp4tB2HQ/1SvSiC1E9VMvpDqxI/2dI=;
        b=UHHOy/Y+BhVr1F5m+vXDwAktKieeaxWN7lkpjq86tjz20cdqn2E/rlHNKrg0c3Gsy3
         4SF0dTlszEVGKCFFlxkq/hzLJ0tXDXhU/dXdY9bdgjlI9kMC+Kju5VwrIVcE8PkcAiCD
         R7cqEYEBYm/b8cgdcPMhqNlJbuSETQ+GElPn+OWxYDtqEQaCm8FKx1wZRaj5Hmrv4Jo8
         dEpw3u14QrahvEQLaXApv5+FFgRqX1iJZCXLH+TqfxaXj3c4dw/st0681mpTqh9wDYYd
         Rj2dORRhctqt9jmVMBC1ABO5zv8HSDX5e6j5UNYtJbgCUWAsY0egO+3efk+1D9YPYTy6
         QulA==
X-Gm-Message-State: ABy/qLabDJ6fQjF1aeKEZxVepApjzho/KZWO061LRhAcGhQUJ+koKmSz
        OjshVMR7p4bISknVTff059FHtypIIE3Z29WPy4k=
X-Google-Smtp-Source: APBJJlH+3FcxCJQA89OmMIqTpLU1UoixLoofPRc7tusL76g4+O+iFAMDvEc3JdSSDuz0GCIaARCF2DwvtbXhWVZXBGQ=
X-Received: by 2002:a1f:4bc2:0:b0:47e:9bbb:103b with SMTP id
 y185-20020a1f4bc2000000b0047e9bbb103bmr4994996vka.6.1690994747999; Wed, 02
 Aug 2023 09:45:47 -0700 (PDT)
MIME-Version: 1.0
References: <ZHZCEUzr9Ak7rkjG@google.com> <20230721143407.2654728-1-amaan.cheval@gmail.com>
 <ZLrCUkwot/yiVC8T@google.com> <CAG+wEg21f6PPEnP2N7oE=48PBSd_2bHOcRsTy_ZuBpa2=dGuiA@mail.gmail.com>
 <ZMAGuic1viMLtV7h@google.com> <CAG+wEg3X1Tc_PW6E=pLHKFyAfJD0n2n25Fw2JYCuHrfDC_Ph0Q@mail.gmail.com>
 <ZMp3bR2YkK2QGIFH@google.com>
In-Reply-To: <ZMp3bR2YkK2QGIFH@google.com>
From:   Amaan Cheval <amaan.cheval@gmail.com>
Date:   Wed, 2 Aug 2023 22:15:36 +0530
Message-ID: <CAG+wEg2x-oGALCwKkHOxcrcdjP6ceU=K52UoQE2ht6ut1O46ug@mail.gmail.com>
Subject: Re: Deadlock due to EPT_VIOLATION
To:     Sean Christopherson <seanjc@google.com>
Cc:     brak@gameservers.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> LOL, NUMA autobalancing.  I have a longstanding hatred of that feature.  I'm sure
> there are setups where it adds value, but from my perspective it's nothing but
> pain and misery.

Do you think autobalancing is increasing the odds of some edge-case race
condition, perhaps?
I find it really curious that numa_balancing definitely affects this issue, but
particularly when thp=0. Is it just too many EPT entries to install
when transparent hugepages is disabled, increasing the likelihood of
a race condition / lock contention of some sort?

> > They still remain locked up, but that might be because the original cause of the
> > looping EPT_VIOLATIONs corrupted/crashed them in an unrecoverable way (are there
> > any ways you can think of that that might happen)?
>
> Define "remain locked up".  If the vCPUs are actively running in the guest and
> making forward progress, i.e. not looping on VM-Exits on a single RIP, then they
> aren't stuck from KVM's perspective.

Right, the traces look like they're not stuck (i.e. no looping on the same
RIP). By "remain locked up" I mean that the VM is unresponsive on both the
console and services (such as ssh) used to connect to it.

> But that doesn't mean the guest didn't take punitive action when a vCPU was
> effectively stalled indefinitely by KVM, e.g. from the guest's perspective the
> stuck vCPU will likely manifest as a soft lockup, and that could lead to a panic()
> if the guest is a Linux kernel running with softlockup_panic=1.

So far we haven't had any guest kernels with softlockup_panic=1 have this issue,
so it's hard to confirm, but it makes sense that the guest took punitive action
in response to being stalled.

Any thoughts on how we might reproduce the issue or trace it down better?

Anything look suspect in the function_graph trace?
(Note that this was on a host that had numa_balancing=0,thp=1 from before
the guest booted, and it still ended up in the EPT_VIOLATION loop and
"locked up" (unresponsive on console).)
