Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62AB74821EC
	for <lists+kvm@lfdr.de>; Fri, 31 Dec 2021 05:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242658AbhLaEAu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Dec 2021 23:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbhLaEAu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Dec 2021 23:00:50 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDE6C061574;
        Thu, 30 Dec 2021 20:00:49 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so29607221pjj.2;
        Thu, 30 Dec 2021 20:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=77h7/M3O/tWcwB1TVuLaAEEhvGIK19Mi+7+lByjGYqs=;
        b=A79vWq8Fny8BNDJsc0FsgLYMAgz9ju3fEYj8NesMp8i5eLDf/fProVh8bgNHIatR9l
         iWPr/+vAsYkwb32T3UKotty+teCit/Kx92ts71fz+IO/iLwChdsPGdXIEOZ0cX9H14vm
         ibdvPN/cEA/fH5w73LZo7moewehJa8glpOBVfw324ztdSvE5WXBusyKFDEL9wsuMR2/8
         CK1ApoluR3obYAfNsJxcO7Y38NPKS9W4f+rRchq3vQc/Kj2qr/IRBAxVKZUXcgfmdWtU
         x9MOTlqU+ueZLG9fjefYaD6a9Id3SNmGygxVC2iNTlQwB7WVib1BYVWfBnNdTX92Fvsm
         i6VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=77h7/M3O/tWcwB1TVuLaAEEhvGIK19Mi+7+lByjGYqs=;
        b=Ek9QEPOG8s7NMc6aZCuKPeGZZma376mLOvz2/vzAKOnSEC7sTwMCrF7U1lwIHGyM9u
         S7d4dgPbNpGaqWrXYphktfgXK1VueUGzzDBBPrcsJGB4sxr5l4+AtZh5tVSSvWZ6XLfP
         oCNwak9EPFk4fjs68zaYx/0/sKJWyiXqp0aco0+WFZWgTQ/D0Zi8r3LrEncAACyruPx2
         ujgiEc9zM8pAaU9CSZ6wMsKaBIdGwJvY7AhKvCP97DvwPa7CM/JRr+jNJ5djE02Hv4Cq
         bs5cbYNdUqhecQDz258WMenoLI63hWcT0dv433d/k3A/xN15OXZNFuDcHZtYc26R/N58
         gmag==
X-Gm-Message-State: AOAM531KEXkUmch6aGq3npaGz8tsRt1SvLtVUdcEuj5XKmv2Ygz2IIqw
        NGp4cLZfHis8FF7GYrMphCg=
X-Google-Smtp-Source: ABdhPJxYoPV/JlIx5DQlw2Qgr1EB8qbo1vsjNHcvSNHnSFn54fSTPSvnDzVDT6VKxtF3M6rjNqJZsQ==
X-Received: by 2002:a17:90b:3c0c:: with SMTP id pb12mr40972455pjb.105.1640923248893;
        Thu, 30 Dec 2021 20:00:48 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u8sm30204230pfg.157.2021.12.30.20.00.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Dec 2021 20:00:48 -0800 (PST)
Message-ID: <69ad949e-4788-0f93-46cb-6af6f79a9f24@gmail.com>
Date:   Fri, 31 Dec 2021 12:00:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Like Xu <likexu@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211210133525.46465-1-likexu@tencent.com>
 <20211210133525.46465-2-likexu@tencent.com> <Yc321e9o16luwFK+@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH v11 01/17] perf/x86/intel: Add EPT-Friendly PEBS for Ice
 Lake Server
In-Reply-To: <Yc321e9o16luwFK+@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/12/2021 2:13 am, Sean Christopherson wrote:
> On Fri, Dec 10, 2021, Like Xu wrote:
>> From: Like Xu <like.xu@linux.intel.com>
>>
>> From: Like Xu <like.xu@linux.intel.com>
> 
> Did one of these get handcoded?

Uh, now I have found the use of "--from=<ident>".

> 
>> The new hardware facility supporting guest PEBS is only available on
>> Intel Ice Lake Server platforms for now. KVM will check this field
>> through perf_get_x86_pmu_capability() instead of hard coding the cpu
>> models in the KVM code. If it is supported, the guest PEBS capability
>> will be exposed to the guest.
> 
> So what exactly is this new feature?  I've speed read the cover letter and a few
> changelogs and didn't find anything that actually explained when this feature does.
> 

Please check Intel SDM Vol3 18.9.5 for this "EPT-Friendly PEBS" feature.

I assume when an unfamiliar feature appears in the patch SUBJECT,
the reviewer may search for the exact name in the specification.

> Based on the shortlog, I assume the feature handles translating linear addresses
> via EPT?  If that's correct, then x86_pmu.pebs_vmx should be named something like
> x86_pmu.pebs_ept.

"Translating linear addresses via EPT" is only part of the hardware implementation,
and we may apply the new name if there are no other objections.

> 
> That also raises the question of what will happen if EPT is disabled.  Presumably
> things will Just Work since no additional translation is needed, but if that's the
> case then arguably vmx_pebs_supported() should be:
> 
> 	return boot_cpu_has(X86_FEATURE_PEBS) &&
> 	       (!tdp_enabled || kvm_pmu_cap.pebs_vmx);

Yes, a similar fix is already on my private tree, and thank you for pointing it out!

> 
> I'm guessing no one actually cares about supporting PEBS on older CPUs using shadow
> paging, but the changelog should at least call out that PEBS is allowed if and only
> if "pebs_vmx" is supported for simplicity, even though it would actually work if EPT
> is disabled.  And if for some reason it _doesn't_ work when EPT is disabled, then
> vmx_pebs_supported() and friends need to actually check tdp_enabled.

Yes, the guest PEBS only works when EPT is enabled on the newer modern CPUs.

> 
> Regardless, this changelog really, really needs an explanation of the feature.

Thank you for picking up, I will update the changelog for this commit.

Please let me know if you have any more obstacles or niggles to review this 
patch set.

Thanks,
Like Xu
