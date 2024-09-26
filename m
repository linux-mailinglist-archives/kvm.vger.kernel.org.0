Return-Path: <kvm+bounces-27541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 85DCB986C3C
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 08:04:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1DBCAB2528C
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 06:04:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10A6A188CD2;
	Thu, 26 Sep 2024 06:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="geGWS3MN"
X-Original-To: kvm@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCADD178CD9;
	Thu, 26 Sep 2024 06:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727330672; cv=none; b=IwxOU1+vTycpRQaPWOk3bKrdjppnWB/SfMLgAUsgg8b0vYnHQYePfPHOI4Zy5WKdvjwdEecIl9LwC+e/pnV4/hDo8FSeRCflsK7L8BSTaEKUEBgcvSvYK+jlaK6aep96o7Y0ni+W6tiDEpVq8gxR8IZVLh6G/ubNwTQD/BsaWFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727330672; c=relaxed/simple;
	bh=ZeQD+1PUyDnjoFlVO8O8D6pVFxmJOJGsc7xOxz4eNag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iX0tM56XLRjB7C7TU9pZCXG7NNkOqhxJnN+e5QPKJ3Gl7C/oy0BSfnWjimerA8Uff9JAB7sokhWdv7NkyUzt1RXadHXQfsXwXwikNA5ijIb43fZ88Bo+JToXygL642jopypIKdILbk86Ww2/z/1ET2LDp60bEW2lX6udGi9WLMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=geGWS3MN; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1727330658; x=1727935458; i=markus.elfring@web.de;
	bh=ZeQD+1PUyDnjoFlVO8O8D6pVFxmJOJGsc7xOxz4eNag=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=geGWS3MNungZvnuSeB/oIbiFxq5h613Eo7Pmd5iPT8OnEu74B6H5Cv6IDacsh1p3
	 PAplQeyDw/8pZ/vsybQYlvPoIEgk87jIa7I+EXqv8cupdPWgW0ycVUhX3JihKkUWD
	 9M6rzX8L1iFabgaKwl3iLr4x2DaObYAY81EulSWpMuJu/jbdZP7deLuFjxFAv8DTo
	 13lG/TcT0jfoey2FgJFzG0+BAeKsUMsXH3lni4QinSy2UM6hr4jxs7NLPU+gl7Cfx
	 MobJJY+1JQqd9htCqwg0ebAuqmwJCdhomePq1IlFEelwb+BVOETsiAG3156uGcNDS
	 1U6v8H8zh87WwTAcQA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.84.95]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MFayq-1si6E02S7i-00EemW; Thu, 26
 Sep 2024 08:04:18 +0200
Message-ID: <c32f24e8-9e4e-4ee5-9b5d-276dc99ace9f@web.de>
Date: Thu, 26 Sep 2024 08:04:06 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: vhost-vdpa: Refactor copy_to_user() usage in
 vhost_vdpa_get_config()
To: Al Viro <viro@zeniv.linux.org.uk>, virtualization@lists.linux.dev,
 kvm@vger.kernel.org, netdev@vger.kernel.org,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <79b2f48a-f6a1-4bfc-9a8d-cb09777f2a07@web.de>
 <20240925205005.GL3550746@ZenIV>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20240925205005.GL3550746@ZenIV>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:pMsomcAkr28z9Z3EwUnEnq8peCVCV4ch6FTAdwlR6QcGeSH397q
 mwXSzn1m+/eTNu8QxabM8wniDml2HEouJF+v+zmlpqqfiRdjJHM+f7stabRGQiiJCofbSU6
 SeBaV3Wbogs6nwukNAXgqZBAWBx0p9+Qi32QvgOQ+7/W+1RzdWwou9iJRVUh/ofJFj4vKST
 unWUrr4RZdlMDGVIWVYYw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:DF04tBPKcp8=;FCU+bf/qUQwvP8X7G4VCbyxZEjL
 F/FjNs231Xf2O15kcVJfSF8C7ImdV8e0ZuyXpQ623+BFZpjQP93RoYJmdC4hgPIwHdTkLNMan
 Vf/VPB94EE5J/N66oZWsfQ6vK1YSUFrmiF6/X+Nbbo4rHsA2hlRNpVoxt/uaWd2qzpOObrjtf
 BZyNW2BfqHoVradMDH2Lcqh//wddskWbZpHcnXAlyVXtTkxhsWt646CA8ecFnresbyjPNaoK6
 lRLU6xoSWbHkmYf8MmW/8Kbw5HG29xCQsR3UPy34SqJh+9HDUtp0ipftW5iNsI27JN8vYyDSU
 dtoKSGUG48TFDYLWU9nnMjhbgU4gyChgdd/9e1cL3MbRi2MhnmedugiwxFP4Ahw6zT4tSTOgY
 nw9cdnJzeao5xD53TsF+mOo2697CoMaskTfnH2jXK+QuSKK4Mk23hIbPnKmQ1QI6bIwVArE3H
 BDmbZKIAfaXJ7Qqaplorqh+lsATrSlX0TuoBMgFSJ44v6DAYt2zI35/OHQIHVNnS2RqAaVQ+l
 sqxfa7NudJquU0iZfZ9qT1i10fFO6DmKDUoh+l+CPJWXGo/Dl9j1LPM8xvJyDzZA+ZrgBUVez
 bVTnoz3BWlH+rcfRLYS/6GwC3gW0paUj9nynEw3Nma+t+ZN0aCxiCBVWadsKxLGUDkEoQvFqo
 e7M9ttVBU29Mbxz//cL9cjsP6V+3Iu4eT8SPfDBjkCYVdFO8v11KH7M3KajMONiVPygyrzuiU
 QaV0sLGb/rtVkikdmV8AWfAMaUNFGwUkax7XrkSDr1/rbEhW8XEMZ0p1e5hgO64gekvOmchwZ
 10mULOtL5104495OANasWuAA==

>> Assign the return value from a copy_to_user() call to an additional
>> local variable so that a kvfree() call and return statement can be
>> omitted accordingly.
>
> Ugly and unidiomatic.
>
>> This issue was detected by using the Coccinelle software.
>
> What issue?

Opportunities for the reduction of duplicate source code.

Regards,
Markus

