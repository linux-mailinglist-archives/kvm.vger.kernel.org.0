Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEB43C1AF9
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 23:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbhGHV3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 17:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbhGHV3R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jul 2021 17:29:17 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D946C06175F
        for <kvm@vger.kernel.org>; Thu,  8 Jul 2021 14:26:34 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id a127so6742382pfa.10
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 14:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rQAnnvoaC8eHApFAvSd/nP3aTqxgvWHcYG/mTAuuti4=;
        b=DoZ3Bs4oWEjjtbYytrKyampzHkzkAXFi0nm3pBtfTrdSZomnErw2UpPSVTnXQK6bXx
         LunSj5+CDCk3OlEOmFbzDBMhn/I+Of/3+PTBkXb4f8u/3EAbX/MRE3q/p7J1xA/z5fcA
         9B8eVA9bDxARsg2qunnVweUW5KbxhcArAqWeT0ApfZVsj2+dq2u7CPaZH63i0Nr1Ircm
         gzWrxImtwHnH010MQOxByBX6WDc5NnmarE9e++d+fGVcscHCSsA40VwhNfMYJRTBn6VB
         03Nh+OSY73Y6NmkpsRmXJ5eOVNtv5z6k7bsLXTZrbmp7FezRPGP928WmumpcOlNmoUgh
         4kdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rQAnnvoaC8eHApFAvSd/nP3aTqxgvWHcYG/mTAuuti4=;
        b=MpIPkAWwziXtvDKwOAlijo1ocYCLICVD745nwp8IpbF3mrcmhHs0sLk85JHV5GV9SC
         02KM39tuVSb+30uKlQMhNjQ+HiYcyADlgZCfDfXJk4+areqRAS3jGnYLyRo2PTvJrw7F
         3YE0F9vXc+S8Yqn4V3/YrRYQnhE+ED2Wwb97B8jqAJFW3NIob3YznAf+s5AV0noEkxW5
         30+A4zu4dI7T/qN8JwaIeTCxxofuIwMM2PzPcjZQ+NkxrMxxey3ROVjC1YagnxCngNGd
         Mbn34Jgi4yCkvKhV9e0w0WWMN8gv0Sz6OReZ7x+2Vie4faeFyvJ1xUoGYkLUyLfXfZQJ
         /s1Q==
X-Gm-Message-State: AOAM532n4ckKWOOBuKwX+OCM4fzDza12YQmXkWTKf7sn6NnzvFOO3q5m
        epnsgamGIwYINAgN5OJRRGYquIH8zxX8dA==
X-Google-Smtp-Source: ABdhPJzuiodYeME9Gftuqrjcs7yCjGYG+82ue8gYMlmuHdBSe3M85S4FRgLK1NsIv1nFokFFlwCEBg==
X-Received: by 2002:a65:6658:: with SMTP id z24mr34008728pgv.266.1625779593363;
        Thu, 08 Jul 2021 14:26:33 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id 10sm3912836pfh.174.2021.07.08.14.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 14:26:32 -0700 (PDT)
Date:   Thu, 8 Jul 2021 21:26:29 +0000
From:   David Matlack <dmatlack@google.com>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v1 3/4] KVM: selftests: Add checks for histogram stats
 parameters
Message-ID: <YOdthbpO6fG53yBa@google.com>
References: <20210706180350.2838127-1-jingzhangos@google.com>
 <20210706180350.2838127-4-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210706180350.2838127-4-jingzhangos@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 06, 2021 at 06:03:49PM +0000, Jing Zhang wrote:
> The hist_param field should be zero for simple stats and 2 for
> logarithmic histogram. It shouldbe non-zero for linear histogram stats.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  .../selftests/kvm/kvm_binary_stats_test.c       | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> index 5906bbc08483..03c7842fcb26 100644
> --- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> +++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> @@ -109,6 +109,23 @@ static void stats_test(int stats_fd)
>  		/* Check size field, which should not be zero */
>  		TEST_ASSERT(pdesc->size, "KVM descriptor(%s) with size of 0",
>  				pdesc->name);
> +		/* Check hist_param field */
> +		switch (pdesc->flags & KVM_STATS_TYPE_MASK) {
> +		case KVM_STATS_TYPE_LINEAR_HIST:
> +			TEST_ASSERT(pdesc->hist_param,
> +			    "Bucket size of Linear Histogram stats (%s) is zero",
> +			    pdesc->name);
> +			break;
> +		case KVM_STATS_TYPE_LOG_HIST:
> +			TEST_ASSERT(pdesc->hist_param == 2,
> +				"Base of Log Histogram stats (%s) is not 2",
> +				pdesc->name);
> +			break;
> +		default:
> +			TEST_ASSERT(!pdesc->hist_param,
> +			    "Simple stats (%s) with hist_param of nonzero",
> +			    pdesc->name);
> +		}
>  		size_data += pdesc->size * sizeof(*stats_data);
>  	}
>  	/* Check overlap */
> -- 
> 2.32.0.93.g670b81a890-goog
> 
