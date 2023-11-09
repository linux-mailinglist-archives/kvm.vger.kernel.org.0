Return-Path: <kvm+bounces-1352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 567187E6E17
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 16:55:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1878A2810EE
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 15:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF38420B37;
	Thu,  9 Nov 2023 15:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="elmMbCuH"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29743208BC
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 15:55:49 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573FC270E
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 07:55:48 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7cc433782so13386157b3.3
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 07:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699545347; x=1700150147; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LIV0OIBtO/qEXjcwFa8rlo/bkTpqYyvIzQur9Hu2Qhs=;
        b=elmMbCuHGjmMGTYLrs9pdF/CJ9097pLAy+R7TYoStB/mA5LnEMcQqefeUu+cR4DaDw
         dNIDJpPIkqFORFySnj2KZ0bpmw8AdWdCuq9IK8VSLikNaNApOr9XzMCVFrbwFMlrYOyb
         d8afeYo0We9B/Jt6gVOQDGQ9JpNt/imEEezhIEcFfYXi8Pyv45NCN2qapcAYPXOnrK+Q
         g8cERphO/Jp20EYPeOlfKaexzJysIg0OlfexqhaFLWwdHNlAeHaCE0E9ZsoqBZ/IunC8
         dxH0pAiPycB3Z7IOEiMbGar/gpMascpfsM13FZCkvMD0zPVIw9N9Ym7RuMQYdWuo/70I
         Q1gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699545347; x=1700150147;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LIV0OIBtO/qEXjcwFa8rlo/bkTpqYyvIzQur9Hu2Qhs=;
        b=Q0Q0CfFY/woJOzNunw/GGi44uYR7MkYn0DNnNtWNhjDhJGsQjUDNjs96yMUaOMPUEy
         XGjZgjw67ASQO3qicMUPZZ5La235xgdJqMWeYnu1cBWEKIHN6x5ZgCjokUQ0LQlcro1o
         yvvE8LGOYqW8e52TYxA+cyTBKA7Lv3j8rNX2Hla5JsEIJtzj9Nisa1YszFoQOXOIhY6L
         FZOfFZRrNWqtb5Aq5FBnkC5DmLUBOLecjoyjtK9wJuIi8CrdII87yRr8b0n75uuxQoCv
         ZPS+kGfNuaivzGyPwL+O0xxQKUOFbARPMalhaHWt+T0wbHhMTCLCf5qHCo88UbsicpVk
         2lhw==
X-Gm-Message-State: AOJu0YxjH9FRU+5qRtmjfkyPC5uzIEeQE+sx6TJcAezv5TFWWZRLHJtg
	hGkUkQ8/h3i3slLDglIgIUfTmZ4O7+0=
X-Google-Smtp-Source: AGHT+IEMEShf0mykk0aG8QQsdHk7vwrzkzv/Ox7kVvv3Xl7bbuRdh2hiw2H6Gx6DhoX5AbdU/WOx4VMJWVk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:310:b0:5bf:6098:58dc with SMTP id
 bg16-20020a05690c031000b005bf609858dcmr88627ywb.9.1699545347576; Thu, 09 Nov
 2023 07:55:47 -0800 (PST)
Date: Thu, 9 Nov 2023 07:55:45 -0800
In-Reply-To: <20231108235456.GB1132821@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1699383993.git.isaku.yamahata@intel.com>
 <20231107192933.GA1102144@ls.amr.corp.intel.com> <CALMp9eR8Jnn0g0XBpTKTfKKOtRmFwAWuLAKcozuOs6KAGZ6MQQ@mail.gmail.com>
 <20231108235456.GB1132821@ls.amr.corp.intel.com>
Message-ID: <ZU0BASXWcck85r90@google.com>
Subject: Re: KVM: X86: Make bus clock frequency for vapic timer (bus lock ->
 bus clock) (was Re: [PATCH 0/2] KVM: X86: Make bus lock frequency for vapic
 timer) configurable
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@linux.intel.com>
Cc: Jim Mattson <jmattson@google.com>, isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, 
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 08, 2023, Isaku Yamahata wrote:
> On Tue, Nov 07, 2023 at 12:03:35PM -0800, Jim Mattson <jmattson@google.com> wrote:
> > I think I know the answer, but do you have any tests for this new feature?
> 
> If you mean kvm kselftest, no.
> I have
> - TDX patched qemu
> - kvm-unit-tests: test_apic_timer_one_shot() @ kvm-unit-tests/x86/apic.c
>   TDX version is found at https://github.com/intel/kvm-unit-tests-tdx
>   We're planning to upstream the changes for TDX
> 
> How far do we want to go?
> - Run kvm-unit-tests with TDX. What I have right now.
> - kvm-unit-tests: extend qemu for default VM case and update
>   test_apic_timer_one_host()

Hrm, I'm not sure that we can do a whole lot for test_apic_timer_one_shot().  Or
rather, I'm not sure it's worth the effort to try and add coverage beyond what's
already there.

As for TDX, *if* we extend KUT, please don't make it depend on TDX.  Very few people
have access to TDX platforms and anything CoCo is pretty much guaranteed to be harder
to debug.

> - kselftest
>   Right now kvm kselftest doesn't have test cases even for in-kernel IRQCHIP
>   creation.

Selftests always create an in-kernel APIC.  And I think selftests are perfectly
suited to complement the coverage provided by KUT.  Specifically, the failure
scenario for this is that KVM emulates at 1Ghz whereas TDX advertises 25Mhz, i.e.
the test case we want is to verify that the APIC timer doesn't expire early.

There's no need for any APIC infrastructure, e.g. a selftest doesn't even need to
handle an interrupt.  Get the TSC frequency from KVM, program up an arbitrary APIC
bus clock frequency, set TMICT such that it expires waaaay in the future, and then
verify that the APIC timer counts reasonably close to the programmed frequency.
E.g. if the test sets the bus clock to 25Mhz, the "drift" due to KVM counting at
1Ghz should be super obvious.

LOL, side topic, KUT has this:

	/*
	 * For LVT Timer clock, SDM vol 3 10.5.4 says it should be
	 * derived from processor's bus clock (IIUC which is the same  <======
	 * as TSC), however QEMU seems to be using nanosecond. In all
	 * cases, the following should satisfy on all modern
	 * processors.
	 */
	report((lvtt_counter == 1) && (tsc2 - tsc1 >= interval),
	       "APIC LVT timer one shot");

