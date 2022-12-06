Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6670F644559
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 15:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbiLFOLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 09:11:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiLFOLJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 09:11:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC08F13E
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 06:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670335812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EjMwbYrUfvj4btSbY7QL+xE8cB7RFXkNXnUQjk3mAn4=;
        b=fMoeiRtkfHzjnm5hFpQT9TBcnoUxKi8Y9ZL4UM5IBlPIW9fXBOYdxuYz8XKzvS+F0rpSJV
        RuTnnsEp68zIjMTQBEXLgD1i87Vsc5xvs7pq2acienomBPJfdm+rp+8ak8qD2GezbZAwlj
        QLPL8vvJeUWE+LPBrbmdbEN1y2tGZik=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-379-RCLDGM52MCud1VOiXvCAyw-1; Tue, 06 Dec 2022 09:10:08 -0500
X-MC-Unique: RCLDGM52MCud1VOiXvCAyw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6062E38123A4;
        Tue,  6 Dec 2022 14:10:07 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40C331121315;
        Tue,  6 Dec 2022 14:10:05 +0000 (UTC)
Message-ID: <3ecd0be04273f91951d008ea815f7d217a6feac2.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 15/27] svm: move some svm support
 functions into lib/x86/svm_lib.h
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Date:   Tue, 06 Dec 2022 16:10:04 +0200
In-Reply-To: <3a3d705f-5867-5816-8545-df11b2ac8485@redhat.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
         <20221122161152.293072-16-mlevitsk@redhat.com>
         <3a3d705f-5867-5816-8545-df11b2ac8485@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-12-01 at 14:59 +0100, Emanuele Giuseppe Esposito wrote:
> 
> Am 22/11/2022 um 17:11 schrieb Maxim Levitsky:
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  lib/x86/svm_lib.h | 53 +++++++++++++++++++++++++++++++++++++++++++++++
> >  x86/svm.c         | 36 +-------------------------------
> >  x86/svm.h         | 18 ----------------
> >  x86/svm_npt.c     |  1 +
> >  x86/svm_tests.c   |  1 +
> >  5 files changed, 56 insertions(+), 53 deletions(-)
> >  create mode 100644 lib/x86/svm_lib.h
> > 
> > diff --git a/lib/x86/svm_lib.h b/lib/x86/svm_lib.h
> > new file mode 100644
> > index 00000000..04910281
> > --- /dev/null
> > +++ b/lib/x86/svm_lib.h
> > @@ -0,0 +1,53 @@
> > +#ifndef SRC_LIB_X86_SVM_LIB_H_
> > +#define SRC_LIB_X86_SVM_LIB_H_
> > +
> > +#include <x86/svm.h>
> > +#include "processor.h"
> > +
> > +static inline bool npt_supported(void)
> > +{
> > +	return this_cpu_has(X86_FEATURE_NPT);
> > +}
> > +
> > +static inline bool vgif_supported(void)
> > +{
> > +	return this_cpu_has(X86_FEATURE_VGIF);
> > +}
> > +
> > +static inline bool lbrv_supported(void)
> > +{
> > +	return this_cpu_has(X86_FEATURE_LBRV);
> > +}
> > +
> > +static inline bool tsc_scale_supported(void)
> > +{
> > +	return this_cpu_has(X86_FEATURE_TSCRATEMSR);
> > +}
> > +
> > +static inline bool pause_filter_supported(void)
> > +{
> > +	return this_cpu_has(X86_FEATURE_PAUSEFILTER);
> > +}
> > +
> > +static inline bool pause_threshold_supported(void)
> > +{
> > +	return this_cpu_has(X86_FEATURE_PFTHRESHOLD);
> > +}
> > +
> > +static inline void vmmcall(void)
> > +{
> > +	asm volatile ("vmmcall" : : : "memory");
> > +}
> > +
> > +static inline void stgi(void)
> > +{
> > +	asm volatile ("stgi");
> > +}
> > +
> > +static inline void clgi(void)
> > +{
> > +	asm volatile ("clgi");
> > +}
> > +
> Not an expert at all on this, but sti() and cli() in patch 1 are in
> processor.h and stgi (g stansd for global?) and clgi are in a different
> header? What about maybe moving them together?

Well the GI (global interrupt flag) is AMD specific, and even more correctly
SVM specific as well. Same for VMMCALL (Intel has VMCALL instead).

Best regards,
	Maxim Levitsky
