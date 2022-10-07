Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C5A5F7D55
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 20:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiJGS3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 14:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiJGS3l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 14:29:41 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F1BA476
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 11:29:39 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id t12-20020a17090a3b4c00b0020b04251529so5394214pjf.5
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 11:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IDSEynMZHmcuL+ncJipcoWaMqhLdNoCSxw7KjmZTzP8=;
        b=XRf/i10zTpRN2dBogv4zp51ORN2zGxrgKetdNozVqorX5fQDBQIy9wotA8vIbY+/2A
         19r1kWw0GbjvPbcoNxBVfKLEsGV9RRfnb/scJ/C4OKxks3Y2YBVE261Ha7aR/+Wv2Et6
         grZe1JKMYQB6x3nbBBtRtUNgv6zeIWYeNFosM75Cr8u0xjD9Izi3FtnL3CQLXa9ojUdX
         uMOMrJxvNa7/vz2/WS2ZTS9Ltiw9EA7FTqyFOo7b3lD988IONhOaZkb+iYnpAo0Wjn4Q
         LZ3Kyd+qx0T4JqUPpBgaK2C6aQhCfLnHeyNvjyNw1+4Aa+7H+2pgqNUof/ghGuPqqsTU
         FmLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IDSEynMZHmcuL+ncJipcoWaMqhLdNoCSxw7KjmZTzP8=;
        b=OxDRo4rzXSXnMXoVYMg2FQd7MfRt0sFP4emoXCLYEeaquyfgZrr7zuCGK7cQUUY8cW
         aR/gWm3iqp0SQV5atYm4zu/DnMnW2Y9emd9RJvwaJIDHF5yyc7/10IRjrF+v2jzMpJe5
         v+mpcfA/ft7XfoAKRYn1jjuSGnkc3myDTvRqFQsiRboMh6xl2aX5nZ4ujDSVLMrXDBQU
         bdGtsHTTtKKTKh00usU+2fKgoP8tHo2dC5Umyhyy2kjiBPYMjmAIhlq/pjc6fjmHAuqB
         i5b23zTYlciNX6PWscnFEAkGpfYOamsZgbV0HzJF9/+fBlzq+M/n4901vVqWRqtbbynQ
         Brtw==
X-Gm-Message-State: ACrzQf3A8hJVPj8WHZPi6xaAApSbml3GZoQ1Xmzgu46YpAJFKEshIDd5
        hfJ0o0KQqpOiOI30cJROKpqhLw==
X-Google-Smtp-Source: AMsMyM584F1xxNe3o/JNlIYxqdaN9jR9ovKh0w0rymYK/XdfGrlq+YwcxwQ5qX5k20T/eMJA4hVrig==
X-Received: by 2002:a17:90b:33d2:b0:20c:64e2:2ba6 with SMTP id lk18-20020a17090b33d200b0020c64e22ba6mr708561pjb.137.1665167379129;
        Fri, 07 Oct 2022 11:29:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a1-20020a170902710100b0017d12d86901sm1792066pll.187.2022.10.07.11.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 11:29:37 -0700 (PDT)
Date:   Fri, 7 Oct 2022 18:29:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v6 5/5] KVM: selftests: Add selftests for dirty quota
 throttling
Message-ID: <Y0BwDSIqPYCZZACm@google.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-6-shivam.kumar1@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220915101049.187325-6-shivam.kumar1@nutanix.com>
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

On Thu, Sep 15, 2022, Shivam Kumar wrote:
>  #endif /* SELFTEST_KVM_UTIL_BASE_H */
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 9889fe0d8919..4c7bd9807d0b 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -18,6 +18,7 @@
>  #include <linux/kernel.h>
>  
>  #define KVM_UTIL_MIN_PFN	2
> +#define PML_BUFFER_SIZE	512

...

> +	/*
> +	 * Due to PML, number of pages dirtied by the vcpu can exceed its dirty
> +	 * quota by PML buffer size.
> +	 */

Buffering for PML is very Intel centric, and even then it's not guaranteed.  In
x86, PML can and should be detected programmatically:

bool kvm_is_pml_enabled(void)
{
	return is_intel_cpu() && get_kvm_intel_param_bool("pml");
}


Not sure if it's worth a generic arch hook to get the CPU buffer size, e.g. the
test could do:


	/*
	 * Allow ??? pages of overrun, KVM is allowed to dirty multiple pages
	 * before exiting to userspace, e.g. when emulating an instruction that
	 * performs multiple memory accesses.
	 */
	uint64_t buffer = ???;

	/*
	 * When Intel's Page-Modification Logging (PML) is enabled, the CPU may
	 * dirty up to 512 pages (number of entries in the PML buffer) without
	 * exiting, thus KVM may effectively dirty that many pages before
	 * enforcing the dirty quota.
	 */
#ifdef __x86_64__
	if (kvm_is_pml_enabled(void)
		buffer = PML_BUFFER_SIZE;
#endif
	

> +	TEST_ASSERT(count <= quota + PML_BUFFER_SIZE, "Invalid number of pages

Clarify _why_ the count is invalid.

> +		dirtied: count=%"PRIu64", quota=%"PRIu64"\n", count, quota);

Don't split strings unless it's truly necessary.  This is one of those cases where
running over the 80 char soft limit is preferable to wrapping.  And no need to use
PRIu64, selftests are 64-bit only.  E.g.

	TEST_ASSERT(count <= (quota + buffer),
		    "KVM dirtied too many pages: count = %lx, quota = %lx, buffer = %lx",
		    count, quota, buffer);


> +
> +	TEST_ASSERT(count >= quota, "Dirty quota exit happened with quota yet to
> +		be exhausted: count=%"PRIu64", quota=%"PRIu64"\n", count, quota);

Similar comments here.

> +
> +	if (count > quota)
> +		pr_info("Dirty quota exit with unequal quota and count:
> +			count=%"PRIu64", quota=%"PRIu64"\n", count, quota);

Not sure I'd bother with this.  Realistically, is anyone ever going to be able to
do anything useful with this information?  E.g. is this just going to be a "PML is
enabled!" message?

> +
> +	run->dirty_quota = count + test_dirty_quota_increment;
> +}
> -- 
> 2.22.3
> 
