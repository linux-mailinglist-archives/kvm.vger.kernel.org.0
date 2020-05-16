Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4438E1D6258
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 17:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgEPPib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 11:38:31 -0400
Received: from elvis.franken.de ([193.175.24.41]:55489 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbgEPPia (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 11:38:30 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1jZytP-0004GR-00; Sat, 16 May 2020 17:38:27 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id CCA48C04D2; Sat, 16 May 2020 17:35:47 +0200 (CEST)
Date:   Sat, 16 May 2020 17:35:47 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH V5 14/15] KVM: MIPS: Enable KVM support for Loongson-3
Message-ID: <20200516153547.GA3334@alpha.franken.de>
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
 <1589359366-1669-15-git-send-email-chenhc@lemote.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1589359366-1669-15-git-send-email-chenhc@lemote.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 13, 2020 at 04:42:45PM +0800, Huacai Chen wrote:
> This patch enable KVM support for Loongson-3 by selecting HAVE_KVM, but
> only enable KVM/VZ on Loongson-3A R4+ (because VZ of early processors
> are incomplete). Besides, Loongson-3 support SMP guests, so we clear the
> linked load bit of LLAddr in kvm_vz_vcpu_load() if the guest has more
> than one VCPUs.
> 
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>  arch/mips/Kconfig            | 1 +
>  arch/mips/kernel/cpu-probe.c | 1 +
>  arch/mips/kvm/vz.c           | 2 +-
>  3 files changed, 3 insertions(+), 1 deletion(-)

Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
