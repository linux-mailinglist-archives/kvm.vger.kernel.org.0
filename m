Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DBD30D985
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 13:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbhBCMJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 07:09:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21567 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234415AbhBCMJY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 07:09:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612354078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SrvxDfDLxZDeRFfsO00vBgZ9Ba/y5cDui2XTUBzZ7SE=;
        b=dH/17FQZZeYw4aufQK6MQt2XlufsdQEkUU06zbYYNJQX9LPu9VmXOG3bfA3f7wkZ7r9B+K
        FIOYPlSaZCksWotNccD+L85RQZNcp57zBDSwz5vVqEWxycJT8qQBZippMjBes019sdbgq1
        UtAHx24YuqivH5wu0xSIBGGwGuGwkoI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-QU8K-zVBMCmOBrEb7fVkVQ-1; Wed, 03 Feb 2021 07:07:56 -0500
X-MC-Unique: QU8K-zVBMCmOBrEb7fVkVQ-1
Received: by mail-ed1-f72.google.com with SMTP id a26so11423618edx.8
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 04:07:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SrvxDfDLxZDeRFfsO00vBgZ9Ba/y5cDui2XTUBzZ7SE=;
        b=uYPRs8Wh36rPldfZ8ZjvM7Obt1uiHpDGlRYVznYAwPLPmcAhnaE47iXlkVcJIYc+Dn
         imsUZkfrv+alxCXR0REngJGUBXm7xaSErsebCPSv/09G+jWfuRHvuUbvBp5d43PXwXmA
         LwoqC4/SokqpTBKkhHA05MqZDxtsJqDGK1M3p0f+c234a+s8d83CH8ON9JxAUQMCaW/W
         K1SaHyhi2Irtzb1Rzc0j1z4JzT/wi8DkUnRIpzh1JJuSrb+fymmfM+6Zm8xIb0V1T4Qa
         uKQM9b0b+JMcwyeVnRS8Mmn/HoWQfj0xUJ1EOqAP8IkWSRpz1X6Ipg2tHfRf3mku6Lny
         r+EQ==
X-Gm-Message-State: AOAM533eniSG3sRzZTVYUX5jnP178+wIgBs0mCZYJBf2y9v3L/P2ZkTl
        BSQ7uXiSakVWKSk09rTOisR3F1Nf6qOkBXoI2rZzUNrcE+MvfIsFo/73uTDmrnyslz5f9uzWexV
        LK3xP5KhjU5V+
X-Received: by 2002:aa7:c682:: with SMTP id n2mr2626957edq.27.1612354075280;
        Wed, 03 Feb 2021 04:07:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwab3gwwD2lNmoJMyvUrcXBXIlmu3OP2NO56BrtfHb8dPrg5oZWPTPbqhHovoD08f1EUzfkOg==
X-Received: by 2002:aa7:c682:: with SMTP id n2mr2626934edq.27.1612354075090;
        Wed, 03 Feb 2021 04:07:55 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b17sm763438edv.56.2021.02.03.04.07.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 04:07:54 -0800 (PST)
Subject: Re: [PATCH v15 14/14] KVM: x86: Save/Restore GUEST_SSP to/from SMRAM
To:     Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com,
        jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yu.c.zhang@linux.intel.com
References: <20210203113421.5759-1-weijiang.yang@intel.com>
 <20210203113421.5759-15-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <55e43685-f4a7-b068-8d4c-931b8789f031@redhat.com>
Date:   Wed, 3 Feb 2021 13:07:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210203113421.5759-15-weijiang.yang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/21 12:34, Yang Weijiang wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 22eb6b8626a8..f63b713cd71f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8592,6 +8592,16 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu, char *buf)
>   
>   	for (i = 0; i < 6; i++)
>   		enter_smm_save_seg_64(vcpu, buf, i);
> +
> +	if (kvm_cet_supported()) {
> +		struct msr_data msr;
> +
> +		msr.index = MSR_KVM_GUEST_SSP;
> +		msr.host_initiated = true;
> +		/* GUEST_SSP is stored in VMCS at vm-exit. */
> +		kvm_x86_ops.get_msr(vcpu, &msr);
> +		put_smstate(u64, buf, 0x7ec8, msr.data);
> +	}
>   }
>   #endif
>   
> 

0x7ec8 is used for I/O instruction restart and auto-halt restart. 
0x7f08 is a free spot.  We should really document the KVM state save 
area format.

Paolo

