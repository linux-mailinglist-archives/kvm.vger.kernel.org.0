Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1408539401
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 17:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345713AbiEaP2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 11:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345734AbiEaP2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 11:28:40 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F494B433;
        Tue, 31 May 2022 08:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=maqGjSWTVMLeUMm65hl8nuksG8k8/+OZs6Omo7vZSRo=; b=BjZ4i8hmVS/gzCU8gbP/4mpOe8
        ZW5BVm4JPq9XhgvpvcsnjY40Y2kzsB2/ebCgPHUeg5poVfygYS47YgunpwIPsi0w48IMZ2Tdt/Kv/
        8QzoUcIXHVWoOby1OsUNwj4cZgeuT/qH1WmKpD8GV9WBpQncPnvcAFGKvyXUObVCoX+0S4sTKPe/J
        QAB+k9O/3NZjtfHJahxYPvBdjM8OR5asZj06kkhbWfwBGKnQQZxZGAU4Ckrzs7b7c3n16HvEsrem+
        aTfrWhhg/VmeYfUtg2GDtum7VVaDtxm6tg1VSxUPRZulQXUVppD1hraUPXEZ+7b+zfb9GmXEQrWfF
        62WOOlsg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nw3mn-003URZ-8r; Tue, 31 May 2022 15:27:57 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 44BF93007A2;
        Tue, 31 May 2022 17:27:55 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1FD13209E5070; Tue, 31 May 2022 17:27:55 +0200 (CEST)
Date:   Tue, 31 May 2022 17:27:54 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jack Allister <jalliste@amazon.com>,
        Borislav Petkov <bp@alien8.de>, diapop@amazon.co.uk,
        "Anvin, H. Peter" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Ingo Molnar <mingo@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: ...\n
Message-ID: <YpYz+ltAHRsF5s0u@hirez.programming.kicks-ass.net>
References: <YpYaYK7a28DFT5Ne@hirez.programming.kicks-ass.net>
 <20220531140236.1435-1-jalliste@amazon.com>
 <YpYpxzt4rmG+LFy9@hirez.programming.kicks-ass.net>
 <CABgObfYYUNb_pEVA2xdUm_U39Wc1=AahJKDx2=9P+aK5=z202w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgObfYYUNb_pEVA2xdUm_U39Wc1=AahJKDx2=9P+aK5=z202w@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 31, 2022 at 04:52:56PM +0200, Paolo Bonzini wrote:
> On Tue, May 31, 2022 at 4:45 PM Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, May 31, 2022 at 02:02:36PM +0000, Jack Allister wrote:
> > > The reasoning behind this is that you may want to run a guest at a
> > > lower CPU frequency for the purposes of trying to match performance
> > > parity between a host of an older CPU type to a newer faster one.
> >
> > That's quite ludicrus. Also, then it should be the host enforcing the
> > cpufreq, not the guest.
> 
> It is a weird usecase indeed, but actually it *is* enforced by the
> host in Jack's patch.

Clearly I don't understand KVM much; I was thikning that since it was
mucking the with vmx code it was some guest interface.

If it is host control, then it's even more insane, since the host has
plenty existing interfaces for cpufreq control. No need to add more
crazy hacks like this.
