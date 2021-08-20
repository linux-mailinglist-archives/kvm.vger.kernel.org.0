Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFA13F3770
	for <lists+kvm@lfdr.de>; Sat, 21 Aug 2021 01:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239025AbhHTXuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 19:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbhHTXuy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 19:50:54 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C69C061575
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 16:50:15 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id l11so6865437plk.6
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 16:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PlnsturUjPgqEunt42wgadCO1dYcV5yvVTufXahXHZM=;
        b=ig8mBGB54P2iWRrMNXzGcF0wHSCu2C24e0Z+0PHN1eJioLpKYCRSYG5dj7NaydhmtN
         Zm7pdyIUrFA3hnji8EpqUvo+Wbs7XOCAIRrNH+JuoxtDLKqpFBW4dSRF4W/kO5ZVFbzb
         jrDbkwNquofeHVFm5cGmQS7XXZykM9AVwb7FrAoDWldAXwsjoIsQaw6x2SVs/XSLpoN2
         3wVasQ+itwnLMqjgi7U092YMfFnSf18/PUhFB7cTB+jUM3V24y0NFDan7N1Jej60Lfwm
         P2Ea5Yb1jXaB9xq7eLLPcf6gVQNBoouYzVsCD6UpYY6Ett1jCiO6/hZN9bFIMH8BfVcY
         ht5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PlnsturUjPgqEunt42wgadCO1dYcV5yvVTufXahXHZM=;
        b=XFLnCalbkF/YCUXuaHo1UM5A8gQ9Z6UyOnRpp7ec2YCvDInX/q/dkbX7cSEK0pJlu4
         eQihM6he6ixKoXqVcTUU5ZpPvxoPgMjOiAQRPcj3exru/XEC41pmi2mQSDyDcKpHIIkY
         YNduXyT/44mLkdCXwEFQrg+ratKwp0pFuF5RVgHSqGR3/F4OqbQhbC+/MJbnNAYud4Vu
         B3puUlW2InYZi2tFCkOsTqOXKV0t1a+apIt53x3Um3GmweYUahRE6e+1MACjFbmSIQaX
         xaMWtd2oJVcGrZuS9afokN8XNK8E6nJLQcghH/MW5z69SKemm4zKuBglvNKO6rVJO2wk
         UvuQ==
X-Gm-Message-State: AOAM5319zltwDFuMiQSBpJGyuwNvl+sUJ/oDjGBATtzlc7+N/q8Aqr26
        HhX+oQYQ1sPrriEDDp3UG6I0Nw==
X-Google-Smtp-Source: ABdhPJzxThBX8laoFxDrJ+7mkcnExW3pjpXMmB+MUlfDlotHDf5Iii9uUAnBbBx7JWPLa4Iil/Z4vA==
X-Received: by 2002:a17:90a:d814:: with SMTP id a20mr3816710pjv.130.1629503414969;
        Fri, 20 Aug 2021 16:50:14 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p10sm7812542pjv.39.2021.08.20.16.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 16:50:14 -0700 (PDT)
Date:   Fri, 20 Aug 2021 23:50:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zixuan Wang <zixuanwang@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
Subject: Re: [kvm-unit-tests RFC 14/16] x86 AMD SEV-ES: Copy UEFI #VC IDT
 entry
Message-ID: <YSA/sYhGgMU72tn+@google.com>
References: <20210818000905.1111226-1-zixuanwang@google.com>
 <20210818000905.1111226-15-zixuanwang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818000905.1111226-15-zixuanwang@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 18, 2021, Zixuan Wang wrote:
> AMD SEV-ES introduces a new #VC exception that handles the communication
> between guest and host.  UEFI already implements a #VC handler so there
> is no need to re-implement it in KVM-Unit-Tests. To reuse this #VC
> handler, this commit reads UEFI's IDT, copy the #VC IDT entry into
> KVM-Unit-Tests' IDT.
> 
> In this commit, load_idt() can work and now guest crashes in
> setup_page_table(), which will be fixed by follow-up commits.

As a stop gap to get SEV testing of any kind enabled, I think piggybacking the
vBIOS #VC handler is a great idea.  But long term, kvm-unit-tests absolutely
needs to have its own #VC handler.

In addition to the downsides Joerg pointed out[*], relying on an external #VC
introduces the possibility of test failures that are tied to the vBIOS being
used.  Such dependencies already exist to some extent, e.g. using a buggy QEMU or
SeaBIOS could certainly introduce failures, but those components are far more
mature and less likely to break in weird ways unique to a specific test.

Another potential issue is that it's possible vBIOS will be enlightened to the
point where it _never_ expects a #VC, e.g. does #VMGEXIT directly, and thus panics
on any #VC instead of requesting the necessary emulation.

Fixing the vBIOS image in the repo would mostly solve those problems, but it
wouldn't solve the lack of flexibility for the #VC handler, and debugging a third
party #VC handler would likely be far more difficult to debug when failures
inevitably occur.

So, if these shenanigans give us test coverage now instead of a few months from
now, than I say go for it.  But, we need clear line of sight to a "native" #VC
handler, confidence that it will actually get written in a timely manner, and an
easily reverted set of commits to unwind all of the UEFI stuff.

[*] https://lkml.kernel.org/r/YRuURERGp8CQ1jAX@suse.de

> Signed-off-by: Zixuan Wang <zixuanwang@google.com>
> ---
>  lib/x86/amd_sev.c | 10 ++++++++++
>  lib/x86/amd_sev.h |  5 +++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
> index c2aebdf..04b6912 100644
> --- a/lib/x86/amd_sev.c
> +++ b/lib/x86/amd_sev.c
> @@ -46,11 +46,21 @@ EFI_STATUS setup_amd_sev(void)
>  
>  #ifdef CONFIG_AMD_SEV_ES
>  EFI_STATUS setup_amd_sev_es(void){
> +	struct descriptor_table_ptr idtr;
> +	idt_entry_t *idt;
> +
>  	/* Test if SEV-ES is enabled */
>  	if (!(rdmsr(MSR_SEV_STATUS) & SEV_ES_ENABLED_MASK)) {
>  		return EFI_UNSUPPORTED;
>  	}
>  
> +	/* Copy UEFI's #VC IDT entry, so KVM-Unit-Tests can reuse it and does

Nit, multiline comments should have a leading bare /*, i.e.

	/*
	 * Copy ....
	 * not have to ...

> +	 * not have to re-implement a #VC handler
> +	 */
> +	sidt(&idtr);
> +	idt = (idt_entry_t *)idtr.base;
> +	boot_idt[SEV_ES_VC_HANDLER_VECTOR] = idt[SEV_ES_VC_HANDLER_VECTOR];
> +
>  	return EFI_SUCCESS;
>  }
>  
> diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
> index 4d81cae..5ebd4a6 100644
> --- a/lib/x86/amd_sev.h
> +++ b/lib/x86/amd_sev.h
> @@ -36,6 +36,11 @@
>  #define SEV_ENABLED_MASK    0b1
>  #define SEV_ES_ENABLED_MASK 0b10
>  
> +/* AMD Programmer's Manual Volume 2
> + *   - Section "#VC Exception"
> + */
> +#define SEV_ES_VC_HANDLER_VECTOR 29
> +
>  EFI_STATUS setup_amd_sev(void);
>  #ifdef CONFIG_AMD_SEV_ES
>  EFI_STATUS setup_amd_sev_es(void);
> -- 
> 2.33.0.rc1.237.g0d66db33f3-goog
> 
