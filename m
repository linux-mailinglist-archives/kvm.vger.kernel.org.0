Return-Path: <kvm+bounces-29256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 544C39A5D89
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 09:50:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1559E281697
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 07:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66D0B1E102B;
	Mon, 21 Oct 2024 07:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="ZWdyu/ez"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-22.smtpout.orange.fr [80.12.242.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915041E0DE6;
	Mon, 21 Oct 2024 07:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729497013; cv=none; b=ouCfoXdV6aGMs+in7as7TINbj+8rD7QnRqb+njRo423P44EH3UeFutkk0G3GcnXyltuDyiID3BbPkrmHL8AysqM7ba4Am+kZmb7g5ORLb16S+1w6djlva654Xc883C4NIgV1bAqvOiYgbZQ6umFCcQ3lpyURlEnQfJqOTA/G1S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729497013; c=relaxed/simple;
	bh=XnT93t9gRI+nxE+bt78pJm7Y0qFs241Nf7r6GTYJmo8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MaG74LK11V+sEAuLa8Q8KMSXFClUP25gJObDAvHEj54jzCRoff70C5bXI+ZOlXYyziusizgfDZs6qaVkGwBGzPqbbpYrkYT2Hih/tLKZXHcIXY+hGI2X5sJuVrMEKb7TlgF79ypoN18V7ftJBUfICqzuoZn2SEKIC2rBz9QPDN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=ZWdyu/ez; arc=none smtp.client-ip=80.12.242.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from [192.168.1.37] ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id 2n9ntL06gjsSz2n9ntfpEX; Mon, 21 Oct 2024 09:48:53 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1729496933;
	bh=Eb/kMiEWGo00zh4rVI7VXlwQ/NqeEqhpavG4zbOM3UM=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=ZWdyu/ezYh4Srx9uTDE61kWjfxE0Qg5364xgp+6Dysh48jJ5+RGRAKWT4q99gyqqf
	 0YtR+wouWC7GUSQhe5xBAzdR4rOyy0gtCg476aIHa9ZiPorTiHxm093qhpfvaZoUzE
	 bHkCp73+YUAFZt7qBcZVRTdWqqF3fi85KIBJuQMMIirPLpWhuv/1u61taIoHpWPU8G
	 eWBZybVG85L8Pp7aQUQikug3G0Gg54lWA28wMCbP2tavYPjvAYFuZ3d7EVVs9GnCL8
	 /qoE0G0h7euFkK+AGkfSDh1JTAR1j8HyzevwOohbsQh2Nv3rMXS/6cG9F5oqig+Czi
	 e+ihO0pfj3xVw==
X-ME-Helo: [192.168.1.37]
X-ME-Auth: bWFyaW9uLmphaWxsZXRAd2FuYWRvby5mcg==
X-ME-Date: Mon, 21 Oct 2024 09:48:53 +0200
X-ME-IP: 90.11.132.44
Message-ID: <5350829a-d30f-41b4-82db-8ed822e13d09@wanadoo.fr>
Date: Mon, 21 Oct 2024 09:48:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 01/13] x86/sev: Carve out and export SNP guest
 messaging init routines
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241021055156.2342564-1-nikunj@amd.com>
 <20241021055156.2342564-2-nikunj@amd.com>
Content-Language: en-US, fr-FR
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20241021055156.2342564-2-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 21/10/2024 à 07:51, Nikunj A Dadhania a écrit :
> Currently, the SEV guest driver is the only user of SNP guest messaging.
> All routines for initializing SNP guest messaging are implemented within
> the SEV guest driver. To add Secure TSC guest support, these initialization
> routines need to be available during early boot.
> 
> Carve out common SNP guest messaging buffer allocations and message
> initialization routines to core/sev.c and export them. These newly added
> APIs set up the SNP message context (snp_msg_desc), which contains all the
> necessary details for sending SNP guest messages.
> 
> At present, the SEV guest platform data structure is used to pass the
> secrets page physical address to SEV guest driver. Since the secrets page
> address is locally available to the initialization routine, use the cached
> address. Remove the unused SEV guest platform data structure.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---

...

> +static inline bool is_vmpck_empty(struct snp_msg_desc *mdesc)
> +{
> +	char zero_key[VMPCK_KEY_LEN] = {0};

Nitpick: I think this could be a static const.

> +
> +	if (mdesc->vmpck)
> +		return !memcmp(mdesc->vmpck, zero_key, VMPCK_KEY_LEN);
> +
> +	return true;
> +}

...

