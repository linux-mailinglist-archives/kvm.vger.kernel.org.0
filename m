Return-Path: <kvm+bounces-56592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64EC0B3FECB
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 13:58:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 72E757B5951
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 11:53:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA70732F771;
	Tue,  2 Sep 2025 11:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="oBsrLAWq"
X-Original-To: kvm@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A842882D3;
	Tue,  2 Sep 2025 11:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756813701; cv=none; b=hbiolXii6saTfmnDLIjWJq5kky6wcepLw9d30X45ybTAuLYpUtMRGr/wtHkhENAJ/3YjFBelPlKJQse0Uo5XajqmTjTVxGTF176uG5dx+TvK2LBlmTzBkBQDF/RABAlKU3iT4WYcpjRzuevr6IBfSdudRCmtjS4MnfNFtPneqPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756813701; c=relaxed/simple;
	bh=wi28NWkLhlLVtrAYd2q+cARxa2gFj027XCruigNiYQc=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=U/uw5aVWUZuXKgQLebof6wyACscNtQAAFmd2RxxGNYvXLg41lj0IxNkueG0XP6HYeKDFbe01hWUS5PKvB5rmOXqzSb4FV6lRbX23tGJLFZn2KZPzDkkUrWaCZoCNj2Qk0LCQlJ69nMUUClVk1HX90d/DLslpRGK9L56ZStsM95o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=oBsrLAWq; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1756813681; x=1757418481; i=markus.elfring@web.de;
	bh=krop/5qf7CHDlNplCB0N+8dhDbZff51hahJhyV1sUdg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=oBsrLAWqAGY2TXHo0CrZiArQdoAtTmnQfzFnvNW5foXAkKLS5IuK9tzWXna/yPyP
	 Ru7jTzluXRzAth2svnjRzJV3IFlZxWu/rNeGfCH+eqof+3WIhTc7Qp09lab+Qu5Wz
	 GqmoaUIIWyylnCMAVl8oaklV2p+dqImlvFvqApRhI8YTG1To/B+Hegb5GjiNu6qKf
	 Sejs6NepwM8pdEEaj72Ywd6Mtm7cbQhZNiUA466aP6IbDLmaL2qIxE7LV1BQ7ZWBp
	 RTv2G3dg4IzwTI4QmaBp1PTL22yAraBz/YpURRZknAVPT1A+GR8l6psZ8mrp23nei
	 8jdx4D21+YhcPOZyZw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.184]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MNfUF-1v8RMx3iqh-00N7j1; Tue, 02
 Sep 2025 13:48:00 +0200
Message-ID: <2adf26f3-c40a-4244-99ac-6544a0fb1d06@web.de>
Date: Tue, 2 Sep 2025 13:47:55 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Miaoqian Lin <linmq006@gmail.com>, kvm@vger.kernel.org
Cc: stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
 Longfang Liu <liulongfang@huawei.com>,
 Shameer Kolothum <shameerkolothum@gmail.com>,
 Yishai Hadas <yishaih@nvidia.com>
References: <20250901081809.2286649-1-linmq006@gmail.com>
Subject: Re: [PATCH] hisi_acc_vfio_pci: Fix reference leak in
 hisi_acc_vfio_debug_init
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250901081809.2286649-1-linmq006@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:PGTxsbfNU/HMaevgrLZ7u/hBYigI89OeEuLHYNbahT8aQM7Fk9o
 wFF370pnA0ORLOmjyNoS3EH/D5C/eC8Ejk8WFp1Nlsh+cYNDo0qeH5N6UIPgzLjmTWYiazI
 NiImNM4ScwyTtcricxplL5j7SSV+uD4wvEyil0nmthZJRO7rOV6zyJHNUGiOkXjs2hDXGrv
 Xd4EOJmXQGNmv2OE/9q8A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:tbtoTNs/iPA=;dd/97DRcdR8RQU1GJsP7hY715MX
 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
 t+9LJwB8KVlM0a/r7sH

> The debugfs_lookup() function returns a dentry with an increased reference
> count that must be released by calling dput().

* See also:
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.17-rc4#n94

* Would you like to complete the object clean-up by using a goto chain?

* How do you think about to increase the application of scope-based resource management?
  https://elixir.bootlin.com/linux/v6.17-rc4/source/include/linux/pci.h#L1208

* Would it be helpful to append parentheses to the function name
  in the summary phrase?


Regards,
Markus

