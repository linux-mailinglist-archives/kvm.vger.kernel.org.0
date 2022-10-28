Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8665A611D1A
	for <lists+kvm@lfdr.de>; Sat, 29 Oct 2022 00:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiJ1WCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 18:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiJ1WBx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 18:01:53 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEC3246C1D
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 15:01:49 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-12c8312131fso7785106fac.4
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 15:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A02e8sBdhkAFHlKOQrgQidSWAiZAEUfwAZZwCce8UM0=;
        b=PYr8Tz9L+0yrX4g1ONBhCtetZ1hAjGI4rISzlYiyWPym0MWMpTFW6lCGhNAnBYeQJH
         WnF96urxWLwKHgu0E5ecF+HxVeBF1q0yVZjXVC4vNud7Tsa6Ui9enxFxG2h1t4KCDjoU
         n0CgKUByJA7Xf2HUfOL3TgLB5VMFZ4fFBln0TpZHGy3LSTWh9nAXoRi+CliWW2c1OqCy
         CuXiq+8UGOSgz7ZA2XzFoO8cY6i8Mnp2afyOnKD70F5KOunUMo5kcF7r7aE1qZu0EcuI
         1GxCuahZddfYtcpJDCkyU55Epl8SxfPt2FsAesNcCAIgSdplT+Pfqj13aqZhznqXwkHm
         06tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A02e8sBdhkAFHlKOQrgQidSWAiZAEUfwAZZwCce8UM0=;
        b=jg58hKNnW2Hq54euq/ppEk3eP9z/kPA8jW1aBZ/5/r1kUDXojnC+BSELoUDrTeR+lr
         LlzZJL4+6pNE5SLV9kQZhdZT8+81moDbuResGIar2iR1VnrGOJLtVdAESqz1QqTMG/DN
         xFIK6UT8Gpl2NUyiC8QwRo62VYXYnIx6fPJnegJ5G3yHivwItPnwJ3ZbMEHpeWIlN5Ww
         3C7mbNM1q0Sf+i6r0hLaPVfVBIv5F+wtYI8imNWSZY5Iq1MiufH45N4DWZNSJQsLJKqc
         XszwDErhOvVddebrmUUgih4iP73OxIcqwMD1x4y94B/aAAoOkf2JgmMEM5AaicsL3Y3C
         x8yQ==
X-Gm-Message-State: ACrzQf26qNcxEG+1DMC0Vll+hbmowF3SzRDC19v4/ja6QqnQ9fjMJNyA
        GrnEptKwlQz1XIyy9dedUg/wGs+jmW8A+sCvj7LpCA==
X-Google-Smtp-Source: AMsMyM4R7Bp9BV2PWN6PaGtpPnepNEzAKw0MR9Tcfs/MY8mxbWrLRClj6y34RI9sDlhP1kFzO5QmVJHkOtKIHh8SFoE=
X-Received: by 2002:a05:6871:8a3:b0:13b:18ef:e8df with SMTP id
 r35-20020a05687108a300b0013b18efe8dfmr723703oaq.181.1666994508369; Fri, 28
 Oct 2022 15:01:48 -0700 (PDT)
MIME-Version: 1.0
References: <20221028130035.1550068-1-aaronlewis@google.com>
 <Y1wCqAzJwvz4s8OR@google.com> <CAAAPnDEda-FBz+3suqtA868Szwp-YCoLEmK1c=UynibTWCU1hw@mail.gmail.com>
 <Y1xOvenzUxFIS0iz@google.com>
In-Reply-To: <Y1xOvenzUxFIS0iz@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 28 Oct 2022 15:01:37 -0700
Message-ID: <CALMp9eT9S4_k9cFR26idssjV+Yz4VH23hXA10PVTGJwNALKeWw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Fix a stall when KVM_SET_MSRS is called on the
 pmu counters
To:     Sean Christopherson <seanjc@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
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

On Fri, Oct 28, 2022 at 2:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Oct 28, 2022, Aaron Lewis wrote:
> > On Fri, Oct 28, 2022 at 4:26 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Fri, Oct 28, 2022, Aaron Lewis wrote:
> > > @@ -3778,16 +3775,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > >
> > >     case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
> > >     case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
> > > -        pr = true;
> > > -        fallthrough;
> > >     case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
> > >     case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
> > >         if (kvm_pmu_is_valid_msr(vcpu, msr))
> > >             return kvm_pmu_set_msr(vcpu, msr_info);
> > >
> > > -        if (pr || data != 0)
> > > -            vcpu_unimpl(vcpu, "disabled perfctr wrmsr: "
> > > -                  "0x%x data 0x%llx\n", msr, data);
> > > +        if (data)
> > > +            kvm_pr_unimpl_wrmsr(vcpu, msr, data);
> >
> > Any reason to keep the check for 'data' around?  Now that it's
> > checking for 'report_ignored_msrs' maybe we don't need that check as
> > well.  I'm not sure what the harm is in removing it, and with this
> > change we are additionally restricting pmu counter == 0 from printing.
>
> Checking 'dat' doesn't restrict counter 0, it skips printing if the guest (or host)
> is writing '0', e.g. it would also skip the case you encountered where the host is
> blindly "restoring" unused MSRs.

The VMM is only blind because KVM_GET_MSR_INDEX_LIST poked it in the
eye. It would be nice to have an API that the VMM could query for the
list of supported MSRs.

> Or did I misunderstand your comment?
