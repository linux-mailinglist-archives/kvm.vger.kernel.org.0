Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A144492D32
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 19:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244576AbiARSWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 13:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244533AbiARSWr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 13:22:47 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DB6C06173E
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 10:22:47 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id a10-20020a9d260a000000b005991bd6ae3eso11825405otb.11
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 10:22:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1q/ydx49keEZGWsAWRg7W9al0WAO2oLskLJ8Qk4a3uA=;
        b=Ti3pXq5PWkDKY2e94msFAZE9zQGy9QZOFNgzR4fLpdLlmvXEobm2Br9/aw0TkwMMML
         gL/ivfTK5tpd25PDCCTleoLGVSPM58hXUlD3qR7jHRb/MaihBFQF1uUjdopF/kfCZY/v
         iUZTzB/AO2Jcutw9XZUhUPnnQsp7nMOQCyNI0LpYgMOYp6kKr8Pg2ZWwZFW5AfflaBHs
         gHPjfX3D2uYXhme4R3KAoEXdlzlZH+6Xp6J5OfxKVg953/vW31RYyUKV+bS00InLVJih
         7IS/AGDVBI+Gf692c73nxgFdSHBzQITpz8Q/8KWF9urpq5z7kEHPvsoAKt+VdB3s3a8i
         KsPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1q/ydx49keEZGWsAWRg7W9al0WAO2oLskLJ8Qk4a3uA=;
        b=qVIfbTBD2ex/BzjTmp2S095HJux1hE9D4zcThhB5vTXV1DLAUmfKgci/Sc0U9BBlKc
         DR4SWdxngca2SIuXEjTSz6kjhNfhs4WtCFeO5hp8QG2G4p4iCiSSVQYXgaTl33/0nMzY
         HjZeIqS/fEKHtbBv/WaAB0+VItKjRZCZLLTPf4SkM04plupRvvmxwsRqhnEn/qc+WAnE
         2SRaqgpMogWG3A0yLMDv17yrxzSQYA7CoKrP2yWRhbBMqIRG2e47/JMfq0z2wkaZikPm
         8c8YbQblgc5jY6OIKIn6txWIb0J3waD53pzEyuxT1E7emLvhFN/Etk6Oax5xfC0CMHoV
         n+Yw==
X-Gm-Message-State: AOAM533y2n8BpLSEicpW2GV/jmgOZ0gD8evLLm04a+I0dJEUNrSTgcTX
        FWonK686HwpnEHxIsdCkW3y8W/ZJzRvq2/fgGgUA1g==
X-Google-Smtp-Source: ABdhPJwOULlAveoN8jDLIzZCo5aBoG3v2UUBO58ENvhePozWMYoNZ6zqfzh9m0ZNRe07m/E2+L+g2Ea953jmmvaSv0Y=
X-Received: by 2002:a9d:12f7:: with SMTP id g110mr21978798otg.299.1642530166827;
 Tue, 18 Jan 2022 10:22:46 -0800 (PST)
MIME-Version: 1.0
References: <CALMp9eQZa_y3ZN0_xHuB6nW0YU8oO6=5zPEov=DUQYPbzLeQVA@mail.gmail.com>
 <453a2a09-5f29-491e-c386-6b23d4244cc2@gmail.com> <CALMp9eSkYEXKkqDYLYYWpJ0oX10VWECJTwtk_pBWY5G-vN5H0A@mail.gmail.com>
 <CALMp9eQAMpnJOSk_Rw+pp2amwi8Fk4Np1rviKYxJtoicas=6BQ@mail.gmail.com> <b3cffb4b-8425-06bb-d40e-89e7f01d5c05@gmail.com>
