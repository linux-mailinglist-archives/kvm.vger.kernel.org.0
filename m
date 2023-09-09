Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F70799C0B
	for <lists+kvm@lfdr.de>; Sun, 10 Sep 2023 01:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345303AbjIIXbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Sep 2023 19:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbjIIXbn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Sep 2023 19:31:43 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EAE1AC
        for <kvm@vger.kernel.org>; Sat,  9 Sep 2023 16:31:39 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id 46e09a7af769-6b9e478e122so2301492a34.1
        for <kvm@vger.kernel.org>; Sat, 09 Sep 2023 16:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694302298; x=1694907098; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bwgrzhzStxt1tRAlOrpewVz1odsaEa2xY4qIDGr9x8c=;
        b=y+aA+G3iVbMwTxFe6j+0t2HO4hMu1MKFJtBs5ArmirXbPKRfDh5Q3vtZeJOukUSsVl
         7YgioU0YXc69Bs3N9h0APepWMxPTSXS+vXwobWoidD62BDtUvHyECzGhlXEYF6YQzaCw
         A/1cWr+62qlZySY2dFFEgicv9lAl9ah/40yD/VPy8Vaqm9SDJdWMLnfMiuZChs8jzynQ
         WfYsp2QlacQGm6DD2R8pbKLADLm6AWPVpduU77sRn4iS+vJf5Q0DzWFYZBqb7gJrpu8t
         dZW+QNgAoWxgoDTYFHneQrwuD7Zh9M3pSKxat3TwaCIoR87OO0E+Rc2H4RfQ9ZKDD8xe
         8AWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694302298; x=1694907098;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bwgrzhzStxt1tRAlOrpewVz1odsaEa2xY4qIDGr9x8c=;
        b=fqiPnUkZa2lkVXWJ2jwUhLEMzkeWt3OXxsLkzUfIrEi9cmFbVgv7fTQbjyiL3LOHfr
         UeMyYdSTqKYNO0VtmWLy0YQ9rLnsVKSaNhCJ/5iO+TMbz0C+BaXoxfJQmUTQtylKlL/S
         l8MASI7SBuL80AEl33Qe8BixY3OUyhhx2gMKaYOGC7HdabIviEL6xAI098sfcovP4Imd
         FFS0qHfShrT+8/nLR2XXwsEXpDBly09uqrUnYObwZEGvQwJSSXf1al0jxU+LXxF44sWU
         n6Oxph2WmPDPvdjBhZPw89WAl973LzzMjI/3opPQpqxrIa+GgG/YKPVKK3ErIdmz4q+g
         KNCQ==
X-Gm-Message-State: AOJu0YywuI1jpWgVBdvnknx4IqmuGqOa9EPsTzW2P6E6N1rxACJ5aNxD
        1EVjF+eXPbHQK843o3O+m35IFw==
X-Google-Smtp-Source: AGHT+IFj9+H2m6xx6ih/UkJynIxDwWufzRc2p4Gk10whdJxNlD4Ts9kGcSxFBgqfJyazq0xPelV7bA==
X-Received: by 2002:a05:6830:1dad:b0:6bf:178f:aade with SMTP id z13-20020a0568301dad00b006bf178faademr6776820oti.11.1694302298423;
        Sat, 09 Sep 2023 16:31:38 -0700 (PDT)
Received: from [192.168.0.4] ([71.212.131.115])
        by smtp.gmail.com with ESMTPSA id k12-20020aa7820c000000b00687ce7c6540sm3252795pfi.99.2023.09.09.16.31.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Sep 2023 16:31:38 -0700 (PDT)
Message-ID: <2c1a73c4-176c-8324-d3c0-9b02eaeef17f@linaro.org>
Date:   Sat, 9 Sep 2023 16:31:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 03/13] hw/i386/fw_cfg: Include missing 'cpu.h' header
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>
References: <20230904124325.79040-1-philmd@linaro.org>
 <20230904124325.79040-4-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230904124325.79040-4-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/4/23 05:43, Philippe Mathieu-Daudé wrote:
> fw_cfg_build_feature_control() uses CPUID_EXT_VMX which is
> defined in "target/i386/cpu.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   hw/i386/fw_cfg.c | 1 +
>   1 file changed, 1 insertion(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
