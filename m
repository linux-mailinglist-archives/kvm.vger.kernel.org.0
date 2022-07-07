Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A6F56AC7A
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 22:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236261AbiGGUHR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 16:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbiGGUHP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 16:07:15 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651855C9FD
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 13:07:13 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id bf9so9739776lfb.13
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 13:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QKhIcn0No1S7A61+zmGLwK91+iFzUTtNVPgIThcxj6s=;
        b=gVC3x4vRSwq9+jTYJ4uo46yrPyBoDX3w1bx40R6Hq+qmp0LoElZElkFm2Hh0l+vxXC
         nl9oOppNyrXY9npgFovnSDGCRT+bSUhslsEq8L4AZqAA1jcipcKhZ7anh/DFsf1fEysw
         yA0IdQLnyj0S0Pgeh67cQ7U+/axRBD/NtYoevdUq4dibCqJY68Dc9jlP26545M4i5/U4
         Ef24qa57ODqV0zgYuzDbrH8vNumdkYJwcA7qYMfh+3KjREN38xz8SU6ImdPRQUW5InGw
         X9cu4YLgWbUU140YdmZwa15DMNtZxfCsLvvLo2QT6i+m5C+wfWxcAH1UAzgZsXuGp5zl
         Licg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QKhIcn0No1S7A61+zmGLwK91+iFzUTtNVPgIThcxj6s=;
        b=KZ5cDMExMEpxlBklSLncs7O2YxM1h80f17q+LOb0pAbNsv6k8bgPK513BDqq5ujpMx
         gF4Yu2tbYaL6LqDG/cJTnH8erfqyK5p40q495rOnw9qmNztmP/MOxhp1dGijyyAwQ31V
         Q2HLEN0pj+TDb+HoxpI0WCwGok/Vl4raNvhqS/iejcrpTSrgfgTuLxMaovPb7A9GfWVa
         JZ/OFMrGpRY3Sc8gGZ3LgYju3W8El/4oTHKW06VUCCkZJbf+x/H/SoJvvj9YguhGKohF
         Lap7KThSlks1dIsh2N8zYIrUpG1vLBbIec63dSjdCKbeLIVFODI/ZiD1923qbnX8+v02
         KWSQ==
X-Gm-Message-State: AJIora/LyVmq3L8Upv3pP9u4Bv7mwpy54SwvNZy6wDBxU3+BCqBpJa48
        gMvwaUXKS9ssuA7BcRe5Btk7jhbDO8tZnAzC1pNKsQ==
X-Google-Smtp-Source: AGRyM1ukmtVWv+UDsK4ocu2WtNQ0skzcglLvz74pG51Y9fsQEHQ2iNFArCm/PlRMEJjkm+H4jn63SwqGqxQ9ctyw6Jk=
X-Received: by 2002:a05:6512:6d3:b0:489:37a0:ac40 with SMTP id
 u19-20020a05651206d300b0048937a0ac40mr1624560lff.79.1657224431418; Thu, 07
 Jul 2022 13:07:11 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <7845d453af6344d0b156493eb4555399aad78615.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6oGzqoMxN5ws9QZ9P1q5Rah92bb4V2KSYBgi0guMGUKAQ@mail.gmail.com> <SN6PR12MB2767CC5405E25A083E76CFFB8EB49@SN6PR12MB2767.namprd12.prod.outlook.com>
In-Reply-To: <SN6PR12MB2767CC5405E25A083E76CFFB8EB49@SN6PR12MB2767.namprd12.prod.outlook.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 7 Jul 2022 14:06:59 -0600
Message-ID: <CAMkAt6pdoMY1yV+kcUzOftD2WKS8sQy-R2b=Aty8wS-gGp-21Q@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 35/49] KVM: SVM: Remove the long-lived GHCB host map
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

