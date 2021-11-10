Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE1944C6A2
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 19:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhKJSJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 13:09:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57535 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229969AbhKJSJP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Nov 2021 13:09:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636567587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cqzkKKVU1TFefm2txuHW5tA1oBvnHRU7MmXEb01dQtg=;
        b=a70ULvnQZnM0QKBho/JrkwZhStoJZeaYyfrtGZ2jnTJyRimeDnjfDGquetjjas5uAs8VVB
        dapbyFWQAUVmzg2Jgvr26S+2bq/LNBRTUZXEyYJ3T9xdu/ctTD6lsEFIa23BfnG/TkX+lE
        hsAWn8hhM3iQ4PU3P1QOSxve46xHac0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-WuMdj5oAPdWGuvWRyIlGuA-1; Wed, 10 Nov 2021 13:06:25 -0500
X-MC-Unique: WuMdj5oAPdWGuvWRyIlGuA-1
Received: by mail-wm1-f72.google.com with SMTP id c1-20020a05600c0ac100b00322fcaa2bc7so1526059wmr.4
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 10:06:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cqzkKKVU1TFefm2txuHW5tA1oBvnHRU7MmXEb01dQtg=;
        b=uhwfJcB789GlXD8VqA232gRAsTj0O0kQKoxyxlWbfamY41r6UFv+ezl1AQKjNi+hp/
         Ir6KizSwdmHOIURNuVrv3AUU4OnMpNslXKpmk/OYr6VCQfef+fEuUcROqmY1GsjXPuSS
         feJL9TefHDEdneFGK0iWS7mbnK688VSGMn3oCgcyZn2jmbcAEabVGs/PJrXv1HY2siz0
         NnA4QNg3Te7iz7q3ywtr7ZJ7kumsm6rFpXfHIGIdGvszCUO04+NVtaTmklv5eti0H79+
         GWs1leAS0zazMEPOx5sbCYGzZsD8vgpioTs4uvM7nw+0x3rpgjAZnqWtkHJ1Zl5V/3tr
         6/0g==
X-Gm-Message-State: AOAM532/bIsfphvu8k6f5ZNw9IiTZDvrGR0CTMzdpHKCITGNTGo4m5vM
        FbjAoZ+oZsC5xihoQDzETyI9l7aG7rNdsSQVsT4eZ7QHZdklyP+6CHXctJGXt43SN7fRjxDLOFy
        zIzAb+iBB5yPq
X-Received: by 2002:a05:600c:510d:: with SMTP id o13mr18448364wms.104.1636567584278;
        Wed, 10 Nov 2021 10:06:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxU9y/NX64qlc3vXZ1ejqNHzYKNDlRCKkpWhRwE8xA5Lk7aS9uc4qTP3ah1NLedT0vvveXpAw==
X-Received: by 2002:a05:600c:510d:: with SMTP id o13mr18448327wms.104.1636567584080;
        Wed, 10 Nov 2021 10:06:24 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id y6sm621380wrh.18.2021.11.10.10.06.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 10:06:23 -0800 (PST)
Subject: Re: [PATCH v4 06/15] KVM: arm64: Add paravirtualization header files
To:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
        shan.gavin@gmail.com, Jonathan.Cameron@huawei.com,
        pbonzini@redhat.com, vkuznets@redhat.com, will@kernel.org
References: <20210815005947.83699-1-gshan@redhat.com>
 <20210815005947.83699-7-gshan@redhat.com>
From:   Eric Auger <eauger@redhat.com>
Message-ID: <82506a31-7b32-f8e2-c0cb-0f39d204ef3a@redhat.com>
Date:   Wed, 10 Nov 2021 19:06:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815005947.83699-7-gshan@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Gavin,

On 8/15/21 2:59 AM, Gavin Shan wrote:
> We need put more stuff in the paravirtualization header files when
> the asynchronous page fault is supported. The generic header files
> can't meet the goal.
you need to explain why
 This duplicate the generic header files to be
s/This duplicate/Duplicate
> our platform specific header files. It's the preparatory work to
> support the asynchronous page fault in the subsequent patches:
why duplication and not move. Shouldn't it be squashed with another
subsequent patch?

Eric
> 
>    include/uapi/asm-generic/kvm_para.h
>    include/asm-generic/kvm_para.h
> 
>    arch/arm64/include/uapi/asm/kvm_para.h
>    arch/arm64/include/asm/kvm_para.h
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/include/asm/kvm_para.h      | 27 ++++++++++++++++++++++++++
>  arch/arm64/include/uapi/asm/Kbuild     |  2 --
>  arch/arm64/include/uapi/asm/kvm_para.h |  5 +++++
>  3 files changed, 32 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm64/include/asm/kvm_para.h
>  create mode 100644 arch/arm64/include/uapi/asm/kvm_para.h
> 
> diff --git a/arch/arm64/include/asm/kvm_para.h b/arch/arm64/include/asm/kvm_para.h
> new file mode 100644
> index 000000000000..0ea481dd1c7a
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_para.h
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_ARM_KVM_PARA_H
> +#define _ASM_ARM_KVM_PARA_H
> +
> +#include <uapi/asm/kvm_para.h>
> +
> +static inline bool kvm_check_and_clear_guest_paused(void)
> +{
> +	return false;
> +}
> +
> +static inline unsigned int kvm_arch_para_features(void)
> +{
> +	return 0;
> +}
> +
> +static inline unsigned int kvm_arch_para_hints(void)
> +{
> +	return 0;
> +}
> +
> +static inline bool kvm_para_available(void)
> +{
> +	return false;
> +}
> +
> +#endif /* _ASM_ARM_KVM_PARA_H */
> diff --git a/arch/arm64/include/uapi/asm/Kbuild b/arch/arm64/include/uapi/asm/Kbuild
> index 602d137932dc..f66554cd5c45 100644
> --- a/arch/arm64/include/uapi/asm/Kbuild
> +++ b/arch/arm64/include/uapi/asm/Kbuild
> @@ -1,3 +1 @@
>  # SPDX-License-Identifier: GPL-2.0
> -
> -generic-y += kvm_para.h
> diff --git a/arch/arm64/include/uapi/asm/kvm_para.h b/arch/arm64/include/uapi/asm/kvm_para.h
> new file mode 100644
> index 000000000000..cd212282b90c
> --- /dev/null
> +++ b/arch/arm64/include/uapi/asm/kvm_para.h
> @@ -0,0 +1,5 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI_ASM_ARM_KVM_PARA_H
> +#define _UAPI_ASM_ARM_KVM_PARA_H
> +
> +#endif /* _UAPI_ASM_ARM_KVM_PARA_H */
> 

