Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA476234012
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 09:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731718AbgGaHge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 03:36:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51568 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731652AbgGaHgd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 03:36:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596180991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=553KQ1qNVymmVc2Jbs3bPD4YZyJND+P5R8Nz7Iw3uxY=;
        b=aVW+me/xFSycdL0B/50SF+57hZZd2rIW0Qrn+rQTxLpmChSfcXDGuGc+qofzxe/CMwV504
        rYUpdHv6RY1iHeb5p//rpauKR0fyLYEVw6XkUhrwI0hZdX0DnSBwsAmn1pZKkkjPGbdMmL
        yhLOkHb5WGtsvlgmwwGPUspixZpeiaM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-P6ZzbWV8Mj2NAEf62cTwdQ-1; Fri, 31 Jul 2020 03:36:28 -0400
X-MC-Unique: P6ZzbWV8Mj2NAEf62cTwdQ-1
Received: by mail-wr1-f72.google.com with SMTP id b13so6079466wrq.19
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 00:36:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=553KQ1qNVymmVc2Jbs3bPD4YZyJND+P5R8Nz7Iw3uxY=;
        b=PHyScnxX9m31GiOxpBJIkp3tdIHPUToFU3iT5xK+sWs6Im4/4SpoU8g7PDFGtsfJkX
         o62U1NUlLzuuYoqFP1sf/+7/3Zm71yKPWRbzTruBzP/9PMxjt9GsB+GsnPVYJ8dw721K
         RZk5+eG/1aXiSTKAN5BkIt0iax9BguwHl77YXZtUwhTcIHsHyX9CM8P3hywGttCzRmms
         5SRib70CfhYfydFomwj/1r7zim9OqtbJY0x0bmwervfjaJLnLkVjiK66YRoo/lEv2ghe
         t4LRdYlpFDsG94VtphP2Bm0/NoUU+v+Cm+yKXaXATiTq/3aK68FOz93aTlXcLq/CD4mv
         E4QQ==
X-Gm-Message-State: AOAM530n3eTQRta84uL5vNeV0WMMs07BsU3kmLRUP974nZZuriJ13OLL
        z8YoPIjDBbl3roY1uN2nmJeZ762b/SDCwfpNVL6OOa66sN/upyPNqxqkWobx2r2VFMNlEWS+9Vr
        yXD644EoUTZSw
X-Received: by 2002:a5d:5609:: with SMTP id l9mr2180875wrv.86.1596180985662;
        Fri, 31 Jul 2020 00:36:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyK5Kv8TZaxnsghX4+eREYu/xA6eXNCFl4Iau4DmmrIF5oz1lEHRcJA6j4qFKcbXil6qN/DmQ==
X-Received: by 2002:a5d:5609:: with SMTP id l9mr2180862wrv.86.1596180985472;
        Fri, 31 Jul 2020 00:36:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:90a5:f767:5f9f:3445? ([2001:b07:6468:f312:90a5:f767:5f9f:3445])
        by smtp.gmail.com with ESMTPSA id t11sm11878979wrs.66.2020.07.31.00.36.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 00:36:24 -0700 (PDT)
Subject: Re: [PATCH -next] emulate:Fix build error
To:     Peng Wu <wupeng58@huawei.com>, tsbogend@alpha.franken.de
Cc:     chenhc@lemote.com, aleksandar.qemu.devel@gmail.com,
        colin.king@canonical.com, tianjia.zhang@linux.alibaba.com,
        huanglllzu@gmail.com, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1596179807-17713-1-git-send-email-wupeng58@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ddee30c4-6190-5cbc-6340-c138bd1550b5@redhat.com>
Date:   Fri, 31 Jul 2020 09:36:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1596179807-17713-1-git-send-email-wupeng58@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/20 09:16, Peng Wu wrote:
> The declaration of function kvm_mips_complete_mmio_load
> has only one formal parameter,but two parameters are passed
> when called. So, the following error is seen while building
> emulate.c
> 
> arch/mips/kvm/emulate.c: In function ‘kvm_mips_emulate_load’:
> arch/mips/kvm/emulate.c:2130:3: error: too many arguments
> to function ‘kvm_mips_complete_mmio_load’
>    kvm_mips_complete_mmio_load(vcpu, run);
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from linux/include/linux/kvm_host.h:36,
>                  from linux/arch/mips/kvm/emulate.c:15:
> arch/mips/include/asm/kvm_host.h:1072:30: note: declared here
> extern enum emulation_result
> 	kvm_mips_complete_mmio_load(struct kvm_vcpu *vcpu);
> 
> Signed-off-by: Peng Wu <wupeng58@huawei.com>
> ---
>  arch/mips/kvm/emulate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
> index 1d41965..7037823 100644
> --- a/arch/mips/kvm/emulate.c
> +++ b/arch/mips/kvm/emulate.c
> @@ -2127,7 +2127,7 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
>  			run->mmio.phys_addr, run->mmio.len, run->mmio.data);
>  
>  	if (!r) {
> -		kvm_mips_complete_mmio_load(vcpu, run);
> +		kvm_mips_complete_mmio_load(vcpu);
>  		vcpu->mmio_needed = 0;
>  		return EMULATE_DONE;
>  	}
> 

This is queued already, I' will push it shortly.  Thanks!

Paolo

