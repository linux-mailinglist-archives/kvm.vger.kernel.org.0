Return-Path: <kvm+bounces-69030-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qCDLG3UNdGly1wAAu9opvQ
	(envelope-from <kvm+bounces-69030-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 01:08:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C83747B987
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 01:08:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1E2853022605
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 00:08:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34A2F53E0B;
	Sat, 24 Jan 2026 00:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GS73p9qk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F83CF9D9
	for <kvm@vger.kernel.org>; Sat, 24 Jan 2026 00:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769213281; cv=pass; b=O3gHMk1AjRwaoQXhEbYrS829mNmAy2oH5nHmIzI9QmHrJn+dRsMNzI7Ke6LXJEIj5W/+4ySLSVFXhdJM0PMtlYnR/Z4qAwGh11TubidEfd35ET9Bgi0H4NLjDn/y7Bo9nLHqkFK7J5ZI2NStdXMbuJcrEvTTUuHq9uBvv3uW1+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769213281; c=relaxed/simple;
	bh=wSe7FuVJUHyRwwoVflyeXFFmY3WfXrs2ZcO7QxlO3W4=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ImetsfoHaKzIvlAx3MDNF5Yw7vyl+gilp/Zbd4cyfz8LPEScaATPhHgDJc/DsMMQD2Zh4LQATj0CNWrKN0MTTyHizB2Dl36TKHXjeHL5ON1J2SjwwflNHV1rAO2fW8m2COu5tk0PGTCrlIxCiTRS+z7Ab+tHdSoANcIxQfwlE2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GS73p9qk; arc=pass smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-5664634a27fso252676e0c.1
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 16:08:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769213279; cv=none;
        d=google.com; s=arc-20240605;
        b=h/96ASLeb9lUsRdeugNdEroGHeIUMOKdpCMAEMDE44YhznMJE1nbkl8Tkp3bQ4Sjxh
         xrA7rX2BD0TVI6eSnWo1/6LANyaEdUSVVyLk2upAPTZJDxI2+blCE9uMxuQhlVEb7kLQ
         WK7P1LoRHWTDFxXDoQzXUaXSU+mt5Qn58QPovyM5GzKjGaS2mC3BfvT6CO+yzbcIC3hU
         qDlr890ID0XSj426Wd5yA7m3yVqPh6TTXQudFaqekZPpBkyYZB3Eif4G/cJlgthPHWQs
         +ifUmROOgQX4Wv5Y7yYHBiUd0QGSUDnlOvvA/5PLHLL73Rh+x4LBD/xlJ/deZc7k2Qpp
         vstw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=/DNHlYn4p0TppVAhoBNqhHlPga7XxHNgUsUOejXrb08=;
        fh=UL/y/ABn/9vaWzLy8AIZA2wEfHr0YOCVsvuM8nt1L2A=;
        b=AQ9VBnKRScvMXGSwO+PhGDHtbDnM9F5aM4bHNOcrDiQfi20YLgUAvJ6WN2wwBMcAhL
         bgT7xc7HoIhqglMkU0RgAKxsjqTpNk6YwjUZY2MiqhFZH0FdRfwuwncoTWOeE2KNmzQU
         kV+EGaIyewsWdopeQ/Pd+pIOZL8Ti76JX1wZp+lCBfNGNIF7Ahsto0mWw9ApUd0ZlD0J
         hB54RcZCY+4jSH7DOPC/JBa5OFfgT7e/HiNQw4OcR2hEmGQoDWiYMZFVgXl3qWMKQZxF
         eyGp3VZanOfj4cs/j/XH06rTT8bjlIIEpLnDu2MrArc2eEUWZy8ntkar7IDtweAMUEYz
         Q9NA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769213279; x=1769818079; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=/DNHlYn4p0TppVAhoBNqhHlPga7XxHNgUsUOejXrb08=;
        b=GS73p9qk9k2uZbjNlfvSB0KZfJGIjLLaktV3kekj16d8bpOVuej/5YAGwMorScQAxB
         B4uQAeoqQm+rP8EY0ur48oVi5PJoEx7ggWP5E9KGA2iB2VrAhDeOsWQfi+dPM7QZULCj
         92MegSB+IFJuaqIA1oHe/b6vbnS/vJ0GsqsQmdIon0xy/OodDkZ7tQiOOVS2b67Mb8VC
         zT+pgRb75eapREX+VF1C6pJVuZTC++LTn9Qw/bFPLKesQHFZAZueB/SPin777/4zCzVQ
         +J6KltDANPJxKleiLkLnaC78cog/mfWJ78F7fvhEy8OE0iRe9YDBqVQNbKbDtfGqaisB
         37gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769213279; x=1769818079;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/DNHlYn4p0TppVAhoBNqhHlPga7XxHNgUsUOejXrb08=;
        b=bvtaSpsmswVYn4DVMTgoaq6Y3vwAvMii9oJtjx2poY3KLSwn/kcW/DmX9mL9Y0H3A8
         UWOAYiNjV7B220ZCTtdz7Z5+4jU77oD6h60rK696efRQNRo7biwWMDYU2u2KVJQUJPOh
         xyC5zavdp4HZ+k7sLLIBbNsM0T2F5ifH3Tlk6upNPerto5KQq4v6igP3gidLR7g7afZn
         +YRpQL1blE659LV7zcoD4ck3/B0PV+Is7dQNsC0Ctdt3QjkgrAti2pSJv5iJogTmcSKk
         c1NvD+68skGNBKTh09qtkp1AzGU8R9P+aMTs0cSxE6PnIWd2+C9tKu0YcK/1m7nCJ9nT
         rupQ==
X-Gm-Message-State: AOJu0YzN416K/IjsAixHrlOLJyL1NF2xRemwuGTpzcdrSXtUgOKdoV5h
	bvs+uzlhdTxASrA+FEyBmVXS60ZcvkUl+fkpJMughiB5Ld9D6q6/kS1hSH2A+QCg7zurX12rA4y
	7E56h97ikfc5rJfwq7m+O7y9zisq3W2Hmo0fc9UOeRn3vChVTtEyritoh
X-Gm-Gg: AZuq6aKTkWfAsgx17IA3RwXznHJm5t8wwaIjOgEWeTVLOWy1ILdj6jtZ7e5Dtuvv9BB
	f8lnBuFmbD9qxQZy4N8+/tszDBcOVHD4vq0flnz/Vy6OrplK9C+mIbcE26sXCRyAHqN+vYcZz9t
	d+W8BhTV3z2FXbT4T9Hj0GA749qvEQ1jayJ7SdrD36eqOjw5FRBn32AosQxhqtdN/2XcFclcwPA
	eCb4g6dYK9UTgaM5Zz4TZTeDPQYj967t7cKRAyWqzMZuQGkbnLzCzPMZRiD6EK+8ue+kr87KI27
	1FlvZZErKwppjkBS7gS0/d6bnw==
X-Received: by 2002:a05:6102:374b:b0:5f5:30e4:c8cd with SMTP id
 ada2fe7eead31-5f55874acd1mr847220137.42.1769213278639; Fri, 23 Jan 2026
 16:07:58 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 23 Jan 2026 16:07:57 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 23 Jan 2026 16:07:57 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <cover.1747264138.git.ackerleytng@google.com>
References: <cover.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 23 Jan 2026 16:07:57 -0800
X-Gm-Features: AZwV_QiZSx8uXBlkjUzf-XEIBRHwTGQ0-9_ksNxOa1FVccYAoX0KqqZc1VcdbW4
Message-ID: <CAEvNRgFmq8DP_=V7mrY8qza3i9h4-Bn0OWt72iDj6mELu+BiZg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/51] 1G page support for guest_memfd
To: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org
Cc: david@kernel.org, fvdl@google.com, ira.weiny@intel.com, 
	jthoughton@google.com, michael.roth@amd.com, pankaj.gupta@amd.com, 
	rick.p.edgecombe@intel.com, seanjc@google.com, vannapurve@google.com, 
	yan.y.zhao@intel.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69030-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C83747B987
