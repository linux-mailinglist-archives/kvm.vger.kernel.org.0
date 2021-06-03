Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7857C39969C
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 02:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbhFCAFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 20:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhFCAFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 20:05:47 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2843C06174A
        for <kvm@vger.kernel.org>; Wed,  2 Jun 2021 17:03:49 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id u18so3483786pfk.11
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 17:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dSK1YghDEHh+NV8WsQLZprl8Ws0Sp5bz7g+xU8GwfWE=;
        b=cm17XxNaMSMR4SOuZSnpk2SRft8oC+mfLDu9RybmyNepi4gUrIISOiX2VoxgrnX6w5
         WMbAvC3Smfu3ZmIMPi3sjGFGnyj2bSiEDvB4TEJeOmrxvgj0rgLE3qoXfSndU76vhDMc
         pIw1fm3w7HixdXbKUPVXMV/YhZPS+3CIxpbcv/+Dcs7Dxo3vKYrmUUXE2exYDOugUNOr
         UQqle5R/FePtFo8EYkaTudzJhCzeVzP9drhnaUibtD/XvrBY3O1R2zQPYyZ5palnyarC
         PKdm7u7RcqaVoAKeJB5dXjmbzrpB0gQXWS+p11JdRM0yA4xQcJ+qTHgBB8MCsLBIikp2
         ewbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dSK1YghDEHh+NV8WsQLZprl8Ws0Sp5bz7g+xU8GwfWE=;
        b=P2TCjvRF9pMHm1ZDpzuiqEh8Y1HC8qVl8q9uoTcD7vW5xyzS4fGxeSg4uV520pJqDy
         fDWKXUrhOzJ1YvHePK5uD2cSkd9muxOVljADviSENu1OVnIa2fsffwNZh2kJfm58xbnQ
         cp4EEvaWagXWbgIChVeC2TXn7TqSYXkuGdBiRhlEC7Lvv0cptoThkzAEFGSBMBh48Hwk
         fmIQyC6fYuhUdGgb8e9YEvM2TNQqoe4X/fteVep0jOvBP41pfD6HYcux1X+JzkCnIAaO
         /KGq5fG2o27a6drF6oJ+hry8ppSIZgPcD4JMa8MuTP8iErcdPtNHHS7nBBITn2yIlHAK
         4TIw==
X-Gm-Message-State: AOAM532GV5l/ySrX4jE8jdwHYF7ss5ky+TzoNR3w/C+tJyO1FqY5cEg+
        DxvaZ8H5ICBg5w8+tmt81NVB4rlKAW7Tlg==
X-Google-Smtp-Source: ABdhPJz/msCR3BtclVo5R8Ez6EZDkYmxTH8rLz/N5JNqkqt0OdwLp4bYONOFQLPYnZlk3Xeyp6Qt2g==
X-Received: by 2002:a05:6a00:216a:b029:2df:3461:4ac3 with SMTP id r10-20020a056a00216ab02902df34614ac3mr29187497pff.80.1622678628971;
        Wed, 02 Jun 2021 17:03:48 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id q23sm747849pgj.61.2021.06.02.17.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 17:03:48 -0700 (PDT)
Date:   Wed, 2 Jun 2021 17:03:45 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        eric.auger@redhat.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com
Subject: Re: [PATCH v3 3/5] KVM: arm64: selftests: get-reg-list: Provide
 config selection option
Message-ID: <YLgcYSJ3COevI7/0@google.com>
References: <20210531103344.29325-1-drjones@redhat.com>
 <20210531103344.29325-4-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531103344.29325-4-drjones@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 31, 2021 at 12:33:42PM +0200, Andrew Jones wrote:
> Add a new command line option that allows the user to select a specific
> configuration, e.g. --config=sve will give the sve config. Also provide
> help text and the --help/-h options.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Ricardo Koller <ricarkol@google.com>

> ---
>  .../selftests/kvm/aarch64/get-reg-list.c      | 56 ++++++++++++++++++-
>  1 file changed, 53 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index 14fc8d82e30f..03e041d97a18 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -539,6 +539,52 @@ static void run_test(struct vcpu_config *c)
>  	kvm_vm_free(vm);
>  }
>  
> +static void help(void)
> +{
> +	struct vcpu_config *c;
> +	int i;
> +
> +	printf(
> +	"\n"
> +	"usage: get-reg-list [--config=<selection>] [--list] [--list-filtered] [--core-reg-fixup]\n\n"
> +	" --config=<selection>        Used to select a specific vcpu configuration for the test/listing\n"
> +	"                             '<selection>' may be\n");
> +
> +	for (i = 0; i < vcpu_configs_n; ++i) {
> +		c = vcpu_configs[i];
> +		printf(
> +	"                               '%s'\n", config_name(c));
> +	}
> +
> +	printf(
> +	"\n"
> +	" --list                      Print the register list rather than test it (requires --config)\n"
> +	" --list-filtered             Print registers that would normally be filtered out (requires --config)\n"
> +	" --core-reg-fixup            Needed when running on old kernels with broken core reg listings\n"
> +	"\n"
> +	);
> +}
> +
> +static struct vcpu_config *parse_config(const char *config)
> +{
> +	struct vcpu_config *c;
> +	int i;
> +
> +	if (config[8] != '=')
> +		help(), exit(1);
> +
> +	for (i = 0; i < vcpu_configs_n; ++i) {
> +		c = vcpu_configs[i];
> +		if (strcmp(config_name(c), &config[9]) == 0)
> +			break;
> +	}
> +
> +	if (i == vcpu_configs_n)
> +		help(), exit(1);
> +
> +	return c;
> +}
> +
>  int main(int ac, char **av)
>  {
>  	struct vcpu_config *c, *sel = NULL;
> @@ -547,20 +593,24 @@ int main(int ac, char **av)
>  	for (i = 1; i < ac; ++i) {
>  		if (strcmp(av[i], "--core-reg-fixup") == 0)
>  			fixup_core_regs = true;
> +		else if (strncmp(av[i], "--config", 8) == 0)
> +			sel = parse_config(av[i]);
>  		else if (strcmp(av[i], "--list") == 0)
>  			print_list = true;
>  		else if (strcmp(av[i], "--list-filtered") == 0)
>  			print_filtered = true;
> +		else if (strcmp(av[i], "--help") == 0 || strcmp(av[1], "-h") == 0)
> +			help(), exit(0);
>  		else
> -			TEST_FAIL("Unknown option: %s\n", av[i]);
> +			help(), exit(1);
>  	}
>  
>  	if (print_list || print_filtered) {
>  		/*
>  		 * We only want to print the register list of a single config.
> -		 * TODO: Add command line support to pick which config.
>  		 */
> -		sel = vcpu_configs[0];
> +		if (!sel)
> +			help(), exit(1);
>  	}
>  
>  	for (i = 0; i < vcpu_configs_n; ++i) {
> -- 
> 2.31.1
> 
