Return-Path: <kvm+bounces-6990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8009B83BC1B
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 09:36:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3DD71C24B7C
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 08:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2FB91B958;
	Thu, 25 Jan 2024 08:36:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414AA12E4A;
	Thu, 25 Jan 2024 08:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706171786; cv=none; b=B40SPXY2rNUqRMC8QClxFtI6x/M7ci1yhVCUxq1d4uUlNOYTsb1DYfma+tXZSl7kSD/qlWNUPDRmNk+B+XGwLDhQHZRQ9NpYsFtUVGAH7HcyJEraBezRtPT9HNfYg99YsLbAB4F+qw5ON8A95bW1ieX6C7aeWn1GYbJadMoccCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706171786; c=relaxed/simple;
	bh=OBgQP1LWDaesd2nRxTRT92PCCumz7hyFXJpJ6nvMyMg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j24VFFBOXL7BPyBMAzRHWpYHY8d9ywk1nP4skjv1ZAmK9H2QJP2/1Ht6B+o8t/Kzr3RuFD3bEEZE/EbKR86Gb/wRz6wk4/p4WIzQFL3gVcKrFoJAD86UFHJyZq+n4aWakg6kCJLlIKO8dnIVQrPt1gnDQdtXlMTpakAfUsiLhqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 0b9114c47c944f3395e17bb8743a5543-20240125
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:70a3d77d-bc90-44e0-b09b-26ae8d961c29,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-5
X-CID-INFO: VERSION:1.1.35,REQID:70a3d77d-bc90-44e0-b09b-26ae8d961c29,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:5d391d7,CLOUDID:f443a58e-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:240124210134Y4FPAFV7,BulkQuantity:5,Recheck:0,SF:66|38|24|17|19|44|6
	4|102,TC:nil,Content:0,EDM:-3,IP:-2,URL:1,File:nil,Bulk:40,QS:nil,BEC:nil,
	COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_FSI,TF_CID_SPAM_ULS,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,
	TF_CID_SPAM_FSD
X-UUID: 0b9114c47c944f3395e17bb8743a5543-20240125
Received: from mail.kylinos.cn [(39.156.73.10)] by mailgw
	(envelope-from <chentao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 392365939; Thu, 25 Jan 2024 16:36:17 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 96B42E000EB9;
	Thu, 25 Jan 2024 16:36:17 +0800 (CST)
X-ns-mid: postfix-65B21D81-548321494
Received: from [172.20.15.234] (unknown [172.20.15.234])
	by mail.kylinos.cn (NSMail) with ESMTPA id 080AFE000EBA;
	Thu, 25 Jan 2024 16:36:16 +0800 (CST)
Message-ID: <fa62f595-6e83-4084-b6ae-b776f3cc504b@kylinos.cn>
Date: Thu, 25 Jan 2024 16:36:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: PPC: code cleanup for kvmppc_book3s_irqprio_deliver
Content-Language: en-US
To: Christophe Leroy <christophe.leroy@csgroup.eu>,
 "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
 "npiggin@gmail.com" <npiggin@gmail.com>,
 "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
 "naveen.n.rao@linux.ibm.com" <naveen.n.rao@linux.ibm.com>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240124093647.479176-1-chentao@kylinos.cn>
 <91bfb613-222b-41ea-a049-d4252b655176@csgroup.eu>
From: Kunwu Chan <chentao@kylinos.cn>
In-Reply-To: <91bfb613-222b-41ea-a049-d4252b655176@csgroup.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2024/1/24 21:01, Christophe Leroy wrote:
>=20
>=20
> Le 24/01/2024 =C3=A0 10:36, Kunwu Chan a =C3=A9crit=C2=A0:
>> This part was commented from commit 2f4cf5e42d13 ("Add book3s.c")
>> in about 14 years before.
>> If there are no plans to enable this part code in the future,
>> we can remove this dead code.
>>
>> Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
>> ---
>>    arch/powerpc/kvm/book3s.c | 3 ---
>>    1 file changed, 3 deletions(-)
>>
>> diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
>> index 8acec144120e..c2f50e04eec8 100644
>> --- a/arch/powerpc/kvm/book3s.c
>> +++ b/arch/powerpc/kvm/book3s.c
>> @@ -360,9 +360,6 @@ static int kvmppc_book3s_irqprio_deliver(struct kv=
m_vcpu *vcpu,
>>    		break;
>>    	}
>>   =20
>> -#if 0
>> -	printk(KERN_INFO "Deliver interrupt 0x%x? %x\n", vec, deliver);
>> -#endif
>=20
> Please also remove one of the two blank lines.
Thanks for your reply. I've send the v2 patch:
https://lore.kernel.org/all/20240125082637.532826-1-chentao@kylinos.cn/
https://lore.kernel.org/all/20240125083348.533883-1-chentao@kylinos.cn/
>>   =20
>>    	if (deliver)
>>    		kvmppc_inject_interrupt(vcpu, vec, 0);
--=20
Thanks,
   Kunwu


