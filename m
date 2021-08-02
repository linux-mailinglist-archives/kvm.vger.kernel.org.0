Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE033DDBF7
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 17:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbhHBPKL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 11:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234281AbhHBPKK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 11:10:10 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306CCC06175F
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 08:10:01 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id u2so11681890plg.10
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 08:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C5WNlWr2BA+JxhQ5uP7aMJ5RBERtPiuLGKSHEYe5+sI=;
        b=CcMM1SCSMb7rRzN3Do0VlF2oMkiwZQ+XGFeO4P34eULW8joQ+7e01PFxPtcyS9L8Ka
         2s4Fvhea128luYbThbX/49lSq5Xf32R2jOf0t9etj2o1Pf6gbcUybkF9+ggPld0a7ssP
         QBiFm1EW+tRcz8K3jnOAN6hh8Bsq2RkCV5ddK159ThaeLiUzgx/F/YX5zPxerTUaB8Po
         ABlh1q7KMLdQbWffosOx8GNj0HylPDb8RViJwwM32rjM63YzV/gBuIYWOEd/cRXzX846
         nB2yP4Cm35CeTMcu7y3aroRRtA+nqZfEFoLsIBfUVkOQbYK8/PXBwL/ZQdy5dkcelZTR
         NoVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C5WNlWr2BA+JxhQ5uP7aMJ5RBERtPiuLGKSHEYe5+sI=;
        b=FgTJNZNC8BEjB2FeS/Sbh9vnLOK03R3OHmPvAR1KFIWFK1YpiEVS6cm/TWRbHILMuI
         Dv9eiuwwR2mVIgYmmdy3pQpSW+CL2NK9TD+DsFMa5k8NZTOJDCw3B5R062bw6Du6izwC
         //gS56us0BjBwUGdT03hdd3vPNwwk09M35i6vLWxxu0KYsplj1jeptbynK4WMPdZduBh
         8QISMUA7R7yf3tgiB+ueJROyIjzlJMe1iZeo7ZmvLIkY18ndd+RwcaNi2DjZrMz23W00
         hdznGXBAN9kruOTcWMJdlYlzSDeaOmndW9bPAsp7F66922euG52CR9CQJBGvrKp1cR2l
         Mfmg==
X-Gm-Message-State: AOAM532bgn5pHZY7iwDbUbOn8wwPwdEoqI7RmS+KRoekoAjE98dw8ChP
        CDD6K3Tg+hL0js1D43r6JPfLjg==
X-Google-Smtp-Source: ABdhPJyPbUCHsd51UrtQEu3P1CiMjdTb4lnu9kanE57p+qXB+gQSXAkuHXee7Qy9flZBvtaRtNROjg==
X-Received: by 2002:a17:90a:29a4:: with SMTP id h33mr17177475pjd.98.1627917000497;
        Mon, 02 Aug 2021 08:10:00 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u129sm5971733pfc.59.2021.08.02.08.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 08:09:59 -0700 (PDT)
Date:   Mon, 2 Aug 2021 15:09:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lara Lazier <laramglazier@gmail.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] nSVM: Added test for VGIF feature
Message-ID: <YQgKxFwd8TpdWaOc@google.com>
References: <20210722131718.11667-1-laramglazier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722131718.11667-1-laramglazier@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nit, s/Added/Add in the shortlog

On Thu, Jul 22, 2021, Lara Lazier wrote:
> When VGIF is enabled STGI executed in guest mode
> sets bit 9, while CLGI clears bit 9 in the int_ctl (offset 60h)
> of the VMCB.
> 
> Signed-off-by: Lara Lazier <laramglazier@gmail.com>
> ---

...

> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -2772,6 +2772,73 @@ static void svm_vmload_vmsave(void)
>  	vmcb->control.intercept = intercept_saved;
>  }
>  
> +static void prepare_vgif_enabled(struct svm_test *test)
> +{
> +    default_prepare(test);
> +}
> +
> +static void test_vgif(struct svm_test *test)
> +{
> +    asm volatile ("vmmcall\n\tstgi\n\tvmmcall\n\tclgi\n\tvmmcall\n\t");

While amusing, this isn't very readable :-)  The SVM tests that use this for
back-to-back VMMCALL are setting a bad example.  The space between "volatile" and
the opening "(" can go too.

	asm volatile("vmmcall\n\t"
		     "stgi\n\t"
		     "vmmcall\n\t"
		     "clgi\n\t"
		     "vmmcall\n\t");

> +

Unnecessary newline.

> +}
> +
> +static bool vgif_finished(struct svm_test *test)
> +{
> +    switch (get_test_stage(test))
> +    {
> +    case 0:
> +        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +            report(false, "VMEXIT not due to vmmcall.");
> +            return true;
> +        }
> +        vmcb->control.int_ctl |= V_GIF_ENABLED_MASK;

Setting and restoring a control flag should be done in setup/teardown, e.g. this
approach will leave V_GIF_ENABLED_MASK set if a VMMCALL check fails.

> +        vmcb->save.rip += 3;
> +        inc_test_stage(test);
> +        break;
> +    case 1:
> +        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +            report(false, "VMEXIT not due to vmmcall.");
> +            return true;
> +        }
> +        if (!(vmcb->control.int_ctl & V_GIF_MASK)) {
> +            report(false, "Failed to set VGIF when executing STGI.");
> +            vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
> +            return true;

Are the VGIF checks really fatal?   I.e. can we keep running of a STGI/CLGI test
fails?  That would allow for slightly cleaner code.

> +        }
> +        report(true, "STGI set VGIF bit.");
> +        vmcb->save.rip += 3;
> +        inc_test_stage(test);
> +        break;
> +    case 2:
> +        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +            report(false, "VMEXIT not due to vmmcall.");
> +            return true;
> +        }
> +        if (vmcb->control.int_ctl & V_GIF_MASK) {
> +            report(false, "Failed to clear VGIF when executing CLGI.");
> +            vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
> +            return true;
> +        }
> +        report(true, "CLGI cleared VGIF bit.");
> +        vmcb->save.rip += 3;
> +        inc_test_stage(test);
> +        vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
> +        break;


Something like this is more reader friendly as the boilerplate is consoliated,
abd the interesting test code is isolated in the switch statement.

	bool is_vmmcall_exit = (vmcb->control.exit_code == SVM_EXIT_VMMCALL);

	report(is_vmmcall_exit, ...);
	if (!is_vmmcall_exit)
		return true;

	switch (get_test_stage())
	{
	case 0:
		vmcb->control.int_ctl |= V_GIF_ENABLED_MASK;
		break;
	case 1:
		report(vmcb->control.int_ctl & V_GIF_MASK, ...);
		break;
	case 2:
		report(!(vmcb->control.int_ctl & V_GIF_MASK), ...);
		break;
	default:
		break;
	}

	vmcb->save.rip += 3;
	inc_test_stage(test);

	return get_test_stage() >= 3;

> +    default:
> +        return true;
> +        break;
> +    }
