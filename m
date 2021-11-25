Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339FC45E189
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 21:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357003AbhKYUan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 15:30:43 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54562 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243229AbhKYU2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 15:28:41 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637871929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ACrtMgpepSAq8VWqDAegilqf67iQGYiLFW/hlfps1pI=;
        b=mOfTM+Q4Y5of4UvJ1c2IXOsXhYVnhdDK7TNCXC45vaCYpL8UNR/b0UkbJ7Mswmn3O26ZPH
        ygq4sK9A8dyK5gMvP1LW7JgARdrSPtUkOk/b1U7NngmDztYKb4ChiYBdXtuO5j3h6kj/Tr
        ltXHawLVk9yihl3GgX+UxTB321Qz8WTQlsk2/cWZkAR+d+kycDZHvRck0HW+3h96i/oOEg
        QLJLU/NlUbUP7Z/Ivw72ZRxDJCL1JeKqKra4t5/TH6euFPlHGQJbdbIqGZvlL0WfbQVTPu
        4AwLwdONdXr5tfhqpkmIypJPQQLnG0/9WfCD7bN9I3TgrG9WDrOGdzkzddE22Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637871929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ACrtMgpepSAq8VWqDAegilqf67iQGYiLFW/hlfps1pI=;
        b=wZBIGhzFyv6XWRQX9ayXsoD/S5GFBOhHxlvGnrdf6u81XXWHOuVN42tQ5mOo1qwL3s1LSr
        7KbIyUnhRI6y5zBw==
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
Subject: Re: [RFC PATCH v3 51/59] KVM: VMX: MOVE GDT and IDT accessors to
 common code
In-Reply-To: <a83e5fb3ef9fbffd3968895bab6f42bf780dbacd.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <a83e5fb3ef9fbffd3968895bab6f42bf780dbacd.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 21:25:28 +0100
Message-ID: <87ee74htjb.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>

Again: Why?

