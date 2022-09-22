Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083AC5E6ED9
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 23:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiIVVvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 17:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiIVVvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 17:51:12 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31FD107DD9
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 14:51:10 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id a80so10585672pfa.4
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 14:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date;
        bh=iremm5+GR7vMaxyC6J6p602GyNU3K6bidlSrtGzKDis=;
        b=QhtHQW4CXRoDZSDi35r9Wz5aA0HdmVTrwmVBJ8hsuEq1mZ/Gat8Y+hlIOdNCpGG38s
         ao+gWU2W4jRBvEIg0wxt+OzOpyNe3ux31FI6Q8BfRfXT6vDjS0xkxqqTXLFCfKGPpOPD
         +ALyWiWp7QYweCbdq8F7hCjeBtxHLItG0GTvDcZtBeqaEaasbX8CSOOt48zLBRxkecs+
         PuJy7qg1OJIlTfQC6hHHvV0UsibR1EaG4hEgh6KiOuOrhoQud6d+MyveCwdkFREe57nY
         cz+8Gi7xch/LIX1+6RDaqgUE/ROfhIPxUlNC5TksnjQCGkOpjK6ECgoAJ6py0mBDM5Kg
         3fgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date;
        bh=iremm5+GR7vMaxyC6J6p602GyNU3K6bidlSrtGzKDis=;
        b=x/boyJ3M3N9hKITcxQIDVW/DsP4Nv2cgT150ED4+01JK/WQ78DIopacOyTR+wpdor5
         x0Q7lusOz7ecd+w5EyBeEh1LTabvEOeB+rwQFo1/x+dsZ9Nk7wji+Do4R4twDkdfr1N8
         4Cixfh2io3iIxmM/ST6SAMWEC80JeIq2F9+EnTYuQgZzO1i2MDYyYSlavCXulhrobKNc
         vQnqykH0iYBtbdk18ALD/P1+Zj1BVTGAT6N6vEYF0vDBtGUEmZRoN2v8dighlGzcxG2v
         pltAFPs92PpYgzu1Pjlmi6PzFKX4WkUzlGInAPnFHDp+kxHFWGC4vprEa/ripvrTfIBb
         FQGg==
X-Gm-Message-State: ACrzQf0E5CBs02aJXxhjw6QL6j7dC0vu+ov9I6JHQBOQd5xooCx3+pqq
        T72DgCgx0n2981OnYDDgh5E=
X-Google-Smtp-Source: AMsMyM5XFfEuYs8Nbw6H60koTskGA7B7IXH6EGem1q/oLl3sioGoLJHHbFCy/0Y0HzU9pjnfccHQHg==
X-Received: by 2002:a65:60cd:0:b0:43c:403:9863 with SMTP id r13-20020a6560cd000000b0043c04039863mr4841884pgv.106.1663883470248;
        Thu, 22 Sep 2022 14:51:10 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id b67-20020a621b46000000b0053e22c7f135sm4916512pfb.141.2022.09.22.14.51.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 14:51:09 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Message-ID: <726982bc-3c26-2679-76ec-a51daf6f5b3d@amsat.org>
Date:   Thu, 22 Sep 2022 23:51:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v1 9/9] gdbstub: move guest debug support check to ops
Content-Language: en-US
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-devel@nongnu.org
Cc:     mads@ynddal.dk, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
References: <20220922145832.1934429-1-alex.bennee@linaro.org>
 <20220922145832.1934429-10-alex.bennee@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
In-Reply-To: <20220922145832.1934429-10-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/9/22 16:58, Alex Bennée wrote:
> This removes the final hard coding of kvm_enabled() in gdbstub and
> moves the check to an AccelOps.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Cc: Mads Ynddal <mads@ynddal.dk>
> ---
>   accel/kvm/kvm-cpus.h       | 1 +
>   gdbstub/internals.h        | 1 +
>   include/sysemu/accel-ops.h | 1 +
>   include/sysemu/kvm.h       | 7 -------
>   accel/kvm/kvm-accel-ops.c  | 1 +
>   accel/kvm/kvm-all.c        | 6 ++++++
>   accel/tcg/tcg-accel-ops.c  | 6 ++++++
>   gdbstub/gdbstub.c          | 5 ++---
>   gdbstub/softmmu.c          | 9 +++++++++
>   gdbstub/user.c             | 6 ++++++
>   10 files changed, 33 insertions(+), 10 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
