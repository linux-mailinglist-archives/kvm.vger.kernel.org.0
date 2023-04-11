Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC5C6DDEA4
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 16:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjDKO64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 10:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjDKO6y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 10:58:54 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513D6272B
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 07:58:52 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-18447b9a633so7362460fac.7
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 07:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681225131; x=1683817131;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JUzuStF55OhH4eYJH9aoC4gqNsDP4T1tXhgFLxA6Gjo=;
        b=nPlZ7EJ4LlvNMM7msupsPQS6oXYYW6nRWe9Y9uR8NI2kQxz7q6XIRvI/j+7eVOgGyK
         AWPjUjGgqH7W+HLqNVWo6n//cgFGnycoAFwwD12SGiY9jvAB6Eo/DbZ3kkVHPz4BTRxv
         8qnlW/suArakriYS8Y/RTEaP30ThehXxph/k016mx2YbaEO+o31xy4iWVAirb3+Nc+oN
         qpCO84/x9tQjDjDt0An/iROzPMy66W6TWgBsN8fK0XNNAFgPjBs4YhRSqdDxvRjAOw6Y
         CAPtW4WQXymaYyC8+WQSHSZ76yLdQxxD3ZMYO3gauaINwjcCfyv+nJ+2xfPmmVz9tCez
         yJDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681225131; x=1683817131;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JUzuStF55OhH4eYJH9aoC4gqNsDP4T1tXhgFLxA6Gjo=;
        b=sNHO2DX2tlf5ZjSTgiQSW2Bw8e/Im766w46rQcmS3VJEplc8I9nhwoMaN9hu4+4aj7
         estnIsTyljI+JVh0kTXlsPOPb3dKXk6Z3PT6JwcKwm5WWPMSHaoelrv8C1hwf9jLFo+M
         kOjgk+0CxBgGTzOF23JSDgAIg6xawXgjahPx+2DW5DpDwbYIeXPXVaRK8/jbNoWoNIT/
         65Nbq71bjzSoDgcx7s9K4yEzwJiFHgNScEGKYmy+hBDUDG8jToMDS5m9aonTO6pzhKx4
         PkyEW1MEFaWi660GLW764bXEBIPzSngcoknER8pdRPl2nsO79sJySVnC0cAweiyGF6nC
         g7fw==
X-Gm-Message-State: AAQBX9fJMRUQpMdAurtrImDzmZWq/HmyNWC23NiLMGiA7G5YDsy722ba
        bxL7Ci6S/nMhxjI00ytNU04r9/moGoud1lM9iPqCJzqjuvQdMQuNifQ=
X-Google-Smtp-Source: AKy350Yu+cBKD9wvjtZX8dK6tlgo9sLprQfwWnmxGLSCUDD9zYyvKMNPRvM6luF4TTHhHeslEBSgbo0XOSGOyvc7wW8=
X-Received: by 2002:a05:6870:7012:b0:177:c2fb:8cec with SMTP id
 u18-20020a056870701200b00177c2fb8cecmr1469994oae.9.1681225131251; Tue, 11 Apr
 2023 07:58:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230410105056.60973-1-likexu@tencent.com> <20230410105056.60973-6-likexu@tencent.com>
 <CALMp9eTLvJ6GW1mfgjO7CL7tW-79asykyz9=Fb=FfT74VRkDVA@mail.gmail.com>
 <9a7d5814-9eb1-d7af-7968-a6e3ebb90248@gmail.com> <CALMp9eR6DwY0EjAb1hcV9XGWQizN6R0dXtLaC4NXDgtCqv5cTA@mail.gmail.com>
 <81bbb700-9346-3d0d-ab86-6e684b185772@gmail.com>
