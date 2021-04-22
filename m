Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40EE368283
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 16:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236058AbhDVOhP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 10:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236465AbhDVOhO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 10:37:14 -0400
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EFDC06138B
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 07:36:37 -0700 (PDT)
Received: by mail-vk1-xa2f.google.com with SMTP id s190so5485152vkd.6
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 07:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=GR8P6grrgB3ruOkM69G+4yKFVdAdfJxp2iiL3+XxziA=;
        b=SQf0wC9CJvMOB8pFyT3KrisZwvQ+yvrp0Xt/8dDvabcTCj2hf2KUmlVdk3VtEzHlz7
         J4inyZ5isJE1XxSbpUP2+BSPpHS/5eV697c/RLrwzFCQzCn5EdQ99MWEEjRSHculFL5P
         zwIWATBEuGR+iXRgqwZCy3KojPJ15BOQDD4FPWeLLI4vyc1L5cqljjiLkp4hHNn8+ohP
         Qxaysor7W6+gzjS8ltHNu1Mgz3HuRTuBRp8D40nxarNd0s8q5tcG3+ZiupOShJKqGs/1
         HjMrFih3kZhJh3aM65EiGg2HLzpuev5s5OcanU8ciUu4pNgRlhrL6l+Uo63cbO2VJ+X+
         2r+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=GR8P6grrgB3ruOkM69G+4yKFVdAdfJxp2iiL3+XxziA=;
        b=ZMip1Mxk6oiQbZCXDkIocL+AY0OpA0el1ji+Xf6rZDKvm5uryV2ntHoYRZL925KcNX
         Bs5yr39HQG016E67jwsLMT0nwHXrqVWDwftluGmmYzdDNIB8XjTT9+Xrh1uC9FPCmcZg
         vBEeSHt+Tni5447KD8zQLcDeoOptZfW0WbQxrSDq3fxUCfE0JBVIG4ai4fvWdgYM4uOq
         4EvvKxR1EreTTWX8bINFPn9pMTPdJKLrJu0w5ON3+W5SoiRbta2il5T/YdINSGQK4Jzv
         ifieRSbpKly3D6ZURwb93BMjKs1HNOrIPfCvXRqUBupHWDZTGK1IjcV19T4kyx3qIEoE
         5Lqw==
X-Gm-Message-State: AOAM530LM3CXR1nipbFyqpsNzRHRw/kyL0MEvNScpq8apjhRsLjIB0G9
        lCZU8PZlP2WloN/HUE3x6rL1am8/entm/szvU8OWvA==
X-Google-Smtp-Source: ABdhPJw2/4Q0etYHJIX8SUZrn0cxC9aDLUykjju5XsssaMG4RXKlwNRaWAk8OwmetWkgN7dTRMyHRiyfGopnQ57nIvs=
X-Received: by 2002:a1f:53c7:: with SMTP id h190mr3106831vkb.19.1619102196901;
 Thu, 22 Apr 2021 07:36:36 -0700 (PDT)
MIME-Version: 1.0
From:   Jue Wang <juew@google.com>
Date:   Thu, 22 Apr 2021 07:36:25 -0700
Message-ID: <CAPcxDJ6tkcgruegNfgPCjA3pS+-Q1iEGAZQejPhzOdx4x9cDnA@mail.gmail.com>
Subject: Re: [RFCv2 00/13] TDX and guest memory unmapping
To:     kirill.shutemov@linux.intel.com
Cc:     andi.kleen@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, erdemaktas@google.com, isaku.yamahata@intel.com,
        jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org,
        peterz@infradead.org, pgonda@google.com,
        rick.p.edgecombe@intel.com, rientjes@google.com, seanjc@google.com,
        srutherford@google.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 16 Apr 2021 18:40:53 +0300, Kirill A. Shutemov wrote:

> TDX integrity check failures may lead to system shutdown host kernel must
> not allow any writes to TD-private memory. This requirment clashes with
> KVM design: KVM expects the guest memory to be mapped into host userspace
> (e.g. QEMU).

> This patchset aims to start discussion on how we can approach the issue.

Hi Kirill,

Some potential food for thought:

Repurpose Linux page hwpoison semantics for TDX-private memory protection is
smart, however, treating PG_hwpoison or hwpoison swap pte differently when
kvm->mem_protected=true implicitly disabled the original capability of page
hwpoison: protecting the whole system from known corrupted physical memory
and giving user space applications an opportunity to recover from physical
memory corruptions.

Have you considered introducing a set of similar but independent
page/pte semantics
for TDX private memory protection purpose?

Best regards,
-Jue
