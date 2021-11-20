Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44CD4580D0
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 23:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236628AbhKTWiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Nov 2021 17:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236209AbhKTWiJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Nov 2021 17:38:09 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D286FC061574
        for <kvm@vger.kernel.org>; Sat, 20 Nov 2021 14:35:05 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id c71-20020a1c9a4a000000b0032cdcc8cbafso10355460wme.3
        for <kvm@vger.kernel.org>; Sat, 20 Nov 2021 14:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZWbr/2vHaYihnisCiK784wK+kh1ViJ+MF6oPCR2LCTc=;
        b=f1mVsmY5OYP/F62iust/NMGTttBM3eP0ZDnjXzXtREruqqsvubz02kgcJZht2wIAci
         Ge2SBn4jJbSG5InjaRWUTZivlDr5d6ATHzBYBCf1s6rGRWxikkjwD/0JM+De7aBUOgt4
         VsK7ICs7nsGPR1nkq7gpnoeeNAVID9YtyVDtzoELBOUwRUCaL/s+wL2McHJskPEuQMqY
         QqVETKz72XcMnkJ2tAjpNqaLx7+5HLfl+PRjK7vcNAp/qnsj4SxpyAs2a8md2/OEgyLO
         j04crzZcZ4aqAUZpRiAki/VNdzb/sU68FPg52fikixaAjb3v43mw2XsOETHo0NKSLryY
         Pi7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZWbr/2vHaYihnisCiK784wK+kh1ViJ+MF6oPCR2LCTc=;
        b=ceEyDElxia8rph/EC5s/gSVlVVRJ1kILdODZ73SWkh/MIsvQPJXwv/kaPM7jywJiyo
         hE+W3rcGXdDQQ5XEfbbGpOTFEqrH1ujB2qdZewaa+2JiUjCHGMlGowU6KuOyTxziVa4m
         Y7DUF39JWeK9HPbQ+6Vz9Iocd366tvSMuAnvRP7i6NF2Tx4bFpW5uCoVkKN/Maf1VsHj
         jXnXU0q6a4XhYh/WikzxQHt1NcTzNsVj0O0Si/CdZX0ZeB2XJHX7ajoXT5KcNxMf4fmL
         1QSBZ2Dnfw0xEh0GH0Usd7+eRw4LWNE2z9EsJL5+VZipjN7gsEdDRZYw5qPIVWAwbIJg
         cmeg==
X-Gm-Message-State: AOAM5305t5MuuFasUfJHzuV+UpxC8DQL/r/MsaygYeyoRC8yIJl1/eha
        JQzveI9FV5ftQ/BcP0qcJOZ/WA==
X-Google-Smtp-Source: ABdhPJwRaQiQ7RXrZpegKeHAzKoEB8Nbx6W7mi/oskytctQ90BSY+lj2elUyY6KHWz6A1a5kzPQh+g==
X-Received: by 2002:a1c:a5c7:: with SMTP id o190mr14686120wme.186.1637447704301;
        Sat, 20 Nov 2021 14:35:04 -0800 (PST)
Received: from [192.168.8.101] (77.red-88-31-131.dynamicip.rima-tde.net. [88.31.131.77])
        by smtp.gmail.com with ESMTPSA id f15sm5165544wmg.30.2021.11.20.14.35.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Nov 2021 14:35:03 -0800 (PST)
Subject: Re: [PATCH v1 12/12] target/riscv: Support virtual time context
 synchronization
To:     Yifei Jiang <jiangyifei@huawei.com>, qemu-devel@nongnu.org,
        qemu-riscv@nongnu.org
Cc:     bin.meng@windriver.com, Mingwang Li <limingwang@huawei.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com, anup.patel@wdc.com,
        wanbo13@huawei.com, Alistair.Francis@wdc.com,
        kvm-riscv@lists.infradead.org, wanghaibin.wang@huawei.com,
        palmer@dabbelt.com, fanliang@huawei.com, wu.wubin@huawei.com
References: <20211120074644.729-1-jiangyifei@huawei.com>
 <20211120074644.729-13-jiangyifei@huawei.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <d9c9196a-692c-cbcf-339b-8e84ecde7cee@linaro.org>
Date:   Sat, 20 Nov 2021 23:34:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211120074644.729-13-jiangyifei@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/21 8:46 AM, Yifei Jiang wrote:
>   const VMStateDescription vmstate_riscv_cpu = {
>       .name = "cpu",
>       .version_id = 3,
>       .minimum_version_id = 3,
> +    .post_load = cpu_post_load,
>       .fields = (VMStateField[]) {
>           VMSTATE_UINTTL_ARRAY(env.gpr, RISCVCPU, 32),
>           VMSTATE_UINT64_ARRAY(env.fpr, RISCVCPU, 32),
> @@ -211,6 +221,10 @@ const VMStateDescription vmstate_riscv_cpu = {
>           VMSTATE_UINT64(env.mtohost, RISCVCPU),
>           VMSTATE_UINT64(env.timecmp, RISCVCPU),
>   
> +        VMSTATE_UINT64(env.kvm_timer_time, RISCVCPU),
> +        VMSTATE_UINT64(env.kvm_timer_compare, RISCVCPU),
> +        VMSTATE_UINT64(env.kvm_timer_state, RISCVCPU),
> +
>           VMSTATE_END_OF_LIST()
>       },

Can't alter VMStateDescription.fields without bumping version.

If this is really kvm-only state, consider placing it into a subsection.  But I worry 
about kvm-only state because ideally we'd be able to migrate between tcg and kvm (if only 
for debugging).


r~
