Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143F148F4D9
	for <lists+kvm@lfdr.de>; Sat, 15 Jan 2022 06:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiAOFCH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Jan 2022 00:02:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiAOFCH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Jan 2022 00:02:07 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A2DC061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 21:02:07 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id s22so15147509oie.10
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 21:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FQzHCH5FlNz+U7bWBTAZyle45WIZg9psEvWsAgYcLfg=;
        b=XsYeRC5z/SD0yApPR18F+winVTYuaJQFhvy2FZDWgSlNjK69/lSizDgqqAHegy0hkj
         BvLr0gPCZYVnMlpYHDa9si/dJEjy4EYBX+X78hWUzBxs3XkAV0trxT/aw6zvi02p470D
         oN8ZQ1bueuykpTrhY5gp7Mae/UIjQ9oiH2630gpal53lPVoGnzCK2hhsSe+71U1Zq/6N
         W91qFm/T/+ss2VP5tiUaFQEwujwfxntp1ZoS4teVWfnUYL168IqrT5kvX5JAEJIo0ywB
         7RNVCPIOZyG33gzhWCq9QpuTk47lZ9mf4glEOfgu0QLwXeAYod/ctxWZ/He28JY7f5e1
         8Adg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FQzHCH5FlNz+U7bWBTAZyle45WIZg9psEvWsAgYcLfg=;
        b=lm1PBDi9W8l+2zxZZTf1lNGegOhWg6lxUr5XvAF7Js08PWvgHnLrF4PKNdivEXv8Fa
         5cUwIRLaFp/kZusFTMxDQro9sXgCOAMMj9fi1XU6JxRlWKBZ6R65EdLKcDoetll0CHk4
         S806r9Sq14ZZN+pEufCZrumpLwyMSnRzD5CG1QA/k2LhBjesFHyBhwl/uVFulGkJap+o
         jsSvv2WS5lIZoZAXFZPhvVWIH+Sd3qCNPk+FIIgUTKLsJxvRd9mwyRvKYz2cnO5n7X/o
         YE/oPbDZTiBtvUwyYsUPD8aeixQqFnLoL4MM+VyCgZy2I8Js+vjmht/duHCNS7BPS/pK
         BH1A==
X-Gm-Message-State: AOAM533/fn+2Kw3CpuKANaZ0jR1x/T8o9AzoA1Vew4ZV6xnebszYnRZS
        Qwo4OADUN6jwkzc9cq4KM0dvXDPX+7/8lNo5FhJtlg==
X-Google-Smtp-Source: ABdhPJwcAip/K8CaTPAsCGOnQhlrdjH1/8ecfJ8WFfimVc+XEKvqSBS78uBKLzO3xk4ryebq7emeiShV4MRHCSNkrfY=
X-Received: by 2002:a05:6808:14cd:: with SMTP id f13mr10526810oiw.76.1642222926120;
 Fri, 14 Jan 2022 21:02:06 -0800 (PST)
MIME-Version: 1.0
References: <20220114012109.153448-1-jmattson@google.com> <20220114012109.153448-7-jmattson@google.com>
 <CABOYuvb=LgmGSZ33Ht6eGYO8P-88Y7i=F=AEjVDxPfkQg46x0g@mail.gmail.com>
In-Reply-To: <CABOYuvb=LgmGSZ33Ht6eGYO8P-88Y7i=F=AEjVDxPfkQg46x0g@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 14 Jan 2022 21:01:55 -0800
Message-ID: <CALMp9eRWWgY1UT6KvnpHoopA86W9=kXojjYpvjLasJ9oBtNGSA@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] selftests: kvm/x86: Add test for KVM_SET_PMU_EVENT_FILTER
To:     David Dunn <daviddunn@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        cloudliang@tencent.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 14, 2022 at 11:15 AM David Dunn <daviddunn@google.com> wrote:
>
> Jim,
>
> The patch set looks good to me.  A couple comments and questions
> related just to this test are inline.
>
> On Thu, Jan 13, 2022 at 5:21 PM Jim Mattson <jmattson@google.com> wrote:
>
> > + * Determining AMD support for a PMU event requires consulting the AMD
> > + * PPR for the CPU or reference material derived therefrom.
> > + */
> > +static bool vcpu_supports_amd_zen_br_retired(void)
> > +{
> > +       struct kvm_cpuid_entry2 *entry;
> > +       struct kvm_cpuid2 *cpuid;
> > +
> > +       cpuid = kvm_get_supported_cpuid();
> > +       entry = kvm_get_supported_cpuid_index(1, 0);
> > +       return entry &&
> > +               ((x86_family(entry->eax) == 0x17 &&
> > +                 (x86_model(entry->eax) == 1 ||
> > +                  x86_model(entry->eax) == 0x31)) ||
> > +                (x86_family(entry->eax) == 0x19 &&
> > +                 x86_model(entry->eax) == 1));
> > +}
>
> The above function does not verify that the AMD host you are running
> on supports PMU.  In particular, you might be running the KVM test
> suite within a guest.  Is there a way to do that check here without
> direct access to MSRs?  If not, maybe we need a KVM capability to
> query this information.

On Intel, if the parent hypervisor has constructed the CPUID:0AH leaf
correctly, the test will skip because it can't find what it wants in
CPUID:0AH, and the CPU family isn't what it is looking for on the AMD
side.

On AMD, the test assumes that the PMU is there (as the specification
requires). For the Zen line, a VM with vPMU enabled should report
CPUID:80000001H:ECX.PerfCtrExtCore[bit 23] set, and a VM with vPMU
disabled should report that bit clear.

In v3, I'm adding a PMU sanity check based on Linux's check_hw_exists().

> > +       r = kvm_check_cap(KVM_CAP_PMU_EVENT_FILTER);
> > +       if (!r) {
> > +               print_skip("KVM_CAP_PMU_EVENT_FILTER not supported");
> > +               exit(KSFT_SKIP);
> > +       }
>
> This capability is still supported even when PMU has been disabled by
> Like Xu's new module parameter.  Should all the PMU related
> capabilities be gated behind that module parameter?

Perhaps. That's something for Like Xu to consider with the current
rewrite of the module parameter.

> Dave Dunn
