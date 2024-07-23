Return-Path: <kvm+bounces-22075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BF6A9397F2
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 03:31:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27475282D48
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 01:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 997E4136E16;
	Tue, 23 Jul 2024 01:31:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EAF42F5E;
	Tue, 23 Jul 2024 01:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721698262; cv=none; b=N5zMKEt60/ELUFJGRQNiLpT0qtgZZ5DgSmsjpAE9+42VmLeKWA74SL20UJ0OAzWvY2CbFKhB0NJADi7kVSseN153hTinusPeY+xcFE491xCTTmhnJAojE0wwHp+MxfHW0Z+oM2sf965eM9dO9csyNTMDWer4JfJFChnCmTt6WOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721698262; c=relaxed/simple;
	bh=yx9dj07JrC+MGOx9cNg4DMiac7FXZSRAGt8vhu4FiAI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=k0Im29Szf2sfOFA4RtKNBZfetE0MfO37A1pYGpwqffGDViwZPu/vlIVOnWYNvHK4ZMASJOh6JQyzosWp1ROMecIS1Xc723zTT5d/5PFnJUPHyYIEaweTYkPV9XGLqueiEoNVRkZYBIYf7LKEXalk6se78CCE/EpVy61Gi+l6jJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxZcXIB59mwwtVAA--.46910S3;
	Tue, 23 Jul 2024 09:30:50 +0800 (CST)
Subject: Re: [PATCH] KVM: Loongarch: remove unnecessary definition of
 KVM_PRIVATE_MEM_SLOTS
To: WangYuli <wangyuli@uniontech.com>, zhaotianrui@loongson.cn,
 chenhuacai@kernel.org, kernel@xen0n.name
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 chao.p.peng@linux.intel.com, Wentao Guan <guanwentao@uniontech.com>
References: <09A6BAA84F3EF573+20240722102624.293359-1-wangyuli@uniontech.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <3bf88ffb-c57b-a881-5a7a-78567e048ae2@loongson.cn>
Date: Tue, 23 Jul 2024 09:30:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <09A6BAA84F3EF573+20240722102624.293359-1-wangyuli@uniontech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxZcXIB59mwwtVAA--.46910S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJF18Aw1DWFW8GF1fZF4UCFg_yoW8Jw4UpF
	Z3ZFyvkF4kKr10y34vgFyj9347G395Cr12gasxWrW7CFsIva4kJr4v9r1DXF1kJa18XF40
	9FsI9r1FgayDX37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9K14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxV
	WxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
	Yx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY02Avz4vE-syl42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
	v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/



On 2024/7/22 下午6:26, WangYuli wrote:
> "KVM_PRIVATE_MEM_SLOTS" is renamed as "KVM_INTERNAL_MEM_SLOTS".
> 
> KVM_PRIVATE_MEM_SLOTS defaults to zero, so it is not necessary to
> define it in Loongarch's asm/kvm_host.h.
> 
> Link: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=bdd1c37a315bc50ab14066c4852bc8dcf070451e
> Link: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=b075450868dbc0950f0942617f222eeb989cad10
> Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
> Signed-off-by: WangYuli <wangyuli@uniontech.com>
> ---
>   arch/loongarch/include/asm/kvm_host.h | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
> index fe38f98eeff8..ce3d36a890aa 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -26,8 +26,6 @@
>   
>   #define KVM_MAX_VCPUS			256
>   #define KVM_MAX_CPUCFG_REGS		21
> -/* memory slots that does not exposed to userspace */
> -#define KVM_PRIVATE_MEM_SLOTS		0
>   
>   #define KVM_HALT_POLL_NS_DEFAULT	500000
>   #define KVM_REQ_TLB_FLUSH_GPA		KVM_ARCH_REQ(0)
> 
Reviewed-by: Bibo Mao <maobibo@loongson.cn>


