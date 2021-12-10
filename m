Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEECD46FEA2
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 11:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240033AbhLJKY2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 05:24:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbhLJKYW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 05:24:22 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99542C061746;
        Fri, 10 Dec 2021 02:20:47 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id h24so6526454pjq.2;
        Fri, 10 Dec 2021 02:20:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=xpuvc+9Hl9NOllZ3htk7q/dYvdJaqcq3/ayg7ngaxwI=;
        b=o7dfCqVFokBdFn5RTMIZncQkgRoWwGOhIF4XcgTN8WdqM22C1kOuGobMG4C8vBIK/L
         6VEKa0AQXihE+Omi11daz1bxLayXaBUgGnk6VCcbItEEm/5jgCRMsL/tzxDLRi33gHJ5
         9KRdsWjIHoMDqzvuqmsT8NIHQ2dUIWG+hCtGb9A0TumsUtj6wZHBi2dU5AdpMcHbDxE2
         cv47EBg12yejCF6DmuWYzwI2EyDVf1lKIhoMhEbnrrqgHd7ky1H9y5Qvr8aW/RNUEVa4
         pOMTYvzsNTn4YzKZVKZ8A23avOhXszCTBjKp13hC+qzYv9nen+CpsLVkOOsDNFJIGJhW
         eKBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=xpuvc+9Hl9NOllZ3htk7q/dYvdJaqcq3/ayg7ngaxwI=;
        b=xJb3o+6LIthyNI5pZOU6g2ZNlcNYk13OnCp3h4XG7dCzpGQO3KvrbAwRezbq4elUvA
         NQh84iBmMHY36bnRJO9SvU1qYsXF1W1WDxwj7RWcV3AIKRcR86zVGYNbDqNAJ0m2Flrh
         pdITd0wF+lA6DYHCoD+4ZX9ePfqx1I8SHtLHL8gvLDYjqaLQttzZgBjPggYZ8IvO/4iu
         guff1sztD50GgncGDyE5wqRC/v1kXWwSGxnvW7oiEUcKykwHwVtNnda14v4Q72pF+WTn
         16nvxPP0AvHEGPG1AoRNxLnVrNc/wt7f347EQpz1RIP7o2YIjsb7t0zwaNDDQxLayCkf
         zimw==
X-Gm-Message-State: AOAM532yJS+sIZ619jKClmfA/591DJxhr10qv9CaTjZval73tiVLuYBZ
        2Mnk0KVkS7dOz29NVIooFxA=
X-Google-Smtp-Source: ABdhPJwK3FptORjh/RyUz1zT7RXxi5ivrHDnyM1UhbTDZ7dJnN7sMP51cmGp9iQfoI/NErikh0lWbg==
X-Received: by 2002:a17:902:d50e:b0:142:1b2a:144 with SMTP id b14-20020a170902d50e00b001421b2a0144mr74757099plg.51.1639131647228;
        Fri, 10 Dec 2021 02:20:47 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id w7sm2292559pgo.56.2021.12.10.02.20.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 02:20:46 -0800 (PST)
Message-ID: <0815b30f-c0e5-4261-df03-bd82d69b05c7@gmail.com>
Date:   Fri, 10 Dec 2021 18:20:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        linux-perf-users@vger.kernel.org
References: <20211130074221.93635-1-likexu@tencent.com>
 <20211130074221.93635-2-likexu@tencent.com>
 <CALMp9eT05nb56b16KkybvGSTYMhkRusQnNL4aWFU8tsets0O2w@mail.gmail.com>
 <8ca78cd6-12ad-56c4-ad73-e88757364ba9@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH v2 1/6] KVM: x86/pmu: Setup pmc->eventsel for fixed PMCs
In-Reply-To: <8ca78cd6-12ad-56c4-ad73-e88757364ba9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/2021 2:49 am, Paolo Bonzini wrote:
> 
> or we modify find_fixed_event and its caller to support PERF_TYPE_RAW
> counters, and then add support for the IceLake TOPDOWN.SLOTS fixed
> counter.

It looks like the TOPDOWN approach from "Yasin Ahmad"
has recently been widely advertised among developers.

But I still need bandwidth to clean up some perf driver stuff
in order to enable topdown counter smoothly in the guest.

cc linux-perf-users@vger.kernel.org for user voices.

> 
> What's your preference?
> 
> Paolo
