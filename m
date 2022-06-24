Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434AD559E83
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 18:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiFXQ0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 12:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbiFXQZv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 12:25:51 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6E067E78
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 09:25:35 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id w20so5313312lfa.11
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 09:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7sfkYHgtbrbvRGaQ8qGJyoZw24OZdcFRjeTJQ0mC8q4=;
        b=Bpuvm7GZi0KpPV9CEvl2ZIxQGNNzpQfrEgbiAWnDFyUyNTloQ1P9ixD/SgxfYKlOVE
         F0CDg/mQmug/gIW536C/uzDniUPU/hl0pXQAKy/zb6ff+vbuxbXoler9iXN1xTB8dU9r
         3GHeKa4WME/VmHifB9h/fTx60FyJvwXKIYocKDXGDGgmIuA5A2IjqldJtNFkVk7hTLAo
         Q+1y8n1IsKQxljxIUGPtLjYPvMetq7k8Ip3i8Vl7fFR+QdOV/RJhGszjxs4/Rh5DDNVI
         jnaS4w973Y3Trei9qw+FNNZgSZUFfQyEYfHFsSsQRZtahn0tEo8tLSL/l1NQ1DGImPq6
         vTCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7sfkYHgtbrbvRGaQ8qGJyoZw24OZdcFRjeTJQ0mC8q4=;
        b=GPrT6Uj5qq34wI/5HMXNwIU06Y4yDeNrpcLDrIvvvpxzs+WJjcDjP6i+J6Gc0l4efY
         OXoNOpAKaKiQsv92yyHpAo61wo3coyk1c9Nenao9Fz7I5jGGH60qozDim43BHOvpPu+0
         o/xCm1mI/GzFRLh/h4XZI4VShHNcN87PIikxO1Eyp2gFTrRGOMEy6jzLym7vSj3ok9em
         7zgq9guppLhMEZOqxavBKe6EI4k5Yk1zGDerw8rz56priQAH0odIwjcduGY0un2h5aDw
         8p1EubwlzJarbojNo/XX/F4RvmnWEsDuZIUeQ+mEHhOekako7SoBq+wmZRqqzQFSdfVQ
         vJkA==
X-Gm-Message-State: AJIora977izUZ6WSXMwYqIdMPXHisYDpmXz1+1dvW4jkq89nKnxIFdrE
        OnfSCYBJjTTxiV9H75ua3xcRQWYTU2AL/0pLvxlWYg==
X-Google-Smtp-Source: AGRyM1sXtqDomYOcNv9VoYB53aObLHNx+adeM1Ml3hiisDwkj9xMA0c9em4sVv6VpCS2bsk4MEFITCr2Dix8IeZEXBY=
X-Received: by 2002:a05:6512:401a:b0:47f:6ea5:dace with SMTP id
 br26-20020a056512401a00b0047f6ea5dacemr9227307lfb.402.1656087933300; Fri, 24
 Jun 2022 09:25:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <5d05799fc61994684aa2b2ddb8c5b326a3279e25.1655761627.git.ashish.kalra@amd.com>
In-Reply-To: <5d05799fc61994684aa2b2ddb8c5b326a3279e25.1655761627.git.ashish.kalra@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 24 Jun 2022 10:25:21 -0600
Message-ID: <CAMkAt6rGzSewSyO1uZehWUD2J6aLtRwP5N-uj-HPG73Pp0=Sjw@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 42/49] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, jarkko@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 5:13 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> Version 2 of GHCB specification added the support for two SNP Guest
> Request Message NAE events. The events allows for an SEV-SNP guest to
> make request to the SEV-SNP firmware through hypervisor using the
> SNP_GUEST_REQUEST API define in the SEV-SNP firmware specification.
>
> The SNP_EXT_GUEST_REQUEST is similar to SNP_GUEST_REQUEST with the
> difference of an additional certificate blob that can be passed through
> the SNP_SET_CONFIG ioctl defined in the CCP driver. The CCP driver
> provides snp_guest_ext_guest_request() that is used by the KVM to get
> both the report and certificate data at once.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 196 +++++++++++++++++++++++++++++++++++++++--
>  arch/x86/kvm/svm/svm.h |   2 +
>  2 files changed, 192 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7fc0fad87054..089af21a4efe 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -343,6 +343,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>
>                 spin_lock_init(&sev->psc_lock);
>                 ret = sev_snp_init(&argp->error);
> +               mutex_init(&sev->guest_req_lock);
>         } else {
>                 ret = sev_platform_init(&argp->error);
>         }
> @@ -1884,23 +1885,39 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>
>  static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> +       void *context = NULL, *certs_data = NULL, *resp_page = NULL;

Is the NULL setting here unnecessary since all of these are set via
functions snp_alloc_firmware_page(), kmalloc(), and
snp_alloc_firmware_page() respectively?

> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>         struct sev_data_snp_gctx_create data = {};
> -       void *context;
>         int rc;
>
> +       /* Allocate memory used for the certs data in SNP guest request */
> +       certs_data = kmalloc(SEV_FW_BLOB_MAX_SIZE, GFP_KERNEL_ACCOUNT);
> +       if (!certs_data)
> +               return NULL;

I think we want to use kzalloc() here to ensure we never give the
guest uninitialized kernel memory.

> +
>         /* Allocate memory for context page */
>         context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
>         if (!context)
> -               return NULL;
> +               goto e_free;
> +
> +       /* Allocate a firmware buffer used during the guest command handling. */
> +       resp_page = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
> +       if (!resp_page)
> +               goto e_free;

|resp_page| doesn't appear to be used anywhere?

>
>         data.gctx_paddr = __psp_pa(context);
>         rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, &data, &argp->error);
> -       if (rc) {
> -               snp_free_firmware_page(context);
> -               return NULL;
> -       }
> +       if (rc)
> +               goto e_free;
> +
> +       sev->snp_certs_data = certs_data;
>
>         return context;
> +
> +e_free:
> +       snp_free_firmware_page(context);
> +       kfree(certs_data);
> +       return NULL;
>  }
>
>  static int snp_bind_asid(struct kvm *kvm, int *error)
> @@ -2565,6 +2582,8 @@ static int snp_decommission_context(struct kvm *kvm)
>         snp_free_firmware_page(sev->snp_context);
>         sev->snp_context = NULL;
>
> +       kfree(sev->snp_certs_data);
> +
>         return 0;
>  }
>
> @@ -3077,6 +3096,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm, u64 *exit_code)
>         case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>         case SVM_VMGEXIT_HV_FEATURES:
>         case SVM_VMGEXIT_PSC:
> +       case SVM_VMGEXIT_GUEST_REQUEST:
> +       case SVM_VMGEXIT_EXT_GUEST_REQUEST:
>                 break;
>         default:
>                 reason = GHCB_ERR_INVALID_EVENT;
> @@ -3502,6 +3523,155 @@ static unsigned long snp_handle_page_state_change(struct vcpu_svm *svm)
>         return rc ? map_to_psc_vmgexit_code(rc) : 0;
>  }
>
> +static unsigned long snp_setup_guest_buf(struct vcpu_svm *svm,
> +                                        struct sev_data_snp_guest_request *data,
> +                                        gpa_t req_gpa, gpa_t resp_gpa)
> +{
> +       struct kvm_vcpu *vcpu = &svm->vcpu;
> +       struct kvm *kvm = vcpu->kvm;
> +       kvm_pfn_t req_pfn, resp_pfn;
> +       struct kvm_sev_info *sev;
> +
> +       sev = &to_kvm_svm(kvm)->sev_info;

This is normally done at declaration in this file. Why not here?

      struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;

> +
> +       if (!IS_ALIGNED(req_gpa, PAGE_SIZE) || !IS_ALIGNED(resp_gpa, PAGE_SIZE))
> +               return SEV_RET_INVALID_PARAM;
> +
> +       req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
> +       if (is_error_noslot_pfn(req_pfn))
> +               return SEV_RET_INVALID_ADDRESS;
> +
> +       resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
> +       if (is_error_noslot_pfn(resp_pfn))
> +               return SEV_RET_INVALID_ADDRESS;
> +
> +       if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true))
> +               return SEV_RET_INVALID_ADDRESS;
> +
> +       data->gctx_paddr = __psp_pa(sev->snp_context);
> +       data->req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
> +       data->res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
> +
> +       return 0;
> +}
> +
> +static void snp_cleanup_guest_buf(struct sev_data_snp_guest_request *data, unsigned long *rc)
> +{
> +       u64 pfn = __sme_clr(data->res_paddr) >> PAGE_SHIFT;
> +       int ret;
> +
> +       ret = snp_page_reclaim(pfn);
> +       if (ret)
> +               *rc = SEV_RET_INVALID_ADDRESS;

Do we need a diff error code here? This means the page the guest gives
us is now "stuck" in the FW owned state. How would the guest know this
is the case? We return the exact same error in snp_setup_guest_buf()
if the resp_gpa isn't page aligned so now if the guest ever sees a
SEV_RET_INVALID_ADDRESS I think its only safe option is to either try
and page_state_change it to a know state or mark it as unusable
memory.

> +
> +       ret = rmp_make_shared(pfn, PG_LEVEL_4K);
> +       if (ret)
> +               *rc = SEV_RET_INVALID_ADDRESS;

Ditto here I think we need some way to signal to the guest what state
this page is on return to guest execution.

Also these errors shadow over FW successes, this means the guest's
guest-request-sequence-numbers are now out of sync meaning this VMPCK
is unusable less the guest risk reusing the AES IV (which would break
the confidentiality/integrity). Should we have a way to signal to the
guest the FW has successfully run your command but we could not change
the page states back correctly, so the guest should increment their
sequence numbers.

> +}
> +
> +static void snp_handle_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
> +{
> +       struct sev_data_snp_guest_request data = {0};
> +       struct kvm_vcpu *vcpu = &svm->vcpu;
> +       struct kvm *kvm = vcpu->kvm;
> +       struct kvm_sev_info *sev;
> +       unsigned long rc;
> +       int err;
> +
> +       if (!sev_snp_guest(vcpu->kvm)) {
> +               rc = SEV_RET_INVALID_GUEST;
> +               goto e_fail;
> +       }
> +
> +       sev = &to_kvm_svm(kvm)->sev_info;

Ditto why not due this above?

> +
> +       mutex_lock(&sev->guest_req_lock);
> +
> +       rc = snp_setup_guest_buf(svm, &data, req_gpa, resp_gpa);
> +       if (rc)
> +               goto unlock;
> +
> +       rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &err);
> +       if (rc)
> +               /* use the firmware error code */
> +               rc = err;
> +
> +       snp_cleanup_guest_buf(&data, &rc);
> +
> +unlock:
> +       mutex_unlock(&sev->guest_req_lock);
> +
> +e_fail:
> +       svm_set_ghcb_sw_exit_info_2(vcpu, rc);
> +}
> +
> +static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
> +{
> +       struct sev_data_snp_guest_request req = {0};
> +       struct kvm_vcpu *vcpu = &svm->vcpu;
> +       struct kvm *kvm = vcpu->kvm;
> +       unsigned long data_npages;
> +       struct kvm_sev_info *sev;
> +       unsigned long rc, err;
> +       u64 data_gpa;
> +
> +       if (!sev_snp_guest(vcpu->kvm)) {
> +               rc = SEV_RET_INVALID_GUEST;
> +               goto e_fail;
> +       }
> +
> +       sev = &to_kvm_svm(kvm)->sev_info;
> +
> +       data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
> +       data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
> +
> +       if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
> +               rc = SEV_RET_INVALID_ADDRESS;
> +               goto e_fail;
> +       }
> +
> +       /* Verify that requested blob will fit in certificate buffer */
> +       if ((data_npages << PAGE_SHIFT) > SEV_FW_BLOB_MAX_SIZE) {
> +               rc = SEV_RET_INVALID_PARAM;
> +               goto e_fail;
> +       }
> +
> +       mutex_lock(&sev->guest_req_lock);
> +
> +       rc = snp_setup_guest_buf(svm, &req, req_gpa, resp_gpa);
> +       if (rc)
> +               goto unlock;
> +
> +       rc = snp_guest_ext_guest_request(&req, (unsigned long)sev->snp_certs_data,
> +                                        &data_npages, &err);
> +       if (rc) {
> +               /*
> +                * If buffer length is small then return the expected
> +                * length in rbx.
> +                */
> +               if (err == SNP_GUEST_REQ_INVALID_LEN)
> +                       vcpu->arch.regs[VCPU_REGS_RBX] = data_npages;
> +
> +               /* pass the firmware error code */
> +               rc = err;
> +               goto cleanup;
> +       }
> +
> +       /* Copy the certificate blob in the guest memory */
> +       if (data_npages &&
> +           kvm_write_guest(kvm, data_gpa, sev->snp_certs_data, data_npages << PAGE_SHIFT))
> +               rc = SEV_RET_INVALID_ADDRESS;

