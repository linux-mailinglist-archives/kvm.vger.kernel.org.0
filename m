Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0B75E9203
	for <lists+kvm@lfdr.de>; Sun, 25 Sep 2022 12:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbiIYKPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Sep 2022 06:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbiIYKO7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Sep 2022 06:14:59 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658C413D69
        for <kvm@vger.kernel.org>; Sun, 25 Sep 2022 03:14:57 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id m9so2755754qvv.7
        for <kvm@vger.kernel.org>; Sun, 25 Sep 2022 03:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=cPJ9chtXSfKnWh4ALPiDpzOPGsIthH5YhQUg9r+z76I=;
        b=H2CZwLUwV6hEk689vtCaJ9fR/OKPl377GeZDWIeaMlDOLJsA4U4OxnsEgHlhVq3PnE
         HoLGmxwaj+juyYcNVRD0SlAJPqbgJIyg6wgAmjVP67hutcB8AYnyHc0j5bLD1Nz7mcrO
         QJTFtmYKBOMBanghbJxWB/h6FO/WtIiaUeixviuaEmUAMDjaHKiGJrC9QXJs0v2bBY9x
         iduE31kDON5K5iF85Y5GcSLZlprNFUCnlqKRChuGZAUc5vpUq1Kbf11YPlUXeNlvxJd2
         rZ3gdQc6ql2UsW06PGsGax9LV5ZgBq7wt75cYAXEnq6QqUHUx+JsalOEl6IhtjFwth/y
         UP6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=cPJ9chtXSfKnWh4ALPiDpzOPGsIthH5YhQUg9r+z76I=;
        b=FnSMNSE0S/I02hY7kF1J9vdDvi/fUyWv4glkDqKAIxRsjZVeJehfUa/Bd/PknsI6vZ
         QqoF7cIQleuLPocyw/qjsV1A8nyjl/1iP9Xeelzsrr3ZMTOfheSt8MK+fiuHU0ty8akc
         JANSE64MI1utq+Qkv3TYS1cVkWmZfAYdxJLr9aKhZ3A30vFFMbGN7+q2O9cu5wGtsR0x
         ylbWFaqDMyDq4v4OOLM0K8yQf0fDpOXBFHXOB6BHNG9YqZHIjrpzICKbvpGVXTNS0MMN
         J4+ISGkINAvA3bjR7Cjn+yiSE4gYYKNnR8j+lFMZ+xSSW3oAqdWJQEGKbJfU5A0dRRkl
         T1Tg==
X-Gm-Message-State: ACrzQf3mgj+KbsBOg7dCNI6rdZda0NLVtUr6ZWGa6fZM+LqseXyFGzgY
        CKfN/Hc6dMA3hTnJL68H8U1smQ==
X-Google-Smtp-Source: AMsMyM7hfU361uEgLc2dGf9QAP2aLGANHMywu5UA1v939Lso6aOhNZZ86B5R5PQB1Bc+un8GsEaEFw==
X-Received: by 2002:a05:6214:dad:b0:4a0:b90f:ec83 with SMTP id h13-20020a0562140dad00b004a0b90fec83mr13820526qvh.16.1664100896564;
        Sun, 25 Sep 2022 03:14:56 -0700 (PDT)
Received: from ?IPV6:2605:ef80:80b2:413a:430d:cdd2:88af:d4b3? ([2605:ef80:80b2:413a:430d:cdd2:88af:d4b3])
        by smtp.gmail.com with ESMTPSA id y11-20020ac8524b000000b0035ba5af2a75sm8790756qtn.16.2022.09.25.03.14.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Sep 2022 03:14:55 -0700 (PDT)
Message-ID: <9fbf3ee2-07b2-dc51-ebfe-2e57f557687c@linaro.org>
Date:   Sun, 25 Sep 2022 10:14:46 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1 7/9] gdbstub: move sstep flags probing into AccelClass
Content-Language: en-US
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-devel@nongnu.org
Cc:     f4bug@amsat.org, mads@ynddal.dk,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
References: <20220922145832.1934429-1-alex.bennee@linaro.org>
 <20220922145832.1934429-8-alex.bennee@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20220922145832.1934429-8-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/22/22 14:58, Alex Bennée wrote:
> The support of single-stepping is very much dependent on support from
> the accelerator we are using. To avoid special casing in gdbstub move
> the probing out to an AccelClass function so future accelerators can
> put their code there.
> 
> Signed-off-by: Alex Bennée<alex.bennee@linaro.org>
> Cc: Mads Ynddal<mads@ynddal.dk>
> ---
>   include/qemu/accel.h | 12 ++++++++++++
>   include/sysemu/kvm.h |  8 --------
>   accel/accel-common.c | 10 ++++++++++
>   accel/kvm/kvm-all.c  | 14 +++++++++++++-
>   accel/tcg/tcg-all.c  | 17 +++++++++++++++++
>   gdbstub/gdbstub.c    | 22 ++++------------------
>   6 files changed, 56 insertions(+), 27 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
