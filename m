Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73DA368197B
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 19:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238151AbjA3Sj0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 13:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238149AbjA3SjH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 13:39:07 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1514708A
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 10:38:26 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id b10so11935154pjo.1
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 10:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xohq9EbIgnc/tnqstvxCmfauz3n996rqPi/cWgUMr6Q=;
        b=LXSBMegShi0AqqFqiTiUbP486qAalHpzG9jEwHOpWkywKB5M/JiK3nIvk2xq3F1CVR
         kZVlfXrQ6xdddsDSbPVNH5XO7bls0jat7fFvi2rhSXS5LUKQvfwqjrmUyijF1jf8VfMw
         ChhomwkuEiTOGzPRARg2Wuh/spIgxBClvx7LpbIE1Z62mTU9+VjAfbnWt10lXXdMeTaI
         IL23w74uELZATYSRl4wXG52IccPfI9kEiqwV7GvLNJZa85MueTXBCi8Qqw40JbILhu0z
         3wn5TMZ6WB4px2k3n/SC5rLVGke1IQ/jb+TgW6FW8EPz3oz1FAHVCDbb0sbQCrlE+vfl
         3E9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xohq9EbIgnc/tnqstvxCmfauz3n996rqPi/cWgUMr6Q=;
        b=LPGdmIrYSx/e0VAOWy5J7JZDV8mKPkwTSIEKRbvng7aHfKnHohPhOIk0gSF2q6ipSH
         qfpWyYFLqfM0vgPS7TX7XDC9/xCkHWpuvzS2YYPxlv732QgueXG4oz5ToYxpmx0vamO0
         XjohHGkBAQwz5WxGU0rWivibmXjMwF4I21vo4Z+ucQmTWjxtetwK/fjN3c/FR5b2VVci
         7i7uXH7GAU17bZuCX0SY4FbBVMaVNtA+7eJkPzyWBpxkGyM3SA85Eo4kZfYf0MW5pXul
         /fP/gSez8OdpXXRDasUYYPNxPsZETmukNA0r0peRycM6tFXSN5N3Lb23BPsyiGffspUu
         R3Fw==
X-Gm-Message-State: AO0yUKXk9hloU8VYmphdl5nULo441xef55BuCqQQ1MPZxhzVkDbtt5dw
        txf4Of49aS+/2LY5z7vaSpstJQ==
X-Google-Smtp-Source: AK7set//AqkY7CCOSrgU+8ZYT1p/+L+gcQCLHh8Fcv3EKveF23rBrl7NO/JgNrZgRZcZYyGySuLKmQ==
X-Received: by 2002:a17:902:d491:b0:196:2e10:ba5c with SMTP id c17-20020a170902d49100b001962e10ba5cmr11701106plg.49.1675103906085;
        Mon, 30 Jan 2023 10:38:26 -0800 (PST)
Received: from [192.168.50.116] (c-24-4-73-83.hsd1.ca.comcast.net. [24.4.73.83])
        by smtp.gmail.com with ESMTPSA id z1-20020a1709028f8100b001888cadf8f6sm8144091plo.49.2023.01.30.10.38.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 10:38:25 -0800 (PST)
Message-ID: <c5470393-af09-e86b-b388-d6b830451e8f@rivosinc.com>
Date:   Mon, 30 Jan 2023 10:38:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH -next v13 19/19] riscv: Enable Vector code to be built
To:     Andy Chiu <andy.chiu@sifive.com>, Conor Dooley <conor@kernel.org>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-20-andy.chiu@sifive.com> <Y9GZbVrZxEZAraVu@spud>
 <CABgGipWndcnUxUvWtyxyETtLaJT42VaZoiat7uDmnOjREEt9tg@mail.gmail.com>
Content-Language: en-US
From:   Vineet Gupta <vineetg@rivosinc.com>
In-Reply-To: <CABgGipWndcnUxUvWtyxyETtLaJT42VaZoiat7uDmnOjREEt9tg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/29/23 22:38, Andy Chiu wrote:
>>> +     default n
>> I forget, but is the reason for this being default n, when the others
>> are default y a conscious choice?
> Yes, I think it could be y if V is allocated in the first-use trap, as
> far as I'm concerned. Hey Vineet, do you have any comments about that?

Yes I think this can be enabled by default now that everything is 
allocated on demand.
FWIW thread_struct would have 5 word overhead due to struct 
__riscv_v_state but nothing I would worry about too much.

-Vineet
