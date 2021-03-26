Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1D734ADAE
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 18:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhCZRg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 13:36:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35681 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230253AbhCZRgX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 13:36:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616780182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SiWoaGpTsKxnpfH36CVPc9yu7W5RPrt7W/LPaBOJkxE=;
        b=DQXvSG9sfK8d1XDvuRdx0718cDMMviYoqvi6wHnFC8cug00e6u8CMaIpgIueYuHchevG+C
        IOACECvNL69frK6fgSKhCmCEXTpvu3zZaOu8REwZVlahrbwISVGh5hhSrQAGaD5Irqce8m
        q2lfREhabdWYQwxTzWbXneGPt129vHw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-kA_R7r3WNOSx64uIc8dcjg-1; Fri, 26 Mar 2021 13:36:20 -0400
X-MC-Unique: kA_R7r3WNOSx64uIc8dcjg-1
Received: by mail-ed1-f71.google.com with SMTP id h5so4801152edf.17
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 10:36:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SiWoaGpTsKxnpfH36CVPc9yu7W5RPrt7W/LPaBOJkxE=;
        b=JD7EWxdhsQmKhkKVseJz78ndUTb5MFwcGAMyx5xUABaWuNaEeVVG2x91gSjvVYsOdY
         FXQqybSd9q7UgYL+70tlLbSM/tJdv75J5p8V4OViUeZYJmhHLKUUPq2EGOwlxsmSwDtT
         uueXjQtHVjgrQ0r7UpA2f8JWVA7n98eOFo6nwTk4tHpy2V1PR0/Vg0zQIowYAOGddgCi
         06XR7KmATxl2K8+ScLRcrOZPNgYc/dKQrqUifgqMBZuiHKfD4w297Hi5oQQyNUOTxWh2
         rqUdDPshlFZcA1WJ0o84cfu+kJEj1m8KTGok8Eksc0dHYiycDGxyaohHT+At6CaIsucI
         7t1g==
X-Gm-Message-State: AOAM5300ychxc2SXvnWvzwuVuERjz8k/H5+6VT+XNhxc6y5oUewK4+xk
        YttlwMxkYMG2jn04IJTM2HCDMf6kXIenn1FmZEU04t2K+UONbp7UWN2EqsQEEPvYGkE3xVmn1eV
        tuxfCoPwmOkjJ
X-Received: by 2002:a17:906:fc1c:: with SMTP id ov28mr16619557ejb.342.1616780179308;
        Fri, 26 Mar 2021 10:36:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywy9F+bHrM6Wo1A9BQMrDcnwQV/JRcPdm9zC2239ivfsh4NlsKnAFvT9M3QNEYIiq1nD6MxQ==
X-Received: by 2002:a17:906:fc1c:: with SMTP id ov28mr16619538ejb.342.1616780179162;
        Fri, 26 Mar 2021 10:36:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d1sm4130294eje.26.2021.03.26.10.36.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 10:36:18 -0700 (PDT)
Subject: Re: [PATCH] KVM: make: Fix out-of-source module builds
To:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210324124347.18336-1-sidcha@amazon.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0391f264-ff1a-5ab6-c989-96a9f28a9457@redhat.com>
Date:   Fri, 26 Mar 2021 18:36:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210324124347.18336-1-sidcha@amazon.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/03/21 13:43, Siddharth Chandrasekaran wrote:
> Building kvm module out-of-source with,
> 
>      make -C $SRC O=$BIN M=arch/x86/kvm
> 
> fails to find "irq.h" as the include dir passed to cflags-y does not
> prefix the source dir. Fix this by prefixing $(srctree) to the include
> dir path.
> 
> Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> ---
>   arch/x86/kvm/Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index 1b4766fe1de2..eafc4d601f25 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -1,6 +1,6 @@
>   # SPDX-License-Identifier: GPL-2.0
>   
> -ccflags-y += -Iarch/x86/kvm
> +ccflags-y += -I $(srctree)/arch/x86/kvm
>   ccflags-$(CONFIG_KVM_WERROR) += -Werror
>   
>   ifeq ($(CONFIG_FRAME_POINTER),y)
> 

Queued, thanks.

Paolo

