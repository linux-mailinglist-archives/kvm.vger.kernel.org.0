Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B514D3DC232
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 03:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235245AbhGaBFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 21:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234893AbhGaBFO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 21:05:14 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F61C0613C1
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 18:05:08 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso16795179pjo.1
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 18:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7fCQsCvI2ERSkc9ox+/XNf66aLFSxrAJ6Aab87hhw0s=;
        b=X1ZVq0hpPSO5/Yd2KoFffT1sCZrD4/KqJLWniSqAunDAunqotTFNmgTlYx8KUSGe8m
         fPxlVyLQg40Wmttm/FuH4QmQ7tP+M366QBmOpPijlSr+alouiYwFqy6hq1pJWWjsmOA/
         SmemNq1syXjJlBEzTC3ubhKa1Pgs2IvjsWnLiso57YSoLYU8wZn3Hg/yXPwQf6h0RpaN
         GHJPFsm79AznsUpLJSXojUVdKaGrKvdZQcB0RBSUNbJwxuTPuJRuc6uDpsEgP22Qjhh2
         UD//jD0LgenwhRmsgQ7665zxDIsWvWtiiNvlB5W7XaTQwq68EQXW1Xa46KueX38SzbVT
         dd1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7fCQsCvI2ERSkc9ox+/XNf66aLFSxrAJ6Aab87hhw0s=;
        b=K9Cdgz7hd92+WQUXfZX2/RgftKgLCqCbO9L4s7Ki1NGSu26nzJqzt3cbUiQjZTvaL6
         qBWyO/olM8QfbQmTLAxFFn/7IPzIoM9p7Hm6Dprg+8uksiiKQRtk168d/jPxTkwd6FZ8
         4bBvtfEtvuUELJ7hW2PiZsGWxnZiTNbcZSAs+gVnXkKeb2sdtU1uTzjl/USh9ZlRZ1E2
         1uwEArXTTYqjBbwPJS+6cGFu2rtqFWnYY0c+oBKKoEwkkfsK2BKOgZ95vB440TQAGK0G
         1XtGo4mBLdDgDCGkDADJdhfD5Ge/huRigvwGTrGaIewnUxREcgFr6ITvEleevSJSl/nq
         VuDg==
X-Gm-Message-State: AOAM533Vfrsj1YVNZIXg8iAI/TDrJoS/3728qlzU/MR5PSDu5Jvea8dF
        RYbpkXZ3lfwQ9lG4tSx7ntgBR3LNYBIgQa/VeprZdA==
X-Google-Smtp-Source: ABdhPJwwGCDxYc0g7AC9UO9CQ7HbqhDlZ7Jx0scPAC9w4HO534gFU7sVhQvnq7/WEPE7IJoY5Kr1Dw+NQ0K9rCkHt/c=
X-Received: by 2002:a17:90a:1b01:: with SMTP id q1mr5854899pjq.162.1627693508091;
 Fri, 30 Jul 2021 18:05:08 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1625186503.git.isaku.yamahata@intel.com> <d29b2ac2090f20e8de96888742feb413f597f1dc.1625186503.git.isaku.yamahata@intel.com>
In-Reply-To: <d29b2ac2090f20e8de96888742feb413f597f1dc.1625186503.git.isaku.yamahata@intel.com>
From:   Erdem Aktas <erdemaktas@google.com>
Date:   Fri, 30 Jul 2021 18:04:57 -0700
Message-ID: <CAAYXXYy=fn9dUMjY6b6wgCHSTLewnTZLKb00NMupDXSWbNC9OQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 05/69] KVM: TDX: Add architectural definitions for
 structures and values
To:     "Yamahata, Isaku" <isaku.yamahata@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86 <x86@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 2, 2021 at 3:05 PM <isaku.yamahata@intel.com> wrote:
> +/* Management class fields */
> +enum tdx_guest_management {
> +       TD_VCPU_PEND_NMI = 11,
> +};
> +
> +/* @field is any of enum tdx_guest_management */
> +#define TDVPS_MANAGEMENT(field)        BUILD_TDX_FIELD(32, (field))

I am a little confused with this. According to the spec, PEND_NMI has
a field code of 0x200000000000000B
I can understand that 0x20 is the class code and the PEND_NMI field code is 0xB.
On the other hand, for the LAST_EXIT_TSC the field code is  0xA00000000000000A.
Based on your code and the table in the spec, I can see that there is
an additional mask (1ULL<<63) for readonly fields.
Is this information correct and is this included in the spec? I tried
to find it but somehow I do not see it clearly defined.

> +#define TDX1_NR_TDCX_PAGES             4
> +#define TDX1_NR_TDVPX_PAGES            5
> +
> +#define TDX1_MAX_NR_CPUID_CONFIGS      6
Why is this just 6? I am looking at the CPUID table in the spec and
there are already more than 6 CPUID leaves there.

> +#define TDX1_MAX_NR_CMRS               32
> +#define TDX1_MAX_NR_TDMRS              64
> +#define TDX1_MAX_NR_RSVD_AREAS         16
> +#define TDX1_PAMT_ENTRY_SIZE           16
> +#define TDX1_EXTENDMR_CHUNKSIZE                256

I believe all of the defined variables above need to be enumerated
with TDH.SYS.INFO.

> +#define TDX_TDMR_ADDR_ALIGNMENT        512
Is TDX_TDMR_ADDR_ALIGNMENT used anywhere or is it just for completeness?

> +#define TDX_TDMR_INFO_ALIGNMENT        512
Why do we have alignment of 512, I am assuming to make it cache line
size aligned for efficiency?


> +#define TDX_TDSYSINFO_STRUCT_ALIGNEMNT 1024

typo: ALIGNEMNT -> ALIGNMENT

-Erdem
