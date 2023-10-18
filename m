Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B769C7CDDCE
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 15:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344769AbjJRNta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 09:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbjJRNt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 09:49:28 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6348483
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 06:49:26 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7e4745acdso106202607b3.3
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 06:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697636965; x=1698241765; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oAKQqv24W/9hoLdu1u7LFvXDRMO4zQJ7ELL3SC0djfQ=;
        b=c1Xvf5t3s89nck10DSfNNlbRbcPsupbZBLZHwZyNvB94VcmgZgnAWEkMqQl5ftQ+5d
         xS63zD9bsLM2Dg3j5g6AmLNfHvWLx/efYF+PHwoLoMym7/kFqJa3jlOd7qMai9xYztJf
         WBYb9nNsGqXhzCJPicHm7BTxsTGs37hhknTZSV4kLUtRL/zGipk95H2GHp/zp0uqbFMk
         gBCW6oHmvuFVGwl6XyystmVFBVKdTEZI3ts91fVh2VjNgzMcqZAGGMYTXkKS21mbpneL
         h4ToymtErcJ56Jx+lTaSfMjMXRbz9oRaratqWka1KXMP5acuSCKgjGbHU1IEzO4NduUu
         //sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697636965; x=1698241765;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oAKQqv24W/9hoLdu1u7LFvXDRMO4zQJ7ELL3SC0djfQ=;
        b=L31opcvYqR6pCxm2NHXPumhkGmBDydxYxbevEmHdAomef5FTkYOQ/d+52f/rcdH2Zg
         qtmt0G/hP3jdLu/kr8RPrAC+8JcxQ2h7hPbfopnQ0nvY4iFG5NePQ6ePf9ySEQa6KJAo
         /3ucWrYFvG657eTSQGIA8Gpo1vID2R6Ei3HY2KexV7Z+fdKoCkLysd0NkaR3J6pnGG4X
         WBpUpKaiZIjDZIREwQi6QcQaCn5KAmsDVdOYeC42TqVla+iCC6BxrE7WfEyAGJoOjbHb
         e4/pL4kEKCC+nDndlPJFdMsnDhGfdrucjmAJYK2571+3R8mWZJa6wP2u5OZiDp770lFK
         tD7A==
X-Gm-Message-State: AOJu0Yytm1jXb4tRtHdPlUHyHj1JCSnRECYz3RHKOlgph242aSP0It/O
        +4fU/N9yw0qlBhd4OKQnKazGuUcEaU8=
X-Google-Smtp-Source: AGHT+IHnFQDi3IwMQOX78sjRJgZJ8FaG1+pts8CizuoqnC8OKrYfZy+4dJST840bISoqEf+kFNtJYopCXPU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:dbd2:0:b0:583:4f82:b9d9 with SMTP id
 d201-20020a0ddbd2000000b005834f82b9d9mr132011ywe.5.1697636965615; Wed, 18 Oct
 2023 06:49:25 -0700 (PDT)
Date:   Wed, 18 Oct 2023 06:48:59 -0700
In-Reply-To: <b9da2fed-b527-4242-a588-7fc3ee6c9070@amd.com>
Mime-Version: 1.0
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-49-michael.roth@amd.com> <CAAH4kHb=hNH88poYw-fj+ewYgt8F-hseZcRuLDdvbgpSQ5FDZQ@mail.gmail.com>
 <ZS614OSoritrE1d2@google.com> <b9da2fed-b527-4242-a588-7fc3ee6c9070@amd.com>
Message-ID: <ZS_iS4UOgBbssp7Z@google.com>
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     Dionna Amalie Glaze <dionnaglaze@google.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
        pankaj.gupta@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023, Alexey Kardashevskiy wrote:
> 
> On 18/10/23 03:27, Sean Christopherson wrote:
> > On Mon, Oct 16, 2023, Dionna Amalie Glaze wrote:
> > > > +
> > > > +       /*
> > > > +        * If a VMM-specific certificate blob hasn't been provided, grab the
> > > > +        * host-wide one.
> > > > +        */
> > > > +       snp_certs = sev_snp_certs_get(sev->snp_certs);
> > > > +       if (!snp_certs)
> > > > +               snp_certs = sev_snp_global_certs_get();
> > > > +
> > > 
> > > This is where the generation I suggested adding would get checked. If
> > > the instance certs' generation is not the global generation, then I
> > > think we need a way to return to the VMM to make that right before
> > > continuing to provide outdated certificates.
> > > This might be an unreasonable request, but the fact that the certs and
> > > reported_tcb can be set while a VM is running makes this an issue.
> > 
> > Before we get that far, the changelogs need to explain why the kernel is storing
> > userspace blobs in the first place.  The whole thing is a bit of a mess.
> > 
> > sev_snp_global_certs_get() has data races that could lead to variations of TOCTOU
> > bugs: sev_ioctl_snp_set_config() can overwrite psp_master->sev_data->snp_certs
> > while sev_snp_global_certs_get() is running.  If the compiler reloads snp_certs
> > between bumping the refcount and grabbing the pointer, KVM will end up leaking a
> > refcount and consuming a pointer without a refcount.
> > 
> > 	if (!kref_get_unless_zero(&certs->kref))
> > 		return NULL;
> > 
> > 	return certs;
> 
> I'm missing something here. The @certs pointer is on the stack,

