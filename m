Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F7745E0D6
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 20:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348027AbhKYTKl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 14:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344775AbhKYTIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 14:08:41 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE5EC061748;
        Thu, 25 Nov 2021 11:04:59 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637867098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Oz7HCCJbRZTXPY8sP0FTAqsOpkpeXGFLm05SsvM3whY=;
        b=Q+62m+JawlMj+kcJc27ohBMMD7XpbafWwRKl3OnoKzzdyzKeRB7Ywga5nyy30i4BgJUPIs
        aNMjjCI3ZK9qynJHz0z3MVXlXPcrl+KXFdOkeKmX2wdbXNcSXt9jFu7MaSqKiWHV9FgA+H
        uZV+3frTlzZ0UZggzCfQHRf+hceF30fFdbaZmMp0Y8wbAW/HLF8vO8KV0LNSHHNqU8kLG4
        drTgy74NFHQNGhRhu5JfKfWQFnr94ewH3fxSVaH3+h6IEv0+N9+CQGXYjMKr3DeDq5elsw
        pCq4y4ULJQmxhmPX+UwBEr3+o93oH53hQGwY2XRz4hsNXaIxUmOupq/EXzXlFg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637867098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Oz7HCCJbRZTXPY8sP0FTAqsOpkpeXGFLm05SsvM3whY=;
        b=rF5T8wrwT7kWq7/HBOgl3nNOSIut3uMNySQY2r/DSRSwbEhUv+FjMT1Modo3BDltP80c8/
        LoYrWdbphlNfJwCw==
To:     isaku.yamahata@intel.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v3 12/59] KVM: x86/mmu: Zap only leaf SPTEs for
 deleted/moved memslot by default
In-Reply-To: <2d195882a4f834256c319aaf669ab933cbe6688a.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <2d195882a4f834256c319aaf669ab933cbe6688a.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 20:04:57 +0100
Message-ID: <87zgpsjbty.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:19, isaku yamahata wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Zap only leaf SPTEs when deleting/moving a memslot by default, and add a
> module param to allow reverting to the old behavior of zapping all SPTEs
> at all levels and memslots when any memslot is updated.

This changelog describes WHAT the change is doing, which can be seen in
the patch itself, but it gives zero justification neither for the change
nor for the existance of the module parameter.

Thanks,

        tglx

