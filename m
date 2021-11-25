Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB17945E15D
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 21:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350956AbhKYUNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 15:13:47 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54430 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356923AbhKYULp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 15:11:45 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637870912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ed4k/5AusQTF97PAK053dx1XOC9ZHscKNMEHYGgCSnY=;
        b=K0JQFqLzCS2k13w7p70QVE2gyZ4xn9IKAa6+rvOAUhYkeXONVXWKmo9wI11Ucwiuq3h6Qt
        l1nJyT/OY1FU+TPDra0prfJaKCwudLErrQNLesUh5wZtviqj4QKa1IvEk8nff/GzkAupbn
        uh+ExXgTj0+DXm+byDmy9hGJFQbP3qb6JWoxtbXIyM77ptDVk1IThMQ20r698m0ZXJGvx6
        ztewr3Sh3pyRu17E+i1IIwdZBkrreKvWSPj/0VCwg4kH03xOUW3Zwj1faCsVE5a9p160I5
        H8ZaQ6GT7So3/HjI9mCNeilKjkIdwF0f59OvqtpFTNztZHnjUT6sXUNExC1L3Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637870912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ed4k/5AusQTF97PAK053dx1XOC9ZHscKNMEHYGgCSnY=;
        b=P0Klh0uhWOThgQ/rUlB6nuh1qcAm3UJIr8FePwd68zcWJABBMBWl6bT7MtVgCYWEsmx+tb
        uoT6p/eumWihLkDQ==
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
Subject: Re: [RFC PATCH v3 45/59] KVM: VMX: Move setting of EPT MMU masks to
 common VT-x code
In-Reply-To: <4f4ab3f9f919f5fa3355163bc01917425adac7d2.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <4f4ab3f9f919f5fa3355163bc01917425adac7d2.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 21:08:31 +0100
Message-ID: <87pmqohubk.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>

Yet another void ...

