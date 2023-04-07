Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E714C6DB6EB
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 01:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjDGXLH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 19:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjDGXLG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 19:11:06 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D0E1FE5
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 16:11:03 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id q2so5009907pll.7
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 16:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680909062;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+8sjrQkKmFa0fDEbK0ByEbj8xRVyyoXwt3mONWUrCjg=;
        b=fu0fc9kQ3M2sfVtK3t68zTbYFucNlj5oFSUSteqUYRu6VDv3uTItwTOkzCaPFNHOei
         Df/jKMmHFnnEBVa21r/eZ50XSQaDi0Hdouvc5bo4bnXn3NaTSvMg4uk2qfa5HE0KEHPK
         G/hnmvZSmlnUfmxSrzAzCG2somHL6hF+eFvhEfvqMO4TRTM4MdDjEbP4M3dgQLLmAJUt
         NQ70V3GEiNeBy6LgXX+ZifscCDpUsnjTSs3RYovPOLuMKgkROChad5HQjq9TyjzVOy/W
         ikj4D19qkBrRoB4IJxSKljZsM9kEwp6vq/D91lh+Kurhgan8M73NHLiK5l1wy/jRVm4c
         8CpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680909062;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+8sjrQkKmFa0fDEbK0ByEbj8xRVyyoXwt3mONWUrCjg=;
        b=wzkvBayitjsAIecnjz1a1UWTajxll1dDesOr0n1VrsADnMigu9jKRWcg0qkptwSxCA
         XDbkC2N9QDRObxG8P/GqQ/EER9m3RdwZNe280MUhGvqzYaXz4EZ8KN9YoXVTT+hmIFy8
         QZYJ1+L5Yrl65tzYd5ZxFFRX+s1ovewNT8/B4zgFyAwiyE4Yfl09GmeGkNfLnL6/CpLc
         ostqy6EtIJ52uFCn2nP147yoo3XlcVKGKsByA/HmoiLjdz+YMH1ee7E1ajhczXaprTCX
         3dO1jrrckuX++6CPkdmXWXLkuQL3D+mcggLr3qZK4s7MhdB+ak8YVQSUCqfc47BlNDxs
         dVVQ==
X-Gm-Message-State: AAQBX9d2ZLINXptO1t6m7RaoOAYJXO7/nYBKfQ4Z9V5iZjH+536OD4mx
        jKOxY4kNh8wcBq7QPmd/MwPJmsAhEXlGywB82QE=
X-Google-Smtp-Source: AKy350Z01RjDdvFrn3SDcNSR06u3kONrO463lNJW2mYVi5QEQlyqB2hcRXm9iVwIpLBrSzeEsGCq9A==
X-Received: by 2002:a17:903:3093:b0:1a2:ca:c6cd with SMTP id u19-20020a170903309300b001a200cac6cdmr3648934plc.43.1680909062629;
        Fri, 07 Apr 2023 16:11:02 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id ik23-20020a170902ab1700b001967580f60fsm3360481plb.260.2023.04.07.16.11.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 16:11:02 -0700 (PDT)
Message-ID: <e37bd0f9-b577-dbf4-6d34-a17a9d5cfbaf@linaro.org>
Date:   Fri, 7 Apr 2023 16:11:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 10/14] accel: Rename NVMM struct qemu_vcpu -> struct
 AccelvCPUState
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Reinoud Zandijk <reinoud@netbsd.org>
References: <20230405101811.76663-1-philmd@linaro.org>
 <20230405101811.76663-11-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405101811.76663-11-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/23 03:18, Philippe Mathieu-Daudé wrote:
> -    struct qemu_vcpu *qcpu = get_qemu_vcpu(cpu);
> +    struct AccelvCPUState *qcpu = get_qemu_vcpu(cpu);

With the typedef in hw/core/cpu.h, you can drop the 'struct' at the same time.

Otherwise,
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

> -    qcpu = g_try_malloc0(sizeof(*qcpu));
> +    qcpu = g_try_new0(struct AccelvCPUState, 1);

Another 'try' to clean up.  :-)


r~
