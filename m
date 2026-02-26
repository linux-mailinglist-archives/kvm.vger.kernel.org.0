Return-Path: <kvm+bounces-72023-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OFuPAHlyoGlZjwQAu9opvQ
	(envelope-from <kvm+bounces-72023-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:19:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 597CE1A9FE3
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:19:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0333B31BDE67
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47DEF44B689;
	Thu, 26 Feb 2026 15:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QjLld+Np"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD1242883D
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 15:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121515; cv=none; b=sYc9QPpD6N+jH2UZ3RzmYUYwwc6u4HU/Lktkl6xiIuGPaIb6NRj5dvmiLgl47+aQVBYULA+zDJkoTjdX24rwYp6tIAJiAc7w0eI3ORpzcG55SAQ3I6TP5nvMPOnw0NTyw+z15K00XMym+lb1n/CcCgxQP0l7ehCbWRT8Coje8nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121515; c=relaxed/simple;
	bh=ebhzs1f9leTJhb7vJ9DTLKifZg7rjye2J7sNivsOQ3s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ms2CU0ViEdZ19EO4kkV8wf9ePnHvtnenrLFGpKAAAuTSyoCByVp4mPSIoYK1e0+9Pke8s1Y3jVmb1+OBPn+M9r84sWgyI4pAkVxtK3E1jROHDPw//fl96AtJq+VYY6q51gYcR3Wr7Td2iXWKxw3QPKVfa56U4NgDD53Vc7Vj1Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QjLld+Np; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E54EC19423;
	Thu, 26 Feb 2026 15:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772121515;
	bh=ebhzs1f9leTJhb7vJ9DTLKifZg7rjye2J7sNivsOQ3s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QjLld+NpH9eFYRonODSfV2PKLWHIQ1yst/ZN2P3geM9ro/JrTctO1PqhDvnZw8kN0
	 WCVSX8Qkxk01hWjaMT3qKYjZ1x9+nBcL9/KQfflgCR7p/ldGDDAfI6pHu0p1oTdTwj
	 At5XLv2zS9oZhVTQYZBjMmFIAzCNcSaQcXl6dHyR7beu+l+Jfi471mkmZ/FTVC2jye
	 VbcFtKPxFjQ7xbHaCraHT9UnvsUpCYBxiFBBCv3/2mHS1DYnROWG4VbZ+HD/4mDDiD
	 2mU5/12G8TTqnyF/Et0OOncFWbs3mW1S5ap+TAQglH0IPqNEn6FJSdC5U63tVKRz8D
	 ECMHYwAj3SaQA==
Message-ID: <160c548f-7839-486e-9ee2-637dcb156bb3@kernel.org>
Date: Thu, 26 Feb 2026 16:58:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/15] memory: drop
 RamDiscardListener::double_discard_supported
To: marcandre.lureau@redhat.com, qemu-devel@nongnu.org
Cc: Ben Chaney <bchaney@akamai.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Alex Williamson <alex@shazbot.org>,
 Fabiano Rosas <farosas@suse.de>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
 Mark Kanda <mark.kanda@oracle.com>
References: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
 <20260226140001.3622334-3-marcandre.lureau@redhat.com>
From: David Hildenbrand <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20260226140001.3622334-3-marcandre.lureau@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72023-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[david@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 597CE1A9FE3
X-Rspamd-Action: no action

On 2/26/26 14:59, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> This was never turned off, effectively some dead code.
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> Reviewed-by: Cédric Le Goater <clg@redhat.com>
> ---

Great, thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David


