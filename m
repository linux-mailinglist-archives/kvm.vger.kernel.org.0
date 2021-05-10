Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADFB379743
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 20:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhEJS6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 14:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbhEJS6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 14:58:47 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB4CC06175F
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 11:57:41 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id x2so24912231lff.10
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 11:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rHjqwVQjzMEV5GK54WowYNEUzQ+k4CK9chJTV5Okn7c=;
        b=QMjJbO1L2Cxu9EqcoA2Dh2LjzMSrVFxlZPKXiltJd/6sQmrMeQxmH95UG0NicAqPUj
         WNZPpwMln6fAm4nod1Kpt1aNKY1MaRsPbYZoWlDMc9bQZsgZ7sJQh2ap2gK+rrTHhq3M
         rXmH3pAazUZliBie1fO20stm2CEZvezyK7PRArTr6i0RZFqSBe7z1CKS1zvYK1Rwqlsi
         jMbodNLYT7iIEDAxxKpv1Kut+KZtAe/W5wCfazhEJqRD15FENd3QWbMh8iwrNdcW94F5
         qMz3DlZ5VbtODD74KEe0KpnwbXRKnPiM94zZ29/OIZjvuzA6ftBfv/rbBMVz2Btxvpqp
         5iTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rHjqwVQjzMEV5GK54WowYNEUzQ+k4CK9chJTV5Okn7c=;
        b=XpVn4lF6K8oBXEYTOK8A56rD70CpROJBttwI3BgYo4y7q+8u+rsq9c2GqWjXkr3ufj
         21f6wEtmwoeU9qFoy3oUiDn+ac28KmLCP8aYW7X9wt6SaQutzRIlvqfRDztAkeN4gVKi
         o05zuqlh+ft58pMjfX1ZMOQYX5kT9wT0Y8MXayUvCzX3IwPpmVT96dvYeHFTcms3rDSw
         zhCqQrAtTP9Xd9YbkP9Btfn5vLYclSnpy8iB9UynpPUUWKsKensNlfeyvJvoOJpNCbh8
         4R9LKxEsbnYUmUBeTi1nyuSfIKCrWsKqliO2OXASKysAr084aJeIAL2rnSU64L131Opq
         rRRg==
X-Gm-Message-State: AOAM531dvk9NrVUd0o8ol5e7PuIXg+ikIdckFm+4XnmyJ4yoBfIM/erz
        xq/Rcp2Reqd8KgTwDi3shl+fpkz4uqj0Gbq207wDw6Ir/MVtX5aD
X-Google-Smtp-Source: ABdhPJyUTojXkR3OkkvxmoH6PFq+uUMBCtGrr8/i1SBWhTm9x+5pM4LoolwpcagABSdUASsTaqvLwYA+WiLFk52KFmI=
X-Received: by 2002:ac2:532d:: with SMTP id f13mr17394936lfh.81.1620673059631;
 Mon, 10 May 2021 11:57:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210430123822.13825-1-brijesh.singh@amd.com> <20210430123822.13825-37-brijesh.singh@amd.com>
In-Reply-To: <20210430123822.13825-37-brijesh.singh@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 10 May 2021 12:57:27 -0600
Message-ID: <CAMkAt6ottZkx02-ykazkG-5Tu5URv-xwOjWOZ=XMAXv98_HOYA@mail.gmail.com>
Subject: Re: [PATCH Part2 RFC v2 36/37] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        kvm list <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, jroedel@suse.de,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>, peterz@infradead.org,
        "H. Peter Anvin" <hpa@zytor.com>, tony.luck@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>
> +static void snp_handle_guest_request(struct vcpu_svm *svm, struct ghcb *ghcb,
> +                                   gpa_t req_gpa, gpa_t resp_gpa)
> +{
> +       struct sev_data_snp_guest_request data = {};
> +       struct kvm_vcpu *vcpu = &svm->vcpu;
> +       struct kvm *kvm = vcpu->kvm;
> +       kvm_pfn_t req_pfn, resp_pfn;
> +       struct kvm_sev_info *sev;
> +       int rc, err = 0;
> +
> +       if (!sev_snp_guest(vcpu->kvm)) {
> +               rc = -ENODEV;
> +               goto e_fail;
> +       }
> +
> +       sev = &to_kvm_svm(kvm)->sev_info;
> +
> +       if (!__ratelimit(&sev->snp_guest_msg_rs)) {
> +               pr_info_ratelimited("svm: too many guest message requests\n");
> +               rc = -EAGAIN;
> +               goto e_fail;
> +       }
> +
> +       if (!IS_ALIGNED(req_gpa, PAGE_SIZE) || !IS_ALIGNED(resp_gpa, PAGE_SIZE)) {
> +               pr_err("svm: guest request (%#llx) or response (%#llx) is not page aligned\n",
> +                       req_gpa, resp_gpa);
> +               goto e_term;
> +       }
> +
> +       req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
> +       if (is_error_noslot_pfn(req_pfn)) {
> +               pr_err("svm: guest request invalid gpa=%#llx\n", req_gpa);
> +               goto e_term;
> +       }
> +
> +       resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
> +       if (is_error_noslot_pfn(resp_pfn)) {
> +               pr_err("svm: guest response invalid gpa=%#llx\n", resp_gpa);
> +               goto e_term;
> +       }
> +
> +       data.gctx_paddr = __psp_pa(sev->snp_context);
> +       data.req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
> +       data.res_paddr = __psp_pa(sev->snp_resp_page);
> +
> +       mutex_lock(&kvm->lock);
> +
> +       rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &err);
> +       if (rc) {
> +               mutex_unlock(&kvm->lock);
> +
> +               /* If we have a firmware error code then use it. */
> +               if (err)
> +                       rc = err;
> +
> +               goto e_fail;
> +       }
> +
> +       /* Copy the response after the firmware returns success. */
> +       rc = kvm_write_guest(kvm, resp_gpa, sev->snp_resp_page, PAGE_SIZE);
> +
> +       mutex_unlock(&kvm->lock);
> +
> +e_fail:
> +       ghcb_set_sw_exit_info_2(ghcb, rc);
> +       return;
> +
> +e_term:
> +       ghcb_set_sw_exit_info_1(ghcb, 1);
> +       ghcb_set_sw_exit_info_2(ghcb,
> +                               X86_TRAP_GP |
> +                               SVM_EVTINJ_TYPE_EXEPT |
> +                               SVM_EVTINJ_VALID);
> +}

I am probably missing something in the spec but I don't see any
references to #GP in the '4.1.7 SNP Guest Request' section. Why is
this different from e_fail?
