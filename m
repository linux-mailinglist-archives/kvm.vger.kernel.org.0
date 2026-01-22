Return-Path: <kvm+bounces-68903-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +AtPDLNYcmkpiwAAu9opvQ
	(envelope-from <kvm+bounces-68903-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:04:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A3216AB51
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:04:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7C7C030B0A0D
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 16:49:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 429CD4A1396;
	Thu, 22 Jan 2026 15:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f8VqQI3c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E524968F4
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 15:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769096771; cv=none; b=sWWbxbFdx4xxuZXx2+Q+fz/yVapbPJEPA0El5E+sPx9nV2Nq9HD35y4TqTn9Sed0h+6a7e0DWc4lygVrol8jajySSjwU9L9fm/9BzCQni7cgK+pV3/4E+QbwlcM7Q58V5m7rd6Kmt6bUTAQbyj/YKtq3Bh1DvGAFga/mwsyTwSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769096771; c=relaxed/simple;
	bh=sK8FrJ26/Sc8m/HpyXoHIB599jHGUSWW+gidTbOiAb8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lUuNAZZ/3YY8TfGhr8EjKj2TNdzbIdF7YjeHAL9FVDoz53uoxuo6oi4JnSYkwnIGBS0KrN9SE1YTFzFvH4FEp/1piznaEAX/z/854gkZfFYUPBg/xUSpMxp7uTSUCZyly263xQlHwwu0AL/6nBvShM6AHhGia12bQJ9QjqezP8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=f8VqQI3c; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a7a23f5915so7602315ad.2
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 07:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1769096764; x=1769701564; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1P3pO9mwWJU7KwcoGKVXusH1FL0E5w+n+ZTDybvnJdM=;
        b=f8VqQI3c1FcqxN3C+yxwOoUJNyqOAh5oiv4aOX4IPw6nfQtTFxNGn1QMBgREK1bcF1
         aZvPVvrcZtT2UU5wjkz9BJqAFj0VdzdRFSA7mnoL9u8P6Kew1V70RhHxP69P42+EbC/c
         KJb21oarDriCKOkMeP1TXYKKfMy7dSoivjp73rhHz3GsnhhFqwCJJFap48vBHhHxYE8a
         mnJ8cbSRMxfXXAgQyIuSYVdzyGsQztAqZR/0mbck0a1i71+lay9S8PcV7pDsKG7wKzih
         wsO5GvU+3fWRGALzaxVHMRmS+vpf/fBFy+cXoIxiT6EMzxMMydeghPR7pyWdl2P7AvDF
         +rew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769096764; x=1769701564;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1P3pO9mwWJU7KwcoGKVXusH1FL0E5w+n+ZTDybvnJdM=;
        b=Sk58xP5vIB3LKshOMXZaq42zbfJwVjpXW5qJ3lJDSGokVyZOiaWBJQQ2qx3uSStQf1
         V7c9mObEoFUa/Iq9pPzDBYhj1wxcYJ7N1CssmL/QhlJc3wXGS7LDhmW/l/s3YCqEVmc/
         LQ2IcX/a12G8xsLRd9/9satjkrW0D/7VzLyPdnLtfuHE52qHBrWS66+6/imI2LiIK2Iq
         MfwJv68aH6+Ep/yUUEx0FaoTMecHnP0H+focPa4g4UAE9UYNPWBgMoMZw9NQki2qJptm
         hbL1QD+z0ZrSS+tEX+xMfvw7YeCCC484ZVlOuYRTRJlDSZkDP3/DdYIhAlu3Dozj8Njh
         PpmQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/kSwx7BePhSfsXDoNvpL0NoxiGN4UWj8fjAzic9bOIvGOYbV8uhXlJTmiqoKjdNzLeqk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCicbsN9TrEKgdSn+aVmarespUsdmENotlfXDuhGNtt/jykyaQ
	Og87sKWDX91lRhQssYoK0q9gdztKHb4tmVmcdKztC4YxGXtdHNVfwxMb3oSb8N01L/M=
X-Gm-Gg: AZuq6aIvFWVcmeECWjdEY8aAy/GpUfwlyBZ+lG9l8VWLctNpWGgdBaOAaV/DqpfBj2m
	8feyWfxkXtfetg2i88uRw7PY5KIqEJpKRXD109cclF6dajQVuDWBrR2hkC9J8BGmc+WjJk7MwZA
	HRzZfoSXwuMGlRhYcOct/hU6Mx2rPQOW0PwNu+JhpzAtyisO14JGXgoZTU/u5nG7iVzTbDR1yv1
	GxrtfuK26Rp/x7WA21FMes+b8CCmX3e0qZ66bYR8JTdt3xczLjSoxT3PwQtDrlJJ+5EklBJNR4b
	5jr6uV7frhXU6MeX38oweUe1rilskoEjoY7HSU5FE0/Kh/4LOJH3lv6d5dcp4yxEtpYoyxylB9v
	nkRkSyVc+RFOsYkw7rQhiTrwWstsF7IXPdNveSpfn/Qkb7jL4/CT3KFQXZNlLL0iulJKHvt8MbQ
	qN5VO2c4KT9bd4NT7rPHrB9h3ou3Z0z3d4O8v0a0+0t81Xcl9Sfu1gdDTn
X-Received: by 2002:a17:903:2351:b0:298:485d:556e with SMTP id d9443c01a7336-2a7175170e0mr201410285ad.11.1769096763526;
        Thu, 22 Jan 2026 07:46:03 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7193dca71sm183794605ad.48.2026.01.22.07.46.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jan 2026 07:46:03 -0800 (PST)
Message-ID: <82f74c82-c572-4ab9-b527-11ea287056d1@linaro.org>
Date: Thu, 22 Jan 2026 07:46:02 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Call for GSoC internship project ideas
Content-Language: en-US
To: =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>,
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
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Autocrypt: addr=pierrick.bouvier@linaro.org; keydata=
 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
 ZtfdHNZotF092MIH0IQC3poExQpV/WBYFAI=
In-Reply-To: <CAMxuvawgOvQbwoyCzFBLw++JqR0vFbVUhbv1AJWU6VqK1MM_Og@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[linaro.org,gmail.com,redhat.com,nongnu.org,vger.kernel.org,gmx.de,ilande.co.uk,nutanix.com];
	TAGGED_FROM(0.00)[bounces-68903-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[21];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim]
X-Rspamd-Queue-Id: 8A3216AB51
X-Rspamd-Action: no action

On 1/22/26 3:28 AM, Marc-André Lureau wrote:
> Hi
> 
> On Thu, Jan 22, 2026 at 2:57 PM Daniel P. Berrangé <berrange@redhat.com> wrote:
>>
>> On Thu, Jan 22, 2026 at 10:54:42AM +0000, Peter Maydell wrote:
>>> On Thu, 22 Jan 2026 at 10:40, Daniel P. Berrangé <berrange@redhat.com> wrote:
>>>> Once we have written some scripts that can build gcc, binutils, linux,
>>>> busybox we've opened the door to be able to support every machine type
>>>> on every target, provided there has been a gcc/binutils/linux port at
>>>> some time (which covers practically everything). Adding new machines
>>>> becomes cheap then - just a matter of identifying the Linux Kconfig
>>>> settings, and everything else stays the same. Adding new targets means
>>>> adding a new binutils build target, which should again we relatively
>>>> cheap, and also infrequent. This has potential to be massively more
>>>> sustainable than a reliance on distros, and should put us on a pathway
>>>> that would let us cover almost everything we ship.
>>>
>>> Isn't that essentially reimplementing half of buildroot, or the
>>> system image builder that Rob Landley uses to produce toybox
>>> test images ?
>>
>> If we can use existing tools to achieve this, that's fine.
>>
> 
> Imho, both approaches are complementary. Building images from scratch,
> like toybox, to cover esoteric minimal systems. And more complete and
> common OSes with mkosi which allows you to have things like python,
> mesa, networking, systemd, tpm tools, etc for testing.. We don't want
> to build that from scratch, do we?
> 

I ran into this need recently, and simply used podman (or docker) for 
this purpose.

$ podman build -t rootfs - < Dockerfile
$ container=$(podman create rootfs)
$ podman export -o /dev/stdout $container |
/sbin/mke2fs -t ext4 -d - out.ext4 10g
$ podman rm -f $container

It allows to create image for any distro (used it for alpine and 
debian), as long as they publish a docker container. As well, it gives 
flexibility to have a custom init, skipping a lengthy emulated boot with 
a full system. As a bonus, it's quick to build, and does not require 
recompiling the world to get something.

You can debug things too by running the container on your host machine, 
which is convenient.

I took a look at bootc, but was not really convinced of what it added 
for my use case compared to the 4 commands above.

Just my 2 cents,
Pierrick

