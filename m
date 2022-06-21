Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9987553931
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 19:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350323AbiFURvP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 13:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbiFURvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 13:51:14 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6841EC41
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 10:51:13 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id e4so16356186ljl.1
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 10:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/sWmRxaBB/7Gvydpg8oN2fyGVNJ3tXVZl0R1M5vQ/Us=;
        b=SIUQ2bfTgtqyKzjQXnVabWR9Z3n/VgrhU2riRxw0AgmXz5H2i9bjCSpp+euFcuWuLr
         btapNTHSb4sb6Dlc8c5EtrlKyvn9xrjsaMXEm7aPioRHs8rBMY+uZERTAzQmLVQnK1vN
         yKhxZkZUR82fcxHyRRqxyWHUHzDwy9sB8NRvzJ+vl/OwnzuaafTUAnsbscxCWGwt7jMB
         59esRMJI0H8QHYn6id6vBjd3uYPVHJcFcswVldGJo9tbKjNdP2YqadzjvdVZprf72/is
         jTh2NPUKW0DrIwZ3k8Ui1RzbVJGEGC+pQhncUSl4DSXTSJGsx66cmG7eT/EtfXyb3aRj
         zdMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/sWmRxaBB/7Gvydpg8oN2fyGVNJ3tXVZl0R1M5vQ/Us=;
        b=bClxJKzJBMiw9bx5BVSjl91Cb2zshLpMDk9RvAJ3TF7mj1HVSLd/C8TzcgRLH8134V
         iRRk3B7ov0VoYhFfDLnDtD803wJ6amBlPhdNIe/o9XNk0tvQaQIHtpP6tZpYaAuBLvsx
         oZxzg2ue89ExSpDT3QHfUKwOmfu7yOrbeDFUQnVxeH6WcDUXXbQD0JKpCSaXHneSQKcu
         OQc2wG0IqmKG+fweHoopxkMlaSCC6KGnZtg9K865pZFMs6F63UXXydBq5W4cDx9O2me6
         o9i+VgFnweD/3OD+k1lIlltapzaqYv6cLW5ilXuvSj2UYqP59ZRo9hESnhFnCOXpopRS
         1uTA==
X-Gm-Message-State: AJIora9qzh3AQ4YSS6rVR42TPC7ByCvCSL6aPdjXmyO1dvWZE96Da2cR
        s0koF+nH0ONNgrXGUtdXbXbZDhuWuL71Droo6plIGA==
X-Google-Smtp-Source: AGRyM1u/rxKy61/kcfa19O8kX+IARHxZ6GtcuY38CjxLPfM7sYm5YakXgDPAfoWdCippLLsbDohcmMAiLcyZQHFOTn4=
X-Received: by 2002:a2e:2a43:0:b0:25a:84a9:921c with SMTP id
 q64-20020a2e2a43000000b0025a84a9921cmr375799ljq.83.1655833871147; Tue, 21 Jun
 2022 10:51:11 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <12df64394b1788156c8a3c2ee8dfd62b51ab3a81.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6r+WSYXLZj-Bs5jpo4CR3+H5cpND0GHjsmgPacBK1GH_Q@mail.gmail.com> <SN6PR12MB2767A51D40E7F53395770DE58EB39@SN6PR12MB2767.namprd12.prod.outlook.com>
In-Reply-To: <SN6PR12MB2767A51D40E7F53395770DE58EB39@SN6PR12MB2767.namprd12.prod.outlook.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 21 Jun 2022 11:50:59 -0600
Message-ID: <CAMkAt6qorwbAXaPaCaSm0SC9o2uQ9ZQzB6s1kBkvAv2D4tkUug@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 02/49] iommu/amd: Introduce function to check
 SEV-SNP support
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

On Tue, Jun 21, 2022 at 11:45 AM Kalra, Ashish <Ashish.Kalra@amd.com> wrote:
>
> [AMD Official Use Only - General]
>
> Hello Peter,
>
> >> +bool iommu_sev_snp_supported(void)
> >> +{
> >> +       struct amd_iommu *iommu;
> >> +
> >> +       /*
> >> +        * The SEV-SNP support requires that IOMMU must be enabled, and is
> >> +        * not configured in the passthrough mode.
> >> +        */
> >> +       if (no_iommu || iommu_default_passthrough()) {
> >> +               pr_err("SEV-SNP: IOMMU is either disabled or
> >> + configured in passthrough mode.\n");
>
> > Like below could this say something like snp support is disabled because of iommu settings.
>
> Here we may need to be more precise with the error information indicating why SNP is not enabled.
> Please note that this patch may actually become part of the IOMMU + SNP patch series, where
> additional checks are done, for example, not enabling SNP if IOMMU v2 page tables are enabled,
> so precise error information will be useful here.

I agree we should be more precise. I just thought we should explicitly
state something like: "SEV-SNP: IOMMU is either disabled or configured
in passthrough mode, SNP cannot be supported".
