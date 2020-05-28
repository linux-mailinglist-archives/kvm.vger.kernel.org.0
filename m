Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22AA1E5E38
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 13:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388372AbgE1L3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 07:29:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33547 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388280AbgE1L3I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 07:29:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590665345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5jkGnU9IhZ9f76OQSbwe6teWCCTmgG0EZGcGlII1Znw=;
        b=WL/+nwCMDMOUu4W9VzIpOhZaV3hdfckNRK8cTX/ywWHznORPLVoGiYlU/PmF+lPsEUtdha
        RJblRjnk0wrLN3bCUlaaoYm1UKgrMPGPSSmVBvw6r/qNmhXLWjlG4O+CVHK9vdhRwmmvfw
        sYWMg86ddOd2prWReBqQoNaUrzs5lcc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-SwMPlc6TMjqSJmcHznc5sg-1; Thu, 28 May 2020 07:29:03 -0400
X-MC-Unique: SwMPlc6TMjqSJmcHznc5sg-1
Received: by mail-ej1-f69.google.com with SMTP id lk22so10113517ejb.15
        for <kvm@vger.kernel.org>; Thu, 28 May 2020 04:29:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5jkGnU9IhZ9f76OQSbwe6teWCCTmgG0EZGcGlII1Znw=;
        b=Q/mtk5Sm2EYQ9FGF98MBdoa9C6njNW8oJ0vMkcV8eJciPlgNYYGUzyGA+YZhO+VfI9
         l5XIjUSGNAEGc0LbxBqwW1MpzSQOnMy7zKsvbvG7Zsv6B1gaQvYTh3H4R8iKgNJBWIJT
         SWszBKOJKz0OT8fngpS4In9xOolxyLVcak6Pfi1Q2mGbnn1c7CVdA+JpdopC8J9iQNIt
         4QPC7EqzSvUJO3Sy+yVMiatEvNVqEiX928YTMf6tI+8P9Wj3WkvoJXpGTvR3SnV6yyiO
         RPSMBqdsfnuHy5/mJDJiUUwWm7OPjVnB46F2E93dXKJkaqKILI4acS0jmzKXXr5lkHXq
         3gEg==
X-Gm-Message-State: AOAM531Yy+sBYtB4BIxjTQqqFP1HOGZkL48hgMKA8/7jUXVNrLVbHS4q
        RGCD/9vyblcaZ3VQlQ0lqKaO+pH0Xt3BzIRHfmZ751sj3Wha/UYVwN2tlB+lRLwDjEeO8uYSann
        5J4wC8NVfwd4E
X-Received: by 2002:a50:fc83:: with SMTP id f3mr2710545edq.138.1590665342667;
        Thu, 28 May 2020 04:29:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJySYdErOVnXb5nGRwttKS53jtfg1bKwk3/b9HzdBfcf3eYOFduECx7Urge3ndc527hNlaGAgg==
X-Received: by 2002:a50:fc83:: with SMTP id f3mr2710523edq.138.1590665342479;
        Thu, 28 May 2020 04:29:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id a3sm4469745edv.70.2020.05.28.04.29.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 04:29:01 -0700 (PDT)
Subject: Re: [PATCH v2 06/10] KVM: x86: acknowledgment mechanism for async pf
 page ready notifications
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Vivek Goyal <vgoyal@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
References: <20200525144125.143875-1-vkuznets@redhat.com>
 <20200525144125.143875-7-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f9d32c25-9167-f1a7-cda7-182a785b92aa@redhat.com>
Date:   Thu, 28 May 2020 13:29:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200525144125.143875-7-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/05/20 16:41, Vitaly Kuznetsov wrote:
> +	case MSR_KVM_ASYNC_PF_ACK:
> +		if (data & 0x1) {
> +			vcpu->arch.apf.pageready_pending = false;
> +			kvm_check_async_pf_completion(vcpu);
> +		}
> +		break;
>  	case MSR_KVM_STEAL_TIME:
>  
>  		if (unlikely(!sched_info_on()))
> @@ -3183,6 +3189,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_KVM_ASYNC_PF_INT:
>  		msr_info->data = vcpu->arch.apf.msr_int_val;
>  		break;
> +	case MSR_KVM_ASYNC_PF_ACK:
> +		msr_info->data = 0;
> +		break;

How is the pageready_pending flag migrated?  Should we revert the
direction of the MSR (i.e. read the flag, and write 0 to clear it)?

Paolo

