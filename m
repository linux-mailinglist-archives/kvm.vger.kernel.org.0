Return-Path: <kvm+bounces-70597-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iMsgO/baiWnfCgAAu9opvQ
	(envelope-from <kvm+bounces-70597-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 14:02:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 33C7B10F58E
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 14:02:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5BEBB306177B
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 11:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A2F0372B40;
	Mon,  9 Feb 2026 11:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="byq8Secf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jQFFoTgU";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="byq8Secf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jQFFoTgU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E16371056
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 11:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770637415; cv=none; b=gjps3Odc+r2eMPNZjNm1PI5gwDlzKEAUPFDvozETXspigrtxTN05lmU4aK8kB0XOsCTR/9K72ozJeDa9Yrl1+i/jm03q6A9Ml9TtTti2Seg1MIBYiLvFpZXerZ1N0Lzm1zTqjaPPetH3Sn2o0+tpiqK+SX89uvQ2jGAk2hPUANc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770637415; c=relaxed/simple;
	bh=ZlCsJRJJAfS5TjFdAY3MUHqS7ewIBNYYOaA7yaL2R+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S9NLNrcNcSLHSpPrl9HSobBfAZBXaP8yWWWDKLUBSRC+/CiMpzyUIu6SqrhoIq48AsbrD+8EBrFCuT23ef+OQo3s7XVxY2wCkh024a+VipdutB683+Q92wXyCz2tyq4xhEkakOQ6UQR9zgC2FzejBSz1On3pGPh/7ZheumNFs64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=byq8Secf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jQFFoTgU; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=byq8Secf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jQFFoTgU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CBAEC3E6F5;
	Mon,  9 Feb 2026 11:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770637413; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3a3kIicM5sBZ4RGa33aXgI4s/G8RklC2RL/Gfa+ujCw=;
	b=byq8Secfa3LGmBrWkiaVvUoijLkjzOqDwbi12IBZ0XgZ47kWWORqOE6/9wkRO5djDb0bXB
	8dV65F00ezR5iooWYrJu3sMn3HK95bdJ0gYVRXlfAOmortAsLUJY/oCUoRoUUq6g6aSLJs
	cAOzpj2gY1hoRtCIdAp0bExH0eS5E28=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770637413;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3a3kIicM5sBZ4RGa33aXgI4s/G8RklC2RL/Gfa+ujCw=;
	b=jQFFoTgUGecrmE012TYG37NJbOL5yIy/M/sUhAa3ZNy6hR9CeOYpCxWz5hhzcRdmFlrnJi
	UzhqgPGiMw4E7cCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770637413; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3a3kIicM5sBZ4RGa33aXgI4s/G8RklC2RL/Gfa+ujCw=;
	b=byq8Secfa3LGmBrWkiaVvUoijLkjzOqDwbi12IBZ0XgZ47kWWORqOE6/9wkRO5djDb0bXB
	8dV65F00ezR5iooWYrJu3sMn3HK95bdJ0gYVRXlfAOmortAsLUJY/oCUoRoUUq6g6aSLJs
	cAOzpj2gY1hoRtCIdAp0bExH0eS5E28=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770637413;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3a3kIicM5sBZ4RGa33aXgI4s/G8RklC2RL/Gfa+ujCw=;
	b=jQFFoTgUGecrmE012TYG37NJbOL5yIy/M/sUhAa3ZNy6hR9CeOYpCxWz5hhzcRdmFlrnJi
	UzhqgPGiMw4E7cCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2AAC33EA63;
	Mon,  9 Feb 2026 11:43:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sju4B2XIiWmHSQAAD6G6ig
	(envelope-from <clopez@suse.de>); Mon, 09 Feb 2026 11:43:33 +0000
Message-ID: <2c59c666-9f6a-460d-8582-55af31ee302d@suse.de>
Date: Mon, 9 Feb 2026 12:43:32 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: synthesize TSA CPUID bits via SCATTERED_F()
To: Binbin Wu <binbin.wu@linux.intel.com>, seanjc@google.com
Cc: bp@alien8.de, kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
 <linux-kernel@vger.kernel.org>
References: <20260208164233.30405-1-clopez@suse.de>
 <3afa5004-412a-4ab8-b0b9-46bd3982438d@linux.intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>
In-Reply-To: <3afa5004-412a-4ab8-b0b9-46bd3982438d@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.de:+];
	TAGGED_FROM(0.00)[bounces-70597-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clopez@suse.de,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.de:mid,suse.de:dkim]
X-Rspamd-Queue-Id: 33C7B10F58E
X-Rspamd-Action: no action

Hi,

On 2/9/26 11:02 AM, Binbin Wu wrote:
> 
> 
> On 2/9/2026 12:42 AM, Carlos López wrote:
>> KVM incorrectly synthesizes TSA_SQ_NO and TSA_L1_NO when running
>> on AMD Family 19h CPUs by using SYNTHESIZED_F(), which unconditionally
>> enables features for KVM-only CPUID leaves (as is the case with
>> CPUID_8000_0021_ECX), regardless of the kernel's synthesis logic in
>> tsa_init(). This is due to the following logic in kvm_cpu_cap_init():
>>
>>     if (leaf < NCAPINTS)
>>         kvm_cpu_caps[leaf] &= kernel_cpu_caps[leaf];
> 
> Since TSA_SQ_NO and TSA_L1_NO are defined in CPUID_8000_0021_ECX, and
> CPUID_8000_0021_ECX > NCAPINTS, the code above doesn't take effect.

I should have explained it better, but that is precisely what I meant.
Since the &= never takes place, kvm_cpu_cap_features always has the bits
set. In other words: the branch always evaluates to false for KVM-only
CPUID leaves, so the bits are always set.

> The code makes the two bits set unconditionally is:
>     SYNTHESIZED_F() sets kvm_cpu_cap_synthesized
> and later
>     kvm_cpu_caps[leaf] &= (raw_cpuid_get(cpuid) |
>                            kvm_cpu_cap_synthesized);
> 
>>
>> This can cause an unexpected failure on Family 19h CPUs during SEV-SNP
>> guest setup, when userspace issues SNP_LAUNCH_UPDATE, as setting these
>> bits in the CPUID page on vulnerable CPUs is explicitly rejected by SNP
>> firmware.
>>
>> Switch to SCATTERED_F(), so that the bits are only set if the features
>> have been force-set by the kernel in tsa_init(), or if they are reported
>> in the raw CPUID.
> 
> When you switch to SCATTERED_F(), if the two bits are not in raw cpuid, the two
> bits will not be set to kvm_cpu_caps[CPUID_8000_0021_ECX], regardless the
> setting initialized in tsa_init().

Yes, I think you're right.

> TSA_SQ_NO and TSA_L1_NO are conditional kernel synthesis bits, should
> SYNTHESIZED_F() check that the related bit is actually synthesized into
> boot_cpu_data before setting to kvm_cpu_cap_synthesized?

Right, I thought this is what SCATTERED_F() already did, but I missed
that there is the logical AND with the raw CPUID later. See the diff in
my reply to Jim Mattson, I think that is what you propose as well.

