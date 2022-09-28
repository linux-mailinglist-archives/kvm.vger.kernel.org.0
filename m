Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA3285EE9BD
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 00:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234173AbiI1Wvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 18:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234164AbiI1Wvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 18:51:38 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B863B5E77
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 15:51:36 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 78so13463914pgb.13
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 15:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=4rijZ4ttYw21/2I1NvyKRYgY5tGibj3vrRPtbvvQIY8=;
        b=CT6iavnj5IsuMKy25adf6SQ6jWrRGW9n7LAy4rc3B8rCGkfTVR1bapMFxV04T7BCmJ
         T8tayXm4T3rCIJ/1KKCYHRKHnvQInf33bzr0mE+4fdnMSWvCSihIgjy+EctH7/rFNJol
         P+q/2nXkM3wMKwOpgQMsDuoXZNjWwsNW4vKa1H03qBnyUMWcl2rQUH7BLVnIfBvvjzvU
         7eAyZ95QyQbr1i6T6BF4D9uXEAifuA0xrB6VEfdU8EfUMwwrCivNTQtrWWNqyEPXq47J
         V1eCbEN+GF/tu0BRGR85y06W1oxOIev7dL2zn9GZMZn3kKVCrv32+H2US7vItUMci6/g
         4/+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=4rijZ4ttYw21/2I1NvyKRYgY5tGibj3vrRPtbvvQIY8=;
        b=WtDGym2g1R9nGWjUv6mMNVBQSGF7uKBlj4rx0YsP3dtbzRjsuirkOI/PUUiIfQNEia
         AMhCN9vBU5T5f64/8ZDgjeQBJfInupM8C0OEHcDdV7EbtR9gz79+UOcrY5dHA6JD0xdj
         pcMWjjcIIZaLO7GZWuduWmmjjz5NOJy8UG7hd1qEwK2msEzYk9QqgiCtYML48EIOS8D5
         2HhUI9mWjBQUzeuiBguLq9e3PxmlWVFpPrzmHsriSGwbJ36AaAKE7vl81ZmxWtY0ngjx
         9M6rY8aNrPRzIH+I1bAx+iJ4hJrVn+d6TXgiuGXR22d1aZGY/euG+eUX+HhHg5EHVFfq
         pWzw==
X-Gm-Message-State: ACrzQf2jN4hTrQ6zbyqvYtXqezL0agd8W4wYq9Y0xAmekKcrDsxGLz/1
        MXDGA3IgdfU9FqB7S0fHj3yv/w==
X-Google-Smtp-Source: AMsMyM7m5lL/W4nnfvx2ECz7WSl8W8I0dh4ldZMzc1H7iRRtM4VOIYKR4fMvESU+z46fOQ2eWIrp/g==
X-Received: by 2002:a63:ce17:0:b0:42a:bfb6:f218 with SMTP id y23-20020a63ce17000000b0042abfb6f218mr103794pgf.484.1664405495415;
        Wed, 28 Sep 2022 15:51:35 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u16-20020a170902e5d000b00172f6726d8esm4268155plf.277.2022.09.28.15.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 15:51:34 -0700 (PDT)
Date:   Wed, 28 Sep 2022 22:51:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/3] KVM: selftests: Add helper to read boolean module
 parameters
Message-ID: <YzTP8xBkBkxzB1gn@google.com>
References: <20220928184853.1681781-1-dmatlack@google.com>
 <20220928184853.1681781-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928184853.1681781-3-dmatlack@google.com>
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

On Wed, Sep 28, 2022, David Matlack wrote:
> @@ -114,6 +115,36 @@ void print_skip(const char *fmt, ...)
>  	puts(", skipping test");
>  }
>  
> +bool get_module_param_bool(const char *module_name, const char *param)
> +{
> +	const int path_size = 1024;
> +	char path[path_size];
> +	char value;
> +	FILE *f;
> +	int r;
> +
> +	r = snprintf(path, path_size, "/sys/module/%s/parameters/%s",
> +		     module_name, param);
> +	TEST_ASSERT(r < path_size,
> +		    "Failed to construct sysfs path in %d bytes.", path_size);
> +
> +	f = fopen(path, "r");

Any particular reason for using fopen()?  Oh, because that's what the existing
code does.  More below.

> +	TEST_ASSERT(f, "fopen(%s) failed", path);

I don't actually care myself, but for consistency this should probably be a
skip condition.  The easiest thing would be to use open_path_or_exit().

At that point, assuming read() instead of fread() does the right thin, that seems
like the easiest solution.

> +	TEST_FAIL("Unrecognized value: %c", value);

Maybe be slightly more verbose?  E.g.

	TEST_FAIL("Unrecognized value '%c' for boolean module param", value);

> +}
> +
>  bool thp_configured(void)
>  {
>  	int ret;
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 2e6e61bbe81b..522d3e2009fb 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -1294,20 +1294,9 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
>  /* Returns true if kvm_intel was loaded with unrestricted_guest=1. */
>  bool vm_is_unrestricted_guest(struct kvm_vm *vm)
>  {
> -	char val = 'N';
> -	size_t count;
> -	FILE *f;
> -
>  	/* Ensure that a KVM vendor-specific module is loaded. */
>  	if (vm == NULL)
>  		close(open_kvm_dev_path_or_exit());
>  
> -	f = fopen("/sys/module/kvm_intel/parameters/unrestricted_guest", "r");
> -	if (f) {
> -		count = fread(&val, sizeof(char), 1, f);
> -		TEST_ASSERT(count == 1, "Unable to read from param file.");
> -		fclose(f);
> -	}
> -
> -	return val == 'Y';
> +	return get_module_param_bool("kvm_intel", "unrestricted_guest");

Since there are only three possible modules, what about providing wrappers to
handle "kvm", "kvm_amd", and "kvm_intel"?  I'm guessing we'll end up with wrappers
for each param we care about, but one fewer strings to get right would be nice.
