Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B973716B5
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 16:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhECOhJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 10:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbhECOhJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 10:37:09 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADDAC06174A;
        Mon,  3 May 2021 07:36:16 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620052574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ksjqkr87qwqum8F3BvqedLTRERvq7CmxRUOdBagDy58=;
        b=O6scsyAGwZbkodi/6wVZFZKvhCQgbaGkeFho8dFckdUivfv0nJfzPXyOOANU9dR/heZglO
        nI8M0r4X8PSMJ/t17iKB/YewzE83DYBp7srprJl5/EaIDZf47lIpkF+moK4N39xLoK3dSv
        dNvfjanNSfb5I3xpG3U7018z90/iuAh02OZdgfVmOrKNBo5q0ae6D8BtaWV9AsR286Off+
        S8HJvMwawhVBeAVLGH03u0f9I2vStMyh8LXBMZlTiaoBJt9owcBptDruO54M9gnDQzO3MG
        jnAybgLB8LcWnJzgUDVGwxYQuVa94xtjlkkUM4f9GLzxGH5vsXBZVj6chjXzHw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620052574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ksjqkr87qwqum8F3BvqedLTRERvq7CmxRUOdBagDy58=;
        b=gEjZKoYkD5PajlN2vwswOTotAiy1RxtTXUEzKqeqOxuvVKYRBaIjU3Fjo04+I7RdmknxNK
        AlWUxCbDvHFF8HDg==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 0/4] x86: Don't invoke asm_exc_nmi() on the kernel stack
In-Reply-To: <228d8b10-84cb-4dd2-8810-3c94bc3ae07b@redhat.com>
References: <20210426230949.3561-1-jiangshanlai@gmail.com> <228d8b10-84cb-4dd2-8810-3c94bc3ae07b@redhat.com>
Date:   Mon, 03 May 2021 16:36:13 +0200
Message-ID: <87zgxbdgv6.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30 2021 at 09:14, Paolo Bonzini wrote:
> On 27/04/21 01:09, Lai Jiangshan wrote:
>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks Paolo. I'm working through it now...
