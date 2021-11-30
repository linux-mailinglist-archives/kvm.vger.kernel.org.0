Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D8946322B
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 12:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238610AbhK3LWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 06:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238533AbhK3LWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 06:22:03 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675BCC061574;
        Tue, 30 Nov 2021 03:18:44 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id e8so20730928ilu.9;
        Tue, 30 Nov 2021 03:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+v5hTuJ8jqJE0jLup8J5GnzDoMmyqlqcX2vMFJVi53E=;
        b=cgHCR5fy4vrVBWJAATdqr56wW81DX4qJ7lS3CbdgbX/ixc7RSfcW0G1ylxd7hyDVi9
         nnKC1szAV3hW3D4ZWdQxZnHsiwHFsydLpb29H+B9AkrThUISnV+GYAhXd2hLO88u180K
         CGYB3J56YrCH6OZX7KblzfeqPjqaKoWGBXSJGXf5NLLqP3iO1gh/Ci4YQRmO4PrsuayY
         4w5WMQ/RUidGF++M3Xax9fNjV5tbDK51vgprY0RyXMgvSM1QZp5n0hMJMTl6Em3K2RCH
         gSZNrZl18x7vPbAHUYkFVG8q3emfy9uU/IfVWAVs7QU73YeNFnO9Hg2iFVFQpXVqKp4p
         XH5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+v5hTuJ8jqJE0jLup8J5GnzDoMmyqlqcX2vMFJVi53E=;
        b=wnDXky8YrU4L9zXXmBThfEqqtIzHB0OZJFLksyJh8jWOPNBe+86d9lrdOx5+RGryxg
         d3VWzTb1K1BOjzSmkLljMeT+YEHeZNikRm2FOWg0an5v2uGt4e+2sR+/YfxD5UfJzyqx
         0ACq4qgPLREgz02jsjiYw1x2n5+FARKq0aeXpmy3SvTAat0DkEbo02pqnHccOeQr/uqR
         60MdsXkLEvABeFY6U8+p959/NVfcchFg9D3YYkSuYacCcJbU0c2RGqQ5bwLDFvD7Y45d
         Cw67jUf8YaNfVCXRAdf6pqLP/m6u5l29qMix4XgIEo6gSasF4O5HdZNzkbVBDFN5ogS2
         XNuQ==
X-Gm-Message-State: AOAM531f0vsG+pqghuTU2AomWd8ResGoc/XhS5nSnyDq1UHiOiK7mTFc
        twUCXK5uRJlf39klE4fGg8IO5U2E0ByORU4d55Y=
X-Google-Smtp-Source: ABdhPJxV/onctk3CTFhpQT598gRPXsk0xxEz5ALwMsLuNOW0Aqa/v7nVr2r1C3H88x4R9u5qHvSJoBFDSogD5otlGQ8=
X-Received: by 2002:a05:6e02:15c9:: with SMTP id q9mr60154971ilu.28.1638271123895;
 Tue, 30 Nov 2021 03:18:43 -0800 (PST)
MIME-Version: 1.0
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <4ede5c987a4ae938a37ab7fe70d5e1d561ee97d4.1637799475.git.isaku.yamahata@intel.com>
 <878rxcht3g.ffs@tglx> <20211126091913.GA11523@gao-cwp> <CAJhGHyAbBUyyVKL7=Cior_uat9rij1BB4iBwX+EDCAUVs1Npgg@mail.gmail.com>
 <20211129092605.GA30191@gao-cwp> <CAJhGHyCiZn8ZwBbVepU+tfmTV6gcDhXxzvS39BwpgUj+6LCZ0g@mail.gmail.com>
 <20211130081954.GA4357@gao-cwp>
In-Reply-To: <20211130081954.GA4357@gao-cwp>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Tue, 30 Nov 2021 19:18:32 +0800
Message-ID: <CAJhGHyA4EEiW37iwrZ7EXOTXC7aQHvGLaK_RSrMc++u1bepj5g@mail.gmail.com>
Subject: Re: [RFC PATCH v3 53/59] KVM: x86: Add a helper function to restore 4
 host MSRs on exit to user space
To:     Chao Gao <chao.gao@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, isaku.yamahata@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Erdem Aktas <erdemaktas@google.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021 at 4:10 PM Chao Gao <chao.gao@intel.com> wrote:

>
> No, it is already documented in public spec.

In intel-tdx-module-1.5-base-spec-348549001.pdf, page 79
"recoverability hist",  I think it is a "hint".

>
> TDX module spec just says some MSRs are reset to INIT state by TDX module
> (un)conditionally during TD exit. When to restore these MSRs to host's
> values is decided by host.
>


Sigh, it is quite a common solution to reset a register to a default
value here, for example in VMX, the host GDT.limit and host TSS.limit
is reset after VMEXIT, so load_fixmap_gdt() and invalidate_tss_limit()
have to be called in host in vmx_vcpu_put().

Off-topic: Is it a good idea to also put load_fixmap_gdt() and
invalidate_tss_limit() in user-return-notfier?
