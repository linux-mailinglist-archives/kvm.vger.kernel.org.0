Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3341873CD
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 21:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732470AbgCPUG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 16:06:29 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37975 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732436AbgCPUG2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 16:06:28 -0400
Received: by mail-pg1-f193.google.com with SMTP id x7so10347313pgh.5
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 13:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oMoLpNdfwPj3BjJ9X6DM9wITDjEHBSTuqrQmlwfNSjU=;
        b=mfW4NgO9PmedbXOTkBJ2p4fnyqH+PaQYFFXkpEl0+hkas2oi5vm/Ucr8lrSCnzFctx
         6wBrvoaeMeZBG2bQRqO6mw68s4MtCafwnw1Acq3IC/kOQ/oZvCX1QOkyT1nv8l5yR9f7
         nL8bzh5vOlxijwjQmhJX60n3loAmx6odX8iqdxxUKlOyqsvAUvJZGVcUty0Jq2YYVuHW
         ciMsmsWm/7We+5mY6F/srwuqqKqIvZJ3LWnx4LWa6xvmfGDrBi1V+BdAJm3E8Mi8khy7
         N49rccakpTBvzDNoqeIEZhtiDJQhZr1MR+mYhDE+Yea4FztXp6MFREA8EZUCaWd+HufS
         NvHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oMoLpNdfwPj3BjJ9X6DM9wITDjEHBSTuqrQmlwfNSjU=;
        b=b11hYcCWOh4PPih7Tw5CdOlZ3wb3NP6N5Kl6uVDAtusgEkzP+koAbf10y1zuDlCZAL
         CLImsji2P/LZq7uydGtZXTcbIy0hGE7EsVw7BneC+TydQ5cOcNamvOyTBbUELvPc6ZlH
         MdlDW7tEKyyK1GK4msKE7/oVAL551mP7IUokxaBtNJ7bgwXMP00AR/0eFiPoqaW6WnU7
         Zrn4nA6MQeeRwa64Bub/Z0w93EC8Zq3Az1mQzK6xLhj1V66t22dVv1Q//103zPTSrvdc
         O56IkuMoVSOAECFd3G1aFLaZ3TS7gTLvajtzeAzqD49Kp4hu+2w8u24JnOW2x3atoXlY
         /Msw==
X-Gm-Message-State: ANhLgQ3kwgQxNZtiSYib8tdG5H/0urE/HUhIRcRekq6GzCNlzinCYeqT
        zk61iqhAvMGmPamAY6EaA8M6xg==
X-Google-Smtp-Source: ADFU+vvSFbuSg/ZfRlESkgsCOFoCSgmG5iPCyQlDq0W9IFjOrCmIyWHQSdbKHKIkdWBjoEo1wl9mPA==
X-Received: by 2002:a63:790e:: with SMTP id u14mr1340697pgc.361.1584389187593;
        Mon, 16 Mar 2020 13:06:27 -0700 (PDT)
Received: from [192.168.1.11] (97-126-123-70.tukw.qwest.net. [97.126.123.70])
        by smtp.gmail.com with ESMTPSA id a71sm687824pfa.162.2020.03.16.13.06.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 13:06:26 -0700 (PDT)
Subject: Re: [PATCH v3 17/19] hw/arm: Automatically select the 'virt' machine
 on KVM
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-18-philmd@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <d0842e82-8640-5903-e59b-99963584b89a@linaro.org>
Date:   Mon, 16 Mar 2020 13:06:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200316160634.3386-18-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/20 9:06 AM, Philippe Mathieu-Daudé wrote:
> When building a KVM-only QEMU, the 'virt' machine is a good
> default :)
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  hw/arm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
> index d0903d8544..8e801cd15f 100644
> --- a/hw/arm/Kconfig
> +++ b/hw/arm/Kconfig
> @@ -1,5 +1,6 @@
>  config ARM_VIRT
>      bool
> +    default y if KVM
>      imply PCI_DEVICES
>      imply TEST_DEVICES
>      imply VFIO_AMD_XGBE
> 

Likewise SBSA_REF?  Otherwise, what is this for?
Did you remove ARM_VIRT from default-config/*?


r~