Since at this point the PSP FW has correctly executed the command and
incremented the VMPCK sequence number I think we need another error
signal here since this will tell the guest the PSP had an error so it
will not know if the VMPCK sequence number should be incremented.

> +
> +cleanup:
> +       snp_cleanup_guest_buf(&req, &rc);
> +
> +unlock:
> +       mutex_unlock(&sev->guest_req_lock);
> +
> +e_fail:
> +       svm_set_ghcb_sw_exit_info_2(vcpu, rc);
> +}
> +
>  static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  {
>         struct vmcb_control_area *control = &svm->vmcb->control;
> @@ -3753,6 +3923,20 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>                 svm_set_ghcb_sw_exit_info_2(vcpu, rc);
>                 break;
>         }
> +       case SVM_VMGEXIT_GUEST_REQUEST: {
> +               snp_handle_guest_request(svm, control->exit_info_1, control->exit_info_2);
> +
> +               ret = 1;
> +               break;
> +       }
> +       case SVM_VMGEXIT_EXT_GUEST_REQUEST: {
> +               snp_handle_ext_guest_request(svm,
> +                                            control->exit_info_1,
> +                                            control->exit_info_2);
> +
> +               ret = 1;
> +               break;
> +       }
>         case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>                 vcpu_unimpl(vcpu,
>                             "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 3fd95193ed8d..3be24da1a743 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -98,6 +98,8 @@ struct kvm_sev_info {
>         u64 snp_init_flags;
>         void *snp_context;      /* SNP guest context page */
>         spinlock_t psc_lock;
> +       void *snp_certs_data;
> +       struct mutex guest_req_lock;
>  };
>
>  struct kvm_svm {
> --
> 2.25.1
>
