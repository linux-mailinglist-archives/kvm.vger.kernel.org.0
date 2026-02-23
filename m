Return-Path: <kvm+bounces-71521-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SLCdLeaenGnPJgQAu9opvQ
	(envelope-from <kvm+bounces-71521-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 19:39:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B707217B9DF
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 19:39:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A0649302C76B
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 18:39:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D67D9366DD2;
	Mon, 23 Feb 2026 18:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="GP8hxvu0"
X-Original-To: kvm@vger.kernel.org
Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A8634107C
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 18:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771871971; cv=none; b=ts+KgQTIiVgUqKS3+rmwLgb1oKsuQnbN3g/tLSuJ8BTp7n8decuz2lAMolL0uuOefWy8Psyk7h1nvl7Bk9QWJ/nnTxDanH1pFmUYeu02grYStYcLkSFELFJxVe6z+A6Vg50C6fAFtOGgjr+yoSIww1b1+WoPlaYZghAxFoVWPBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771871971; c=relaxed/simple;
	bh=aPbuXDWVTlTr4MTV+J1z5na0bvWZqujDr8myGZRL6u0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QsEyzmo+r0SUqzMaGFL/JXD176+FIw/PwbE0pE7xMUAaYmOCBZrw71HvX9fqqQIKgtRxMepZP4Fyb7g1ynGyFDqFL15fnsIqIWNo3aXRORBXAETB8QrIgxzVH8LYTO1Je7xpxM3bXhCr/JlM9GjdIXxDSxt5oRrPqNHxp36jrNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=GP8hxvu0; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Received: from eig-obgw-6004b.ext.cloudfilter.net ([10.0.30.210])
	by cmsmtp with ESMTPS
	id uZTAvAtLxipkCuaq3vRmPX; Mon, 23 Feb 2026 18:39:23 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id uaq2vfdI9K8vzuaq2via4i; Mon, 23 Feb 2026 18:39:22 +0000
X-Authority-Analysis: v=2.4 cv=cJDgskeN c=1 sm=1 tr=0 ts=699c9edb
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=k5Y5iPg+dmTXVWgYE/XtfQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=7T7KSl7uo7wA:10 a=cm27Pg_UAAAA:8
 a=FHDQm2CFppvGkXip7MwA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=2aFnImwKRvkU0tJ3nQRT:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=taVw0B+z5tsgngiAZBQo/LxSMSdHPHO1dbCTb0UWDZ4=; b=GP8hxvu0JEWG6Ydl+BN8EUaMik
	/Q/juWmy47Ut/Utyr02oSxVbdftQQEZGg7lzMSvYkpBmPYCOKHyXN2F2WdqWd3U7arxIpRgBX8u9t
	uS2Jl61ZcfgZdA2LS9rglqYE3r55Rcl1orTjq5amI7H2+tFOxPMbg4bx8ODS2E5AxxQQht2t4bvmt
	vLABfz22UQCX970FO0IQz666BErT8vE7pteOReXfw75Zi0301dFPtnXBHuqxUrvsmyIqCmnUQgOcF
	cGK9PF0fqE89VgCbEFjJ1MnAt/i90w9oJkHdY+6Y3EIwxyTX3Cz6LWxS1DoS1MFPJ0uARRPyVIL/e
	C9upAmpQ==;
Received: from [177.238.16.13] (port=50750 helo=[192.168.0.104])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.99.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1vuaq1-00000000GtO-0dHq;
	Mon, 23 Feb 2026 12:39:21 -0600
Message-ID: <da02314c-e6da-4d9e-a2c8-cd3ee096bc0c@embeddedor.com>
Date: Mon, 23 Feb 2026 12:38:07 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] treewide: uapi: Replace zero-length arrays with
 flexible-array members
