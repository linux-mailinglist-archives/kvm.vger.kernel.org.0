Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0973B9585
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 19:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbhGARbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 13:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbhGARbp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 13:31:45 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38A4C061762
        for <kvm@vger.kernel.org>; Thu,  1 Jul 2021 10:29:13 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so4368515pjo.3
        for <kvm@vger.kernel.org>; Thu, 01 Jul 2021 10:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1IJtpsVcytmCjAYZJRNbaDAnaK0qMOEWAnoO2DngMDc=;
        b=RPoOY+HP5qTgxbrCak3zwbbLkTPbRrYBM2JJOBv7sA45Zb4zepOmeqy0QMnMcjLb5j
         udBgrbxMsxKtC6IwltG3FDR2vDdsVQLD0CRRVYn8YGQBtdqdt+wC4/+tkEiV1qAf28rK
         S0dtWpPANJhkLvj+I0yB/MB1/AjPw3PLbg+E1si1c86//lJ2kgPSowgnHTxqnVYtV7Ro
         ipJc/YNRkMHLMV/x2t8u4wSjfe5lPtfPa5ISTaV4msIjPwAamDTq8Y9NwkqrvqTM0bOf
         o1lTN1ROo6NNka2WuKsBMPFRbT//Ldr9ReKtGn+rx/Et0mpr6anU5HaIjJZ1CETEwwK3
         ykdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1IJtpsVcytmCjAYZJRNbaDAnaK0qMOEWAnoO2DngMDc=;
        b=uLmd2flZn7iQz8tPyswOkkGpz1JiTxLIFHKjteTzNXEeDTG4P6rDSObRDv7qQ8Nhrp
         wixs8WjJomBXg+4pXZnuR3/EnrFWYu/hrGNMMFHNQ+3PuXSflSp9u32CghlgdFfiZ1qU
         XkciirrXgmOtMDq5DLfQza9NybvcRZm6mxZnPQ4I7rvGBsnHjJGfGSVUScoRn/omgGsP
         l6Io7WKsTuj6nJU4rrN3t0105iPIAt43OsGgPDwKxYjaioWgS1nLhE0n1v+Y8JDit0RJ
         4/rVJIiYofNL7sH4KC7sI1yIMNXV/LrXRI5L2mw0/+VukYbo/yfgSPzAM/DsDX2W5QCJ
         aBwA==
X-Gm-Message-State: AOAM530DiP5X/T+MrZf3mA2mzgRj9PBiJqF56RYgobwmDqwUjqIpbcGb
        DfOSr+PCfUOYJS1HKwYA0ufEVQ==
X-Google-Smtp-Source: ABdhPJzM3sOnNr4h5T9lf3f3fVbfhY6J151kPDfM6N/6JK1fqSYAmBBfSg9Uy8kcPa6rRGDgzfaDLQ==
X-Received: by 2002:a17:902:b7c2:b029:128:c1cd:241e with SMTP id v2-20020a170902b7c2b0290128c1cd241emr689364plz.14.1625160553006;
        Thu, 01 Jul 2021 10:29:13 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id t3sm598566pfl.44.2021.07.01.10.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 10:29:12 -0700 (PDT)
Date:   Thu, 1 Jul 2021 10:29:09 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        kernel-team@android.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: selftests: x86: Address missing
 vm_install_exception_handler conversions
Message-ID: <YN37ZaayVZjPH4n1@google.com>
References: <20210701071928.2971053-1-maz@kernel.org>
 <20210701073004.uy4ch45vrqc4a2y7@gator.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210701073004.uy4ch45vrqc4a2y7@gator.home>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 01, 2021 at 09:30:04AM +0200, Andrew Jones wrote:
> On Thu, Jul 01, 2021 at 08:19:28AM +0100, Marc Zyngier wrote:
> > Commit b78f4a59669 ("KVM: selftests: Rename vm_handle_exception")
> > raced with a couple of new x86 tests, missing two vm_handle_exception
> > to vm_install_exception_handler conversions.
> > 
> > Help the two broken tests to catch up with the new world.
> > 
> > Cc: Andrew Jones <drjones@redhat.com>
> > CC: Ricardo Koller <ricarkol@google.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  tools/testing/selftests/kvm/x86_64/hyperv_features.c | 2 +-
> >  tools/testing/selftests/kvm/x86_64/mmu_role_test.c   | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> > index 42bd658f52a8..af27c7e829c1 100644
> > --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> > +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> > @@ -615,7 +615,7 @@ int main(void)
> >  
> >  	vm_init_descriptor_tables(vm);
> >  	vcpu_init_descriptor_tables(vm, VCPU_ID);
> > -	vm_handle_exception(vm, GP_VECTOR, guest_gp_handler);
> > +	vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
> >  
> >  	pr_info("Testing access to Hyper-V specific MSRs\n");
> >  	guest_test_msrs_access(vm, addr_gva2hva(vm, msr_gva),
> > diff --git a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
> > index 523371cf8e8f..da2325fcad87 100644
> > --- a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
> > @@ -71,7 +71,7 @@ static void mmu_role_test(u32 *cpuid_reg, u32 evil_cpuid_val)
> >  	/* Set up a #PF handler to eat the RSVD #PF and signal all done! */
> >  	vm_init_descriptor_tables(vm);
> >  	vcpu_init_descriptor_tables(vm, VCPU_ID);
> > -	vm_handle_exception(vm, PF_VECTOR, guest_pf_handler);
> > +	vm_install_exception_handler(vm, PF_VECTOR, guest_pf_handler);
> >  
> >  	r = _vcpu_run(vm, VCPU_ID);
> >  	TEST_ASSERT(r == 0, "vcpu_run failed: %d\n", r);
> > -- 
> > 2.30.2
> >
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> 
> Hopefully vm_install_exception_handler() has now officially won the race!
> 
> Thanks,
> drew
> 

Reviewed-by: Ricardo Koller <ricarkol@google.com>

Thanks!
Ricardo
