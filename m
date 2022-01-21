Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C25496250
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 16:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381679AbiAUPuU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 10:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381669AbiAUPuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 10:50:19 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A0DC06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 07:50:19 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id y27so5090949pfa.0
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 07:50:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BbmBFDQzxivSJA07l3KJYJuESCQjxWVZmOoKDKEGWWk=;
        b=ZId9X/h2onRFuyw3sL9UOLfVJmuGyAE7I9NWU0kQpqhW1AtL2eAqEwi7hUR/1iItV6
         JogcW9nCuKaNgLNhucWr4FKs41YCjq3eptWJQ4YtohmVMR2WSs9AWvniKjyVZkEVXs2D
         dYFE617eF/HmPtmTQ20DgCzueM9dRVwPEn456xUCuuFhtSsNp+smwqVegkaXXlncUPKs
         YMjOEnBm4DjBqUFPDaj9Oio4NdqDLt6b3JLS1KT7+LCZE/BVIrqISh8EPgouCKABgwNx
         IrEOWNXJd6aA+3aTyDt9DUVvDygN4L6JHxsHODI3fqIXifJ0Ql7BFwMV21mkN/rQoTgs
         hGZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BbmBFDQzxivSJA07l3KJYJuESCQjxWVZmOoKDKEGWWk=;
        b=fNXDEOWPDZ2ZF07zRmuV2dsXbfR1rxnbx6H4U3/ql39rWYFnnDCnud7hU9G2KGHcCO
         USgbjxcAD/c/PIfcIbNIfQNmCGXzmSfD7a1mQkE7XuHFixXGAl0ivq8K+by8B+bTyrD9
         TKWE4ztfNayI8mz69EMVHMtkCDtIemFRerdfXkVFGxH4SF1AdsWPXIEP4jeh/aMXx7MX
         K2HV3zvm215GHYdXlfwgRt/lC5Y0IRACfF4odM2GWBXM3Swiix4zWbg1ZFPW00oDiTgK
         FDdi0mcekZSR/bB5SYAEzM9raitane+u7I7CMWwRGxBiSqxRYqLgAYrnVLzf2fPoy2jl
         wC/A==
X-Gm-Message-State: AOAM5315XUoIulZDzy4mQQ3/jMHEvK7ixTzwYbgsd/BCSu60ITlJ7PsJ
        qprC235gJ+vP7Og8whvbdTNu2iabuEmSOg==
X-Google-Smtp-Source: ABdhPJziGlY+Lhky+lAme8JhShtCeZWSvLcNNUJbsRIMb04P3NsZft67Rq74T4mS1dLqQ0fOaSbRsw==
X-Received: by 2002:a63:ed01:: with SMTP id d1mr1192700pgi.145.1642780218647;
        Fri, 21 Jan 2022 07:50:18 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 202sm5518969pga.72.2022.01.21.07.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 07:50:17 -0800 (PST)
Date:   Fri, 21 Jan 2022 15:50:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Cathy Avery <cavery@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] vmx: Fix EPT accessed and dirty flag test
Message-ID: <YerWNpFyFjJFtKHF@google.com>
References: <20220121153408.2332-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121153408.2332-1-cavery@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 21, 2022, Cathy Avery wrote:
> If ept_ad is not supported by the processor or has been
> turned off via kvm module param, test_ept_eptp() will
> incorrectly leave EPTP_AD_FLAG set in variable eptp
> causing the following failures of subsequent
> test_vmx_valid_controls calls:
> 
> FAIL: Enable-EPT enabled; reserved bits [11:7] 0: vmlaunch succeeds
> FAIL: Enable-EPT enabled; reserved bits [63:N] 0: vmlaunch succeeds
> 
> Signed-off-by: Cathy Avery <cavery@redhat.com>
> ---
>  x86/vmx_tests.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 3d57ed6..54f2aaa 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -4783,6 +4783,7 @@ static void test_ept_eptp(void)
>  
>  		eptp |= EPTP_AD_FLAG;
>  		test_eptp_ad_bit(eptp, false);
> +		eptp &= ~EPTP_AD_FLAG;
>  	}

Heh, or we could get cute and do:

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index e67eaea..9a8f7c2 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4785,11 +4785,11 @@ static void test_ept_eptp(void)
                test_eptp_ad_bit(eptp, true);
        } else {
                report_info("Processor does not supports accessed and dirty flag");
-               eptp &= ~EPTP_AD_FLAG;
-               test_eptp_ad_bit(eptp, true);
-
                eptp |= EPTP_AD_FLAG;
                test_eptp_ad_bit(eptp, false);
+
+               eptp &= ~EPTP_AD_FLAG;
+               test_eptp_ad_bit(eptp, true);
        }

        /*


More seriously, I would much prefer we use eptp_saved to restore the known good
eptp instead of manually clearing the bits that were set.  Does this work?

---
 x86/vmx_tests.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index e67eaea..8116b0c 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4749,8 +4749,7 @@ static void test_ept_eptp(void)
 			test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
-
-	eptp = (eptp & ~EPT_MEM_TYPE_MASK) | 6ul;
+	eptp = eptp_saved;

 	/*
 	 * Page walk length (bits 5:3).  Note, the value in VMCS.EPTP "is 1
@@ -4769,9 +4768,7 @@ static void test_ept_eptp(void)
 			test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
-
-	eptp = (eptp & ~EPTP_PG_WALK_LEN_MASK) |
-	    3ul << EPTP_PG_WALK_LEN_SHIFT;
+	eptp = eptp_saved;

 	/*
 	 * Accessed and dirty flag (bit 6)
@@ -4791,6 +4788,7 @@ static void test_ept_eptp(void)
 		eptp |= EPTP_AD_FLAG;
 		test_eptp_ad_bit(eptp, false);
 	}
+	eptp = eptp_saved;

 	/*
 	 * Reserved bits [11:7] and [63:N]
@@ -4809,8 +4807,7 @@ static void test_ept_eptp(void)
 			test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
-
-	eptp = (eptp & ~(EPTP_RESERV_BITS_MASK << EPTP_RESERV_BITS_SHIFT));
+	eptp = eptp_saved;

 	maxphysaddr = cpuid_maxphyaddr();
 	for (i = 0; i < (63 - maxphysaddr + 1); i++) {
@@ -4829,6 +4826,7 @@ static void test_ept_eptp(void)
 			test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
+	eptp = eptp_saved;

 	secondary &= ~(CPU_EPT | CPU_URG);
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
--

