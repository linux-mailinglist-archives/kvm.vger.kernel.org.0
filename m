Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5975B44FD89
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 04:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236967AbhKODqc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Nov 2021 22:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236750AbhKODqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Nov 2021 22:46:31 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4313C061746
        for <kvm@vger.kernel.org>; Sun, 14 Nov 2021 19:43:34 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id b13so13349584plg.2
        for <kvm@vger.kernel.org>; Sun, 14 Nov 2021 19:43:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to
         :references:from:organization:cc:subject:in-reply-to
         :content-transfer-encoding;
        bh=uzS4tJ+rfzbhaAxhadHg/+nXGcG4mCIEMyFkUf3pKxg=;
        b=S2cvwUMYDGKnXyKZ8vuRS50uJF/6keNG1SkgtLrHHEm0kf7Cl/5vTaRYIa38d6Z912
         asgzszKYBlQfo8Oh61zfWLwKeMG1C6jrVgb3vwNT6AVr8Q5bFavFjOI8aSoPHeCKAC20
         AkPv0MqsY7zWSKlRRtuA/uubiWbgO/Do3XpAP7bObznIN/5HK2eaXZoOp+96YgvGSi77
         VwF4WQikDJGqppkEVYqu9yLhUkux78jd+2jPNDR7jnk68YyvnFB2kUQUJI/J2ofPgrXi
         hcvdHPFrvc1xZMrCxhcX4m9m/ccCrlpIFFcMAPlEyFO7/NH92KX57QJCye1MzVLi3Hj0
         qLbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:references:from:organization:cc:subject
         :in-reply-to:content-transfer-encoding;
        bh=uzS4tJ+rfzbhaAxhadHg/+nXGcG4mCIEMyFkUf3pKxg=;
        b=ivlwCCHUC+PnsWBr31km7heQUGZnk2y/SCd/2OXzgZZUxrfMZ3kDio+jAVFk/EkxKc
         cB6iBJeZIcPTreT0Co2PogCvMEa5PtO13qENh2FQPdAD1tGGkedht1i3Qwqbag8WnITt
         DiLRfyZeqmnytXzVMpb0DzYZSaX3lPogvHzxoWLDmV25gyFkVP6BVqDZqdlcQyjF5c68
         i2W1gmaqaSPYmzrKULM9At8SBYJQgdLimACq7hSdZz3fZtalBwIDmlIzyR7tG22XnUPw
         LgRElVaJKjyKUJ9uBOatc9fMDCn+bzVJF343ZcPya3rmdIbucHg3i3ZfpaTSL14g1Fvf
         emKg==
X-Gm-Message-State: AOAM532gHxzmrlK3c7wXO1TAO2CqaMh5Z6e/JFdBCKwZaBFKhZlCNIl3
        dfQN+DTp38vHCAxkuGZUht4=
X-Google-Smtp-Source: ABdhPJyH35KjifkzzDUmY2Pfd66kZphGUlsGp9HHmcYx4THDdxrNuWJA0SmirJlQ237e5R4JPOrUaA==
X-Received: by 2002:a17:90a:af94:: with SMTP id w20mr14500814pjq.223.1636947814436;
        Sun, 14 Nov 2021 19:43:34 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u22sm13111607pfi.187.2021.11.14.19.43.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Nov 2021 19:43:33 -0800 (PST)
Message-ID: <d4f3b54a-3298-cec3-3193-da46ae9a1f09@gmail.com>
Date:   Mon, 15 Nov 2021 11:43:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
References: <20211112235235.1125060-1-jmattson@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Cc:     kvm@vger.kernel.org,
        "Inc. (kernel-recipes.org)" <pbonzini@redhat.com>
Subject: Re: [PATCH 0/2] kvm: x86: Fix PMU virtualization for some basic
 events
In-Reply-To: <20211112235235.1125060-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/11/2021 7:52 am, Jim Mattson wrote:
> Google Cloud has a customer that needs accurate virtualization of two
> architected PMU events on Intel hardware: "instructions retired" and
> "branch instructions retired." The existing PMU virtualization code
> fails to account for instructions that are emulated by kvm.

Does this customer need to set force_emulation_prefix=Y ?

Is this "accurate statistics" capability fatal to the use case ?

> 
> Accurately virtualizing all PMU events for all microarchitectures is a
> herculean task, but there are only 8 architected events, so maybe we
> can at least try to get those right.

I assume you mean the architectural events "Instruction Retired"
and "Branch Instruction Retired" defined by the Intel CPUID
since it looks we don't have a similar concept on AMD.

This patch set opens Pandora's Box, especially when we have
the real accurate Guest PEBS facility, and things get even
more complicated for just some PMU corner use cases.

> 
> Eric Hankland wrote this code originally, but his plate is full, so
> I've volunteered to shepherd the changes through upstream acceptance.

Does Eric have more code to implement
accurate virtualization on the following events ?

"UnHalted Core Cycles"
"UnHalted Reference Cycles"
"LLC Reference"
"LLC Misses"
"Branch Misses Retired"
"Topdown Slots" (unimplemented)

Obviously, it's difficult, even absurd, to emulate these.

> 
> Jim Mattson (2):
>    KVM: x86: Update vPMCs when retiring instructions
>    KVM: x86: Update vPMCs when retiring branch instructions
> 
>   arch/x86/kvm/emulate.c     | 57 +++++++++++++++++++++-----------------
>   arch/x86/kvm/kvm_emulate.h |  1 +
>   arch/x86/kvm/pmu.c         | 31 +++++++++++++++++++++
>   arch/x86/kvm/pmu.h         |  1 +
>   arch/x86/kvm/vmx/nested.c  |  6 +++-
>   arch/x86/kvm/x86.c         |  5 ++++
>   6 files changed, 75 insertions(+), 26 deletions(-)
> 
