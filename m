Return-Path: <kvm+bounces-14602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA9E88A4147
	for <lists+kvm@lfdr.de>; Sun, 14 Apr 2024 10:35:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58C12281E0E
	for <lists+kvm@lfdr.de>; Sun, 14 Apr 2024 08:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D2332374C;
	Sun, 14 Apr 2024 08:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="t26R2MBY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-13.smtpout.orange.fr [80.12.242.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7A31AAA5;
	Sun, 14 Apr 2024 08:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713083726; cv=none; b=G/fvm1rQivUkM2IVQYvfPCyUpnOYczFOxbVLyUfFlTrMlVxSBmLMWv38AaQDVihpYgCjAQtRnB8CxXw/ziiNe4P7zfsRGlV4MWuzr0Juo41UmmYca4IcjUEbWWy75AeUzLfmvcnoDvrqm9rSXrqHIgOCwtLZ8MudVOYTnpE+U5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713083726; c=relaxed/simple;
	bh=g9g7W9dRjFnnmcIhBA8COuq//kRWVgC968TWF7npr3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iZsgQfV/a3CMXBFVfExyxxxj9wBLaCDeyp0XhF5Q2I8yWC2B4I3d6eMTZqfYA0Jv1sTAFIBRtidpeSKWRoGfcrwRARg9nBNUQkMgqhtqRHSLnw0ckUtt8JsDHzIkwW8waMxycRpA1N5bHduZtrIZl8Qxs911Mei39CY8aE0HoZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=t26R2MBY; arc=none smtp.client-ip=80.12.242.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from [192.168.1.18] ([86.243.17.157])
	by smtp.orange.fr with ESMTPA
	id vvBdrWaH5A2vSvvBdrpztt; Sun, 14 Apr 2024 10:26:07 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1713083167;
	bh=E/95b58pRdlETX2FBhKOQ8sHn6Id8wFl4e2YyFmV+PQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=t26R2MBYEryhnb3fr0GVe0bUrJSy66cl3pnhuzUjxJEHnCzJLilAmM2tmOQOLpU2r
	 TB+MGsHq8MOHayvTnsqMJ7iioHNDMtW+/zRVjT4WsBp9Dka4Ej/CA3W3NfCTuZzkqs
	 1a8dMOXIxnq9rL2PMHeJ0t8ImzTNivavt/3feGOIb6OcjG+NafjZkjM9LgG8BlqRvC
	 /lKaH6iDFG83QiddAQatJ9/Dr3ZN4lrRnybefJcn2k4vSvOFaP+4KEhgNO/EiPnVA5
	 A9vLR60pr7GsnLzK4psbK2GKL5jgkh0/AwH+POJtjbKVdQGhBYS0nQPGTBUH9nTE3O
	 da8rtH49+TejA==
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 14 Apr 2024 10:26:07 +0200
X-ME-IP: 86.243.17.157
Message-ID: <93a3a465-01b1-4ca6-9b77-55d1024ae88a@wanadoo.fr>
Date: Sun, 14 Apr 2024 10:26:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vhost-vdpa: Remove usage of the deprecated
 ida_simple_xx() API
To: Simon Horman <horms@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
 kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org
References: <bd27d4066f7749997a75cf4111fbf51e11d5898d.1705350942.git.christophe.jaillet@wanadoo.fr>
 <20240116145727.GT392144@kernel.org>
Content-Language: en-MW
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20240116145727.GT392144@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 16/01/2024 à 15:57, Simon Horman a écrit :
> On Mon, Jan 15, 2024 at 09:35:50PM +0100, Christophe JAILLET wrote:
>> ida_alloc() and ida_free() should be preferred to the deprecated
>> ida_simple_get() and ida_simple_remove().
>>
>> Note that the upper limit of ida_simple_get() is exclusive, buInputt the one of
>> ida_alloc_max() is inclusive. So a -1 has been added when needed.
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> Reviewed-by: Simon Horman <horms@kernel.org>
> 
> 
> 

Hi,

polite reminder ;-)

CJ

