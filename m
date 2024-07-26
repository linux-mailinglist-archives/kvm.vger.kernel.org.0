Return-Path: <kvm+bounces-22280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 528D193CCDD
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 05:10:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 845941C20DF8
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 03:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1F2A2C694;
	Fri, 26 Jul 2024 03:10:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from bg1.exmail.qq.com (bg1.exmail.qq.com [114.132.77.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93562B9AD;
	Fri, 26 Jul 2024 03:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.132.77.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721963445; cv=none; b=HO6ouAJ9QET6Pn6AO3flIMKOTUVLVXjf+8tyLa8cthsSVXmgpxYJrpefbuWZDCrmvsjaR2l5reLI1A2otBJoGTfT87FWM2gjrvlXLKewqmm455GEUe+jgt1bqxMIOY7xLZAQFrAKJyrqXYsqbYf7ZLkAIMftsaMWVO2MbfIJqgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721963445; c=relaxed/simple;
	bh=KnmhnJYYwGpkztXvAAhQ7H65oKgoi/1LJQ1oRyzvwF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f/lgjRqRzdMLQnoFh3WR75uK3+ZeaQFTlS7dGx21WpZx3TaZkAhdOT0FgM8cVvYOwrlREaDnDzfdWQre1EdqP5oTIefnxhCwN6H9udNjtwG70UnWXZ+TZoZwS2HEhcejaSz3BkPo1kc9VMExY1Te35JZAQMixpa7yr70URfbrH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; arc=none smtp.client-ip=114.132.77.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
X-QQ-mid: bizesmtpsz10t1721963365t3n0or
X-QQ-Originating-IP: Xp/t7bt6kuXPtAGBYlF0Pf3MCFZXF14mFhYnaXWuoYI=
Received: from [10.20.251.167] ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 26 Jul 2024 11:09:23 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12097295247028987170
Message-ID: <378701EAC462BD03+7e3108aa-7289-4b3a-8ebf-013dd9ab6e74@uniontech.com>
Date: Fri, 26 Jul 2024 11:09:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: Loongarch: Remove undefined a6 argument comment for
 kvm_hypercall
To: Huacai Chen <chenhuacai@kernel.org>, maobibo <maobibo@loongson.cn>
Cc: Dandan Zhang <zhangdandan@uniontech.com>, zhaotianrui@loongson.cn,
 kernel@xen0n.name, kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, Wentao Guan <guanwentao@uniontech.com>,
 lixianglai@loongson.cn
References: <6D5128458C9E19E4+20240725134820.55817-1-zhangdandan@uniontech.com>
 <c40854ac-38ef-4781-6c6b-4f74e24f265c@loongson.cn>
 <CAAhV-H5R_kamf=YJ62hb+iFr7Y+cvCaBBrY1rdk_wEEq4+6D_w@mail.gmail.com>
From: WangYuli <wangyuli@uniontech.com>
In-Reply-To: <CAAhV-H5R_kamf=YJ62hb+iFr7Y+cvCaBBrY1rdk_wEEq4+6D_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1


On 2024/7/26 10:55, Huacai Chen wrote:
> On Fri, Jul 26, 2024 at 9:49 AM maobibo <maobibo@loongson.cn> wrote:
>
> Maybe it is better to implement kvm_hypercall6() than remove a6 now?
>
It seems that The LoongArch KVM implementation does not include a 
kvm_hypercall6() function.

This might be a typo or an oversight.


Link: 
https://github.com/deepin-community/kernel/blob/linux-6.6.y/Documentation/virt/kvm/loongarch/hypercalls.rst 



