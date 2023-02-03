Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A7868A3CD
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 21:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbjBCUtj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 15:49:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBCUti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 15:49:38 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF3D945ED
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 12:49:37 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id ge21-20020a17090b0e1500b002308aac5b5eso132230pjb.4
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 12:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0NuuQgjEG23B2DPqBDDMecvUvPhpbLh9TYew+NmFHoc=;
        b=VgIIXISXfMR5wvvuPW3HPUehpTeo2EhClTg/JlwUdBH2AZ+VQK76mb5FIAx3EiHgHy
         PCsJceekk2nmdIBKtCzvmJxMUb6Mqv7pUWNJ6621SE3LnNJXF1HcCi0VYo8aL5DYwO2e
         vR/vHnbe9JJTwzMOFRGGC0Dsp6VsNHA1TC8Mni5H00RLQ5/Z6quk0mDyisFc9RxDKtUt
         tQ44eRhXvB1KSgVqhzvBRVQK3nyG3uO9gpNOwNFjAZMFH1Ia2IxRQHViELkcO5BCT8XM
         Y9Ve4TPpQJzqyH/p6dyh36+ugQHf+gSpqNAN+YW1OodKmJDY3j+KE1dXWj5B+So48NQi
         h0ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0NuuQgjEG23B2DPqBDDMecvUvPhpbLh9TYew+NmFHoc=;
        b=U1RNOJdSh9GAXrIp0ija8thBZWm3GwKjzvYWMZc13Hjr9pFgksdGWGAvhtcIEjibJw
         cSSJ9Of2XGAMc9ZNSHCoG+AKVqYiQSVOeLKUpCCJuJlmH9y1JRtgW1/n8QlcajT9KB3u
         h2BkXypR0UbRx8nYuXle/escnzdQULmlDT2c6Oen+/985ZPCgiMveT0XfDOYppwRaCMg
         g5lq0t001byRuvTxOPIFYzUUNGPJXAh7QCWygFkPoh79IsGq5cGq2nS23tvYik/EiLpN
         tqxSrq5fv8KOTc0l9i0Vnwr4mANe5Efk0HCc/foeZW096Bp7y+UkuR50bdJHwPMfG03M
         Wpug==
X-Gm-Message-State: AO0yUKV0eQhO4PG4pK0glzznZzV9ie3C/kfv1M4u0125pq2bJK56LLdQ
        ea2oYBN0jwFf9TT0pCBAxxvVV3x+URzXZ2/9bto=
X-Google-Smtp-Source: AK7set9ijJLmz54py+alQSvtlbzY63y0qMo6GmyGo7zvduofAVhakknMD4qa61ONh/0pc0hNqqMNTw==
X-Received: by 2002:a17:902:ea0f:b0:198:af50:e4e5 with SMTP id s15-20020a170902ea0f00b00198af50e4e5mr18901plg.11.1675457376602;
        Fri, 03 Feb 2023 12:49:36 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c25-20020a639619000000b004f198707cdbsm1869142pge.55.2023.02.03.12.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 12:49:36 -0800 (PST)
Date:   Fri, 3 Feb 2023 20:49:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     lirongqing@baidu.com
Cc:     kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] KVM: x86: Enable PIT shutdown quirk
Message-ID: <Y91zXD++4pSHKo6c@google.com>
References: <1675395710-37220-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1675395710-37220-1-git-send-email-lirongqing@baidu.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please use "x86/kvm:" for guest side changes.

On Fri, Feb 03, 2023, lirongqing@baidu.com wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> KVM emulation of the PIT has a quirk such that the normal PIT shutdown
> path doesn't work, because clearing the counter register restarts the
> timer.
> 
> Disable the counter clearing on PIT shutdown as in Hyper-V
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/kernel/kvm.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 1cceac5..14411b6 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -43,6 +43,7 @@
>  #include <asm/reboot.h>
>  #include <asm/svm.h>
>  #include <asm/e820/api.h>
> +#include <linux/i8253.h>
>  
>  DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
>  
> @@ -978,6 +979,9 @@ static void __init kvm_init_platform(void)
>  			wrmsrl(MSR_KVM_MIGRATION_CONTROL,
>  			       KVM_MIGRATION_READY);
>  	}
> +
> +	i8253_clear_counter_on_shutdown = false;

AFAICT, zeroing the counter isn't actually supposed to stop it from counting.
Copy pasting from the KVM host-side patch[*]:

  The largest possible initial count is 0; this is equivalent to 216 for
  binary counting and 104 for BCD counting.

  The Counter does not stop when it reaches zero. In Modes 0, 1, 4, and 5 the
  Counter ‘‘wraps around’’ to the highest count, either FFFF hex for binary count-
  ing or 9999 for BCD counting, and continues counting. 

  Mode 0 is typically used for event counting. After the Control Word is written,
  OUT is initially low, and will remain low until the Counter reaches zero. OUT
  then goes high and remains high until a new count or a new Mode 0 Control Word
  is written into the Counter.

Can we simply delete i8253_clear_counter_on_shutdown and the code it wraps?

[*] https://lore.kernel.org/kvm/Y91yLt3EZLA32csp@google.com
