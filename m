Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AE5241A42
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 13:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgHKLTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 07:19:52 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40598 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728722AbgHKLTu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Aug 2020 07:19:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597144789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E/b3MlPnS2fuBzmiz0g+4SKXMuO51LxW4Hm59pIWy/s=;
        b=JrphKBtE+mCM54WnO6U2ii+LNIMoAGvcVEodfM3mMAlO4WKqh1bEOwkEZSXq6LPW/7ZN80
        uZJrvJHM6zw6YfiujOJIQsxjIy5CGCZslPmjVtUy9ef8oLlEgKNZDUg/WK8LRM/5FbzeLy
        CBH7h9vUUjnVXjnHXQgglNNyKS5TfpY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-kDGD2iffMliPIPEuxBy_7w-1; Tue, 11 Aug 2020 07:19:47 -0400
X-MC-Unique: kDGD2iffMliPIPEuxBy_7w-1
Received: by mail-wr1-f69.google.com with SMTP id m7so5467203wrb.20
        for <kvm@vger.kernel.org>; Tue, 11 Aug 2020 04:19:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E/b3MlPnS2fuBzmiz0g+4SKXMuO51LxW4Hm59pIWy/s=;
        b=WWYGE7UB1OpdgBmueT/4Tftf/UnG5TrUpUx9nNPYEXWkp/GdmWdfkvFeOJvuEL4oHG
         fpuh9bLIBU7/wpEuul7ZbHWKiK1pjzmXJLTDKt+cEaaVvWgopjWEYGIaCnh0uR4A+UwO
         LXitpx5J3XZY8haZlZf+gIxnW4fG9DqWdX8YZOdZzk2Sn+sgUG0RRjqmu6IOvoy4HKIL
         2GE6HYHHMCeruMXUxcO8SOeJzlzkAu3SqsQsrI8V1o6qhX049j+TCBj2dki2+xoUT2t4
         rOrT3dyWcLq/cb/P7PoQjyl9rFe0QxH+ezTV+1O1C1dgNP+/iLZ6XWdW8Ag9FpXeZTQ2
         4PTg==
X-Gm-Message-State: AOAM532xMngDONMfv4rbVlTw+RNd0iQywNSM+eEz2SS9bbN82Dix37/q
        KckbYzuItk/r2WqN1HqdeK3aMVsDT4TvdiQFnREnNt8OxYTBd6uiV0Cdv05zfLaPzsKzMMZOIO+
        pRj4Ek+0EEq/k
X-Received: by 2002:a7b:c7d5:: with SMTP id z21mr3679297wmk.145.1597144786097;
        Tue, 11 Aug 2020 04:19:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycs8UIHN4QlqH2I4HQWZaGHCNRAKLSrQG2kEthrAyxd1vyOM7wNG5kQKcp+EWkaj8Ozb+JXQ==
X-Received: by 2002:a7b:c7d5:: with SMTP id z21mr3679278wmk.145.1597144785885;
        Tue, 11 Aug 2020 04:19:45 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.12.249])
        by smtp.gmail.com with ESMTPSA id d11sm26253533wrw.77.2020.08.11.04.19.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 04:19:45 -0700 (PDT)
Subject: Re: [PATCH RESEND] KVM: MIPS/VZ: Fix build error caused by 'kvm_run'
 cleanup
To:     Xingxing Su <suxingxing@loongson.cn>,
        Huacai Chen <chenhc@lemote.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1597138297-2105-1-git-send-email-suxingxing@loongson.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bbbd9ca6-431a-26be-a9c9-18b7e6ce363c@redhat.com>
Date:   Tue, 11 Aug 2020 13:19:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1597138297-2105-1-git-send-email-suxingxing@loongson.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/08/20 11:31, Xingxing Su wrote:
> Commit c34b26b98caca48ec9ee9 ("KVM: MIPS: clean up redundant 'kvm_run'
> parameters") remove the 'kvm_run' parameter in kvm_vz_gpsi_lwc2.
> 
> The following build error:
> 
> arch/mips/kvm/vz.c: In function Ã¢â‚¬Ëœkvm_trap_vz_handle_gpsiÃ¢â‚¬â„¢:
> arch/mips/kvm/vz.c:1243:43: error: Ã¢â‚¬ËœrunÃ¢â‚¬â„¢ undeclared (first use in this function)
>    er = kvm_vz_gpsi_lwc2(inst, opc, cause, run, vcpu);
>                                            ^~~
> arch/mips/kvm/vz.c:1243:43: note: each undeclared identifier is reported only 
> once for each function it appears in
> scripts/Makefile.build:283: recipe for target 'arch/mips/kvm/vz.o' failed
> make[2]: *** [arch/mips/kvm/vz.o] Error 1
> scripts/Makefile.build:500: recipe for target 'arch/mips/kvm' failed
> make[1]: *** [arch/mips/kvm] Error 2
> Makefile:1785: recipe for target 'arch/mips' failed
> make: *** [arch/mips] Error 2
> 
> Signed-off-by: Xingxing Su <suxingxing@loongson.cn>
> ---
>  +cc Paolo Bonzini <pbonzini@redhat.com> and kvm@vger.kernel.org.
> 
>  arch/mips/kvm/vz.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> index 3932f76..49c6a2a 100644
> --- a/arch/mips/kvm/vz.c
> +++ b/arch/mips/kvm/vz.c
> @@ -1142,7 +1142,6 @@ static enum emulation_result kvm_vz_gpsi_cache(union mips_instruction inst,
>  #ifdef CONFIG_CPU_LOONGSON64
>  static enum emulation_result kvm_vz_gpsi_lwc2(union mips_instruction inst,
>  					      u32 *opc, u32 cause,
> -					      struct kvm_run *run,
>  					      struct kvm_vcpu *vcpu)
>  {
>  	unsigned int rs, rd;
> @@ -1240,7 +1239,7 @@ static enum emulation_result kvm_trap_vz_handle_gpsi(u32 cause, u32 *opc,
>  #endif
>  #ifdef CONFIG_CPU_LOONGSON64
>  	case lwc2_op:
> -		er = kvm_vz_gpsi_lwc2(inst, opc, cause, run, vcpu);
> +		er = kvm_vz_gpsi_lwc2(inst, opc, cause, vcpu);
>  		break;
>  #endif
>  	case spec3_op:
> 

Queued, thanks.

Paolo

