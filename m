Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1388173A797
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 19:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbjFVRrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 13:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjFVRrv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 13:47:51 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9751988
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 10:47:50 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-4f866a3d8e4so8395014e87.0
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 10:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687456069; x=1690048069;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CA2JjQ8/OleI6z0qNtxgxu5zyvvw1MZeyIYD2fCQD3I=;
        b=Woxpb7WYR4FvOn5NOxMo42gcotnVmBXbNOaTEK784GMQg+He54w6TFwrLdYPT0bEdn
         9ZKkMM/hG3Mk2TOVQrKcTvXUZu5ZgixwDMwBHwNiAydolumiVmFo2RKYOYR1Dx1A90lt
         Xce7H9QAz1xzbY+ZlchmtggODp6W3O9g4x5uk6/NbI7Vc/iJfcRXuBttmX2lBQSmWNrX
         adAR2Z1B2IFRfGtQiK7ZGG6nBAT7WiP58lyLTxjV/BZ3g4+SEowVSx6RepdoKm7jjbw9
         x2OQNQXlO+iv3T303ZMBmKGi/QaLOYNaHfOC3vRTynsIoXC2E9njPdaJcZ4CY+ZvB1Se
         s8KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687456069; x=1690048069;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CA2JjQ8/OleI6z0qNtxgxu5zyvvw1MZeyIYD2fCQD3I=;
        b=Z0m349v2pLkRpOsmdH3Nw88+Bdy2HKGiznO9v9aN9ZzlZrTYGCmNphe2wL6wAHwimo
         UIBxB5WaZlXtPSute0LEkXFTFyJfcJtaV8bcmu+hCu5ZW8jwHi4yTBlZsZxUPAvtznAW
         l/3nzPab68BAEGGsRaWW4p1TuDWnOqzRldQ5s96SnNMxG/tE36J2442TP12tFQc6vdb5
         bbZkAL73mMGx+Uls1/zA+ENSsNiMWO7lV74MNQYf+n9N3eyf5bdsWDDXueXsIdSZEp4+
         LikPrHy/vHj01HyvrCOJ6bvVf+7lhXp/O697AcNFK2RsjwCLMJ8QiwOGUQDg0aUV/YUc
         v4OQ==
X-Gm-Message-State: AC+VfDz4tNTiu5DZL3R6zft92mBA4JkeuGsqBKYO5/kB1NSSHjDr/LmT
        kjQym3Csm3VTgkYzXgXaDeUQHQ==
X-Google-Smtp-Source: ACHHUZ70krz16gmVF54iWhD+K94iRIEs8ZK4yutx0YkjOW53miT7yXbm7wIhwHFKhqthG2rHfxqvaA==
X-Received: by 2002:a05:6512:3ba7:b0:4f9:6221:8fb7 with SMTP id g39-20020a0565123ba700b004f962218fb7mr2907515lfv.11.1687456068808;
        Thu, 22 Jun 2023 10:47:48 -0700 (PDT)
Received: from [192.168.157.227] ([91.223.100.47])
        by smtp.gmail.com with ESMTPSA id x24-20020ac25dd8000000b004f84b36a24fsm1179173lfq.51.2023.06.22.10.47.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jun 2023 10:47:48 -0700 (PDT)
Message-ID: <32335eb2-a766-dc4e-afd0-09ce62cf7fb2@linaro.org>
Date:   Thu, 22 Jun 2023 19:47:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 09/16] accel: Remove NVMM unreachable error path
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Reinoud Zandijk <reinoud@netbsd.org>, qemu-arm@nongnu.org,
        kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Roman Bolshakov <rbolshakov@ddn.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Alexander Graf <agraf@csgraf.de>,
        xen-devel@lists.xenproject.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>
References: <20230622160823.71851-1-philmd@linaro.org>
 <20230622160823.71851-10-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230622160823.71851-10-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/23 18:08, Philippe Mathieu-Daudé wrote:
> g_malloc0() can not fail. Remove the unreachable error path.
> 
> https://developer-old.gnome.org/glib/stable/glib-Memory-Allocation.html#glib-Memory-Allocation.description
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/i386/nvmm/nvmm-all.c | 4 ----
>   1 file changed, 4 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
