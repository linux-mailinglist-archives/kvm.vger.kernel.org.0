Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64C722C1D8
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 11:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgGXJPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 05:15:15 -0400
Received: from elvis.franken.de ([193.175.24.41]:47029 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgGXJPO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 05:15:14 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1jytnL-0002By-01; Fri, 24 Jul 2020 11:15:11 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 523B2C0931; Fri, 24 Jul 2020 11:11:23 +0200 (CEST)
Date:   Fri, 24 Jul 2020 11:11:23 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     linux-mips@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Burton <paulburton@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] MIPS: Retire kvm paravirt
Message-ID: <20200724091123.GB14059@alpha.franken.de>
References: <20200710063047.154611-1-jiaxun.yang@flygoat.com>
 <20200710063047.154611-2-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710063047.154611-2-jiaxun.yang@flygoat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 10, 2020 at 02:30:16PM +0800, Jiaxun Yang wrote:
> paravirt machine was introduced for Cavium's partial virtualization
> technology, however, it's host side support and QEMU support never
> landed in upstream.
> 
> As Cavium was acquired by Marvel and they have no intention to maintain
> their MIPS product line, also paravirt is unlikely to be utilized by
> community users, it's time to retire it if nobody steps in to maintain
> it.
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>  arch/mips/Kbuild.platforms                |   1 -
>  arch/mips/Kconfig                         |  19 --
>  arch/mips/configs/mips_paravirt_defconfig |  98 ------
>  arch/mips/include/asm/Kbuild              |   1 +
>  arch/mips/include/asm/kvm_para.h          | 115 -------
>  arch/mips/include/uapi/asm/Kbuild         |   2 +
>  arch/mips/include/uapi/asm/kvm_para.h     |   5 -
>  arch/mips/paravirt/Kconfig                |   7 -
>  arch/mips/paravirt/Makefile               |  14 -
>  arch/mips/paravirt/Platform               |   7 -
>  arch/mips/paravirt/paravirt-irq.c         | 368 ----------------------
>  arch/mips/paravirt/paravirt-smp.c         | 145 ---------
>  arch/mips/paravirt/serial.c               |  39 ---
>  arch/mips/paravirt/setup.c                |  67 ----
>  arch/mips/pci/Makefile                    |   1 -
>  arch/mips/pci/pci-virtio-guest.c          | 131 --------
>  16 files changed, 3 insertions(+), 1017 deletions(-)
>  delete mode 100644 arch/mips/configs/mips_paravirt_defconfig
>  delete mode 100644 arch/mips/include/asm/kvm_para.h
>  delete mode 100644 arch/mips/include/uapi/asm/kvm_para.h
>  delete mode 100644 arch/mips/paravirt/Kconfig
>  delete mode 100644 arch/mips/paravirt/Makefile
>  delete mode 100644 arch/mips/paravirt/Platform
>  delete mode 100644 arch/mips/paravirt/paravirt-irq.c
>  delete mode 100644 arch/mips/paravirt/paravirt-smp.c
>  delete mode 100644 arch/mips/paravirt/serial.c
>  delete mode 100644 arch/mips/paravirt/setup.c
>  delete mode 100644 arch/mips/pci/pci-virtio-guest.c

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
