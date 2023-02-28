Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0CC56A609A
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 21:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjB1Uri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 15:47:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjB1Urg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 15:47:36 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2AF34C0E;
        Tue, 28 Feb 2023 12:47:34 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id bi9so14935139lfb.2;
        Tue, 28 Feb 2023 12:47:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677617253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3L1QLt7UDDPEkqiycna07teZMPhk4C+uHRwLWaiwTyc=;
        b=EF6ipXncGR87Hyi7yuIkIWlrhtTuMv9ZwhTzqku5AcU+7xbIZO6LNpXbphdVN/4YTC
         3gHjUpjN3/gvCJa92kzGi7UJiihYkqSxEOEztuC4Y+aG2M6yb9V+VeovWBmIA1OsuUAb
         3SK9TUvY500zI+99tIz5zFv9ukjRv5jeS7Q+4SxyqCUbE9dNb5JsB13QfKf3u29XDdMj
         O8/KtllWWAK6CVQanDx1FYpD3YBdhau9KiGWWEGFqMhalWLx3YIm5tJahqV6ilqqMelD
         VRorG8yZYlbEENSGAReaYvRaH26bYF5QJd3SkU7U14t1Vi8qX9W/UJSnKrIzGThs+lL/
         0FAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677617253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3L1QLt7UDDPEkqiycna07teZMPhk4C+uHRwLWaiwTyc=;
        b=uuc1+r4Zxf2je8aL2IT5bERjRQzOVtBwfiSAVG6ql/FcK8eKcdXY1w3TflmzSz6+Gj
         7GOn4C448gQPz7WrGWed1PZqbLF+zH7aOjHoAktc1NezjoGwF44ZG5FfizMCdhQRrlHu
         mini6Ky7q5G+BMpjAwseDrQdYMhxAb4WU+m8caLoVbRJyllt+2jOv9ilqyzLMfTMyAe+
         HZIddV16KQElTOv5yUD0Isj1xnW52XG5pDcEBqCcj2aXVMVjwuqrt8fAY2pzWwgKVBSR
         xuLorx5+4sbJO/o4oYtjRkHdOIYy3BsaPeaSfEDZq1UtKgTei152Kh4SelBdk0Gt++o5
         JKSg==
X-Gm-Message-State: AO0yUKVLSPdw18WkPxtG6Sp4rcG/N1XcLIAJGugtaSG+xhYUnPziaKkF
        bDIypRJe0+43P9JQ0jH5hF4=
X-Google-Smtp-Source: AK7set8v7E0yifOxFvbZFDxajwr0/Pny5hwCohRYpmE+xovY8y4YPAZGRDqcnWw/eas+nkSXmzpyLg==
X-Received: by 2002:ac2:4c21:0:b0:4b5:a7c7:9dc4 with SMTP id u1-20020ac24c21000000b004b5a7c79dc4mr805829lfq.3.1677617252760;
        Tue, 28 Feb 2023 12:47:32 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id t4-20020ac25484000000b004b592043413sm1478655lfk.12.2023.02.28.12.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 12:47:32 -0800 (PST)
From:   Zhi Wang <zhi.wang.linux@gmail.com>
X-Google-Original-From: Zhi Wang <zhi.wang.linux@intel.com>
Date:   Tue, 28 Feb 2023 22:47:30 +0200
To:     Alexander Graf <graf@amazon.com>
Cc:     Michael Roth <michael.roth@amd.com>, <kvm@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v8 47/56] KVM: SVM: Support SEV-SNP AP Creation NAE
 event
Message-ID: <20230228224730.00007d21@intel.com>
In-Reply-To: <09696af0-b72d-29e7-862b-22ae4a630299@amazon.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-48-michael.roth@amd.com>
        <09696af0-b72d-29e7-862b-22ae4a630299@amazon.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Feb 2023 13:37:48 +0100
Alexander Graf <graf@amazon.com> wrote:

