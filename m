Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7CC5BD6BB
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 00:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiISWDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 18:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiISWDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 18:03:02 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612694B0F8
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 15:03:01 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id g8so788482iob.0
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 15:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Ph6MNOnGKLISbGCGLjM6coGHkzrba1s1LnEs9FR4sTM=;
        b=VU+BHb8cdS/Oa5JCSIUk+cXt21pVVXxcuXbg4Oet5MqxrY6yxDbfiqTPEx84/lbOj2
         kJsyplHAsJmY60goMoUelqDKKpvW1eYrVaU2OgDhhDNeBqN22dSIaVdLng883i4zWf4h
         Gkld3gnvhbMhI1euLW8xw8xeU2zxN4G7HZab1Oj63H50nH8x+2uiqJTkQRZHQs0vH9JS
         9Lqqi8b40cZDeV2EmscIqj/kUi1dzOkGriuMdGLWKZuGrYQTBdBfcQ511vceGfx3RDPX
         zAvh6W1gwAO80jRbnp3JmP5zEoAkIKdNHwFiL+17rzYZ/lzs5lxY5aMCug385OmLvmhB
         Hyrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Ph6MNOnGKLISbGCGLjM6coGHkzrba1s1LnEs9FR4sTM=;
        b=SpPh5zMpJNSERtwf6vG1r5OAVv8MPAmCERRKwi+5i/5x1uEsrRQZj5ziOYvH8TwL5W
         IFg7qSh2RSmpA9Q8qMSrlmtzlUyPSRaUxnqxLx+5Si6vdfPGet6rTrglCVkZ8d/5V/X0
         z6u/5a+0wbMC3E75Q6YMtBgSWPzwUA+oQR4OVTHMYbZqxQrmIHCeK7dOpsWd6q/CixIt
         un4V4AkBRd8x2RjxXzl8hPImJ1flBCO+NPWtvVKmAUihkxpdCZC0HA1G/8M15V8nqVx+
         IH6Gp9ApFy4HJeN3oZljtJJPEx6ktMHstLUgfX8S1n91AtxQuTIjWTL30zBZQ/Lp2IqF
         kkOQ==
X-Gm-Message-State: ACrzQf1zKi7Skf3NnQ0OHQhj7IdhuIhza72uyNhQ+ps+XQjy/GhOxV2X
        GoZo9edvz9IaJqva1gv+h/m25uQ5CffNjplBnfORKg==
X-Google-Smtp-Source: AA6agR4HFz/DHLHwEcywS9WcQoZJwSA4uYS/q3Lf9C4Waz2sWYn/W6hslEF14NZfkmOWQMdR14fFgB5sSwbMtr4E9cA=
X-Received: by 2002:a05:6638:40a3:b0:35a:3f2d:a21c with SMTP id
 m35-20020a05663840a300b0035a3f2da21cmr9196001jam.221.1663624980515; Mon, 19
 Sep 2022 15:03:00 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <78e30b5a25c926fcfdcaafea3d484f1bb25f20b9.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6rrGJ5DYTAJKFUTagN9i_opS8u5HPw5c_8NoyEjK7rYzA@mail.gmail.com>
 <CABpDEum157s5+yQvikjwQRaOcxau27NkMzX9eCs9=HFOW5FYnA@mail.gmail.com> <0716365f-3572-638b-e841-fcce7d30571a@amd.com>
