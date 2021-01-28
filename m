Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1143077E2
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 15:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhA1OWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 09:22:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24446 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231417AbhA1OVX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 09:21:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611843596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yAiCHorAzIW2hLcLk4L5vE7GRzZCATEfk8PZpeojDvE=;
        b=FLKfmptJfroM7MCpZk8hWI2+f7BupXhPHYGY83w5VWZeaxNbwvwrEgOEB50OLIYRLfUBdM
        rlFbV1eA7p3H9S22jCqXmF+DjI5qj39wQ8qWFOq/Bnf+/95UlFHLAe8Zr7ytU6tx43sCxG
        33OV/ZPxti90cBrTBDzDX6Z/p1U3vFE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-BWh05eEsOB6CMtG_bbXyjQ-1; Thu, 28 Jan 2021 09:19:54 -0500
X-MC-Unique: BWh05eEsOB6CMtG_bbXyjQ-1
Received: by mail-ej1-f71.google.com with SMTP id j14so2227475eja.15
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 06:19:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yAiCHorAzIW2hLcLk4L5vE7GRzZCATEfk8PZpeojDvE=;
        b=bqAEwR5YUVwTyuce3dx+epR78L9Gve1HYPthhUsZdgcajPvAjhTY+vk4xSJtnJ2jIX
         M9vXzG6u0UlzptxZX4UfJMwhP4sTCn5kodqmlLh9vAUKJyfW/Ali7VGqTFj+UcWNmZhN
         c3M8Ibyc3KitOFu5Le8EcblFzpDTFtKv7C0hAp0af4yzd2JCZRhu135EJp+hNi7fhlbP
         nErQJ8wII4O5K4/7DzQAcCucK+lRDUPsYTHw/jW+RU5wNiMoAvLrvJ5ngD9z/tli1Amx
         Ftz1UWBCV77FSW4APe28icWHqcrq2XeiSiO2EYLHdHlyeQS3XqH7EuPAkAZCU1SMN2fM
         kVxg==
X-Gm-Message-State: AOAM531XYN8eu9ZsEFTpTJxNYJuYvdDk1WAYsPQc7jd47QM87dAzKbOn
        A5QwsieJHdxQUpvC3ZpuyqoqFGIir6PKTrPWbVuQv+9tp2ap3Naeb8OTR16FNLNghu/p1lFeblq
        wqPDCEW7bor3u
X-Received: by 2002:a17:906:d8b4:: with SMTP id qc20mr11647595ejb.451.1611843593284;
        Thu, 28 Jan 2021 06:19:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz6tZri9LUS2myexI16esYkZJpRGeDlKJKPq/yU8EAW9sKj6smvnLk2ugilglSJPe28+K4j7w==
X-Received: by 2002:a17:906:d8b4:: with SMTP id qc20mr11647591ejb.451.1611843593153;
        Thu, 28 Jan 2021 06:19:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x21sm2345051eje.118.2021.01.28.06.19.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 06:19:52 -0800 (PST)
Subject: Re: [PATCH v2 11/15] KVM: x86: hyper-v: Prepare to meet unallocated
 Hyper-V context
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
References: <20210126134816.1880136-1-vkuznets@redhat.com>
 <20210126134816.1880136-12-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fe1bb68d-96a0-cbb3-967a-8576c3533cf6@redhat.com>
Date:   Thu, 28 Jan 2021 15:19:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210126134816.1880136-12-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/01/21 14:48, Vitaly Kuznetsov wrote:
> 
> +static inline u32 to_hv_vpindex(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +
> +	return hv_vcpu ? hv_vcpu->vp_index : kvm_vcpu_get_idx(vcpu);
> +}
> +

I'd rather restrict to_* names for pointer conversions. 
kvm_hv_get_vpindex is a better choice here.

Paolo

