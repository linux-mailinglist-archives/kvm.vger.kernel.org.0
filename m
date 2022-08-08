Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC43058CE8C
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 21:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244375AbiHHT15 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 15:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244337AbiHHT14 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 15:27:56 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C9F1A050
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 12:27:54 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-31f445bd486so90905607b3.13
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 12:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=KBxnTL7K25Hs8Wv1cjszwJQN73tLNnDr4U0ROfrziZM=;
        b=bmhDQvAoVXlswYykpII5N+dpGoKRhyIPQd6917OIYRgTBKCDiocZ8hBciok/W8LUze
         EIjX5hN3yiimne61Nb3aTNlb9nBZQmslL5TCM0d1LA7i2zQ/H/4aTTagUPnTlBHd7NNH
         jp49XCAYeppQJH6DZPAkhkhwaPCdGbr5LzxpBy1SPKkfFCpwOrhcOT7IXsuqUQ7ZkHXk
         2EN9b/GFRVyKWz6SZA4dRgUqR4NSQvsXiltm/yl8BfV5WDZTRhGGdA6KVukBUihgBOyH
         55C0EgVneBrxf/TZZbWXKThHVk8W/icGPUW+SM47rOw7socQV2WRJvnbyYLErUkfE5Gt
         l21w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=KBxnTL7K25Hs8Wv1cjszwJQN73tLNnDr4U0ROfrziZM=;
        b=PfiZEgNR8SPZ2K0c5nhv7u1E/QHQRC+K4OisjSy7hjBsDee1YNfIEGepNmrn86zdU2
         ZBG1+kP0pU5cr1B1FSuTSiXaoYIeYFmifJetYXNxdTCvRIAhDzmc+OwpmlE0rwIAlC4F
         Ftxdc2jGAHC0phi71BnX6biTz4cUjFLPt6n5msQTmMBzqvwRIhRlO0m5WPcdBTDowBRa
         +Be35Mz2NnuW7lpCbWmCTkS7tVlMsbjlqVIOE7dde+5EHrSZ9UULTLXW3AdqXtFK8IPy
         WB7XBWAALPxwcUt0uQEnYZcW47ud8+dHyz0vQV8CvydAn0qEEwaw4VpjzVXIz3Jwp1gE
         RA6A==
X-Gm-Message-State: ACgBeo3M/z/zWNeLrLfdsknzHv68hkIayqvAzyyF2/iWvh9ed/bTpj7+
        Cl4+34vHYktF4FlGoRUBvqrtnTgL5pdi5Qo/yHWHMg==
X-Google-Smtp-Source: AA6agR4CqP2bI2zng0Vr3lzhitvUH2Let9QUGzmufNUJrDlFIezoBA22p9QF8TCyK0rnYyUKBgURyaJWteXCXsvKjg8=
X-Received: by 2002:a0d:da41:0:b0:329:91e7:fd06 with SMTP id
 c62-20020a0dda41000000b0032991e7fd06mr10086726ywe.436.1659986873539; Mon, 08
 Aug 2022 12:27:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <d325cb5d7961f015400999dda7ee8e08e4ca2ec6.1655761627.git.ashish.kalra@amd.com>
 <YukZFKpAO5o5MLA1@kernel.org>
In-Reply-To: <YukZFKpAO5o5MLA1@kernel.org>
From:   Dionna Amalie Glaze <dionnaglaze@google.com>
Date:   Mon, 8 Aug 2022 12:27:42 -0700
Message-ID: <CAAH4kHazh_S4zTLimL3Bch7yo3zL2wv86j=w3f2n74O-joWLQQ@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 17/49] crypto: ccp: Add the SNP_{SET,GET}_EXT_CONFIG
 command
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:X86 KVM CPUs" <kvm@vger.kernel.org>,
        linux-coco@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>, hpa@zytor.com,
        Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, vkuznets@redhat.com,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>, dave.hansen@linux.intel.com,
        slp@redhat.com, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        srinivas.pandruvada@linux.intel.com,
        David Rientjes <rientjes@google.com>, dovmurik@linux.ibm.com,
        tobin@ibm.com, Borislav Petkov <bp@alien8.de>,
        "Roth, Michael" <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        Marc Orr <marcorr@google.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>, dgilbert@redhat.com
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

To preface, I don't want to delay this patch set, only have the
conversation at the most appropriate place.

>
> > The SEV-SNP firmware provides the SNP_CONFIG command used to set the
> > system-wide configuration value for SNP guests. The information includes
> > the TCB version string to be reported in guest attestation reports.
>

The system-wide aspect of this makes me wonder if we can also have a
VM instance-specific extension. This is important for the use case
that we may see secure boot variables included in the launch
measurement, making offline signing of the UEFI image impossible. We
can't sign the cross-product of all UEFI builds and every user's EFI
variables. We'd like to include an instance-specific certificate that
specifies the platform-endorsed golden measurement of the UEFI.

An alternative that doesn't require a change to the kernel is to just
make this certificate fetchable from a FAMILY_ID-keyed, predetermined
URL prefix + IMAGE_ID + '.crt', but this requires a download (and
continuous hosting) to do something as routine as collecting an
attestation report. It's up to the upstream community to determine if
that is an acceptable cost to keep the complexity of a certificate
table merge operation out of the kernel.

The SNP API specification gives an interpretation to the data blob
here as a table of GUID/offset pairs followed by data blobs that
presumably are at the appropriate offsets into the data pages. The
spec allows for the host to add any number of GUID/offset pairs it
wants, with 3 specific GUIDs recommended for the AMD PSP certificate
chain.

The snp_guest_ext_guest_request function in ccp is what passes back
the certificate data that was previously stored, so I'm wondering if
it can take an extra (pointer,len) pair of VM instance certificate
data to merge with the host certificate data before returning to the
guest. The new required length is the sum total of both the header
certs and instance certs. The operation to copy the data is no longer
a memcpy but a header merge that tracks the offset shifts caused by a
larger header and other certificates in the remaining data pages.

I can propose my own patch on top of this v6 patch set that adds a KVM
ioctl like KVM_{GET,SET}_INSTANCE_SNP_EXT_CONFIG and then pass along
the stored certificate blob in the request call. I'd prefer to have
the design agreed upon upfront though.

-- 
-Dionna Glaze, PhD (she/her)
