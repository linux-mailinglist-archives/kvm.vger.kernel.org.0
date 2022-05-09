Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C400651FB8A
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 13:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbiEILpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 07:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbiEILpX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 07:45:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 097B91BE124
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 04:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652096487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bf0d4LwdBszW2HoKqW0Csu48jPbD9xTwfA3gn01IV/A=;
        b=cT5rBgHmN3MsDyh6Ny5G7joFKZDdAtc1NaTHsrLymI6fJIFS2xCRY3gKKJ6sF733qljOjv
        9ANBySR59edC5LgSPCMj1nFo0XvPfJcRCFa7ebVlGHlv78haXzfANmnkR2rwa395jE7I1y
        SRXaXJzAPmoobIcC9sY/qGcschSyWmY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-ZkXiBlnHNV-7m7P7DtZZgA-1; Mon, 09 May 2022 07:41:26 -0400
X-MC-Unique: ZkXiBlnHNV-7m7P7DtZZgA-1
Received: by mail-ed1-f71.google.com with SMTP id r26-20020a50aada000000b00425afa72622so8102139edc.19
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 04:41:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=Bf0d4LwdBszW2HoKqW0Csu48jPbD9xTwfA3gn01IV/A=;
        b=mHF8Bj5VpPvsrf3jeQrLl/jTu8PzcLSY9qncJJbLO7Dn5aZ4RDXzR+Nz9CMzTG7jgC
         9w28+QmNcIba7Uag7+/QKy0P1lcEwyZzPV5rNOyBtmGmDEkTM3ckvL8vEF356v3p5DQK
         wJecvTxwkth+iW3KI6spG+4L3sz1tTrmYraMhT2++5HDZCJascx+uAxdLsZdtNV3YUe0
         SVkLV0v1eZycfQZT7wCwutRL27MTrtVbDj+Pxz4GNDUmJM+6AUYTzXimxSV7hrr235m7
         Fe/x84frayTZVRuT0ScPkaYnyeFsS2UtN7fUF35FtpubVTCaF/5f+BcXzO3xS8TN65sY
         grAQ==
X-Gm-Message-State: AOAM532MPV7Bi+jDStTxejmyDpHzLQY+cwQkuB84Kw83QHODhy5IN2Ib
        gocmUsjYutiLGvusqZNhtuqDjM/UKj3o6/Ubv3gupB3OCOb8nA69me2ZbEN2xgCx/mE2nbkhwuq
        0MA2iFIxNly7L
X-Received: by 2002:a17:907:3e90:b0:6f7:f63:78b6 with SMTP id hs16-20020a1709073e9000b006f70f6378b6mr11022285ejc.3.1652096484922;
        Mon, 09 May 2022 04:41:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwCkzxuX0xT0C1Tww5G/TqDm4C9Sb5c9/QTjuSai4noiho34YDCJ1QDxMazyXPzv1WpsX7aqA==
X-Received: by 2002:a17:907:3e90:b0:6f7:f63:78b6 with SMTP id hs16-20020a1709073e9000b006f70f6378b6mr11022254ejc.3.1652096484626;
        Mon, 09 May 2022 04:41:24 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id w5-20020a056402268500b0042617ba6389sm6291740edd.19.2022.05.09.04.41.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 04:41:23 -0700 (PDT)
Message-ID: <29767a7d-d887-1a0c-296e-5bed220f1c9e@redhat.com>
Date:   Mon, 9 May 2022 13:41:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Kyle Huey <me@kylehuey.com>, stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        Robert O'Callahan <robert@ocallahan.org>,
        Keno Fischer <keno@juliacomputing.com>
References: <20220508165434.119000-1-khuey@kylehuey.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5.4] KVM: x86/svm: Account for family 17h event
 renumberings in amd_pmc_perf_hw_id
In-Reply-To: <20220508165434.119000-1-khuey@kylehuey.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/8/22 18:54, Kyle Huey wrote:
> From: Kyle Huey <me@kylehuey.com>
> 
> commit 5eb849322d7f7ae9d5c587c7bc3b4f7c6872cd2f upstream
> 
> Zen renumbered some of the performance counters that correspond to the
> well known events in perf_hw_id. This code in KVM was never updated for
> that, so guest that attempt to use counters on Zen that correspond to the
> pre-Zen perf_hw_id values will silently receive the wrong values.
> 
> This has been observed in the wild with rr[0] when running in Zen 3
> guests. rr uses the retired conditional branch counter 00d1 which is
> incorrectly recognized by KVM as PERF_COUNT_HW_STALLED_CYCLES_BACKEND.
> 
> [0] https://rr-project.org/
> 
> Signed-off-by: Kyle Huey <me@kylehuey.com>
> Message-Id: <20220503050136.86298-1-khuey@kylehuey.com>
> Cc: stable@vger.kernel.org
> [Check guest family, not host. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [Backport to 5.4: adjusted context]
> Signed-off-by: Kyle Huey <me@kylehuey.com>
> ---
>   arch/x86/kvm/pmu_amd.c | 28 +++++++++++++++++++++++++---
>   1 file changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
> index 6bc656abbe66..3ccfd1abcbad 100644
> --- a/arch/x86/kvm/pmu_amd.c
> +++ b/arch/x86/kvm/pmu_amd.c
> @@ -44,6 +44,22 @@ static struct kvm_event_hw_type_mapping amd_event_mapping[] = {
>   	[7] = { 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
>   };
>   
> +/* duplicated from amd_f17h_perfmon_event_map. */
> +static struct kvm_event_hw_type_mapping amd_f17h_event_mapping[] = {
> +	[0] = { 0x76, 0x00, PERF_COUNT_HW_CPU_CYCLES },
> +	[1] = { 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },
> +	[2] = { 0x60, 0xff, PERF_COUNT_HW_CACHE_REFERENCES },
> +	[3] = { 0x64, 0x09, PERF_COUNT_HW_CACHE_MISSES },
> +	[4] = { 0xc2, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
> +	[5] = { 0xc3, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
> +	[6] = { 0x87, 0x02, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND },
> +	[7] = { 0x87, 0x01, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
> +};
> +
> +/* amd_pmc_perf_hw_id depends on these being the same size */
> +static_assert(ARRAY_SIZE(amd_event_mapping) ==
> +	     ARRAY_SIZE(amd_f17h_event_mapping));
> +
>   static unsigned int get_msr_base(struct kvm_pmu *pmu, enum pmu_type type)
>   {
>   	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
> @@ -130,17 +146,23 @@ static unsigned amd_find_arch_event(struct kvm_pmu *pmu,
>   				    u8 event_select,
>   				    u8 unit_mask)
>   {
> +	struct kvm_event_hw_type_mapping *event_mapping;
>   	int i;
>   
> +	if (guest_cpuid_family(pmc->vcpu) >= 0x17)
> +		event_mapping = amd_f17h_event_mapping;
> +	else
> +		event_mapping = amd_event_mapping;
> +
>   	for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
> -		if (amd_event_mapping[i].eventsel == event_select
> -		    && amd_event_mapping[i].unit_mask == unit_mask)
> +		if (event_mapping[i].eventsel == event_select
> +		    && event_mapping[i].unit_mask == unit_mask)
>   			break;
>   
>   	if (i == ARRAY_SIZE(amd_event_mapping))
>   		return PERF_COUNT_HW_MAX;
>   
> -	return amd_event_mapping[i].event_type;
> +	return event_mapping[i].event_type;
>   }
>   
>   /* return PERF_COUNT_HW_MAX as AMD doesn't have fixed events */

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks,

Paolo

