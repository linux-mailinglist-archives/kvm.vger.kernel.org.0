Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FD11D6254
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 17:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgEPPia (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 11:38:30 -0400
Received: from elvis.franken.de ([193.175.24.41]:55490 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbgEPPia (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 11:38:30 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1jZytP-0004GR-01; Sat, 16 May 2020 17:38:27 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 3D72FC04D3; Sat, 16 May 2020 17:36:44 +0200 (CEST)
Date:   Sat, 16 May 2020 17:36:44 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH V5 12/15] KVM: MIPS: Add CONFIG6 and DIAG registers
 emulation
Message-ID: <20200516153644.GB3334@alpha.franken.de>
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
 <1589359366-1669-13-git-send-email-chenhc@lemote.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1589359366-1669-13-git-send-email-chenhc@lemote.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 13, 2020 at 04:42:43PM +0800, Huacai Chen wrote:
> Loongson-3 has CONFIG6 and DIAG registers which need to be emulated.
> CONFIG6 is mostly used to enable/disable FTLB and SFB, while DIAG is
> mostly used to flush BTB, ITLB, DTLB, VTLB and FTLB.
> 
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>  arch/mips/include/asm/kvm_host.h |  7 +++++
>  arch/mips/include/asm/mipsregs.h |  7 +++++
>  arch/mips/kvm/tlb.c              | 41 ++++++++++++++++++++++++++
>  arch/mips/kvm/vz.c               | 62 +++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 116 insertions(+), 1 deletion(-)

Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
