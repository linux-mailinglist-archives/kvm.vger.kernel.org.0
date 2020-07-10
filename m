Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E75021B015
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 09:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgGJHXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 03:23:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28096 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725851AbgGJHXe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 03:23:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594365813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9rlNnRbRqtwxX9xwOw7BiMZzCXRPe3JkOPdkKEm94pM=;
        b=HUwWv/wPoSsRnis2bHT07rE9yS0ec9pGfvu2JaHF5IH/4RQMBaysOB1lTQBAZctQU8NK4g
        Y4QXjcLglJHYV5L2jFs45qzIAix9SYjMILXiEaJ7u7XXcbPKtlSJKQ7Q4MN62uyCZ9ncQv
        /x4HDINcQjF/BEvF1KksDoNFhOPxhyM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-OVnoJ9WtMJSR2Gy61kF8Aw-1; Fri, 10 Jul 2020 03:23:31 -0400
X-MC-Unique: OVnoJ9WtMJSR2Gy61kF8Aw-1
Received: by mail-wr1-f71.google.com with SMTP id v3so4970706wrq.10
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 00:23:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9rlNnRbRqtwxX9xwOw7BiMZzCXRPe3JkOPdkKEm94pM=;
        b=UGvHOFRcL3UrPCqrbEJ8cqa/ZBH2/8f7K8HeSafLh/gcm6tZW6UNuV+vCyZks5KPAz
         7qbOUA2bijTMEIRR1xa6vHHz/ifSg8jhyEfQxmmfxYTHsreauDMZJ/0i51vLj1Mh4Xzv
         +k8YjwGId1c5lf3UPxbfmCFoBCJGOSq9FTmXPw3HcuDyn1Te+7y1o0Tl6avxTbRZovEw
         4ohtHrM2JBcKKuzPThv31YOGpUYNDfUQfky4P4nctwHdHbvI3nWhEAJk9ip4pIwrHdmE
         t9Jf708/E6HDZaL0MFTnM6qRMTLuSczh5ylYHBr3UnTrz9uphKVwuieYb2p/SU/gGgBK
         JMkg==
X-Gm-Message-State: AOAM532iNb79OSiAX5iA65HeIUDnltp45SKHlJZMtcNcWPrQtZpCQZ/h
        PbrDHUINAHHHab/qJQuxowbzttu6qi4WmF+S97KQ0A+NQ3xjRUR5ehvLtXP525xrrRnbKwiAOj9
        oRyY8TH4qhtTg
X-Received: by 2002:a05:6000:1143:: with SMTP id d3mr54505538wrx.235.1594365810611;
        Fri, 10 Jul 2020 00:23:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5gKoesIIGwDsggi1LxHDAmw11dsdUiy6Tv9bIEijXeDfWJZHy6OtV2T4NmFlW7hWej+34Gw==
X-Received: by 2002:a05:6000:1143:: with SMTP id d3mr54505524wrx.235.1594365810390;
        Fri, 10 Jul 2020 00:23:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id b184sm8664696wmc.20.2020.07.10.00.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 00:23:29 -0700 (PDT)
Subject: Re: [PATCH] KVM: MIPS: Fix build errors for 32bit kernel
To:     Huacai Chen <chenhc@lemote.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <1594365797-536-1-git-send-email-chenhc@lemote.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f7266f18-6f8d-0224-1675-c2a514cf0c5b@redhat.com>
Date:   Fri, 10 Jul 2020 09:23:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1594365797-536-1-git-send-email-chenhc@lemote.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/07/20 09:23, Huacai Chen wrote:
> Commit dc6d95b153e78ed70b1b2c04a ("KVM: MIPS: Add more MMIO load/store
> instructions emulation") introduced some 64bit load/store instructions
> emulation which are unavailable on 32bit platform, and it causes build
> errors:
> 
> arch/mips/kvm/emulate.c: In function 'kvm_mips_emulate_store':
> arch/mips/kvm/emulate.c:1734:6: error: right shift count >= width of type [-Werror]
>       ((vcpu->arch.gprs[rt] >> 56) & 0xff);
>       ^
> arch/mips/kvm/emulate.c:1738:6: error: right shift count >= width of type [-Werror]
>       ((vcpu->arch.gprs[rt] >> 48) & 0xffff);
>       ^
> arch/mips/kvm/emulate.c:1742:6: error: right shift count >= width of type [-Werror]
>       ((vcpu->arch.gprs[rt] >> 40) & 0xffffff);
>       ^
> arch/mips/kvm/emulate.c:1746:6: error: right shift count >= width of type [-Werror]
>       ((vcpu->arch.gprs[rt] >> 32) & 0xffffffff);
>       ^
> arch/mips/kvm/emulate.c:1796:6: error: left shift count >= width of type [-Werror]
>       (vcpu->arch.gprs[rt] << 32);
>       ^
> arch/mips/kvm/emulate.c:1800:6: error: left shift count >= width of type [-Werror]
>       (vcpu->arch.gprs[rt] << 40);
>       ^
> arch/mips/kvm/emulate.c:1804:6: error: left shift count >= width of type [-Werror]
>       (vcpu->arch.gprs[rt] << 48);
>       ^
> arch/mips/kvm/emulate.c:1808:6: error: left shift count >= width of type [-Werror]
>       (vcpu->arch.gprs[rt] << 56);
>       ^
> cc1: all warnings being treated as errors
> make[3]: *** [arch/mips/kvm/emulate.o] Error 1
> 
> So, use #if defined(CONFIG_64BIT) && defined(CONFIG_KVM_MIPS_VZ) to
> guard the 64bit load/store instructions emulation.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: dc6d95b153e78ed70b1b2c04a ("KVM: MIPS: Add more MMIO load/store instructions emulation")
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  arch/mips/kvm/emulate.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
> index 5ae82d9..d242300c 100644
> --- a/arch/mips/kvm/emulate.c
> +++ b/arch/mips/kvm/emulate.c
> @@ -1722,6 +1722,7 @@ enum emulation_result kvm_mips_emulate_store(union mips_instruction inst,
>  			  vcpu->arch.gprs[rt], *(u32 *)data);
>  		break;
>  
> +#if defined(CONFIG_64BIT) && defined(CONFIG_KVM_MIPS_VZ)
>  	case sdl_op:
>  		run->mmio.phys_addr = kvm_mips_callbacks->gva_to_gpa(
>  					vcpu->arch.host_cp0_badvaddr) & (~0x7);
> @@ -1815,6 +1816,7 @@ enum emulation_result kvm_mips_emulate_store(union mips_instruction inst,
>  			  vcpu->arch.pc, vcpu->arch.host_cp0_badvaddr,
>  			  vcpu->arch.gprs[rt], *(u64 *)data);
>  		break;
> +#endif
>  
>  #ifdef CONFIG_CPU_LOONGSON64
>  	case sdc2_op:
> @@ -2002,6 +2004,7 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
>  		}
>  		break;
>  
> +#if defined(CONFIG_64BIT) && defined(CONFIG_KVM_MIPS_VZ)
>  	case ldl_op:
>  		run->mmio.phys_addr = kvm_mips_callbacks->gva_to_gpa(
>  					vcpu->arch.host_cp0_badvaddr) & (~0x7);
> @@ -2073,6 +2076,7 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
>  			break;
>  		}
>  		break;
> +#endif
>  
>  #ifdef CONFIG_CPU_LOONGSON64
>  	case ldc2_op:
> 

Queued, thanks.

Paolo

