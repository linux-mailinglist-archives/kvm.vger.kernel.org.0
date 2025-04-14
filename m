Return-Path: <kvm+bounces-43264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45635A88A4F
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 19:49:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51D3C17B587
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 17:49:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08986274FD8;
	Mon, 14 Apr 2025 17:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="n/u42MxQ"
X-Original-To: kvm@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FDC19F416;
	Mon, 14 Apr 2025 17:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744652935; cv=none; b=fbz9KPzTsGiwcdpzuXidPt48GnJv4gNboP7/IwGCfBqKMId1XblUklrMc38/wfSE/+S5HxyHlU17Bl+9WdgsntyQ0ScSIMvZw5FS9t605FTdf2ojJHH3llhNNJcYMH26wCSYHpUwa/yo2fCO43sarYbjmwyoypKWEzR3JORfysM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744652935; c=relaxed/simple;
	bh=gfCPepPv1n0+P8DflWgted8Y49ZuVnKnzDVOsoE3ZXU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gnT4W669vhRuhRZlcKeIYTukLxFPAFLUQyHP3t3ycFcB3RigjIdli4CzUSa1WgEs5JWR8O6PAYVN2MwyGu695v6lcuNoXkgViUemQTJ5VKHoRFi9ZkS9pG6aht6LmiCZ8D6epF+YSQR3x66oGjjdtVbWveTfTgbaP4sdHaSIrBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=n/u42MxQ; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net B887B41E46
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1744652932; bh=pvnGwN5iYkeWp7KCnx9Dc3ojnv5bEwcQT3E4GnBFnjo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=n/u42MxQ8Xv7IPRczJ8nWCpiiWItbAPaYl+3H8lczCs1yhYXh90Zb5rN33y5FqfuB
	 VhhfUodvMfUzuoO3G+NmhGB62ZW7dlQkd7ozCAojn3EOyZ6NJfiqz7ujQDYH13OaVy
	 oa9UdswKZfKgil9yijr0/f7SQPJvOgd3EOgrvHEsCHF9kPC07zkdU4VTSm/jeKLxSj
	 ULKXogtB0B4GFzfauE23w7fTUxsYmf/DBDcIDsAbBUFZOj31SKm0+eIh/2Wtknt8Mo
	 Dnx9SYFnB0jdiDuurdQoOq6giFDpVCTjJqiFL84NLPNLkUQFlITpRpFAxPZVApab1J
	 Em0CHB1Bh1jgQ==
Received: from localhost (unknown [IPv6:2601:280:4600:2da9::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id B887B41E46;
	Mon, 14 Apr 2025 17:48:52 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Xin Li <xin@zytor.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com
Subject: Re: [PATCH v1 1/1] Documentation: kvm: Fix a section number
In-Reply-To: <747d9d7d-c500-46f0-b0f8-a157dc7524ad@zytor.com>
References: <20250414165146.2279450-1-xin@zytor.com>
 <87sema8yhy.fsf@trenco.lwn.net>
 <747d9d7d-c500-46f0-b0f8-a157dc7524ad@zytor.com>
Date: Mon, 14 Apr 2025 11:48:51 -0600
Message-ID: <87o6wy8who.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Xin Li <xin@zytor.com> writes:

> On 4/14/2025 10:05 AM, Jonathan Corbet wrote:
>>> -7.37 KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
>>> +7.42 KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
>>>   -------------------------------------
>> The fix seems fine but ... I have to ask ... do the section numbers buy
>> anything here?  We have a documentation system that can do nice
>> cross-references when needed, so I'm not sure that these numbers add
>> anything other than a bit of manual maintenance hassle.
>
> So you prefer to get rid of the section numbering?
>
> Looks it makes it simpler to maintain the documentation.  But that would
> anyway be another serial patches, right?

*I* would prefer it, but that call is really up to the KVM folks, not
me.  Their preference far outweighs mine on this ... I'm just venting :)

Thanks,

jon

