Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E28845DF99
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 18:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349086AbhKYR0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 12:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbhKYRYk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 12:24:40 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093E4C0619F8;
        Thu, 25 Nov 2021 09:14:49 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637860486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LL/5ce9I075bREwdkAPDj5xcKSWxoEt5ZmGokCJm/Y8=;
        b=jk3EwCul194w55gondVINdtl0j2sATS0mMm/2Frp5sBjuixnkzMjZX7lEavMtIz91apRty
        48SeOy15dsDuMFOXr3XPqwXt7Akw2QD6kBrpOa5kh6iC/5l2dF5rmGBHVgz+OPq9MdSoVZ
        DIyWpFAsgQP8DCJXrs597Dt6BOArmdKPGTHT76REyeg6GdS1p3ZtKHdJc7TLsJ6mooSiq5
        fHfnf5NbtLFtSXULIhmV5E2cSiFDOjzydy6acEc964ik/3qv6dpdXg7rJn9beGu7KcKMAN
        U1xrUotpA2rm0NlKUxV0XNDjLJ5rzuCKvnqJDp8ao/1FTkVW63okDfYCEFSOgw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637860486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LL/5ce9I075bREwdkAPDj5xcKSWxoEt5ZmGokCJm/Y8=;
        b=n/TJMWJeKQbISYcq2MXsKC4q6WGiCYJFykjqE4/jnpHQpKXz4d2pfwdRuKU9GJZilNOBB8
        NoJModPs01o00aCA==
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
Subject: Re: [RFC PATCH v3 08/59] KVM: Export kvm_io_bus_read for use by TDX
 for PV MMIO
In-Reply-To: <7adb093f872ead3f69c03dcc26a15fb9d1c499f2.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <7adb093f872ead3f69c03dcc26a15fb9d1c499f2.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 18:14:45 +0100
Message-ID: <875ysgkvi2.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:19, isaku yamahata wrote:

What is PV MMIO? This has nothing to do with PV=, aka paravirt because
it's used in the tdx exit handler for emulation. Please stop confusing
concepts.

> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Later kvm_intel.ko will use it.

That sentence is useless, as are the other 'later patches' phrases all
over the place. At submission time it's obvious and once this is merged
it's not helpful at all.

What's even worse is that this happens right at the beginning of the
series and the actual use case is introduced 50 patches later. That's
not how exports are done. Exports are next to the use case and in the
best case they can be just part of the use case patch.

This is not how fine granular patching works. Just splitting out stupid
things into separate patches does not make a proper patch series. It
creates an illusion, that's it.

And if I look at the patch which makes actual use of that export then
it's just the proof. I'll come to that later.

Thanks,

        tglx

