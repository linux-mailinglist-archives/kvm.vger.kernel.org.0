Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63BED17A753
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 15:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgCEOYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 09:24:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34610 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725965AbgCEOYB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 09:24:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583418239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7wS/wcb85DkcLBGKnRxV24Ml02OHwCI8OhAwRihp0FA=;
        b=EixRMxFxaR9v60oqUjfN07paIyEu1l92RwDz2CmDxYJ8XOiX9Kyap0p+pmWtawBGPrxh9H
        ynr9tBTDfa75j+CGLHKDsBB+QuLvDl1gglUJRF9YP2Dm4gV8sY4ezn6VDi9rIwzo0Xp5sa
        t2tRftcKqW3+e+buBFDam1WTuOzRu2o=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-rKJMpKdsOKuE3RTr4aJeRw-1; Thu, 05 Mar 2020 09:23:57 -0500
X-MC-Unique: rKJMpKdsOKuE3RTr4aJeRw-1
Received: by mail-wr1-f72.google.com with SMTP id t14so2359518wrs.12
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 06:23:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7wS/wcb85DkcLBGKnRxV24Ml02OHwCI8OhAwRihp0FA=;
        b=Qrt9C5sbusZ9m/i8DK4MULJDYtG8/f+1vd8e3CGvHSOu2ZxLh1xwnWlNNIO7Uc/Qqf
         KFUxEbX3zwm1UOCHDxiSfyEX2BVaDv9Vyjlzb9uDvvY4HU4uSPi/84ZOmhlNQB+94Jt8
         7lsOD2EXwaH3poGn5NRx1lwuRNBxyRvW/DMmvFI75W4XKVNuRXSIysFtbGmE/UMhwXHq
         6nwV2biE3+YG4aCVld8lIVIEg8A7681Qn/CmI0Z/XaH+k5CV2/H9s2jWE2bZLMTkDttu
         9jBpkfvnRk4ZT1hRpwIv8preGEmC3lJRmf/IgV/Miy54Mcbud7kzU+foIfzwPRXJ2ZKE
         pmOA==
X-Gm-Message-State: ANhLgQ18h7lFJvrKCfAUmtfrrRlv7JZCRBLnqvG4cpBP2esPPLqSDSdh
        JTpsUAul2ofJQPqlk4Jf5IUay0q7i1b0zNhy6nnm74DB682o+jlye1/lTyF65UF6YXXKh0hXkPf
        vc7A5/8n1qofw
X-Received: by 2002:a05:6000:1186:: with SMTP id g6mr1840639wrx.331.1583418236633;
        Thu, 05 Mar 2020 06:23:56 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsCAlsOC+yFneBefdJyj3+DCMaXPX18cRQKObXoQhxnoFrirb6aowWyILujBlj4CBuhZjFHmQ==
X-Received: by 2002:a05:6000:1186:: with SMTP id g6mr1840623wrx.331.1583418236409;
        Thu, 05 Mar 2020 06:23:56 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id z12sm17349361wrs.43.2020.03.05.06.23.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 06:23:55 -0800 (PST)
Subject: Re: [PATCH v2 1/4] x86/kvm/hyper-v: Align the hcall param for
 kvm_hyperv_exit
To:     Jon Doron <arilou@gmail.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com
References: <20200305140142.413220-1-arilou@gmail.com>
 <20200305140142.413220-2-arilou@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <09762184-9913-d334-0a33-b76d153bc371@redhat.com>
Date:   Thu, 5 Mar 2020 15:23:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200305140142.413220-2-arilou@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/20 15:01, Jon Doron wrote:
> Signed-off-by: Jon Doron <arilou@gmail.com>
> ---
>  include/uapi/linux/kvm.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4b95f9a31a2f..9b4d449f4d20 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -200,6 +200,7 @@ struct kvm_hyperv_exit {
>  			__u64 input;
>  			__u64 result;
>  			__u64 params[2];
> +			__u32 pad;
>  		} hcall;
>  	} u;
>  };
> 

Can you explain the purpose of this patch?

Paolo

