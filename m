Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104D645E182
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 21:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357051AbhKYUYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 15:24:41 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54510 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242493AbhKYUWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 15:22:40 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637871568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2A2mtNS0DKb6dqqC8o4MSgl7FirJUel4InUDXfuBsIU=;
        b=WFJAiSeqjB5Ake1IU06h2j5Tz+P3t5+Tb+xdEXSAOOby2u2MJW0HNDB/rnbS/+u1lCMikt
        gj+RdlOIaraI4ywlzXKL+84KrL6Th/FCWIJqOVcKrdeG0Zvr4mPw9XPaIPmtgXg7NvBJv6
        bryFPV6247oMJ6M7j05cVpv9QH0gMrIGM6/zuYcwaxtr2CYOUrj1cV6Pu6ERAgaddBsWk3
        LPZQxfoFyL2BW/om5cpQkxRzzARCN8ME/AHd30a+nI9gW3V7EoxqT736g/29kD+UmtjIAa
        HrvMI+5d7hfZD8ZzuyoI3p/Fbges7W8QlR44/0gyOJ+N9AnlkXFsliRg6ACYjw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637871568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2A2mtNS0DKb6dqqC8o4MSgl7FirJUel4InUDXfuBsIU=;
        b=numU1eF43/7g4E/13NfyMmKRCWlWbIgLyDATF3KhsASL6HGQuWcQn0p4hOL8R8gD4sSoIs
        DKt3LxoQdEF11KBQ==
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [RFC PATCH v3 47/59] KVM: TDX: Define TDCALL exit reason
In-Reply-To: <eb5dd2a1d02c7afe320ab3beb6390da43a9bf0bc.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <eb5dd2a1d02c7afe320ab3beb6390da43a9bf0bc.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 21:19:27 +0100
Message-ID: <87k0gwhttc.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Define the TDCALL exit reason, which is carved out from the VMX exit
> reason namespace as the TDCALL exit from TDX guest to TDX-SEAM is really
> just a VM-Exit.

How is this carved out? What's the value of this word salad?

It's simply a new exit reason. Not more, not less. So what?

> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

I'm pretty sure that it does not take two engineers to add a new exit
reason define, but it takes at least two engineers to come up with a
convoluted explanation for it.

Thanks,

        tglx