In-Reply-To: <81bbb700-9346-3d0d-ab86-6e684b185772@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 11 Apr 2023 07:58:40 -0700
Message-ID: <CALMp9eSKnE8+jMpp0KzBRC7NDjT+S2cRz9CcBNDKB7JCU8dmTg@mail.gmail.com>
Subject: Re: [PATCH V5 05/10] KVM: x86/pmu: Disable vPMU if the minimum num of
 counters isn't met
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Tue, Apr 11, 2023 at 6:18=E2=80=AFAM Like Xu <like.xu.linux@gmail.com> w=
rote:
>
> On 11/4/2023 8:58 pm, Jim Mattson wrote:
> > On Mon, Apr 10, 2023 at 11:17=E2=80=AFPM Like Xu <like.xu.linux@gmail.c=
om> wrote:
> >>
> >> On 11/4/2023 1:36 pm, Jim Mattson wrote:
> >>> On Mon, Apr 10, 2023 at 3:51=E2=80=AFAM Like Xu <like.xu.linux@gmail.=
com> wrote:
> >>>>
> >>>> From: Like Xu <likexu@tencent.com>
> >>>>
> >>>> Disable PMU support when running on AMD and perf reports fewer than =
four
> >>>> general purpose counters. All AMD PMUs must define at least four cou=
nters
> >>>> due to AMD's legacy architecture hardcoding the number of counters
> >>>> without providing a way to enumerate the number of counters to softw=
are,
> >>>> e.g. from AMD's APM:
> >>>>
> >>>>    The legacy architecture defines four performance counters (PerfCt=
rn)
> >>>>    and corresponding event-select registers (PerfEvtSeln).
> >>>>
> >>>> Virtualizing fewer than four counters can lead to guest instability =
as
> >>>> software expects four counters to be available.
> >>>
> >>> I'm confused. Isn't zero less than four?
> >>
> >> As I understand it, you are saying that virtualization of zero counter=
 is also
> >> reasonable.
> >> If so, the above statement could be refined as:
> >>
> >>          Virtualizing fewer than four counters when vPMU is enabled ma=
y lead to guest
> >> instability
> >>          as software expects at least four counters to be available, t=
hus the vPMU is
> >> disabled if the
> >>          minimum number of KVM supported counters is not reached durin=
g initialization.
> >>
> >> Jim, does this help you or could you explain more about your confusion=
 ?
> >
> > You say that "fewer than four counters can lead to guest instability
> > as software expects four counters to be available." Your solution is
> > to disable the PMU, which leaves zero counters available. Zero is less
> > than four. Hence, by your claim, disabling the PMU can lead to guest
> > instability. I don't see how this is an improvement over one, two, or
> > three counters.
>
> As you know, AMD pmu lacks an architected method (such as CPUID) to
> indicate that the VM does not have any pmu counters available for the
> current platform. Guests like Linux tend to check if their first counters
> exist and work properly to infer that other pmu counters exist.

"Guests like Linux," or just Linux? What do you mean by "tend"? When
do they perform this check, and when do they not?

> If KVM chooses to emulate greater than 1 less than 4 counters, then the
> AMD guest PMU agent may assume that there are legacy 4 counters all
> present (it's what the APM specifies), which requires the legacy code
> to add #GP error handling for counters that should exist but actually not=
.

I would argue that regardless of the number of counters emulated, a
guest PMU agent may assume that the 4 legacy counters are present,
since that's what the APM specifies.

> So at Sean's suggestion, we took a conservative approach. If KVM detects
> less than 4 counters, we think KVM (under the current configuration and
> platform) is not capable of emulating the most basic AMD pmu capability.
> A large number of legacy instances are ready for 0 or 4+ ctrs, not 2 or 3

Which specific guest operating systems is this change intended for?

> Does this help you ? I wouldn't mind a better move.

Which AMD platforms have less than 4 counters available?

>
> >
> >>>
> >>>> Suggested-by: Sean Christopherson <seanjc@google.com>
> >>>> Signed-off-by: Like Xu <likexu@tencent.com>
> >>>> ---
> >>>>    arch/x86/kvm/pmu.h | 3 +++
> >>>>    1 file changed, 3 insertions(+)
> >>>>
> >>>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> >>>> index dd7c7d4ffe3b..002b527360f4 100644
> >>>> --- a/arch/x86/kvm/pmu.h
> >>>> +++ b/arch/x86/kvm/pmu.h
> >>>> @@ -182,6 +182,9 @@ static inline void kvm_init_pmu_capability(const=
 struct kvm_pmu_ops *pmu_ops)
> >>>>                           enable_pmu =3D false;
> >>>>           }
> >>>>
> >>>> +       if (!is_intel && kvm_pmu_cap.num_counters_gp < AMD64_NUM_COU=
NTERS)

Does this actually guarantee that the requisite number of counters are
available and will always be available while the guest is running?
What happens if some other client of the host perf subsystem requests
a CPU-pinned counter after this checck?

> >>>> +               enable_pmu =3D false;
> >>>> +
> >>>>           if (!enable_pmu) {
> >>>>                   memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
> >>>>                   return;
> >>>> --
> >>>> 2.40.0
> >>>>
