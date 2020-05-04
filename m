Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513F21C40A7
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 19:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729908AbgEDRAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 13:00:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40699 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729540AbgEDRAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 13:00:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588611619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XZwSHDTgAJY55QsWjO425HTimSCFfyLWLSNByzoLLc4=;
        b=Z1JmlEj/ncuX1AnevsXt++7xoLZL3Uwx+hT3iWbnr/a9D+noJ3L3+9LBCPzRMaMVdJolR3
        E8YgIIV3QOL6lFQbK5PR+4jW6PuWUXgEG6kNiEe5c6T7GrARXcGWqzpjm5FFY40Dt23CZd
        ipYxSZY/czvjOdzb6k6qSUAwC+fvoRQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-pKMin8KGP7G9-OUkyzjw9g-1; Mon, 04 May 2020 13:00:14 -0400
X-MC-Unique: pKMin8KGP7G9-OUkyzjw9g-1
Received: by mail-wr1-f70.google.com with SMTP id o6so34153wrn.0
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 10:00:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XZwSHDTgAJY55QsWjO425HTimSCFfyLWLSNByzoLLc4=;
        b=pcbd/aqbtnKbuioa9RPZGtVa1INirSMDUAOuA6nRj6sBvcnYNOu/33R4lDmuly1Fr8
         RvxkD1odDTSJn+iFy2EWx/apUW/n/Dq6TlyeyF9bJBXZRKGh4czggwrgJ+5s1j3dm41e
         Wod72rAImPzdtj1oVTfZx7CbUA7XDv+JC7CnuRz0ZmC3+qODFA2AJEcTCwYh+XyOoboE
         ikf08SLQY3yjDSPvVtC/eKhpCifFO5OpzR1b4JIS6nZQtA8k6EAqUBVTYCbG+US0Pa/a
         IHlB/p0uZ1td+zMXp0qCxahRIRrz+lKQp6onPmXsoU9wrQi2XahBTJygGFKLWqI47DZB
         iSfg==
X-Gm-Message-State: AGi0Puan9PhHCS/o+O6dliB+lgGWhsZeQto0J91WkIe/SnqVNkGflBw9
        Rs/ao3KWzfcHRqdGqbskLRFHENpslSwFYb5KxK7eic2N5lwEsxGOHrbsbxSTtYJnPrCOP5aMRt5
        umTsPqSVpi/pc
X-Received: by 2002:a05:600c:2:: with SMTP id g2mr16326090wmc.85.1588611613313;
        Mon, 04 May 2020 10:00:13 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ41oygDiuT1qZ0XdnetyQ4B6+1kUn6yL5hrKBBZ6sRup8CrAvAib+rpBZ4eSHnMvvBKSpOkQ==
X-Received: by 2002:a05:600c:2:: with SMTP id g2mr16326061wmc.85.1588611613127;
        Mon, 04 May 2020 10:00:13 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id 89sm7720568wrj.37.2020.05.04.10.00.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 10:00:12 -0700 (PDT)
Subject: Re: [PATCH] KVM: Documentation: Fix up cpuid page
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200416155913.267562-1-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <16eba56e-226e-2ad7-5cdd-0f2e90f152e8@redhat.com>
Date:   Mon, 4 May 2020 19:00:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200416155913.267562-1-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/04/20 17:59, Peter Xu wrote:
> 0x4b564d00 and 0x4b564d01 belong to KVM_FEATURE_CLOCKSOURCE2.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  Documentation/virt/kvm/cpuid.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> index 01b081f6e7ea..f721c89327ec 100644
> --- a/Documentation/virt/kvm/cpuid.rst
> +++ b/Documentation/virt/kvm/cpuid.rst
> @@ -50,8 +50,8 @@ KVM_FEATURE_NOP_IO_DELAY          1           not necessary to perform delays
>  KVM_FEATURE_MMU_OP                2           deprecated
>  
>  KVM_FEATURE_CLOCKSOURCE2          3           kvmclock available at msrs
> -
>                                                0x4b564d00 and 0x4b564d01
> +
>  KVM_FEATURE_ASYNC_PF              4           async pf can be enabled by
>                                                writing to msr 0x4b564d02
>  
> 

Queued, thanks.

Paolo

