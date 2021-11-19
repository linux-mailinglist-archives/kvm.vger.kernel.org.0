Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827CC456E02
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 12:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234985AbhKSLNW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 06:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234973AbhKSLNU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 06:13:20 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D320C061574;
        Fri, 19 Nov 2021 03:10:19 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id b13so7894737plg.2;
        Fri, 19 Nov 2021 03:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=RBmftx8r18XYvlPfX3k5O7sa5Z338CPAboNhPJkfLgg=;
        b=q0oPBUaZ0U0r9znR8JdCJLamOYmBQwv8iA9t3v+RXQSAXoPEvzVLjFG9BxRdhLdul1
         GAJj7RsLjmDrEAMOw4x/XrJRTzKIqut5wo4H1/EM3pA2d3wfFng7B2E0G4mic1Nf+spm
         RT5hcO2cLhjtBeF2yjjBVI1JSmoBua6+lGk+UEak7PN1KlZc7e2ccCt+dKqxa+20KYKo
         mZGUDgLfhZE6RG8207VcAl967LTRC9IctO8dHi1DG5VLs/vlSe6O0unHMurY9k+ZJPTW
         ARLiv/H64Npxmycs841KoO5ANoqVoSvFSoK+1e38hTqPx6NcUiClcE21fy2K9LeWMZpa
         fjOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=RBmftx8r18XYvlPfX3k5O7sa5Z338CPAboNhPJkfLgg=;
        b=gC97sLN9zOHswzjd/A3rBNGll4n526wbt2gQHX3LjBvu6KMCQhoNEKf6BhRJtE2xfY
         xB4iXx0AdZMQTHqxCgS6WpwVzplwmeoFLdWpfxBdQxWNec+irkoxSbxxxlBVo0kokzpS
         VkD+BgOqCnPIpVXeEw1s5ovGCHLCgU4DqhnPRIW6HXoxrvW+u2udlqYznaiHS2mPPhMr
         YmpNA7j4QDkLFVwQ0ZyzSe+xU4OxjEpYQtK7hKAKj7xOzRjO8mV4amjhuM9L4q8TpTD8
         B/Ztt0cowg2UhZGNB8eJppH2luScV5Je4wa+dQFPz+oNooDHQq1s4cLtQwneBYhPzLuL
         ZU1w==
X-Gm-Message-State: AOAM5333WZYpDWkCj0sfRRdBpu2mOO93vMRj3y74G5gxAgT2f/ooZ28D
        zYED1MFLfGmo/7JpDPAQFYE=
X-Google-Smtp-Source: ABdhPJxwOWKtpmR5D2EMTK99IVxhK1F72XBgpPhQjAYdug9PuR1Djar/lDbRP4xPXRRYEBHFOgmtkw==
X-Received: by 2002:a17:903:245:b0:143:c5ba:8bd8 with SMTP id j5-20020a170903024500b00143c5ba8bd8mr51405081plh.64.1637320218872;
        Fri, 19 Nov 2021 03:10:18 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x17sm2379616pfa.209.2021.11.19.03.10.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 03:10:18 -0800 (PST)
Message-ID: <87a11cd6-55aa-025c-2e74-7dc91d82798a@gmail.com>
Date:   Fri, 19 Nov 2021 19:10:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
References: <20211116122030.4698-1-likexu@tencent.com>
 <20211116122030.4698-4-likexu@tencent.com>
 <85286356-8005-8a4d-927c-c3d70c723161@redhat.com>
 <e3b3ad6f-b48a-24fa-a242-e28d2422a7f3@gmail.com>
 <50caf3b7-3f06-10ec-ab65-e3637243eb09@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH 3/4] KVM: x86/pmu: Reuse find_perf_hw_id() and drop
 find_fixed_event()
In-Reply-To: <50caf3b7-3f06-10ec-ab65-e3637243eb09@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/2021 6:29 pm, Paolo Bonzini wrote:
> On 11/19/21 08:16, Like Xu wrote:
>>
>> It's proposed to get [V2] merged and continue to review the fixes from [1] 
>> seamlessly,
>> and then further unify all fixed/gp stuff including intel_find_fixed_event() 
>> as a follow up.
> 
> I agree and I'll review it soon.  Though, why not add the
> 
> +            && (pmc_is_fixed(pmc) ||
> +            pmu->available_event_types & (1 << i)))
> 

If we have a fixed ctr 0 for "retired instructions" event
but the bit 01 of the guest CPUID 0AH.EBX leaf is masked,

thus in that case, we got true from "pmc_is_fixed(pmc)"
and false from "pmu->available_event_types & (1 << i)",

thus it will break and continue to program a perf_event for pmc.

(SDM says, Bit 01: Instruction retired event not available if 1 or if EAX[31:24]<2.)

But the right behavior is that KVM should not program perf_event
for this pmc since this event should not be available (whether it's gp or fixed)
and the counter msr pair can be accessed but does not work.

The proposal final code may look like :

/* UMask and Event Select Encodings for Intel CPUID Events */
static inline bool is_intel_cpuid_event(u8 event_select, u8 unit_mask)
{
	if ((!unit_mask && event_select == 0x3C) ||
	    (!unit_mask && event_select == 0xC0) ||
	    (unit_mask == 0x01 && event_select == 0x3C) ||
	    (unit_mask == 0x4F && event_select == 0x2E) ||
	    (unit_mask == 0x41 && event_select == 0x2E) ||
	    (!unit_mask && event_select == 0xC4) ||
	    (!unit_mask && event_select == 0xC5))
		return true;

	/* the unimplemented topdown.slots event check is kipped. */
	return false;
}

static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
{
	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
	int i;

	for (i = 0; i < PERF_COUNT_HW_MAX; i++) {
		if (kernel_generic_events[i].eventsel != event_select ||
		    kernel_generic_events[i].unit_mask != unit_mask)
			continue;

		if (is_intel_cpuid_event(event_select, unit_mask) &&
		    !test_bit(i, pmu->avail_cpuid_events))
			return PERF_COUNT_HW_MAX + 1;

		break;
	}

	return (i == PERF_COUNT_HW_MAX) ? i : kernel_generic_events[i].event_type;
}


> version in v2 of this patch? :)
> 
> Paolo
> 
>> [1] https://lore.kernel.org/kvm/20211112095139.21775-1-likexu@tencent.com/
>> [V2] https://lore.kernel.org/kvm/20211119064856.77948-1-likexu@tencent.com/
> 
