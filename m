Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3075261FB68
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 18:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbiKGRbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 12:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiKGRbR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 12:31:17 -0500
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE1B20BE0;
        Mon,  7 Nov 2022 09:31:16 -0800 (PST)
Received: from [IPV6:2601:646:8600:40c0:425:cd56:6750:e1bf] ([IPv6:2601:646:8600:40c0:425:cd56:6750:e1bf])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 2A7HUiHJ1044882
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 7 Nov 2022 09:30:44 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 2A7HUiHJ1044882
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2022110601; t=1667842245;
        bh=yldvO65QURVLOQ7Eu8yQmh08iZtI+puhXJFbyAVBGns=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Ts+8JfFS9U5gE76qXBy36Fxnu/t51z0u9ib2f3FnRwGnriurXpu3uIAsq2f3HsfW9
         L1avUXX9FJncq4LvkA5QMJ9kzdYGUFMZRA/94UKJsDHyF/OMLc5BGUwotO4PIqHMLL
         2gmbXUpqw5KorSHZKZ2KzyWHXJQ+8PGv1dln1tVgpHpyFIUCaJM5V6wfLehQGL1mgG
         7mr3Bv6f1gxUNyXxiAxAllXj+JmESR361dhNASGeEaVssTONBjpGw7HgIissdsHljl
         oT3iG1XqwRygw5Cm89KAKsgFZLoU7PFHOFdymVY6ZAIWRsGJxA+7ohMFD4YZAKQK1f
         Bke17H4vFNPBw==
Message-ID: <b151d65b-7b67-002c-49f2-b7334c201130@zytor.com>
Date:   Mon, 7 Nov 2022 09:30:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH linux-next] KVM: x86: Replace IS_ERR() with IS_ERR_VALUE()
Content-Language: en-US
To:     yexingchen116@gmail.com, seanjc@google.com
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ye xingchen <ye.xingchen@zte.com.cn>
References: <20221020113943.400103-1-ye.xingchen@zte.com.cn>
From:   "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20221020113943.400103-1-ye.xingchen@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RDNS_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/20/22 04:39, yexingchen116@gmail.com wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> Avoid type casts that are needed for IS_ERR() and use
> IS_ERR_VALUE() instead.
> 
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
> ---
>   arch/x86/kvm/x86.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4bd5f8a751de..1c260f716c3b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12414,7 +12414,7 @@ void __user * __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
>   		 */
>   		hva = vm_mmap(NULL, 0, size, PROT_READ | PROT_WRITE,
>   			      MAP_SHARED | MAP_ANONYMOUS, 0);
> -		if (IS_ERR((void *)hva))
> +		if (IS_ERR_VALUE(hva))
>   			return (void __user *)hva;
>   	} else {
>   		if (!slot || !slot->npages)

This seems to imply IS_ERR() is misdesigned.

It would be nice to have IS_ERR() contain the appropriate casts. If we 
want to enforce that the argument is a pointer, add IS_ERR_PTR()?

	-hpa
