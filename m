Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52ABD189A9F
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 12:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgCRLaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 07:30:01 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:41553 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726905AbgCRLaA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 07:30:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584530999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E2raNO3LZvQFYBCoVG2cHroRijIinSH+Abh4Yah3yxE=;
        b=MgKZ33n2tR7WAjvjYMWe+gHMuYwnmwnxBVnEyOH9CwUJKYCDTr6hFh5zdqooJpUWpkBY6m
        x+CMOgJrAC4cyPq8EluqjRKOmzIkBh/lcWSHs++pARnapAh3CScN82y1pHn3kIyO4cJ504
        6YMfDEF4mxN/AnnrXa0+XR4HUTXK8Ms=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-OHOBnt1HM_WrqDqap-8y6w-1; Wed, 18 Mar 2020 07:29:57 -0400
X-MC-Unique: OHOBnt1HM_WrqDqap-8y6w-1
Received: by mail-wm1-f69.google.com with SMTP id n188so929924wmf.0
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 04:29:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E2raNO3LZvQFYBCoVG2cHroRijIinSH+Abh4Yah3yxE=;
        b=IB59twG2PUGjvlSszWXfR7H8cx9ZLSfjkxobWppjqawwo3qBF79YMf3m++j1Cdtfu9
         9pZv3KBxj9s3YLBTyo4z6pawiiKRy3ZUKwhQHuRQghJ3WHJV7dbf9dV+my7zSIOHzl2h
         lAAlg6zyRBjd61KDC/Sif/AG98lmehTiLHUyE49DOaHWJ5fWoqSsGJpfZLjvX6ZqVgyA
         cMyvsJHJk9qbvHIaPSVuax4QFvgpH5texoy+9ksuOpZ+2n0lwTKg7LsQJgKe0KzyEL0v
         ZF88CbZNriSuzXrfznSlV3cPdD8xtPVZQYwvH/a+3On0bKxdKuTvqJcui3RBUv6BA0R9
         vgNw==
X-Gm-Message-State: ANhLgQ38R6+6xb5PQLXK6K4LNxtoYobVSoewFxV6g/azaldd/P/qU2gp
        kP30/XcFP98gAMOXrtuQoy9lMl5flSafsqEmYJFayCw8CsbXGfFJPwjcz+zaOeKu6NFaH1CJaTD
        DPKsGdMUzHrCq
X-Received: by 2002:a05:600c:d8:: with SMTP id u24mr4879758wmm.42.1584530996277;
        Wed, 18 Mar 2020 04:29:56 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsr1aX6ZaLbIrm8qc+ZOSLlogf/y+e/yKqFJim1bY3qrXkv+Gvhpe2QqGWc8QZUfYw60gbh7w==
X-Received: by 2002:a05:600c:d8:: with SMTP id u24mr4879737wmm.42.1584530996060;
        Wed, 18 Mar 2020 04:29:56 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id u204sm3484735wmg.40.2020.03.18.04.29.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 04:29:55 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] x86: vmx: Expect multiple error codes on
 HOST_EFER corruption
To:     Nadav Amit <namit@vmware.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20200212195736.39540-1-namit@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <620bcfed-a0a1-73a6-d24f-421dce4591c9@redhat.com>
Date:   Wed, 18 Mar 2020 12:29:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200212195736.39540-1-namit@vmware.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/02/20 20:57, Nadav Amit wrote:
> Extended HOST_EFER tests can fail with a different error code than the
> expected one, since the host address size bit is checked against
> EFER.LMA. This causes kvm-unit-tests to fail on bare metal. According
> to the SDM the errors are not ordered.
> 
> Expect either "invalid control" or "invalid host state" error-codes to
> allow the tests to pass. The fix somewhat relaxes the tests, as there
> are cases when only "invalid host state" is a valid instruction error,
> but doing the fix in this manner prevents intrusive changes.
> 
> Fixes: a22d7b5534c2 ("x86: vmx_tests: extend HOST_EFER tests")
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  x86/vmx_tests.c | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 69429e5..e69c361 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -3407,6 +3407,27 @@ static void test_vmx_vmlaunch(u32 xerror)
>  	}
>  }
>  
> +/*
> + * Try to launch the current VMCS, and expect one of two possible
> + * errors (or success) codes.
> + */
> +static void test_vmx_vmlaunch2(u32 xerror1, u32 xerror2)
> +{
> +	bool success = vmlaunch_succeeds();
> +	u32 vmx_inst_err;
> +
> +	if (!xerror1 == !xerror2)
> +		report(success == !xerror1, "vmlaunch %s",
> +		       !xerror1 ? "succeeds" : "fails");
> +
> +	if (!success && (xerror1 || xerror2)) {
> +		vmx_inst_err = vmcs_read(VMX_INST_ERROR);
> +		report(vmx_inst_err == xerror1 || vmx_inst_err == xerror2,
> +		       "VMX inst error is %d or %d (actual %d)", xerror1,
> +		       xerror2, vmx_inst_err);
> +	}
> +}
> +
>  static void test_vmx_invalid_controls(void)
>  {
>  	test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_CONTROL_FIELD);
> @@ -6764,7 +6785,8 @@ static void test_efer_vmlaunch(u32 fld, bool ok)
>  		if (ok)
>  			test_vmx_vmlaunch(0);
>  		else
> -			test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
> +			test_vmx_vmlaunch2(VMXERR_ENTRY_INVALID_CONTROL_FIELD,
> +					VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>  	} else {
>  		if (ok) {
>  			enter_guest();
> 

Queued, thanks.

Paolo

