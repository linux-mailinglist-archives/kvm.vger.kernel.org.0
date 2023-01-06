Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFB865FD81
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 10:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbjAFJUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 04:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbjAFJUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 04:20:07 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2B96C7C7;
        Fri,  6 Jan 2023 01:20:03 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id s9so703892wru.13;
        Fri, 06 Jan 2023 01:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:reply-to
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qklMNUYmcxFOiWDqalcLw1HqhMrUrUGUH0yuIx/r7dw=;
        b=kBuDGrFBD/4F0Qxyc0Q/XNKgtbT9NAwHyEh03m4+XyhTOGM0qhiNMUl4Z4Ts0yThUF
         F88iJy2bOTiKhKAWG6VGZEK8VlPhy85HmGXpLmMph1+gEoGxs3GOyCawshrBw2Js0WQG
         hEMXueoD2Bx3ygREgju+P0E80jfpCbEHF6v4C6B47srZ0inr6lQOZXFoYYsR/t6oXA0B
         UQ16UMfv2oiC4iHdKZ/PqVEf5yU09kBDhzhCvY44RdtvruA4CSfXnscxvPEAtTL31/8+
         mDc70I9+pfAVwucl2awgzjXdmQlTLurnf1AI85zocPgIGk29DN6JVOeAicfWYKkeu0Be
         JlIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:reply-to
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qklMNUYmcxFOiWDqalcLw1HqhMrUrUGUH0yuIx/r7dw=;
        b=cortX4MhiKBjZgiTWKX6NMJ6vCBDGqFhSNrxBg2S0AidFPa8sLmGcIEsCOrqwdNNfG
         ALPLKXGicL42vFJjM8a42UHcfdGQzh9+joTZaTxhNZ76RpQyg4zfZ6P5aBhDgMLiFvJH
         HgrNQZ9RPv28HNtbiHTrFhjlfI0o79GdwmoX/7ifBIC4pwSKbD/Pp6RCgq0xywd+DcSc
         y2H/95iRndBNZ1UJeIt5r7QM/cloB1fazv5YV3qYqZlNe5nWMWz8NRoF8GeUviUhYFBV
         ummQ2XJwLpRzi7olI1wDAN2wapipzftOmDYVMxgj5Ea0Qx34Lmelm3FVblr4oFpe3hDA
         zQdw==
X-Gm-Message-State: AFqh2koOSwYdK0YrUrE/GU52qaYIYa4tcS3CSOUPUjfH636+ZZ+Cm+uS
        ej6HORbzT9+BfUctZwPIr0w=
X-Google-Smtp-Source: AMrXdXuQnHguVnaqUAImY7Ha8tzoIj3tzVYsUFfS+LHX29qYWmEfpDpLz4Y5OmN6m0mRO9FYXyBBlg==
X-Received: by 2002:a5d:4f8c:0:b0:28a:8b5d:6f4e with SMTP id d12-20020a5d4f8c000000b0028a8b5d6f4emr21106702wru.2.1672996802345;
        Fri, 06 Jan 2023 01:20:02 -0800 (PST)
Received: from [192.168.4.98] (54-240-197-231.amazon.com. [54.240.197.231])
        by smtp.gmail.com with ESMTPSA id u14-20020a5d6ace000000b002422bc69111sm734716wrw.9.2023.01.06.01.20.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 01:20:01 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <4aba7537-7c70-4965-46e2-ac36d389ef0a@xen.org>
Date:   Fri, 6 Jan 2023 09:20:00 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v6 1/2] KVM: x86/cpuid: generalize
 kvm_update_kvm_cpuid_base() and also capture limit
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paul Durrant <pdurrant@amazon.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>
References: <20221220134053.15591-1-pdurrant@amazon.com>
 <20221220134053.15591-2-pdurrant@amazon.com> <Y7XU2R0f3pCYF9uz@google.com>
 <82fbc53e-be3e-b516-2420-dc27e5b811e8@gmail.com>
 <Y7cSdYWX8e3FqlrO@google.com>
Reply-To: paul@xen.org
Organization: Xen Project
In-Reply-To: <Y7cSdYWX8e3FqlrO@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/01/2023 18:09, Sean Christopherson wrote:
> On Thu, Jan 05, 2023, Paul Durrant wrote:
>> On 04/01/2023 19:34, Sean Christopherson wrote:
>>> Since the struct is a 64-bit value, what about making this a pure getter that
>>> returns a copy?
>>>
>>> static struct kvm_hypervisor_cpuid kvm_get_hypervisor_cpuid(struct kvm_vcpu *vcpu,
>>> 							    const char *sig)
>>> {
>>> 	struct kvm_hypervisor_cpuid cpuid = {};
>>> 	struct kvm_cpuid_entry2 *entry;
>>> 	u32 function;
>>>
>>> 	for_each_possible_hypervisor_cpuid_base(cpuid.base) {
>>> 		entry = kvm_find_cpuid_entry(vcpu, function);
>>>
>>> 		if (entry) {
>>> 			u32 signature[3];
>>>
>>> 			signature[0] = entry->ebx;
>>> 			signature[1] = entry->ecx;
>>> 			signature[2] = entry->edx;
>>>
>>> 			if (!memcmp(signature, sig, sizeof(signature))) {
>>> 				cpuid.base = function;
>>> 				cpuid.limit = entry->eax;
>>> 				break;
>>> 			}
>>> 		}
>>> 	}
>>>
>>> 	return cpuid;
>>> }
>>>
>>>
>>> 	vcpu->arch.kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
>>> 	vcpu->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);
>>
>> Yes, if that's preferable then no problem.
> 
> I like it (obviously), but it's probably worth waiting a few days to see what
> others think before posting a new version.

I think it's cleaner too, and I already did the typing so I may as well 
post. I don't think anyone else has expressed any strong opinions on the 
code either way.

Paul
