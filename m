Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B01045E18F
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 21:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357089AbhKYUba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 15:31:30 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54580 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243392AbhKYU30 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 15:29:26 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637871973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XqarTOl+OqpgFlt/ry3kQWkFscoc5NOUCwqBahBauN4=;
        b=oQTei6MwpnkyzcZM9CtF9jipXDxnZ1HWnZ1HLgw+lweFDJAHto3XgMA3yOVRdgrjw6MmrL
        fheAhXQpstKjuwqTs559gguRZj3XT6dhIjq6zwIRZzGn6svm69DzQMS5cM4XY3QWdq5boc
        +WeSS5SNLubeWTMfAo0NM8RUxUzCmSzI2agsU1XSgKzJ/vuRA5qR4kwUjZjaxvTMAim7XI
        YC/id6jhJoSNvNiKJBnxtmW+ivy2FKQKrcYtF2prxftpa2mJOd4wRiIEcglFoOYFrEn9C2
        MonNEnE1nfDQVf0rnHe4DBw4ghR/O0EZPYplY89GwqWT2yP/9qf27/Hnqx0NVg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637871973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XqarTOl+OqpgFlt/ry3kQWkFscoc5NOUCwqBahBauN4=;
        b=TiX5tjLh1lqr51EME2/1Qaoa21zwM1rH6Nr02hbIKuVGJcYI5p70ldho/5M2TXCwRuE+df
        502vRyu5N9llcPBw==
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
Subject: Re: [RFC PATCH v3 52/59] KVM: VMX: Move .get_interrupt_shadow()
 implementation to common VMX code
In-Reply-To: <fc5fec456f87e8f815813e65f85055fe38e44d10.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <fc5fec456f87e8f815813e65f85055fe38e44d10.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 21:26:13 +0100
Message-ID: <87bl28hti2.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>

Moar missing explanation of the why.

