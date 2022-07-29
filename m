Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACBB458532D
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 18:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236905AbiG2QIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 12:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiG2QIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 12:08:31 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416C788762
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 09:08:30 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id x7so4995172pll.7
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 09:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=RYcpsjxUNAdkgvJjXQiMdiYuQAEk/gdttUVtKFBEw8A=;
        b=AjKL6PeRqhXDIEOnN9L9Wd0ZFCa25E/pyJmXJGzXI0EfRnj4fw59ouUPcSKuQYlzyF
         WvLcMVXcBPLzEU6WNKNhrGIjCoW1eO0FJJ7f9AG4xL9G1mFBAhimzIwMMHurKp8W+9G8
         j2kmV8Akh2pkqJmzPoNyJlJbW5zbtvKuelo9Lg3M/8GAZeMKP+MAfR5aBJ/eWb5Vmdle
         iYPiTiIBpLPbtHZV9MQKJh1dOQ2ttYyTZWAP2LuNEtsfdiQJN2ZzWR8IW0R7UtETmWpA
         E/TAMjLZxWO7BG5uWwxkkrcufuoRHgYslEOTdzl6MiR2sb2b40Vz5cs9SOWhcCLCo+5V
         BiWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=RYcpsjxUNAdkgvJjXQiMdiYuQAEk/gdttUVtKFBEw8A=;
        b=PM16fhWCrL+RJuaLibihMCiU6Ie+SrqjYLjS2VUHYg/7RutBEacbxqpvZItKPkaiOu
         So2Y9jYoWqITcj+QgKvXcBfUxTxb63C7O6TTW1S3Pt/TxGhrrXUH1BQ2CdFSZkg7MNbz
         5XPgmR4KtwiLKt4HZTVI9TaLsZ9lHwZ8EAMiSbduTf4HrnK3UmaknVVzVhcsTpkRCo/S
         9jP1Xhjyy/fDJjwtng9FWDigl/GB3yZQdJUCm0dUTcJUCrfKwzY7hGcgP+uLlayqXpZL
         OlqO9ITHjYjfAhls5EFcQOIjSv7O1TdOxaMbx2EgJ99tLaKJ1lLA7Qr5EZ9WmOqhG4x8
         qMhA==
X-Gm-Message-State: ACgBeo14jpdcSQvf83wqSKROn+Pijm7LcSg2Ww6OTzQFymo6/iaZoYHD
        2CM5suLnhBMQU2Al9gQnA2vjwQ==
X-Google-Smtp-Source: AA6agR61xDITDWyHhmJ/PgNsKxGvpkXB+wIdNYNMpSXXqsxuypo6qbXBT4gtZgofOJj6mB0LmCVlrw==
X-Received: by 2002:a17:902:c950:b0:16d:4035:3bb9 with SMTP id i16-20020a170902c95000b0016d40353bb9mr4691728pla.55.1659110909604;
        Fri, 29 Jul 2022 09:08:29 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f12-20020a170902684c00b0016dcc381bbasm2618348pln.144.2022.07.29.09.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 09:08:29 -0700 (PDT)
Date:   Fri, 29 Jul 2022 16:08:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: VMX: Use proper type-safe functions for vCPU =>
 LBRs helpers
Message-ID: <YuQF+BBWA1SkXjT/@google.com>
References: <20220727233424.2968356-1-seanjc@google.com>
 <20220727233424.2968356-3-seanjc@google.com>
 <5f93760c-cb93-2c58-11d7-f9ddef7f640c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f93760c-cb93-2c58-11d7-f9ddef7f640c@gmail.com>
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

On Fri, Jul 29, 2022, Like Xu wrote:
> On 28/7/2022 7:34 am, Sean Christopherson wrote:
> > Turn vcpu_to_lbr_desc() and vcpu_to_lbr_records() into functions in order
> > to provide type safety, to document exactly what they return, and to
> 
> Considering the prevalence of similar practices, perhaps we (at least me)
> need doc more benefits of "type safety" or the risks of not doing so.

There already is documentation, see "#ifdef and preprocessor use in general" in
Documentation/process/4.Coding.rst:

  C preprocessor macros present a number of hazards, including possible
  multiple evaluation of expressions with side effects and no type safety.
  If you are tempted to define a macro, consider creating an inline function
  instead.  The code which results will be the same, but inline functions are
  easier to read, do not evaluate their arguments multiple times, and allow
  the compiler to perform type checking on the arguments and return value.

To elaborate on type safety, or lack thereof, let's pretend that struct kvm_vcpu's
"mutex" was actually named "lock", i.e. that both struct kvm_vcpu and struct kvm had:

	struct mutex lock;

And for whatever reason, we wanted to add helpers to lock/unlock.  If the helpers
were implemented via macros, e.g.

  	#define kvm_lock_vm(kvm) mutex_lock(&(kvm)->lock)

then this ends up being 100% legal code from the compilers perspective

	kvm_lock_vm(vcpu);

i.e. it will compile cleanly and only cause problems at run time because the
preprocesor expands that to:

	mutex_lock(&vcpu->lock);

A function on the other hand provides type safety because even though both kvm.lock
and kvm_vcpu.lock exist, the compiler will yell due to attempting to pass a
"struct kvm_vcpu *" into a function that takes a "struct kvm *kvm".

	static inline void kvm_lock_vm(struct kvm *kvm)
	{
		mutex_lock(&kvm->lock);
	}

There are instances where a macro is used because it's deemed to be the lesser
evil.  E.g. KVM x86 does

  #define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)

to allow inlining without creating a circular dependency.  include/linux/kvm_host.h
uses kvm_arch_vcpu_memslots_id() and so it needs to be fully defined by
arch/x86/include/asm/kvm_host.h.  But because linux/kvm_host.h includes asm/kvm_host.h,
asm/kvm_host.h can't deference @vcpu due to "struct kvm_vcpu" not yet being defined.

The macro trick works for this case because the preprocessor doesn't compile or check
anything, it just expands the macro in its user.  I.e. the derefence of @vcpu occurs
in kvm_vcpu_memslots() from the compilers perspective, and at that point "struct kvm_vcpu"
is fully defined and everyone is happy.

There's still some amount of risk in misuing kvm_arch_vcpu_memslots_id(), but in
this case we've decided that the benefits of inlining outweigh the risk of misuse.

> > allow consuming the helpers in vmx.h.  Move the definitions as necessary
> > (the macros "reference" to_vmx() before its definition).
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/vmx/vmx.h | 26 +++++++++++++++++---------
> >   1 file changed, 17 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index 286c88e285ea..690421b7d26c 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -6,6 +6,7 @@
> >   #include <asm/kvm.h>
> >   #include <asm/intel_pt.h>
> > +#include <asm/perf_event.h>
> >   #include "capabilities.h"
> >   #include "kvm_cache_regs.h"
> > @@ -91,15 +92,6 @@ union vmx_exit_reason {
> >   	u32 full;
> >   };
> > -#define vcpu_to_lbr_desc(vcpu) (&to_vmx(vcpu)->lbr_desc)
> > -#define vcpu_to_lbr_records(vcpu) (&to_vmx(vcpu)->lbr_desc.records)
> 
> More targets can be found in the arch/x86/kvm/pmu.h:
> 
> #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
> #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
> #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)

We should definitely convert those, assuming it's not too painful and not
completely impossible due to circular dependencies.
