Return-Path: <kvm+bounces-33701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C2989F05EB
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 09:02:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17A94169D66
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 08:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DD2E19DF53;
	Fri, 13 Dec 2024 08:02:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF2C187355;
	Fri, 13 Dec 2024 08:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734076945; cv=none; b=hyhE4oo8R8hg/HNsaQH+KUTIvZCQWhxv860wNuSLYrhw/7TIcWoE/XES+a4PQXnUOiBRnvrrvpDY5IVKiLvj+nbzZc0gRSVvTGC130N+zZz2D024/dKe51syZf+eeok002/XitTcUQ1I/gKQdGnwIMARPzprlZSZWMeIJGx23Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734076945; c=relaxed/simple;
	bh=FYED/8DUnjBkN3i+Sn9aK7jeJYFlZLNiQnfSwlxCUTo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l/IKVeTaxVcMvWg2XtiBpA0flq3AVpRppQERwiHV82eqdHpmdn0VmVfQEpbyElLRwHjOx/ls0+4Rz1QYCmnVLxJ512kd4hluyqhhyLz4yr8lPLPa9vfU68QiqS+6Ck9+iQoyrG9C9hOLsyUBvF6mBfwe5Dpm6fOABYDzQJH/Uy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4Y8hdT5hV5z9str;
	Fri, 13 Dec 2024 09:02:21 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BkzwJyV56MEz; Fri, 13 Dec 2024 09:02:21 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4Y8hdT4bL5z9sST;
	Fri, 13 Dec 2024 09:02:21 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 87B638B773;
	Fri, 13 Dec 2024 09:02:21 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id XDvAIJXlZlMl; Fri, 13 Dec 2024 09:02:21 +0100 (CET)
Received: from [192.168.232.97] (unknown [192.168.232.97])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 2B4EE8B763;
	Fri, 13 Dec 2024 09:02:20 +0100 (CET)
Message-ID: <0b1ea054-22bb-4380-a1e4-8be988d8746d@csgroup.eu>
Date: Fri, 13 Dec 2024 09:02:19 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 3/5] powerpc: kvm: drop 32-bit book3s
To: Arnd Bergmann <arnd@kernel.org>, kvm@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Huacai Chen <chenhuacai@kernel.org>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Alexander Graf <graf@amazon.com>, Crystal Wood <crwood@redhat.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
References: <20241212125516.467123-1-arnd@kernel.org>
 <20241212125516.467123-4-arnd@kernel.org>
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <20241212125516.467123-4-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 12/12/2024 à 13:55, Arnd Bergmann a écrit :
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Support for KVM on 32-bit Book III-s implementations was added in 2010
> and supports PowerMac, CHRP, and embedded platforms using the Freescale G4
> (mpc74xx), e300 (mpc83xx) and e600 (mpc86xx) CPUs from 2003 to 2009.
> 
> Earlier 603/604/750 machines might work but would be even more limited
> by their available memory.
> 
> The only likely users of KVM on any of these were the final Apple
> PowerMac/PowerBook/iBook G4 models with 2GB of RAM that were at the high
> end 20 years ago but are just as obsolete as their x86-32 counterparts.
> The code has been orphaned since 2023.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   MAINTAINERS                               |   2 +-
>   arch/powerpc/include/asm/kvm_book3s.h     |  19 ----
>   arch/powerpc/include/asm/kvm_book3s_asm.h |  10 --

pmac32_defconfig: something is going wrong with headers:

   CC      arch/powerpc/kernel/asm-offsets.s
In file included from ./arch/powerpc/include/asm/book3s/64/mmu-hash.h:20,
                  from ./arch/powerpc/include/asm/kvm_book3s_64.h:14,
                  from ./arch/powerpc/include/asm/kvm_book3s.h:380,
                  from ./arch/powerpc/include/asm/kvm_ppc.h:22,
                  from ./arch/powerpc/include/asm/dbell.h:17,
                  from arch/powerpc/kernel/asm-offsets.c:36:
./arch/powerpc/include/asm/book3s/64/pgtable.h:17: warning: "_PAGE_EXEC" 
redefined
    17 | #define _PAGE_EXEC              0x00001 /* execute permission */
       |
In file included from ./arch/powerpc/include/asm/book3s/pgtable.h:8,
                  from ./arch/powerpc/include/asm/pgtable.h:18,
                  from ./include/linux/pgtable.h:6,
                  from ./arch/powerpc/include/asm/kup.h:43,
                  from ./arch/powerpc/include/asm/uaccess.h:8,
                  from ./include/linux/uaccess.h:12,
                  from ./include/linux/sched/task.h:13,
                  from ./include/linux/sched/signal.h:9,
                  from ./include/linux/rcuwait.h:6,
                  from ./include/linux/percpu-rwsem.h:7,
                  from ./include/linux/fs.h:33,
                  from ./include/linux/compat.h:17,
                  from arch/powerpc/kernel/asm-offsets.c:12:
./arch/powerpc/include/asm/book3s/32/pgtable.h:30: note: this is the 
location of the previous definition
    30 | #define _PAGE_EXEC      0x200   /* software: exec allowed */
       |



