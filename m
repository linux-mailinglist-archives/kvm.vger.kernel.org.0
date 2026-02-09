Return-Path: <kvm+bounces-70596-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4NpUCZreiWkaDAAAu9opvQ
	(envelope-from <kvm+bounces-70596-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 14:18:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C24DC10F8C9
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 14:18:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7CB973038AC9
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 11:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62F20371072;
	Mon,  9 Feb 2026 11:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oV99INbT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OVqaJ/bI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oV99INbT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OVqaJ/bI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DACF36606D
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 11:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770637206; cv=none; b=LnajLBqYfufw3h4HeBnPMhfe9D9WozwzTDApElS3WFoxndbJi8T5stB83pyyiUt+PIm+vCpIxea9nHP/S/FhJG7JaBMb9UpjsGbxvVETU+M6S/Dsau2gxfxwR4FhrLlNc+VnN5XcaE9RH/d6PmdT3wawnNZK8YwELKnIchtib/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770637206; c=relaxed/simple;
	bh=aYjEeCkMZHiuC5R4skkZ7Q04duQgzS9O7uRFGOAxUnE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VilKSHqy48x1JUzK+SH70u6A6870JtuZoAGmJMbeIQMworSXTy4Rmxv6S1N+f2uA9kTJUssvIcTADCJo00ABWyOmdnoPMAFgYVtvqLY37RFBFPrD8xdsxHT+z4Ift9edmvezhMkqRCHZMGXyQaqkgQ7W6jpOzO2ZMEqH/8sjAKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oV99INbT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OVqaJ/bI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oV99INbT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OVqaJ/bI; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5A6A15BD2B;
	Mon,  9 Feb 2026 11:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770637204; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EFvENNphJJ02ND6rKpiGDYtX6p1T1DdwkEQYwe3cuOA=;
	b=oV99INbTOGLH52qRELpVbDI1t/HeVhWE7JKpyv8MlkdGbttpdwgBw5T5sbfos3mawHZXze
	S+UvYIIkLjABHJYqW0842UZQCIkJe7kpPn99rVKKTgrme6nZ2E8Uo8VRXkbjKi7U+ObolY
	vRjcQpZvIdQ8tqwa16VYvuIEbhdEUe4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770637204;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EFvENNphJJ02ND6rKpiGDYtX6p1T1DdwkEQYwe3cuOA=;
	b=OVqaJ/bI+/WqS6BLF0rjwqVrci4G1NhU/woDtLBDQMXQ4JpDXCe+frnfu3a78VjT/pZbKJ
	G256pzszEWMRVhCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oV99INbT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="OVqaJ/bI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770637204; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EFvENNphJJ02ND6rKpiGDYtX6p1T1DdwkEQYwe3cuOA=;
	b=oV99INbTOGLH52qRELpVbDI1t/HeVhWE7JKpyv8MlkdGbttpdwgBw5T5sbfos3mawHZXze
	S+UvYIIkLjABHJYqW0842UZQCIkJe7kpPn99rVKKTgrme6nZ2E8Uo8VRXkbjKi7U+ObolY
	vRjcQpZvIdQ8tqwa16VYvuIEbhdEUe4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770637204;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EFvENNphJJ02ND6rKpiGDYtX6p1T1DdwkEQYwe3cuOA=;
	b=OVqaJ/bI+/WqS6BLF0rjwqVrci4G1NhU/woDtLBDQMXQ4JpDXCe+frnfu3a78VjT/pZbKJ
	G256pzszEWMRVhCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AF7123EA63;
	Mon,  9 Feb 2026 11:40:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id glItKJPHiWnSEgAAD6G6ig
	(envelope-from <clopez@suse.de>); Mon, 09 Feb 2026 11:40:03 +0000
Message-ID: <e19b9666-b224-4fbd-92c9-82c712916a07@suse.de>
Date: Mon, 9 Feb 2026 12:40:03 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: synthesize TSA CPUID bits via SCATTERED_F()
To: Jim Mattson <jmattson@google.com>, Borislav Petkov <bp@alien8.de>
Cc: seanjc@google.com, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
 <linux-kernel@vger.kernel.org>, Babu Moger <bmoger@amd.com>
References: <20260208164233.30405-1-clopez@suse.de>
 <20260208182849.GAaYjV4Vh8i0kznTEK@fat_crate.local>
 <CALMp9eQmwsND7whnvVof1i=OsCdo6wcwBWyDRwS3Ud69WkKf-g@mail.gmail.com>
 <20260208211342.GBaYj8hhtYM-lYfq-X@fat_crate.local>
 <CALMp9eSVB=iRec2A0tmRzkTBa9zz4BVS8Lu79vUuRPrTawYFcQ@mail.gmail.com>
From: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>
Content-Language: en-US
In-Reply-To: <CALMp9eSVB=iRec2A0tmRzkTBa9zz4BVS8Lu79vUuRPrTawYFcQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.51
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
	TAGGED_FROM(0.00)[bounces-70596-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clopez@suse.de,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,alien8.de:email]
X-Rspamd-Queue-Id: C24DC10F8C9
X-Rspamd-Action: no action

Hi,

On 2/9/26 6:48 AM, Jim Mattson wrote:
> On Sun, Feb 8, 2026 at 1:14 PM Borislav Petkov <bp@alien8.de> wrote:
>>
>> On Sun, Feb 08, 2026 at 12:50:18PM -0800, Jim Mattson wrote:
>>>> /*
>>>>  * Synthesized Feature - For features that are synthesized into boot_cpu_data,
>>>>  * i.e. may not be present in the raw CPUID, but can still be advertised to
>>>>  * userspace.  Primarily used for mitigation related feature flags.
>>>>                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>>  */
>>>> #define SYNTHESIZED_F(name)
>>>>
>>>>> +             SCATTERED_F(TSA_SQ_NO),
>>>>> +             SCATTERED_F(TSA_L1_NO),
>>>>
>>>> And scattered are of the same type.
>>>>
>>>> Sean, what's the subtle difference here?
>>>
>>> SYNTHESIZED_F() sets the bit unconditionally. SCATTERED_F() propagates
>>> the bit (if set) from the host's cpufeature flags.
>>
>> Yah, and I was hinting at the scarce documentation.
>>
>> SYNTHESIZED_F() is "Primarily used for mitigation related feature flags."
>> SCATTERED_F() is "For features that are scattered by cpufeatures.h."
> 
> Ugh. I have to rescind my Reviewed-by. IIUC, SCATTERED_F() implies a
> logical and with hardware CPUID, which means that the current proposal
> will never set the ITS_NO bits.

Right, I see what you mean now. SCATTERED_F() will set kvm_cpu_caps
correctly, but then this will clear the bits, because
kvm_cpu_cap_synthesized is now 0:

    kvm_cpu_caps[leaf] &= (raw_cpuid_get(cpuid) |
        kvm_cpu_cap_synthesized);

So to me it seems like SYNTHESIZED_F() is just wrong, since it always
enables bits for KVM-only leafs. So how about the following (I think
Binbin Wu suggests this in his other email):

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 819c176e02ff..5e863e213f54 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -769,7 +769,8 @@ do {                                                                        \
  */
 #define SYNTHESIZED_F(name)                                    \
 ({                                                             \
-       kvm_cpu_cap_synthesized |= feature_bit(name);           \
+       if (boot_cpu_has(X86_FEATURE_##name))                   \
+               kvm_cpu_cap_synthesized |= feature_bit(name);           \
        F(name);                                                \
 })


