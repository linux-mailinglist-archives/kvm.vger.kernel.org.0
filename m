Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9861F64455D
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 15:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbiLFOMP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 09:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbiLFOMN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 09:12:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BA82CE0C
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 06:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670335874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o/+CNhq5EBJ6i7cmYU6+NRbSCyGBErDwb5xA+7JRLuQ=;
        b=BQH0wGnrAUAkjAo5BvVCFiI7Qzvvm3k4Dy+dKmSx4PeHRWdrpEblvaNKN9LTlr5pbVmqxa
        wla/VjaNrrLysSpl8F49H2xZFTtLjesx1qZGB8sw2UOVUj94ypkxKJGg32xB2jo7pgV/6r
        1HdF5f/D3kM/BKKS2IGErYAT0EE7Dbc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-403-X1udCxM-OWifDwYYXytC3Q-1; Tue, 06 Dec 2022 09:11:11 -0500
X-MC-Unique: X1udCxM-OWifDwYYXytC3Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0AB69801231;
        Tue,  6 Dec 2022 14:11:11 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F22EB4A9256;
        Tue,  6 Dec 2022 14:11:08 +0000 (UTC)
Message-ID: <eed073d8ab6e91ee9ac9012b59ddcc20bf3d0e54.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 18/27] svm: move vmcb_ident to
 svm_lib.c
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
Date:   Tue, 06 Dec 2022 16:11:08 +0200
In-Reply-To: <08c7eca0-b828-b1bd-b85c-babfc758c8a2@redhat.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
         <20221122161152.293072-19-mlevitsk@redhat.com>
         <08c7eca0-b828-b1bd-b85c-babfc758c8a2@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-12-01 at 17:18 +0100, Emanuele Giuseppe Esposito wrote:
> 
> Am 22/11/2022 um 17:11 schrieb Maxim Levitsky:
> > Extract vmcb_ident to svm_lib.c
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Not sure if it holds for kvm unit tests, but indent of vmcb_set_seg
> parameters seems a little bit off.

True, I will fix.

Best regards,
	Maxim Levitsky

