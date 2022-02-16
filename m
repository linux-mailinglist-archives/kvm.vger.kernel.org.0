Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF3C24B8FB9
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 18:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237362AbiBPRyT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 12:54:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233946AbiBPRyS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 12:54:18 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED3122C6F1
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 09:54:06 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id s203-20020a4a3bd4000000b003191c2dcbe8so3321104oos.9
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 09:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yDpB++dvNrcqAJlyBBM88E31rOeEBSpFbNBIclLTgXo=;
        b=OnqQAVhnLzGUgqKcIt3PmSKH4G+af9kqvOLRvGa2O8NG9yKoKacECt/CJOVQgRPfSZ
         OgWhpnhRHfbA4QYO7qfEqdMNK1nac2uRJoROPFgXTssmRUu4KlKxUBMmJ8ux02a15Kb/
         3s4nR9rrJ0jcnYrYcCm0DMX5pqSYo1KpCmrOBY6I518zqhOrcKAdPhrTxFcFL4iSbG89
         DUyWssVO+HPtMvu0fDtrBAOHLMVxEim3syc0lJ8/+4XSICS5B4wbJCSWo7C3g2982eQ3
         zA5qkyw6EheZ3nF3tCej1rLsDDQdn1Dg9z7MBBxKMQEknIOo1r3SH1JrMV005O2ImPh5
         vafw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yDpB++dvNrcqAJlyBBM88E31rOeEBSpFbNBIclLTgXo=;
        b=njs1O7izkD4uPHDytyEYORz9tc0nHbngFCdFSYCG3MiOyB19gRrRax8OlDYOs/EZRi
         CroE1XYaJeHMZriaPlnrKbqFUDOYx0Q+krMWDnOJD9mdKci8mJXyUPtbttqWVlahT45Y
         Q6k4boo7Tl36XwcsTct+3SI91GUdVWc8GsXk1J+CSTFF0nVz9uQcisSfkAz3OWNiDv/S
         HWiKBGfgGJ8HiP6bWfLOJI3URXiQDOR04XWrrMFo7Occ/hVZQkqOI2LNb+Vbc+/59oc+
         gWYt1G0vmfmT/5cBBpoHFRtOJ+3IrJMTIg3FAFORygLIwP3bveft7yYlIXwOmzQWNXdj
         nWlQ==
X-Gm-Message-State: AOAM5319GyseAkdxAIc5iHqR++GIj+uO7qhbjC+c4+sfyWPvMUis2Ax4
        GPNEmsrlcN9yMfcejx/TVSV1n5di4QjyPQNGKHh6pg==
X-Google-Smtp-Source: ABdhPJwrqVLrxMD0AyQI4+bdavEDRbKgWj+hnFhMd/6pObRAg+cMk9FvIr+VbFsiEmNSihEHsTTicPnR3OEC9FrRVCU=
X-Received: by 2002:a05:6870:3046:b0:d3:58b:fbd1 with SMTP id
 u6-20020a056870304600b000d3058bfbd1mr921086oau.129.1645034045122; Wed, 16 Feb
 2022 09:54:05 -0800 (PST)
MIME-Version: 1.0
References: <20220117085307.93030-1-likexu@tencent.com> <20220117085307.93030-3-likexu@tencent.com>
 <20220202144308.GB20638@worktop.programming.kicks-ass.net>
 <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
 <2db2ebbe-e552-b974-fc77-870d958465ba@gmail.com> <YgPCm1WIt9dHuoEo@hirez.programming.kicks-ass.net>
 <YgQrWHCNG/s4EWFf@google.com> <39b64c56-bc8d-272d-da92-5aa29e54cdaf@gmail.com>
 <YgVHawnQWuSAk+C1@google.com> <810c3148-1791-de57-27c0-d1ac5ed35fb8@gmail.com>
In-Reply-To: <810c3148-1791-de57-27c0-d1ac5ed35fb8@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 16 Feb 2022 09:53:53 -0800
Message-ID: <CALMp9eTNhhHKoGrsiQT24UCUzY+TGKOkGPMDh7MZ5+YzSHjkhg@mail.gmail.com>
Subject: Re: KVM: x86: Reconsider the current approach of vPMU
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Dunn <daviddunn@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 15, 2022 at 7:33 PM Like Xu <like.xu.linux@gmail.com> wrote:

> AFAI, most cloud provider don't want to lose this flexibility as it leaves
> hundreds of "profile KVM guests" cases with nowhere to land.

I can only speak for Google Cloud. We'd like to be able to profile
host code with system-wide pinned counters on a periodic basis, but we
would like to do so without breaking PMU virtualization in the guest
(and that includes not only the guest counters that run in guest mode,
but also the guest counters that have to run in both guest mode and
host mode, such as reference cycles unhalted).

The one thing that is clear to me from these discussions is that the
perf subsystem behavior needs to be more configurable than it is
today.

One possibility would be to separate priority from usage. Instead of
having implicit priorities based on whether the event is system-wide
pinned, system-wide multiplexed, thread pinned, or thread multiplexed,
we could offer numeric priorities independent of the four usage modes.
That should offer enough flexibility to satisfy everyone.
