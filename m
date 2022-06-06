Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B4153F24D
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 01:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235199AbiFFXBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 19:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235179AbiFFXBs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 19:01:48 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7759E9DC
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 16:01:47 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-f33f0f5b1dso20972062fac.8
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 16:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fvJVapmaiR5ta4tTtII1xFa6y7+0Xioffnfwf7wnw+o=;
        b=HwC38GPisP9Qe5N9Dxjshw2xLsFj/bl7lBR3ynQu0FQ7+euFbaZ4T5LHEJTbtOy9nP
         BxVGWlZjVH9N61c1ipVWuELIgXqPdtkyFpp5mvrcgbRHH43iQlWFwO3gQt8ZJmCgafGX
         XbkDBMefGP17Rwm0IO0esP26Irjo99G+nZfW/Y9GtdQXArM9KHm1+qU1rWAkDq+tca8C
         WcfaNA0aDM1QPVoF0AHIQrQoj1rXtqsxwqzoxJDD7cLFncOZesV0lidUDmsw+2thVrrk
         58Px0WoB3DMhAR4Bx5fCtrWY/SSkfvMt7nMO2zI99Ptey5kl5gUXfA9gwoP101qMDhLB
         tBHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fvJVapmaiR5ta4tTtII1xFa6y7+0Xioffnfwf7wnw+o=;
        b=q/+Lo5QIQadaFeqFrBkrHxZ6s/o5MMcu3E0dayv/Kbf4NsdORq5wykGfnt0WQzwiwM
         gWyohRC6ZULu0OUvT429WqnFSRPaO3GOffkagHS2eaJKlhE+SA/79VB7Dsi+Xx8QYJSk
         OQtezTjkZNLnb6LN7Lqsh7X+kcQHQ5ivZSQP2+B3HRleI/04auVbLEy0ak/+3F53XkMv
         L1nW2IoMdu32tK4AEge2qe3lCAvil5YyJJMhMagQUMBAyFdyyHXRrj4lFIGeFpfVAgeD
         Xv9NfOWKm4q1hXTPKpERF+uv1P+VuHtIe1bcX79Tf2ppzHfEVlY4hlTdkJoHPY92iQ1i
         KMGA==
X-Gm-Message-State: AOAM530zsCsz6Qq9yEJM27jVYRKsylokU1G3baM+OSTu11zfBax4qT2I
        ux+VHCcXc1mi17OZI33hNRp9yNVTeFGMWgcg6y2Zbw==
X-Google-Smtp-Source: ABdhPJxrmQDiRqVFb0RjkQcmEcjZ5kSWb8NBWoQZdMJUK94PfICLEPcP0PP3w5mCrrSeyWS7P5i6N07Wf5m9xFcwErg=
X-Received: by 2002:a05:6870:891f:b0:f3:3811:3e30 with SMTP id
 i31-20020a056870891f00b000f338113e30mr24252893oao.269.1654556506633; Mon, 06
 Jun 2022 16:01:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220602142620.3196-1-santosh.shukla@amd.com>
In-Reply-To: <20220602142620.3196-1-santosh.shukla@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jun 2022 16:01:35 -0700
Message-ID: <CALMp9eTh9aZ_Ps0HehAuNfZqYmCS72RKyfAP3Pe_u08N9F8ZLw@mail.gmail.com>
Subject: Re: [PATCH 0/7] Virtual NMI feature
To:     Santosh Shukla <santosh.shukla@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Thu, Jun 2, 2022 at 7:26 AM Santosh Shukla <santosh.shukla@amd.com> wrote:
>
> Currently, NMI is delivered to the guest using the Event Injection
> mechanism [1]. The Event Injection mechanism does not block the delivery
> of subsequent NMIs. So the Hypervisor needs to track the NMI delivery
> and its completion(by intercepting IRET) before sending a new NMI.
>
> Virtual NMI (VNMI) allows the hypervisor to inject the NMI into the guest
> w/o using Event Injection mechanism meaning not required to track the
> guest NMI and intercepting the IRET. To achieve that,
> VNMI feature provides virtualized NMI and NMI_MASK capability bits in
> VMCB intr_control -
> V_NMI(11) - Indicates whether a virtual NMI is pending in the guest.
> V_NMI_MASK(12) - Indicates whether virtual NMI is masked in the guest.
> V_NMI_ENABLE(26) - Enables the NMI virtualization feature for the guest.
>
> When Hypervisor wants to inject NMI, it will set V_NMI bit, Processor will
> clear the V_NMI bit and Set the V_NMI_MASK which means the Guest is
> handling NMI, After the guest handled the NMI, The processor will clear
> the V_NMI_MASK on the successful completion of IRET instruction
> Or if VMEXIT occurs while delivering the virtual NMI.
>
> To enable the VNMI capability, Hypervisor need to program
> V_NMI_ENABLE bit 1.
>
> The presence of this feature is indicated via the CPUID function
> 0x8000000A_EDX[25].
>
> Testing -
> * Used qemu's `inject_nmi` for testing.
> * tested with and w/o AVIC case.
> * tested with kvm-unit-test
>
> Thanks,
> Santosh
> [1] https://www.amd.com/system/files/TechDocs/40332.pdf - APM Vol2,
> ch-15.20 - "Event Injection".
>
> Santosh Shukla (7):
>   x86/cpu: Add CPUID feature bit for VNMI
>   KVM: SVM: Add VNMI bit definition
>   KVM: SVM: Add VNMI support in get/set_nmi_mask
>   KVM: SVM: Report NMI not allowed when Guest busy handling VNMI
>   KVM: SVM: Add VNMI support in inject_nmi
>   KVM: nSVM: implement nested VNMI
>   KVM: SVM: Enable VNMI feature
>
>  arch/x86/include/asm/cpufeatures.h |  1 +
>  arch/x86/include/asm/svm.h         |  7 +++++
>  arch/x86/kvm/svm/nested.c          |  8 +++++
>  arch/x86/kvm/svm/svm.c             | 47 ++++++++++++++++++++++++++++--
>  arch/x86/kvm/svm/svm.h             |  1 +
>  5 files changed, 62 insertions(+), 2 deletions(-)
>
> --
> 2.25.1

When will we see vNMI support in silicon? Genoa?

Where is this feature officially documented? Is there an AMD64
equivalent of the "Intel Architecture Instruction Set Extensions and
Future Features" manual?
