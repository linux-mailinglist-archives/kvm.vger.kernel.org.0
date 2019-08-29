Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C96ABA0F60
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 04:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfH2CHr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 22:07:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52306 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbfH2CHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 22:07:47 -0400
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AD1C64E4E6
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 02:07:46 +0000 (UTC)
Received: by mail-pf1-f198.google.com with SMTP id p16so1253317pfn.3
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 19:07:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UTtKaYO8o58VEORaJUygfO/C/Qe47dsETN2hRJwgzxg=;
        b=oj6ptchXE7pCufjkNnzap+rdaQ2nL6QuXYeAeD+m1vEUC45lcAcexfCAFNaafvCj53
         g4kAYtTtg2kwrdWUPYjsZHElwNr3fvzmOeZbB4bJa5jFj+OKZ6OpoXQbYXrxUw2alOKL
         c+Tzh9T5vy88kUEf1NCRhtWWaR7Yc8pqf4Uowa3M50AdQGb9qkXeHXcnM0Gi7R+Wii9C
         GrT+RRwIJQ1DtOGv1kVumM1aJzU/6UeML/Q+MMYR/daKrEpSjQAU/rssDjENiV92r26y
         xTm9R1h4SQLEQg6lYdIZ+bpvb8Jo34Os42KL5PWYBiwz6buxCmcaBDxxrpgQQJuQkr7e
         oD8g==
X-Gm-Message-State: APjAAAWgUkdWp3nhHR3ByUjh4DpyED8tzCJTfhdG7Dl5f4csN2mDW6sx
        t4AV1GR6PGY0mtXCybWX9R0HeDVWg6GXbfl8w9z3KLRq1iM6QNVfsy+g9LjjIrO+L7BldSv+bqi
        j3aDy8lglYJcO
X-Received: by 2002:a17:902:e85:: with SMTP id 5mr7690873plx.16.1567044465647;
        Wed, 28 Aug 2019 19:07:45 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy1v0THXMa4o8JzVoqol5UIv4TY6YkL5ICskh6qbw7hwVx/XkLZASaMg3qfmccT4+NHQppfLA==
X-Received: by 2002:a17:902:e85:: with SMTP id 5mr7690860plx.16.1567044465445;
        Wed, 28 Aug 2019 19:07:45 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e6sm856619pfl.37.2019.08.28.19.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 19:07:44 -0700 (PDT)
Date:   Thu, 29 Aug 2019 10:07:34 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 3/4] KVM: selftests: Introduce VM_MODE_PXXV48_4K
Message-ID: <20190829020734.GF8729@xz-x1>
References: <20190827131015.21691-1-peterx@redhat.com>
 <20190827131015.21691-4-peterx@redhat.com>
 <20190828114104.wvqdhvapf774ivq2@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190828114104.wvqdhvapf774ivq2@kamzik.brq.redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 01:41:04PM +0200, Andrew Jones wrote:

[...]

> > +#define DEBUG printf
> 
> If this is going to be some general thing, then maybe we should do it
> like this
> 
> #ifndef NDEBUG
> #define dprintf printf
> #endif

Ok.

> 
> 
> > +
> >  /* Minimum allocated guest virtual and physical addresses */
> >  #define KVM_UTIL_MIN_VADDR		0x2000
> >  
> > @@ -38,12 +40,19 @@ enum vm_guest_mode {
> >  	VM_MODE_P48V48_64K,
> >  	VM_MODE_P40V48_4K,
> >  	VM_MODE_P40V48_64K,
> > +	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
> >  	NUM_VM_MODES,
> >  };
> >  
> >  #ifdef __aarch64__
> >  #define VM_MODE_DEFAULT VM_MODE_P40V48_4K
> > -#else
> > +#endif
> > +
> > +#ifdef __x86_64__
> > +#define VM_MODE_DEFAULT VM_MODE_PXXV48_4K
> > +#endif
> > +
> > +#ifndef VM_MODE_DEFAULT
> >  #define VM_MODE_DEFAULT VM_MODE_P52V48_4K
> >  #endif
> 
> nit: how about
> 
> #if defined(__aarch64__)
> ...
> #elif defined(__x86_64__)
> ...
> #else
> ...
> #endif

