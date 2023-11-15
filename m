Return-Path: <kvm+bounces-1705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF99B7EBA60
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 01:00:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFE341C20A97
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 00:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5739D33080;
	Wed, 15 Nov 2023 00:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z08EQD44"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876052C1B2
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 00:00:10 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2C5C2;
	Tue, 14 Nov 2023 16:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=fI1i46wGmSawxg9bjQqtCDxaszTYtfTdIi2jtLduIII=; b=z08EQD44LOosBYSQh7X5OAeNlk
	i5YGV6CTfwp0fndbsnX0juOwyS0Rgs0EvsHZER+NPjqeDdenGV3/NjhT8eguHN8I7uBxQw3/UziJ0
	2k/LhfOz2dTvZ/nEKnHqt/YoW+5VccyjjDESSmVsioMSdTZzw8QgzV+CK4fW1MN1QxkSKWa9M8HDX
	ggyxr91FgxyR+ghklrTdVzQhboa3ZrUcVW1MXGQkSg07REeGwGHG4S3lgkw/AA/tS/t0x1//j4S98
	D2QFYPyxOK9L10p6l+uoKNIckvdO0VEsIwBcJmdkmRDmNUF8HqoZdjryA6pYATPYBXf95p9NElnE9
	L0WVKVhg==;
Received: from [50.53.46.231] (helo=[192.168.254.15])
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r33KA-00H0dp-36;
	Wed, 15 Nov 2023 00:00:06 +0000
Message-ID: <960bef74-ed09-4b6f-8ae8-b3effef6914f@infradead.org>
Date: Tue, 14 Nov 2023 16:00:05 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: linux-next: Tree for Nov 14 (loongarch: KVM)
Content-Language: en-US
To: Stephen Rothwell <sfr@canb.auug.org.au>,
 Linux Next Mailing List <linux-next@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 KVM list <kvm@vger.kernel.org>,
 "open list:LOONGARCH" <loongarch@lists.linux.dev>
References: <20231114141916.6472e5c0@canb.auug.org.au>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20231114141916.6472e5c0@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/13/23 19:19, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20231113:
> 

../arch/loongarch/kvm/mmu.c: In function 'kvm_map_page':
../arch/loongarch/kvm/mmu.c:810:13: error: implicit declaration of function 'mmu_invalidate_retry_hva'; did you mean 'mmu_invalidate_retry_gfn'? [-Werror=implicit-function-declaration]
  810 |         if (mmu_invalidate_retry_hva(kvm, mmu_seq, hva)) {
      |             ^~~~~~~~~~~~~~~~~~~~~~~~
      |             mmu_invalidate_retry_gfn


-- 
~Randy