> 
> If that's fine:
> Reviewed-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> 
> > ---
> >  lib/x86/svm_lib.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++
> >  lib/x86/svm_lib.h |  4 ++++
> >  x86/svm.c         | 54 -----------------------------------------------
> >  x86/svm.h         |  1 -
> >  4 files changed, 58 insertions(+), 55 deletions(-)
> > 
> > diff --git a/lib/x86/svm_lib.c b/lib/x86/svm_lib.c
> > index c7194909..aed757a1 100644
> > --- a/lib/x86/svm_lib.c
> > +++ b/lib/x86/svm_lib.c
> > @@ -109,3 +109,57 @@ bool setup_svm(void)
> >  	setup_npt();
> >  	return true;
> >  }
> > +
> > +void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
> > +			 u64 base, u32 limit, u32 attr)
> > +{
> > +	seg->selector = selector;
> > +	seg->attrib = attr;
> > +	seg->limit = limit;
> > +	seg->base = base;
> > +}
> > +
> > +void vmcb_ident(struct vmcb *vmcb)
> > +{
> > +	u64 vmcb_phys = virt_to_phys(vmcb);
> > +	struct vmcb_save_area *save = &vmcb->save;
> > +	struct vmcb_control_area *ctrl = &vmcb->control;
> > +	u32 data_seg_attr = 3 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
> > +		| SVM_SELECTOR_DB_MASK | SVM_SELECTOR_G_MASK;
> > +	u32 code_seg_attr = 9 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
> > +		| SVM_SELECTOR_L_MASK | SVM_SELECTOR_G_MASK;
> > +	struct descriptor_table_ptr desc_table_ptr;
> > +
> > +	memset(vmcb, 0, sizeof(*vmcb));
> > +	asm volatile ("vmsave %0" : : "a"(vmcb_phys) : "memory");
> > +	vmcb_set_seg(&save->es, read_es(), 0, -1U, data_seg_attr);
> > +	vmcb_set_seg(&save->cs, read_cs(), 0, -1U, code_seg_attr);
> > +	vmcb_set_seg(&save->ss, read_ss(), 0, -1U, data_seg_attr);
> > +	vmcb_set_seg(&save->ds, read_ds(), 0, -1U, data_seg_attr);
> > +	sgdt(&desc_table_ptr);
> > +	vmcb_set_seg(&save->gdtr, 0, desc_table_ptr.base, desc_table_ptr.limit, 0);
> > +	sidt(&desc_table_ptr);
> > +	vmcb_set_seg(&save->idtr, 0, desc_table_ptr.base, desc_table_ptr.limit, 0);
> > +	ctrl->asid = 1;
> > +	save->cpl = 0;
> > +	save->efer = rdmsr(MSR_EFER);
> > +	save->cr4 = read_cr4();
> > +	save->cr3 = read_cr3();
> > +	save->cr0 = read_cr0();
> > +	save->dr7 = read_dr7();
> > +	save->dr6 = read_dr6();
> > +	save->cr2 = read_cr2();
> > +	save->g_pat = rdmsr(MSR_IA32_CR_PAT);
> > +	save->dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
> > +	ctrl->intercept = (1ULL << INTERCEPT_VMRUN) |
> > +		(1ULL << INTERCEPT_VMMCALL) |
> > +		(1ULL << INTERCEPT_SHUTDOWN);
> > +	ctrl->iopm_base_pa = virt_to_phys(io_bitmap);
> > +	ctrl->msrpm_base_pa = virt_to_phys(msr_bitmap);
> > +
> > +	if (npt_supported()) {
> > +		ctrl->nested_ctl = 1;
> > +		ctrl->nested_cr3 = (u64)pml4e;
> > +		ctrl->tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
> > +	}
> > +}
> > diff --git a/lib/x86/svm_lib.h b/lib/x86/svm_lib.h
> > index f603ff93..3bb098dc 100644
> > --- a/lib/x86/svm_lib.h
> > +++ b/lib/x86/svm_lib.h
> > @@ -49,7 +49,11 @@ static inline void clgi(void)
> >  	asm volatile ("clgi");
> >  }
> >  
> > +void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
> > +				  u64 base, u32 limit, u32 attr);
> > +
> >  bool setup_svm(void);
> > +void vmcb_ident(struct vmcb *vmcb);
> >  
> >  u64 *npt_get_pte(u64 address);
> >  u64 *npt_get_pde(u64 address);
> > diff --git a/x86/svm.c b/x86/svm.c
> > index cf246c37..5e2c3a83 100644
> > --- a/x86/svm.c
> > +++ b/x86/svm.c
> > @@ -63,15 +63,6 @@ void inc_test_stage(struct svm_test *test)
> >  	barrier();
> >  }
> >  
> > -static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
> > -			 u64 base, u32 limit, u32 attr)
> > -{
> > -	seg->selector = selector;
> > -	seg->attrib = attr;
> > -	seg->limit = limit;
> > -	seg->base = base;
> > -}
> > -
> >  static test_guest_func guest_main;
> >  
> >  void test_set_guest(test_guest_func func)
> > @@ -85,51 +76,6 @@ static void test_thunk(struct svm_test *test)
> >  	vmmcall();
> >  }
> >  
> > -void vmcb_ident(struct vmcb *vmcb)
> > -{
> > -	u64 vmcb_phys = virt_to_phys(vmcb);
> > -	struct vmcb_save_area *save = &vmcb->save;
> > -	struct vmcb_control_area *ctrl = &vmcb->control;
> > -	u32 data_seg_attr = 3 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
> > -		| SVM_SELECTOR_DB_MASK | SVM_SELECTOR_G_MASK;
> > -	u32 code_seg_attr = 9 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
> > -		| SVM_SELECTOR_L_MASK | SVM_SELECTOR_G_MASK;
> > -	struct descriptor_table_ptr desc_table_ptr;
> > -
> > -	memset(vmcb, 0, sizeof(*vmcb));
> > -	asm volatile ("vmsave %0" : : "a"(vmcb_phys) : "memory");
> > -	vmcb_set_seg(&save->es, read_es(), 0, -1U, data_seg_attr);
> > -	vmcb_set_seg(&save->cs, read_cs(), 0, -1U, code_seg_attr);
> > -	vmcb_set_seg(&save->ss, read_ss(), 0, -1U, data_seg_attr);
> > -	vmcb_set_seg(&save->ds, read_ds(), 0, -1U, data_seg_attr);
> > -	sgdt(&desc_table_ptr);
> > -	vmcb_set_seg(&save->gdtr, 0, desc_table_ptr.base, desc_table_ptr.limit, 0);
> > -	sidt(&desc_table_ptr);
> > -	vmcb_set_seg(&save->idtr, 0, desc_table_ptr.base, desc_table_ptr.limit, 0);
> > -	ctrl->asid = 1;
> > -	save->cpl = 0;
> > -	save->efer = rdmsr(MSR_EFER);
> > -	save->cr4 = read_cr4();
> > -	save->cr3 = read_cr3();
> > -	save->cr0 = read_cr0();
> > -	save->dr7 = read_dr7();
> > -	save->dr6 = read_dr6();
> > -	save->cr2 = read_cr2();
> > -	save->g_pat = rdmsr(MSR_IA32_CR_PAT);
> > -	save->dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
> > -	ctrl->intercept = (1ULL << INTERCEPT_VMRUN) |
> > -		(1ULL << INTERCEPT_VMMCALL) |
> > -		(1ULL << INTERCEPT_SHUTDOWN);
> > -	ctrl->iopm_base_pa = virt_to_phys(svm_get_io_bitmap());
> > -	ctrl->msrpm_base_pa = virt_to_phys(svm_get_msr_bitmap());
> > -
> > -	if (npt_supported()) {
> > -		ctrl->nested_ctl = 1;
> > -		ctrl->nested_cr3 = (u64)npt_get_pml4e();
> > -		ctrl->tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
> > -	}
> > -}
> > -
> >  struct regs regs;
> >  
> >  struct regs get_regs(void)
> > diff --git a/x86/svm.h b/x86/svm.h
> > index 67f3205d..a4aabeb2 100644
> > --- a/x86/svm.h
> > +++ b/x86/svm.h
> > @@ -55,7 +55,6 @@ bool default_finished(struct svm_test *test);
> >  int get_test_stage(struct svm_test *test);
> >  void set_test_stage(struct svm_test *test, int s);
> >  void inc_test_stage(struct svm_test *test);
> > -void vmcb_ident(struct vmcb *vmcb);
> >  struct regs get_regs(void);
> >  int __svm_vmrun(u64 rip);
> >  void __svm_bare_vmrun(void);
> > 


