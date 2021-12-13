Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B08D473054
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 16:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhLMPVy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 10:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235933AbhLMPVv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 10:21:51 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20CDC061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 07:21:50 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id np3so12083003pjb.4
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 07:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AGc1PquQXh0+9331OAt9/t/pIqsDq0eIaBHESSHpnxA=;
        b=HzoQt+uthV6vbcJBqrKhH8j/XHs+GtMpyP7UM24kBENT+NfcMcD8q73DEayMJFAfXW
         T/H0duDe+hRFBkSje431MCOqjpnoeAzMinRBa/7+ZVIIa4YNDlfHT4AuuVcnptlaHPPX
         dj/pZL1t99ystjuI/QFfjp+cSMxA6ptDeiX2+id4PhthCtDq7alneV5MFNn8z3VgwScN
         dEgYKBBD5L40M72WwasSMttpH+1qv3ghydG+CuGiP0596hH956hilMQFSiV6qYyH8Xdk
         2vzSOGEN/TN2gvnlk/Dw+P2/zeG1czRpibulnt88oawnU1fUxdO8ZagCubTCFdoUrq+y
         iqPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AGc1PquQXh0+9331OAt9/t/pIqsDq0eIaBHESSHpnxA=;
        b=Euk5zaDqtG/Pvyds7zwacefUBGtxiFoNX3e3BbDDg4Etg01uJp9qgVl5LHP0GbFPEy
         4x+p92g3gyQjnxiEFJsQRZcz8zo/IjRr1NWZIuAiMOEIHfvYHoj7uTD2zW+8GiLh/5bf
         YNvOxCxjfglDuitgaAy5FLXklUwE+U1xeHVWQTSljaPCgTBHCzsUJnlu07jxUwTkrp1r
         Rf5xjLrMDt0NFFufc/aAnOnAZQU3eIleuo/CmV8G0JH8taflKzjNSR5ORVZXDjLIHM3r
         /O1wTQITT1CbzJfIl1kmdlWNh88pcKQnjgeiHt+iSYpqUrOoTa8wkVE+ryK3U9KcYS6q
         J2rA==
X-Gm-Message-State: AOAM5337+SsCTNnwzhc4GxYe1qe2866OdbpyJXUFqo2m5ZvsTpy5cBL+
        XXUcKPVsG8zS/UOs7gytZm9qFQ==
X-Google-Smtp-Source: ABdhPJxGt30nuzSBLZfqYPjbexcn085QFp2N6BpQabQxMRsjKxAHXZAfch8zfO4BJ3JlY+kcXaTqIg==
X-Received: by 2002:a17:90b:4c8c:: with SMTP id my12mr44483778pjb.157.1639408910304;
        Mon, 13 Dec 2021 07:21:50 -0800 (PST)
Received: from [192.168.1.11] (174-21-75-75.tukw.qwest.net. [174.21.75.75])
        by smtp.gmail.com with ESMTPSA id t191sm5315472pgd.3.2021.12.13.07.21.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 07:21:49 -0800 (PST)
Subject: Re: [PATCH v2 12/12] target/riscv: Support virtual time context
 synchronization
To:     Yifei Jiang <jiangyifei@huawei.com>, qemu-devel@nongnu.org,
        qemu-riscv@nongnu.org
Cc:     kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        libvir-list@redhat.com, anup.patel@wdc.com, palmer@dabbelt.com,
        Alistair.Francis@wdc.com, bin.meng@windriver.com,
        fanliang@huawei.com, wu.wubin@huawei.com,
        wanghaibin.wang@huawei.com, wanbo13@huawei.com,
        Mingwang Li <limingwang@huawei.com>
References: <20211210100732.1080-1-jiangyifei@huawei.com>
 <20211210100732.1080-13-jiangyifei@huawei.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <10d2d911-e975-64b3-8ab6-e950c5064b9e@linaro.org>
Date:   Mon, 13 Dec 2021 07:21:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211210100732.1080-13-jiangyifei@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/21 2:07 AM, Yifei Jiang via wrote:
> +static bool kvmtimer_needed(void *opaque)
> +{
> +    return kvm_enabled();
> +}
> +
> +
> +static const VMStateDescription vmstate_kvmtimer = {
> +    .name = "cpu/kvmtimer",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .needed = kvmtimer_needed,
> +    .fields = (VMStateField[]) {
> +        VMSTATE_UINT64(env.kvm_timer_time, RISCVCPU),
> +        VMSTATE_UINT64(env.kvm_timer_compare, RISCVCPU),
> +        VMSTATE_UINT64(env.kvm_timer_state, RISCVCPU),
> +
> +        VMSTATE_END_OF_LIST()
> +    }
> +};
> +
> +static int cpu_post_load(void *opaque, int version_id)
> +{
> +    RISCVCPU *cpu = opaque;
> +    CPURISCVState *env = &cpu->env;
> +
> +    if (kvm_enabled()) {
> +        env->kvm_timer_dirty = true;
> +    }
> +    return 0;
> +}

This post-load belongs on the vmstate_kvmtimer struct, so that you need not re-check 
kvm_enabled().

>   const VMStateDescription vmstate_riscv_cpu = {
>       .name = "cpu",
> -    .version_id = 3,
> -    .minimum_version_id = 3,
> +    .version_id = 4,
> +    .minimum_version_id = 4,
> +    .post_load = cpu_post_load,

No need for version change.


r~
