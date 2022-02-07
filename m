Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25654ACB57
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 22:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbiBGVaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 16:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240421AbiBGVaX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 16:30:23 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F9AC043181
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 13:30:23 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id t4-20020a17090a510400b001b8c4a6cd5dso474637pjh.5
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 13:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SJlxGotQNLYMsIorLZ1IC7vukOuj4FuT0Pyrq4D+HqI=;
        b=RuHNhRrQ91iF8BFOx76KVUtJNlpQ+iSwLNWSH3V4I/LOTuDNnjDz/7Zl7WrAMDrPgw
         E9Sw2khUe9HWC81C5d8IxkOKCxKCnFNc91hBXpLow7NAX+JmUrlLRpdSl8j860GuoPXe
         6uJI9JcE8guM3wpg7QQjTUG8WWRn84yICAzvY1xgVkSXi1vKNrOz/OieGEDDYUSgFCNz
         jVapwRQERj7OIJgPBNwW7qrWaMT0xfFCFL618Gvf9qmFkHoc3byrXk4I4xzq1u97/6EN
         +e+3AgyHAQfRpppPH65MSsfDlM3Q/GQ0gj1SLpXvdr9LSlteZdyjorvc1Z+oSKPLJZPz
         UHbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SJlxGotQNLYMsIorLZ1IC7vukOuj4FuT0Pyrq4D+HqI=;
        b=acAdJ06v3m8NpI6IB51BXSQNt4WHiZA1bcgChu0ZLXGGEozetEdgdpIVXgnwSLJIne
         VEIR4m++6HalhhuIPrb0SvFAEJR5A7xKz/43muC72A0JtakNTBhYLmDp2vLWAP8U/pmC
         k5ZLDxCMCy3hTzj9dpIlbqIp0cNDEYVCKrGwfBzXe0mcMX/+6Fwtsl7WjpMygaZ4Wtgh
         INTbMk6NB0QD4T3S1rCMD1DQxUOjRbFCMSZ4mWuFff3PxZeNG0B8+F3NazAUQBHkv+rY
         04LumdQtq6uAXuo3KIL+q4TtVlfSIcWSJ3DFhFXnVlWPi37bqQE+Gs+aO799CgosKHzg
         FSfA==
X-Gm-Message-State: AOAM532vXqycOjQt9ouNO0ggMMe3gq5Wy2+OQNa6JhAL5QtY6S0hDM5c
        yrb5fioJ/ip3MIHnbzQGum2qucSVZL9uGQ==
X-Google-Smtp-Source: ABdhPJxhlIBecjNXRZ+uXmELBSS+4bRFekG96ZBZrDppcc2ToJqbRJJl9rwjExgEyzgwWPhjsNTzKw==
X-Received: by 2002:a17:90b:4f85:: with SMTP id qe5mr952699pjb.142.1644269422337;
        Mon, 07 Feb 2022 13:30:22 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mj21sm287387pjb.20.2022.02.07.13.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 13:30:21 -0800 (PST)
Date:   Mon, 7 Feb 2022 21:30:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Cathy Avery <cavery@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests v2 PATCH] vmx: Fix EPT accessed and dirty flag
 test
Message-ID: <YgGParjmY9X3G6+z@google.com>
References: <20220202135509.3286-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202135509.3286-1-cavery@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 02, 2022, Cathy Avery wrote:
> If ept_ad is not supported by the processor or has been
> turned off via kvm module param, test_ept_eptp() will
> incorrectly leave EPTP_AD_FLAG set in variable eptp
> causing the following failures of subsequent
> test_vmx_valid_controls calls:
> 
> FAIL: Enable-EPT enabled; reserved bits [11:7] 0: vmlaunch succeeds
> FAIL: Enable-EPT enabled; reserved bits [63:N] 0: vmlaunch succeeds

Heh, the changelog never actually provides info on how it fixes things.

  Use the saved EPTP to restore the EPTP after each sub-test instead of
  manually unwinding what was done by the sub-test, which is error prone
  and hard to follow.

  Explicitly setup a dummy EPTP, as calling the test in isolation will cause
  test failures due to lack a good starting EPTP.

> Signed-off-by: Cathy Avery <cavery@redhat.com>
> ---
> 
> * Changes in v2:
> 
> - Initialize vmcs EPTP to good values for page walk len
>   and ept memory type.
> - Restore eptp to known good values from eptp_saved
> - Cleanup test_vmx_vmlaunch to generate clearer and
>   more consolidated test reports.
>   New format suggested by seanjc@google.com
> ---
>  x86/vmx_tests.c | 39 +++++++++++++++++++++++----------------
>  1 file changed, 23 insertions(+), 16 deletions(-)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 3d57ed6..1269829 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -3392,14 +3392,21 @@ static void test_vmx_vmlaunch(u32 xerror)
>  	bool success = vmlaunch_succeeds();
>  	u32 vmx_inst_err;
>  
> -	report(success == !xerror, "vmlaunch %s",
> -	       !xerror ? "succeeds" : "fails");
> -	if (!success && xerror) {
> -		vmx_inst_err = vmcs_read(VMX_INST_ERROR);
> +	if (!success)
> +	vmx_inst_err = vmcs_read(VMX_INST_ERROR);
> +
> +	if (success && !xerror)
> +		report_pass("VMLAUNCH succeeded as expected");
> +	else if (success && xerror)
> +		report_fail("VMLAUNCH succeeded unexpectedly, wanted VM-Fail with error code = %d",
> +			    xerror);
> +	else if (!success && !xerror)
> +		report_fail("VMLAUNCH hit unexpected VM-Fail with error code = %d",
> +			    vmx_inst_err);
> +	else
>  		report(vmx_inst_err == xerror,
> -		       "VMX inst error is %d (actual %d)", xerror,
> -		       vmx_inst_err);
> -	}
> +		       "VMLAUNCH hit VM-Fail as expected, wanted error code %d, got %d",
> +		       xerror, vmx_inst_err);
>  }

The changes to test_vmx_vmlaunch() need to be a separate patch.  The addition of
setup_dummy_ept() would ideally be separate as well, though I don't care terribly
about that one.

With this split in two (or three) and an updated changelog,

Reviewed-by: Sean Christopherson <seanjc@google.com>
