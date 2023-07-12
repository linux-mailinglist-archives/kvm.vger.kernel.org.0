Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D755750FD0
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 19:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjGLRkH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 13:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbjGLRjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 13:39:55 -0400
X-Greylist: delayed 450 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 Jul 2023 10:39:51 PDT
Received: from smtp.smtpout.orange.fr (smtp-16.smtpout.orange.fr [80.12.242.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA7621FD6
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 10:39:51 -0700 (PDT)
Received: from [192.168.1.18] ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id JdhIqzHAhwgkxJdhIqnn4N; Wed, 12 Jul 2023 19:32:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
        s=t20230301; t=1689183139;
        bh=nj3VwYwdD9E/FLl0FSv5Oeoycz38oa7+CVNBRYtk6gU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=sIzK5kFXCameantP8myCFIMUhAIs/kwm/GR8eKV5928Vt0RObj7xF/amNA1itdYK7
         dEyyK0DKI47Hp8FEx7tXsngViYyReKRKDsVAavP49/crWjQH+mqZBQGdeAFMsRuWvn
         VX0aMBo16mXA7g16tUlBvhQ5dPgbFK6SytFWdfMgA9bolS+nivWCs5Laq4kBkDpGGf
         JJi5eF9DbEZizZCB8xaslWsRS0/UdNSNzptUXhx0RVTFw2ojxBd6nL9qSJ5oI/oeCc
         jy36eyHMSJXxC6znJNfGmOUouWa3E7qd+jlSCAW+4Dsz1AcjSga8JyEUGDrLtzAmf9
         cEeH9y50i5qTQ==
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 12 Jul 2023 19:32:19 +0200
X-ME-IP: 86.243.2.178
Message-ID: <036435eb-40c2-548a-1cfd-93a364f95634@wanadoo.fr>
Date:   Wed, 12 Jul 2023 19:32:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] KVM: x86: Fix errors in vmcs12.c
To:     shijie001@208suo.com, tglx@linutronix.de, mingo@redhat.com
Cc:     Hpa <hpa@zytor.com>, Kvm <kvm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
References: <tencent_833CA5C82FF883DD2261815EDE19C9858D0A@qq.com>
 <eec40752bc900473f65ad8f94d160106@208suo.com>
Content-Language: fr, en-US
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <eec40752bc900473f65ad8f94d160106@208suo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Le 12/07/2023 à 10:40, shijie001@208suo.com a écrit :
> The following checkpatch errors are removed:
> ERROR: space prohibited before open square bracket '['
> ERROR: Macros with complex values should be enclosed in parentheses
> 
> Signed-off-by: Jie Shi <shijie001@208suo.com>
> ---
>   arch/x86/kvm/vmx/vmcs12.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
> index 106a72c923ca..da239ca58f90 100644
> --- a/arch/x86/kvm/vmx/vmcs12.c
> +++ b/arch/x86/kvm/vmx/vmcs12.c
> @@ -4,10 +4,10 @@
>   #include "vmcs12.h"
> 
>   #define VMCS12_OFFSET(x) offsetof(struct vmcs12, x)
> -#define FIELD(number, name)    [ROL16(number, 6)] = VMCS12_OFFSET(name)
> +#define FIELD(number, name)[ROL16(number, 6)] = VMCS12_OFFSET(name)

Hi,

Written this way, this is really counter-intuitive.
I think that the checkpatch warning should be ignored in this case.

>   #define FIELD64(number, name)                        \
>       FIELD(number, name),                        \
> -    [ROL16(number##_HIGH, 6)] = VMCS12_OFFSET(name) + sizeof(u32)
> +    [ROL16(number##_HIGH, 6)] = (VMCS12_OFFSET(name) + sizeof(u32))

This does not silence the checkpatch warning.
I think that the checkpatch warning should also be ignored in this case.

> 
>   const unsigned short vmcs12_field_offsets[] = {
>       FIELD(VIRTUAL_PROCESSOR_ID, virtual_processor_id),
> 

checkpatch output should always be taken with a grain of salt.
It just runs some heuristics on what looks improvable, but it is not THE 
law.

It is just a tool that can help in many cases, but not all.

Here, I think that the code is better as-is.


CJ
