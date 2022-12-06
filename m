Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17E7964451A
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 14:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbiLFN5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 08:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbiLFN5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 08:57:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA2E2CC8D
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 05:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670334992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wSprF/sRagL1l078J8sg2AYSRdpDVUG1pvsXbEchjSs=;
        b=Hlhq4Cdqda/4y+sVTZi9B4wahhy0/m+G0aepD4cAv6U1Fbr8qvmPiwQBbEwdr0/bCIGHtf
        9O52nl6kIhr8cC7ypVIjkaaO2xYG9E5tj5U1D6qh33KRPUrn9q5JsAGJQyaBP3gcNvV5Yx
        YeV8irXi2z+FdG4u4+xiFjBEpoDDXjM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-esplx2gMMTekWtR8KLgvPQ-1; Tue, 06 Dec 2022 08:56:29 -0500
X-MC-Unique: esplx2gMMTekWtR8KLgvPQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C81D18630D4;
        Tue,  6 Dec 2022 13:56:28 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BCDFEC16932;
        Tue,  6 Dec 2022 13:56:26 +0000 (UTC)
Message-ID: <7d7f580b16f41688f7b483993e1d1ae026f41825.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 21/27] svm: cleanup the default_prepare
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
Date:   Tue, 06 Dec 2022 15:56:25 +0200
In-Reply-To: <297e66f8-3e6d-bcd4-2ce4-aeb25f6cb699@redhat.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
         <20221122161152.293072-22-mlevitsk@redhat.com>
         <297e66f8-3e6d-bcd4-2ce4-aeb25f6cb699@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-12-02 at 10:45 +0100, Emanuele Giuseppe Esposito wrote:
> 
> Am 22/11/2022 um 17:11 schrieb Maxim Levitsky:
> > default_prepare only calls vmcb_indent, which is called before
> > each test anyway
> > 
> > Also don't call this now empty function from other
> > .prepare functions
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  x86/svm.c       |  1 -
> >  x86/svm_tests.c | 18 ------------------
> >  2 files changed, 19 deletions(-)
> > 
> > diff --git a/x86/svm.c b/x86/svm.c
> > index 2ab553a5..5667402b 100644
> > --- a/x86/svm.c
> > +++ b/x86/svm.c
> > @@ -30,7 +30,6 @@ bool default_supported(void)
> >  
> >  void default_prepare(struct svm_test *test)
> >  {
> > -	vmcb_ident(vmcb);
> >  }
> 
> Makes sense removing it, but maybe remove the function alltogether since
> it is not used anymore and then change test_run() to handle ->prepare ==
> NULL?


I had a version of the refactoring which removed all of these, but that made
the table of unit tests look ugly with all the NULL's there, which suggests
that this table should be rewrittern to use named initializers.

I decided to drop off this for now, so I'll do that later.

Best regards,
	Maxim Levitsky

