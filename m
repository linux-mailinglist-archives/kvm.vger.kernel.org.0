Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157E52FEE09
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 16:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732297AbhAUPFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 10:05:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58176 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732487AbhAUPDt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 10:03:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611241343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v5ZJBAFE/dpWgJgGy+WRiaDv+4qyXSXIA8BiVewPRXg=;
        b=Bsc/7Z5BtlnNPDPs2zKEj+Au/EFxYypaFqWQAefFMMaK1ia2KEFoAdjQdfrfx/jbvSDFqB
        5ZeCkROaQKeXwm4oBXGNiSBRpLgpLtd4PdP6jtwyvm2Flk2ONv5QAy5E1CyGF7HOMbe1Mp
        FtqmATLhF0PDf3T8nL2Ky5gihOUaiaE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-2H6XANwxPaeXzf6K6IussA-1; Thu, 21 Jan 2021 10:02:20 -0500
X-MC-Unique: 2H6XANwxPaeXzf6K6IussA-1
Received: by mail-ej1-f71.google.com with SMTP id f1so857400ejq.20
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 07:02:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v5ZJBAFE/dpWgJgGy+WRiaDv+4qyXSXIA8BiVewPRXg=;
        b=LgiSCGXLv6uF79NXLV5qVDPHnwEGGm+LMk2ZpNR7qJKlZ32ZEI72b1veKG15aFq2uH
         w8Ec14MZgehhJNvr96M8p1Auq1NdU9zc84YrRBOIDpEjMtYYamKWLbuhfq20XIsCrzsV
         joGsqep3MQGemO7PvXXfKUWVMLmtOn/xJdphSe/fgFVd0UQavliiNjEM2vO5ZLvzG0Ya
         84N8pLt5SOoTF5ZPQkw3M4VC677DdV0QsV6mzjBQMViXmjCcxqwcjKRqW6ewtM68oESw
         rnBlpXb5T10mhFuDDa5Mn24H46P9+AhOL/+479AOlRrV05xsZlQb2qW7JGWGX2YmnwhR
         vbLA==
X-Gm-Message-State: AOAM5338w/Uswzvw0DqTzkzKx9Ndi0FN27T2wa5EJMWu9vBzYgcWq/Gg
        N+fgw93fOQHL79zdKtLsNg0qNHKIV8WepmEce8RaNSTB7bX/HX24jNTasTXH3GzA4jDoiuhI/cO
        NaFS+dWtwdnUF
X-Received: by 2002:a05:6402:134b:: with SMTP id y11mr11338537edw.88.1611241339237;
        Thu, 21 Jan 2021 07:02:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyhj7tsuHL8LeeLW26jaZLOTEWepj0VMCjXTY/MLlSVJ7mDAQ89Ie+ss8mPDl8VdQWyN94HZQ==
X-Received: by 2002:a05:6402:134b:: with SMTP id y11mr11338520edw.88.1611241339103;
        Thu, 21 Jan 2021 07:02:19 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id w2sm2377655ejn.73.2021.01.21.07.02.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 07:02:18 -0800 (PST)
Subject: Re: [PATCH 0/2] Enumerate and expose AVX_VNNI feature
To:     Yang Zhong <yang.zhong@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        tony.luck@intel.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kyung.min.park@intel.com
References: <20210105004909.42000-1-yang.zhong@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <eee07399-df81-83ed-d410-18b42d51e26c@redhat.com>
Date:   Thu, 21 Jan 2021 16:02:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210105004909.42000-1-yang.zhong@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/01/21 01:49, Yang Zhong wrote:
> A processor supports AVX_VNNI instructions if CPUID.(EAX=7,ECX=1):EAX[bit 4]
> is present.
> 
> This series includes kernel and kvm patches, kernel patch define this
> new cpu feature bit and kvm expose this bit to guest. When this bit is
> enabled on cpu or vcpu, the cpu feature flag is shown as "avx_vnni" in
> /proc/cpuinfo of host and guest.
> 
> Detailed information on the instruction and CPUID feature flag can be
> found in the latest "extensions" manual [1].
> 
> Reference:
> [1]. https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html
> 
> 
> Kyung Min Park (1):
>    Enumerate AVX Vector Neural Network instructions
> 
> Yang Zhong (1):
>    KVM: Expose AVX_VNNI instruction to guset
> 
>   arch/x86/include/asm/cpufeatures.h | 1 +
>   arch/x86/kvm/cpuid.c               | 2 +-
>   2 files changed, 2 insertions(+), 1 deletion(-)
> 

Queued, thanks.

Paolo

