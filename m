Return-Path: <kvm+bounces-33719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A03B99F0968
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 11:27:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7DC8165928
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 10:27:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E1A1B87EA;
	Fri, 13 Dec 2024 10:27:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33C91AF0BA;
	Fri, 13 Dec 2024 10:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734085658; cv=none; b=mxQ8zSNP3lpYcUfAtF3ozTKj9kLofNokTZss0DC4Zfovp97KvQFNq7kkcuU4lklxmIR9GmsDPdPw9BmhHt2cDMcWgZnlT3DkYfh77flHrmRj+kPlN4cLrvpcxlUaVLeBAVy50cKrWPo3m3RzcOWVwdm0gyt3VR5NxhrzomYSSHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734085658; c=relaxed/simple;
	bh=rrFLr8CNUec5XTWiJRpluJNFyXGGpTR84FLKjriRXKk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ePc3rSZYzlcuQDSFwLpdA+qU8/sfJfPPEiNMpPv0T+jBDj1Rx+u4AUs/waVF46EH8VnD1cjPTkBtKBBYwV55Q92sFeNCBkyW+tIbOKLVW1DTK2pCSJAQqltkY0/EVWJCbsB+45g4loP9zm2jggcMppb7vmbGgUCYCnSTF4sHwdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4Y8ls307LNz9sSd;
	Fri, 13 Dec 2024 11:27:35 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w4LjWUMC-i0O; Fri, 13 Dec 2024 11:27:34 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4Y8ls26Grzz9sSH;
	Fri, 13 Dec 2024 11:27:34 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id C07B88B773;
	Fri, 13 Dec 2024 11:27:34 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id SmQbPCkQpRec; Fri, 13 Dec 2024 11:27:34 +0100 (CET)
Received: from [192.168.232.97] (unknown [192.168.232.97])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 679968B763;
	Fri, 13 Dec 2024 11:27:33 +0100 (CET)
Message-ID: <3a2fadc3-f594-492f-805a-148043436995@csgroup.eu>
Date: Fri, 13 Dec 2024 11:27:32 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 3/5] powerpc: kvm: drop 32-bit book3s
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
 <20241212125516.467123-4-arnd@kernel.org>
 <2809dcce-3405-430e-b43d-d75f35bdb7d5@csgroup.eu>
 <3380464f-5db4-487d-936f-1b5503905793@app.fastmail.com>
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <3380464f-5db4-487d-936f-1b5503905793@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 13/12/2024 à 11:04, Arnd Bergmann a écrit :
> diff --git a/arch/powerpc/kernel/head_32.h b/arch/powerpc/kernel/head_32.h
> index 9cba7dbf58dd..24e89dadc74d 100644
> --- a/arch/powerpc/kernel/head_32.h
> +++ b/arch/powerpc/kernel/head_32.h
> @@ -172,7 +172,6 @@ _ASM_NOKPROBE_SYMBOL(\name\()_virt)
>   #define	START_EXCEPTION(n, label)		\
>   	__HEAD;					\
>   	. = n;					\
> -	DO_KVM n;				\
>   label:
>   
>   #else

Then the complete macro should go away because both versions are now 
identical:

-#ifdef CONFIG_PPC_BOOK3S
-#define	START_EXCEPTION(n, label)		\
-	__HEAD;					\
-	. = n;					\
-label:
-
-#else
  #define	START_EXCEPTION(n, label)		\
  	__HEAD;					\
  	. = n;					\
  label:

-#endif



