Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DE149C888
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 12:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240639AbiAZLWZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 06:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbiAZLWY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 06:22:24 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFF4C06161C;
        Wed, 26 Jan 2022 03:22:24 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id o11so5698192pjf.0;
        Wed, 26 Jan 2022 03:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=DcnfjljfiqT/xzEtLh/gjs1otCHVMxLp1a++I/N+BGI=;
        b=d1p3iRYPM8vmqp3/IVyo6DDwd3kc8DiV6zqmaaoP4XAIol010Nr/mu5uAldEZ2fMpC
         gyb+bIyvbGtdcToddIWr9wTAv2bH+lOCMJRjUqj5a7VfvE5xTZBxfJEw/bv78wX23jyx
         gMknGBoAxKOY8LUsSW0xgLt0Z2JaFOaQ3WZgCEXA8mfvpTmyJFpvOMuN9hDlz8ZXaqOh
         SpDIekpqadb2pS/NijyOqc4Pk0szBMqGSAMVQ06HPmHyW2gveW4o8Npejwgu9y9oik4r
         4XAremChBh+pdn03CHnCk3IuHOUd+z7/BEwU6w2RZ6lT6/1eXIaBZeX68icfVrpP2QMl
         2bpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=DcnfjljfiqT/xzEtLh/gjs1otCHVMxLp1a++I/N+BGI=;
        b=7kQYMKVwTEBCZF1mqaneKHSoMigHODVdPFF/1OgDU9bNwGkMGhCRGB9AsS+bv24NaB
         hASjPC778lAwP5mpZ3YT6xyjQo2m7Zkpxun7QIGrb7M3cNdlX+7ME1la10ZdmJWb65Ad
         zt4xz+y6AVGg+oez+iViAXmo2hTnk76AtH2DUtkvpVcLPICCA3k5JnR1WrkehilEZBlr
         fhPlZAfBvGi7lZL5F9gaH0mkVBzIer3HcZvE0mU5U8LBN6ztGBSV8PTId8niGXFHYQGL
         NFk50a1FXK7WsgsA+/yf6N1cwPW1yc7sTU92btSgnhm4/7GElEDDUh1sKU1lfl3kVLPK
         6l3w==
X-Gm-Message-State: AOAM531LZtU/+DGPBQhn5JC10MroUTl7KLBSKOtXO7ewissTAiFdAPtF
        dc/mBTB7vG+iEEwTWmsnL2s=
X-Google-Smtp-Source: ABdhPJzO0xi5Fk/D7ECNT7Uv+s752bPTXGgAggKIRT1wW4tBC74c9lplekS9gVrRb8TqQY21Uc+czQ==
X-Received: by 2002:a17:902:7c82:b0:14a:e210:f2d6 with SMTP id y2-20020a1709027c8200b0014ae210f2d6mr22844433pll.74.1643196143651;
        Wed, 26 Jan 2022 03:22:23 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h9sm1903196pfi.54.2022.01.26.03.22.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 03:22:23 -0800 (PST)
Message-ID: <626806ff-7cd0-a6b4-c2f1-933d0a1924a2@gmail.com>
Date:   Wed, 26 Jan 2022 19:22:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH kvm/queue v2 0/3] KVM: x86/pmu: Fix out-of-date AMD
 amd_event_mapping[]
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Bangoria, Ravikumar" <ravi.bangoria@amd.com>,
        Ananth Narayan <ananth.narayan@amd.com>,
        Jim Mattson <jmattson@google.com>
References: <20220117085307.93030-1-likexu@tencent.com>
Organization: Tencent
In-Reply-To: <20220117085307.93030-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

cc AMD folks and ping for any comments.

On 17/1/2022 4:53 pm, Like Xu wrote:
> The current amd_event_mapping[] named "amd_perfmon_event_map" is only
> valid for "K7 and later, up to and including Family 16h" but for AMD
> "Family 17h and later", it needs amd_f17h_perfmon_event_mapp[] .
> 
> It's proposed to fix it in a more generic approach:
> - decouple the available_event_types from the CPUID 0x0A.EBX bit vector;
> - alway get the right perfmon_event_map[] form the hoser perf interface;
> - dynamically populate {inte|amd}_event_mapping[] during hardware setup;
> 
> v1 -> v2 Changelog:
> - Drop some merged patches and one misunderstood patch;
> - Rename bitmap name from "avail_cpuid_events" to "avail_perf_hw_ids";
> - Fix kernel test robot() compiler warning;
> 
> Previous:
> https://lore.kernel.org/kvm/20211112095139.21775-1-likexu@tencent.com/
> 
> Like Xu (3):
>    KVM: x86/pmu: Replace pmu->available_event_types with a new BITMAP
>    perf: x86/core: Add interface to query perfmon_event_map[] directly
>    KVM: x86/pmu: Setup the {inte|amd}_event_mapping[] when hardware_setup
> 
>   arch/x86/events/core.c            |  9 ++++
>   arch/x86/include/asm/kvm_host.h   |  2 +-
>   arch/x86/include/asm/perf_event.h |  2 +
>   arch/x86/kvm/pmu.c                | 25 ++++++++++-
>   arch/x86/kvm/pmu.h                |  2 +
>   arch/x86/kvm/svm/pmu.c            | 23 ++--------
>   arch/x86/kvm/vmx/pmu_intel.c      | 72 ++++++++++++++++++++-----------
>   arch/x86/kvm/x86.c                |  1 +
>   8 files changed, 89 insertions(+), 47 deletions(-)
> 