To: David Woodhouse <dwmw2@infradead.org>, keescook@chromium.org
Cc: daniel@iogearbox.net, gustavoars@kernel.org, jgg@ziepe.ca,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <aaa7ac93db25459fa5a629d0da5abf13e93d8301.camel@infradead.org>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <aaa7ac93db25459fa5a629d0da5abf13e93d8301.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 177.238.16.13
X-Source-L: No
X-Exim-ID: 1vuaq1-00000000GtO-0dHq
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.0.104]) [177.238.16.13]:50750
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 2
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfD3YtrnDVHp9i6g5w+l7p9shhAG3YMIU9ktIxXBChnk//xZAFE6urhf794o4GyCH5qjK/tZIeLcm9u2G1kk6mdHeTD+d8C3R97/Z2VEEkb6tWkt4D4yW
 vNzYT9H2SkhaYHUyA2WkcsMjo4z1C2062TMwo9ovE3uIP5yfBmRnQkiH5gD8rsZTsLC4HRBIW4us/JohSzNaadT41Sf3ImWyJBQ=
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_REJECT(1.00)[embeddedor.com:s=default];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	HAS_X_SOURCE(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71521-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[embeddedor.com];
	DKIM_TRACE(0.00)[embeddedor.com:-];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	HAS_X_ANTIABUSE(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gustavo@embeddedor.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.997];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B707217B9DF
X-Rspamd-Action: no action



On 2/23/26 23:28, David Woodhouse wrote:
> On 2022-07-28 at 10:54:58 -0700, Kees Cook <keescook@chromium.org> wrote:
>> The issue here seems to be a collision between "unknown array size"
>> and known sizes:
>>
>> struct bpf_lpm_trie_key {
>>          __u32   prefixlen;      /* up to 32 for AF_INET, 128 for AF_INET6 */
>>          __u8    data[0];        /* Arbitrary size */
>> };
>>
>> struct lpm_key {
>> 	struct bpf_lpm_trie_key trie_key;
>> 	__u32 data;
>> };
>>
>> This is treating trie_key as a header, which it's not: it's a complete
>> structure. :)
>>
>> Perhaps:
>>
>> struct lpm_key {
>>          __u32 prefixlen;
>>          __u32 data;
>> };
>>
>> I don't see anything else trying to include bpf_lpm_trie_key.
> 
> What was the eventual conclusion here?
> 
> These changes broke userspace compilation, because a *lot* of these
> structures ending with VLAs are very much used as headers.
> 
> QEMU does it, for example...
> 
> uint64_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t index)
> {
>      struct {
>          struct kvm_msrs info;
>          struct kvm_msr_entry entries[1];
>      } msr_data = {};
> 
> 
> ... which works in C but not in C++, which gives an error I can't work
> out how to avoid.
> 
> Am I missing something, or did we break our userspace headers for C++
> and make them C-only?
> 
>   $ cat test_kvm.cpp
> #include <cstdlib>
> #include <asm/kvm.h>
> 
> struct msr_data {
> 	struct kvm_msrs info;
> 	struct kvm_msr_entry entries[1];
> };

Something like this should eventually land:

diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 7ceff6583652..295b2a54b25d 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -192,11 +192,14 @@ struct kvm_msr_entry {
         __u64 data;
  };

-/* for KVM_GET_MSRS and KVM_SET_MSRS */
-struct kvm_msrs {
+struct kvm_msrs_hdr {
         __u32 nmsrs; /* number of msrs in entries */
         __u32 pad;
+};

+/* for KVM_GET_MSRS and KVM_SET_MSRS */
+struct kvm_msrs {
+       struct kvm_msrs_hdr;
         struct kvm_msr_entry entries[];
  };

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index fdec90e85467..a354ee1ef359 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -261,6 +261,8 @@ CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
         -fno-builtin-memcmp -fno-builtin-memcpy \
         -fno-builtin-memset -fno-builtin-strnlen \
         -fno-stack-protector -fno-PIE -fno-strict-aliasing \
+       -Wno-microsoft-anon-tag \
+       -fms-extensions \
         -I$(LINUX_TOOL_INCLUDE) -I$(LINUX_TOOL_ARCH_INCLUDE) \
         -I$(LINUX_HDR_PATH) -Iinclude -I$(<D) -Iinclude/$(ARCH) \
         -I ../rseq -I.. $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index fab18e9be66c..0f881ee8c37c 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -1076,7 +1076,7 @@ uint64_t vcpu_get_msr(struct kvm_vcpu *vcpu, uint64_t msr_index)
  int _vcpu_set_msr(struct kvm_vcpu *vcpu, uint64_t msr_index, uint64_t msr_value)
  {
         struct {
-               struct kvm_msrs header;
+               struct kvm_msrs_hdr header;
                 struct kvm_msr_entry entry;
         } buffer = {};


(patch above untested)

-Gustavo

> 
> struct msr_data *alloc_msr_data(void)
> {
> 	return static_cast<struct msr_data *>(malloc(sizeof(struct msr_data)));
> }
> 
>   $ g++    -c -o test_kvm.o test_kvm.cpp
> In file included from test_kvm.cpp:2:
> /usr/include/x86_64-linux-gnu/asm/kvm.h:194:30: error: flexible array member ‘kvm_msrs::entries’ not at end of ‘struct msr_data’
>    194 |         struct kvm_msr_entry entries[];
>        |                              ^~~~~~~
> test_kvm.cpp:6:30: note: next member ‘kvm_msr_entry msr_data::entries [1]’ declared here
>      6 |         struct kvm_msr_entry entries[1];
>        |                              ^~~~~~~
> test_kvm.cpp:4:8: note: in the definition of ‘struct msr_data’
>      4 | struct msr_data {
>        |        ^~~~~~~~
> 


