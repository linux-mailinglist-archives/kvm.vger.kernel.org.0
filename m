Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FA77CFF39
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 18:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345139AbjJSQPT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 12:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjJSQPS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 12:15:18 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8559114
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 09:15:16 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c9d4e38f79so67497865ad.2
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 09:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697732116; x=1698336916; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=09L4XxQdyFI0hEokOUGHOhWPvvo7gUvMowYIXj3Yqn0=;
        b=w5DgHbW4BV2XMuk+506usaqSIlaq5tfnD1RHUPoce+t1ruQMQXdrTqgPgMyM4XqGH1
         5WAr0uYGq9I5ho0V0XHISO9j6W5qiMtWJDnNizCdwGnt5vWHiOQERqE21/nL1b9dIxlA
         bZ0i5KkAUrCNUDctTRV2j1KUdoEQUd1llRWP2E20ZA8iLrfcL4IAwGc1QGPr00qWT92J
         Efz9Hb7qYWzBtyenbslXCy2/dCL6Yk9SmsnT9JkP4sXZRqZdHFPfvs1fsrGKLRcj1zQJ
         sU3HDqldLYz+RhphEBNonBewq5mIEFXncVOUaAlNFvxG+zsN0pN/whZOuCcriLzkl8rU
         ohWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697732116; x=1698336916;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=09L4XxQdyFI0hEokOUGHOhWPvvo7gUvMowYIXj3Yqn0=;
        b=ouJ1f4LYNPSMQDoLDMU0PdYj78CPRtOycAg5FYnDUr1QEEAtbgDOpJKZe+naGcI6s9
         aIy8uRaSvhFgq9dHQO1kAUCaewnYyrjmHdfhJcYg+R8RBo/5QZr/wC9bvhBWtby6JUUX
         +rEPyoe8qzMo0doCual1a/BmYL31pcNQFyT1FLbN5ekz7sW54ugh6aViBozikWILBh7W
         gW281aOfmTFA8muMEVj+ZGwTCM8h6Yi/BqmplPyK7uUno1JoV1AhYZEHk6//KRkNYA/f
         y0NpFRk0ZIfbawhn/Fw4QF9X7DoeHUb04zvc7jAx64sH5+QDHl1F30HTdb2S3VIoZN6I
         gA3w==
X-Gm-Message-State: AOJu0YzjsJUbiU56b7N/CqmUYYfIm0MZAnXV7RlvoEWiO3r7h0SvWXLt
        ROjLzpkfPMYfl0EOG3LbWzIbMJ6Hq/E=
X-Google-Smtp-Source: AGHT+IEnsvd3v8uxBsfzqaexvqDFYl1EsxRVbNDS1zwKUH7J7roLNA9uBA7okXynBiub+pqW/ajv/NFZ4DA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:6505:b0:1c9:c95e:6b2d with SMTP id
 b5-20020a170902650500b001c9c95e6b2dmr50322plk.4.1697732116131; Thu, 19 Oct
 2023 09:15:16 -0700 (PDT)
Date:   Thu, 19 Oct 2023 09:15:14 -0700
In-Reply-To: <20bb3005-bf6c-4fe1-bf0d-6d37e0ce1a77@zytor.com>
Mime-Version: 1.0
References: <20230927230811.2997443-1-xin@zytor.com> <ZTBJO75Zu1JBsqvw@google.com>
 <20bb3005-bf6c-4fe1-bf0d-6d37e0ce1a77@zytor.com>
Message-ID: <ZTFWEte375FF-5RA@google.com>
Subject: Re: [PATCH 1/1] KVM: VMX: Cleanup VMX basic information defines and usages
From:   Sean Christopherson <seanjc@google.com>
To:     Xin Li <xin@zytor.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, weijiang.yang@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 19, 2023, Xin Li wrote:
> On 10/18/2023 2:08 PM, Sean Christopherson wrote:
> 
> > > Add IA32_VMX_BASIC MSR bitfield shift macros and use them to define VMX
> > > basic information bitfields.
> > 
> > Why?  Unless something actually uses the shift independently, just define the
> > BIT_ULL(...) straightaway.
> 
> Well, reading "BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |" is hard.

