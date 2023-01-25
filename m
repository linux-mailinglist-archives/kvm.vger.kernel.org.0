Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866AF67BF67
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 22:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjAYV5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 16:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjAYV5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 16:57:52 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D4C303EF
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 13:57:31 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id x2-20020a17090a46c200b002295ca9855aso3521990pjg.2
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 13:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z2vhwDs0FbIEqY+iDhOA3obE1vwwrXQgUVCCUgwo1gY=;
        b=E0MQN0N1mmnXVpE4uf7kU/gwYZWArkmYq+VIImssSdUfHzpbRxiTXmkBRVWUPOYaMV
         hi1lHB5AA8w4affJg/dvVBQcspynoh/ZYvhGNDugls48WaGic3Bi68kyYQ35DdK/ZjSV
         HLUAMgJRQx8nFfHqouuI7dC7uht35pn+01veJZvkXanheZrkPUzzsCvrtR7k7ojRXP9A
         MLXKVRcEv4ZzI5faTshM62DUMedxE6g6qlQInCWUR1LUO5aK7pQmQdpmUU3hkPatZ5be
         jRxW2hAZrKEWks7bpIC0X3EBOAlQkkpvKE0xP5wo487dxha4Jl/rHajXZqPLvpGox/Vx
         jK+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2vhwDs0FbIEqY+iDhOA3obE1vwwrXQgUVCCUgwo1gY=;
        b=D+v9oxc9uscUF8bbIFuJbvihx4duKVlomjI2AkazQmGuvZ7U3yF7bemElmlv8Aeykw
         LM42vUU/MzKxVRjdQGTVsao/WB8WQv2ODEVZ4EqIaw24vZCDRx2fJwziiYcX1GAGToV8
         kFqM776YwUhLNoGhsZp2xbHfFJ7sTJMtyqnFTiy7FIRhA/jYqwlYreBQIjEud4nH6RnU
         I8xigk65wytlHORfR+foqQTBcnvltgeF0SRnXxgFYYWS7sJqZkz3cOrQ+vkwM/H1Q52q
         npMLiQL3GS6UHEmjL//Tc2TIXlagJVV19cdVEM8zTji4+r148bRWwmjXYIsePuyMzyus
         v6yw==
X-Gm-Message-State: AFqh2kqzKX0MSRsQOOg5wGLymw7vXxf12WNpzyRdO8RjpWzWQ5neA9H/
        UpBAhjv4R39bMGI+eNdhm34kRA==
X-Google-Smtp-Source: AMrXdXtM4DMMtUycfvOjJNqyg8XXT3U4FOV+OCwywv9YV0usgBP8yfUVDDapp+CeLGBVHTv220oGYA==
X-Received: by 2002:a05:6a20:9f95:b0:b9:478f:9720 with SMTP id mm21-20020a056a209f9500b000b9478f9720mr26088969pzb.42.1674683851207;
        Wed, 25 Jan 2023 13:57:31 -0800 (PST)
Received: from [192.168.50.116] (c-24-4-73-83.hsd1.ca.comcast.net. [24.4.73.83])
        by smtp.gmail.com with ESMTPSA id w7-20020a628207000000b005815a371177sm4087507pfd.52.2023.01.25.13.57.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jan 2023 13:57:30 -0800 (PST)
Message-ID: <428eb479-5066-f8c6-ad98-4eeac53a5be8@rivosinc.com>
Date:   Wed, 25 Jan 2023 13:57:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH -next v13 04/19] riscv: Clear vector regfile on bootup
Content-Language: en-US
To:     Conor Dooley <conor@kernel.org>, Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Myrtle Shah <gatecat@ds0.me>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-5-andy.chiu@sifive.com> <Y9Gk/FCFBbWC/Pyi@spud>
From:   Vineet Gupta <vineetg@rivosinc.com>
In-Reply-To: <Y9Gk/FCFBbWC/Pyi@spud>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/25/23 13:54, Conor Dooley wrote:
> n Wed, Jan 25, 2023 at 02:20:41PM +0000, Andy Chiu wrote:
>> clear vector registers on boot if kernel supports V.
>>
>> Signed-off-by: Greentime Hu<greentime.hu@sifive.com>
>> Signed-off-by: Vineet Gupta<vineetg@rivosinc.com>
>> [vineetg: broke this out to a seperate patch]
>> Signed-off-by: Andy Chiu<andy.chiu@sifive.com>
> But this patch didn't carry over the long list of contributors from it's
> source? Seems a bit odd, that's all.
> There was also an Rb from Palmer that got dropped too. Was that
> intentional?
> https://lore.kernel.org/linux-riscv/20220921214439.1491510-6-stillson@rivosinc.com/

In v12 this and 5/19 were in one patch, which I broke off into two for 
clarity. Hence the Rb technically doesn't apply.

-Vineet
