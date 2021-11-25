Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5490245E0D8
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 20:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356437AbhKYTLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 14:11:43 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:53902 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236558AbhKYTJl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 14:09:41 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637867186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Pn57p54ZEZtDgVHnF58kqElnodorlAj6rpZoxOplks=;
        b=Mb1hRHG8JzypnC958m9ZGzTb99fBttgox0fvNm7enrxlj6uWwwdtf2S+J+ghFUhfcJDQb9
        YF7gxQx9HxmVrtnvWDcaFs+3HH8gKGoe4dLYwXW0x1gjsjm1V3G0RnxivhAvYOy/CDSui6
        qQA9ArQRyQw+Vao4PNiYixYD+fa2n9a+akbjKDELFVh+Rz5T8IVChOXpFsa+PUo9H881ds
        y60Wy+oBgg1GoF0Nhelyjlgs4C0so4mZ+jjTe0oXQLp+lUyB7zGzVzaH1aOEq5kKLEeC2p
        UPA0x3UXrUIrcOq6+99GM1FNPqCc8Gj7Qw960rRo8V7g+GYY8h+gFRDajihuSw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637867186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Pn57p54ZEZtDgVHnF58kqElnodorlAj6rpZoxOplks=;
        b=N5kB9vDczvzVbQPGFs5itet7ox7V5y6+Uh39WVbaLya7LT0OfGYON7H0XJQ+mY40mbWPvX
        SI5DI5VqdRlJwNBw==
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
Subject: Re: [RFC PATCH v3 13/59] KVM: Add max_vcpus field in common 'struct
 kvm'
In-Reply-To: <cb707c90542c9ad4768dae88c80fefcc15a264d6.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <cb707c90542c9ad4768dae88c80fefcc15a264d6.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 20:06:26 +0100
Message-ID: <87wnkwjbrh.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:19, isaku yamahata wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>

Why?
