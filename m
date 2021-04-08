Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C573588CF
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 17:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbhDHPrd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 11:47:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44668 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231655AbhDHPrc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 11:47:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617896841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YTgmH756AhLxTUX70sV9sEtjSkUIHcT5ErPkRW1CdPU=;
        b=Z9ET8wZf03YHHTqNh0Zt0OIDdjb/0S/4quxWVaIBdKP1bBBUn3QXX7SciMIM6T5mpXJDbY
        ldY8Q2FA5vjABBPz9RMRCcSPbWcAEp/fZUnj20Nfy3ttNHJQu1+SVv+V/VITJiuTyQZl07
        3hV7mGPVawuJecZceqOVnmLd/3Te6FI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-qs3VOco2NHelInflkqZuQA-1; Thu, 08 Apr 2021 11:47:19 -0400
X-MC-Unique: qs3VOco2NHelInflkqZuQA-1
Received: by mail-ed1-f71.google.com with SMTP id h9so1233192edb.10
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 08:47:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YTgmH756AhLxTUX70sV9sEtjSkUIHcT5ErPkRW1CdPU=;
        b=SJqJ1wtPKgxR1ZI2ygjhw/bVn4s0giTdVXw6IBCEGSo3RBN67UdhDrrZaEixEWxUz8
         kFIBBGmG4I4+33Z60GtFJgAryHM+o/kIYal+6REAMglMmBibiAC1jEg423LO89T8kBfz
         R3BEjEnh4vEpJey2ItPEIEI8cJCiQMCSR0OU3/B1fyxJxMiX4gxktits4Qd9c+CiCTEf
         UocFvY/PFF+rJiZmLhC6YNbvwX2JiZ7d40ruMSzVMqipL9Xx+dy43hvLNe8iN0zOC/6a
         Ndj7LAaGix7Cu9okqtdxuUasvxI7yAo8y7t8+feHDCFmf2rjQVlVQSFYLJyfRms8Ngib
         dPiw==
X-Gm-Message-State: AOAM530JU2JwKSZjigkqRG+cp6jR17x06+BtN/CuzUX5Iq78xY1JMdC6
        7JQ8N4btHGtZqtkdNfUF0VRVQhWmG5QSoWvy+pT1xoWTPS/BMtXJ7th3yem22Bo10UwK3ntQZeM
        AUUxqFs2FOUXt
X-Received: by 2002:a17:906:7e53:: with SMTP id z19mr2999602ejr.422.1617896838111;
        Thu, 08 Apr 2021 08:47:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKGb2aWaaqbI0/Ib/6Q0YDqGF8YzM0XjfD52Zv6Hen9YRdCmYCPhA95jv92MLfrWIXCkYaAw==
X-Received: by 2002:a17:906:7e53:: with SMTP id z19mr2999580ejr.422.1617896837965;
        Thu, 08 Apr 2021 08:47:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id r19sm14422213ejr.55.2021.04.08.08.47.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 08:47:17 -0700 (PDT)
Subject: Re: [PATCH 6/7] KVM: SVM: hyper-v: Enlightened MSR-Bitmap support
To:     Vineeth Pillai <viremana@linux.microsoft.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
References: <cover.1617804573.git.viremana@linux.microsoft.com>
 <5cf935068a9539146e033276b6d9a6c9b1e42119.1617804573.git.viremana@linux.microsoft.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <58df22aa-5d2c-f99f-6dfb-9a8b4260dc21@redhat.com>
Date:   Thu, 8 Apr 2021 17:47:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <5cf935068a9539146e033276b6d9a6c9b1e42119.1617804573.git.viremana@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/04/21 16:41, Vineeth Pillai wrote:
>   
> +#if IS_ENABLED(CONFIG_HYPERV)
> +static inline void hv_vmcb_dirty_nested_enlightenments(struct kvm_vcpu *vcpu)
> +{
> +	struct vmcb *vmcb = to_svm(vcpu)->vmcb;
> +
> +	/*
> +	 * vmcb can be NULL if called during early vcpu init.
> +	 * And its okay not to mark vmcb dirty during vcpu init
> +	 * as we mark it dirty unconditionally towards end of vcpu
> +	 * init phase.
> +	 */
> +	if (vmcb && vmcb_is_clean(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS) &&
> +	    vmcb->hv_enlightenments.hv_enlightenments_control.msr_bitmap)
> +		vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
> +}

In addition to what Vitaly said, can svm->vmcb really be NULL?  If so it 
might be better to reorder initializations and skip the NULL check.

Paolo

