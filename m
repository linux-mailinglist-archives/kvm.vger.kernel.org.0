Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011FA746E01
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 11:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjGDJxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 05:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjGDJxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 05:53:07 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95EAC4
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 02:53:05 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3fbc0609cd6so53206775e9.1
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 02:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688464384; x=1691056384;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DLfPNulXKo+qJFwX/tED285Px/SBZZY1/yvfCrf8v/I=;
        b=ZcacpQ0sFIQOplWw6A06PlVQzDW7/5wn88vf8yWJhvhr6DzZFVVAN4WLd/Znjs3buU
         7KMjZQhLN8tLn3iMvvNd/KlXZLju+cadbp20PifZzuGxjZ0Ak5xfhToIlMyQjGXI4lrI
         uZA7xV7ELptBXeZHQoWAt0QoiSUc+QM0QW/bvT2sh4X+q/qAn/Q22c814mZxtiVhLqGW
         l7UoU/BbinzBz+WCeKCakQBWOH15zb7gd8AT2iJp+8Q1MZVAg5jWcJVDzw7zqeJ2uod/
         5/yvf2TgOY3vZUILzTBdYpFImETzkOtV+6JECBnC2lt+W1ghEe/oRVlv//0QvBI3PXRy
         D4Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688464384; x=1691056384;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DLfPNulXKo+qJFwX/tED285Px/SBZZY1/yvfCrf8v/I=;
        b=bUZ/ONh9KyNBMGmUizgyRRM6wclxSLw4suhqEyR7In2A3DKkFrVYqNIFpVTrBVajob
         QfzioJqqEZo7JeyfoBJWIfL0ebDKW8hxZrn3fVCGHF3T7c7LAdO3u6Tv9UVxQWhcMO9H
         rCLE3SlsaRzupmtjQgf4DfW8IsQLgaxlkLxNS6AXT1ISq4IUSzFMlzdflT2sxyY3t//g
         kf4HYyYjaYfPjUTxxgZTav4g3m0yEIMmis2WctkWDQfaXlpRm6dxp9MBU1DVewWnrI9J
         hSR1RonDcBbt9E2HXEPjf9Ql3KfNJ0N5FMCpsys2bERDFqk7Uog403yx7o521Em//pHQ
         6w1w==
X-Gm-Message-State: AC+VfDy55MUSFyTXXieDokEmXEKVjZQNWr6pm+6nuuiK4XAryqH+zi59
        VZvo9J1XbTE0kqdD4x3szCEUag==
X-Google-Smtp-Source: ACHHUZ7+mN4NtBSyJM8s/2UeUz91Q5GZJLAEyevkpWQR9OXa9AvxSYeUSnOReA4GkYpAZrCdbJfgQA==
X-Received: by 2002:a1c:7203:0:b0:3fa:934c:8360 with SMTP id n3-20020a1c7203000000b003fa934c8360mr9908102wmc.8.1688464384401;
        Tue, 04 Jul 2023 02:53:04 -0700 (PDT)
Received: from myrica ([2.219.138.198])
        by smtp.gmail.com with ESMTPSA id b2-20020a05600010c200b00314427091a2sm571086wrx.98.2023.07.04.02.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jul 2023 02:53:04 -0700 (PDT)
Date:   Tue, 4 Jul 2023 10:53:04 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        Suzuki.Poulose@arm.com, andre.przywara@arm.com, maz@kernel.org,
        oliver.upton@linux.dev, jean-philippe.brucker@arm.com,
        apatel@ventanamicro.com, kvm@vger.kernel.org
Subject: Re: [PATCH RESEND kvmtool 4/4] Add --loglevel argument for the run
 command
Message-ID: <20230704095304.GE3214657@myrica>
References: <20230630133134.65284-1-alexandru.elisei@arm.com>
 <20230630133134.65284-5-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230630133134.65284-5-alexandru.elisei@arm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 02:31:34PM +0100, Alexandru Elisei wrote:
> Add --loglevel command line argument, with the possible values of 'error',
> 'warning', 'info' or 'debug' to control what messages kvmtool displays. The
> argument functions similarly to the Linux kernel parameter, when lower
> verbosity levels hide all message with a higher verbosity (for example,
> 'warning' hides info and debug messages, allows warning and error
> messsages).
> 
> The default level is 'info', to match the current behaviour. --debug has
> been kept as a legacy option, which might be removed in the future.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

