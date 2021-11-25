Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F8845E156
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 21:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356936AbhKYUMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 15:12:08 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54378 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242011AbhKYUKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 15:10:07 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637870814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J2CSJ3Wz4Kcy/OpvhfPockln9mBSNKAjWcSUm6y6bLQ=;
        b=B77QPhCfW8g2zyXnv5J3/9rQkS91xVvI97cGU/RngOEfdb1pK17XkTvpKDI0XkTXYNWGEC
        oraU0BV2QJZQtVwrKk8alAt+hqOue/phS+zloLUkLVMbipPVaVK2zJO5yw0mHWWxJ25KJ1
        Blzx1Vj9HRB50/DBlQMqACoD63Ugc7dTc+kAPt9TLABWotNno4djnh7UtbPTyImp7YcpY/
        n4V3jwfG2R3o5wE6pcNeK3Ie0Hjnyw+j0OGezz3QrDWYREdRmwHA+uS4nev3MYyH0CESze
        sx8cdOvSErZFuZwekW/MEG2PULfmnxFrn+3MoqQg45WeQLc+5yXF2kXqiZrBaw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637870814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J2CSJ3Wz4Kcy/OpvhfPockln9mBSNKAjWcSUm6y6bLQ=;
        b=GNCe/Y10MGHonXWSK9b4FSIHszuc6RZxExC2HMaNV4BDiKzwB9gtKx20t1N0YJbqRs61JB
        DW5KBjDAj1geZpBg==
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
Subject: Re: [RFC PATCH v3 40/59] KVM: VMX: Move NMI/exception handler to
 common helper
In-Reply-To: <a3113cf940d30e2853e2f7aca1c6c85238f8ed21.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <a3113cf940d30e2853e2f7aca1c6c85238f8ed21.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 21:06:53 +0100
Message-ID: <87v90ghuea.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>

Why?

