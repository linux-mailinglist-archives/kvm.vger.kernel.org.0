Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1133B8E30
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 09:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbhGAHcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 03:32:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55362 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234679AbhGAHcj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Jul 2021 03:32:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625124609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=akFs91hhi1A8oZ8D92g4ML3qN1GuOOXjRBJuGZS6l7s=;
        b=fCQVc1DKJNquzjBslZZUGmWSOqKRnie73QFI07+hZKnh4sTC4PpltmMwPF+woeumlHI/Ih
        bzAu/8TqCQWauqxeEonc8/FLfpfawvtQ9+I57TXVOf3K8NcYNmyH+iTOPtb5b/XhZSadQz
        ka0Ki/YqrOPNV8OkWKGKhItx5FqWiMo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-o8q8xPcmNfeFed_8yw_55A-1; Thu, 01 Jul 2021 03:30:08 -0400
X-MC-Unique: o8q8xPcmNfeFed_8yw_55A-1
Received: by mail-ej1-f72.google.com with SMTP id k1-20020a17090666c1b029041c273a883dso1776473ejp.3
        for <kvm@vger.kernel.org>; Thu, 01 Jul 2021 00:30:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=akFs91hhi1A8oZ8D92g4ML3qN1GuOOXjRBJuGZS6l7s=;
        b=hknM3aBO32zE0hfODd+7CBD373c7WDQsE/z7aht1RyFk1NwObHRvgshsygKtDxtXh0
         2KNXKe7HATXZsdxfNJA6LcMrr7gvREXlB1Or5+WW5jWGAo93+k+zPAZpQaHWf8eKVYPw
         kyRd+sIhlIeaQYCtDqQJgq2khrh6A/IUcN8isz+kwIIcc63Nqi2780K1x8pRbKV8vAuN
         CExaWxySSvU6vori2NVbEse0afqewdbsj+1wSP7pwb9wVhadDpYA0+inARx/yxdIZeMJ
         I84qHmM/RHIPayOhMRvU28c68wNb+dFbWrwbItXan+RqEXbTAQQyuZFy/59YKPhDJQUc
         PxRA==
X-Gm-Message-State: AOAM531Coj0n/Z2vJwKlhdNr3xdDwgdqOdVrTIZPePz2ly6FKL03N55g
        FDhOValQSAKMJaPkfMJV/ignwHQkWuHQFirBt/8Lh1lt3MwzEAQKGazj1pjMOdgtKeC6Qa+qm5a
        9J+HhyLJxvIQF
X-Received: by 2002:a17:906:c2cf:: with SMTP id ch15mr39583782ejb.517.1625124606790;
        Thu, 01 Jul 2021 00:30:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWY5hoP/UqNDvRYBaaVbpJnN14cEuv03+nOArQxlC/XGEV3z+xbTIluUwRX6O3KYbSzHYatg==
X-Received: by 2002:a17:906:c2cf:: with SMTP id ch15mr39583772ejb.517.1625124606637;
        Thu, 01 Jul 2021 00:30:06 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id b26sm516185ejz.124.2021.07.01.00.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 00:30:06 -0700 (PDT)
Date:   Thu, 1 Jul 2021 09:30:04 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kernel-team@android.com,
        Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: selftests: x86: Address missing
 vm_install_exception_handler conversions
Message-ID: <20210701073004.uy4ch45vrqc4a2y7@gator.home>
References: <20210701071928.2971053-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210701071928.2971053-1-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 01, 2021 at 08:19:28AM +0100, Marc Zyngier wrote:
> Commit b78f4a59669 ("KVM: selftests: Rename vm_handle_exception")
> raced with a couple of new x86 tests, missing two vm_handle_exception
> to vm_install_exception_handler conversions.
> 
> Help the two broken tests to catch up with the new world.
> 
> Cc: Andrew Jones <drjones@redhat.com>
> CC: Ricardo Koller <ricarkol@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  tools/testing/selftests/kvm/x86_64/hyperv_features.c | 2 +-
>  tools/testing/selftests/kvm/x86_64/mmu_role_test.c   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> index 42bd658f52a8..af27c7e829c1 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> @@ -615,7 +615,7 @@ int main(void)
>  
>  	vm_init_descriptor_tables(vm);
>  	vcpu_init_descriptor_tables(vm, VCPU_ID);
> -	vm_handle_exception(vm, GP_VECTOR, guest_gp_handler);
> +	vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
>  
>  	pr_info("Testing access to Hyper-V specific MSRs\n");
>  	guest_test_msrs_access(vm, addr_gva2hva(vm, msr_gva),
> diff --git a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
> index 523371cf8e8f..da2325fcad87 100644
> --- a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
> @@ -71,7 +71,7 @@ static void mmu_role_test(u32 *cpuid_reg, u32 evil_cpuid_val)
>  	/* Set up a #PF handler to eat the RSVD #PF and signal all done! */
>  	vm_init_descriptor_tables(vm);
>  	vcpu_init_descriptor_tables(vm, VCPU_ID);
> -	vm_handle_exception(vm, PF_VECTOR, guest_pf_handler);
> +	vm_install_exception_handler(vm, PF_VECTOR, guest_pf_handler);
>  
>  	r = _vcpu_run(vm, VCPU_ID);
>  	TEST_ASSERT(r == 0, "vcpu_run failed: %d\n", r);
> -- 
> 2.30.2
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

Hopefully vm_install_exception_handler() has now officially won the race!

Thanks,
drew

