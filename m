Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1949B434EAE
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 17:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhJTPMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 11:12:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49108 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229570AbhJTPMu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 11:12:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634742635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mjiPTfW2gLGy0hlLQoZymCi13i6pwqBjAytBG2xMmKU=;
        b=YiHvG5NtMOX+ihYX+ri8BY+w1klww0Ssky4U1h/FynilM2aNmD29eyzs+9dfxfKaYjWmAQ
        1zBG+N//wwxVgw8qTp+lkxcGcwiCaDpplqUHOW9gBt478l1Xjohgs2oeIhcSJZ7fpPc9k4
        Efqc5gSKinnahaRqJrE6ZVKhUFQ5a5g=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-XAbRhbHQNg26xASgf4sTBQ-1; Wed, 20 Oct 2021 11:10:32 -0400
X-MC-Unique: XAbRhbHQNg26xASgf4sTBQ-1
Received: by mail-ed1-f71.google.com with SMTP id g28-20020a50d0dc000000b003dae69dfe3aso21286436edf.7
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 08:10:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mjiPTfW2gLGy0hlLQoZymCi13i6pwqBjAytBG2xMmKU=;
        b=wrWGY+OU3pCvc1cuGE+ubid+iyldr96sCGBHSN7l+TwsoMUATpfomTDHfOs1wk/wRW
         FkAhFHA9fWIldgblFnDTaWOjT1T2eNl+7YOiBUpDngpFiA/swB0ifWL9Cs+b+MQRTOfv
         pXFlyeC2N9vPItFwXVV+II0tauEHGF4ctSZCvHx5GV8k4jV33I3jJkIJSlCMZNhNGIRg
         v7vWoUajCdMKV/kJ/+/juC6NpVkXR0K/8d8mHKpELUUbGPwhzW5FYw9OiVnFhAH2+Syf
         EJFaeMPDDs2Z+N6JDR/nweq4u6sBbuk5WGISyZN2KNfJqFBgYgmvDwdU0lo28Sc87GEW
         HyoQ==
X-Gm-Message-State: AOAM532jYyf/FKcY6QIzv5S+frQR1W3VTMMzzhzCZyXt2RV4lM4JtiL6
        vNc7VaFQcoQ/SfF3jOedxQDUzZfkrYln8Id39WhuCMOyF8poE9o9QeDJa/PrPnFlaWm5FElmbom
        Tl1YowWeWaryp
X-Received: by 2002:a17:906:4e89:: with SMTP id v9mr157658eju.354.1634742631014;
        Wed, 20 Oct 2021 08:10:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOiI08Fc457AZgGg4vyem413WiqWwlWvwqbyzTXb+9Udsh3EHSyIQVD4+5piQwEsyTpoNqLw==
X-Received: by 2002:a17:906:4e89:: with SMTP id v9mr157626eju.354.1634742630754;
        Wed, 20 Oct 2021 08:10:30 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n6sm1320390eds.10.2021.10.20.08.10.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 08:10:30 -0700 (PDT)
Message-ID: <b2aebaba-92bc-865d-5d52-6810ba08ceaa@redhat.com>
Date:   Wed, 20 Oct 2021 17:10:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v1 1/5] KVM: x86: nVMX: Add vmcs12 field existence bitmap
 in nested_vmx
Content-Language: en-US
To:     Robert Hoo <robert.hu@linux.intel.com>, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Cc:     kvm@vger.kernel.org, yu.c.zhang@linux.intel.com
References: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
 <1629192673-9911-2-git-send-email-robert.hu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1629192673-9911-2-git-send-email-robert.hu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/08/21 11:31, Robert Hoo wrote:
> +#define FIELD_BIT_SET(name, bitmap) set_bit(f_pos(name), bitmap)
> +#define FIELD64_BIT_SET(name, bitmap)	\
> +	do {set_bit(f_pos(name), bitmap);	\
> +	    set_bit(f_pos(name) + (sizeof(u32) / sizeof(u16)), bitmap);\
> +	} while (0)
> +
> +#define FIELD_BIT_CLEAR(name, bitmap) clear_bit(f_pos(name), bitmap)
> +#define FIELD64_BIT_CLEAR(name, bitmap)	\
> +	do {clear_bit(f_pos(name), bitmap);	\
> +	    clear_bit(f_pos(name) + (sizeof(u32) / sizeof(u16)), bitmap);\
> +	} while (0)
> +
> +#define FIELD_BIT_CHANGE(name, bitmap) change_bit(f_pos(name), bitmap)
> +#define FIELD64_BIT_CHANGE(name, bitmap)	\
> +	do {change_bit(f_pos(name), bitmap);	\
> +	    change_bit(f_pos(name) + (sizeof(u32) / sizeof(u16)), bitmap);\
> +	} while (0)
> +
> +/*

Hi Robert,

I'd rather not have FIELD_BIT_CHANGE, and instead have something like

#define FIELD_BIT_ASSIGN(name, bitmap, value) \
	if (value) \
		FIELD_BIT_SET(name, bitmap); \
	else
		FIELD_BIT_CLEAR(name, bitmap);

Also, these set_bit/clear_bit can use the non-atomic variants __set_bit 
and __clear_bit, because the bitmaps are protected by the vCPU mutex.

> +		FIELD64_BIT_CHANGE(posted_intr_desc_addr, bitmap);

Many of the fields you mark as 64-bit are actually natural sized.

> +	if ((old_val ^ new_val) &
> +	    CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) {
> +		FIELD_BIT_CHANGE(secondary_vm_exec_control, bitmap);
> +	}
> +}

If secondary controls are not available, you should treat the 
corresponding MSR as if it was all zeroes.  Likewise if VMFUNC is disabled.

> +	if ((old_val ^ new_val) & SECONDARY_EXEC_PAUSE_LOOP_EXITING) {
> +		FIELD64_BIT_CHANGE(vmread_bitmap, bitmap);
> +		FIELD64_BIT_CHANGE(vmwrite_bitmap, bitmap);

This seems wrong.

Paolo