On Fri, Jun 24, 2022 at 2:14 PM Kalra, Ashish <Ashish.Kalra@amd.com> wrote:
>
> [AMD Official Use Only - General]
>
> Hello Peter,
>
> >> From: Brijesh Singh <brijesh.singh@amd.com>
> >>
> >> On VMGEXIT, sev_handle_vmgexit() creates a host mapping for the GHCB
> >> GPA, and unmaps it just before VM-entry. This long-lived GHCB map is
> >> used by the VMGEXIT handler through accessors such as ghcb_{set_get}_x=
xx().
> >>
> >> A long-lived GHCB map can cause issue when SEV-SNP is enabled. When
> >> SEV-SNP is enabled the mapped GPA needs to be protected against a page
> >> state change.
> >>
> >> To eliminate the long-lived GHCB mapping, update the GHCB sync
> >> operations to explicitly map the GHCB before access and unmap it after
> >> access is complete. This requires that the setting of the GHCBs
> >> sw_exit_info_{1,2} fields be done during sev_es_sync_to_ghcb(), so
> >> create two new fields in the vcpu_svm struct to hold these values when
> >> required to be set outside of the GHCB mapping.
> >>
> >> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> >> ---
> >>  arch/x86/kvm/svm/sev.c | 131
> >> ++++++++++++++++++++++++++---------------
> >>  arch/x86/kvm/svm/svm.c |  12 ++--
> >>  arch/x86/kvm/svm/svm.h |  24 +++++++-
> >>  3 files changed, 111 insertions(+), 56 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c index
> >> 01ea257e17d6..c70f3f7e06a8 100644
> >> --- a/arch/x86/kvm/svm/sev.c
> >> +++ b/arch/x86/kvm/svm/sev.c
> >> @@ -2823,15 +2823,40 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
> >>         kvfree(svm->sev_es.ghcb_sa);
> >> }
> >>
> >> +static inline int svm_map_ghcb(struct vcpu_svm *svm, struct
> >> +kvm_host_map *map) {
> >> +       struct vmcb_control_area *control =3D &svm->vmcb->control;
> >> +       u64 gfn =3D gpa_to_gfn(control->ghcb_gpa);
> >> +
> >> +       if (kvm_vcpu_map(&svm->vcpu, gfn, map)) {
> >> +               /* Unable to map GHCB from guest */
> >> +               pr_err("error mapping GHCB GFN [%#llx] from guest\n", =
gfn);
> >> +               return -EFAULT;
> >> +       }
> >> +
> >> +       return 0;
> >> +}
>
> >There is a perf cost to this suggestion but it might make accessing the =
GHCB safer for KVM. Have you thought about just using
> >kvm_read_guest() or copy_from_user() to fully copy out the GCHB into a K=
VM owned buffer, then copying it back before the VMRUN. That way the KVM do=
esn't need to guard against page_state_changes on the GHCBs, that could be =
a perf ?>improvement in a follow up.
>
> Along with the performance costs you mentioned, the main concern here wil=
l be the GHCB write-back path (copying it back) before VMRUN: this will aga=
in hit the issue we have currently with
> kvm_write_guest() / copy_to_user(), when we use it to sync the scratch bu=
ffer back to GHCB. This can fail if guest RAM is mapped using huge-page(s) =
and RMP is 4K. Please refer to the patch/fix
> mentioned below, kvm_write_guest() potentially can fail before VMRUN in c=
ase of SNP :
>
> commit 94ed878c2669532ebae8eb9b4503f19aa33cd7aa
> Author: Ashish Kalra <ashish.kalra@amd.com>
> Date:   Mon Jun 6 22:28:01 2022 +0000
>
>     KVM: SVM: Sync the GHCB scratch buffer using already mapped ghcb
>
>     Using kvm_write_guest() to sync the GHCB scratch buffer can fail
>     due to host mapping being 2M, but RMP being 4K. The page fault handli=
ng
>     in do_user_addr_fault() fails to split the 2M page to handle RMP faul=
t due
>     to it being called here in a non-preemptible context. Instead use
>     the already kernel mapped ghcb to sync the scratch buffer when the
>     scratch buffer is contained within the GHCB.

Ah I didn't see that issue thanks for the pointer.

The patch description says "When SEV-SNP is enabled the mapped GPA
needs to be protected against a page state change." since if the guest
were to convert the GHCB page to private when the host is using the
GHCB the host could get an RMP violation right? That RMP violation
would cause the host to crash unless we use some copy_to_user() type
protections. I don't see anything mechanism for this patch to add the
page state change protection discussed. Can't another vCPU still
convert the GHCB to private?

I was wrong about the importance of this though seanjc@ walked me
through how UPM will solve this issue so no worries about this until
the series is rebased on to UPM.

>
> Thanks,
> Ashish
>
> >Since we cannot unmap GHCBs I don't think UPM will help here so we proba=
bly want to make these patches safe against malicious guests making GHCBs p=
rivate. But maybe UPM does help?
