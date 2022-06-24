Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC89559D0F
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 17:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbiFXPMk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 11:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbiFXPMg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 11:12:36 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8467E4D9D1
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 08:12:33 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id x3so5039418lfd.2
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 08:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x8Jy0OJ39PBOXthgIfAdqP1jgQfbb438h2GvJW/Mdq0=;
        b=mVTuWLuN8XZpFMJ+S+7U0qjJl+qK5dJblLURULdgRe/zT3wWoBwZfRqWcI9kIGhQix
         nJ0AlpkWAXgQzKGyiv+kR+rVuzVz+DEiOKI+39aGe1PTUDQ8PQmnF7lzUOTyeVqe+jYj
         /sPnpedyt4AqMb/Oe/lOmeQR9MXlebXyA5UNaCTZQAkhpYwhIjp+b0opRH/UNwzNPtdQ
         Kk22/0JzzDkTIXbMGifjZwkz6D6F0dqP5YXT6OK/4HiWJaQ2EEPlJAoKT7iFqZHu+CO3
         yCdSI3Vrj02rJYLXVd24AKX1AmjoKBptyIgnOqn/2cJdm0bxgeklwSTdhUM5wS9vLoIB
         buLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x8Jy0OJ39PBOXthgIfAdqP1jgQfbb438h2GvJW/Mdq0=;
        b=oylrBsf5rPgdAaQYUGb6MWxMdDR9iPoDv00dSL7X8ErR00IlrBEnbWBS5vBtylBzoe
         6+BZclQn8Z5P6qZUyk9WvndD/XnQGCAw2M0crOT8bwVpfCldYKgDL0pR2WqYCbFRMZCh
         Zadba4HkuJ6s5SEHzqOQb1ueKp/ohbAWije4sjWOjjBZklCCenHslMEjMW17woBpgPpf
         FrETM4y11GdrJSL4I/HG4wrai25WR04Ak0IUfntiLK8qLeaZyFskBZf+qw1HmH4PQ3uZ
         upT4SHG9inhXthFX5oLDLomiadUKfs5t2CCj0numIMNsWZBEQlonA8ejdFLQGjl2L6jA
         Nhpg==
X-Gm-Message-State: AJIora/P4roV0DCH/IUEtrVyPlSq7N3OBHe6w4wk69wQTxxz9m8ho5WZ
        yIS8Wp2NdaEwFQq7mQTvWvv8Rn/ti/n3BcOrh0WTYA==
X-Google-Smtp-Source: AGRyM1ux6fJI1UqfhbKtYI3380oq0Yc9WPcnS1B8UQFcR4k15s9NIrtzUEPIL6muaukL0Y7LrG0POm9dBMYr5wpMzHA=
X-Received: by 2002:a05:6512:401a:b0:47f:6ea5:dace with SMTP id
 br26-20020a056512401a00b0047f6ea5dacemr9014219lfb.402.1656083551555; Fri, 24
 Jun 2022 08:12:31 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <7845d453af6344d0b156493eb4555399aad78615.1655761627.git.ashish.kalra@amd.com>
In-Reply-To: <7845d453af6344d0b156493eb4555399aad78615.1655761627.git.ashish.kalra@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 24 Jun 2022 09:12:20 -0600
Message-ID: <CAMkAt6oGzqoMxN5ws9QZ9P1q5Rah92bb4V2KSYBgi0guMGUKAQ@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 35/49] KVM: SVM: Remove the long-lived GHCB host map
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

On Mon, Jun 20, 2022 at 5:11 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> On VMGEXIT, sev_handle_vmgexit() creates a host mapping for the GHCB GPA,
> and unmaps it just before VM-entry. This long-lived GHCB map is used by
> the VMGEXIT handler through accessors such as ghcb_{set_get}_xxx().
>
> A long-lived GHCB map can cause issue when SEV-SNP is enabled. When
> SEV-SNP is enabled the mapped GPA needs to be protected against a page
> state change.
>
> To eliminate the long-lived GHCB mapping, update the GHCB sync operations
> to explicitly map the GHCB before access and unmap it after access is
> complete. This requires that the setting of the GHCBs sw_exit_info_{1,2}
> fields be done during sev_es_sync_to_ghcb(), so create two new fields in
> the vcpu_svm struct to hold these values when required to be set outside
> of the GHCB mapping.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 131 ++++++++++++++++++++++++++---------------
>  arch/x86/kvm/svm/svm.c |  12 ++--
>  arch/x86/kvm/svm/svm.h |  24 +++++++-
>  3 files changed, 111 insertions(+), 56 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 01ea257e17d6..c70f3f7e06a8 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2823,15 +2823,40 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
>         kvfree(svm->sev_es.ghcb_sa);
>  }
>
> +static inline int svm_map_ghcb(struct vcpu_svm *svm, struct kvm_host_map *map)
> +{
> +       struct vmcb_control_area *control = &svm->vmcb->control;
> +       u64 gfn = gpa_to_gfn(control->ghcb_gpa);
> +
> +       if (kvm_vcpu_map(&svm->vcpu, gfn, map)) {
> +               /* Unable to map GHCB from guest */
> +               pr_err("error mapping GHCB GFN [%#llx] from guest\n", gfn);
> +               return -EFAULT;
> +       }
> +
> +       return 0;
> +}

There is a perf cost to this suggestion but it might make accessing
the GHCB safer for KVM. Have you thought about just using
kvm_read_guest() or copy_from_user() to fully copy out the GCHB into a
KVM owned buffer, then copying it back before the VMRUN. That way the
KVM doesn't need to guard against page_state_changes on the GHCBs,
that could be a perf improvement in a follow up.

Since we cannot unmap GHCBs I don't think UPM will help here so we
probably want to make these patches safe against malicious guests
making GHCBs private. But maybe UPM does help?
