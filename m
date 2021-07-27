Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17043D6AF5
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 02:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbhGZXjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 19:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbhGZXjw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 19:39:52 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6017DC061757
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 17:20:19 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d1so6449112pll.1
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 17:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wVBlAfYVK+A67kfMW0lEOQriseReOLvaoenkbvG2knc=;
        b=wHEU18aPHZ42XHn2LP1jdMAKi36laPIyQGRSMe6yIkrPjI5ELNCWGcV+liCJlFVn/P
         Js+bgZ8RFHdLqIOmT5xZTZ6nBpKfjTrnpaPM6lwSRxT3sYrcUDC0AVOqGsHATwmOsjK7
         QRfAk47bzEZQzFskUi0iTYQBUSm8Yk9dyliz9FpwhlfvivR6u28J16fqBU56PsMp0e2C
         F98FUgR+b2CQqONrpZ4ED+aaPgQKUxfwCGiyDijnpVqfbuQRqWMorB38/PPnmCavTe58
         6ZPFlfnr5qfCC9mSbb27px4dZL0wjf65g2hF0jBcjfmB+AECh25wawtjWQqRj3+q2USe
         x9SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wVBlAfYVK+A67kfMW0lEOQriseReOLvaoenkbvG2knc=;
        b=bWEwf9DL34Wp76Q6Hyvq/kAvMVaX5p532865B5fHuJvQLg0PApRRuYUeXG/3QFi87y
         ya+FPyhBvzv76PIwo17JH/pfKhsP7v9hfZXi5ZwcSKDC3HwUwUZgwlRZc+bQSBlRfHrf
         oJ3TV6nhtbjowwjY2TYSVepr4Bm0xoJVPmGARkGVkd67Av0YaMwuKuJP/K4U5KdjMd9u
         s3DC7a11o+xMmJpTLI9pWIdY2rqTsrmOeMvA9uMZgenFnBLGKD9Lc2Q0ve/M+vpxNzFt
         6YiRaDjqR+x4/hw/5wpIHICvQbB6zXmMz6pub26yupbdQc7wmZkz86T1RHGu91n4UZ4E
         0dnA==
X-Gm-Message-State: AOAM530jNsE5z19VnMvdOe+w9eAl3OuoKu1I8a0V63ZCEzC8pDeVfA7r
        DTo63su76JXHGN77q84r71ao3cfJ9OtlZw==
X-Google-Smtp-Source: ABdhPJzzGhdBgbvjjb6YYtbE5xZldpXSwPXqDbRWufpf/tr5jKUweHe5W6mpANOpcbJf/tOv/gNrZA==
X-Received: by 2002:a17:90a:bd06:: with SMTP id y6mr19746071pjr.6.1627345218696;
        Mon, 26 Jul 2021 17:20:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k37sm1020335pgm.84.2021.07.26.17.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 17:20:18 -0700 (PDT)
Date:   Tue, 27 Jul 2021 00:20:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     kvm@vger.kernel.org, bsd@redhat.com
Subject: Re: [kvm-unit-tests PATCH] x86: vmx_tests: pml: Skip PML test if
 it's not enabled in underlying
Message-ID: <YP9RPhWwI1At3fLX@google.com>
References: <1627179854-1878-1-git-send-email-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1627179854-1878-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jul 25, 2021, Robert Hoo wrote:
> PML in VM depends on "enable PML" in VM-execution control, check this
> before vmwrite to PMLADDR, because this field doesn't exist if PML is
> disabled in VM-execution control.

No, the field doesn't exist if the CPU doesn't support PML.  Whether or not PML
is enabled in the execution controls is irrelevant.  pml_init() checks for both
secondary execution controls and PML support (with bad indentation).

	if (!(ctrl_cpu_rev[0].clr & CPU_SECONDARY) ||
		!(ctrl_cpu_rev[1].clr & CPU_PML)) {
		printf("\tPML is not supported");
		return VMX_TEST_EXIT;
	}

	pml_log = alloc_page();
	vmcs_write(PMLADDR, (u64)pml_log);
	vmcs_write(GUEST_PML_INDEX, PML_INDEX - 1);

> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> ---
>  x86/vmx_tests.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 4f712eb..8663112 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -1502,13 +1502,16 @@ static int pml_init(struct vmcs *vmcs)
>  		return VMX_TEST_EXIT;
>  	}
>  
> +	ctrl_cpu = vmcs_read(CPU_EXEC_CTRL1) & CPU_PML;
> +	if (!ctrl_cpu) {
> +		printf("\tPML is not enabled\n");
> +		return VMX_TEST_EXIT;
> +	}
> +
>  	pml_log = alloc_page();
>  	vmcs_write(PMLADDR, (u64)pml_log);
>  	vmcs_write(GUEST_PML_INDEX, PML_INDEX - 1);
>  
> -	ctrl_cpu = vmcs_read(CPU_EXEC_CTRL1) | CPU_PML;
> -	vmcs_write(CPU_EXEC_CTRL1, ctrl_cpu);
> -
>  	return VMX_TEST_START;
>  }
>  
> -- 
> 1.8.3.1
> 
