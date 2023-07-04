Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B51746DFB
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 11:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjGDJuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 05:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbjGDJuI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 05:50:08 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8946D8
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 02:50:06 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3fbc244d307so63473445e9.1
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 02:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688464205; x=1691056205;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vuMSRnKjY5CfkcypvZaS47D4U4a7VG2zfjdmEAI+9vg=;
        b=RYoE5GUKIl79QCfBcVUinAxPRizlvKAzhD706op2pmFgGZFiunfsMKxmK06iUj9Bx+
         xC3Cf2ieiic15kLaPRyFUznIHeUg+kgpplBWNFcfJtTP4Z3bGD9wx6KBRkvfRCKJBBPG
         ZZhPM8kXav09Hld3ibXTKSbt4DHZ89S3HaBdv2GuzUm2gL5JjwUmRghZZERT4VB2lWF9
         tafD3NzrqT/vZ68IgaRRS06txOeMveCKG6LkiTVc77n/2+M8IXqPYt18nScCXQaTgPOi
         CXUeG6j6WWwSBkA/nqQsqDQ7hSuIx9eqH2JmqRFQFBtkMLrqHYStMHiGagaMtnaJg9ly
         xkZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688464205; x=1691056205;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vuMSRnKjY5CfkcypvZaS47D4U4a7VG2zfjdmEAI+9vg=;
        b=bvVZ7Ecu7F37b+Y4RW4Wu2hNWyjsQFc7tZPm2jb3c8p33/wy8Z/fsn+pNgk65DDpoC
         f8jrfsI5CtL68SHjf0PqJaB4MsTQrUf16BT0Q5hPpf/72qrr3smX+zuu4IFh67I4NNVX
         rktop/bQt778vShGlDsayDq0tGUxbb2qBlWqmn+/Q+Sxwv7JtDk5WK4m9fM0RhnIFK5H
         kCl4iViEABj9TqeEtXdR4kIG9smdGvMZkSXGgn/8SPB44KCUyWZWkOGuxEzdyEbjTs88
         FfkkEndcEyY6jDW0aAOU8uzQeqhakNjA7EaH+42uIuKqS92BmUIVp9cOad9q4mlE4Wez
         W7fw==
X-Gm-Message-State: AC+VfDzjfCfUOD1fnQ+0mzkbDajH8rgYJp+6vdBsSGLIG+Ew8LMQoX83
        ZSL99rwZqS5StKH1s0ziprSaUg==
X-Google-Smtp-Source: ACHHUZ6bx0s4EBXPQZQiMrbe9gwqUIPMfXjTa3Oh2kBf6koJ/2OJVKbqHm+Y7d9czEqmIYDODY34jw==
X-Received: by 2002:a1c:4b11:0:b0:3f9:b804:1785 with SMTP id y17-20020a1c4b11000000b003f9b8041785mr12052930wma.0.1688464205218;
        Tue, 04 Jul 2023 02:50:05 -0700 (PDT)
Received: from myrica ([2.219.138.198])
        by smtp.gmail.com with ESMTPSA id y19-20020a05600c365300b003fa8dbb7b5dsm25884113wmq.25.2023.07.04.02.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jul 2023 02:50:05 -0700 (PDT)
Date:   Tue, 4 Jul 2023 10:50:04 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        Suzuki.Poulose@arm.com, andre.przywara@arm.com, maz@kernel.org,
        oliver.upton@linux.dev, jean-philippe.brucker@arm.com,
        apatel@ventanamicro.com, kvm@vger.kernel.org
Subject: Re: [PATCH RESEND kvmtool 3/4] util: Use __pr_debug() instead of
 pr_info() to print debug messages
Message-ID: <20230704095004.GD3214657@myrica>
References: <20230630133134.65284-1-alexandru.elisei@arm.com>
 <20230630133134.65284-4-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230630133134.65284-4-alexandru.elisei@arm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 02:31:33PM +0100, Alexandru Elisei wrote:
> pr_debug() is special, because it can be suppressed with a command line
> argument, and because it needs to be a macro to capture the correct
> filename, function name and line number. Display debug messages with the
> prefix "Debug", to make it clear that those aren't informational messages.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

(nit below)

> ---
>  include/kvm/util.h |  3 ++-
>  util/util.c        | 15 +++++++++++++++
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/include/kvm/util.h b/include/kvm/util.h
> index f51f370d2b37..6920ce2630ad 100644
> --- a/include/kvm/util.h
> +++ b/include/kvm/util.h
> @@ -42,12 +42,13 @@ extern void die_perror(const char *s) NORETURN;
>  extern void pr_err(const char *err, ...) __attribute__((format (printf, 1, 2)));
>  extern void pr_warning(const char *err, ...) __attribute__((format (printf, 1, 2)));
>  extern void pr_info(const char *err, ...) __attribute__((format (printf, 1, 2)));
> +extern void __pr_debug(const char *err, ...) __attribute__((format (printf, 1, 2)));
>  extern void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN);
>  
>  #define pr_debug(fmt, ...)						\
>  	do {								\
>  		if (do_debug_print)					\
> -			pr_info("(%s) %s:%d: " fmt, __FILE__,		\
> +			__pr_debug("(%s) %s:%d: " fmt, __FILE__,	\
>  				__func__, __LINE__, ##__VA_ARGS__);	\
>  	} while (0)
>  
> diff --git a/util/util.c b/util/util.c
> index f59f26e1581c..e3b36f67f899 100644
> --- a/util/util.c
> +++ b/util/util.c
> @@ -38,6 +38,11 @@ static void info_builtin(const char *info, va_list params)
>  	report(" Info: ", info, params);
>  }
>  
> +static void debug_builtin(const char *info, va_list params)

parameter here and in __pr_debug could be called 'debug' for consistency

> +{
> +	report(" Debug: ", info, params);
> +}
> +
>  void die(const char *err, ...)
>  {
>  	va_list params;
> @@ -74,6 +79,16 @@ void pr_info(const char *info, ...)
>  	va_end(params);
>  }
>  
> +/* Do not call directly; call pr_debug() instead. */
> +void __pr_debug(const char *info, ...)
> +{
> +	va_list params;
> +
> +	va_start(params, info);
> +	debug_builtin(info, params);
> +	va_end(params);
> +}
> +
>  void die_perror(const char *s)
>  {
>  	perror(s);
> -- 
> 2.41.0
> 