> 
> > +
> > +#endif /* SRC_LIB_X86_SVM_LIB_H_ */
> > diff --git a/x86/svm.c b/x86/svm.c
> > index 0b2a1d69..8d90a242 100644
> > --- a/x86/svm.c
> > +++ b/x86/svm.c
> > @@ -14,6 +14,7 @@
> >  #include "alloc_page.h"
> >  #include "isr.h"
> >  #include "apic.h"
> > +#include "svm_lib.h"
> >  
> >  /* for the nested page table*/
> >  u64 *pml4e;
> > @@ -54,32 +55,6 @@ bool default_supported(void)
> >  	return true;
> >  }
> >  
> > -bool vgif_supported(void)
> > -{
> > -	return this_cpu_has(X86_FEATURE_VGIF);
> > -}
> > -
> > -bool lbrv_supported(void)
> > -{
> > -	return this_cpu_has(X86_FEATURE_LBRV);
> > -}
> > -
> > -bool tsc_scale_supported(void)
> > -{
> > -	return this_cpu_has(X86_FEATURE_TSCRATEMSR);
> > -}
> > -
> > -bool pause_filter_supported(void)
> > -{
> > -	return this_cpu_has(X86_FEATURE_PAUSEFILTER);
> > -}
> > -
> > -bool pause_threshold_supported(void)
> > -{
> > -	return this_cpu_has(X86_FEATURE_PFTHRESHOLD);
> > -}
> > -
> > -
> >  void default_prepare(struct svm_test *test)
> >  {
> >  	vmcb_ident(vmcb);
> > @@ -94,10 +69,6 @@ bool default_finished(struct svm_test *test)
> >  	return true; /* one vmexit */
> >  }
> >  
> > -bool npt_supported(void)
> > -{
> > -	return this_cpu_has(X86_FEATURE_NPT);
> > -}
> >  
> >  int get_test_stage(struct svm_test *test)
> >  {
> > @@ -128,11 +99,6 @@ static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
> >  	seg->base = base;
> >  }
> >  
> > -inline void vmmcall(void)
> > -{
> > -	asm volatile ("vmmcall" : : : "memory");
> > -}
> > -
> >  static test_guest_func guest_main;
> >  
> >  void test_set_guest(test_guest_func func)
> > diff --git a/x86/svm.h b/x86/svm.h
> > index 3cd7ce8b..7cb1b898 100644
> > --- a/x86/svm.h
> > +++ b/x86/svm.h
> > @@ -53,21 +53,14 @@ u64 *npt_get_pdpe(u64 address);
> >  u64 *npt_get_pml4e(void);
> >  bool smp_supported(void);
> >  bool default_supported(void);
> > -bool vgif_supported(void);
> > -bool lbrv_supported(void);
> > -bool tsc_scale_supported(void);
> > -bool pause_filter_supported(void);
> > -bool pause_threshold_supported(void);
> >  void default_prepare(struct svm_test *test);
> >  void default_prepare_gif_clear(struct svm_test *test);
> >  bool default_finished(struct svm_test *test);
> > -bool npt_supported(void);
> >  int get_test_stage(struct svm_test *test);
> >  void set_test_stage(struct svm_test *test, int s);
> >  void inc_test_stage(struct svm_test *test);
> >  void vmcb_ident(struct vmcb *vmcb);
> >  struct regs get_regs(void);
> > -void vmmcall(void);
> >  int __svm_vmrun(u64 rip);
> >  void __svm_bare_vmrun(void);
> >  int svm_vmrun(void);
> > @@ -75,17 +68,6 @@ void test_set_guest(test_guest_func func);
> >  
> >  extern struct vmcb *vmcb;
> >  
> > -static inline void stgi(void)
> > -{
> > -    asm volatile ("stgi");
> > -}
> > -
> > -static inline void clgi(void)
> > -{
> > -    asm volatile ("clgi");
> > -}
> > -
> > -
> >  
> >  #define SAVE_GPR_C                              \
> >          "xchg %%rbx, regs+0x8\n\t"              \
> > diff --git a/x86/svm_npt.c b/x86/svm_npt.c
> > index b791f1ac..8aac0bb6 100644
> > --- a/x86/svm_npt.c
> > +++ b/x86/svm_npt.c
> > @@ -2,6 +2,7 @@
> >  #include "vm.h"
> >  #include "alloc_page.h"
> >  #include "vmalloc.h"
> > +#include "svm_lib.h"
> >  
> >  static void *scratch_page;
> >  
> > diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> > index 202e9271..f86c2fa4 100644
> > --- a/x86/svm_tests.c
> > +++ b/x86/svm_tests.c
> > @@ -12,6 +12,7 @@
> >  #include "delay.h"
> >  #include "x86/usermode.h"
> >  #include "vmalloc.h"
> > +#include "svm_lib.h"
> >  
> >  #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
> >  
> > 