I wasn't suggesting that, I was suggesting:

 #define VMX_BASIC_INOUT                          BIT_ULL(54)

instead of

 #define VMX_BASIC_INOUT                          BIT_ULL(VMX_BASIC_INOUT_SHIFT)

Defining a shift adds a pointless layer of indirection (if the shift isn't used
directly).  It's especially problematic when there are a series of definitions.
E.g. if I want to know which bit a flag corresponds to, this:

  #define VMX_BASIC_32BIT_PHYS_ADDR_ONLY          BIT_ULL(48)
  #define VMX_BASIC_DUAL_MONITOR_TREATMENT        BIT_ULL(49)
  #define VMX_BASIC_MEM_TYPE(x)                   (((x) & GENMASK_ULL(53, 50)) >> 50)
  #define VMX_BASIC_INOUT                         BIT_ULL(54)
  #define VMX_BASIC_TRUE_CTLS                     BIT_ULL(55)

is much easier for me to process than this

  #define VMX_BASIC_32BIT_PHYS_ADDR_ONLY_SHIFT    48
  #define VMX_BASIC_32BIT_PHYS_ADDR_ONLY          BIT_ULL(VMX_BASIC_32BIT_PHYS_ADDR_ONLY_SHIFT)
  #define VMX_BASIC_DUAL_MONITOR_TREATMENT_SHIFT  49
  #define VMX_BASIC_DUAL_MONITOR_TREATMENT        BIT_ULL(VMX_BASIC_DUAL_MONITOR_TREATMENT_SHIFT)
  #define VMX_BASIC_MEM_TYPE_SHIFT                50
  #define VMX_BASIC_INOUT_SHIFT                   54
  #define VMX_BASIC_INOUT                         BIT_ULL(VMX_BASIC_INOUT_SHIFT)
  #define VMX_BASIC_TRUE_CTLS_SHIFT               55
  #define VMX_BASIC_TRUE_CTLS                     BIT_ULL(VMX_BASIC_TRUE_CTLS_SHIFT)

and the former also tends to work better for IDEs that support peeking at macro
definitions.

> > > ---
> > >   arch/x86/include/asm/msr-index.h       | 31 ++++++++++++++++++++------
> > >   arch/x86/kvm/vmx/nested.c              | 10 +++------
> > >   arch/x86/kvm/vmx/vmx.c                 |  2 +-
> > >   tools/arch/x86/include/asm/msr-index.h | 31 ++++++++++++++++++++------
> > 
> > Please drop the tools/ update, copying kernel headers into tools is a perf tools
> > thing that I want no part of.
> > 
> > https://lore.kernel.org/all/Y8bZ%2FJ98V5i3wG%2Fv@google.com
> 
> why can't we simply remove tools/arch/x86/include/asm/msr-index.h?

That's a question for the tools/perf folks, though I believe the answer is partly
that the perf tooling relies on *exactly* matching kernel-internal structures, and
so tools/perf doesn't want to rely on installed headers.

> > > +#define VMX_BASIC_RESERVED_BITS			\
> > > +	(VMX_BASIC_ALWAYS_0 |			\
> > > +	 VMX_BASIC_RESERVED_RANGE_1 |		\
> > > +	 VMX_BASIC_RESERVED_RANGE_2)
> > 
> > I don't see any value in defining VMX_BASIC_RESERVED_RANGE_1 and
> > VMX_BASIC_RESERVED_RANGE_2 separately.   Or VMX_BASIC_ALWAYS_0 for the matter.
> > And I don't think these macros need to go in msr-index.h, e.g. just define them
> > above vmx_restore_vmx_basic() as that's likely going to be the only user, ever.
> 
> hmm, I'm overusing macros, better do:
> #define VMX_BASIC_RESERVED_BITS			\
> 	(BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56))

Please define from high=>low, x86 is little-endian.  I.e.

	 (GENMASK_ULL(63, 56) | GENMASK_ULL(47, 45) | BIT_ULL(31))

> Probably should also move VMX MSR field defs from msr-index.h to
> a vmx header file.

Why bother putting them in a header?  As above, it's extremely unlikely anything
besides vmx_restore_vmx_basic() will ever care about exactly which bits are
reserved.
