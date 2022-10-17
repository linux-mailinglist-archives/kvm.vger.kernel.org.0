Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149816015E8
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 20:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiJQSEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 14:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbiJQSEe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 14:04:34 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C9913F78
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:04:33 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d10so11809764pfh.6
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=drU3O/+nGrdgy6WMvD6hVrTFvRlUohf8Zzl84rmZ2yQ=;
        b=HXDzvzxUEPXF8gRIh1ZWqTSePTIzEruLotn0oKCLBkUbTNT01bZzUDXGcPHZ7smqbA
         JzbhVdVMZdS4ku0TM9KOqVdl5fBf2nU3XvGlf2GPjGSa1iVeXa4qcnCg7FQmArF2F1jY
         M0AiKOMuBlrmxZWgeB93M2gJn3itRtzlzZPhegmxIsgafHged2ZW33vomJf+hhB7/JUr
         UCIiBHNKc/cOWuj4BksIRLREcwpmLYEbP9OxuslD09Z+3UZOh7CdwOn3htaTg08N2AbY
         8Hr8VtX/K0Jb2b9ohvHEvN4b82ZOiV7LFN7k/Tj7IC7i7OYCi1VmpIlUQ9l7AgCLfw7L
         Uq4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=drU3O/+nGrdgy6WMvD6hVrTFvRlUohf8Zzl84rmZ2yQ=;
        b=MlhA75JMpHdnI2ZmvVn/Dfg0OHqTvoA13qNYZTY2/a0/6845Df6B8i7hAI+oh/yQqW
         LpyzCrIRCjIf567sDRODbz8zmio9GHSFECM2QIrSLiYeqqPlXXG2vFbT3U68pDM4TtVr
         IoQ8cIOeJ06oG85e9Yuq66ZHF/S/M7IkajNb/5e5YVzXAD77GSRqIzmBdPhfgwJU6WfN
         aK/r6JvLJIQoLxC6vjhcLwb1fW9mzVKNihu6gUDiEI9zAQL70TdqdGkMGorU9KN8PBTK
         5yEzlsSTk7ZkBD6hquXbWKr3jaJGJuaCE9C4nfbw3SNjhbw7cuNuWMFPMTilSdVQzzM+
         xptQ==
X-Gm-Message-State: ACrzQf3jalcC9cjrFztmWZycqzbz+JDT+THOwi/2toKikGQf/19Yk2f6
        XtOkDuTmXCNie0TC+/obnjrW2aImd5w24w==
X-Google-Smtp-Source: AMsMyM6sO+LOU09ZXjof0uEuD7P3wpQStynULcyl6LgTFLXcVsWYXWq8MBmKYePZBrMNXMTOfiCISA==
X-Received: by 2002:a05:6a00:21c8:b0:52b:ffc0:15e7 with SMTP id t8-20020a056a0021c800b0052bffc015e7mr13710910pfj.29.1666029872934;
        Mon, 17 Oct 2022 11:04:32 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h9-20020a656389000000b00458a0649474sm6414850pgv.11.2022.10.17.11.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 11:04:32 -0700 (PDT)
Date:   Mon, 17 Oct 2022 18:04:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev
Subject: Re: [V4 6/8] KVM: selftests: add library for creating/interacting
 with SEV guests
Message-ID: <Y02ZLFcDQbX6lP9z@google.com>
References: <20220829171021.701198-1-pgonda@google.com>
 <20220829171021.701198-7-pgonda@google.com>
 <Yz8dpB5+RFjEhA3n@google.com>
 <CAMkAt6oZQc4jqF7FOXOKkpbP3c4NXxPumVVjX9gXwPCh-zbtYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMkAt6oZQc4jqF7FOXOKkpbP3c4NXxPumVVjX9gXwPCh-zbtYg@mail.gmail.com>
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

On Mon, Oct 17, 2022, Peter Gonda wrote:
> On Thu, Oct 6, 2022 at 12:25 PM Sean Christopherson <seanjc@google.com> wrote:
> > And with that, I believe sev_vm_create() can go away entirely and the SEV encryption
> > stuff can be handled via a new vm_guest_mode.  ____vm_create() already has a gross
> > __x86_64__ hook that we can tweak, e.g.
> >
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 54b8d8825f5d..2d6cbca2c01a 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -238,9 +238,10 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
> >         case VM_MODE_P36V47_16K:
> >                 vm->pgtable_levels = 3;
> >                 break;
> > +       case VM_MODE_PXXV48_4K_SEV:
> >         case VM_MODE_PXXV48_4K:
> >  #ifdef __x86_64__
> > -               kvm_get_cpu_address_width(&vm->pa_bits, &vm->va_bits);
> > +               kvm_init_vm_address_properties(vm);
> >                 /*
> >                  * Ignore KVM support for 5-level paging (vm->va_bits == 57),
> >                  * it doesn't take effect unless a CR4.LA57 is set, which it
> >
> > Then kvm_init_vm_address_properties() can pivot on vm->mode to deal with SEV
> > specific stuff.

...

> This refactor sounds good, working on this with a few changes.
> 
> Instead of kvm_init_vm_address_properties() as you suggested I've added this:
> 
> @@ -272,6 +275,8 @@ struct kvm_vm *____vm_create(enum vm_guest_mode
>  mode, uint64_t nr_pages)
>                 vm->type = KVM_VM_TYPE_ARM_IPA_SIZE(vm->pa_bits);
>  #endif
> 
> +       kvm_init_vm_arch(vm);

Why?  I'm not necessarily opposed to adding kvm_init_vm_arch(), but since x86
"needs" a dedicated hook to unpack the mode, why not piggyback that one?

> +
>         vm_open(vm);
> 
>         /* Limit to VA-bit canonical virtual addresses. */
> 
> And I need to put kvm_arch_vm_post_create() after the vCPUs are
> created because the ordering we need is: KVM_SEV_INIT -> Create vCPUS
> -> KVM_SEV_LAUNCH_FINISH.

Hrm, that's annoying.  Please don't use kvm_arch_vm_post_create() as the name,
that's a better fit for what Vishal is doing since the "vm_post_create()" implies
that it's called for "all" VM creation paths, where "all" means "everything
except barebones VMs".  E.g. in Vishal's series, kvm_arch_vm_post_create() can
be used to drop the vm_create_irqchip() call in common code.  In your case, IIUC
the hook will be invoked from __vm_create_with_vcpus().

I'm a little hesitant to have an arch hook for this case since it can't be
all-or-nothing (again, ignoring barebones VMs).  If a "finalize" arch hook is added,
then arguably tests that do __vm_create() and manually add vCPUs should call the
arch hook, i.e. we'd be adding maintenance burden to tests that in all likelihood
don't care about SEV and never will.

It's somewhat unfortunate, but dedicated vm_sev_create_with_one_vcpu() and
and vm_sev_create_with_vcpus() wrappers is probably the least awful solution.