In-Reply-To: <0716365f-3572-638b-e841-fcce7d30571a@amd.com>
From:   Alper Gun <alpergun@google.com>
Date:   Mon, 19 Sep 2022 15:02:49 -0700
Message-ID: <CABpDEu=quPsv6cXfbvpsGS2N+5Pcw7inCfmv=sx3-VaK0UE76g@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 37/49] KVM: SVM: Add support to handle MSR based
 Page State Change VMGEXIT
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Peter Gonda <pgonda@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
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
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, jarkko@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_FILL_THIS_FORM_SHORT,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 19, 2022 at 2:38 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 9/19/22 12:53, Alper Gun wrote:
> > On Fri, Aug 19, 2022 at 9:54 AM Peter Gonda <pgonda@google.com> wrote:
> >>
> >>> +
> >>> +static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op, gpa_t gpa,
> >>> +                                         int level)
> >>> +{
> >>> +       struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
> >>> +       struct kvm *kvm = vcpu->kvm;
> >>> +       int rc, npt_level;
> >>> +       kvm_pfn_t pfn;
> >>> +       gpa_t gpa_end;
> >>> +
> >>> +       gpa_end = gpa + page_level_size(level);
> >>> +
> >>> +       while (gpa < gpa_end) {
> >>> +               /*
> >>> +                * If the gpa is not present in the NPT then build the NPT.
> >>> +                */
> >>> +               rc = snp_check_and_build_npt(vcpu, gpa, level);
> >>> +               if (rc)
> >>> +                       return -EINVAL;
> >>> +
> >>> +               if (op == SNP_PAGE_STATE_PRIVATE) {
> >>> +                       hva_t hva;
> >>> +
> >>> +                       if (snp_gpa_to_hva(kvm, gpa, &hva))
> >>> +                               return -EINVAL;
> >>> +
> >>> +                       /*
> >>> +                        * Verify that the hva range is registered. This enforcement is
> >>> +                        * required to avoid the cases where a page is marked private
> >>> +                        * in the RMP table but never gets cleanup during the VM
> >>> +                        * termination path.
> >>> +                        */
> >>> +                       mutex_lock(&kvm->lock);
> >>> +                       rc = is_hva_registered(kvm, hva, page_level_size(level));
> >>> +                       mutex_unlock(&kvm->lock);
> >>> +                       if (!rc)
> >>> +                               return -EINVAL;
> >>> +
> >>> +                       /*
> >>> +                        * Mark the userspace range unmerable before adding the pages
> >>> +                        * in the RMP table.
> >>> +                        */
> >>> +                       mmap_write_lock(kvm->mm);
> >>> +                       rc = snp_mark_unmergable(kvm, hva, page_level_size(level));
> >>> +                       mmap_write_unlock(kvm->mm);
> >>> +                       if (rc)
> >>> +                               return -EINVAL;
> >>> +               }
> >>> +
> >>> +               write_lock(&kvm->mmu_lock);
> >>> +
> >>> +               rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level);
> >>> +               if (!rc) {
> >>> +                       /*
> >>> +                        * This may happen if another vCPU unmapped the page
> >>> +                        * before we acquire the lock. Retry the PSC.
> >>> +                        */
> >>> +                       write_unlock(&kvm->mmu_lock);
> >>> +                       return 0;
> >>> +               }
> >>
> >> I think we want to return -EAGAIN or similar if we want the caller to
> >> retry, right? I think returning 0 here hides the error.
> >>
> >
> > The problem here is that the caller(linux guest kernel) doesn't retry
> > if PSC fails. The current implementation in the guest kernel is that
> > if a page state change request fails, it terminates the VM with
> > GHCB_TERM_PSC reason.
> > Returning 0 here is not a good option because it will fail the PSC
> > silently and will probably cause a nested RMP fault later. Returning
>
> Returning 0 here is ok because the PSC current index into the PSC
> structure will not be updated and the guest will then retry (see the loop
> in vmgexit_psc() in arch/x86/kernel/sev.c).
>
> Thanks,
> Tom

But the host code updates the index. It doesn't leave the loop because
rc is 0. The guest will think that it is successful.
rc = __snp_handle_page_state_change(vcpu, op, gpa, level);
if (rc)
goto out;

Also the page state change request with MSR is not retried. It
terminates the VM if the MSR request fails.

>
> > an error also terminates the guest immediately with current guest
> > implementation. I think the best approach here is adding a retry logic
> > to this function. Retrying without returning an error should help it
> > work because snp_check_and_build_npt will be called again and in the
> > second attempt this should work.
> >
> >>> +
> >>> +               /*
> >>> +                * Adjust the level so that we don't go higher than the backing
> >>> +                * page level.
> >>> +                */
> >>> +               level = min_t(size_t, level, npt_level);
> >>> +
> >>> +               trace_kvm_snp_psc(vcpu->vcpu_id, pfn, gpa, op, level);
> >>> +
> >>> +               switch (op) {
> >>> +               case SNP_PAGE_STATE_SHARED:
> >>> +                       rc = snp_make_page_shared(kvm, gpa, pfn, level);
> >>> +                       break;
> >>> +               case SNP_PAGE_STATE_PRIVATE:
> >>> +                       rc = rmp_make_private(pfn, gpa, level, sev->asid, false);
> >>> +                       break;
> >>> +               default:
> >>> +                       rc = -EINVAL;
> >>> +                       break;
> >>> +               }
> >>> +
> >>> +               write_unlock(&kvm->mmu_lock);
> >>> +
> >>> +               if (rc) {
> >>> +                       pr_err_ratelimited("Error op %d gpa %llx pfn %llx level %d rc %d\n",
> >>> +                                          op, gpa, pfn, level, rc);
> >>> +                       return rc;
> >>> +               }
> >>> +
> >>> +               gpa = gpa + page_level_size(level);
> >>> +       }
> >>> +
> >>> +       return 0;
> >>> +}
> >>> +
