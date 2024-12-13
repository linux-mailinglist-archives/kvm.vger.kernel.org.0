Return-Path: <kvm+bounces-33689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F8389F04C5
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 07:25:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48CFB16A2D2
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 06:25:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E75318C91F;
	Fri, 13 Dec 2024 06:25:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FE713DDAA;
	Fri, 13 Dec 2024 06:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734071108; cv=none; b=vFGQ/6Wh5YJYa9cXGEbILw/b+fO8nED3NXt+YFeQWmRQ3tZ6ZTXk0m09OyJ1D4Mg93VmvPzYYPsLNzx1BEeEpAAM/Y4dHdXHz2zyn/+IGro6NuxvUuNsUyTHlN7Ld+mjoSpB2ZFVpisZ3GQ4FToylSOh1R1nEfS0exfwX6nLwmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734071108; c=relaxed/simple;
	bh=h3KvM8+5gu1HSmwvWLHSNsLeIvLTcGNr7SBLsi/2IcI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kNMEK9TBZkZ+pouo3sadgXuJsFpujfZR1jtnWeN/LdFl1WdFP9+DxQplDAS3hhS0IgzAI0HP/uvnDKukF9OAYmasz8W4fpTf4OyQwKdgrz9Q/PpPPnlF1Obu5n7Vwcwh1/Sc8AEB2Z6HwSsLg/ctXr1ygEL/ZBW9BZSlSRHLUU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4Y8fTB6fpSz9str;
	Fri, 13 Dec 2024 07:25:02 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JDOGWM-FGhTz; Fri, 13 Dec 2024 07:25:02 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4Y8fTB5dPqz9stm;
	Fri, 13 Dec 2024 07:25:02 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id ACB7C8B773;
	Fri, 13 Dec 2024 07:25:02 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id FXHjhDgv36wk; Fri, 13 Dec 2024 07:25:02 +0100 (CET)
Received: from [192.168.232.97] (unknown [192.168.232.97])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 4A60F8B763;
	Fri, 13 Dec 2024 07:25:01 +0100 (CET)
Message-ID: <1f1beb34-65cc-4038-a8b2-de8af3e0703e@csgroup.eu>
Date: Fri, 13 Dec 2024 07:25:01 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 2/5] powerpc: kvm: drop 32-bit booke
To: Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>,
 kvm@vger.kernel.org
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
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
 <20241212125516.467123-3-arnd@kernel.org>
 <3589ad69-13df-40f1-88c2-55d39790bbac@csgroup.eu>
 <1633f30e-d885-4f31-a14d-11881e16deb9@app.fastmail.com>
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <1633f30e-d885-4f31-a14d-11881e16deb9@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 12/12/2024 à 22:08, Arnd Bergmann a écrit :
> On Thu, Dec 12, 2024, at 19:35, Christophe Leroy wrote:
>> Le 12/12/2024 à 13:55, Arnd Bergmann a écrit :
>>> From: Arnd Bergmann <arnd@arndb.de>
> 
>>>
>>> Support for 64-bit hosts remains unchanged, for both 32-bit and
>>> 64-bit guests.
>>>
> 
>>>    arch/powerpc/include/asm/kvm_book3s_32.h    |  36 --
>>>    arch/powerpc/include/asm/kvm_booke.h        |   4 -
>>>    arch/powerpc/include/asm/kvm_booke_hv_asm.h |   2 -
>>>    arch/powerpc/kvm/Kconfig                    |  22 +-
>>>    arch/powerpc/kvm/Makefile                   |  15 -
>>>    arch/powerpc/kvm/book3s_32_mmu_host.c       | 396 --------------
>>>    arch/powerpc/kvm/booke.c                    | 268 ----------
>>>    arch/powerpc/kvm/booke.h                    |   8 -
>>>    arch/powerpc/kvm/booke_emulate.c            |  44 --
>>>    arch/powerpc/kvm/booke_interrupts.S         | 535 -------------------
>>>    arch/powerpc/kvm/bookehv_interrupts.S       | 102 ----
>>>    arch/powerpc/kvm/e500.c                     | 553 --------------------
>>>    arch/powerpc/kvm/e500.h                     |  40 --
>>>    arch/powerpc/kvm/e500_emulate.c             | 100 ----
>>>    arch/powerpc/kvm/e500_mmu_host.c            |  54 --
>>>    arch/powerpc/kvm/e500mc.c                   |   5 +-
>>>    arch/powerpc/kvm/trace_booke.h              |  14 -
>>>    17 files changed, 4 insertions(+), 2194 deletions(-)
>>>    delete mode 100644 arch/powerpc/include/asm/kvm_book3s_32.h
>>>    delete mode 100644 arch/powerpc/kvm/book3s_32_mmu_host.c
>>>    delete mode 100644 arch/powerpc/kvm/booke_interrupts.S
>>>    delete mode 100644 arch/powerpc/kvm/e500.c
>>
>> Left over ?
>>
>> arch/powerpc/kernel/head_booke.h:#include <asm/kvm_asm.h>
>> arch/powerpc/kernel/head_booke.h:#include <asm/kvm_booke_hv_asm.h>
>> arch/powerpc/kernel/head_booke.h:       b
>> kvmppc_handler_\intno\()_\srr1
> 
> As far as I can tell, these are still needed for e5500/e6500,
> but you know more about the platform than I do.

$ git grep kvmppc_handler_ arch/powerpc/
arch/powerpc/kvm/bookehv_interrupts.S: 
_GLOBAL(kvmppc_handler_\intno\()_\srr1)

In your patch you remove the include of head_booke.h from there:

diff --git a/arch/powerpc/kvm/bookehv_interrupts.S 
b/arch/powerpc/kvm/bookehv_interrupts.S
index 8b4a402217ba..c75350fc449e 100644
--- a/arch/powerpc/kvm/bookehv_interrupts.S
+++ b/arch/powerpc/kvm/bookehv_interrupts.S
@@ -18,13 +18,9 @@
  #include <asm/asm-offsets.h>
  #include <asm/bitsperlong.h>

-#ifdef CONFIG_64BIT
  #include <asm/exception-64e.h>
  #include <asm/hw_irq.h>
  #include <asm/irqflags.h>
-#else
-#include "../kernel/head_booke.h" /* for THREAD_NORMSAVE() */
-#endif

  #define LONGBYTES		(BITS_PER_LONG / 8)

$ git grep head_booke.h
arch/powerpc/kernel/asm-offsets.c:#include "head_booke.h"
arch/powerpc/kernel/head_44x.S:#include "head_booke.h"
arch/powerpc/kernel/head_85xx.S:#include "head_booke.h"

$ git grep head_85xx.o
arch/powerpc/kernel/Makefile:obj-$(CONFIG_PPC_85xx)             += 
head_85xx.o

CONFIG_PPC_85xx depends on CONFIG_PPC32.

CONFIG_E5500_CPU and CONFIG_E6500_CPU both depend on CONFIG_PPC64.

So yes it is used on e5500/e6500 but only when they run a 32 bits kernel 
built with CONFIG_PPC_85xx. Isn't it what you want to get rid of with 
this patch ?

Am I missing something ?

Christophe

