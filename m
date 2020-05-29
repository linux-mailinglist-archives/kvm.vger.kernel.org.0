Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370691E7CFC
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 14:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgE2MSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 08:18:02 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48403 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725306AbgE2MSC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 08:18:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590754680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZAoc7g+SypvscNqSSgFikPZ4GSUD+foVb3L3OUQy8To=;
        b=dz1f/+fin0NjqfrkeL2lHjwv0R4NXenseQZ34jIA5z8yY+xQQ0/88qrX1M+mG4dCY6O7D5
        mEz2hna36QZHLw6Afrg0gYlmPxuvjm2AiGjcDNUusGmXJ1EIEIlQP/He/SXOnkoHuSlUfU
        2RnVencvoWd7roiWLhOHjiqgdL6VeCY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-nbfgMi1_PVG7euMsOf2iBg-1; Fri, 29 May 2020 08:17:58 -0400
X-MC-Unique: nbfgMi1_PVG7euMsOf2iBg-1
Received: by mail-wm1-f71.google.com with SMTP id l26so620487wmh.3
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 05:17:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZAoc7g+SypvscNqSSgFikPZ4GSUD+foVb3L3OUQy8To=;
        b=TpVMkCumU8rcOrI/L45y+y3sUrDPCeoSJo+oz3gB0lWY+Fqhba/1ocZltxcbigoWpX
         V/+x2I113ex0+aLI27unHR/wM908QYf6wANPiOHIjN88nS9ngB8cOUQX+C7STVId58+4
         awazHULsbeJHyom2h3nZkqiHl4vpLFEDZfkNwe8Hb0F8DQIWuBDv0WVIkuzGnTiFAaco
         34JuSuJBE/6VbkvW/rLpqeb/JIK9n/LDaunsnduxM0VK0UV11/n1RZ7tcrAqc93jh+yR
         3/GDzZyaB2MirQaiLiatYvrIPyh0qWO+x9TQV9WBuWhWSjSm32U9mdYFQ/UCSPPrH1rM
         exiw==
X-Gm-Message-State: AOAM532gsMj7w1WhCnAFA7ePA0sBBDFW6gLk7Fxmw3r3EhY0QjL4o9ZW
        JBxxdgYcrMwQi6sW/TAZz6H1Zm8tC/ecY61SjnSOTl5+C9oo6Mc/bsHmpfGTK8k+5QTZzYGBHyR
        7HfOaX79MVDVu
X-Received: by 2002:a5d:40d0:: with SMTP id b16mr8328695wrq.218.1590754677646;
        Fri, 29 May 2020 05:17:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw97y5rG2FUBughZ29PI1wmLhQfN16iF7uV9cR7qhTbrwm1W8JNTt7MLqLn+LXensqrIP30xg==
X-Received: by 2002:a5d:40d0:: with SMTP id b16mr8328677wrq.218.1590754677377;
        Fri, 29 May 2020 05:17:57 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.160.89])
        by smtp.gmail.com with ESMTPSA id d5sm10036438wrb.14.2020.05.29.05.17.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 05:17:56 -0700 (PDT)
Subject: Re: [PATCH v11 4/7] x86/kvm/hyper-v: Add support for synthetic
 debugger capability
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Jon Doron <arilou@gmail.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org
References: <20200424113746.3473563-1-arilou@gmail.com>
 <20200424113746.3473563-5-arilou@gmail.com>
 <12df4348-3dc1-a4cc-aa41-4492cd42dcc8@redhat.com>
 <87ftbjhrk0.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6102aaf8-0ee0-b6cd-dce3-bb91376a1b5e@redhat.com>
Date:   Fri, 29 May 2020 14:17:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87ftbjhrk0.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/05/20 14:08, Vitaly Kuznetsov wrote:
>> On 24/04/20 13:37, Jon Doron wrote:
>>> +static int syndbg_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
>>> +{
>>> +	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
>>> +
>>> +	if (!syndbg->active && !host)
>>> +		return 1;
>>> +
>> One small thing: is the ENABLE_CAP and active field needed?  Can you
>> just check if the guest has the syndbg CPUID bits set?
>>
> Yes, we can probably get away with a static capability (so userspace
> knows that the interface is supported and CPUID bit can be set) and
> check guest_cpuid_has() here but we don't have Hyper-V feature leaves
> exposed as X86_FEATURE_* (yet). It is probably possible to implement an
> interim solution by open coding the check with kvm_find_cpuid_entry() or
> something like that.

Yes, that would be fine if you just abstract it in its own function.

Paolo

