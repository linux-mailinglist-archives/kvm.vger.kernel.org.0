Return-Path: <kvm+bounces-56895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A1B4B45F62
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 18:52:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11123179DD7
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 16:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AFC530B525;
	Fri,  5 Sep 2025 16:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YlkRttTM"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FDD30B50D;
	Fri,  5 Sep 2025 16:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757091122; cv=none; b=Cq6Z6co6z00MyYqrrOJgqI64PiU1QV2Kf14tBpN3syKeY+Q8LuyMxqH/OzT07RCCiXD7wB26oS/6iIhxoyO7Fq4afgKB4WUuQ0PQ8NQzwAVExU+uJn0XztVPYEpRSX0bsOjNAvjhxQIsKQbqZDyb6/4NovVywIbYtVrdh/IVJ0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757091122; c=relaxed/simple;
	bh=WYLWUcPSd5jrYSeGhSGOmpkf3UQu+Fvp70h1FOBvL/E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vF7GqAe8PAQjvpqq8fH3AZ0gOCb1aQNzt9cf+IRGDh+pphfN5xWzmIIrZ0rW0MsbcROEaUMQw63V+8DMVitDWpjLWVCUB3wNcvLMhR1mJ3kml4REp4mIUpSboLXVxv0TkAZtNT6CphroqdcFRaKHdW4JPcE6uDpMXBP1n0t/wxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YlkRttTM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=Lu0hDzSntfixagIqqAnPk5EmBO+qEzDTbOWkYSk//uM=; b=YlkRttTMuOxt4e5t6VZxxC+R2B
	qUI4Vvdh/3JOYCS5R5IHKka+RFJw40TpFNd5VUJ1+a1oM9rWUuHVBG1lAwMyfBklvRXLXR03eZkqU
	KCKXDGoQpWFEFqNyuDQONEYbefoGUCqKII6Kr0DeoKaJ9Q7Jdexo7zrutYslDUsYwBtzH0MpmLaIR
	Xz8P7bx2u2QnilfFRFgoJ4acvkyMdb4mBcmyE5AljkiLg1dPBq6IElFAh67dp3ml3AElNi6/QgpB1
	bzmsBSzYIt5fpR3xDcZPAGy0vQ32JS+i/gep+yxNAMJMxhxVbMFjZaofyYd1pVUg1ztzECdDDGik9
	FbneDyAw==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uuZfL-00000003GDO-2eRP;
	Fri, 05 Sep 2025 16:51:59 +0000
Message-ID: <00378f4c-ac64-459d-a990-6246a29c0ced@infradead.org>
Date: Fri, 5 Sep 2025 09:51:59 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Documentation: KVM: Add reference specs for PIT and LAPIC
 ioctls
To: Jiaming Zhang <r772577952@gmail.com>, pbonzini@redhat.com,
 seanjc@google.com, corbet@lwn.net, kvm@vger.kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CANypQFZKnwafAFm2v5S_kbgr=p0UBBsmcSVsE2r65cayObaoiA@mail.gmail.com>
 <20250905075115.779749-1-r772577952@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250905075115.779749-1-r772577952@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

On 9/5/25 12:51 AM, Jiaming Zhang wrote:
> The behavior of KVM_SET_PIT2 and KVM_SET_LAPIC conforms to their
> respective hardware specifications. Add references to the Intel 8254
> PIT datasheet and the Software Developer's Manual (SDM)  to ensure
> users can rely on the official datasheets for behavioral details.
> 
> Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
> ---
>  Documentation/virt/kvm/api.rst | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 6aa40ee05a4a..d21494aa7dc2 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -2083,6 +2083,11 @@ The format of the APIC ID register (bytes 32-35 of struct kvm_lapic_state's
>  regs field) depends on the state of the KVM_CAP_X2APIC_API capability.
>  See the note in KVM_GET_LAPIC.
>  
> +.. Tip::
> +  ``KVM_SET_LAPIC`` ioctl strictly adheres to Intel® 64 and IA-32 Architectures
> +  Software Developer's Manual (SDM). Refer volume 3A of the `Intel SDM <https://

                                        Refer to volume 3A of the Intel SDM

> +  www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html>`_.

Please put the full URL on one line -- don't split it on 2 lines.

> +
>  
>  4.59 KVM_IOEVENTFD
>  ------------------
> @@ -3075,6 +3080,14 @@ This IOCTL replaces the obsolete KVM_GET_PIT.
>  Sets the state of the in-kernel PIT model. Only valid after KVM_CREATE_PIT2.
>  See KVM_GET_PIT2 for details on struct kvm_pit_state2.
>  
> +.. Tip::
> +
> +  ``KVM_SET_PIT2`` ioctl strictly adheres to the spec of Intel 8254 PIT.
> +  For example, a ``count`` value of 0 in ``struct kvm_pit_channel_state`` is
> +  interpreted as 65536, which is the maximum count value. Refer `Intel

                                                             Refer to

> +  8254 programmable interval timer <https://www.scs.stanford.edu/10wi-cs140/
> +  pintos/specs/8254.pdf>`_.

Put the full URL on one line, please.

> +
>  This IOCTL replaces the obsolete KVM_SET_PIT.
>  
>  
Thanks.
-- 
~Randy


