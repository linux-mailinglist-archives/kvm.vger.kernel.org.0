Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E5454B4DE
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 17:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343685AbiFNPhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 11:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236865AbiFNPhy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 11:37:54 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B98B2E9F3
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 08:37:53 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id g2so10191587ljk.5
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 08:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fn8gtxL6sSNRSsiDRRI9nlOANxjqFwtwIBrOJj9PDX4=;
        b=LT/lyo0Gkm8vUesqRnJoPnu//GtJ2a4J7xk0YQo1fVzKIPstZDTs4ocVHUhOQzAzDf
         1mhknKFZFcyuP+FcITbRZ9C3Zb5IygQ+dSD/d5sDSo5jPxZ3Xod61S+96JIZEmvp/ioU
         ZLBYWsR7cCtO3xXbwzi+P+VOMS8qTkNT6dLd5qwOG4wKAOBEMDsF5IyyBzSoJSpbj7Ps
         0sLvaRhd6KXmBxBx5Mnte8TQS/1qrwy08MCnMdz9Rwv7O5iKxxqDYqsRoQXOdKe/qqv/
         D1JOHgxvD7xtNV5gXfizVs33keuKhzIJmtdRXlLVfle9UauwzrlzB+MCJvLuXXUxDdkT
         328Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fn8gtxL6sSNRSsiDRRI9nlOANxjqFwtwIBrOJj9PDX4=;
        b=tTHM0a+kIGdtd0B93oD7EY9Qx9gFzFZ+f04xNqZTBdAMDrl3s6nuolgoWQmDaefSa6
         KcUMUzFz3TubAkBNy5x0/9w4qmULZI5Un6qJKX918OQ6+SfH5nk5tlnuimuwleOQ2awE
         GahA0e/xVQWH8hDey6+gEq8pZnHOV6IGgqoEsaOtyOqVsAQ5tT9Y6AUebjisgqbG0TX6
         tLCFtg8ZGnUMcJfyE8sRnujbwCrw4Jz8CKOsl6puPj4tiw2Hq8nXmOdioz9RWfCk/E3o
         S8NSdSk4r+E2hXtOPASSNA3i8asNvvP1WWcJpbvUoAn13KziIhFm22HZEB0fs+rKpxHP
         I8kg==
X-Gm-Message-State: AJIora8V2yDW6T2JZZzR5LPlf6qGWiYB/sA7W7T8MpEk9tiz7e98zMKL
        aSj4/WBtqtZQtdreoeMwII56NlAGPNG6CQrEDJh4zA==
X-Google-Smtp-Source: AGRyM1tVivOgpTFI/b0e/Dm7QRVBpJJPup//gAccjasK6nMQcbpqWB6Xf55xhXL4gRzWthbIWts51F5C1RaIfIMXqkE=
X-Received: by 2002:a2e:547:0:b0:255:703a:d9ae with SMTP id
 68-20020a2e0547000000b00255703ad9aemr2756675ljf.282.1655221071098; Tue, 14
 Jun 2022 08:37:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <20210820155918.7518-24-brijesh.singh@amd.com>
 <CABpDEukdrEbXjOF_QuZqUMQndYx=zVM4s2o-oN_wb2L_HCrONg@mail.gmail.com>
 <1cadca0d-c3dc-68ed-075f-f88ccb0ccc0a@amd.com> <CABpDEun0rjrNVCGZDXd8SO3tfZi-2ku3mit2XMGLwCsijbF9tg@mail.gmail.com>
 <ee1a829f-9a89-e447-d182-877d4033c96a@amd.com>
In-Reply-To: <ee1a829f-9a89-e447-d182-877d4033c96a@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 14 Jun 2022 09:37:39 -0600
Message-ID: <CAMkAt6q3otA3n-daFfEBP7kzD+ucMQjP=3bX1PkuAUFrH9epUQ@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 23/45] KVM: SVM: Add KVM_SNP_INIT command
To:     Ashish Kalra <ashkalra@amd.com>
Cc:     Alper Gun <alpergun@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
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
        Pavan Kumar Paluri <papaluri@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 13, 2022 at 6:21 PM Ashish Kalra <ashkalra@amd.com> wrote:
>
>
> On 6/13/22 23:33, Alper Gun wrote:
> > On Mon, Jun 13, 2022 at 4:15 PM Ashish Kalra <ashkalra@amd.com> wrote:
> >> Hello Alper,
> >>
> >> On 6/13/22 20:58, Alper Gun wrote:
> >>> static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >>>>    {
> >>>> +       bool es_active = (argp->id == KVM_SEV_ES_INIT || argp->id == KVM_SEV_SNP_INIT);
> >>>>           struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> >>>> -       bool es_active = argp->id == KVM_SEV_ES_INIT;
> >>>> +       bool snp_active = argp->id == KVM_SEV_SNP_INIT;
> >>>>           int asid, ret;
> >>>>
> >>>>           if (kvm->created_vcpus)
> >>>> @@ -249,12 +269,22 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >>>>                   return ret;
> >>>>
> >>>>           sev->es_active = es_active;
> >>>> +       sev->snp_active = snp_active;
> >>>>           asid = sev_asid_new(sev);
> >>>>           if (asid < 0)
> >>>>                   goto e_no_asid;
> >>>>           sev->asid = asid;
> >>>>
> >>>> -       ret = sev_platform_init(&argp->error);
> >>>> +       if (snp_active) {
> >>>> +               ret = verify_snp_init_flags(kvm, argp);
> >>>> +               if (ret)
> >>>> +                       goto e_free;
> >>>> +
> >>>> +               ret = sev_snp_init(&argp->error);
> >>>> +       } else {
> >>>> +               ret = sev_platform_init(&argp->error);
> >>> After SEV INIT_EX support patches, SEV may be initialized in the platform late.
> >>> In my tests, if SEV has not been initialized in the platform yet, SNP
> >>> VMs fail with SEV_DF_FLUSH required error. I tried calling
> >>> SEV_DF_FLUSH right after the SNP platform init but this time it failed
> >>> later on the SNP launch update command with SEV_RET_INVALID_PARAM
> >>> error. Looks like there is another dependency on SEV platform
> >>> initialization.
> >>>
> >>> Calling sev_platform_init for SNP VMs fixes the problem in our tests.
> >> Trying to get some more context for this issue.
> >>
> >> When you say after SEV_INIT_EX support patches, SEV may be initialized
> >> in the platform late, do you mean sev_pci_init()->sev_snp_init() ...
> >> sev_platform_init() code path has still not executed on the host BSP ?
> >>
> > Correct, INIT_EX requires the file system to be ready and there is a
> > ccp module param to call it only when needed.
> >
> > MODULE_PARM_DESC(psp_init_on_probe, " if true, the PSP will be
> > initialized on module init. Else the PSP will be initialized on the
> > first command requiring it");
> >
> > If this module param is false, it won't initialize SEV on the platform
> > until the first SEV VM.
> >
> Ok, that makes sense.
>
> So the fix will be to call sev_platform_init() unconditionally here in
> sev_guest_init(), and both sev_snp_init() and sev_platform_init() are
> protected from being called again, so there won't be any issues if these
> functions are invoked again at SNP/SEV VM launch if they have been
> invoked earlier during module init.

That's one solution. I don't know if there is a downside to the system
for enabling SEV if SNP is being enabled but another solution could be
to just directly place a DF_FLUSH command instead of calling
sev_platform_init().

>
> Thanks, Ashish
>
