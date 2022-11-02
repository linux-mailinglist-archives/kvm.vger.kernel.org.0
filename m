Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C207617302
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiKBXqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiKBXqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:46:05 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52812193
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:46:00 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id e129so198113pgc.9
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 16:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PxnrF5yXGCzBk6DuHEJc9aTEx7Jr1C20HXqasxjld9I=;
        b=foT9bmxt+RZUSdC8GunvebUXVC5zFCL3KCnne9B6lNVSkp4oEUxJz8Qu2eKO38p5rf
         QFDgFhnaoJOt24v44q/UcrVM0y3JD7KOsJSsz5syx/qZxINhm8AeEyHXr3AGA0YPrWUL
         Cdyb7ziJC9/WoJiwD3soz46KqRF58jmJgsREd+udlkVDvHR0Ds8ZaZVGag2BiamqVTk8
         f5TuwXJ8sScV+DACm6zL2EGK6+TfBrp+cM0QjFOGOYxwsrjf9gUaNxqpAUd1dPBryHla
         NKlzL5YZAhfHPsBdWGypf7M/5wJ0YnP6ImZKr44zlveTFsieuFiZO0LshYqvc2UJgbHS
         5SHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PxnrF5yXGCzBk6DuHEJc9aTEx7Jr1C20HXqasxjld9I=;
        b=UTbI5kBRjM/hOhsiSK6X6/O1Hgpoc2LKSGKQ37YEvVurHZQ47ZpnZ+fhCBkgVZZZb/
         OEVp1Qj6EHxzAD81G1RxK3Vi/5NoPV6qo+I+KcfM7NPQ8/dYlBWRKCn0Yc0v8UQY5mSM
         QD6PHdobRUOotAAaXlKFsh1CL1rqlK0cGa/yaoY8RlKELVd9gd+GBBfojaC3W0hmkMUU
         whDxNzryJR+6R+NKft6huOB4qTDfQlHbXPW7/OjKBuV+uIgSjj1+Bw/4A3+93drodXK+
         kr8i7rKsC1ubvtr8TLIKC7HvEHxjCd4yGKj49aQJkcupDyTau8cnKtLr6GVP9cUNfgno
         itBA==
X-Gm-Message-State: ACrzQf1JwUE3vSi4WISVmaSncgEtM60ZK3pr7HDS8NkeIEoUtEt6Tfjb
        Lrs79JZLgWlJbCUT3GA8a9rFYQ==
X-Google-Smtp-Source: AMsMyM4MThYbzDwazYy/pifB316ku5meLYAnINTWxrULu+jof2vSlpkfGVVeXHEd7w2usP1MOmbjXg==
X-Received: by 2002:a62:174a:0:b0:56b:9fc2:4ebd with SMTP id 71-20020a62174a000000b0056b9fc24ebdmr11036716pfx.21.1667432759752;
        Wed, 02 Nov 2022 16:45:59 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id im23-20020a170902bb1700b00186ae20e8dcsm8810730plb.271.2022.11.02.16.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 16:45:59 -0700 (PDT)
Date:   Wed, 2 Nov 2022 23:45:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, andrew.jones@linux.dev,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 5/7] KVM: selftests: Shorten the test args in
 memslot_modification_stress_test.c
Message-ID: <Y2MBNA7pLIb6ugU2@google.com>
References: <20221102232737.1351745-1-vipinsh@google.com>
 <20221102232737.1351745-6-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102232737.1351745-6-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 02, 2022, Vipin Sharma wrote:
> Change test args memslot_modification_delay and nr_memslot_modifications
> to delay and nr_iterations for simplicity.

Suggested-by: Sean Christopherson <seanjc@google.com>

I don't care about the credit so much as I don't want you getting yelled at for
one of my random ideas :-)

> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  .../kvm/memslot_modification_stress_test.c     | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> index d7ddc8a105a2..d6089ccaa484 100644
> --- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> +++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> @@ -87,8 +87,8 @@ static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
>  }
>  
>  struct test_params {
> -	useconds_t memslot_modification_delay;
> -	uint64_t nr_memslot_modifications;
> +	useconds_t delay;
> +	uint64_t nr_iterations;
>  	bool partition_vcpu_memory_access;
>  };
>  
> @@ -107,8 +107,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  
>  	pr_info("Started all vCPUs\n");
>  
> -	add_remove_memslot(vm, p->memslot_modification_delay,
> -			   p->nr_memslot_modifications);
> +	add_remove_memslot(vm, p->delay,
> +			   p->nr_iterations);

This wrap is no longer necessary (which was part of the motivation for the
rename).

>  	run_vcpus = false;
>  
> @@ -144,8 +144,8 @@ int main(int argc, char *argv[])
>  	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
>  	int opt;
>  	struct test_params p = {
> -		.memslot_modification_delay = 0,
> -		.nr_memslot_modifications =
> +		.delay = 0,
> +		.nr_iterations =
>  			DEFAULT_MEMSLOT_MODIFICATION_ITERATIONS,
>  		.partition_vcpu_memory_access = true
>  	};
> @@ -158,8 +158,8 @@ int main(int argc, char *argv[])
>  			guest_modes_cmdline(optarg);
>  			break;
>  		case 'd':
> -			p.memslot_modification_delay = atoi_paranoid(optarg);
> -			TEST_ASSERT(p.memslot_modification_delay >= 0,
> +			p.delay = atoi_paranoid(optarg);
> +			TEST_ASSERT(p.delay >= 0,
>  				    "A negative delay is not supported.");
>  			break;
>  		case 'b':
> @@ -175,7 +175,7 @@ int main(int argc, char *argv[])
>  			p.partition_vcpu_memory_access = false;
>  			break;
>  		case 'i':
> -			p.nr_memslot_modifications = atoi_paranoid(optarg);
> +			p.nr_iterations = atoi_paranoid(optarg);
>  			break;
>  		case 'h':
>  		default:
> -- 
> 2.38.1.273.g43a17bfeac-goog
> 
