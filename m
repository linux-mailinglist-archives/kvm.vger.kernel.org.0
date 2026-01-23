Return-Path: <kvm+bounces-68954-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2NSVAxE+c2kztgAAu9opvQ
	(envelope-from <kvm+bounces-68954-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 10:23:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C10597337F
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 10:23:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D07523034334
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 09:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A15C633FE30;
	Fri, 23 Jan 2026 09:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="j/TBwzhy"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6691B32ED58;
	Fri, 23 Jan 2026 09:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769160098; cv=none; b=UZRrOZdckWsYq/zj1e3urvcGR9gMlLji7kyAKsxTqOu5soZgUZ8pgWTGds5eQCcZYwOvb645jle+uL9HYAa6WLxPfnT8GyemrPN1uV+RpXVB0nNbL/zDu55My9OMoE30rghdQTESkx8OyFunbUtjmbXAUyRUz4ZM6gCsdT3aZdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769160098; c=relaxed/simple;
	bh=9S8Wwx68iSqz4szDYufCVZdts8LhHSdVmt//ehYdGcw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X+kao/8ZcH834IL+LRq99DRyhvcpY8+/hiKIE5+2HXhSkva4W5sv41Ulp6MbZlySrT7X2f1+hBUQDnhSXrDSPJPEfFFGc3ChwZoHeiZ4Sejp3qOhy/4KazJo8g/x/FEcIknv1mr98YEHeaEnTr3NJrTXqP0d5tDkMqMoMs3cbeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=j/TBwzhy; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=aNe+NXx1fSGf0Ef6wL2MoAIzVRM/cCnOzAumVL49lLE=;
	b=j/TBwzhyePXLOUZ7EbYmEIIIJqVBu5wy/alZvauNrsKS0lqFWTaPSF9SXL2bAC
	DlhLIC+yD45kKcICP/Ufa4lfyp7cLiw4ubM0il38Otx1971DP/fYFfioID+CcLYP
	rPw75hL4WKjLfZNQsgD/Nt0XrNLqlTzDrWgMdWQPLEmyk=
Received: from [10.0.2.15] (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wDX5M9qPXNp9ENZHg--.137S2;
	Fri, 23 Jan 2026 17:20:44 +0800 (CST)
Message-ID: <6752311d-f545-4148-a938-5c9690c31710@163.com>
Date: Fri, 23 Jan 2026 17:20:42 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: selftests: Add -U_FORTIFY_SOURCE to avoid some
 unpredictable test failures
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiquan_li@163.com
References: <20260122053551.548229-1-zhiquan_li@163.com>
 <aXJcpzcoHIRi3ojE@google.com>
From: Zhiquan Li <zhiquan_li@163.com>
Content-Language: en-US
In-Reply-To: <aXJcpzcoHIRi3ojE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDX5M9qPXNp9ENZHg--.137S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGry7WFWUtr17AFyrZF43KFg_yoWrWF18pa
	9a9r9FyF4vqr1Iyr97Can3Gr1S9r4kGF48JF15Wry5Z3Z0y3yIvrWIkFyYk3WfCr4kJ34Y
	vFy8KF13u3WUAw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUS2NJUUUUU=
X-CM-SenderInfo: 52kl13xdqbzxi6rwjhhfrp/xtbCwgyhimlzPWxQwQAA3-
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[163.com,none];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68954-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[163.com];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,kernel.org,vger.kernel.org,163.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zhiquan_li@163.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[163.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C10597337F
X-Rspamd-Action: no action


On 1/23/26 01:21, Sean Christopherson wrote:
> Is this needed for _all_ code, or would it suffice to only disable fortification
> when building LIBKVM_STRING_OBJ?  From the changelog description, it sounds like
> we need to disable fortification in the callers to prevent a redirect, but just
> in case I'm reading that wrong...

Thanks for your review, Sean.

Unfortunately, disabling fortification only when building LIBKVM_STRING_OBJ is
insufficient, because the definitions of the fortified versions are included by
each caller during the preprocessing stage.  I’ve done further investigation and
found the off tracking since compilation stage with the GCC “-c -fdump-tree-all”
options:

I found memset() is replaced by __builtin___memset_chk in
x86/nested_emulation_test.c.031t.einline phase by compiler and kept to the end.
At last, __builtin___memset_chk was redirected to __memset_chk@plt at GLIBC in
linking stage.

As a perfect reference substance, guest_memfd_test, which invokes memset() in
guest_code() as well.  I replayed the same steps and found memset() is replaced
by __builtin___memset_chk in guest_memfd_test.c.031t.einline phase, but, it was
redirect to __builtin_memset  in guest_memfd_test.c.103t.objsz1 phase after the
compiler computing maximum dynamic object size for the destination.  Eventually,
__builtin_memset was redirected to memset at lib/string_override.o in linking stage.

Whatever, the KVM selftests guest code should not reference to the fortified
versions of string functions, let’s stop it at the beginning to avoid the
compiler dancing :-)  Indeed, disabling fortification for all code may seem
overly aggressive.  We can first try limiting the scope to
x86/nested_emulation_test and then expand the blast radius if the similar issues
arise in other files in the future.

The new patch as below:

---

From 33b502ea1cf6f4b6ac272bda64e1361903330d61 Mon Sep 17 00:00:00 2001
From: Zhiquan Li <zhiquan_li@163.com>
Date: Fri, 23 Jan 2026 17:05:41 +0800
Subject: [PATCH] KVM: selftests: Add -U_FORTIFY_SOURCE to avoid
 x86/nested_emulation_test failed

Some distributions (such as Ubuntu) configure GCC so that
_FORTIFY_SOURCE is automatically enabled at -O1 or above.  This results
in some fortified version of definitions of standard library functions
are included.  While compiler parsers the symbols, the string functions
might be replaced by the fortified versions, this will result in the
definitions in lib/string_override.c are skipped and reference to those
PLT entries in GLIBC in by linker.  This is not a problem for the code
in host, but it is a disaster for the guest code.  E.g., if build and
run x86/nested_emulation_test on Ubuntu 24.04 will encounter a L1 #PF
due to memset() reference to __memset_chk@plt.

The option -fno-builtin-memset is not helpful here, because those
fortified versions are not built-in but some definitions which are
included by header, they are for different intentions.

In order to eliminate the unpredictable behaviors may vary depending on
the compiler and platform, add "-U_FORTIFY_SOURCE" into CFLAGS for
x86/nested_emulation_test to prevent from introducing the fortified
definitions.

Signed-off-by: Zhiquan Li <zhiquan_li@163.com>
---
 tools/testing/selftests/kvm/Makefile.kvm | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm
b/tools/testing/selftests/kvm/Makefile.kvm
index ba5c2b643efa..5fd35d593023 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -282,6 +282,8 @@ $(GEN_HDRS): $(wildcard $(arm64_tools_dir)/*)
 	$(MAKE) -C $(arm64_tools_dir) OUTPUT=$(arm64_hdr_outdir)
 endif

+$(OUTPUT)/x86/nested_emulation_test.o: CFLAGS += -U_FORTIFY_SOURCE
+
 no-pie-option := $(call try-run, echo 'int main(void) { return 0; }' | \
         $(CC) -Werror $(CFLAGS) -no-pie -x c - -o "$$TMP", -no-pie)

-- 
2.43.0


