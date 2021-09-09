Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC97405AB2
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 18:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236918AbhIIQWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 12:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236864AbhIIQWo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 12:22:44 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D96C061757
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 09:21:34 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id m4so3850123ljq.8
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 09:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=50boaNouSSTnvb0c2eCNnctIiz+x2UvGPCv3kZE2AMI=;
        b=CGlS41mR+Axb4y9wrWknWpwz18CNGuBs4jPnMvqDoRK2oZuinLZetPH/MFKIb8QsFq
         dwjlyvlbpGylKPvinmbj4zrK082kTzJ/A04BP0LPHPiMny8rw5XtJdbuLyAS2Cu3Iq2a
         5mNDcYlZpJ2rQYFynA/vjgP5nvtJhW6kmblNhC/mlC/ZRbrsvDSWmxVX/yijiPJwLctZ
         Ok3XosICIt8PBk3Z4ObHrWttu9jOcUZBhM97/+okCfieuqwKAP85xxSsRIcM0i6dEpx6
         CSdgzkqPT6zNjVZ+EGv4lv3irK7wfuuFFRAdH8Mg0EGSH/uIQU2+RRXceMf1eqItaojC
         GeKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=50boaNouSSTnvb0c2eCNnctIiz+x2UvGPCv3kZE2AMI=;
        b=kufF6Zpel+WGL1Hswdk2iEXqqvbJw4vfSJyYNh63D1Ylas6euhdpNJZetmz+9OihKG
         oea33ZK0IPD/i+VudLAw/5ykHpbzzCh+G+ByS3No0xCoj6rDHkN0dY/XYt32FWMGwNXk
         M2B8rQvfTnwRBhZ75AcQXHudKpDAxpUdkW6oR7gAlgqEXyfjcOpuqWUr27/EdysZX0JR
         yrdzY5UoG24MWmDjeC+nRL4lG/Hqu8bEgpiXRhALPEJWW8Gf/XtSKfjq4eu1O0PFVhvg
         MMjwcS+p5eQVHLvNay5o2Bi8/zovnLDO16UlbzYjteg0LlXhg6orDewFdFvZXEJNS5w/
         r/LA==
X-Gm-Message-State: AOAM530MRtnl7jzOyFLEFWcooo2BWmUzePXCgVi5ti6e5TzDINoaYRjW
        UMs1328intSo1RYeojZijlDSW7q7S3F+uz8U1lWs4g==
X-Google-Smtp-Source: ABdhPJzsPtWW1AxipaV2pMWSdisA0skj+HLtMngumlXVDQINaNFPekQ15ydtkZbF3rf81kHbTiw9diF0ZbdCGuQNGTc=
X-Received: by 2002:a05:651c:98c:: with SMTP id b12mr557878ljq.83.1631204492754;
 Thu, 09 Sep 2021 09:21:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210820151933.22401-1-brijesh.singh@amd.com> <20210820151933.22401-35-brijesh.singh@amd.com>
 <CAMkAt6qQOgZVEMQdMXqvs2s8pELnAFV-Msgc2_MC5WOYf8oAiQ@mail.gmail.com>
 <4742dbfe-4e02-a7e3-6464-905ccc602e6c@amd.com> <CAMkAt6pT4vkgLxTN1Lj54ufaStyCHHitNaHAdZvEgDV8Nyrx-Q@mail.gmail.com>
 <f54f3fc3-14c3-5c36-2712-62eb625a958b@amd.com>
In-Reply-To: <f54f3fc3-14c3-5c36-2712-62eb625a958b@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 9 Sep 2021 10:21:20 -0600
Message-ID: <CAMkAt6oG0L4an-VgsADxz1xs6-wq3x4Qpxk9BdP=F2W3uT8U4g@mail.gmail.com>
Subject: Re: [PATCH Part1 v5 34/38] x86/sev: Add snp_msg_seqno() helper
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        kvm list <kvm@vger.kernel.org>, linux-efi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
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
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        Marc Orr <marcorr@google.com>,
        sathyanarayanan.kuppuswamy@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 9, 2021 at 10:17 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
>
>
> On 9/9/21 10:43 AM, Peter Gonda wrote:
> ...
>
> >>
> >> Does this address your concern?
> >
> > So the 'snp_msg_seqno()' call in 'enc_payload' will not increment the
> > counter, its only incremented on 'snp_gen_msg_seqno()'? If thats
> > correct, that addresses my first concern.
> >
>
> Yes, that is goal.
>
> >>>
> >>
> >> So far, the only user for the snp_msg_seqno() is the attestation driver.
> >> And the driver is designed to serialize the vmgexit request and thus we
> >> should not run into concurrence issue.
> >
> > That seems a little dangerous as any module new code or out-of-tree
> > module could use this function thus revealing this race condition
> > right? Could we at least have a comment on these functions
> > (snp_msg_seqno and snp_gen_msg_seqno) noting this?
> >
>
> Yes, if the driver is not performing the serialization then we will get
> into race condition.
>
> One way to avoid this requirement is to do all the crypto inside the
> snp_issue_guest_request() and eliminate the need to export the
> snp_msg_seqno().
>
> I will add the comment about it in the function.

Actually I forgot that the sequence number is the only component of
the AES-GCM IV. Seen in 'enc_payload'. Given the AES-GCM spec requires
uniqueness of the IV. I think we should try a little harder than a
comment to guarantee we never expose 2 requests encrypted with the
same sequence number / IV. It's more than just a DOS against the
guest's PSP request ability but also could be a guest security issue,
thoughts?

https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-38d.pdf
(Section 8 page 18)

>
> thanks
