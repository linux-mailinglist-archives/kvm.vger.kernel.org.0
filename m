Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E44C1D6255
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 17:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgEPPia (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 11:38:30 -0400
Received: from elvis.franken.de ([193.175.24.41]:55492 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727098AbgEPPia (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 11:38:30 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1jZytP-0004GR-02; Sat, 16 May 2020 17:38:27 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id BA823C04D3; Sat, 16 May 2020 17:37:26 +0200 (CEST)
Date:   Sat, 16 May 2020 17:37:26 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH V5 06/15] KVM: MIPS: Introduce and use cpu_guest_has_ldpte
Message-ID: <20200516153726.GC3334@alpha.franken.de>
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
 <1589359366-1669-7-git-send-email-chenhc@lemote.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1589359366-1669-7-git-send-email-chenhc@lemote.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 13, 2020 at 04:42:37PM +0800, Huacai Chen wrote:
> Loongson-3 has lddir/ldpte instructions and their related CP0 registers
> are the same as HTW. So we introduce a cpu_guest_has_ldpte flag and use
> it to indicate whether we need to save/restore HTW related CP0 registers
> (PWBase, PWSize, PWField and PWCtl).
> 
> Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>  arch/mips/include/asm/cpu-features.h |  3 +++
>  arch/mips/kernel/cpu-probe.c         |  1 +
>  arch/mips/kvm/vz.c                   | 26 +++++++++++++-------------
>  3 files changed, 17 insertions(+), 13 deletions(-)

Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
