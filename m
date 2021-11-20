Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F244F4580C8
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 23:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236209AbhKTWWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Nov 2021 17:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234536AbhKTWWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Nov 2021 17:22:18 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88860C061574
        for <kvm@vger.kernel.org>; Sat, 20 Nov 2021 14:19:14 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id s13so24935689wrb.3
        for <kvm@vger.kernel.org>; Sat, 20 Nov 2021 14:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uXpyrC3qcidqF3BCl1Do1azpcuOZyCIiAoL+Rqxq15I=;
        b=EyFzoMUjIWnA2XtGyopqjuBUaABAbS8r9QmfS9lYoykxav7lR36SlBYVWHfGMVh+GZ
         qFE9rcyxmRgzC+5bgNAoF3B8W39p22GXumdz1GiSyl2hq2CzKr9KoCuZktBmICnYd3xu
         Wqm6SnK7/De9fBTpE4YtUl3myIeQD+OeLS1phSLMOmVThPPV+4hUOGJTUM+7EAnXnZut
         Hg86IXxGUQMNrSixBsQBPOuXy2jvrf20Zl76iyJGQMkncUDZI8bHrUm0TiqSSmOIM+LX
         cezZDw92VYbf0UuTme357HoyazA/F5iI75qch/XDwcRsqSEF7toMsDcuzOF7ow2bC2K0
         8cjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uXpyrC3qcidqF3BCl1Do1azpcuOZyCIiAoL+Rqxq15I=;
        b=VHIbYLb7JvNiltSoohg5IRbByLdcKZWNW8Qx30eFWXf4+uLTRvDoNo1jOFPk6pxI8h
         QGGtxHim2jh28R9ofOMQJf7oa2LXEa0V21PR9EC+vSaP3E+ZHdg5MCO4zAYlZarJij3m
         o/L8tKfhhn2z76q3RM/S3is+8VmmtcpULbdQqFbPkUSxOk9IZNXN2bNqXGqbSBuSjyk5
         Rp61RyRBpXSS81RTAbf4PTPltm7THxQhqZzdZ8ZhKZW9zlU7IAnlG/K5qCXb2/LxZtZX
         dlTLr7roZq5hgogzCW6qCkH43nstdv740XeFIEl2fe+NV+r0fvqYguKsJbcjH4dV6b/S
         7msw==
X-Gm-Message-State: AOAM532Q9n/DpuigBUOyr69yf3TcyB5EBmmwiDur2RfDOYcdzuTuBued
        cHsjnbI5d5FikrEGVEoYLixrGQ==
X-Google-Smtp-Source: ABdhPJwt3VRvGHP0CCY2rFKpcz53xmoIFof/nEioGKwB8HlHCSQrP1T1ej681ezuKRf/sSUj8+l5/g==
X-Received: by 2002:adf:e482:: with SMTP id i2mr21442964wrm.284.1637446752957;
        Sat, 20 Nov 2021 14:19:12 -0800 (PST)
Received: from [192.168.8.101] (77.red-88-31-131.dynamicip.rima-tde.net. [88.31.131.77])
        by smtp.gmail.com with ESMTPSA id b197sm4012974wmb.24.2021.11.20.14.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Nov 2021 14:19:12 -0800 (PST)
Subject: Re: [PATCH v1 03/12] target/riscv: Implement function
 kvm_arch_init_vcpu
To:     Yifei Jiang <jiangyifei@huawei.com>, qemu-devel@nongnu.org,
        qemu-riscv@nongnu.org
Cc:     bin.meng@windriver.com, Mingwang Li <limingwang@huawei.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com, anup.patel@wdc.com,
        wanbo13@huawei.com, Alistair Francis <alistair.francis@wdc.com>,
        kvm-riscv@lists.infradead.org, wanghaibin.wang@huawei.com,
        palmer@dabbelt.com, fanliang@huawei.com, wu.wubin@huawei.com
References: <20211120074644.729-1-jiangyifei@huawei.com>
 <20211120074644.729-4-jiangyifei@huawei.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <d3f974e1-6278-8c11-898a-a1cc55965786@linaro.org>
Date:   Sat, 20 Nov 2021 23:19:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211120074644.729-4-jiangyifei@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/21 8:46 AM, Yifei Jiang wrote:
> +    id = kvm_riscv_reg_id(env, KVM_REG_RISCV_CONFIG, KVM_REG_RISCV_CONFIG_REG(isa));
> +    ret = kvm_get_one_reg(cs, id, &isa);
> +    if (ret) {
> +        return ret;
> +    }
> +    env->misa_mxl |= isa;

This doesn't look right.
I'm sure you meant

     env->misa_ext = isa;


r~
