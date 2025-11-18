Return-Path: <kvm+bounces-63442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E652AC66D6C
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 02:33:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 30CA828C94
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 01:33:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C6E230597D;
	Tue, 18 Nov 2025 01:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="DkYWisG9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C67A1E7C19
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 01:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763429604; cv=none; b=nxcHwyrLSxwiynSW/1XU2dDcscaLCrGw9k+vEV+MTtuR3el8lBOW4m6KL6yCiwP7YdkUOE7dM0DQMjr6V1iMEG3BqFxMtbft6bd2bAg5Pyqq4wmITqKzO42sTiDwadmk/h2ycybWfLPyncxSO3Nzy/FohO0Oya6bbzTj6nKuDlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763429604; c=relaxed/simple;
	bh=nnVJBDrqwwIhWPtEpmmZic7FnfDmoGokXzSNORyOUJo=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=l0A2WZ7ClZM4Vll+dcjUwen9ZEIxmZ3xNBER1g67vBFenFrEO95b7w3wHFvOMq8T15FYmRy/68BjubHyW/7YHqmbVypUVHfEjyolfRARJCezI0llqiZpBzOq3GNrHj5xhBFKFVzWS/2oRhj+OQr9PgwSpOTpxftcdEvHsVAy1Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=DkYWisG9; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8b2f2c5ec36so152185485a.1
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 17:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1763429600; x=1764034400; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C4hoiXRAaj1tbhxDzJlVdMfo7upvGHdC39KJuih16Vw=;
        b=DkYWisG9I5MV8eZFp6lQU4QtaZo9qIrAlMpnkiyulOGMwW4iEs3AiuoSlb6ZFlXFH4
         QweKMg1w2gx87m/iTZMv1uvEiejWKRrPVNV0Ldsb+EZ0elNntEO+1VDJm275hNV84ZWK
         2VlAn5sVqvy4tbabawf8ZrptMaPRpHuohK55zQ0epPVWT6uqkfL1DvAFZAialPiWkr9d
         dbbRdSar4iAh2XqUFTwRJZ0HRCKcY+vZ9luXtntbx05PQIcFmivEoMliWrkrmHqiuwi3
         LlFGA+IFJYnmGlKQyouAOiy1WdbJhSceJbo87c3XQkV9jHMQr1WVYV+eaAqEN4NMIBFY
         cqqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763429600; x=1764034400;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C4hoiXRAaj1tbhxDzJlVdMfo7upvGHdC39KJuih16Vw=;
        b=tSXX12JBxaSolrSteTiBiwTc/j20kN4zFSkrHfT5bS2bd9N10HS7iIzdBOIi5ZIYRR
         an7eb4jqM5AIc9cElTb1TEoABRP6rzJfYG9SldH605AxoOdneYN8fCIWHKSjw/JdZoWJ
         wjF3ponzf2fX4qgHSOIAetOwLEJdyFiXSBwKacLt9bKysgeCHa1/PhlTIR8wNd1ePxIY
         NUJ8JafpURDVP9TdpcvOL0m2sNy0WMEIkouoSmXg70tmQ1lseOauphOWdyJ29zWCntK7
         lLG5vqViMV+eINJCvmf5+vsnxaC1hnkdNRCiXI6wQhaMAb2lOKisU4+viBto9udFrhr5
         MaGw==
X-Gm-Message-State: AOJu0YzY65GJkqsPXwQzJbbdksfSCdPXCgZ0ZsvxCe2K+o3HtN25f0y1
	SCPAxF2kIu2Q0Fue0VrekerPTk5KvJ7vRE7Is5/+kVn6jDJJu0RXjAwJ/5Qxk2BPm14=
X-Gm-Gg: ASbGncsVWSR0oAZahlwuL6Yy3dS1p4M6jtHJCn9XTik80kNbSHVCnu4WhkSDaDbHvWg
	eU897ULViwtxryxRyedmpehHEcflbq2Xqk9HevwdMjLgGSjjvI932o6MwHaQAFzd9GHCmHy6Y3l
	VhyDREA/PHMTcEd43bWmppojirVUZrb37RiGcW4Vqs1FdweO8DawSlR11Dy0HBz2dXD6KbziG16
	4OWre020Hayrh6m+0ppxIAD6+BS/p6ohJxNhFVY4M2ObnH+Ft2xtwF3naDsy82CoIz4wC5v/CCa
	SceGz3ewElu7G2XXXyPy885zhu+wgAm2cPX/u59FnxH06Bf9nE2jyEHunC1Xjg7lCcUN0ONQ62u
	x4B/hLLk7oTE0PcjPPbqVZW8vl7gYW/2mV+QS/SL3cMLHjne4LoliOC1PaDMWwFcLbcZYvlRbNV
	PXwrMqxgxuk68CVlNIFnmE8HL+kTuqrMZdNtYrsrAsPlIArWPj+fAZkO0wA3UT0IZl6mLJpfx0x
	34QpxJVw4lVxajObIShhSghd4oTa715+/xGd0a3v9BiNC6qKKSQkSKi