No, nothing guarantees that @certs is on the stack and will never be reloaded.
sev_snp_certs_get() is in full view of sev_snp_global_certs_get(), so it's entirely
possible that it can be inlined.  Then you end up with:

	struct sev_device *sev;

	if (!psp_master || !psp_master->sev_data)
		return NULL;

	sev = psp_master->sev_data;
	if (!sev->snp_initialized)
		return NULL;

	if (!sev->snp_certs)
		return NULL;

	if (!kref_get_unless_zero(&sev->snp_certs->kref))
		return NULL;

	return sev->snp_certs;

At which point the compiler could choose to omit a local variable entirely, it
could store @certs in a register and reload after kref_get_unless_zero(), etc.
If psp_master->sev_data->snp_certs is changed at any point, odd thing can happen.

That atomic operation in kref_get_unless_zero() might prevent a reload between
getting the kref and the return, but it wouldn't prevent a reload between the
!NULL check and kref_get_unless_zero().

> > If userspace wants to provide garbage to the guest, so be it, not KVM's problem.
> > That way, whether the VM gets the global cert or a per-VM cert is purely a userspace
> > concern.
> 
> The global cert lives in CCP (/dev/sev), the per VM cert lives in kvmvm_fd.
> "A la vcpu->run" is fine for the latter but for the former we need something
> else.

Why?  The cert ultimately comes from userspace, no?  Make userspace deal with it.

> And there is scenario when one global certs blob is what is needed and
> copying it over multiple VMs seems suboptimal.

That's a solvable problem.  I'm not sure I like the most obvious solution, but it
is a solution: let userspace define a KVM-wide blob pointer, either via .mmap()
or via an ioctl().

FWIW, there's no need to do .mmap() shenanigans, e.g. an ioctl() to set the
userspace pointer would suffice.  The benefit of a kernel controlled pointer is
that it doesn't require copying to a kernel buffer (or special code to copy from
userspace into guest).

Actually, looking at the flow again, AFAICT there's nothing special about the
target DATA_PAGE.  It must be SHARED *before* SVM_VMGEXIT_EXT_GUEST_REQUEST, i.e.
KVM doesn't need to do conversions, there's no kernel priveleges required, etc.
And the GHCB doesn't dictate ordering between storing the certificates and doing
the request.  That means the certificate stuff can be punted entirely to usersepace.

Heh, typing up the below, there's another bug: KVM will incorrectly "return" '0'
for non-SNP guests:

	unsigned long exitcode = 0;
	u64 data_gpa;
	int err, rc;

	if (!sev_snp_guest(vcpu->kvm)) {
		rc = SEV_RET_INVALID_GUEST; <= sets "rc", not "exitcode"
		goto e_fail;
	}

e_fail:
	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, exitcode);

Which really highlights that we need to get test infrastructure up and running
for SEV-ES, SNP, and TDX.

Anyways, back to punting to userspace.  Here's a rough sketch.  The only new uAPI
is the definition of KVM_HC_SNP_GET_CERTS and its arguments.

static void snp_handle_guest_request(struct vcpu_svm *svm)
{
	struct vmcb_control_area *control = &svm->vmcb->control;
	struct sev_data_snp_guest_request data = {0};
	struct kvm_vcpu *vcpu = &svm->vcpu;
	struct kvm *kvm = vcpu->kvm;
	struct kvm_sev_info *sev;
	gpa_t req_gpa = control->exit_info_1;
	gpa_t resp_gpa = control->exit_info_2;
	unsigned long rc;
	int err;

	if (!sev_snp_guest(vcpu->kvm)) {
		rc = SEV_RET_INVALID_GUEST;
		goto e_fail;
	}

	sev = &to_kvm_svm(kvm)->sev_info;

	mutex_lock(&sev->guest_req_lock);

	rc = snp_setup_guest_buf(svm, &data, req_gpa, resp_gpa);
	if (rc)
		goto unlock;

	rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &err);
	if (rc)
		/* Ensure an error value is returned to guest. */
		rc = err ? err : SEV_RET_INVALID_ADDRESS;

	snp_cleanup_guest_buf(&data, &rc);

unlock:
	mutex_unlock(&sev->guest_req_lock);

e_fail:
	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, rc);
}

static int snp_complete_ext_guest_request(struct kvm_vcpu *vcpu)
{
	u64 certs_exitcode = vcpu->run->hypercall.args[2];
	struct vcpu_svm *svm = to_svm(vcpu);

	if (certs_exitcode)
		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, certs_exitcode);
	else
		snp_handle_guest_request(svm);
	return 1;
}

static int snp_handle_ext_guest_request(struct vcpu_svm *svm)
{
	struct kvm_vcpu *vcpu = &svm->vcpu;
	struct kvm *kvm = vcpu->kvm;
	struct kvm_sev_info *sev;
	unsigned long exitcode;
	u64 data_gpa;

	if (!sev_snp_guest(vcpu->kvm)) {
		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SEV_RET_INVALID_GUEST);
		return 1;
	}

	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
	if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SEV_RET_INVALID_ADDRESS);
		return 1;
	}

	vcpu->run->hypercall.nr		 = KVM_HC_SNP_GET_CERTS;
	vcpu->run->hypercall.args[0]	 = data_gpa;
	vcpu->run->hypercall.args[1]	 = vcpu->arch.regs[VCPU_REGS_RBX];
	vcpu->run->hypercall.flags	 = KVM_EXIT_HYPERCALL_LONG_MODE;
	vcpu->arch.complete_userspace_io = snp_complete_ext_guest_request;
	return 0;
}

