Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7806B3C1779
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 18:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhGHQ45 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 12:56:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47585 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229469AbhGHQ44 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 12:56:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625763254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mxB1ViFzyzUHGo17PYe+ViblmtcgtxcvfbutT2UIddM=;
        b=akm1mhylBNsE0fBql33m3kLVPQ4jgqweFV8MdlVojbxkG0i8pNth1xe8OrXgetxyEi+2jB
        HFE5iCQTCR+U2680vtabysNWr7zEFeUOzz2eP+wMdF9q+fqtvz/orOoFd4TtetIWm0nF6b
        se4SP4fGLEt8qlit7J2Te7BOHalY0iw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-e7a39JhgO5avPyMOvNqELw-1; Thu, 08 Jul 2021 12:54:13 -0400
X-MC-Unique: e7a39JhgO5avPyMOvNqELw-1
Received: by mail-ed1-f69.google.com with SMTP id j25-20020aa7ca590000b029039c88110440so3617101edt.15
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 09:54:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mxB1ViFzyzUHGo17PYe+ViblmtcgtxcvfbutT2UIddM=;
        b=AkPk9Ng3OlYGrCeLeg8hNlxZHg9x9zViTVSBT0Q3whaQto0V+5UsQysonlNOVjwbyh
         pXzzCXq2aPjxfddcLRAMpQbRCOvHBALLdJzObmlZtISljC5T/DrvAl0W5Yjg3Oum3E63
         GlfCkUAy/HAn0NWGQUoEAujow843m9YmPJQG+Bsamu2bh0t50h1u8dpfD3tt11PDWQ5R
         WbbjHoOvV6fJH6uXssCuyyxKnAxP4O/2zyxDDmp9E3A8NLAgei47KILk0QIUzyE7wRB6
         T03j0+WJvKRNSOxlJonqCj1g441pG+fKBBegVXKKQ9CVCjtlE6BS1m55T/Z2Zl5Exma/
         4qfg==
X-Gm-Message-State: AOAM533Ca3jbThSs3RwrfRbfWpzlS/q58iEDS0oIW/CAfk149LY5Svfp
        SWzuwU6oawzA/yPDAmQgGzK8iJTIwlw2EASr3H5chqXh2KdiLw2DnkBzxbUSIX1eSkzl51zNEiB
        /NktjoMHOABzi
X-Received: by 2002:a17:906:f0a:: with SMTP id z10mr32932841eji.115.1625763252143;
        Thu, 08 Jul 2021 09:54:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGkLYIhRvhynFxbNHs4uWQpSbjIxHolctxDeja7s0380h25moq/fGxgNcKr8r+4vfFfede9Q==
X-Received: by 2002:a17:906:f0a:: with SMTP id z10mr32932829eji.115.1625763252010;
        Thu, 08 Jul 2021 09:54:12 -0700 (PDT)
Received: from [192.168.10.67] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id b5sm1206309ejz.122.2021.07.08.09.54.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 09:54:11 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: x86: Address missing
 vm_install_exception_handler conversions
To:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org
Cc:     kernel-team@android.com, Andrew Jones <drjones@redhat.com>,
        Ricardo Koller <ricarkol@google.com>
References: <20210701071928.2971053-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20cdb930-a1d9-058b-4317-e851ede02470@redhat.com>
Date:   Thu, 8 Jul 2021 18:52:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210701071928.2971053-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/07/21 09:19, Marc Zyngier wrote:
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
>   tools/testing/selftests/kvm/x86_64/hyperv_features.c | 2 +-
>   tools/testing/selftests/kvm/x86_64/mmu_role_test.c   | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> index 42bd658f52a8..af27c7e829c1 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> @@ -615,7 +615,7 @@ int main(void)
>   
>   	vm_init_descriptor_tables(vm);
>   	vcpu_init_descriptor_tables(vm, VCPU_ID);
> -	vm_handle_exception(vm, GP_VECTOR, guest_gp_handler);
> +	vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
>   
>   	pr_info("Testing access to Hyper-V specific MSRs\n");
>   	guest_test_msrs_access(vm, addr_gva2hva(vm, msr_gva),
> diff --git a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
> index 523371cf8e8f..da2325fcad87 100644
> --- a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
> @@ -71,7 +71,7 @@ static void mmu_role_test(u32 *cpuid_reg, u32 evil_cpuid_val)
>   	/* Set up a #PF handler to eat the RSVD #PF and signal all done! */
>   	vm_init_descriptor_tables(vm);
>   	vcpu_init_descriptor_tables(vm, VCPU_ID);
> -	vm_handle_exception(vm, PF_VECTOR, guest_pf_handler);
> +	vm_install_exception_handler(vm, PF_VECTOR, guest_pf_handler);
>   
>   	r = _vcpu_run(vm, VCPU_ID);
>   	TEST_ASSERT(r == 0, "vcpu_run failed: %d\n", r);
> 

Queued, thanks.

Paolo

