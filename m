Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B96613E8C
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 20:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiJaTsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 15:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiJaTsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 15:48:21 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DD9267
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 12:48:20 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id k22so11596196pfd.3
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 12:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x7N9kfNxRp4rcAnBpWzv9IhHAOhOmOL3SfOMvIFzLEo=;
        b=oTizwPjTW/xH8tuWtXb2tlGJaUTK4tVLrrSfweZb6JEhZX+/SfsDpyg9WZQopaoJEg
         nRo5UaJkxjEJf/17lITp0Krf0P/Fqpy9AOQvTYosp/e8i8AYBK5V4Dp4V5rzLmFN1HT1
         4DvGSF9ajwSAfsOQLtL76ayROFxwSJ8BY5dslpINdE0p6supkPNfx6nSL5+7oQpCI2pY
         yNil6bMMqtBwyYR7erdWRIdh/OIir+Faffz4rzypRkB5CJThZTDnf9cOIZQsSl5hxFZk
         wxQaxQHeYVqv4P+4pnbPVSreUjQDSAdjAx0ZoWJBLX0qolj5sYxxhOzVLSm5ebGI06Nz
         bdLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x7N9kfNxRp4rcAnBpWzv9IhHAOhOmOL3SfOMvIFzLEo=;
        b=W/XrM+LB45vm0qJg/fdSW03EWwkAEPP9FoClar3r9kVSmB/NMsgs2obOIMRHttNxJ2
         i8OJ6yO3nWyQSVBUOvriYYyXMdw6WKdNrRMa7vsZz1CcHTWzVd94Oa9SLPhG2Vn+G3If
         DqmlUHXoMuBl9rUsXA7MMoqxaghFV0AV90wmxLUVD3q0PiZmfk1qWwgzAdCWbs3XJHEq
         4Cu7hQn9gj69Y1Tm/R0Sp9JnD9ME3P8rPsC7bb3+DSPWZrpBZujbJrWY6ZozTS3XeUk1
         zapHtpvlvQovv70qEy0D9pDkz/fCGZUz5Pm0+QxvGAz+H5UdO0DYIhX3n8l7o0rRlO2r
         ZVHA==
X-Gm-Message-State: ACrzQf2M1t1YwzlFgNSjODH4CHNFnsvyO9KHWGaW0hcqti4iV/vYhcfk
        XUzqigt/mfl6qNpcM8Jqz28jbg==
X-Google-Smtp-Source: AMsMyM5nD/Z7kmincdOAHSJzZ3tjVyX5eHC50LDw75rk9sJ4w+E2BvoxJCnvBRgqAW7ilCmLt+8bmQ==
X-Received: by 2002:a62:1c48:0:b0:56b:daf5:255a with SMTP id c69-20020a621c48000000b0056bdaf5255amr16332981pfc.44.1667245700042;
        Mon, 31 Oct 2022 12:48:20 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y1-20020a17090a104100b00200a85fa777sm4682861pjd.1.2022.10.31.12.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 12:48:19 -0700 (PDT)
Date:   Mon, 31 Oct 2022 19:48:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, andrew.jones@linux.dev,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 4/5] KVM: selftests: Add atoi_positive() and
 atoi_non_negative() for input validation
Message-ID: <Y2AmgObslx57+uYt@google.com>
References: <20221031173819.1035684-1-vipinsh@google.com>
 <20221031173819.1035684-5-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031173819.1035684-5-vipinsh@google.com>
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

On Mon, Oct 31, 2022, Vipin Sharma wrote:
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> index ec0f070a6f21..210e98a49a83 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -353,3 +353,19 @@ int atoi_paranoid(const char *num_str)
>  
>  	return num;
>  }
> +
> +uint32_t atoi_positive(const char *num_str)

I think it makes sense to inline atoi_positive() and atoi_non_negative() in
test_util.h.  Depending on developer's setups, it might be one less layer to jump
through to look at the implementation.

