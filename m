Return-Path: <kvm+bounces-69002-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sMUgD0Cbc2nNxQAAu9opvQ
	(envelope-from <kvm+bounces-69002-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 17:01:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BE923781E0
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 17:01:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 926393065FE8
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:56:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F3A82F2604;
	Fri, 23 Jan 2026 15:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zFuMWmRO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4311DD877
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 15:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769183802; cv=none; b=OQ8vzHfizj1ffnudF6brwQL+mPuLVIIr5noc+eL0JbtodqoLzFNjzaQqfqgGHvoiIROLRlmgguJGL5X97DDECPA8iE7j4Oq5SP73klwYxpsE6kcqJS/hPrrs8oMeznn9Kc0FozH3Pgm+GWHYlAQbEiHfphPG0/gYrbF5Pg8Vs8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769183802; c=relaxed/simple;
	bh=Sl3PRmZUZo46uuExMEcTw/G/u7erw3YZZigDrH8wCoo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QLJ1Jwq9s2MdWN5yLX8eQ6fSeRKS+qTBUwrXY/vVBq1q678LaGbA5MZWyacNZBmbDpT/nVwt5CrBiNmoqTy1rIsqHLWtIgZXDK6lhtm4t+6jWWWIpR6D795QLVJ7ofq8hAkhKG5EKfqlcUf27LGVafLUKQZL2aNtAUiKoFKg5wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zFuMWmRO; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-81f4c0e2b42so1270177b3a.1
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 07:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1769183800; x=1769788600; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=6t04NU0w884dfN28yF/6Ge0FsY+81Z3QWXgyOd1PAmg=;
        b=zFuMWmROZAI2dpOg2TFJgGIMz8mIsH/doUp5MJJ8fc1QOEq54qC84kHu459bBy2q7j
         Io8K0S02HugyGRe2eLmqrXjczpdYMT1H9ySgKab8lOci8zsehegZ7OEso7+dQbngc39W
         SplDfVF6NyS0LdP3g95mTkSz5lD4Ru2qt9J/BGcOylC3H/pYBCir0t4vvXO7q8gZLjow
         lKctFk3iolN4Vwgs8kooD9U0Ne7hxqyxGge6lDIguhzzVqz23ifJ04WI/B5ks6cgFBMQ
         dz7Cb6jHQ1fffoLqB9f3ez/PXRwse7VUl6z57SGqpoWgD0WwKrhi8wqrkXLNgVuOulSw
         pwmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769183800; x=1769788600;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6t04NU0w884dfN28yF/6Ge0FsY+81Z3QWXgyOd1PAmg=;
        b=ISoRmlm1V0rQGFaUAUlC/zOCcZcx14TWHDKpIupgHJIAD2FXdqAAiiOJ1jaJVGwltm
         X4EtC5mxuMOSp7ODGPizmp43Kd3NJc6+lMkgU5WhcxWemqnJvEs2LXrYZkHHvkowD1yp
         mMYL+5dhzCF4MnSgTQ+0bYPaWcLTag8cRD9RBBKa2VqO9TPjlqp67ZQQ7h/hTgHVJ6ib
         6uPDyoojGfxDq8ZwsebfRWBooqVwzLBjLixEyJfh8UQTjXGgq+vso61HsXqVzpZptZ14
         my/vqPk6Ec+iQ2d3tLc9fB3pL/VbFyx/JBT6up+1LkKGzryR264RF8tTs+VjoFmi4W6Z
         KZJA==
X-Forwarded-Encrypted: i=1; AJvYcCXHyH8/xwhc4WlYLy7AoPeEtHWyJewqKui0cKp1E/5BrQsQEiBwCl8Q9svOTsAkqLS234w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yws56KVAiX3Q3C39fFYLB49zrGsrUS99ABW/2nvTOPd6h3sfoiS
	aBMng1bpXy/6JWjVx7ki+WPq78n2G3rH/tCzuZ9+uGY2wKhOqRQ3WFO70lnU1kmYoDE=
X-Gm-Gg: AZuq6aIouQqo/Ba+MkTJBPfY2kSMF+NxOgTLjfzZ73QO6mo7ybyy7743DXDW1DKF5jo
	C6KX9Pq4nIGVtls8al1LHsTPsYv8Xj5LHSF9oemNxDDzUlg/9rLdTJvWcWtfuHDb3egzpJVoGFZ
	yuD5x5ziNVMPEdK0KhDwtDTB9W1JAVPQ0GVcNGQIz2h8ANpsX2PPljb9tOfhUrhwAvgCAZg+HGC
	vDyxopbtKyBFlMhIeotQhpr8Fy6YupLn86LydSmBEhLeYjNj7YB4uvTjTw5JDS6R5KSXFEMyp+s
	NFig0vo2CdLZB+w07NkVGAerwsd6pF3oY6nXPX08aXFzl4oZKQAbF3ovyRzPluBXjSb6+8M+SdG
	TpdJ9ga4k4miSXS92phcde2ULBQKVp1LvfqHvEE4cStBGmDzKaOJbWl0QHMDQ2ylEn23tDaFfuS
	CdlARjuWmIC0BUfx7F1y6bAk+ILdK2tLM6Pp6pHaJBv5AXVolfir5JrXiAgi7QLcRwAPU=
X-Received: by 2002:a05:6a00:1d9e:b0:823:16b2:2498 with SMTP id d2e1a72fcca58-82317e0091amr2720434b3a.36.1769183799926;
        Fri, 23 Jan 2026 07:56:39 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8231876e718sm2554003b3a.62.2026.01.23.07.56.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jan 2026 07:56:39 -0800 (PST)
Message-ID: <4163b033-426c-47f0-91f9-3ef76dec3fec@linaro.org>
Date: Fri, 23 Jan 2026 07:56:38 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Call for GSoC internship project ideas
To: =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@gmail.com>
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Stefan Hajnoczi <stefanha@gmail.com>, Thomas Huth <thuth@redhat.com>,
 qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
 Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 Matias Ezequiel Vara Larsen <mvaralar@redhat.com>,
 Kevin Wolf <kwolf@redhat.com>, German Maglione <gmaglione@redhat.com>,
 Hanna Reitz <hreitz@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
 Alex Bennee <alex.bennee@linaro.org>, John Levon <john.levon@nutanix.com>,
 Thanos Makatos <thanos.makatos@nutanix.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
 <CAJSP0QVQNExn01ipcu4KTQJrmnXGVmvFyKzXe5m9P3_jQwJ6cA@mail.gmail.com>
 <CAJSP0QW4bMO8-iYODO_6oaDn44efPeV6e00AfD5A42pQ9d+REQ@mail.gmail.com>
 <aXH4PpkC4AtccsOE@redhat.com>
 <CAMxuvaw04pDNzHyw5+Qcv_KfrhDTiyp+MNxpECp+HfTa5iLOGw@mail.gmail.com>
 <aXH-TlzxZ1gDvPH2@redhat.com>
 <CAFEAcA_u6QUhs+6-cyYm_qttsDiV2zHbsc-_FbTb8QzWXk6+tw@mail.gmail.com>
 <aXICpFZuNM9GG4Kv@redhat.com>
 <CAMxuvawgOvQbwoyCzFBLw++JqR0vFbVUhbv1AJWU6VqK1MM_Og@mail.gmail.com>
 <82f74c82-c572-4ab9-b527-11ea287056d1@linaro.org>
 <CAJ+F1CJtrv9YgDbiekVmDD2yT+6nUe39nLwLsKxvFOtMc1kUGA@mail.gmail.com>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Language: en-US
Autocrypt: addr=pierrick.bouvier@linaro.org; keydata=
 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
 ZtfdHNZotF092MIH0IQC3poExQpV/WBYFAI=
In-Reply-To: <CAJ+F1CJtrv9YgDbiekVmDD2yT+6nUe39nLwLsKxvFOtMc1kUGA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69002-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,linaro.org,gmail.com,nongnu.org,vger.kernel.org,gmx.de,ilande.co.uk,nutanix.com];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linaro.org:+];
	NEURAL_HAM(-0.00)[-0.997];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:email,linaro.org:dkim,linaro.org:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BE923781E0
