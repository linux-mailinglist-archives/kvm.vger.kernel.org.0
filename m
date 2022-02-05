Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70C54AA984
	for <lists+kvm@lfdr.de>; Sat,  5 Feb 2022 15:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380195AbiBEOuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Feb 2022 09:50:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50811 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1380188AbiBEOux (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 5 Feb 2022 09:50:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644072653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Rc8ijCVExWwCJv+VMGAynjPNWd83v7JPEXJNV8RCeA=;
        b=FNQj24v9K5HEZPhag6iDP0eNrAIXLaRunFA/VNexWvZNrTD6KW/xwR4abCzfk3R0x2TGD1
        PVKU9asiqEtcvAxLIYX3zvT2Wcp4gO+6Gz7haOvKncfyBZ2wbYboGXVBTWRXSpi28yO1jY
        JuxMuutAXjOlqdDDGxNTy5YgNEQ5gNs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-RNRQSE4DMSia3FXRzSvIGg-1; Sat, 05 Feb 2022 09:50:51 -0500
X-MC-Unique: RNRQSE4DMSia3FXRzSvIGg-1
Received: by mail-ed1-f69.google.com with SMTP id k12-20020a50c8cc000000b0040f28426e5aso1128757edh.17
        for <kvm@vger.kernel.org>; Sat, 05 Feb 2022 06:50:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5Rc8ijCVExWwCJv+VMGAynjPNWd83v7JPEXJNV8RCeA=;
        b=bvmAm91bdBrtfXZnQ1xgOeVjl29kOgUeZi+U1gJZF+ge7h2eSKP8ZHsORXS35bshqQ
         lMxb1AZ+1zcFee8+E2Jd5AF1+93DgsTBaMCT9Lw1sLa9NpQqJXlvACELZ53i1dZQjPA0
         l/kQ4eXfCG04iIk1g3feMVoWwbmZaF8pMUyI516RZi10UI5t9oFimfpn/5h7dS1KS1t8
         bwFBRZrS9FWFzVzLwMpuPO9IvXZp2OKnGSppJvreSqZQW9It8qYJrHcnhV6Gsfce0f3U
         TPKlYlvyivSuyUCpJjQNjUaj+8I/unfmSnO+RfXwsctdhDiAIQHTdTdMlJUU5MUvdiwj
         u/nQ==
X-Gm-Message-State: AOAM530TKMtLdjP2sC9CwurW+I7Oz6h4HP898H3BH1bVxDY2zpnnhbwR
        OwB3xZWAbfGrxqlIe9EyhvFKBrvvCUs9fWuqyxNiPYQe7Ju5bgr7xGhc41aP5yYMN03a+DfLpFm
        uYeaCug30rtjy
X-Received: by 2002:a05:6402:2683:: with SMTP id w3mr4776347edd.405.1644072650703;
        Sat, 05 Feb 2022 06:50:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzauDtqAvaJ/GElUfrMmdQtavm9QTuQ0dPoLeNID8Ql3GDWEKtV4Y/TrUFnpLdaxfgqo9WIPQ==
X-Received: by 2002:a05:6402:2683:: with SMTP id w3mr4776326edd.405.1644072650511;
        Sat, 05 Feb 2022 06:50:50 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id t8sm1673362ejx.217.2022.02.05.06.50.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Feb 2022 06:50:49 -0800 (PST)
Message-ID: <a7cc6ead-c30b-4d21-c92c-faf37d9023b7@redhat.com>
Date:   Sat, 5 Feb 2022 15:50:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 03/23] KVM: MMU: remove valid from extended role
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-4-pbonzini@redhat.com> <Yf1xU+EVukcX4Exb@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yf1xU+EVukcX4Exb@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/22 19:32, David Matlack wrote:
>> -	vcpu->arch.root_mmu.mmu_role.ext.valid = 0;
>> -	vcpu->arch.guest_mmu.mmu_role.ext.valid = 0;
>> -	vcpu->arch.nested_mmu.mmu_role.ext.valid = 0;
>> +	vcpu->arch.root_mmu.mmu_role.base.level = 0;
>> +	vcpu->arch.guest_mmu.mmu_role.base.level = 0;
>> +	vcpu->arch.nested_mmu.mmu_role.base.level = 0;
> I agree this will work but I think it makes the code more difficult to
> follow (and I start worrying that some code that relies on level being
> accurate will creep in in the future). At minimum we should extend the
> comment here to describe why level is being changed.
> 
> I did a half-assed attempt to pass something like "bool force_role_reset"
> down to the MMU initialization functions as an alternative but it very
> quickly got out of hand.
> 
> What about just changing `valid` to `cpuid_stale` and flip the meaning?
> kvm_mmu_after_set_cpuid() would set the cpuid_stale bit and then reset
> the MMUs.
> 

For now I'll swap this patch with one that clears the whole word, but 
keep the ext bit as described in my other reply.

Paolo

