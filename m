Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E1A626736
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 06:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbiKLFt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Nov 2022 00:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiKLFt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Nov 2022 00:49:26 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBF024BFD
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 21:49:25 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id f5-20020a17090a4a8500b002131bb59d61so8807210pjh.1
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 21:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z48ZrzrkWelkm7CZgwdxVdBpd3xzXj7MJO/rISEsX9s=;
        b=LQKRZfnyYi3xCI+3GGrSYD8luHWGb5N/mOC9K1DW3n5imBaZAWgtfjlRP7jvSm1y2M
         B1jrDnaalkzkBexP8n/CsDPsDDSnI0dtOYUWT1Qha0oGeJnPy4AsQbwpQWcQQ/4gtPMj
         5YtYkQ9UU+dp3E1/4w16GRZDuzRovWRCkXWdtVE6yu6wkABqJS8wQIrsh24LY6oZB0wn
         Vt4hthdpPxyjZFy1RGGwtHgGmA+w0TCFCx94muAnLfS69MHqflWGe+wlDcq+sSbyJp2/
         Y1c0kG/IUZ+oijwxy0Ylscl7GaahAZF1pQMxKa58tZWcX9JSLz+Qhsk1erH7ujREKVZu
         fhzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z48ZrzrkWelkm7CZgwdxVdBpd3xzXj7MJO/rISEsX9s=;
        b=B/HFcCb/3j2aSBMgKs7ht9H5L+74hILrt3gjYBAtKcZnnHOFAbcgUnR/eI/hYt8ms4
         Hvf31WAwQfYZAsx7K4RyLp3YTf/dO0lAKJ0YRp88ruvGvVbxV5lgiALhkX72VvzRO90w
         xP0JrwvHJWSFyTSFNFjkq88trMjnXY5Pzm2Di1zbMEiJ47YXA0ey+0TvA6VEHI2wl98k
         MPuuHFpZuDKBZOO6NhwUMqbbKKbG1ygkL7bqsMYpngkhnMgRoL1AicqwfUFLqt2vK/Z/
         JDhQEM4ZBd98UocSvpYloB/cjx8bcYThJ8uF6bEJVwO6Tq77dS+CDOtBFjy14qxO2uGd
         4WIw==
X-Gm-Message-State: ANoB5pniz34HRhi7x9ZV+FlU36UngU3/N2Tv5R1NMEgWr0pnxgnXUhOW
        VFXpF6+2hnmICJiRc+3VqY8+mg==
X-Google-Smtp-Source: AA0mqf4+9suJa1M3ta91oRZPYPUeq5oUuS/JQZez6tWBE95lkzDvSEqRdLSnl557ASUtleEGzkqUPQ==
X-Received: by 2002:a17:902:e052:b0:172:f5b1:e73b with SMTP id x18-20020a170902e05200b00172f5b1e73bmr5664989plx.58.1668232164479;
        Fri, 11 Nov 2022 21:49:24 -0800 (PST)
Received: from ?IPV6:2001:44b8:2176:c800:8228:b676:fb42:ee07? (2001-44b8-2176-c800-8228-b676-fb42-ee07.static.ipv6.internode.on.net. [2001:44b8:2176:c800:8228:b676:fb42:ee07])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902f64500b00186da904da0sm2711334plg.154.2022.11.11.21.49.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 21:49:23 -0800 (PST)
Message-ID: <9d64f949-e1fd-1436-fefe-bf3c156d8d6e@linaro.org>
Date:   Sat, 12 Nov 2022 15:49:16 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v5 13/20] target/i386: add explicit initialisation for
 MexTxAttrs
Content-Language: en-US
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-devel@nongnu.org
Cc:     f4bug@amsat.org, Wenchao Wang <wenchao.wang@intel.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        "open list:X86 HAXM CPUs" <haxm-team@intel.com>,
        "open list:X86 KVM CPUs" <kvm@vger.kernel.org>
References: <20221111182535.64844-1-alex.bennee@linaro.org>
 <20221111182535.64844-14-alex.bennee@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20221111182535.64844-14-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/22 04:25, Alex Bennée wrote:
> diff --git a/target/i386/hax/hax-all.c b/target/i386/hax/hax-all.c
> index b185ee8de4..337090e16f 100644
> --- a/target/i386/hax/hax-all.c
> +++ b/target/i386/hax/hax-all.c
> @@ -385,7 +385,7 @@ static int hax_handle_io(CPUArchState *env, uint32_t df, uint16_t port,
>   {
>       uint8_t *ptr;
>       int i;
> -    MemTxAttrs attrs = { 0 };
> +    MemTxAttrs attrs = MEMTXATTRS_UNSPECIFIED;
>   
>       if (!df) {
>           ptr = (uint8_t *) buffer;
> diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
> index b75738ee9c..cb0720a6fa 100644
> --- a/target/i386/nvmm/nvmm-all.c
> +++ b/target/i386/nvmm/nvmm-all.c
> @@ -502,7 +502,7 @@ nvmm_vcpu_post_run(CPUState *cpu, struct nvmm_vcpu_exit *exit)
>   static void
>   nvmm_io_callback(struct nvmm_io *io)
>   {
> -    MemTxAttrs attrs = { 0 };
> +    MemTxAttrs attrs = MEMTXATTRS_UNSPECIFIED;
>       int ret;
>   
>       ret = address_space_rw(&address_space_io, io->port, attrs, io->data,
> diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
> index e738d83e81..42846144dd 100644
> --- a/target/i386/whpx/whpx-all.c
> +++ b/target/i386/whpx/whpx-all.c
> @@ -791,7 +791,7 @@ static HRESULT CALLBACK whpx_emu_ioport_callback(
>       void *ctx,
>       WHV_EMULATOR_IO_ACCESS_INFO *IoAccess)
>   {
> -    MemTxAttrs attrs = { 0 };
> +    MemTxAttrs attrs = MEMTXATTRS_UNSPECIFIED;
>       address_space_rw(&address_space_io, IoAccess->Port, attrs,
>                        &IoAccess->Data, IoAccess->AccessSize,
>                        IoAccess->Direction);

All three of these are hypervisor callouts to handle i/o for the guest, just like kvm.


r~