X-Rspamd-Action: no action

On 1/23/26 12:44 AM, Marc-André Lureau wrote:
> Hi
> 
> On Thu, Jan 22, 2026 at 7:46 PM Pierrick Bouvier
> <pierrick.bouvier@linaro.org> wrote:
>>
>> On 1/22/26 3:28 AM, Marc-André Lureau wrote:
>>> Hi
>>>
>>> On Thu, Jan 22, 2026 at 2:57 PM Daniel P. Berrangé <berrange@redhat.com> wrote:
>>>>
>>>> On Thu, Jan 22, 2026 at 10:54:42AM +0000, Peter Maydell wrote:
>>>>> On Thu, 22 Jan 2026 at 10:40, Daniel P. Berrangé <berrange@redhat.com> wrote:
>>>>>> Once we have written some scripts that can build gcc, binutils, linux,
>>>>>> busybox we've opened the door to be able to support every machine type
>>>>>> on every target, provided there has been a gcc/binutils/linux port at
>>>>>> some time (which covers practically everything). Adding new machines
>>>>>> becomes cheap then - just a matter of identifying the Linux Kconfig
>>>>>> settings, and everything else stays the same. Adding new targets means
>>>>>> adding a new binutils build target, which should again we relatively
>>>>>> cheap, and also infrequent. This has potential to be massively more
>>>>>> sustainable than a reliance on distros, and should put us on a pathway
>>>>>> that would let us cover almost everything we ship.
>>>>>
>>>>> Isn't that essentially reimplementing half of buildroot, or the
>>>>> system image builder that Rob Landley uses to produce toybox
>>>>> test images ?
>>>>
>>>> If we can use existing tools to achieve this, that's fine.
>>>>
>>>
>>> Imho, both approaches are complementary. Building images from scratch,
>>> like toybox, to cover esoteric minimal systems. And more complete and
>>> common OSes with mkosi which allows you to have things like python,
>>> mesa, networking, systemd, tpm tools, etc for testing.. We don't want
>>> to build that from scratch, do we?
>>>
>>
>> I ran into this need recently, and simply used podman (or docker) for
>> this purpose.
>>
>> $ podman build -t rootfs - < Dockerfile
>> $ container=$(podman create rootfs)
>> $ podman export -o /dev/stdout $container |
>> /sbin/mke2fs -t ext4 -d - out.ext4 10g
>> $ podman rm -f $container
>>
>> It allows to create image for any distro (used it for alpine and
>> debian), as long as they publish a docker container. As well, it gives
>> flexibility to have a custom init, skipping a lengthy emulated boot with
>> a full system. As a bonus, it's quick to build, and does not require
>> recompiling the world to get something.
>>
>> You can debug things too by running the container on your host machine,
>> which is convenient.
>>
> 
> Very nice! I didn't realize you could export and reuse a container that way.
>