X-Google-Smtp-Source: AGHT+IH3jZaF+8AMXYP9SIuqmgqhQ/1/L9nHNB8dUkfbV4+F9NYJk6SL9OfbdMigKEqTCtc9kQ2kdg==
X-Received: by 2002:a05:620a:3945:b0:8b2:7679:4d2d with SMTP id af79cd13be357-8b2c31d3f09mr1994630685a.63.1763429600193;
        Mon, 17 Nov 2025 17:33:20 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2aee9e519sm1116530885a.5.2025.11.17.17.33.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Nov 2025 17:33:19 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------v5UEWd1lmK7xbVKuWRNVQR30"
Message-ID: <083276ef-ff1b-4ac3-af19-3f73b1581d39@grsecurity.net>
Date: Tue, 18 Nov 2025 02:33:16 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf
 functions
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, Eric Auger <eric.auger@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20250915215432.362444-1-minipli@grsecurity.net>
 <176314469132.1828515.1099412303366772472.b4-ty@google.com>
 <15788499-87c6-4e57-b3ae-86d3cc61a278@grsecurity.net>
 <aRufV8mPlW3uKMo4@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <aRufV8mPlW3uKMo4@google.com>

This is a multi-part message in MIME format.
--------------v5UEWd1lmK7xbVKuWRNVQR30
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 17.11.25 23:19, Sean Christopherson wrote:
> On Sat, Nov 15, 2025, Mathias Krause wrote:
>> On 14.11.25 19:25, Sean Christopherson wrote:
>>> On Mon, 15 Sep 2025 23:54:28 +0200, Mathias Krause wrote:
>>>> This is v2 of [1], trying to enhance backtraces involving leaf
>>>> functions.
>>>>
>>>> This version fixes backtraces on ARM and ARM64 as well, as ARM currently
>>>> fails hard for leaf functions lacking a proper stack frame setup, making
>>>> it dereference invalid pointers. ARM64 just skips frames, much like x86
>>>> does.
>>>>
>>>> [...]
>>>
>>> Applied to kvm-x86 next, thanks!
>>
>> Thanks a lot, Sean!
>>
>>> P.S. This also prompted me to get pretty_print_stacks.py working in my
>>>      environment, so double thanks!
>>
>> Haha, you're welcome! :D
>>
>>>
>>> [1/4] Makefile: Provide a concept of late CFLAGS
>>>       https://github.com/kvm-x86/kvm-unit-tests/commit/816fe2d45aed
>>> [2/4] x86: Better backtraces for leaf functions
>>>       https://github.com/kvm-x86/kvm-unit-tests/commit/f01ea38a385a
> 
> Spoke too soon :-(
> 
> The x86 change breaks the realmode test.  I didn't try hard to debug, as that
> test is brittle, e.g. see https://lore.kernel.org/all/20240604143507.1041901-1-pbonzini@redhat.com.

Gee! 16bit code at its finest.

So I looked at it and this seems to be a bug in gcc because it emits a
5-byte NOP to make room for a 3-byte call. Actually, it doesn't even
emit a NOP, it just spits out some bytes:

minipli@bell:~$ diff -u pg.s nop_mcount.s
--- pg.s	2025-11-18 01:34:34.884472417 +0100
+++ nop_mcount.s	2025-11-18 01:34:05.716096290 +0100
@@ -11,7 +11,7 @@
 	.cfi_offset 5, -8
 	movl	%esp, %ebp
 	.cfi_def_cfa_register 5
-1:	call	mcount
+1:	.byte	0x0f, 0x1f, 0x44, 0x00, 0x00
 	movl	8(%ebp), %eax
 	addl	%eax, %eax
 	popl	%ebp

The issue is, while that is a perfectly fine NOPL for 32-bit and 64-bit,
it's not for 16-bit. The 16-bit version gets treated as a 4-byte NOPW
with a left-over zero byte which messes with all the following opcodes
and causes issues like you observed.

However, gcc is probably not fully to blame, as it cannot know that it's
generating 16-bit code. That piece is hidden in a asm(".code16gcc")
statement.

> 
> I can't for the life of me figure out how to get Makefile variables to do what I
> want, so for now I'm going to drop the x86 change so as not to block the rest of
> the stuff I've got applied.
> 
> I'll keep the rest applied, so just resubmit the x86 patch against kvm-x86/next.
> 


> FWIW, conceptually I think we want something like this:
> 
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index be18a77a..65e41578 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -44,6 +44,7 @@ COMMON_CFLAGS += -O1
>  KEEP_FRAME_POINTER := y
>  
>  ifneq ($(KEEP_FRAME_POINTER),)
> +ifneq ($(no_profiling),y)
>  # Fake profiling to force the compiler to emit a frame pointer setup also in
>  # leaf function (-mno-omit-leaf-frame-pointer doesn't work, unfortunately).
>  #
> @@ -53,6 +54,7 @@ ifneq ($(KEEP_FRAME_POINTER),)
>  # during compilation makes this do "The Right Thing."
>  LATE_CFLAGS += $(call cc-option, -pg -mnop-mcount, "")
>  endif
> +endif
>  
>  FLATLIBS = lib/libcflat.a
>  
> @@ -120,6 +122,7 @@ $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o $(SRCDIR)/$(TEST_DIR)/realmode.
>         $(LD) -m elf_i386 -nostdlib -o $@ \
>               -T $(SRCDIR)/$(TEST_DIR)/realmode.lds $(filter %.o, $^)
>  
> +$(TEST_DIR)/realmode.o: no_profiling = y
>  $(TEST_DIR)/realmode.o: bits = $(realmode_bits)

Kind of, yes. Just with the $(no_profiling) part embedded into
LATE_CFLAGS. However, as that gets forcibly evaluated early (on
purpose!), that can't work.

I tried to play with $(filter-out ...,$(CFLAGS)) but that didn't work
out either. What does work, however, is to disable -mnop-mcount and make
it a call again. This just needs a stub mcount() and the realmode test
is working again.

I see that kvm-x86/next as of now (e403d30a8210 ("x86/emulator: Treat
DR6_BUS_LOCK as writable if CPU has BUS_LOCK_DETECT")) still has
f01ea38a385a ("x86: Better backtraces for leaf functions"), so I just
created a fixup commit (attached). Feel free to squash it into
f01ea38a385a or yell at if you want something else.

Thanks,
Mathias

--------------v5UEWd1lmK7xbVKuWRNVQR30
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-x86-Prevent-realmode-test-code-instrumentation-with-.patch"
Content-Disposition: attachment;
 filename*0="0001-x86-Prevent-realmode-test-code-instrumentation-with-.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSBkMmFjMTU4ODFiNzk0YTRlMzkzMmM0OWE5NzI3OGQwNDI2ZjBhYTY3IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBNYXRoaWFzIEtyYXVzZSA8bWluaXBsaUBncnNlY3Vy
aXR5Lm5ldD4KRGF0ZTogVHVlLCAxOCBOb3YgMjAyNSAwMjoxNDoyNyArMDEwMApTdWJqZWN0
OiBba3ZtLXVuaXQtdGVzdHMgUEFUQ0hdIHg4NjogUHJldmVudCByZWFsbW9kZSB0ZXN0IGNv
ZGUKIGluc3RydW1lbnRhdGlvbiB3aXRoIG5vcC1tY291bnQKCkNvbW1pdCBmMDFlYTM4YTM4
NWEgKCJ4ODY6IEJldHRlciBiYWNrdHJhY2VzIGZvciBsZWFmIGZ1bmN0aW9ucyIpIG1hZGUK
dXNlIG9mICctcGcgLW1ub3AtbWNvdW50JyB0byBwcm92aWRlIGEgbGlnaHR3ZWlnaHQgd2F5
IHRvIGZvcmNlIGxlYWYKZnVuY3Rpb25zIHRvIGVtaXQgYSBwcm9wZXIgcHJvbG9ndWUgZm9y
IHRoZSBiYWNrdHJhY2luZyBjb2RlLiBIb3dldmVyLAotbW5vcC1tY291bnQgZG9lc24ndCBw
bGF5IHdlbGwgd2l0aCAxNi1iaXQgY29kZSBnZW5lcmF0aW9uIGZvciBDIGNvZGUuCmdjYyBo
YXBwaWx5IGVtaXRzIGEgNS1ieXRlIE5PUCB0aGF0IHRyYW5zbXV0ZXMgdG8gYSA0LWJ5dGUg
Tk9QIGZvbGxvd2VkCmJ5IGEgemVybyBieXRlIHdoZW4gZXhlY3V0ZWQgaW4gcmVhbCBtb2Rl
LCB3cmVja2luZyBhbGwgY29kZSB0aGF0CmZvbGxvd3MuCgpGaXggdGhhdCBieSBzZWxlY3Rp
dmVseSBkaXNhYmxpbmcgJy1tbm9wLW1jb3VudCcgZm9yIHJlYWxtb2RlLmMsIG1ha2luZwpp
dCBjYWxsIG1jb3VudCgpLCB3aGljaCBpcyBwcm92aWRlZCBhcyBhIHN0dWIgZnVuY3Rpb24u
CgpSZXBvcnRlZC1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+
CkZpeGVzOiBmMDFlYTM4YTM4NWEgKCJ4ODY6IEJldHRlciBiYWNrdHJhY2VzIGZvciBsZWFm
IGZ1bmN0aW9ucyIpClNpZ25lZC1vZmYtYnk6IE1hdGhpYXMgS3JhdXNlIDxtaW5pcGxpQGdy
c2VjdXJpdHkubmV0PgotLS0KIHg4Ni9NYWtlZmlsZS5jb21tb24gfCA1ICsrKystCiB4ODYv
cmVhbG1vZGUuYyAgICAgIHwgMyArKysKIDIgZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEveDg2L01ha2VmaWxlLmNvbW1vbiBi
L3g4Ni9NYWtlZmlsZS5jb21tb24KaW5kZXggYmUxOGE3N2E3NzllLi42YjU5ZjI2YTNkMmMg
MTAwNjQ0Ci0tLSBhL3g4Ni9NYWtlZmlsZS5jb21tb24KKysrIGIveDg2L01ha2VmaWxlLmNv
bW1vbgpAQCAtNTEsNyArNTEsOSBAQCBpZm5lcSAoJChLRUVQX0ZSQU1FX1BPSU5URVIpLCkK
ICMgV2UgbmVlZCB0byBkZWZlciB0aGUgY2Mtb3B0aW9uIHRlc3QgdW50aWwgLWZuby1waWMg
b3IgLW5vLXBpZSBoYXZlIGJlZW4KICMgYWRkZWQgdG8gQ0ZMQUdTIGFzIC1tbm9wLW1jb3Vu
dCBuZWVkcyBpdC4gVGhlIGxhenkgZXZhbHVhdGlvbiBvZiBDRkxBR1MKICMgZHVyaW5nIGNv
bXBpbGF0aW9uIG1ha2VzIHRoaXMgZG8gIlRoZSBSaWdodCBUaGluZy4iCi1MQVRFX0NGTEFH
UyArPSAkKGNhbGwgY2Mtb3B0aW9uLCAtcGcgLW1ub3AtbWNvdW50LCAiIikKK05PUF9QR0ZM
QUdTIDo9IC1wZyAtbW5vcC1tY291bnQKK0xBVEVfQ0ZMQUdTICs9ICQoY2FsbCBjYy1vcHRp
b24sICQoTk9QX1BHRkxBR1MpLCAiIikKK05PX05PUF9NQ09VTlQgPSAkKGlmICQoZmlsdGVy
ICQoTk9QX1BHRkxBR1MpLCQoTEFURV9DRkxBR1MpKSwtbW5vLW5vcC1tY291bnQpCiBlbmRp
ZgogCiBGTEFUTElCUyA9IGxpYi9saWJjZmxhdC5hCkBAIC0xMjEsNiArMTIzLDcgQEAgJChU
RVNUX0RJUikvcmVhbG1vZGUuZWxmOiAkKFRFU1RfRElSKS9yZWFsbW9kZS5vICQoU1JDRElS
KS8kKFRFU1RfRElSKS9yZWFsbW9kZS4KIAkgICAgICAtVCAkKFNSQ0RJUikvJChURVNUX0RJ
UikvcmVhbG1vZGUubGRzICQoZmlsdGVyICUubywgJF4pCiAKICQoVEVTVF9ESVIpL3JlYWxt
b2RlLm86IGJpdHMgPSAkKHJlYWxtb2RlX2JpdHMpCiskKFRFU1RfRElSKS9yZWFsbW9kZS5v
OiBDRkxBR1MgKz0gJChOT19OT1BfTUNPVU5UKQogCiAkKFRFU1RfRElSKS9hY2Nlc3NfdGVz
dC4kKGJpbik6ICQoVEVTVF9ESVIpL2FjY2Vzcy5vCiAKZGlmZiAtLWdpdCBhL3g4Ni9yZWFs
bW9kZS5jIGIveDg2L3JlYWxtb2RlLmMKaW5kZXggN2E0NDIzZWM2MDk4Li4wYTcxMDRkNGNm
ZjQgMTAwNjQ0Ci0tLSBhL3g4Ni9yZWFsbW9kZS5jCisrKyBiL3g4Ni9yZWFsbW9kZS5jCkBA
IC0yMyw2ICsyMyw5IEBAIHZvaWQgdGVzdF9mdW5jdGlvbih2b2lkKTsKIGFzbSgKIAkidGVz
dF9mdW5jdGlvbjogXG5cdCIKIAkibW92ICQweDEyMzQsICVlYXggXG5cdCIKKwkicmV0XG5c
dCIKKwkvKiBtY291bnQoKSBzdHViICovCisJIm1jb3VudDpcblx0IgogCSJyZXQiCiAgICAp
OwogCi0tIAoyLjQ3LjMKCg==

--------------v5UEWd1lmK7xbVKuWRNVQR30--