> +{
> +	int num = atoi_paranoid(num_str);
> +
> +	TEST_ASSERT(num > 0, "%s is not a positive integer.\n", num_str);

Newlines aren't needed in asserts.  This applies to atoi_paranoid() in the previous
patch as well (I initially missed them).

> +	return num;
> +}
> +
> +uint32_t atoi_non_negative(const char *num_str)
> +{
> +	int num = atoi_paranoid(num_str);
> +
> +	TEST_ASSERT(num >= 0, "%s is not a non-negative integer.\n", num_str);
> +	return num;
> +}
> diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
> index 1595b73dc09a..20015de3b91c 100644
> --- a/tools/testing/selftests/kvm/max_guest_memory_test.c
> +++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
> @@ -193,15 +193,14 @@ int main(int argc, char *argv[])
>  	while ((opt = getopt(argc, argv, "c:h:m:s:H")) != -1) {
>  		switch (opt) {
>  		case 'c':
> -			nr_vcpus = atoi_paranoid(optarg);
> -			TEST_ASSERT(nr_vcpus > 0, "number of vcpus must be >0");
> +			nr_vcpus = atoi_positive(optarg);

I know I originally made the claim that the assert would provide enough context
to offest lack of a specific message, but after actually playing around with this,
past me was wrong.  E.g. this

  Memory size must be greater than 0, got '-1'

is much more helpful than

  -1 is not a positive integer.

E.g. something like this?

  static inline uint32_t atoi_positive(const char *name, const char *num_str)
  {
	int num = atoi_paranoid(num_str);

	TEST_ASSERT(num > 0, "%s must be greater than 0, got '%s'", name, num_str);
	return num;
  }

  static inline uint32_t atoi_non_negative(const char *name, const char *num_str)
  {
	int num = atoi_paranoid(num_str);

	TEST_ASSERT(num >= 0, "%s must be non-negative, got '%s'", name, num_str);
	return num;
  }

IMO, that also makes the code slightly easier to follow as it's super obvious
what is being parsed.

  p.wr_fract = atoi_positive("Write fraction", optarg);

  p.iterations = atoi_positive("Number of iterations", optarg);

  nr_vcpus = atoi_positive("Number of vCPUs", optarg);

Last thought: my vote would be to ignore the 80 char soft limit when adding the
"name" to these calls, in every case except nr_memslot_modifications the overrun
is relatively minor and not worth wrapping.  See below for my thougts on that one.

>  			break;
>  		case 'm':
> -			max_mem = atoi_paranoid(optarg) * size_1gb;
> +			max_mem = atoi_positive(optarg) * size_1gb;
>  			TEST_ASSERT(max_mem > 0, "memory size must be >0");

This assert can be dropped, max_mem is a uint64_t so wrapping to '0' is impossible.

>  			break;
>  		case 's':
> -			slot_size = atoi_paranoid(optarg) * size_1gb;
> +			slot_size = atoi_positive(optarg) * size_1gb;

Same thing here.

>  			TEST_ASSERT(slot_size > 0, "slot size must be >0");
>  			break;
>  		case 'H':
> diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> index 865276993ffb..7539ee7b6e95 100644
> --- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> +++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> @@ -175,7 +175,7 @@ int main(int argc, char *argv[])
>  			p.partition_vcpu_memory_access = false;
>  			break;

memslot_modification_delay can be converted to atoi_non_negative(), it open codes
strtoul(), but the "long" part is unnecessary because memslot_modification_delay
is an "unsigned int", not an "unsigned long".

>  		case 'i':
> -			p.nr_memslot_modifications = atoi_paranoid(optarg);
> +			p.nr_memslot_modifications = atoi_positive(optarg);

To avoid a ridiculously long line, my vote is to rename the test args.  The names
are rather odd irrespective of line length.  E.g. in a prep patch do

  s/memslot_modification_delay/delay
  s/nr_memslot_modifications/nr_iterations

which yields parsing of:

	while ((opt = getopt(argc, argv, "hm:d:b:v:oi:")) != -1) {
		switch (opt) {
		case 'm':
			guest_modes_cmdline(optarg);
			break;
		case 'd':
			p.delay = atoi_non_negative("Delay", optarg);
			break;
		case 'b':
			guest_percpu_mem_size = parse_size(optarg);
			break;
		case 'v':
			nr_vcpus = atoi_positive("Number of vCPUs", optarg);
			TEST_ASSERT(nr_vcpus <= max_vcpus,
				    "Invalid number of vcpus, must be between 1 and %d",
				    max_vcpus);
			break;
		case 'o':
			p.partition_vcpu_memory_access = false;
			break;
		case 'i':
			p.nr_iterations = atoi_positive("Number of iterations", optarg);
			break;
		case 'h':
		default:
			help(argv[0]);
			break;
		}
	}