> 
> >  
> >  void default_prepare_gif_clear(struct svm_test *test)
> > diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> > index 70e41300..3b68718e 100644
> > --- a/x86/svm_tests.c
> > +++ b/x86/svm_tests.c
> > @@ -69,7 +69,6 @@ static bool check_vmrun(struct svm_test *test)
> >  
> >  static void prepare_rsm_intercept(struct svm_test *test)
> >  {
> > -	default_prepare(test);
> >  	vmcb->control.intercept |= 1 << INTERCEPT_RSM;
> >  	vmcb->control.intercept_exceptions |= (1ULL << UD_VECTOR);
> >  }
> > @@ -115,7 +114,6 @@ static bool finished_rsm_intercept(struct svm_test *test)
> >  
> >  static void prepare_cr3_intercept(struct svm_test *test)
> >  {
> > -	default_prepare(test);
> >  	vmcb->control.intercept_cr_read |= 1 << 3;
> >  }
> >  
> > @@ -149,7 +147,6 @@ static void corrupt_cr3_intercept_bypass(void *_test)
> >  
> >  static void prepare_cr3_intercept_bypass(struct svm_test *test)
> >  {
> > -	default_prepare(test);
> >  	vmcb->control.intercept_cr_read |= 1 << 3;
> >  	on_cpu_async(1, corrupt_cr3_intercept_bypass, test);
> >  }
> > @@ -169,7 +166,6 @@ static void test_cr3_intercept_bypass(struct svm_test *test)
> >  
> >  static void prepare_dr_intercept(struct svm_test *test)
> >  {
> > -	default_prepare(test);
> >  	vmcb->control.intercept_dr_read = 0xff;
> >  	vmcb->control.intercept_dr_write = 0xff;
> >  }
> > @@ -310,7 +306,6 @@ static bool check_next_rip(struct svm_test *test)
> >  
> >  static void prepare_msr_intercept(struct svm_test *test)
> >  {
> > -	default_prepare(test);
> >  	vmcb->control.intercept |= (1ULL << INTERCEPT_MSR_PROT);
> >  	vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
> >  	memset(svm_get_msr_bitmap(), 0xff, MSR_BITMAP_SIZE);
> > @@ -711,7 +706,6 @@ static bool tsc_adjust_supported(void)
> >  
> >  static void tsc_adjust_prepare(struct svm_test *test)
> >  {
> > -	default_prepare(test);
> >  	vmcb->control.tsc_offset = TSC_OFFSET_VALUE;
> >  
> >  	wrmsr(MSR_IA32_TSC_ADJUST, -TSC_ADJUST_VALUE);
> > @@ -811,7 +805,6 @@ static void svm_tsc_scale_test(void)
> >  
> >  static void latency_prepare(struct svm_test *test)
> >  {
> > -	default_prepare(test);
> >  	runs = LATENCY_RUNS;
> >  	latvmrun_min = latvmexit_min = -1ULL;
> >  	latvmrun_max = latvmexit_max = 0;
> > @@ -884,7 +877,6 @@ static bool latency_check(struct svm_test *test)
> >  
> >  static void lat_svm_insn_prepare(struct svm_test *test)
> >  {
> > -	default_prepare(test);
> >  	runs = LATENCY_RUNS;
> >  	latvmload_min = latvmsave_min = latstgi_min = latclgi_min = -1ULL;
> >  	latvmload_max = latvmsave_max = latstgi_max = latclgi_max = 0;
> > @@ -965,7 +957,6 @@ static void pending_event_prepare(struct svm_test *test)
> >  {
> >  	int ipi_vector = 0xf1;
> >  
> > -	default_prepare(test);
> >  
> >  	pending_event_ipi_fired = false;
> >  
> > @@ -1033,8 +1024,6 @@ static bool pending_event_check(struct svm_test *test)
> >  
> >  static void pending_event_cli_prepare(struct svm_test *test)
> >  {
> > -	default_prepare(test);
> > -
> >  	pending_event_ipi_fired = false;
> >  
> >  	handle_irq(0xf1, pending_event_ipi_isr);
> > @@ -1139,7 +1128,6 @@ static void timer_isr(isr_regs_t *regs)
> >  
> >  static void interrupt_prepare(struct svm_test *test)
> >  {
> > -	default_prepare(test);
> >  	handle_irq(TIMER_VECTOR, timer_isr);
> >  	timer_fired = false;
> >  	set_test_stage(test, 0);
> > @@ -1272,7 +1260,6 @@ static void nmi_handler(struct ex_regs *regs)
> >  
> >  static void nmi_prepare(struct svm_test *test)
> >  {
> > -	default_prepare(test);
> >  	nmi_fired = false;
> >  	handle_exception(NMI_VECTOR, nmi_handler);
> >  	set_test_stage(test, 0);
> > @@ -1450,7 +1437,6 @@ static void my_isr(struct ex_regs *r)
> >  
> >  static void exc_inject_prepare(struct svm_test *test)
> >  {
> > -	default_prepare(test);
> >  	handle_exception(DE_VECTOR, my_isr);
> >  	handle_exception(NMI_VECTOR, my_isr);
> >  }
> > @@ -1519,7 +1505,6 @@ static void virq_isr(isr_regs_t *regs)
> >  static void virq_inject_prepare(struct svm_test *test)
> >  {
> >  	handle_irq(0xf1, virq_isr);
> > -	default_prepare(test);
> >  	vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
> >  		(0x0f << V_INTR_PRIO_SHIFT); // Set to the highest priority
> >  	vmcb->control.int_vector = 0xf1;
> > @@ -1682,7 +1667,6 @@ static void reg_corruption_isr(isr_regs_t *regs)
> >  
> >  static void reg_corruption_prepare(struct svm_test *test)
> >  {
> > -	default_prepare(test);
> >  	set_test_stage(test, 0);
> >  
> >  	vmcb->control.int_ctl = V_INTR_MASKING_MASK;
> > @@ -1877,7 +1861,6 @@ static void host_rflags_db_handler(struct ex_regs *r)
> >  
> >  static void host_rflags_prepare(struct svm_test *test)
> >  {
> > -	default_prepare(test);
> >  	handle_exception(DB_VECTOR, host_rflags_db_handler);
> >  	set_test_stage(test, 0);
> >  }
> > @@ -2610,7 +2593,6 @@ static void svm_vmload_vmsave(void)
> >  
> >  static void prepare_vgif_enabled(struct svm_test *test)
> >  {
> > -	default_prepare(test);
> >  }
> >  
> >  static void test_vgif(struct svm_test *test)
> > 




