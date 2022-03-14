Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A29E4D8842
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 16:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242597AbiCNPia (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 11:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242556AbiCNPi2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 11:38:28 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E717443F6
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 08:37:17 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id c15so5899068ljr.9
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 08:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kVfmtFDSCvEKnN5uVHIJTuQQYlsxOsGyYkf8pyY+0/Q=;
        b=ly6VgkyE/N2DilB66OlGgTRs7XW4ikkdeCj07AHpzwPTXmBvg/eY2zam8ApFTRlOR5
         nYovovt0CjCv0mVFSdNNRfD1GBVc98xUTH+4hYovxh5gLLysSq2wur504PTEG7cXYGzk
         +jkPBUqOQv7lTNsllfuiADSGF2qWM+CK0jYEiKkOeZX+chYHMrRb45BRHJrBu4Jf8w6g
         g8K5/Gotpcv8hvk7q9iB5jA2GHMwmm9zGE4Zz7n+REZaUOmbpBXU/YkfD9h+I400cL5l
         XV0ZgIKwTM1nv/8HsVU0lty08o+lppZiLyPoP2ZAWtdnBTDuHImmVUyRAagMg+LpSgsO
         R1yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kVfmtFDSCvEKnN5uVHIJTuQQYlsxOsGyYkf8pyY+0/Q=;
        b=DvzWEp+1QEg/nh+eKpHhDlV6VkjANoUdshEGJQgzH14hRkrqFfHNcUrNCje8duGMF9
         8nthbAcjsj4qdxUvoBPnrkg0paS10yeIV0UeP25cCwOFPBVWZCJmGTCNzgCmGgIWkEc8
         cQ48IYewxj4Ur2pZn/tvcKNrvxnEHf4twMVZGrJUdDtjQP1zaeagqNEoqan3gMitSWJ+
         oh8PO5Jvg1uhWLwMJgoR1ZoLo0kMfYZ9dL2ZQdnehsqIB4CvMIrFZJGngh5ULcE5rAmG
         jZVCMft9vaYsj6NVw2zJg/TnUAdXkV5iubHwOJCUGx3BA4FTAf6EGgw+hU59f8EDg6SS
         v5bQ==
X-Gm-Message-State: AOAM530FxodWNeWmhgDjIs52nF2v1EPNjMGMkebF6KMHVS0zkMGvE6H5
        sdq0PsMFHGAK1XQb1voYI7mZhIkWaN3fKLf1DUyvdA==
X-Google-Smtp-Source: ABdhPJypcCytiOSWiftk8g5xIcm1i6Q4xC23lRZ00aVkchh307Y/e92ibN4O2ilaRQP1fEwUjwULABkE209J2py0EZQ=
X-Received: by 2002:a2e:9654:0:b0:244:bb3f:6555 with SMTP id
 z20-20020a2e9654000000b00244bb3f6555mr14586391ljh.282.1647272234801; Mon, 14
 Mar 2022 08:37:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220307213356.2797205-1-brijesh.singh@amd.com> <20220307213356.2797205-47-brijesh.singh@amd.com>
In-Reply-To: <20220307213356.2797205-47-brijesh.singh@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 14 Mar 2022 09:37:03 -0600
Message-ID: <CAMkAt6pTwo0e6deCtdY7zjEi7-45Mb_Pr7R0uK8WL8uUZAadRw@mail.gmail.com>
Subject: Re: [PATCH v12 46/46] virt: sevguest: Add documentation for SEV-SNP
 CPUID Enforcement
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-efi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
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
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        brijesh.ksingh@gmail.com, Tony Luck <tony.luck@intel.com>,
        Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
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

On Mon, Mar 7, 2022 at 2:35 PM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
> From: Michael Roth <michael.roth@amd.com>
>
> Update the documentation with information regarding SEV-SNP CPUID
> Enforcement details and what sort of assurances it provides to guests.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>

Tested-by: Peter Gonda <pgonda@google.com>

I've booted these V12 patches on our internal KVM stack and then
tested these new driver ioctls with some basic usage. Feel free to add
this tag to all the driver patches, I am not sure if a basic boot test
qualifies this for the entire series though.
