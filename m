Return-Path: <kvm+bounces-5264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77A2981EB3E
	for <lists+kvm@lfdr.de>; Wed, 27 Dec 2023 02:15:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 191A4283450
	for <lists+kvm@lfdr.de>; Wed, 27 Dec 2023 01:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3F651FD9;
	Wed, 27 Dec 2023 01:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vOlLyGPs"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14641A40;
	Wed, 27 Dec 2023 01:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=dVx/E9hxRr1pgfNn2HtlNdFpTW42eEbMQ5BSsWrEMeU=; b=vOlLyGPswNz/ukFMMvQff5QuD3
	RqKR/e/ZoWohom5oc3LQGkA1lO9aj1/oQbDmAJ44IwjAOAowiLBugqHkT+lowVwwGxjNdAkPwvurB
	1aIi3VZ5/A0QF5GRYKisLexcSqECl9f3OqftrAHrHmHvpI5ZO7ManoHTFZPB+Re/hMMoWEYnBWEFZ
	pabdTzcmJnAgIScV89fFZEdVPAsUlo4NN0+2cs+NFZ7NeSYrj0pJZO3ESP+xCWXDsai/IrYpzoouQ
	lna+RxjoQIa1fXQAmfPssdTy/D0wYnD6GXMye/wuhUKssIWrmCNcZiVN6dkDKmu+5SnzbaLo1Hmph
	E5TP7w1w==;
Received: from [50.53.46.231] (helo=[192.168.254.15])
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rIIW3-00Dl1h-0A;
	Wed, 27 Dec 2023 01:15:23 +0000
Message-ID: <b42e66b0-58a1-4408-a3f6-bbbf5254e472@infradead.org>
Date: Tue, 26 Dec 2023 17:15:22 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] LoongArch: KVM: add a return kvm_own_lasx() stub
Content-Language: en-US
To: Huacai Chen <chenhuacai@kernel.org>
Cc: linux-kernel@vger.kernel.org, Bibo Mao <maobibo@loongson.cn>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Huacai Chen
 <chenhuacai@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 Stephen Rothwell <sfr@canb.auug.org.au>
References: <20231227010742.21539-1-rdunlap@infradead.org>
 <CAAhV-H4JVEa9hhD0WrDC0YA0Q55T3-SKQCHyxNm=KR3Tb_oeQA@mail.gmail.com>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <CAAhV-H4JVEa9hhD0WrDC0YA0Q55T3-SKQCHyxNm=KR3Tb_oeQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 12/26/23 17:11, Huacai Chen wrote:
> Hi, Randy,
> 
> Could you please fix kvm_own_lsx() together?
> 

Sure will. Thanks.

> Huacai
> 
> On Wed, Dec 27, 2023 at 9:07 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>>
>> The stub for kvm_own_lasx() when CONFIG_CPU_HAS_LASX is not defined
>> should have a return value since it returns an int, so add
>> "return -EINVAL;" to the stub. Fixes the build error:
>>
>> In file included from ../arch/loongarch/include/asm/kvm_csr.h:12,
>>                  from ../arch/loongarch/kvm/interrupt.c:8:
>> ../arch/loongarch/include/asm/kvm_vcpu.h: In function 'kvm_own_lasx':
>> ../arch/loongarch/include/asm/kvm_vcpu.h:73:39: error: no return statement in function returning non-void [-Werror=return-type]
>>    73 | static inline int kvm_own_lasx(struct kvm_vcpu *vcpu) { }
>>
>> Fixes: 118e10cd893d ("LoongArch: KVM: Add LASX (256bit SIMD) support")
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Bibo Mao <maobibo@loongson.cn>
>> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
>> Cc: Huacai Chen <chenhuacai@loongson.cn>
>> Cc: WANG Xuerui <kernel@xen0n.name>
>> Cc: kvm@vger.kernel.org
>> Cc: loongarch@lists.linux.dev
>> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
>> ---


-- 
#Randy