> ---
>  builtin-run.c      | 32 ++++++++++++++++++++++++++++----
>  include/kvm/util.h |  9 +++++++--
>  util/util.c        |  9 +++++++++
>  3 files changed, 44 insertions(+), 6 deletions(-)
> 
> diff --git a/builtin-run.c b/builtin-run.c
> index 79d031777c26..2e4378819f00 100644
> --- a/builtin-run.c
> +++ b/builtin-run.c
> @@ -58,8 +58,7 @@
>  __thread struct kvm_cpu *current_kvm_cpu;
>  
>  static int  kvm_run_wrapper;
> -
> -bool do_debug_print = false;
> +int loglevel = LOGLEVEL_INFO;
>  
>  static const char * const run_usage[] = {
>  	"lkvm run [<options>] [<kernel image>]",
> @@ -146,6 +145,27 @@ static int mem_parser(const struct option *opt, const char *arg, int unset)
>  	return 0;
>  }
>  
> +static int loglevel_parser(const struct option *opt, const char *arg, int unset)
> +{
> +	if (strcmp(opt->long_name, "debug") == 0) {
> +		loglevel = LOGLEVEL_DEBUG;
> +		return 0;
> +	}
> +
> +	if (strcmp(arg, "debug") == 0)
> +		loglevel = LOGLEVEL_DEBUG;
> +	else if (strcmp(arg, "info") == 0)
> +		loglevel = LOGLEVEL_INFO;
> +	else if (strcmp(arg, "warning") == 0)
> +		loglevel = LOGLEVEL_WARNING;
> +	else if (strcmp(arg, "error") == 0)
> +		loglevel = LOGLEVEL_ERROR;
> +	else
> +		die("Unknown loglevel: %s", arg);
> +
> +	return 0;
> +}
> +
>  #ifndef OPT_ARCH_RUN
>  #define OPT_ARCH_RUN(...)
>  #endif
> @@ -215,6 +235,8 @@ static int mem_parser(const struct option *opt, const char *arg, int unset)
>  		     VIRTIO_TRANS_OPT_HELP_SHORT,		        \
>  		     "Type of virtio transport",			\
>  		     virtio_transport_parser, NULL),			\
> +	OPT_CALLBACK('\0', "loglevel", NULL, "[error|warning|info|debug]",\
> +			"Set the verbosity level", loglevel_parser, NULL),\
>  									\
>  	OPT_GROUP("Kernel options:"),					\
>  	OPT_STRING('k', "kernel", &(cfg)->kernel_filename, "kernel",	\
> @@ -241,8 +263,10 @@ static int mem_parser(const struct option *opt, const char *arg, int unset)
>  		     vfio_device_parser, kvm),				\
>  									\
>  	OPT_GROUP("Debug options:"),					\
> -	OPT_BOOLEAN('\0', "debug", &do_debug_print,			\
> -			"Enable debug messages"),			\
> +	OPT_CALLBACK_NOOPT('\0', "debug", kvm, NULL,			\
> +			"Enable debug messages (deprecated, use "	\
> +			"--loglevel=debug instead)",			\
> +			loglevel_parser, NULL),				\
>  	OPT_BOOLEAN('\0', "debug-single-step", &(cfg)->single_step,	\
>  			"Enable single stepping"),			\
>  	OPT_BOOLEAN('\0', "debug-ioport", &(cfg)->ioport_debug,		\
> diff --git a/include/kvm/util.h b/include/kvm/util.h
> index 6920ce2630ad..e9d63c184752 100644
> --- a/include/kvm/util.h
> +++ b/include/kvm/util.h
> @@ -32,7 +32,10 @@
>  #endif
>  #endif
>  
> -extern bool do_debug_print;
> +#define LOGLEVEL_ERROR		0
> +#define LOGLEVEL_WARNING	1
> +#define LOGLEVEL_INFO		2
> +#define LOGLEVEL_DEBUG		3
>  
>  #define PROT_RW (PROT_READ|PROT_WRITE)
>  #define MAP_ANON_NORESERVE (MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE)
> @@ -45,9 +48,11 @@ extern void pr_info(const char *err, ...) __attribute__((format (printf, 1, 2)))
>  extern void __pr_debug(const char *err, ...) __attribute__((format (printf, 1, 2)));
>  extern void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN);
>  
> +extern int loglevel;
> +
>  #define pr_debug(fmt, ...)						\
>  	do {								\
> -		if (do_debug_print)					\
> +		if (loglevel >= LOGLEVEL_DEBUG)				\
>  			__pr_debug("(%s) %s:%d: " fmt, __FILE__,	\
>  				__func__, __LINE__, ##__VA_ARGS__);	\
>  	} while (0)
> diff --git a/util/util.c b/util/util.c
> index e3b36f67f899..962e8d4edb21 100644
> --- a/util/util.c
> +++ b/util/util.c
> @@ -56,6 +56,9 @@ void pr_err(const char *err, ...)
>  {
>  	va_list params;
>  
> +	if (loglevel < LOGLEVEL_ERROR)
> +		return;
> +
>  	va_start(params, err);
>  	error_builtin(err, params);
>  	va_end(params);
> @@ -65,6 +68,9 @@ void pr_warning(const char *warn, ...)
>  {
>  	va_list params;
>  
> +	if (loglevel < LOGLEVEL_WARNING)
> +		return;
> +
>  	va_start(params, warn);
>  	warn_builtin(warn, params);
>  	va_end(params);
> @@ -74,6 +80,9 @@ void pr_info(const char *info, ...)
>  {
>  	va_list params;
>  
> +	if (loglevel < LOGLEVEL_INFO)
> +		return;
> +
>  	va_start(params, info);
>  	info_builtin(info, params);
>  	va_end(params);
> -- 
> 2.41.0
> 
