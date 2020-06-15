Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F401F9352
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 11:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgFOJ0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 05:26:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25323 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728180AbgFOJ0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 05:26:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592213169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hZRUtaUJ932ZlCQQbbYzNzjvtVWhAHymSOYbwBdTnCE=;
        b=BkMjoOYthG0RTYJ58GGaOhrz/DgCgl2E3CEmBJIwCZ0YSKS0cNsROdJDG/Fg/b8S/3wXGA
        hDuceyO6YkmVj0ZLAwk0xQK2hBLtAfYAqGD2zsUsYnA4Nv5JBWodWtdDo9xvsYBA7jjAnd
        swlR9sPu+Gt2cLBqv+KL+d6ZuzRjRNs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-T5SRRkQ7MWeTZ_wryIHnRg-1; Mon, 15 Jun 2020 05:26:08 -0400
X-MC-Unique: T5SRRkQ7MWeTZ_wryIHnRg-1
Received: by mail-wr1-f72.google.com with SMTP id j16so6746691wre.22
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 02:26:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hZRUtaUJ932ZlCQQbbYzNzjvtVWhAHymSOYbwBdTnCE=;
        b=VLrSl0eQLkh/6cbrQIMXMseOuyMF4R0rRUwPZ5KOBGHzedMnaOc6jIXTh6v3v3ysD0
         CkbDkzQS3wR2QPG5H6gbWjZDrUzKU5ZpwPYg1yf4dw95T1rVcxjq9ZpaT8cbd4w4SHwA
         lCr9sHXD/CmtaGaDrlm4atACCb1EF5o4EQ0u7cqIZ0Wm0T/Y+Lydr/O3cD3wWZ0sWDhb
         gl0m6iK+nAriUKQH2xcOv6GbjYtNzP3359jmssNKFT3LJCTVBG4W3StukgjTzuWTQVMX
         E/DWx50jOUeB10YJUGAQ7Ps+1a5BmErS190ab8mzpjwt5BggSy1uVqwViSDoZZbxK+Yf
         vTbg==
X-Gm-Message-State: AOAM531+Epmq2Owf3DeO+m4SSHZiOXdy95SF30upsCmGOCP6SfB2qwr8
        uRNjPFtMwJ/AVRwxOzh1PYsdd1Cbstu2hKh4k0byweiUQzrOXt/8jC6MBUu0p81HiDbTgkigdpu
        k0teCMsEGQlED
X-Received: by 2002:a5d:500d:: with SMTP id e13mr29684527wrt.150.1592213166872;
        Mon, 15 Jun 2020 02:26:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzv8DVyRZi9qtb8K0ghXXPE5Md7jQA6TvmLQFzaSBYlaUpm2+z2htDOIiu8mMzNA9/r75JKzw==
X-Received: by 2002:a5d:500d:: with SMTP id e13mr29684499wrt.150.1592213166643;
        Mon, 15 Jun 2020 02:26:06 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id t8sm21120194wmi.46.2020.06.15.02.26.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 02:26:06 -0700 (PDT)
Subject: Re: [PATCH] KVM: MIPS: fix spelling mistake "Exteneded" -> "Extended"
To:     Colin King <colin.king@canonical.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhc@lemote.com>, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200615082636.7004-1-colin.king@canonical.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8719ff21-8344-a4d0-112b-c7876f0b6f29@redhat.com>
Date:   Mon, 15 Jun 2020 11:26:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200615082636.7004-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/06/20 10:26, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a couple of kvm_err messages. Fix them.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  arch/mips/kvm/emulate.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
> index 5ae82d925197..d3d322f70fe0 100644
> --- a/arch/mips/kvm/emulate.c
> +++ b/arch/mips/kvm/emulate.c
> @@ -1861,7 +1861,7 @@ enum emulation_result kvm_mips_emulate_store(union mips_instruction inst,
>  				  vcpu->arch.gprs[rt], *(u64 *)data);
>  			break;
>  		default:
> -			kvm_err("Godson Exteneded GS-Store not yet supported (inst=0x%08x)\n",
> +			kvm_err("Godson Extended GS-Store not yet supported (inst=0x%08x)\n",
>  				inst.word);
>  			break;
>  		}
> @@ -2103,7 +2103,7 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
>  			vcpu->mmio_needed = 30;	/* signed */
>  			break;
>  		default:
> -			kvm_err("Godson Exteneded GS-Load for float not yet supported (inst=0x%08x)\n",
> +			kvm_err("Godson Extended GS-Load for float not yet supported (inst=0x%08x)\n",
>  				inst.word);
>  			break;
>  		}
> 

Queued, thanks.

Paolo

