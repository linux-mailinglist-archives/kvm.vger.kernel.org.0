Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D78C746DC5
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 11:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjGDJkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 05:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbjGDJkX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 05:40:23 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D78A1FC9
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 02:38:03 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3fbc656873eso65507375e9.1
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 02:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688463438; x=1691055438;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SpcARJPauCixrL63DbIocIar6BtvglwEPVjknlrHqKs=;
        b=uZ3uIY3VwiAacH0U4n6+v8m+rHNYyKMd/xvS3VpgRUt4YrFeRn+AsepE68ED7foqdL
         QuK6696zJH0RM7mOgT/zYEgJtidA7WC5CwCVLs5thb2PgCzoD8gevm6aLfUfUA4/xicj
         yWTRVYsasES9qyRo0HDGRUIiDa9PwlX1Yt4opvKhp3yw9yvF/4damVjhfLNYKpT1tbEu
         I1ul8Kod4E0qqWiYxkr4UeIWyDg13WJwF7SqAgeK+fBgFTDnc6+TMV+dtq6edtFXi3yC
         ICEBVnXkBx3KhdkpQP+fRsIzfGbh98VQZq2LOFHOwQf1vYq7zMHDSN5Y7YW3iD4SUiv7
         6imA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688463438; x=1691055438;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SpcARJPauCixrL63DbIocIar6BtvglwEPVjknlrHqKs=;
        b=gvZ3gxCdZk1RHdvRT20cCb/6wBPepeB2eIcmzqxqpSN9U23X4ACsUX8nhur26hwQ9s
         XayVxZlNP1aKZkHA3VRGY0b6+wITGLOcl4MdTcxN4jYcZa7tKlrBvznwgPPl8XDA922e
         2fPq2lDQTUpb2eYVEFkyM+cfDSimbFaTuxs3JKLm4HvXZxFjDca6b0zwNLVhoY5C3hAM
         vdVG4eI596kladFurryyOAh+TE5eMxf4GsM8Uc1/84mLDVJ+rWKO7vPDKB/genPW4hSp
         NWGY+1m7dfqjpsANKtdoGcma2Eu8gKBLclXHvLtvNewmxS3D7UhlccelcDzhhnnw9XiB
         dzOQ==
X-Gm-Message-State: ABy/qLZBIzhMS7/+UpRlHrYXj/9RAwk0CZ+vwonO9W/Ttub2496FZTf1
        +uY/bHDF3L7J8k8SAPQnb3OgUQ==
X-Google-Smtp-Source: APBJJlGPX91ziTjruM5N7WRBFGpNpxg5jTwN/h3qpnaNIKKR5392vNwfSXNrXgGcPBxAEDXA48Nk0Q==
X-Received: by 2002:adf:f7cb:0:b0:30a:dd26:63cd with SMTP id a11-20020adff7cb000000b0030add2663cdmr15735870wrq.5.1688463437970;
        Tue, 04 Jul 2023 02:37:17 -0700 (PDT)
Received: from myrica ([2.219.138.198])
        by smtp.gmail.com with ESMTPSA id i6-20020adff306000000b00311339f5b06sm27712970wro.57.2023.07.04.02.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jul 2023 02:37:17 -0700 (PDT)
Date:   Tue, 4 Jul 2023 10:37:17 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        Suzuki.Poulose@arm.com, andre.przywara@arm.com, maz@kernel.org,
        oliver.upton@linux.dev, jean-philippe.brucker@arm.com,
        apatel@ventanamicro.com, kvm@vger.kernel.org
Subject: Re: [PATCH RESEND kvmtool 1/4] util: Make pr_err() return void
Message-ID: <20230704093717.GB3214657@myrica>
References: <20230630133134.65284-1-alexandru.elisei@arm.com>
 <20230630133134.65284-2-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230630133134.65284-2-alexandru.elisei@arm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 02:31:31PM +0100, Alexandru Elisei wrote:
