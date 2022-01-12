Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472E648CB21
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 19:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356306AbiALSjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 13:39:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41082 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343991AbiALSjN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Jan 2022 13:39:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642012752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QDVFLXIz2JDZrvGc2eGZe6Vv1J9TCTU3WjZaistUlP8=;
        b=WJNALIPjoMgpENgL16sw1TsJ3+CRLtR3QSTB1dfDnkmnrlmk9hgI+BQh5Cv4gkmo//eo0Q
        b3BqYfoIuqnesvcFEZBaK1HtX0w4xcTiIIfoHgwRlJixhPG06b6aJBocLQumQQnD732s6Q
        GFsSEdrgg1m5ZXGhTuhht/q0qs0t5nk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-Z2VV-uTsPs2N5TWcfWg3ew-1; Wed, 12 Jan 2022 13:39:10 -0500
X-MC-Unique: Z2VV-uTsPs2N5TWcfWg3ew-1
Received: by mail-ed1-f71.google.com with SMTP id g2-20020a056402424200b003f8ee03207eso3069846edb.7
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 10:39:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QDVFLXIz2JDZrvGc2eGZe6Vv1J9TCTU3WjZaistUlP8=;
        b=733y4IPezgXoBqVczL2C5g62C8VMl+uV6CwE99gT01LogpOjLkdonxu0PEKutTu1J2
         IUpEi2by5NtxrvzPKUVFlh8RPrEdUBoM47jUXcpA2elg6qgLcalJgRJkTeZO1vU0Dv5O
         RJ0ny+PuMb8KSSY1hu7YsJ2X/6FjF0EdE9/1EJbEkbN0z7ff7Z1a7ux0Ho0rhrny5q4b
         C59dMJPc3mxc9T5lNDXdRJc4WBgU8eAgoXgS0y/G5jQgpV+yPk2RZXnOSLfFhXikAEOD
         S7Qx52oEDXSrNhiVZ2WHxPYifE+mT8RkQczSG1rsuyUlmKC55W3g1ro40BuxiDtdmP/9
         bA9Q==
X-Gm-Message-State: AOAM531VUOPxx1KEdqmKJM8FPJxogDGfKu0OqDK8rZPomM3wu4ILZSV8
        UIQNHm57sxCxdUe8ndkaz8YDv+C/1MlgF9Iq0hpNH55soxT2aXwyVuymqAvIDwHkcxsgkrG5AZ6
        k/aYQjknO89mz
X-Received: by 2002:a05:6402:1602:: with SMTP id f2mr897815edv.80.1642012749692;
        Wed, 12 Jan 2022 10:39:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwftRaiNcrTcdkuykZ6qJFdRyA+68PtNAEc9NiHUw/3W9bAuJOBn+/B0NV9fSBUzIRHv8zORQ==
X-Received: by 2002:a05:6402:1602:: with SMTP id f2mr897806edv.80.1642012749515;
        Wed, 12 Jan 2022 10:39:09 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id h2sm153319ejo.169.2022.01.12.10.39.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 10:39:09 -0800 (PST)
Message-ID: <50136685-706e-fc6a-0a77-97e584e74f93@redhat.com>
Date:   Wed, 12 Jan 2022 19:39:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20211122175818.608220-1-vkuznets@redhat.com>
 <20211122175818.608220-3-vkuznets@redhat.com>
 <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
 <20211227183253.45a03ca2@redhat.com>
 <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com> <87mtkdqm7m.fsf@redhat.com>
 <20220103104057.4dcf7948@redhat.com> <875yr1q8oa.fsf@redhat.com>
 <ceb63787-b057-13db-4624-b430c51625f1@redhat.com> <87o84qpk7d.fsf@redhat.com>
 <877dbbq5om.fsf@redhat.com> <5505d731-cf87-9662-33f3-08844d92877c@redhat.com>
 <20220111090022.1125ffb5@redhat.com> <87fsptnjic.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87fsptnjic.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/12/22 14:58, Vitaly Kuznetsov wrote:
> -	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
> +	best = cpuid_entry2_find(entries, nent, 0xD, 1);
>   	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
>   		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>   		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>   
> -	best = kvm_find_kvm_cpuid_features(vcpu);
> +	best = __kvm_find_kvm_cpuid_features(vcpu, vcpu->arch.cpuid_entries,
> +					     vcpu->arch.cpuid_nent);
>   	if (kvm_hlt_in_guest(vcpu->kvm) && best &&

I think this should be __kvm_find_kvm_cpuid_features(vcpu, entries, nent).

> 
> +		case 0x1:
> +			/* Only initial LAPIC id is allowed to change */
> +			if (e->eax ^ best->eax || ((e->ebx ^ best->ebx) >> 24) ||
> +			    e->ecx ^ best->ecx || e->edx ^ best->edx)
> +				return -EINVAL;
> +			break;

This XOR is a bit weird.  In addition the EBX test is checking the wrong 
bits (it checks whether 31:24 change and ignores changes to 23:0).

You can write just "(e->ebx & ~0xff000000u) != (best->ebx ~0xff000000u)".

> 
> +		default:
> +			if (e->eax ^ best->eax || e->ebx ^ best->ebx ||
> +			    e->ecx ^ best->ecx || e->edx ^ best->edx)
> +				return -EINVAL;

This one even more so.

Paolo

