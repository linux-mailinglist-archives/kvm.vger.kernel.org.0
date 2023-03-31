Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E626D1422
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 02:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjCaAfF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 20:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjCaAfD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 20:35:03 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C07EFAC
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 17:35:02 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id u20so13745055pfk.12
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 17:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680222901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MH3dmPhc4+moh1k942OUVlyMUe+0ay7bXGCHlOkXk5M=;
        b=mcRHDdbzbUBalM4xQm/dV4O4CAnvmP60HNvjCNMdG0V0+RzDyWZ0twOaW7gPPckYmh
         l6ySSh+J6l2SUwYdNua4gOFnU3dU90B7eresyjvGu1Qr4U+Pj8rikdAKAjnIu+opqWv5
         kF8AfcEWyaQh/MZC+lFbK1FD6OKf0kXA4qCNugDXVGm6Li5IDFcUxzJYSiqmEFri/Wq9
         t8nQvJtUyXtfhLC44XDz0jH5RX8uokYwNCWedoV/wim5XdiwnilST7RPGaceM+Y7QDnQ
         zkdOcCS/92CcMiU3awafEkmrvo3Te/s2SVlcm5b8vtLZ7p1qPLy6FW0w6x3rV75P7/v+
         G+gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680222901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MH3dmPhc4+moh1k942OUVlyMUe+0ay7bXGCHlOkXk5M=;
        b=6kawpzcD6TdMK1lSHjI7wGp9vIEvihHEtClpwSsa4j2kVkbGuKRinl+4EcaELrABXc
         6UrU+4nhvHOU0xTosUrXrXEazhx8f7fYABjRjbHU9p5XkY8RO23gH7gHkN+9cbyyHF/J
         Kv8C9QJMGfpkl9l5x5jWEJpL6wRFw0SevALB7oqerdJQ0oF48ioTDlhWqZE+qhXJ0Te7
         LCwo5/tenE+UPsMT67WDCyon2paRInH/vyeecuRXD4uxIc4DxAT1NpJ4I0jsH/I5Xcf2
         xCNOirx0mrTgXHHdyIOE1jRk9LgcXs2AqsOU/2T1CP0S2ZOQ6aPSeAr9guC9MvXysTTL
         zz5Q==
X-Gm-Message-State: AAQBX9fumv3e9zqBOJYhE1ObPPQJRN/vY/T1vDMclKjUSsizUDXYGRsJ
        02FhKR2PfO7uoRdi3K4l2pBwgCieIDbVEx7XEOZtTQ==
X-Google-Smtp-Source: AKy350a4DeFNtiT0puMpHPQRz//ZqQ7b+CicsE7u8pb1b0QPYo1NzBe7x2L2DYaneQRuVTtUr1bNCZzzLBDtrXjhewY=
X-Received: by 2002:a05:6a00:2da5:b0:624:c7cc:3d0e with SMTP id
 fb37-20020a056a002da500b00624c7cc3d0emr12953815pfb.6.1680222901270; Thu, 30
 Mar 2023 17:35:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230330224348.1006691-1-davidai@google.com> <ZCYZRIbPh+f3v26v@linux.dev>
 <CAGETcx_P27-=wkAkCETTR2Q0edA01M5jArS_t-zZFn61YM9Muw@mail.gmail.com> <ZCYd7kH2f/Ku8b0D@linux.dev>
In-Reply-To: <ZCYd7kH2f/Ku8b0D@linux.dev>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 30 Mar 2023 17:34:24 -0700
Message-ID: <CAGETcx9CHZCpUsAaEdJGmBFuwJzdp+Mr81=4JQdG0zVy42AZDw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] Improve VM DVFS and task placement behavior
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     David Dai <davidai@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        kernel-team@android.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023 at 4:40=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Thu, Mar 30, 2023 at 04:36:52PM -0700, Saravana Kannan wrote:
> > On Thu, Mar 30, 2023 at 4:20=E2=80=AFPM Oliver Upton <oliver.upton@linu=
x.dev> wrote:
> > >
> > > On Thu, Mar 30, 2023 at 03:43:35PM -0700, David Dai wrote:
> > >
> > > [...]
> > >
> > > > David Dai (6):
> > > >   sched/fair: Add util_guest for tasks
> > > >   kvm: arm64: Add support for get_cur_cpufreq service
> > > >   kvm: arm64: Add support for util_hint service
> > > >   kvm: arm64: Add support for get_freqtbl service
> > > >   dt-bindings: cpufreq: add bindings for virtual kvm cpufreq
> > > >   cpufreq: add kvm-cpufreq driver
> > >
> > > I only received patches 2-4 in my inbox (same goes for the mailing li=
sts
> > > AFAICT). Mind sending the rest? :)
> >
> > Oliver,
> >
> > Sorry about that. Actually even I'm not cc'ed in the cover letter :)
> >
> > Is it okay if we fix this when we send the next version? Mainly to
> > avoid some people responding to this vs other responding to a new
> > series (where the patches are the same).
>
> Fine by me, as long as the full series arrived somewhere.
>
> > We used a script for --to-cmd and --cc-cmd but looks like it needs
> > some more fixes.
> >
> > Here is the full series to anyone who's wondering where the rest of
> > the patches are:
> > https://lore.kernel.org/lkml/20230330224348.1006691-1-davidai@google.co=
m/T/#t
>
> Gah, a bit of noodling would've dug up the full series. Thanks for the
> link.

Actually, we'll send out a new RFC v2 series with the To's and Cc's
fixed with some minor cover letter fixes. So everyone can ignore this
series and just wait for the RFC v2 series later today.


-Saravana
