Return-Path: <kvm+bounces-70701-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oEZdKsbPimk/OAAAu9opvQ
	(envelope-from <kvm+bounces-70701-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 07:27:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E6FB1175CD
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 07:27:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 60B583006B4C
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 06:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B54232D7E6;
	Tue, 10 Feb 2026 06:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="brZbiouA";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z7CQxR1b"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D9832C309
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 06:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770704829; cv=none; b=lhWRdisOkaDnGybwgQ9Uw+YTc6/s4vucSxLcDdc1B0/5LuVpqiJ/sFbwg2yrD13sswev9LbYtiDO3JhOm0q39rM6NXowN/D1eA4ONrVMuiCxpO/aNK/dSQkKulGOVAPSRiXEg9QB7Lvby8X9W4b0qJ7qYPxLFNfANmfux339RbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770704829; c=relaxed/simple;
	bh=hdy03mEYW90qZm3pt21hr79QfuEN0S/r5uuaUybijh0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=WVS6TDf9zc6gDI0xDAPXRSd7G4ZwanoxejE6Z9kfoad7r+EDJwcqOJoH3HD1B9p63r47GvttwkDPIWLLX4g9nmY7SmaIVnOPOF3oxr2CaNs8lfVjM2QdNbbnPuZN+FQmjATX0BxD4Gs28TSAb+IxMrjN20A9grqw4ebaO3HxmPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=brZbiouA; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z7CQxR1b; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770704826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FysZsB5k8hbHFWlIK99Yr+eFck1qP1kHPKIqAGZmSws=;
	b=brZbiouA6Q4CZCG5W9/1blpvacKGdRxNf7WCXFzceEOXoX7eY+hODLOdErvqf4A+azyz0T
	a2a1LK6jeqL2HkLn0AAHdOnC3tebIg5Z4B/jP4CHXI9Uwp3nm/QkA5JuUvD+QVMMgwgoB5
	QduOvQXsc1IHkAYdQzv4FIGyKUTTaZ0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-lcS1wYguOj2wkOY07aH2sQ-1; Tue, 10 Feb 2026 01:27:05 -0500
X-MC-Unique: lcS1wYguOj2wkOY07aH2sQ-1
X-Mimecast-MFC-AGG-ID: lcS1wYguOj2wkOY07aH2sQ_1770704824
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-435ab907109so3841424f8f.3
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 22:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770704824; x=1771309624; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FysZsB5k8hbHFWlIK99Yr+eFck1qP1kHPKIqAGZmSws=;
        b=Z7CQxR1bTtJ9CR900A8l8+0s3B18M9Btr742w7h66eCA8wMCFwCjl7jF43rNJ5iWyR
         bzFRV5V/p7oYIlmJuc+1jgojRv9V6JSCtFxTXm6BBx93o8gIVp962lfg+x5t23R6J9cP
         m5usBDsqtfD+UulBnGH89S97LYWDiReVYVnn/H+RCFoCZGmDQ94c1Bi+uz0ZV7ILstAd
         rlMqL1q3yhd5pxCST6ioBc2A5+lIpJWv3ias2GnZkDVbhn5ah08r7GyK9YZ7TTIAXxn7
         HIw7FkzZmIajMI1JoMArL/+WxROsbBHTHwgLDYDHz/B4+mV9tb4hw6KRC7gR5HF4lYzs
         9lEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770704824; x=1771309624;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FysZsB5k8hbHFWlIK99Yr+eFck1qP1kHPKIqAGZmSws=;
        b=bZlvCzWaU1X4Ex/rxW/203zsE4SamiKrMVPmyv5Vr43B/Ebvx0Sy20yiRGfl/bEfmp
         6vb6XWEceZfsJkowDe2GSx0AAx0nnpIGu5DpkszZtQ2y/bJavWHcOT0RrRCghH9U0n/C
         o403EW6SqL94/nlOyj6P2/rdTSXJDi5+zxRTPhQ1Zl4TiI3oJUEatyRR0QT352E9Y+g1
         T8Wq1jEFt+gWdvteteQJrB096pc//NYhN+C3UMs2YXWyLrEtMMBZl0jsNQbcv2eW0NRx
         QiQI/Mzx951jvB4TIWB9mkpCLFIs6t9mh17be8s36ohfm1LMZjISuu1vMuNg5kM8+8dv
         KUkw==
X-Forwarded-Encrypted: i=1; AJvYcCVY2RgQZROzT6dpW+Y7uTCS2SCj4GwS41WNu6bV54A5nO6CawfYBug6n5FB8haDW0Sd81E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAk4Rx6ru3J8a/eDkWhqP3hrwi0MtkxUU1Z/X+trw6PDagR2w8
	LwQVShWpjDXfzZEN52qXX9JJ66C9aBUpy2U7zG6206RhZ+nXu/cDida6sbsKeLBk8WAMtfSXd+E
	y0zhQ2IbwWZ5YUhnkcqkkz8D8utuYsPRQS+9npXeXdThaedxnXa6Rdg==
X-Gm-Gg: AZuq6aIqOAL5esG9Lc41MmB4q7t3+sT2SCGMhQ0O6Jg3aNM7p7m7Rh6ZliH5O2IKd5P
	JMTH10U7vNKR7+QT3ROAlG8cVxYwjX453Y22MFUVPycgvuIbZjNm9sZ8DW1VbbNCXwaoa4ZiVMG
	Anzbq/s0xDTWwj+KxjMQrYLuleYb/6K6JklKq39OTtOrNs4hpmYn0VeGnH4DEMOxumHTcGCt7t3
	NNHXz4CI01QeDJY3GPWYM0EOPTqZVqiEpIvpt0L2wmFiKtCUFWJt+/5F4Cm0w9gdZ2UL6vax8it
	DKdDTaLKLLWg/9JnSVhfyGOJDiMMvl4gdd6sbmm9GBQ0WGJ6okzlAogaDXUcrFT9lnlpOs9IQ6/
	oBiky/aHeZhbes8Ah/Ul3Wr/7HCzu9QhSjePAW52EqOc1JlLXY/3PBzHJJ51BXoSzQdMitpsE0Y
	dS209IoihU9BugMc2A0UbuD5rTVg==
X-Received: by 2002:a5d:5f82:0:b0:430:96bd:411b with SMTP id ffacd0b85a97d-43629691fedmr19341724f8f.58.1770704823739;
        Mon, 09 Feb 2026 22:27:03 -0800 (PST)
X-Received: by 2002:a5d:5f82:0:b0:430:96bd:411b with SMTP id ffacd0b85a97d-43629691fedmr19341688f8f.58.1770704823304;
        Mon, 09 Feb 2026 22:27:03 -0800 (PST)
Received: from [192.168.10.81] ([151.61.26.160])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-4376d3a32basm15125796f8f.14.2026.02.09.22.27.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 22:27:01 -0800 (PST)
Message-ID: <5f3e0ca5-cf60-4f07-bbc6-663b04192c49@redhat.com>
Date: Tue, 10 Feb 2026 07:26:55 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [BUG REPORT] USE_AFTER_FREE in complete_emulated_mmio found by
 KASAN/Syzkaller fuzz test (v5.10.0)
To: Zhangjiaji <zhangjiaji1@huawei.com>
Cc: Sean Christopherson <seanjc@google.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Wangqinxiao (Tom)" <wangqinxiao@huawei.com>,
 zhangyashu <zhangyashu2@h-partners.com>,
 "wangyanan (Y)" <wangyanan55@huawei.com>
References: <369eaaa2b3c1425c85e8477066391bc7@huawei.com>
Content-Language: en-US
In-Reply-To: <369eaaa2b3c1425c85e8477066391bc7@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70701-lists,kvm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4E6FB1175CD
X-Rspamd-Action: no action


> I've analyzed the Syzkaller output and the complete_emulated_mmio() code path.
> The buggy address is created in em_enter(), where it passes its local variable `ulong rbp` to emulate_push(), finally ends in emulator_read_write_onepage() putting the address into vcpu->mmio_fragments[].data .
> The bug happens when kvm guest executes an "enter" instruction, and top of the stack crosses the mem page.
> In that case, the em_enter() function cannot complete the instruction within itself, but leave the rest data (which is in the other page) to complete_emulated_mmio().
> When complete_emulated_mmio() starts, em_enter() has exited, so local variable `ulong rbp` is also released.
> Now complete_emulated_mmio() trys to access vcpu->mmio_fragments[].data , and the bug happened.
>
> any idea?

Ouch, the bug is certainly legit.  The easiest way to fix it is something
like this:

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c8e292e9a24d..1c8698139dd5 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1905,7 +1905,7 @@ static int em_enter(struct x86_emulate_ctxt *ctxt)
  	rbp = reg_read(ctxt, VCPU_REGS_RBP);
  	rc = emulate_push(ctxt, &rbp, stack_size(ctxt));
  	if (rc != X86EMUL_CONTINUE)
-		return rc;
+		return X86EMUL_UNHANDLEABLE;
  	assign_masked(reg_rmw(ctxt, VCPU_REGS_RBP), reg_read(ctxt, VCPU_REGS_RSP),
  		      stack_mask(ctxt));
   	assign_masked(reg_rmw(ctxt, VCPU_REGS_RSP),

The hard part is auditing all similar places that lead to passing a
local variable to emulator_read_write_onepage().

For example I found this one:

	write_segment_descriptor(ctxt, old_tss_sel, &curr_tss_desc);

which however is caught at kvm_task_switch() and changed to an
emulation error.

It may be a good idea to stick a defensive "vcpu->mmio_needed = false;"
in prepare_emulation_failure_exit(), as well as
"vcpu->arch.complete_userspace_io = NULL" both there and in
kvm_task_switch().

Paolo


