Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FAE56BDD8
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 18:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238497AbiGHP3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 11:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238327AbiGHP3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 11:29:06 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A8017A8B
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 08:29:04 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id bu42so17066842lfb.0
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 08:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EsqbPN5x+9PQgkB3EhpcwOrofU0GdaTgCdJPXG3XIDs=;
        b=Cjnkmx6zMzqZ3p3G/vWvCi7H5Ak27tLHkdjhmkw9kNmIAPJUo8Zng3TS5lXIfi6DBw
         X3tUPRJlg4MJWu+CehqG44HL/yX8UnZbaetVtGCue+/dkdQhexRD9soeCLZkESw3xgav
         PADev3iQqDx6T63UIbOBv+bZJGarOCx/gjp/mT5vs2iAEenyNWCIpiGzUNYHEMlGwPxW
         qZC7lCmjwJmRxifn9Rc6bcipQ7WFHZgUtl2Ho9HL5gHQrUb+LvEpMSwQ6e1O6/soqAhT
         LZRfSUQ7NKWdx7lQcXIdC9xYJnjTWcyo16zxdsDVt5YINNiZ4TeBSrYhfklXh5wMLdbo
         tZuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EsqbPN5x+9PQgkB3EhpcwOrofU0GdaTgCdJPXG3XIDs=;
        b=bZ7sLYW26Q1D2bx4ed6ovtsa9XvehBL9D1RnzGxgeyZO1Z+ke96EZtlChSxQ56Ygw6
         6lgzlifp5FjvigjgqiTnxbXsd4QAqcreOsY7ZZRD1wA89g4kk+NP1aWyT4Glp5b8bjXg
         qG+AbtLygWw93qXvgXbYDCTjxe8nJYWoNU0JO0/pCflagL7pV7/oCfwKGB/cyPcTrMeL
         oZ7DF2xWl7/W2oE+LknmIFRanuV0Q15+tYE6sozZN6mqIjoxCTMIxaFftAbNFPbvbC4e
         M3kUZk3FKyAe/tBIBm97WCJyk+9DmtbObwoL93ldAd4GxW2vnfIK6vciIeM1Nbq7JkuM
         7upw==
X-Gm-Message-State: AJIora+O6gwKYRfXETbvyPxOQDqvCxmecm6YkgviuPBt+6Q38ErMsB6O
        wtZadiBVt1oDmqPgaizEti05AJwiaExr0DaDod7xew==
X-Google-Smtp-Source: AGRyM1sV1zq1ZnN2yjXTPuiG/7Xv8X9xkix73ZrgQZOxRd61c9fzZcS0BmfVarULhrHnBVAu75EPaoUECCydheenFzI=
X-Received: by 2002:a05:6512:1112:b0:488:e0ac:fb41 with SMTP id
 l18-20020a056512111200b00488e0acfb41mr3001464lfg.456.1657294142373; Fri, 08
 Jul 2022 08:29:02 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <5d05799fc61994684aa2b2ddb8c5b326a3279e25.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6rGzSewSyO1uZehWUD2J6aLtRwP5N-uj-HPG73Pp0=Sjw@mail.gmail.com>
 <SN6PR12MB2767B9F438A0F6413780F73E8EB99@SN6PR12MB2767.namprd12.prod.outlook.com>
 <SN6PR12MB27675E821D5D1C423F2AF5768EBB9@SN6PR12MB2767.namprd12.prod.outlook.com>
In-Reply-To: <SN6PR12MB27675E821D5D1C423F2AF5768EBB9@SN6PR12MB2767.namprd12.prod.outlook.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 8 Jul 2022 09:28:50 -0600
Message-ID: <CAMkAt6riwJuL445USAAc-dLZ+vUsmtr+spAM=RQhJ07-K=nyMg@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 42/49] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
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
        "Roth, Michael" <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Wed, Jun 29, 2022 at 1:15 PM Kalra, Ashish <Ashish.Kalra@amd.com> wrote:
>
> [Public]
>
>
> >> +static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t
> >> +req_gpa, gpa_t resp_gpa) {
> >> +       struct sev_data_snp_guest_request req =3D {0};
> >> +       struct kvm_vcpu *vcpu =3D &svm->vcpu;
> >> +       struct kvm *kvm =3D vcpu->kvm;
> >> +       unsigned long data_npages;
> >> +       struct kvm_sev_info *sev;
> >> +       unsigned long rc, err;
> >> +       u64 data_gpa;
> >> +
> >> +       if (!sev_snp_guest(vcpu->kvm)) {
> >> +               rc =3D SEV_RET_INVALID_GUEST;
> >> +               goto e_fail;
> >> +       }
> >> +
> >> +       sev =3D &to_kvm_svm(kvm)->sev_info;
> >> +
> >> +       data_gpa =3D vcpu->arch.regs[VCPU_REGS_RAX];
> >> +       data_npages =3D vcpu->arch.regs[VCPU_REGS_RBX];
> >> +
> >> +       if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
> >> +               rc =3D SEV_RET_INVALID_ADDRESS;
> >> +               goto e_fail;
> >> +       }
> >> +
> >> +       /* Verify that requested blob will fit in certificate buffer *=
/
> >> +       if ((data_npages << PAGE_SHIFT) > SEV_FW_BLOB_MAX_SIZE) {
> >> +               rc =3D SEV_RET_INVALID_PARAM;
> >> +               goto e_fail;
> >> +       }
> >> +
> >> +       mutex_lock(&sev->guest_req_lock);
> >> +
> >> +       rc =3D snp_setup_guest_buf(svm, &req, req_gpa, resp_gpa);
> >> +       if (rc)
> >> +               goto unlock;
> >> +
> >> +       rc =3D snp_guest_ext_guest_request(&req, (unsigned long)sev->s=
np_certs_data,
> >> +                                        &data_npages, &err);
> >> +       if (rc) {
> >> +               /*
> >> +                * If buffer length is small then return the expected
> >> +                * length in rbx.
> >> +                */
> >> +               if (err =3D=3D SNP_GUEST_REQ_INVALID_LEN)
> >> +                       vcpu->arch.regs[VCPU_REGS_RBX] =3D data_npages=
;
> >> +
> >> +               /* pass the firmware error code */
> >> +               rc =3D err;
> >> +               goto cleanup;
> >> +       }
> >> +
> >> +       /* Copy the certificate blob in the guest memory */
> >> +       if (data_npages &&
> >> +           kvm_write_guest(kvm, data_gpa, sev->snp_certs_data, data_n=
pages << PAGE_SHIFT))
> >> +               rc =3D SEV_RET_INVALID_ADDRESS;
>
> >>Since at this point the PSP FW has correctly executed the command and i=
ncremented the VMPCK sequence number I think we need another error signal h=
ere since this will tell the guest the PSP had an error so it will not know=
 if the VMPCK sequence >number should be incremented.
>
> >Similarly as above, as this is an error path, so what's the guarantee th=
at the next guest message request will succeed completely,  isn=E2=80=99t i=
t better to let the
> >FW reject any subsequent guest messages once it has detected that the se=
quence numbers are out of sync ?
>
> Alternately, we probably can return SEV_RET_INVALID_PAGE_STATE/SEV_RET_IN=
VALID_PAGE_OWNER here, but that still does not indicate to the guest
> that the FW has successfully executed the command and the error occurred =
during cleanup/result phase and it needs to increment the VMPCK sequence nu=
mber. There is nothing as such defined in SNP FW API specs to indicate such=
 kind of failures to guest. As I mentioned earlier, this is probably indica=
tive of
> a bigger system failure and it is better to let the FW reject subsequent =
guest messages/requests once it has detected that the sequence numbers are =
out of sync.

Hmm I think the guest must be careful here because the guest could not
trust the hypervisor here to be truthful about the sequence numbers
incrementing. That's unfortunate since this means if these operations
do fail with a well behaved hypervisor the guest cannot use that VMPCK
again. But there is no harm in the guest re-issuing the
SNP_GUEST_REQUEST (or extended version) with the exact same request
just in at a different address. The GHCB spec actually calls this out
" It is recommended that the hypervisor validate the guest physical
address of the response page before invoking the SNP_GUEST_REQUEST API
so that the sequence numbers do not get out of sync for the guest,
possibly resulting in all successive requests failing".

Currently SVM_VMGEXIT_GUEST_REQUEST and SVM_VMGEXIT_EXT_GUEST_REQUEST
have different hypervisor -> guest usage for SW_EXITINFO2. I think
they both should be defined as what SVM_VMGEXIT_EXT_GUEST_REQUEST is
now: the high 32bits are the hypervisor error code, the low 32bits are
the FW error code. This would allow for both NAEs to have some signal
to the guest say SEV_RET_INVALID_REQ_ADDRESS. The hypervisor can use
this error code when doing the validation on the request and response
regions, if some is wrong with them the guest can retry with the exact
same request (so no IV reuse) in a corrected region.

But another reason I think SVM_VMGEXIT_GUEST_REQUEST SW_EXITINFO2
hypervisor->guest state should include this change is because in this
patch we are currently overloading the lower 32bits with hypervisor
error codes. In snp_handle_guest_request() if sev_snp_guest(),
snp_setup_guest_buf(), or snp_cleanup_guest_buf() fails we use the low
32bits of SW_EXITINFO2 to return hypervisor errors to the guest.

>
> Thanks,
> Ashish