> Of all the pr_* functions, pr_err() is the only function that returns a
> value, which is -1. The code in parse_options is the only code that relies
> on pr_err() returning a value, and that value must be exactly -1, because
> it is being treated differently than the other return values.
> 
> This makes the code opaque, because it's not immediately obvious where that
> value comes from, and fragile, as a change in the return value of pr_err
> would break it.
> 
> Make pr_err() more like the other functions and don't return a value.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

One small nit below, otherwise 

Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

> ---
>  include/kvm/util.h   |  2 +-
>  util/parse-options.c | 28 ++++++++++++++++------------
>  util/util.c          |  3 +--
>  3 files changed, 18 insertions(+), 15 deletions(-)
> 
> diff --git a/include/kvm/util.h b/include/kvm/util.h
> index b49454876a83..f51f370d2b37 100644
> --- a/include/kvm/util.h
> +++ b/include/kvm/util.h
> @@ -39,7 +39,7 @@ extern bool do_debug_print;
>  
>  extern void die(const char *err, ...) NORETURN __attribute__((format (printf, 1, 2)));
>  extern void die_perror(const char *s) NORETURN;
> -extern int pr_err(const char *err, ...) __attribute__((format (printf, 1, 2)));
> +extern void pr_err(const char *err, ...) __attribute__((format (printf, 1, 2)));
>  extern void pr_warning(const char *err, ...) __attribute__((format (printf, 1, 2)));
>  extern void pr_info(const char *err, ...) __attribute__((format (printf, 1, 2)));
>  extern void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN);
> diff --git a/util/parse-options.c b/util/parse-options.c
> index 9a1bbee6c271..fb44b48d14c8 100644
> --- a/util/parse-options.c
> +++ b/util/parse-options.c
> @@ -17,10 +17,13 @@
>  static int opterror(const struct option *opt, const char *reason, int flags)
>  {
>  	if (flags & OPT_SHORT)
> -		return pr_err("switch `%c' %s", opt->short_name, reason);
> -	if (flags & OPT_UNSET)
> -		return pr_err("option `no-%s' %s", opt->long_name, reason);
> -	return pr_err("option `%s' %s", opt->long_name, reason);
> +		pr_err("switch `%c' %s", opt->short_name, reason);
> +	else if (flags & OPT_UNSET)
> +		pr_err("option `no-%s' %s", opt->long_name, reason);
> +	else
> +		pr_err("option `%s' %s", opt->long_name, reason);
> +
> +	return -1;
>  }
>  
>  static int get_arg(struct parse_opt_ctx_t *p, const struct option *opt,
> @@ -429,14 +432,15 @@ is_abbreviated:
>  		return get_value(p, options, flags);
>  	}
>  
> -	if (ambiguous_option)
> -		return pr_err("Ambiguous option: %s "
> -				"(could be --%s%s or --%s%s)",
> -				arg,
> -				(ambiguous_flags & OPT_UNSET) ?  "no-" : "",
> -				ambiguous_option->long_name,
> -				(abbrev_flags & OPT_UNSET) ?  "no-" : "",
> -				abbrev_option->long_name);
> +	if (ambiguous_option) {
> +		pr_err("Ambiguous option: %s " "(could be --%s%s or --%s%s)",

drop " "

> +			arg,
> +			(ambiguous_flags & OPT_UNSET) ?  "no-" : "",
> +			ambiguous_option->long_name,
> +			(abbrev_flags & OPT_UNSET) ?  "no-" : "",
> +			abbrev_option->long_name);
> +		return -1;
> +	}
>  	if (abbrev_option)
>  		return get_value(p, abbrev_option, abbrev_flags);
>  	return -2;
> diff --git a/util/util.c b/util/util.c
> index 1877105e3c08..f59f26e1581c 100644
> --- a/util/util.c
> +++ b/util/util.c
> @@ -47,14 +47,13 @@ void die(const char *err, ...)
>  	va_end(params);
>  }
>  
> -int pr_err(const char *err, ...)
> +void pr_err(const char *err, ...)
>  {
>  	va_list params;
>  
>  	va_start(params, err);
>  	error_builtin(err, params);
>  	va_end(params);
> -	return -1;
>  }
>  
>  void pr_warning(const char *warn, ...)
> -- 
> 2.41.0
> 
