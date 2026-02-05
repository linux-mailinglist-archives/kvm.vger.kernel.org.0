Return-Path: <kvm+bounces-70357-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eB71NzvXhGlo5gMAu9opvQ
	(envelope-from <kvm+bounces-70357-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 18:45:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 81F13F61E4
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 18:45:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9B5B6309E925
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 17:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 601502FB997;
	Thu,  5 Feb 2026 17:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="rfV8I1XJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1E92EC55C;
	Thu,  5 Feb 2026 17:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770313209; cv=none; b=KHGeuI1df5t6+ly4ZdoAp90MEdNE8cGv9R7MRJgAAiC+hGilBIIqxS5knCLXsrlYrYP05IxvoVn77BxiqOl5QfyTVhUUM3soIf9879osS6Vma1Ef2E7ilQVRThZgcxy3Ie86z3L1Rf3dHDIPCyK/IM52Kp87T6RKz39l7DQVr0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770313209; c=relaxed/simple;
	bh=y9xuidujizu0Yqvw0fFAH0w/kDIXHN4IwvtdMkHrWpQ=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=PtmUSkIGimXCfg86IVaW1Tlf11AWfySQuuqh+o5uQ6fpBvjED39HfP+x7edawqyGttx9GJ17VPFbLuZVREvFLSxt63awcgWhfF+PWROD2K1OM3ZnXmxET5WnrJtgGK+oJJPZrEXD3i6jy7RHZw/pgBz0wsxxnqh/oIflvyq6siM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=rfV8I1XJ; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 615Hdkrw584153
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 5 Feb 2026 09:39:46 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 615Hdkrw584153
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770313187;
	bh=OFZIA4TMVVmvQv7ImCf/nTrja6phFzcIyFHWUzvb1Hg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=rfV8I1XJxHu1MJbWcFNaZXysa6WqrKYD2m/YrHDV/R2hQseNzqDaasPwsmpljAN1J
	 IvTeJjOQ7ulTIThCa476oMHpIaKHHxA9aTtAex8ihUbxwRCjJy8Q9ANes1BAWZcncq
	 Hghk6gGGCbdcllSS+rHgCP2L9L2VUIHVe5ShIP0VUL5Z5MzGNRh76D6LqtieUUeIwm
	 hv5qtkX4DQ4iS/9pTIzV1n4rsFXPg4oLaFnsIEZWAIKrYImoMwigkalBeeA+35SSFz
	 Ws37i2NRMamcCKQDLhhajnHjVXhq1l9SvUP6ARR/U4EvKPFjLeggRjbknqMb2hX1tc
	 ERuw9HUUTGIzw==
Date: Thu, 05 Feb 2026 09:39:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Dave Hansen <dave.hansen@intel.com>, Nikunj A Dadhania <nikunj@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        thomas.lendacky@amd.com
CC: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
        xin@zytor.com, seanjc@google.com, pbonzini@redhat.com, x86@kernel.org,
        jon.grimm@amd.com, stable@vger.kernel.org
Subject: Re: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
User-Agent: K-9 Mail for Android
In-Reply-To: <02df7890-83c2-4047-8c88-46fbc6e0a892@intel.com>
References: <20260205051030.1225975-1-nikunj@amd.com> <9c8c2d69-5434-4416-ba37-897ce00e2b11@intel.com> <02df7890-83c2-4047-8c88-46fbc6e0a892@intel.com>
Message-ID: <19388254-8FD4-41F4-A55C-DA7D2E182332@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2026012301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70357-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[zytor.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hpa@zytor.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 81F13F61E4
X-Rspamd-Action: no action

On February 5, 2026 9:20:20 AM PST, Dave Hansen <dave=2Ehansen@intel=2Ecom>=
 wrote:
>On 2/5/26 08:10, Dave Hansen wrote:
>> Shouldn't we flip the FRED CR4 bit _last_, once all the MSRs are set up=
?
>> Why is it backwards in the first place? Why can't it be fixed?
>
>Ahhh, it was done by CR4 pinning=2E It's the first thing in C code for
>booting secondaries:
>
>static void notrace __noendbr start_secondary(void *unused)
>{
>        cr4_init();
>
>Since FRED is set in 'cr4_pinned_mask', cr4_init() sets the FRED bit far
>before the FRED MSRs are ready=2E Anyone else doing native_write_cr4()
>will do the same thing=2E That's obviously not what was intended from the
>pinning code or the FRED init code=2E
>
>Shouldn't we fix this properly rather than moving printk()'s around?
>
>One idea is just to turn off all the CR-pinning logic while bringing
>CPUs up=2E That way, nothing before:
>
>	set_cpu_online(smp_processor_id(), true);
>
>can get tripped up by CR pinning=2E I've attached a completely untested
>patch to do that=2E
>
>The other thing would be to make pinning actually per-cpu:
>'cr4_pinned_bits' could be per-cpu and we'd just keep it empty until the
>CPU is actually booted and everything is fully set up=2E
>
>Either way, this is looking like it'll be a bit more than one patch to
>do properly=2E
We could initialize the FRED MSRs much earlier, like we do during S3 resum=
e=2E

