Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3078160FBE4
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 17:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235704AbiJ0P1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 11:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236069AbiJ0P1a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 11:27:30 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7141843FF
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 08:27:25 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d24so1857878pls.4
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 08:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+tj9p+sLn7YeP5Xd0DfI8j+ikuZzVppjGSJZ7yYzzQ0=;
        b=FaLH9Tp5QxyOKTbifXkw7jSCzqnLcRtAmkpF5ytRaAoOjzoVVjTW0Qj4Lwf1h+9izN
         GA8K5moe7cs2f3fJRy6Jy9vfquzkNVgrjj3Ss8937MHcM064xjl9bB3U2djzYteM12WN
         GP/vz51Cd3EU0brsbHXRMqdFnJyzBRJICz5l7A9ZFFmxP31E/jmT42Om8eeShZPhM6Ja
         5Im4FTuZGI+IzbRaM4yfcm8r8qOo+0S/8FAbDdJ1RO2J7FJ4E5SbvHnuncFTlr6Iz/HH
         S5yirdCBxzXVSt2hMw1CHbJ7R1Mf6NCh3+Yt+Kz1d1itycg5XoQwK5fC+ejNAxkqvE+t
         MRfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+tj9p+sLn7YeP5Xd0DfI8j+ikuZzVppjGSJZ7yYzzQ0=;
        b=n4+pJ0Zwqhfl6uYKWurw03tD2ZVA2EG1SBn3ngQmNxk1wI1npDbjQyVpaFxwyIFrED
         qDlIIDaJydxnMFqonxIuSywzXHz1c2+EHwxCZL6/UVNk+rpsmGeatudpvwMhHehWUfu0
         bNfOsyU9bqdh/lafZtaXGdy9nYgp2FmPuZguAPHi9vIq2qaGv+e7E14y/UZ2QKMYthTa
         7X+ArNftgXBVR6WEP2GBD3RobEpOATOkn9jXjexWvDUYOMNA4pmqff/JVIE7/gbBnBF0
         ZdU8Eu/kMZxXm3M+hom+yVOCUyeYmeRXbcNXzkGxW/48hmNM1n5B5oMNQDmYpwkySmT4
         t/Ig==
X-Gm-Message-State: ACrzQf2CJN3sAjK2zRVMVvt7Ga7VNnWn3xBWIAYHAlmf/hnK3wBP9yZE
        kOyu121yZdu+BXYm9vkxEKAdYQ==
X-Google-Smtp-Source: AMsMyM6yY1r/HaOo5VsNgQbihwcaKGHgLcFyj6i5KhZkfzxS6rxLLRr0oL+LLStr+eyb/MWgcuNyRQ==
X-Received: by 2002:a17:903:1c9:b0:186:91fa:59ad with SMTP id e9-20020a17090301c900b0018691fa59admr27726524plh.35.1666884445081;
        Thu, 27 Oct 2022 08:27:25 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d20-20020a621d14000000b0056c47a5c34dsm1293083pfd.122.2022.10.27.08.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 08:27:24 -0700 (PDT)
Date:   Thu, 27 Oct 2022 15:27:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "vipinsh@google.com" <vipinsh@google.com>,
        "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 01/18] KVM: selftests/kvm_util: use array of pointers
 to maintain vcpus in kvm_vm
Message-ID: <Y1qjWZ8Lpveyky9m@google.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
 <20221024113445.1022147-2-wei.w.wang@intel.com>
 <Y1nHL5BUoWPqUtt9@google.com>
 <DS0PR11MB6373E471C1378CBEEBD40A82DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB6373E471C1378CBEEBD40A82DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
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

On Thu, Oct 27, 2022, Wang, Wei W wrote:
> On Thursday, October 27, 2022 7:48 AM, Sean Christopherson wrote:
> > > +	for (i = 0, vcpu = vm->vcpus[0];				\
> > > +		vcpu && i < KVM_MAX_VCPUS; vcpu = vm->vcpus[++i])
> > 
> > I hate pointer arithmetic more than most people, but in this case it avoids the
> > need to pass in 'i', which in turn cuts down on boilerplate and churn.
> 
> Hmm, indeed, this can be improved, how about this one:
> 
> +#define vm_iterate_over_vcpus(vm, vcpu)                         \
> +       for (vcpu = vm->vcpus[0]; vcpu; vcpu = vm->vcpus[vcpu->id + 1]) \

Needs to be bounded by the size of the array.
 
> > >  #endif /* SELFTEST_KVM_UTIL_H */
> > > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > > b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > > index e42a09cd24a0..c90a9609b853 100644
> > > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > > @@ -45,7 +45,6 @@ struct userspace_mem_region {  };
> > >
> > >  struct kvm_vcpu {
> > > -	struct list_head list;
> > >  	uint32_t id;
> > >  	int fd;
> > >  	struct kvm_vm *vm;
> > > @@ -75,7 +74,6 @@ struct kvm_vm {
> > >  	unsigned int pa_bits;
> > >  	unsigned int va_bits;
> > >  	uint64_t max_gfn;
> > > -	struct list_head vcpus;
> > >  	struct userspace_mem_regions regions;
> > >  	struct sparsebit *vpages_valid;
> > >  	struct sparsebit *vpages_mapped;
> > > @@ -92,6 +90,7 @@ struct kvm_vm {
> > >  	int stats_fd;
> > >  	struct kvm_stats_header stats_header;
> > >  	struct kvm_stats_desc *stats_desc;
> > > +	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
> > 
> > We can dynamically allocate the array without too much trouble, though I'm not
> > sure it's worth shaving the few KiB of memory.  For __vm_create(), the number
> > of vCPUs is known when the VM is created.  For vm_create_barebones(), we
> > could do the simple thing of allocating KVM_MAX_VCPU.
> 
> The issue with dynamic allocation is that some users start with
> __vm_create(nr_vcpus), and later could add more cpus with vm_vcpu_add (e.g.
> x86_64/xapic_ipi_test.c). To support this we may need to re-allocate the
> array for later vm_vcpu_add(), and also need to add nr_vcpus to indicate the
> size.

Hrm, right, the number of runnable CPUs isn't a hard upper bound.  Ideally it
would be, as the number of pages required for guest memory will fail to account
for the "extra" vcpus.  E.g. that test should really do vm_create(2) and then
manually add each vCPU.

> It's userspace memory, and not a problem to use a bit larger virtual memory
> (memory are not really allocated until we have that many vcpus to touch the
> array entries), I think.

Yeah, just allocate the max for now, though the array still needs to be dynamically
allocated based on the actual maximum number of vCPUs.  Oh, duh, we can do the
easy thing and just bump KVM_MAX_VCPUS to 1024 to match KVM.  And then assert that
kvm_check_cap(KVM_CAP_MAX_VCPUS) == KVM_CAP_MAX_VCPUS in kvm_create_max_vcpus.c.
