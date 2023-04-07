Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD106DB6D4
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 01:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjDGXHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 19:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjDGXHW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 19:07:22 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F596E072
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 16:07:16 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id q2so5004834pll.7
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 16:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680908836;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JAx0qx3C6KbkeA3/DQYQ7BheR/mOc8zbOwn50MI/ySU=;
        b=mbYbKfx8mUmFoekiQdkNphSpXLmmbqH8glL3AwV4W3HVWtDJAciucY0lPbRfBpEDFq
         gLlOvNgZ1aLfgvbPXG+Qx/8/igjS3HTbQe0TOOhogHHLu6CsdelnF0yAQM3P4NvkeUlZ
         /xxR7Zdqi7rV2zCgA4fHc1MzHVBEyEVNb2vgXSmk+/mwYBQWFUuxDl3NGR/k474i1eEt
         GapH/ZtfQMmDXQlxBXlVSl3mvt6+PQYPigGuP+NMhSb2Yk4I8i4WH+/5bJi5N0/JyBg7
         qvyMaJ5KjlSKrhsg0GppELpMFE4U4M6ddit4DbdCD0iuZxi2OYxIn/vTltNF+s2Tq4mQ
         uM6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680908836;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JAx0qx3C6KbkeA3/DQYQ7BheR/mOc8zbOwn50MI/ySU=;
        b=kL8GLPhyZhzXtnqdENlu8E87zk9goJkwmP2vMf68vrlCl193to+60YpSWAiCORyIUu
         vaXmd0UHXa+zQwAJN0cIEYSOZP5oC4MbhYmD/uZK6R6674cEVior4fysnu4tdz6lyiGT
         2Ip7NqTjmd0uZQ0BeGyhERsZwNLACi8zo5qq7tCeud3kOT4Neyd8aADWqeYomUBBV8Dt
         cvEd6dPSvHlmuT2cQmwjMGQWVQzLRFsCFb6ZcpKVi/XnzDI3Sfo3EcK3JNurCb13ZXyt
         UQNYDGeHoSkXOxDZCmnVzgrLDD9GUxI5hbAGOq1iASV+KGdKG9xeLC1Xcizqk90rsT69
         wxUw==
X-Gm-Message-State: AAQBX9fLmFbBCr6rCQmy2FWzsYWXZjLeuMHYinSHBfM7E5MAs6OzQ8D+
        1J6qxDiqqCdW4tl1e6YRJW8YLw==
X-Google-Smtp-Source: AKy350ZaLWvNZM1+jRdEw1wsK7EItizE9LE7fAUvdw6zSKnESjRPfP7KFdel4FWtCgR78LROUj0RRA==
X-Received: by 2002:a05:6a20:ca4e:b0:d7:34a1:85b9 with SMTP id hg14-20020a056a20ca4e00b000d734a185b9mr108846pzb.7.1680908836058;
        Fri, 07 Apr 2023 16:07:16 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id w8-20020a63c108000000b005141e2c733dsm3117978pgf.11.2023.04.07.16.07.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 16:07:15 -0700 (PDT)
Message-ID: <7f1385f0-b0bc-090a-4437-434cb72a7cc6@linaro.org>
Date:   Fri, 7 Apr 2023 16:07:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 07/14] accel: Rename struct hax_vcpu_state -> struct
 AccelvCPUState
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>
References: <20230405101811.76663-1-philmd@linaro.org>
 <20230405101811.76663-8-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405101811.76663-8-philmd@linaro.org>
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
> We want all accelerators to share the same opaque pointer in
> CPUState. Start with the HAX context, renaming its forward
> declarated structure 'hax_vcpu_state' as 'AccelvCPUState'.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   include/hw/core/cpu.h       | 7 +++----
>   target/i386/hax/hax-i386.h  | 3 ++-
>   target/i386/nvmm/nvmm-all.c | 2 +-
>   target/i386/whpx/whpx-all.c | 2 +-
>   4 files changed, 7 insertions(+), 7 deletions(-)

Can this be squashed with previous?  It seems odd to change the name twice in a row.
Is the "v" in AccelvCPUState helpful?

> +    struct AccelvCPUState *accel;
>      /* shared by kvm, hax and hvf */
>      bool vcpu_dirty;

Move below the comment?  Or is that later?


r~