X-Rspamd-Action: no action

Ackerley Tng <ackerleytng@google.com> writes:

Re-using this thread to collect discussions related to guest_memfd
HugeTLB support, also trimmed cc list.

Here's the latest public version Vishal and I have:

  https://github.com/googleprodkernel/linux-cc/tree/wip-gmem-conversions-hugetlb-restructuring-12-08-25

On the guest_memfd call on 2026-01-22, Michael found another bug to do
with multiple threads trying to allocate within the same huge page at
the same time.

The fix we're using to make progress is to use hugetlb_fault_mutex_lock.

unsigned int gmem_hugetlb_mapping_index_lock(struct address_space *mapping,
					     pgoff_t index, u8 page_order)
{
	pgoff_t index_floor = round_down(index, 1ULL << page_order);

	return hugetlb_fault_mutex_lock(mapping, index_floor);
}

void gmem_hugetlb_mapping_index_unlock(unsigned int hash)
{
	hugetlb_fault_mutex_unlock(hash);
}

and then

static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
{
        ... declarations ...

	if (gmem_is_hugetlb(gi->flags))
		lock_id = gmem_hugetlb_mapping_index_lock(mapping, index, gi->page_order);

        ... and this right at the end ...

	if (gmem_is_hugetlb(gi->flags))
		gmem_hugetlb_mapping_index_unlock(lock_id);
}

Yan also found some bugs (thanks!) and there's a discussion at [*].

[*] https://lore.kernel.org/all/CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com/

