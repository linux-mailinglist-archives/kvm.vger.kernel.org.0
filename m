Return-Path: <kvm+bounces-17764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 552D38C9EA1
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 16:16:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 118D2284705
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 14:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F25A81369A5;
	Mon, 20 May 2024 14:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="karszRpn"
X-Original-To: kvm@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548B94D9EA;
	Mon, 20 May 2024 14:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716214597; cv=none; b=gAUggwhSjnlkWA7R5xg2o7Yr2VHt6sPWoI8mQNw3fNeBMz/CCbb0mLbcscI8Gt5FET7JDPTQkMd7AdjBZEdb9Fn47ML5KQ0ii22C1BIcFmDeH0jCTiTEspxOmN62dN9BpkLFyF71YYj/ria15MFlDqNnNk2WYNERiaXUKtMo2TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716214597; c=relaxed/simple;
	bh=laZ+Qd+OmvRCAT/GbO+Cr6ZYOfkZHMiq9sxpX2cq4/E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R7ks4L6Srt524He3rGuX/r9IYiMch08QmktHGaoHr7RPU09EeO7vOC6+g45e6WJ+hfHT6RqQNusqn4AVF7qrVEaz91nj8oiXqsDME8XfAx6ScoWymvhMzqTgMnMrJQm5CimQC3GoAWMJjcwvw3RMC8OKBqQIosJYXneVwuS/lCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=karszRpn; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1716214585; x=1716819385; i=markus.elfring@web.de;
	bh=laZ+Qd+OmvRCAT/GbO+Cr6ZYOfkZHMiq9sxpX2cq4/E=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=karszRpnXf+0fDbqZ1pxNgcBHMy0wXdCz0V8kUhzGEqMR17rbk29N1+8xV3aEuY4
	 9XNho0YOERhGPPShpQvSX+QNX3Uz4RDnAPq05oN9cSrJZhJzJpa5x5DkQxFmZpOGf
	 CR145/ApBUB8IGbmqZgQklEHElkS/g7eQnOkL41fv5VaXT5YuSCRkTEzLvClQjZ4d
	 t3MLGF7YqAaMdPba/CucfhS7E00yr4NVbFQ/2GuPwKr1xxkz1DEnqVxszjEHeMcLV
	 uo49oK+m7FfD/TP3VPEVL0/Ir8YgOphh9VZ8jN21IJ+zom1BtACUPsvZASCTVAwdE
	 nodFFNYK+48lzMmZRA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.82.95]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1McIki-1shIAP20NA-00cWiT; Mon, 20
 May 2024 16:16:25 +0200
Message-ID: <6da2ddfb-02f3-43a7-89f4-60d1613dd5a4@web.de>
Date: Mon, 20 May 2024 16:16:24 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: KVM: SEV: Fix unused variable in guest request handling
To: Carlos Bilbao <carlos.bilbao.osdev@gmail.com>,
 Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
 kernel-janitors@vger.kernel.org, linux-coco@lists.linux.dev
Cc: LKML <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>
References: <20240513181928.720979-1-michael.roth@amd.com>
 <76413d53-4572-4a38-baff-8b01f6179c8e@web.de>
 <cfdf1ee1-41a3-46f1-9a71-ad09894ee931@gmail.com>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <cfdf1ee1-41a3-46f1-9a71-ad09894ee931@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:OZVLnVxUOQUY9+VoSosbb7O3HPgbOOzVRiAvFhhvgFbGDmCtjiJ
 h16xsqjwgrgZ9nKVp7LR+Rsn4S48Jv397uNOJYIWtVvj+RxuHBxUbMHhLDwBaRFoj/movw5
 za7ED5YpbwjyaDy5iGNYIPwk2CvpeqqLFI4AFADnpPy/fJuqazWK7r0dO7E8Ld16T0LYrZJ
 rkdIUhD4a4Ka22TCis4CA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:VuoImDyM+jw=;lCZXNa4RMjhVsyhrxwbpcvYzk6h
 4Y//926hKszc/v2JHc9lTXy8ZcXvqD/zRzO9E6V5cVAUHuAHEeprVfK4YsX1VE5w7eSfA67tY
 r6pzOCfpdHQtGnKQY/7UcXoNw83vK4Ee9ypZjtE4HKyabsUIy+2kfAnrwSsmX74GdW0h3iZDT
 RNtkE4CKdAQzQw2S/n7q93w68U7L9xRAqVuXRXG342u/n44ucZkh1IUiFFh8jkGoqWRNJu0x0
 DFPwfBTYrdsxKhRsbEwrDW2d6lTM9YVVy4MWXqv1Jn+wiCYay2vo/W0QwS+2zsqZbo4yLCYtM
 IghiCezqP2iA8p6s65Rp9Qs8/vXwSBI27Lr4tFf6Vo+VMWPiRgSLl73IkPB/4uWscGvX76GAU
 6TVigxZtKb441qG455VM9WZixUa8RPfRFq7xTjl99X7k7ZTI3pXJtqk6pwukNlKFhHgf7riCh
 ZeyVhEGsWczWyW2QIl75lApFsI3IjN9kziJYWhoPm4A3LA7LdgJRCkIfyykn6tUXULgFItiKq
 unOBaT3lzABdioswZo4xDgEN8iOYD3BAWHY1zCPyLSiH1ZdcJsiW6oggpzRUCE6XP1TGUtKM4
 153Gp1gGb+Awj4DPfiLvDf3rv7PaLVISK96AmVRNInGqJQY0l1l/02sfujmkkGJgFiE2+4MUq
 Acl76rfdjY9wmF5ImMrHxkVaKHmIgiuAdlT7Bi8wpc6rFxHSznyvWNrgHi1S4LOBMhCdn6z/P
 vAfWjtcLlvtByNSv7GF+/GGxWgtXajdTxRfmuvwBM+QYwMiYgIf8pgaNi26mSLD8ckAgPBAOz
 o4EWEhYylzmk0q3isHgJ7dtk2MBzXtL5tBo9OvrWQ6ygU=

>>> The variable 'sev' is assigned, but never used. Remove it.
>> Would it be a bit nicer to use the word =E2=80=9COmit=E2=80=9D instead =
of =E2=80=9CFix=E2=80=9D
>> in the summary phrase?
>
>
> I can find many instances of "Fix unused variable" in the history of the
> kernel:
=E2=80=A6
> but not a single "Omit unused variable" commit.

Some implementation details were fixed somehow because of a warning or err=
or message.
You would probably like to point the desire out in your summary phrase
to get rid of another bit of redundant source code.

Were any analysis tools involved in the discovery of corresponding change =
possibilities?

Regards,
Markus

