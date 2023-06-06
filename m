Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F4372498D
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 18:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238337AbjFFQyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 12:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238194AbjFFQyc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 12:54:32 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4111110EA
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 09:54:29 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-565d6824f2dso93877177b3.0
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 09:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686070468; x=1688662468;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vWfghhT+K/VvYdIHsaVVRXfigb3NJPqkB0cgBd8gNOA=;
        b=iEDqIHuxrXw0gIUvL9P7CFRGySn8VWahksHLrzLIsF04F3kpysyg/ZXXPgX1/Oq0Cg
         uNZwWVM0lmG1i9F7IvLGtcvDZxah8CCzeFmyYd8JeZI2cirpwt8HxgWG6YNxcZ/oyeHa
         Shr68eC/Tvns2OgiaZBrBLT4BmA8I7jF4xpC5y8+kZuzzOkVQcp5L55EaqRj+XlgqlfZ
         Gv17+BTmWt1BakRBdxSu5TYg8+VYNMtb+aPTYbMhfPJ/FZ2xN1jI3sKNVB31LT/1zIzf
         AT1jmu9pwQeIqWTDkhnxgRX4LBjvB9V3rKWEN9NGRmT9IyKYu0qddHc/5qvolsBdo1QK
         u8Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686070468; x=1688662468;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vWfghhT+K/VvYdIHsaVVRXfigb3NJPqkB0cgBd8gNOA=;
        b=fuumx0gG4KTb7n5bMPhENpuDsGw2rc+Gotb7N1Nur1ScPyFbEg/rXq3lgaUiijh1Pq
         zr8NAtiGz37Nj8ntz1ltuLEIHLAEgw6d0NrdxysdN8LWoEtvhQjYrF9TsczUfi1/kJTt
         KRKrN8HTwn+gmTJHb6miw8TtDp2fUw6hSf4hPLJoH1PKhD9v5PyWJTk9hjwf4qRVwsEg
         7/l+kGPEAoe35yhvXut3XZY5+EZbh8Nmfs4h6k9gLcMepMBLEF6iaEDnuGHBt4zskRf5
         JL255G2wbOuhlvPxhQu5hZC7gXIlxpXKOWS40o83XtnnYlLrwYS3mMj2BxHiapxqhr8f
         C9SQ==
X-Gm-Message-State: AC+VfDz4Rs/G9AUx6fS1KId0F7G7tBKliacfbhM0YqlSaX7veyN/zuYe
        3VLNzVAC8gk5JTjbSYv7O6KgqTkca5Y=
X-Google-Smtp-Source: ACHHUZ735NOAxJ3G3HjCYdRPxFLDWLMm4QKxC+twRQjzhCgzbcYWiG6wj9pxN63ErpW9hCrFilnr+ZskZ6M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:d208:0:b0:564:c5fd:6d98 with SMTP id
 x8-20020a81d208000000b00564c5fd6d98mr1286497ywi.10.1686070468519; Tue, 06 Jun
 2023 09:54:28 -0700 (PDT)
Date:   Tue, 6 Jun 2023 09:54:26 -0700
In-Reply-To: <ZHQdlSY2tsdGyCPs@chao-email>
Mime-Version: 1.0
References: <20230506030435.80262-1-chao.gao@intel.com> <b472b58d-0469-8a55-985c-1d966ce66419@intel.com>
 <ZGZhW/x5OWPmx1qD@google.com> <ZHQdlSY2tsdGyCPs@chao-email>
Message-ID: <ZH9kwlg2Ac9IER7Y@google.com>
Subject: Re: [PATCH] KVM: x86: Track supported ARCH_CAPABILITIES in kvm_caps
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 29, 2023, Chao Gao wrote:
> On Thu, May 18, 2023 at 10:33:15AM -0700, Sean Christopherson wrote:
> >FWIW, this trainwreck is another reason why I'm not going to look at the proposed
> >"Intel IA32_SPEC_CTRL Virtualization" crud until external forces dictate that I
> >do so.  I have zero confidence that a paravirt interface defined by hardware
> >vendors to fiddle with mitigations will be sane, flexible, and extensible.
> 
> Hi Sean,
> 
> Just to confirm we are on the same page:
> 
> "Intel IA32_SPEC_CTRL Virtualization" series consists of 3 parts:
> 
> 1. Expose BHI_CTRL, RRSBA_CTRL to guests. They are hardware mitigations to
>    disable BHI and RRSBA behaviors and can be used by both guest/host.
> 
> 2. Enable IA32_SPEC_CTRL Virtualization which is a VMX feature. This is for KVM
>    to effectively lock some bits of IA32_SPEC_CTRL MSR when guests are running.
> 
> 3. Implement the paravirt interface (the virtual MSRs) for guests to report
>    software mitigations in-use. KVM can utilize such information to enable
>    hardware mitigations for guests transparently to address software mitigation
>    effectiveness issues caused by CPU microarchitecture changes (RRSBA behavior,
>    size of branch history table).
> 
> As per my understanding, your concerns are primarily focused on #3, the
> paravirt interface, rather than the entire series. Am I correct in assuming that
> you do not oppose #1 and #2?

Yes, correct.  I definitely recommend posting #1 and #2 separately from the
paravirt interface, I ignored the entire series without realizing there is real
hardware support in there.

> You previously mentioned that the paravirt interface was not common [1], and
> this time, you expressed an expectation for the interface to be "sane, flexible,
> and extensible." To ensure clarity, I want to confirm my interpretation of
> your expectations:
> 
> 1. The interface should not be tied to a specific CPU vendor but instead be
>    beneficial for Intel and AMD (and even ARM, and potentially others).
> 
> 2. The interface should have the capability to solve other issues (e.g,
>    coordinate mitigations in guest/host to address other perf/function issues),
>    not limited to software mitigation effectiveness on Intel CPUs.
> 3. The interface should be extendable by VMMs rather than relying on hardware
>    vendors rolling out new spec. This enables VMM developers to propose new
>    ideas to coordinate mitigations in guest/host.

Ya, that's more or less my opinion.  Even more than allowing VMM developers to
extend/define the interface, I want the definition of the interace to be a
community/collaborative effort.  LKML has active representatives from all of the
major (known) hypervisors, so it shouldn't be *that* hard to figure out a way to
make the interface community driven.

Note that it doesn't necessarily have to be VMM developers, e.g. many of the
people that are intimately familiar with the mitigations aren't virtualization
folks.

> Please let me know if I missed any key points or if any of the above statements
> do not align with your expectations. 
> 
> [1]: https://lore.kernel.org/all/Y6Sin1bmLN10yvMw@google.com/ 