> 
> On 20.02.23 19:38, Michael Roth wrote:
> > From: Tom Lendacky <thomas.lendacky@amd.com>
> >
> > Add support for the SEV-SNP AP Creation NAE event. This allows SEV-SNP
> > guests to alter the register state of the APs on their own. This allows
> > the guest a way of simulating INIT-SIPI.
> >
> > A new event, KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, is created and used
> > so as to avoid updating the VMSA pointer while the vCPU is running.
> >
> > For CREATE
> >    The guest supplies the GPA of the VMSA to be used for the vCPU with
> >    the specified APIC ID. The GPA is saved in the svm struct of the
> >    target vCPU, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is added
> >    to the vCPU and then the vCPU is kicked.
> >
> > For CREATE_ON_INIT:
> >    The guest supplies the GPA of the VMSA to be used for the vCPU with
> >    the specified APIC ID the next time an INIT is performed. The GPA is
> >    saved in the svm struct of the target vCPU.
> >
> > For DESTROY:
> >    The guest indicates it wishes to stop the vCPU. The GPA is cleared
> >    from the svm struct, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is
> >    added to vCPU and then the vCPU is kicked.
> >
> > The KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event handler will be invoked
> > as a result of the event or as a result of an INIT. The handler sets the
> > vCPU to the KVM_MP_STATE_UNINITIALIZED state, so that any errors will
> > leave the vCPU as not runnable. Any previous VMSA pages that were
> > installed as part of an SEV-SNP AP Creation NAE event are un-pinned. If
> > a new VMSA is to be installed, the VMSA guest page is pinned and set as
> > the VMSA in the vCPU VMCB and the vCPU state is set to
> > KVM_MP_STATE_RUNNABLE. If a new VMSA is not to be installed, the VMSA is
> > cleared in the vCPU VMCB and the vCPU state is left as
> > KVM_MP_STATE_UNINITIALIZED to prevent it from being run.
> >
> > Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > [mdr: add handling for restrictedmem]
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> 
> 
> What is the intended boot sequence for SEV-SNP guests? FWIW with this 
> interface in place, guests will typically use in-guest VMSA pages to 
> hold secondary vcpu state. But that means we're now allocating 4kb of 
> memory for every vcpu that we create that will be for most of the 
> guest's lifetime superfluous.
> 
> Wouldn't it make more sense to have a model where we only allocate the 
> VMSA for the boot CPU and leave secondary allocation to the guest? We 
> already need firmware changes for SEV-SNP - may as well make this one more.
> 
> [...]
> 
> > +
> > +static int sev_snp_ap_creation(struct vcpu_svm *svm)
> > +{
> > +       struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
> > +       struct kvm_vcpu *vcpu = &svm->vcpu;
> > +       struct kvm_vcpu *target_vcpu;
> > +       struct vcpu_svm *target_svm;
> > +       unsigned int request;
> > +       unsigned int apic_id;
> > +       bool kick;
> > +       int ret;
> > +
> > +       request = lower_32_bits(svm->vmcb->control.exit_info_1);
> > +       apic_id = upper_32_bits(svm->vmcb->control.exit_info_1);
> > +
> > +       /* Validate the APIC ID */
> > +       target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, apic_id);
> 
> 
> Out of curiosity: The target CPU can be my own vCPU, right?
> 
> 
> > +       if (!target_vcpu) {
> > +               vcpu_unimpl(vcpu, "vmgexit: invalid AP APIC ID [%#x] from guest\n",
> > +                           apic_id);
> > +               return -EINVAL;
> > +       }
> > +
> > +       ret = 0;
> > +
> > +       target_svm = to_svm(target_vcpu);
> > +
> > +       /*
> > +        * The target vCPU is valid, so the vCPU will be kicked unless the
> > +        * request is for CREATE_ON_INIT. For any errors at this stage, the
> > +        * kick will place the vCPU in an non-runnable state.
> > +        */
> > +       kick = true;
> > +
> > +       mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
> > +
> > +       target_svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
> > +       target_svm->sev_es.snp_ap_create = true;
> > +
> > +       /* Interrupt injection mode shouldn't change for AP creation */
> > +       if (request < SVM_VMGEXIT_AP_DESTROY) {
> > +               u64 sev_features;
> > +
> > +               sev_features = vcpu->arch.regs[VCPU_REGS_RAX];
> > +               sev_features ^= sev->sev_features;
> > +               if (sev_features & SVM_SEV_FEAT_INT_INJ_MODES) {
> > +                       vcpu_unimpl(vcpu, "vmgexit: invalid AP injection mode [%#lx] from guest\n",
> > +                                   vcpu->arch.regs[VCPU_REGS_RAX]);
> > +                       ret = -EINVAL;
> > +                       goto out;
> > +               }
> > +       }
> > +
> > +       switch (request) {
> > +       case SVM_VMGEXIT_AP_CREATE_ON_INIT:
> > +               kick = false;
> > +               fallthrough;
> > +       case SVM_VMGEXIT_AP_CREATE:
> > +               if (!page_address_valid(vcpu, svm->vmcb->control.exit_info_2)) {
> > +                       vcpu_unimpl(vcpu, "vmgexit: invalid AP VMSA address [%#llx] from guest\n",
> > +                                   svm->vmcb->control.exit_info_2);
> > +                       ret = -EINVAL;
> > +                       goto out;
> > +               }
> > +
> > +               /*
> > +                * Malicious guest can RMPADJUST a large page into VMSA which
> > +                * will hit the SNP erratum where the CPU will incorrectly signal
> > +                * an RMP violation #PF if a hugepage collides with the RMP entry
> > +                * of VMSA page, reject the AP CREATE request if VMSA address from
> > +                * guest is 2M aligned.
> 
> 
> This will break genuine current Linux kernels that just happen to 
> allocate a guest page, no? In fact, given enough vCPUs you're almost 
> guaranteed to hit an aligned structure somewhere. What is the guest 
> supposed to do in that situation?
> 
> 
> > +                */
> > +               if (IS_ALIGNED(svm->vmcb->control.exit_info_2, PMD_SIZE)) {
> > +                       vcpu_unimpl(vcpu,
> > +                                   "vmgexit: AP VMSA address [%llx] from guest is unsafe as it is 2M aligned\n",
> > +                                   svm->vmcb->control.exit_info_2);
> > +                       ret = -EINVAL;
> > +                       goto out;
> > +               }
> > +
> > +               target_svm->sev_es.snp_vmsa_gpa = svm->vmcb->control.exit_info_2;
> > +               break;
> > +       case SVM_VMGEXIT_AP_DESTROY:
> 
> 
> I don't understand the destroy path. Why does this case destroy anything?
> 
> 
> > +               break;
> > +       default:
> > +               vcpu_unimpl(vcpu, "vmgexit: invalid AP creation request [%#x] from guest\n",
> > +                           request);
> > +               ret = -EINVAL;
> > +               break;
> > +       }
> > +
> > +out:
> > +       if (kick) {
> > +               if (target_vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)
> > +                       target_vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> 
> 
> What if the guest AP goes through a create -> destroy -> create cycle? 
> Will it stay runnable while destroyed?

The code is not very straightforward.

1) target_svm->sev_es.snp_vmsa_gpa is set as INVALID_PAGE in the beginning of this function.