Yes, better!

> 
> >  
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > index 486400a97374..86036a59a668 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > @@ -264,6 +264,9 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
> >  	case VM_MODE_P52V48_4K:
> >  		TEST_ASSERT(false, "AArch64 does not support 4K sized pages "
> >  				   "with 52-bit physical address ranges");
> > +	case VM_MODE_PXXV48_4K:
> > +		TEST_ASSERT(false, "AArch64 does not support 4K sized pages "
> > +				   "with ANY-bit physical address ranges");
> >  	case VM_MODE_P52V48_64K:
> >  		tcr_el1 |= 1ul << 14; /* TG0 = 64KB */
> >  		tcr_el1 |= 6ul << 32; /* IPS = 52 bits */
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 0c7c4368bc14..8c6f872a8793 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -8,6 +8,7 @@
> >  #include "test_util.h"
> >  #include "kvm_util.h"
> >  #include "kvm_util_internal.h"
> > +#include "processor.h"
> >  
> >  #include <assert.h>
> >  #include <sys/mman.h>
> > @@ -101,12 +102,13 @@ static void vm_open(struct kvm_vm *vm, int perm)
> >  }
> >  
> >  const char * const vm_guest_mode_string[] = {
> > -	"PA-bits:52, VA-bits:48, 4K pages",
> > -	"PA-bits:52, VA-bits:48, 64K pages",
> > -	"PA-bits:48, VA-bits:48, 4K pages",
> > -	"PA-bits:48, VA-bits:48, 64K pages",
> > -	"PA-bits:40, VA-bits:48, 4K pages",
> > -	"PA-bits:40, VA-bits:48, 64K pages",
> > +	"PA-bits:52,  VA-bits:48, 4K pages",
> > +	"PA-bits:52,  VA-bits:48, 64K pages",
> > +	"PA-bits:48,  VA-bits:48, 4K pages",
> > +	"PA-bits:48,  VA-bits:48, 64K pages",
> > +	"PA-bits:40,  VA-bits:48, 4K pages",
> > +	"PA-bits:40,  VA-bits:48, 64K pages",
> > +	"PA-bits:ANY, VA-bits:48, 4K pages",
> 
> nit: while formatting we could align the 'K's in the 64/4K column

Ok.

> 
> >  };
> >  _Static_assert(sizeof(vm_guest_mode_string)/sizeof(char *) == NUM_VM_MODES,
> >  	       "Missing new mode strings?");
> > @@ -185,6 +187,32 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
> >  		vm->page_size = 0x10000;
> >  		vm->page_shift = 16;
> >  		break;
> > +	case VM_MODE_PXXV48_4K:
> > +#ifdef __x86_64__
> > +		{
> > +			struct kvm_cpuid_entry2 *entry;
> > +
> > +			/* SDM 4.1.4 */
> > +			entry = kvm_get_supported_cpuid_entry(0x80000008);
> > +			if (entry) {
> > +				vm->pa_bits = entry->eax & 0xff;
> > +				vm->va_bits = (entry->eax >> 8) & 0xff;
> > +			} else {
> > +				vm->pa_bits = vm->va_bits = 32;
> > +			}
> > +			TEST_ASSERT(vm->va_bits == 48, "Linear address width "
> > +				    "(%d bits) not supported", vm->va_bits);
> > +			vm->pgtable_levels = 4;
> > +			vm->page_size = 0x1000;
> > +			vm->page_shift = 12;
> > +			DEBUG("Guest physical address width detected: %d\n",
> > +			      vm->pa_bits);
> > +		}
> 
> How about making this a function that lives in x86_64/processor.c?

Done.  Also I fixed up the overlooked PAE calculation which should be
36 rather than 32 bits PA.

> 
> > +#else
> > +		TEST_ASSERT(false, "VM_MODE_PXXV48_4K not supported on "
> > +			    "non-x86 platforms");
> 
> This should make the above aarch64_vcpu_setup() change unnecessary.

I tend to prefer keeping both because if some non-arm arch removed it
then aarch64 has another chance to assert.

Thanks,

-- 
Peter Xu
