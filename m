Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1DF22EDF9
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 15:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgG0NyB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 09:54:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32888 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726247AbgG0NyA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 09:54:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595858039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zEtQDs6cVppDK5WKf5nJI5uTNdjoT/6wHXknBUUaQAk=;
        b=GmLJ0mv4IeQ+ghSb7Ps9Kh6VZ+kDrGwxDh9z4vJ8WiLn8XorI712JFaG0yHUXvT/j+SN/G
        EUiJqIFuVupLkJb9WdOOu1AsldhDNPwWtgF/aaAei9EskDhGXFE1kdlTuwnGB7MhUoDID3
        JH0TtjEp4/EQ7fKi9j55Toamo2Pqjos=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-R03fF09VPA-I2ldklE0Ung-1; Mon, 27 Jul 2020 09:53:56 -0400
X-MC-Unique: R03fF09VPA-I2ldklE0Ung-1
Received: by mail-wr1-f70.google.com with SMTP id f14so3937722wrm.22
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 06:53:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zEtQDs6cVppDK5WKf5nJI5uTNdjoT/6wHXknBUUaQAk=;
        b=egLDrLbdInE2TDO5RET/4JR1qSi4H8//QzBkEk97tE6xl0RimROqeG43AJB2Hvaypk
         ru9S5ISIQMeFdJ60+V4/DOB/lxjo1+apPSI66sxR+N6sDbmH/++mmRSXFl3mSLvYjKWe
         XnYarjfo/4bL72ejqY1g6R9NJjam28X7PBzClX7zL1GYVxXJwlw0YOy5yXRW70+fXGXC
         joTQHQUiLH0lPRyEqrBiJ6RfEZqejUTrASCDDdc34yRH8QB5fPbCaMBWuOZgKR4zuVMd
         xO6psaENDtv3ZIR28nO5Y6qjkXGjAo7o+Yy0W1TmTgDRHuKHQLWVve8jz4A4c/sZiAR8
         P7lg==
X-Gm-Message-State: AOAM532yqe9WlhTEbF1Bwyhmqv8ZMWYzjN5ewP8c14D5vyfDIKzzYWyp
        BvXYehsJP0Rg/+I5H2rjeEYIUvfuaXEWUcox0T0tCAP3W6D54TgATrf9WIs0k3iCUfh6VkPpr0T
        5+e/8p4dU3pDJ
X-Received: by 2002:a05:600c:2209:: with SMTP id z9mr20038383wml.70.1595858035175;
        Mon, 27 Jul 2020 06:53:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8T3WYkDDJyVBZk0vOV3Xvzou/NRMJtSKXBjdBGUAmkCaSBmPaaxVeHEWeMNixgTZXBHCw6w==
X-Received: by 2002:a05:600c:2209:: with SMTP id z9mr20038364wml.70.1595858034895;
        Mon, 27 Jul 2020 06:53:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4502:3ee3:2bae:c612? ([2001:b07:6468:f312:4502:3ee3:2bae:c612])
        by smtp.gmail.com with ESMTPSA id y11sm13158673wrs.80.2020.07.27.06.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2020 06:53:54 -0700 (PDT)
Subject: Re: [PATCH] MIPS: KVM: Fix build error caused by 'kvm_run' cleanup
To:     Huacai Chen <chenhc@lemote.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
References: <1595154207-9787-1-git-send-email-chenhc@lemote.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <21b0e23a-5974-dbcb-0e0a-e2c1847a97d4@redhat.com>
Date:   Mon, 27 Jul 2020 15:53:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1595154207-9787-1-git-send-email-chenhc@lemote.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/07/20 12:23, Huacai Chen wrote:
> Commit c34b26b98caca48ec9ee9 ("KVM: MIPS: clean up redundant 'kvm_run'
> parameters") remove the 'kvm_run' parameter in kvm_mips_complete_mmio_
> load(), but forget to update all callers.
> 
> Fixes: c34b26b98caca48ec9ee9 ("KVM: MIPS: clean up redundant 'kvm_run' parameters")
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
> I have reviewed Tianjia's patch but hadn't found the bug, I'm very very
> sorry for that.
> 
>  arch/mips/kvm/emulate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
> index d242300c..3b3f7b11 100644
> --- a/arch/mips/kvm/emulate.c
> +++ b/arch/mips/kvm/emulate.c
> @@ -2128,7 +2128,7 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
>  			run->mmio.phys_addr, run->mmio.len, run->mmio.data);
>  
>  	if (!r) {
> -		kvm_mips_complete_mmio_load(vcpu, run);
> +		kvm_mips_complete_mmio_load(vcpu);
>  		vcpu->mmio_needed = 0;
>  		return EMULATE_DONE;
>  	}
> 

Queued, thanks.

Paolo

