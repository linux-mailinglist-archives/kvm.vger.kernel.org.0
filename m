Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B2D48F060
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 20:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237130AbiANTPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 14:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233751AbiANTPg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 14:15:36 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583D1C061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 11:15:36 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id l4so7862581wmq.3
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 11:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bvAe3S0KcQvTUoMGNcXxe17MRzzqyvQCCu/Ha7bbxEM=;
        b=A2sxLarx9L6Ry2Jojcj/zRT8DIE9gFFfCHpcx1nQQ8PV/SAhZxSJuLWLiwdfWZLTH8
         2pKd8JAkuSE33VOQ77ZVskfO7IQMNMdERAmn0nkmrLEZ8JOmS+nLmRErZ9d+wNEqcN2n
         RcnXWBlxert60j80uUGFuI0nF/wcGIxDiuZRyTZSUUJ7IQAjfCvYXX+JJadSagzlEh4j
         XLVSIih5sadnyG9xFg4YijdD9ZbtH30ywnIljiKA+cxhVnAYgFfHmtazcMYkltiey412
         4lpNgg43QVs2fYoIUwmxMLj/42GkxilmR3mrDvAbuCz4dvkfO7gschOcb3mrxst2KM+i
         ytEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bvAe3S0KcQvTUoMGNcXxe17MRzzqyvQCCu/Ha7bbxEM=;
        b=6IkpvoTwEa29u/MoeUzXFjRCMvaXToSl4KpnOJVNZtyOwpxevt5E2J7DhfCGHAkFmB
         /9w4gGwbS/aABZxsrTl3Cq9HDS33Kmg0uzhW0fV1u1cQ+4BRe8JWmwLrcFdCrpsd0tH+
         c6S9K6oG8cPqCmHtnyG82c6r15PBEWM5RwQs09th9U9s6qNUaOBp41aybZ6idT2G7qlr
         Ct+JgDm9BrcuPRCCY0+21HAq36V3CEs3galN5YIgJLJgi5CO/2s9JEvcPE4xgzRhKtDF
         DlhfaHAnmRBeggJcAzfBbb+5VDuA1DVuusjdggyQ/IznywiYe0AZyR3mdhUdoKHWahHP
         WR0A==
X-Gm-Message-State: AOAM531TEtgCKg6mo+DlllGzxked57x9XL+81dHjroWgvOBOrL6WHsmT
        +B1liAMV14BSidj8W2WR1PRbhgOosOoTL5lKTvbBSg==
X-Google-Smtp-Source: ABdhPJxbjnNQvmaB34efrDTpUKnI48pryUjy39GC5U1Rj1D2BUzp3Zdqk0kOyl77TZMgsNj2RLGw9lvILWTVFjZ6LOM=
X-Received: by 2002:a05:600c:2906:: with SMTP id i6mr14966915wmd.105.1642187734844;
 Fri, 14 Jan 2022 11:15:34 -0800 (PST)
MIME-Version: 1.0
References: <20220114012109.153448-1-jmattson@google.com> <20220114012109.153448-7-jmattson@google.com>
In-Reply-To: <20220114012109.153448-7-jmattson@google.com>
From:   David Dunn <daviddunn@google.com>
Date:   Fri, 14 Jan 2022 11:15:23 -0800
Message-ID: <CABOYuvb=LgmGSZ33Ht6eGYO8P-88Y7i=F=AEjVDxPfkQg46x0g@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] selftests: kvm/x86: Add test for KVM_SET_PMU_EVENT_FILTER
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        cloudliang@tencent.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim,

The patch set looks good to me.  A couple comments and questions
related just to this test are inline.

On Thu, Jan 13, 2022 at 5:21 PM Jim Mattson <jmattson@google.com> wrote:

> + * Determining AMD support for a PMU event requires consulting the AMD
> + * PPR for the CPU or reference material derived therefrom.
> + */
> +static bool vcpu_supports_amd_zen_br_retired(void)
> +{
> +       struct kvm_cpuid_entry2 *entry;
> +       struct kvm_cpuid2 *cpuid;
> +
> +       cpuid = kvm_get_supported_cpuid();
> +       entry = kvm_get_supported_cpuid_index(1, 0);
> +       return entry &&
> +               ((x86_family(entry->eax) == 0x17 &&
> +                 (x86_model(entry->eax) == 1 ||
> +                  x86_model(entry->eax) == 0x31)) ||
> +                (x86_family(entry->eax) == 0x19 &&
> +                 x86_model(entry->eax) == 1));
> +}

The above function does not verify that the AMD host you are running
on supports PMU.  In particular, you might be running the KVM test
suite within a guest.  Is there a way to do that check here without
direct access to MSRs?  If not, maybe we need a KVM capability to
query this information.

> +       r = kvm_check_cap(KVM_CAP_PMU_EVENT_FILTER);
> +       if (!r) {
> +               print_skip("KVM_CAP_PMU_EVENT_FILTER not supported");
> +               exit(KSFT_SKIP);
> +       }

This capability is still supported even when PMU has been disabled by
Like Xu's new module parameter.  Should all the PMU related
capabilities be gated behind that module parameter?

Dave Dunn
