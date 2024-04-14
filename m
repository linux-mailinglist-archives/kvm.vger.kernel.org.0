Return-Path: <kvm+bounces-14603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11A588A416C
	for <lists+kvm@lfdr.de>; Sun, 14 Apr 2024 11:09:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 700E8B21062
	for <lists+kvm@lfdr.de>; Sun, 14 Apr 2024 09:08:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F09B23749;
	Sun, 14 Apr 2024 09:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="AjSsfHjv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-16.smtpout.orange.fr [80.12.242.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E0723763;
	Sun, 14 Apr 2024 09:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713085723; cv=none; b=Gm41fXIbhL6B7ibynZFDqNtQZdlZwJUez4gMokTgK3vKa6JN9RR/9haYcZ9HrnEXxx8z97qiqNNrSYKWvzpYkHXGjSvkAvm8ZL7vowwRPqY0VE+didagcnfUImRyR3ZQdNqwsKa6+Ze+bIphSMfYdcwliip5Thx7yuWzrrMv9To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713085723; c=relaxed/simple;
	bh=9779tXEoKwtk0tBlvFrV6fyjZ+AwBifchZcZ26bQycY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e9jkGaWcNpZlSvbR97OroGE+I7N3jfzuOvApa4OrdcVuzzMm54H0ddtBJnJvwSinr6NnmHFXI2wmQjm9Ib0ofHqHzraJcyXrXPvJzW0lg3wD/Wgx7uGjky3f1fK6vrA3APsdNyrwuW5j6Xfeevy3hLcxmtr/3EMtMUi3I4CIuwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=AjSsfHjv; arc=none smtp.client-ip=80.12.242.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from [192.168.1.18] ([86.243.17.157])
	by smtp.orange.fr with ESMTPA
	id vvharZVzm6xfSvvhar10vW; Sun, 14 Apr 2024 10:59:07 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1713085147;
	bh=Lg/QS1BhTQotDrjjhFPq2bEuJpWIpclvcNGCTr5a1hY=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=AjSsfHjv+lTSFM9oqHAYJLnszgFMIyk64VAYK85LEwPjsu7hgyv6P/vdkNVsKf1J/
	 ypr49UhadsGYEaNvkdkpdKKTf5RL6Zn+H48Xf1fahaGjxqc0ZgECyF+cT9U00fthze
	 9GNHEMBMojjVd51Kl8Mq3p4T6QIyGTeyVPFLu9cGXC9yo/8w12xhmPlzlU0LuEToXL
	 2HeoXdwsML3AW9SIV0xXPY1B4+cdXK/4cE3ViylOde5hfpPiGo1zXwTWUBDBM/zPJl
	 jU5S0xoO/My8G7QBpHgQX/QA7QPIYgZQdZPVylBDGyXQzX3v7iJfWXATtto79Tc1k3
	 fzQ0WPtEW2RKg==
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 14 Apr 2024 10:59:07 +0200
X-ME-IP: 86.243.17.157
Message-ID: <a7eceabf-12cb-41ff-8e2b-f3b21d789c17@wanadoo.fr>
Date: Sun, 14 Apr 2024 10:59:06 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vhost-vdpa: Remove usage of the deprecated
 ida_simple_xx() API
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org
References: <bd27d4066f7749997a75cf4111fbf51e11d5898d.1705350942.git.christophe.jaillet@wanadoo.fr>
 <20240414043334-mutt-send-email-mst@kernel.org>
Content-Language: en-MW
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20240414043334-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 14/04/2024 à 10:35, Michael S. Tsirkin a écrit :
> On Mon, Jan 15, 2024 at 09:35:50PM +0100, Christophe JAILLET wrote:
>> ida_alloc() and ida_free() should be preferred to the deprecated
>> ida_simple_get() and ida_simple_remove().
>>
>> Note that the upper limit of ida_simple_get() is exclusive, buInputt the one of
> 
> What's buInputt? But?

Yes, sorry. It is "but".

Let me know if I should send a v2, or if it can be fixed when it is applied.

CJ

> 
>> ida_alloc_max() is inclusive. So a -1 has been added when needed.
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> 
> Jason, wanna ack?
> 
>> ---
>>   drivers/vhost/vdpa.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index bc4a51e4638b..849b9d2dd51f 100644
>> --- a/drivers/vhost/vdpa.c
>> +++ b/drivers/vhost/vdpa.c
>> @@ -1534,7 +1534,7 @@ static void vhost_vdpa_release_dev(struct device *device)
>>   	struct vhost_vdpa *v =
>>   	       container_of(device, struct vhost_vdpa, dev);
>>   
>> -	ida_simple_remove(&vhost_vdpa_ida, v->minor);
>> +	ida_free(&vhost_vdpa_ida, v->minor);
>>   	kfree(v->vqs);
>>   	kfree(v);
>>   }
>> @@ -1557,8 +1557,8 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
>>   	if (!v)
>>   		return -ENOMEM;
>>   
>> -	minor = ida_simple_get(&vhost_vdpa_ida, 0,
>> -			       VHOST_VDPA_DEV_MAX, GFP_KERNEL);
>> +	minor = ida_alloc_max(&vhost_vdpa_ida, VHOST_VDPA_DEV_MAX - 1,
>> +			      GFP_KERNEL);
>>   	if (minor < 0) {
>>   		kfree(v);
>>   		return minor;
>> -- 
>> 2.43.0
> 
> 
> 


