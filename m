Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913605E9205
	for <lists+kvm@lfdr.de>; Sun, 25 Sep 2022 12:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbiIYKSw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Sep 2022 06:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiIYKSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Sep 2022 06:18:50 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CB432B96
        for <kvm@vger.kernel.org>; Sun, 25 Sep 2022 03:18:48 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id u28so2635420qku.2
        for <kvm@vger.kernel.org>; Sun, 25 Sep 2022 03:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=8lacXhpDy2SA6NaDs9PUyJ/7mVkTZQOmvIVZj4dGSts=;
        b=x1L3vuJgnSYemfmDmp/qbt7/7c05XFUH09CUQTqCBhjQZTdvZiFLl22IMOj1hq4gjv
         9wlpW2FL3GM0PivCUzcH3uLRjRDAL372boAiYCfy6V/bE3iyzcpOJo3cScYtGwVkJY6e
         gdUOYoSH0zohozCwBHUJDy7Zw8SY7CKpvqI2UU1q09n7CEJQB/7GSPkyshLo2VCfISTl
         qfZ+T4lepvX+x03gS8IdqS3CB2GVV7Hyf3HncaA6cKSz9Bf1a7pLSSdJPR1EiyBgIn9g
         DVBnWLcmHb7jb0PLQeG/ix97Or/EzK87jMTp8AaDpF1J3Mt62c/DKHDawqvWi+H7fMOp
         /+cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=8lacXhpDy2SA6NaDs9PUyJ/7mVkTZQOmvIVZj4dGSts=;
        b=5g/moC3OzRAaaIBNjrlO128rw3T4rtK+sFZZM8/6FfhqSjk8HW3/nKLdEk4XYROD0H
         T6UAWFwf4Ofvj+jn37zh1ThVRBZGBvJGVe6JY2XaUMTXTP0ht6VJ0Sr+PFk8dAF1bqw9
         6kMLYbP0xZdwS9BZBW0gco/VCFxErk4yTygLJtSlICAL8Adf/w9rNfWhDvERGxohaM8E
         WRmRVeNS/CqvO4Gw0DcRfvxx6bFex6OyHzgMCSGbZFjB3bQE0ag9lh7Q39T1kGXpdP1l
         2r4/LMD+/vP78RiQSaxQYQQk6Zt9W0mxD4VdzmbcBZkar2oiQ3Ui8G1ovoT9Hrmj+Iux
         0c0g==
X-Gm-Message-State: ACrzQf08ZZQRmBhZCelbAsl64siEIBETxQSpt2q/gwSEWUXgeF0nx68c
        OFJ/V63pQLm3xiJCs3VW73OieQ==
X-Google-Smtp-Source: AMsMyM75jZIeOfaxLw4TJzv2WBXhoA3ivr9Na52KxGf8I4oQ4ZFYd1StaXqr1f6MXBh6pKpsvF/DpQ==
X-Received: by 2002:a37:4553:0:b0:6cf:4dbd:b5f6 with SMTP id s80-20020a374553000000b006cf4dbdb5f6mr11112482qka.339.1664101128113;
        Sun, 25 Sep 2022 03:18:48 -0700 (PDT)
Received: from ?IPV6:2605:ef80:80a9:5c0e:1ec2:d482:4986:8538? ([2605:ef80:80a9:5c0e:1ec2:d482:4986:8538])
        by smtp.gmail.com with ESMTPSA id w17-20020ac87e91000000b0035a6d0f7298sm9466373qtj.35.2022.09.25.03.18.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Sep 2022 03:18:47 -0700 (PDT)
Message-ID: <b4066f96-8cf1-e301-5167-f256d4a3a35e@linaro.org>
Date:   Sun, 25 Sep 2022 10:18:36 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1 8/9] gdbstub: move breakpoint logic to accel ops
Content-Language: en-US
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-devel@nongnu.org
Cc:     f4bug@amsat.org, mads@ynddal.dk,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
References: <20220922145832.1934429-1-alex.bennee@linaro.org>
 <20220922145832.1934429-9-alex.bennee@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20220922145832.1934429-9-alex.bennee@linaro.org>
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
> As HW virtualization requires specific support to handle breakpoints
> lets push out special casing out of the core gdbstub code and into
> AccelOpsClass. This will make it easier to add other accelerator
> support and reduces some of the stub shenanigans.
> 
> Signed-off-by: Alex Bennée<alex.bennee@linaro.org>
> Cc: Mads Ynddal<mads@ynddal.dk>
> ---
>   accel/kvm/kvm-cpus.h       |   3 +
>   gdbstub/internals.h        |  16 +++++
>   include/sysemu/accel-ops.h |   6 ++
>   include/sysemu/cpus.h      |   3 +
>   include/sysemu/kvm.h       |   5 --
>   accel/kvm/kvm-accel-ops.c  |   8 +++
>   accel/kvm/kvm-all.c        |  24 +------
>   accel/stubs/kvm-stub.c     |  16 -----
>   accel/tcg/tcg-accel-ops.c  |  92 +++++++++++++++++++++++++++
>   gdbstub/gdbstub.c          | 127 +++----------------------------------
>   gdbstub/softmmu.c          |  42 ++++++++++++
>   gdbstub/user.c             |  62 ++++++++++++++++++
>   softmmu/cpus.c             |   7 ++
>   gdbstub/meson.build        |   8 +++
>   14 files changed, 259 insertions(+), 160 deletions(-)
>   create mode 100644 gdbstub/internals.h
>   create mode 100644 gdbstub/softmmu.c
>   create mode 100644 gdbstub/user.c

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
