Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157DD375310
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 13:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234787AbhEFLeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 07:34:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28542 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234671AbhEFLeA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 07:34:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620300782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y9zFz2Pd4PacI7N8DSgBt6hQeKhJ/ACPsQ095WgVG8o=;
        b=eSM/+VVJso29+fnHNqwvKBOoDhLPir+R+p//OF6MJ/LyE537eYP+6d5y1z6PL6GZFSnkQ4
        4IsgxIdbWN0kQRj85EyPaHO0+zT4xv3H9ePm319aYdigNh4w1KjqFPZwG0m68TwT8k8f4F
        aBcmOivb5nu0YFL81mpLnIx8+DQGXv0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-xx-Zhl5ONQ2IUvA2s28IMw-1; Thu, 06 May 2021 07:33:00 -0400
X-MC-Unique: xx-Zhl5ONQ2IUvA2s28IMw-1
Received: by mail-wr1-f70.google.com with SMTP id s7-20020adfc5470000b0290106eef17cbdso2060964wrf.11
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 04:33:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y9zFz2Pd4PacI7N8DSgBt6hQeKhJ/ACPsQ095WgVG8o=;
        b=pjQU516fiQXwuuoOc6t8ipPx0802vOwi7EvpVyWA6VBHwJ2iVsfhmiklSxqG+PxnuT
         vw3QCblMU6hZHGSQJVwiPiXzgwK4wyxHeeQdjrDljGNEGPHuQi796UqP20HGEK4DpcWx
         ZQS6E23JeM96YMXdRreIfMuvZWwdSzOSY/1JbQNfDpwgq2WAoyaYJac3wekb79TyvEsL
         eQT8OkWs4oNaxfWMmHRVFNFbs5Vm5CeoKdkqjDUrQnu97FkdCReNlADGt279mFK8xU7T
         vkmLi6xRpKavK/2NjxRlnkjRqnBjgqFeAbfW9oltYE9GB3Q7TzuMfezT67Ya0BLPs6f8
         WK/Q==
X-Gm-Message-State: AOAM531sCo2YnMjjfFjdiK3BlOQcww71oANDcQxhnLFD2xMw5vumzjAu
        c2wZ9ZEF40EVlLANcs3HmH86CnxEXpDTmz+XVaV1WVkstvSJw/KMeqP9B3dJ7YfmWgoS9AWP5Np
        Ukjc2eXZTopU8
X-Received: by 2002:a5d:524f:: with SMTP id k15mr4508683wrc.412.1620300779783;
        Thu, 06 May 2021 04:32:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJySAOzbq/0B3BkEsbZNYxWmL9Nqds2KX53q5A4ACTHZgU10fORGtqi8P6SOylffIAaYx3rO9g==
X-Received: by 2002:a5d:524f:: with SMTP id k15mr4508667wrc.412.1620300779591;
        Thu, 06 May 2021 04:32:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s6sm9720965wms.0.2021.05.06.04.32.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 04:32:59 -0700 (PDT)
Subject: Re: [PATCH 4/8] KVM: VMX: Adjust the TSC-related VMCS fields on L2
 entry and exit
To:     ilstam@mailbox.org, kvm@vger.kernel.org
Cc:     ilstam@amazon.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        haozhong.zhang@intel.com, zamsden@gmail.com, mtosatti@redhat.com,
        dplotnikov@virtuozzo.com, dwmw@amazon.co.uk
References: <20210506103228.67864-1-ilstam@mailbox.org>
 <20210506103228.67864-5-ilstam@mailbox.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <50f86951-1cea-b7aa-7236-f28edd5eca8d@redhat.com>
Date:   Thu, 6 May 2021 13:32:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210506103228.67864-5-ilstam@mailbox.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/21 12:32, ilstam@mailbox.org wrote:
> +	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING) {
> +		if (vmcs12->secondary_vm_exec_control & SECONDARY_EXEC_TSC_SCALING) {
> +			vcpu->arch.tsc_offset = kvm_compute_02_tsc_offset(
> +					vcpu->arch.l1_tsc_offset,
> +					vmcs12->tsc_multiplier,
> +					vmcs12->tsc_offset);
> +
> +			vcpu->arch.tsc_scaling_ratio = mul_u64_u64_shr(
> +					vcpu->arch.tsc_scaling_ratio,
> +					vmcs12->tsc_multiplier,
> +					kvm_tsc_scaling_ratio_frac_bits);
> +		} else {
> +			vcpu->arch.tsc_offset += vmcs12->tsc_offset;
> +		}

The computation of vcpu->arch.tsc_offset is (not coincidentially) the
same that appears in patch 6

+	    (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)) {
+		if (vmcs12->secondary_vm_exec_control & SECONDARY_EXEC_TSC_SCALING) {
+			cur_offset = kvm_compute_02_tsc_offset(
+					l1_offset,
+					vmcs12->tsc_multiplier,
+					vmcs12->tsc_offset);
+		} else {
+			cur_offset = l1_offset + vmcs12->tsc_offset;

So I think you should just pass vmcs12 and the L1 offset to
kvm_compute_02_tsc_offset, and let it handle both cases (and possibly
even set vcpu->arch.tsc_scaling_ratio in the same function).

Paolo

