Return-Path: <kvm+bounces-59392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B064BB2AE1
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 09:20:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA9B819C4848
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 07:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 572052BCF6A;
	Thu,  2 Oct 2025 07:20:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BADA933F6
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 07:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759389638; cv=none; b=b0aAvU5yGRE+2XbZJ2cUM6eZiLX4mDH+KGiA63KPgD7KPXxYVkJj7tLofTNsnwXpOjxGTDB2OCizXW+TmqRGTOyYRSslQNKaqlZW+IE1mCA6PVyvOQ9j6rY1L46HkQs/MSK26XA34ffuy2fOG9agQIG397KISOHSKiIMBjrTKMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759389638; c=relaxed/simple;
	bh=Iux0nIVTc80HUdp+Y8jhGnhylI5WJ3yGKEl4c7YxDes=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HjT9lwHcDokqSyTU2xzYmWdGjBEcCARt8TrESebNeaVlMMr3BZfUNM/fvOxnqY+41TQd6BimzRB6S/TIQpqaCJDq8OpGnvSsrOs90Wz9Wq9LhPjBqR2kGed1A2M1A8lh8Zgtr/A8DdFHehHKjIvv+1sc0jOQfxXFrTUc0PYKCXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4ccjCS471cz9sS7;
	Thu,  2 Oct 2025 08:52:20 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gBandp4y6DE4; Thu,  2 Oct 2025 08:52:20 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4ccjCS2t3Mz9sRy;
	Thu,  2 Oct 2025 08:52:20 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 507EA8B796;
	Thu,  2 Oct 2025 08:52:20 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id GrYjV0F4DxGN; Thu,  2 Oct 2025 08:52:20 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id DB90B8B774;
	Thu,  2 Oct 2025 08:52:19 +0200 (CEST)
Message-ID: <1b6074f6-1d23-48bf-98b6-beb57bd81886@csgroup.eu>
Date: Thu, 2 Oct 2025 08:52:18 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: KVM-PR no longer works when compiled with new GCC compilers
To: Christian Zigotzky <chzigotzky@xenosoft.de>,
 linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, kvm@vger.kernel.org,
 "debian-powerpc@lists.debian.org" <debian-powerpc@lists.debian.org>
Cc: "R.T.Dickinson" <rtd2@xtra.co.nz>, hypexed@yahoo.com.au,
 mad skateman <madskateman@gmail.com>
References: <cfd779d6-9440-46b2-9ed5-752f1ae6b5d1@xenosoft.de>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <cfd779d6-9440-46b2-9ed5-752f1ae6b5d1@xenosoft.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 02/10/2025 à 08:37, Christian Zigotzky a écrit :
> Hello,
> 
> KVM-PR (-enable-kvm) doesn't work anymore on our PA Semi Nemo boards [1] 
> if we compiled it with new GCC compilers.
> The VM can't boot. There aren't any messages on the serial console of QEMU.
> 
> It boots without KVM-PR.
> 
> Kernel config with new GCC compiler [2]:
> 
> - CONFIG_CC_VERSION_TEXT="powerpc64-suse-linux-gcc (SUSE Linux) 11.5.0"
> - CONFIG_TARGET_CPU="power4"
> - CONFIG_TUNE_CPU="-mtune=power10"
> 
> It works if I compile it with an old GCC compiler [3]:
> 
> - CONFIG_CC_VERSION_TEXT="powerpc-linux-gnu-gcc (Ubuntu 
> 9.4.0-1ubuntu1~20.04.1) 9.4.0"
> - CONFIG_TARGET_CPU="power4"
> - CONFIG_TUNE_CPU="-mtune=power9"
> 
> Mtune changes to power9 automatically if I compiled it with an old GCC 
> compiler. If I compile it with a new GCC compiler again it changes 
> automatically to mtune=power10.
> 
> Is mtune the reason of the KVM-PR issue? I think the issue is the new 
> GCC. [4]
> 
> Could you please check whether KVM-PR is compatible with new versions of 
> GCC compilers?

On your side, can you try with the following hack to test new GCC + 
CONFIG_TUNE_CPU="-mtune=power9"

diff --git a/arch/powerpc/platforms/Kconfig.cputype 
b/arch/powerpc/platforms/Kconfig.cputype
index 7b527d18aa5e..b8480cdb3a9a 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -264,7 +264,6 @@ config TARGET_CPU
  config TUNE_CPU
  	string
  	depends on POWERPC64_CPU
-	default "-mtune=power10" if $(cc-option,-mtune=power10)
  	default "-mtune=power9"  if $(cc-option,-mtune=power9)
  	default "-mtune=power8"  if $(cc-option,-mtune=power8)



> 
> Thanks in advance,
> 
> Christian
> 
> 
> 
> [1] https://eur01.safelinks.protection.outlook.com/? 
> url=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FAmigaOne_X1000&data=05%7C02%7Cchristophe.leroy2%40cs-soprasteria.com%7C0ca7898bcfed40a2839108de017ea0b4%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C638949840566572384%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=9U0DLwRhoWagfDe4bTRCdHZpf52tvZbXAMGE8jHibyU%3D&reserved=0
> 
> [2] https://eur01.safelinks.protection.outlook.com/? 
> url=https%3A%2F%2Fgithub.com%2Fchzigotzky%2Fkernels%2Fblob%2F45186997e6f347fd092f9ab629d62d6041426227%2Fconfigs%2Fx1000_defconfig&data=05%7C02%7Cchristophe.leroy2%40cs-soprasteria.com%7C0ca7898bcfed40a2839108de017ea0b4%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C638949840566592849%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=KAcTs9%2BiNnjhKkvlW6JHsiRts0uRBp0Oza56rVZRxvs%3D&reserved=0
> 
> [3] https://eur01.safelinks.protection.outlook.com/? 
> url=https%3A%2F%2Fgithub.com%2Fchzigotzky%2Fkernels%2Fblob%2Fbc7a3e27b3fcdee52a8135435f02cf807a43872a%2Fconfigs%2Fx1000_defconfig&data=05%7C02%7Cchristophe.leroy2%40cs-soprasteria.com%7C0ca7898bcfed40a2839108de017ea0b4%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C638949840566604830%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=FTh46dqFpLZyNrnhVgjHgUrlG689ryfymogE9oAVhE4%3D&reserved=0
> 
> [4] KVM-PR no longer works on an X1000 if the kernel has been compiled 
> with a new GCC: https://eur01.safelinks.protection.outlook.com/? 
> url=https%3A%2F%2Fforum.hyperion- 
> entertainment.com%2Fviewtopic.php%3Fp%3D57146%23p57146&data=05%7C02%7Cchristophe.leroy2%40cs-soprasteria.com%7C0ca7898bcfed40a2839108de017ea0b4%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C638949840566617191%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=ih%2FgNl3HKEavfrn%2ByHM9J3ZpZvztC95aWUhC%2Fy1YjiQ%3D&reserved=0
> 


