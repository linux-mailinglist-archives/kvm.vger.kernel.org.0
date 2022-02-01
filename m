Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2074A5C2D
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 13:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237599AbiBAM0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 07:26:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23500 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235488AbiBAM0K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Feb 2022 07:26:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643718369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZOsQ7tCjggbyJsap3yPkhYLBomgSptsnuwvSsGz14Vk=;
        b=hmmAluwcTx2cd2SyXrjyv3T18yfHpKTQLNISVAzb2jmRQKK9qWNgvc3Nj/KgEWxrpz5Nm4
        v8A5mbWCABKWNNYxkQAM6GYyCsw4ZwKyxl93bHL3W1zW2xeyy/XLBxuFKOpmd6BDzpgDoy
        YEzUbgUdjdAZei3+8oRx0fpXLMER1a0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142--ntiIo2vNAS7fk-3Glp2wQ-1; Tue, 01 Feb 2022 07:26:08 -0500
X-MC-Unique: -ntiIo2vNAS7fk-3Glp2wQ-1
Received: by mail-ej1-f70.google.com with SMTP id p8-20020a1709060e8800b006b39ade8c12so6475117ejf.10
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 04:26:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZOsQ7tCjggbyJsap3yPkhYLBomgSptsnuwvSsGz14Vk=;
        b=vKaVUNzB5RDRcy2HvGrvGRCYAVCKz3ePh01/AX+f5DtEPd4vWms33s4Rxx/uhHN1xh
         mNm5+hd2UueNmcGPcmgaNNIyEc4LWEggItospKA9gFj6EjZc0ZhGWMH1isAYs3C3/lcr
         LnWs0HFHNnH8IqW9IfAl4gcv+eZ+qv9pR7I3zbk1d3QXKAuc4Ha2mCZRJGzuR5Y+axy0
         A9AtGObKlV1Fg0CE/T/DZZQXK53Oyro0WjcbZ32WTPgyoPd2oA2RkcysvPkWxngQQasi
         c6fnkiOf7CgHqnPFR9/RPu1CWTlykmKgLNDXaLH6+uMgF3p0Svp2ao6V9aTnWrt82GIO
         zKfA==
X-Gm-Message-State: AOAM530Roo3t0QgTftiRyry811N1hMGkjqoNRq6HsFZJEXZ4ZolugBQE
        cPUPh2EPWE1TaEcIgWy2G08JFsoS//z9Q+xW3p4D4+DkiCG9bVV82dMszTAbJRYVM6PkFeVD7N/
        UB5w9vbMJLXFj
X-Received: by 2002:a17:906:cc54:: with SMTP id mm20mr19996350ejb.313.1643718367519;
        Tue, 01 Feb 2022 04:26:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxHXhxwLpXav5KTYsLp1XBTl+8R3PESRejFZhEZXppgLCXd4Ex7CZ9M9KE024cKby9FudzbrQ==
X-Received: by 2002:a17:906:cc54:: with SMTP id mm20mr19996335ejb.313.1643718367349;
        Tue, 01 Feb 2022 04:26:07 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id d5sm14481372ejr.200.2022.02.01.04.26.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 04:26:06 -0800 (PST)
Message-ID: <6690a921-5df7-5c31-e115-96b89cc5057e@redhat.com>
Date:   Tue, 1 Feb 2022 13:26:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH kvm/queue v2 1/3] KVM: x86/pmu: Replace
 pmu->available_event_types with a new BITMAP
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
References: <20220117085307.93030-1-likexu@tencent.com>
 <20220117085307.93030-2-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220117085307.93030-2-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/17/22 09:53, Like Xu wrote:
> +/* Mapping between CPUID 0x0A.EBX bit vector and enum perf_hw_id. */
> +static inline int map_unavail_bit_to_perf_hw_id(int bit)
> +{
> +	switch (bit) {
> +	case 0:
> +	case 1:
> +		return bit;
> +	case 2:
> +		return PERF_COUNT_HW_BUS_CYCLES;
> +	case 3:
> +	case 4:
> +	case 5:
> +	case 6:
> +		return --bit;
> +	}
> +
> +	return PERF_COUNT_HW_MAX;
> +}
> +

Please use an array here (e.g. cpuid_event_to_perf_hw_id_map[]).

Paolo

