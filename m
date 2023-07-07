Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805ED74AD57
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 10:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbjGGIuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 04:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbjGGIuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 04:50:07 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDD21FF6
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 01:50:05 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-51e362e4c61so1245208a12.0
        for <kvm@vger.kernel.org>; Fri, 07 Jul 2023 01:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688719804; x=1691311804;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5RjK+qC2yMFJgjkKw6erEN3Jd2b9gaqG22ipLAdc2dU=;
        b=XrbXfRmQCjUscV2Ba8aT4CeqI8SHGzhgNT19Z+cXVUVjsfjlY727uM5XgaL3/HGEmE
         rincuPV1ve3upDuPmcKf8yyDZ0uYqQ0RgcFsz3NX051UPBbVCeG/wcrgU9jKo7ealzIF
         FM0qSpBNBBwnXNaZMFUqTZnhoZ2vVMkDcoPBNiSUEvogy6JTo6ViMLgGEnZK5AtAJfUN
         H+KmB832D8xMunS52RPmzM8geXB3umrm+7r7KDi4I/dGdIg0v8AXc6NCT68I8aIHJms6
         zLIccr5zXTaQXVpoWOnsoxD2gaz+QSY9UbEMLWAKhEmS1P5om5naa7O7dZvbYo0reRWc
         z2mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688719804; x=1691311804;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5RjK+qC2yMFJgjkKw6erEN3Jd2b9gaqG22ipLAdc2dU=;
        b=JHYOi3WvTwqUlh/KsTz1m/rIEAEQb6n0REhRt1XCDURmaDabq2ptiUdjYkEvCo7WKh
         j5Ox2bPAqQUe+HD3jy9oS2GxMHmAy4urcopsF8LApglM0jeggvpXkLBpuldKpundwF1d
         0dkTehkob3sEmd3PfYM5v5E+ydfaX+qnHBFr/iGh6pxQjAAY+WWXPdO43eX3tp0q09lS
         vhshjqp4jNT/vMRvAbrWaPm3CWjxukGhr+h3XgI96qDpCgYmQp9znnaZM1gTevnanoeM
         8mBso5Cz1IrKXUk0vOiu5GfGp2I/oZzC9hy9mFEQEFgt3Ps1EVVh2dT0NOspF3RaXFOt
         07tA==
X-Gm-Message-State: ABy/qLY4XDEF6iJTq+KUbWZUxqWik5YeqLv9EMpC1gy/SOs5J+HN/C18
        heWfQMWxQdYgJoYJGBacqbbvgQ==
X-Google-Smtp-Source: APBJJlFoSNKdTxcrVTzHzXQ9XY797yl1F/eHgY+ESTfu/TLkIN4acobfLB5NWFomyTRDzX+c+XGX5Q==
X-Received: by 2002:a17:906:5291:b0:973:e5d9:d6ff with SMTP id c17-20020a170906529100b00973e5d9d6ffmr2680060ejm.66.1688719803836;
        Fri, 07 Jul 2023 01:50:03 -0700 (PDT)
Received: from [192.168.69.115] ([176.187.215.192])
        by smtp.gmail.com with ESMTPSA id v1-20020a170906b00100b00993a9a951fasm1933484ejy.11.2023.07.07.01.50.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jul 2023 01:50:03 -0700 (PDT)
Message-ID: <d662fe0e-e463-5c22-2e31-31aec6307c05@linaro.org>
Date:   Fri, 7 Jul 2023 10:50:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH] MIPS: kvm: Fix build error with
 KVM_MIPS_DEBUG_COP0_COUNTERS enabled
Content-Language: en-US
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhuacai@kernel.org>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230706163610.106938-1-tsbogend@alpha.franken.de>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230706163610.106938-1-tsbogend@alpha.franken.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/7/23 18:36, Thomas Bogendoerfer wrote:
> Commit e4de20576986 ("MIPS: KVM: Fix NULL pointer dereference") missed
> converting one place accessing cop0 registers, which results in a build
> error, if KVM_MIPS_DEBUG_COP0_COUNTERS is enabled.
> 
> Fixes: e4de20576986 ("MIPS: KVM: Fix NULL pointer dereference")
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> ---
>   arch/mips/kvm/stats.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/mips/kvm/stats.c b/arch/mips/kvm/stats.c
> index 53f851a61554..3e6682018fbe 100644
> --- a/arch/mips/kvm/stats.c
> +++ b/arch/mips/kvm/stats.c
> @@ -54,9 +54,9 @@ void kvm_mips_dump_stats(struct kvm_vcpu *vcpu)
>   	kvm_info("\nKVM VCPU[%d] COP0 Access Profile:\n", vcpu->vcpu_id);
>   	for (i = 0; i < N_MIPS_COPROC_REGS; i++) {
>   		for (j = 0; j < N_MIPS_COPROC_SEL; j++) {
> -			if (vcpu->arch.cop0->stat[i][j])
> +			if (vcpu->arch.cop0.stat[i][j])
>   				kvm_info("%s[%d]: %lu\n", kvm_cop0_str[i], j,
> -					 vcpu->arch.cop0->stat[i][j]);
> +					 vcpu->arch.cop0.stat[i][j]);
>   		}
>   	}
>   #endif

Oops, sorry I missed that :/

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

