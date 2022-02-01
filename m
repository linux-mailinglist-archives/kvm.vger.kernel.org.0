Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A844A5C43
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 13:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238093AbiBAM2Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 07:28:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37329 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238076AbiBAM2W (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Feb 2022 07:28:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643718502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gYsMOanhgag9FX9U5PUDWc3Rn4Habp49ag3te6WP1O0=;
        b=OsQlSFnA6Pccor2foPJpl/OlbAXZmhQIEhqg8j92DCF/+jRAA7pM8qO168jgIknQUhYEIU
        okTYtQxKp/Dw6ZRHK2rLYK0OEHPSSLomURZA3g6OzduFL00wmdp8WcPD2qPP/5XOf8sm41
        rciEMl8vgGOPbR67PbskJRwjXu5V5Js=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-xBBQhndIMP-sHe56lCla1w-1; Tue, 01 Feb 2022 07:28:21 -0500
X-MC-Unique: xBBQhndIMP-sHe56lCla1w-1
Received: by mail-ej1-f69.google.com with SMTP id k16-20020a17090632d000b006ae1cdb0f07so6463825ejk.16
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 04:28:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gYsMOanhgag9FX9U5PUDWc3Rn4Habp49ag3te6WP1O0=;
        b=VLFhBi7Ld/IDrXYlnLm8WaTifGGQbgvE1WzFLiG6PinzysDm5LtdvRjqjfguatH5DQ
         FKuEEl5VvfuM2+p/vfNULv/dspvW0O7v6nCOLEYx17L/bj/mKVihGHthUgrzuwPYWBfu
         8nGy8IqpJoiQITuJEx6itF6Wvuuws71XXsmrBYDe5PwSGxNMDiurlvDY+vfJOasnIfyY
         p+utYPg5cu/zRMPHjNztC/wPtGB/xRYMAWNyaj/d/oDTYyMwMfkynvQjFxpjUJwmNx/E
         fzA+fYCgIWAQdjnpgA5YZk9GA/idLnTitJrM/8/cI1/i6yAtpQBXGfpFDp2G+bDe1nb7
         6PCQ==
X-Gm-Message-State: AOAM533v8SOyoHEdxOrhxvLyIOA/WebXil6t2x62vWGuCP/oz0MxobQD
        9x9T4V4Mx2hhc0Js1nU9oi+hdKq+djY7zgyBmyhrGbRb1iAHr4NAMcyxM6t/3117FlUUYlF0Yxl
        Psmn7Z4VLMORu
X-Received: by 2002:a17:907:6091:: with SMTP id ht17mr20947049ejc.626.1643718500191;
        Tue, 01 Feb 2022 04:28:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyRMhTfm6g/0pB4jH/vP9Y4MT+TpgfSycD16pvewkJM7tuG9Ae3/hbl+ctjuIB/GNDnbjbmrQ==
X-Received: by 2002:a17:907:6091:: with SMTP id ht17mr20947035ejc.626.1643718500029;
        Tue, 01 Feb 2022 04:28:20 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id s1sm19400809edt.49.2022.02.01.04.28.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 04:28:19 -0800 (PST)
Message-ID: <13de6271-61bc-7138-15b3-9241508d94fa@redhat.com>
Date:   Tue, 1 Feb 2022 13:28:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH kvm/queue v2 3/3] KVM: x86/pmu: Setup the
 {inte|amd}_event_mapping[] when hardware_setup
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
References: <20220117085307.93030-1-likexu@tencent.com>
 <20220117085307.93030-4-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220117085307.93030-4-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/17/22 09:53, Like Xu wrote:
> +
> +	for (i = 0; i < PERF_COUNT_HW_MAX; i++) {
> +		config = perf_get_hw_event_config(i) & 0xFFFFULL;
> +
> +		kernel_hw_events[i] = (struct kvm_event_hw_type_mapping){
> +			.eventsel = config & ARCH_PERFMON_EVENTSEL_EVENT,
> +			.unit_mask = (config & ARCH_PERFMON_EVENTSEL_UMASK) >> 8,
> +			.event_type = i,
> +		};

Should event_type be PERF_COUNT_HW_MAX if config is zero?

Thanks,

Paolo