It's a just a filesystem, so you're free to include what you want. An 
advantage on custom solutions is that Dockerfile is a standardized format.

> I wonder how this workflow can be extended and compare to mkosi
> (beside the limitation to produce tar/fs image)
>

mkosi takes care of more things for you, like setting up users, probably 
supports partitioning your disk, and make it bootable. See it as 
something like debootstrap + install.
The container based approach above give you an ext4 filesystem, the rest 
is up to you.

> For qemu VM testing, it would fit better along with our Dockerfile &
> lcitool usage.
>

It's nice and easy to prototype indeed. As well, unrelated, but I think 
it's better for everyone to spend time learning Dockerfiles instead of 
an ad-hoc solution QEMU wants to use. The worse would be custom python 
scripts reinventing the wheel and recompiling everything: long to 
iterate and impossible to decipher except for the one who wrote it.

> I wish a tool would help to (cross) create & boot such (reproducible)
> images & vm easily.
> 

I was looking exactly at this, and I've been surprised that nobody 
except bootc tried reusing existing containers: it seems to be a perfect 
match. Beyond the convenience, you get build caching for free, which is 
very important when you iterate on system images. And you can host the 
result directly and for free on dockerhub, even if that's several GB.

Bootc forces the usage of a specific "base" image, which, IMHO, goes 
against what people should expect. Now, instead of having a normal 
Dockerfile, you have a Dockerfile based on a black box you can't modify 
easily. If I'm wrong and if someone is familiar with bootc here, I would 
be happy to hear the opposite.

> 
>> I took a look at bootc, but was not really convinced of what it added
>> for my use case compared to the 4 commands above.
>>
> 
> Having a regular VM bootable image could be desirable for some cases
> (tpm, secure boot testing for ex).
> 
> --
> Marc-André Lureau

All that said, containers are just a suggestion. If mkosi is a good 
tool, I would be happy to see it used. Just avoid going down the rabbit 
hole reimplementing everything like it has been suggested on this 
thread: we would not have one problem only, but two problems instead.

Regards,
Pierrick