2) If a DESTROY is hit in this function, target_svm->sev_es.snp_vmsa_gpa will be
left as INVALID_PAGE.

3) At the end of this function, it calls kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE).

4) In the vcpu_enter_guest(), the kvm_vcpu_reset()->sev_snp_init_protected_guest_state()
->__sev_snp_init_protected_guest_state() is called.

5) The mp_state is set to KVM_MP_STATE_STOPPED by default and the runtime VMSA is
cleared. Then the it will be initialized according to the guest's
configuration.

6) As the snp_vmsa_gpa is set as INVALID_PAGE in 1, the mp_state will be left as
KVM_MP_STATE_STOPPED.

7) With this code piece:

+			kvm_vcpu_reset(vcpu, true);
+			if (vcpu->arch.mp_state != KVM_MP_STATE_RUNNABLE)
+				goto out;

vcpu_enter_guest() bails out.

> 
> 
> Alex
> 
> > +
> > +               kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
> > +               kvm_vcpu_kick(target_vcpu);
> > +       }
> > +
> > +       mutex_unlock(&target_svm->sev_es.snp_vmsa_mutex);
> > +
> > +       return ret;
> > +}
> > +
> >   static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
> >   {
> >          struct vmcb_control_area *control = &svm->vmcb->control;
> 
> 
> 
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
> 
> 

