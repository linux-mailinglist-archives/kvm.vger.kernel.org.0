Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE02A7BA789
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 19:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjJERP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 13:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbjJERPE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 13:15:04 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E255D3A88
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 10:07:03 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-51e24210395so813a12.0
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 10:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696525622; x=1697130422; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wzZbwwBbKebKwgMr49OTxR0Xhz5+Y0n3B7MG0qd+R/Y=;
        b=AulhkyAN/GUHMVgM7g3Xc9xDMHysWVVVcpgXZmVyp8NReAsh08pEKNmFSUl0rg/Rd9
         i2eVboVQfpchFnZdQjU3DwsCjTTKGr+qt/YONzp570EaUvRRj9o5bpO7tGolNc5BYlOU
         2kjVo+tQAdEY7T/dN/eK+x/VkwhBGHC0UvRRhBzyuTdXE+KJseOcFLaQ8FoW5/IcLej5
         8Ke28JxRu8M7LOoQ/6OEf/IDL18BEHKfvl8H4Ard/v37yLivDzwRKQZ5Xd14sQXZwnkK
         yKFk12lhY/12Up7mrMDCe4Qy3KW2sovgugAkXp9Ad7qJoDnDzAOAmXzXOTbTk11E6Sc4
         YPJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696525622; x=1697130422;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wzZbwwBbKebKwgMr49OTxR0Xhz5+Y0n3B7MG0qd+R/Y=;
        b=EBDFANu6qDq3suvJ3oRFCLYJx5rL+dah91MDdiqerAAUQ03YB0O1s0zj1Uf8azXPlx
         Z0gDRXS5luevpgEA9Ow7oB28RWWj786FzdMY9xnnANdX3Qp8oOQGF+gPEM6d1E21mgN2
         3H0hm9m3mhEISy2DPKYML5YeJk3wd3cfQUHFCyLiI5YVpPCuqvr9k0Ly4rt0JuoTHThx
         ePE9Zngvj8B7aOMk0qH3ueWpjQ6gEJt5dRIZjHmxgOhNcXjrAnsl3dIPJHUZDSwPu23E
         9BSO6OOVj9qv55I8GAQ62i7StuJiZ+DEWiA5KfFl/v7ojC8EvK8hvHIPowcs1ZFprnAG
         zpTw==
X-Gm-Message-State: AOJu0Yzo8TwSE3hTjVPZRp85Q2TmDj6nftd1ryjlhrVNbPWJCBQwQnmG
        bvnp7bc8x7IJC+1DNZg9eXD9LFrpAmDAB7WnacNDOA==
X-Google-Smtp-Source: AGHT+IGT+kR1c9HFvTY4OIplYN+U2b57hpDklQEGtUSa87zhhvTwZ8/QEXjREsFcoHhv7GLM8rXHJpR8f2FjsuOLWgM=
X-Received: by 2002:a50:8d5a:0:b0:538:2941:ad10 with SMTP id
 t26-20020a508d5a000000b005382941ad10mr80323edt.5.1696525622177; Thu, 05 Oct
 2023 10:07:02 -0700 (PDT)
MIME-Version: 1.0
References: <20231004002038.907778-1-jmattson@google.com> <01009a2a-929e-ce16-6f44-1d314e6bcba5@intel.com>
 <CALMp9eR+Qudg++J_dmY_SGbM_kr=GQcRRcjuUxtm9rfaC_qeXQ@mail.gmail.com>
 <20231004075836.GBZR0bLC/Y09sSSYWw@fat_crate.local> <8c810f89-43f3-3742-60b8-1ba622321be8@redhat.com>
In-Reply-To: <8c810f89-43f3-3742-60b8-1ba622321be8@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 5 Oct 2023 10:06:45 -0700
Message-ID: <CALMp9eR=URBsz1qmTcDU5ixncUTkNgxJahLbfyZXYr-2RkBPng@mail.gmail.com>
Subject: Re: [PATCH] x86: KVM: Add feature flag for AMD's FsGsKernelGsBaseNonSerializing
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 5, 2023 at 9:39=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com> =
wrote:

> I agree with Jim that it would be nice to have some bits from Intel, and
> some bits from AMD, that current processors always return as 1.  Future
> processors can change those to 0 as desired.

That's not quite what I meant.

Today, hypervisors will not pass through a non-zero CPUID bit that
they don't know the definition of. This makes sense for positive
features, and for multi-bit fields.

I'm suggesting a leaf devoted to single bit negative features. If a
bit is set in hardware, it means that something has been taken away.
Hypervisors don't need to know exactly what was taken away. For this
leaf only, hypervisors will always pass through a non-zero bit, even
if they have know idea what it means.