In-Reply-To: <b3cffb4b-8425-06bb-d40e-89e7f01d5c05@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 18 Jan 2022 10:22:35 -0800
Message-ID: <CALMp9eRhdLKq0Y372e+ZGnUCtDNQYv7pUiYL0bqJsYCDfqTpcQ@mail.gmail.com>
Subject: Re: PMU virtualization and AMD erratum 1292
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Ananth Narayan <ananth.narayan@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 17, 2022 at 10:25 PM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 18/1/2022 12:08 pm, Jim Mattson wrote:
> > On Mon, Jan 17, 2022 at 12:57 PM Jim Mattson <jmattson@google.com> wrote:
> >>
> >> On Sun, Jan 16, 2022 at 8:26 PM Like Xu <like.xu.linux@gmail.com> wrote:
> >> ...
> >>> It's easy for KVM to clear the reserved bit PERF_CTL2[43]
> >>> for only (AMD Family 19h Models 00h-0Fh) guests.
> >>
> >> KVM is currently *way* too aggressive about synthesizing #GP for
> >> "reserved" bits on AMD hardware. Note that "reserved" generally has a
> >> much weaker definition in AMD documentation than in Intel
> >> documentation. When Intel says that an MSR bit is "reserved," it means
> >> that an attempt to set the bit will raise #GP. When AMD says that an
> >> MSR bit is "reserved," it does not necessarily mean the same thing.
>
> I agree. And I'm curious as to why there are hardly any guest user complaints.
>
> The term "reserved" is described in the AMD "Conventions and Definitions":
>
>         Fields marked as reserved may be used at some future time.
>         To preserve compatibility with future processors, reserved fields require
> special handling when
>         read or written by software. Software must not depend on the state of a
> reserved field (unless
>         qualified as RAZ), nor upon the ability of such fields to return a previously
> written state.
>
>         If a field is marked reserved *without qualification*, software must not change
> the state of
>         that field; it must reload that field with the same value returned from a prior
> read.
>
>         Reserved fields may be qualified as IGN, MBZ, RAZ, or SBZ.
>
> For AMD, #GP comes from "Writing 1 to any bit that must be zero (MBZ) in the MSR."
>
> >> (Usually, AMD will write MBZ to indicate that the bit must be zero.)
> >>
> >> On my Zen3 CPU, I can write 0xffffffffffffffff to MSR 0xc0010204,
> >> without getting a #GP. Hence, KVM should not synthesize a #GP for any
> >> writes to this MSR.
> >>
>
> ; storage behind bit 43 test
> ; CPU family:          25
> ; Model:               1
>
> wrmsr -p 0 0xc0010204 0x80000000000
> rdmsr -p 0 0xc0010204 # return 0x80000000000

Oops. You're right. The host that I thought was a Zen3 was actually a
Zen2. Switching to an actual Zen3, I find that there is storage behind
bits 42 and 43, both of which are indicated as reserved.


> >> Note that the value I get back from rdmsr is 0x30fffdfffff, so there
> >> appears to be no storage behind bit 43. If KVM allows this bit to be
> >> set, it should ensure that reads of this bit always return 0, as they
> >> do on hardware.
>
> The PERF_CTL2[43] is marked reserved without qualification in the in Figure 13-7.
>
> I'm not sure we really need a cleanup storm of #GP for all SVM's non-MBZ
> reserved bits.

OTOH, we wouldn't need to have this discussion if these MSRs had been
implemented correctly to begin with.

> >
> > Bit 19 (Intel's old Pin Control bit) seems to have storage behind it.
> > It is interesting that in Figure 13-7 "Core Performance Event-Select
> > Register (PerfEvtSeln)" of the APM volume 2, this "reserved" bit is
> > not marked in grey. The remaining "reserved" bits (which are marked in
> > grey), should probably be annotated with "RAZ."
> >
>
> In any diagram, we at least have three types of "reservation":
>
> - Reserved + grey
> - Reserved, MBZ + grey
> - Reserved + no grey
>
> So it is better not to think of "Reserved + grey" as "Reserved, MBZ + grey".

Right. None of these bits MBZ. I was observing that the grey fields
RAZ. However, that observation was on Zen2. Zen3 is different. Now,
it's not clear to me what the grey highlights mean. Perhaps nothing at
all.
