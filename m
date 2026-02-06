Return-Path: <kvm+bounces-70466-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6MfYHBMrhmm1KAQAu9opvQ
	(envelope-from <kvm+bounces-70466-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 18:55:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A4E0101881
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 18:55:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4D89A300B1B9
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 17:55:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23360426D0E;
	Fri,  6 Feb 2026 17:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iVLADzda"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FEB296BD3
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 17:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770400523; cv=pass; b=WY29qSvgr5KhUoYvPPmRMvt693Sz5eXVzUDT+nuVItLd/tw2GsmGOT6daE87RbHfIaA/+IaytkxHqGnZ8EaecwwgVQu5TEVl0VJmOsR7P9eWwQaxNPB4dmOQpIjHrVcIUo/I4zYB4X63Jj0GNHJN/5v5ZWWGRiQWi0sse5Z1bMY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770400523; c=relaxed/simple;
	bh=CQs3qizMq3SbCY1dailXM4UPmWUUNs7Uy0jKl1/hvIo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o2eaZnux3GtkIgOwCT46oQehkq6rYvdZNmAYzWS33dhYhn4U4LL2LYQQfqvNstDFDjnQI6ZsNcTvycmdylZMnCwU0mcIry11NEUT69YOQqf1nqyu8DcSmCN1lwvLuOACTzBFkAwxxToxvOFPkY79RoX93YbIAkugfgC1vn//qvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iVLADzda; arc=pass smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-385d9fb297dso23078491fa.2
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 09:55:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770400521; cv=none;
        d=google.com; s=arc-20240605;
        b=P25GcDzTsiX3yL0PCZSxwwdOpJjZweXLSecxPQ8N4dxPDoO90+AC1FWj4O5N+95oCg
         vfaUVxbY7ygZ7bpRpDpOPET0i66QvwosKnitOV2oZ1N8XDxxbkVq/vceoSbDB5HxOoDT
         eUGYz84vm9RR9BkF7LsR7VqfSWSGBiCBuaaRDFDNJ2CuBVPD7p+Vif3CbnbQF57Pl8TC
         GzfSZEisaUijT5R8d8Cwg9CIYOb9kz0EqhUtbna9wYJa6HVqRlzs4Xj+nEYGZBIGMS44
         kl/oIGFsaQcqD2RDVxcXDtoM3IFmcK1RYjCG1PoFthALvO9dJUiUBdHQA85ErjWCTuiA
         zZ1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CQs3qizMq3SbCY1dailXM4UPmWUUNs7Uy0jKl1/hvIo=;
        fh=7TNRyq8hY1jNh4Tdd4fMHJKmrm9+jWJP4M/zkcgE9x0=;
        b=a1D3FtzP0h0K7AotinRbgQwxs2n2e21KZG4EA3/TvagFiEu6qfjnirmVhMQ672BgDI
         tfW8Ymc58v4nf6054JpeT+1uFuzY/dsEiFlfSveesWmoa6YVn0S2NJFj4JxpkbbUyWL/
         4nyyV4OUOQ+/2Hb3ej11d/NB/34UsOowVRDXbSeJNaB5GAdkFleXIDcXXuo/79JV1Ic2
         AtPiSkGf4XehF44c/Kaugw+7EeVUt+9bqfF99RlbQ0aFBfn4bdWMtNpIBG8dBFJhPtp1
         hCSZQqzWLrMQJS9Qdr7kzJbFwztQ/WlBYKggpJb9enIb4c8/NYtfzpgFe9WV/2GCNrzY
         vuIQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770400521; x=1771005321; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CQs3qizMq3SbCY1dailXM4UPmWUUNs7Uy0jKl1/hvIo=;
        b=iVLADzdaD0oZa1faECWjz9DDhEdD8N/CZtDRQmCRjyq+v/tmY/6t8TBnKMk4Hs+f7o
         sBhu5gyJ45rStzKgG9x5fZaTkrUHsG14eVzumxPifC3vBhWYI+piGkbszSZM093uBf6h
         m/irnSf2zWxu3anoBPyNa3Ia/DOLmcq8EqYCHnvvWqMIMbLFZ9g4cY8l4bVKqKgK6g+p
         DUY6R6iL4oDMQtt6Du+PRzC6zEZrKU07GxY74q6iJSdv+Mpnq/etpygMIaldSuMZlu9f
         3GOoFxqATHibKat3Yz0mL5dQ0GWnHVwvh908krQWtSLi8yfD/qmvM4u5S/Z9KWSY7VZw
         HXBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770400521; x=1771005321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CQs3qizMq3SbCY1dailXM4UPmWUUNs7Uy0jKl1/hvIo=;
        b=JIYMpBFCiKHe6qzSh9ceSkF6flzfdkjwlSBxgAcLLsDF2JElr7Kz1aL/DunoqEwUNc
         xJkSozAJvnuYVGUmsrlhQuY2aMHYG5ub5dOPaIwoOeaEE7gQ1OfKPB/qJICMw35gO9jL
         NUijhgw0NP6APn7M8KnMi75x5lV20+NPQ0BAAuOy2oDe8KYqIVVhUoZUQnwAb8wPs4h7
         Zw2gMDjryZ2x/zWdrJK0rc6yg2paYmVGQVg/7Oo7S/VSXULwC7Z2gTjiVBIxDF+OZTw4
         hKyasqSUqw5YUtDslQBBmK3LEApFF1K1GH7ceU8F992T/bAwoH4NT3EgrLw5stC2iIXg
         CnEg==
X-Forwarded-Encrypted: i=1; AJvYcCWs+haOv+mOXcWupNjkkGpR9N7ES8F8jWaHjon1tVutH1+6hQx1EWx/aL6w8HQRZJxV7eg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzARxR+iZxaEgGcRprRQnTYc8aTkDtA7mQeaW6rAcHk0W4xT37j
	ORJ1Aq3MPu02J5R/xBlAyEYjo6tIkg3IYN/uX3ES/NnR/Y2AIk2eCP7TSUDakivQ+jirfIOtO5M
	ikR5PQU7q1z70QS/D0+gNhg0dV/yd8iZHMV/yom2ep4B2nZLERtKuR6+V
X-Gm-Gg: AZuq6aL299EhiTuAz3q6yGxmOFYT3qh1isBPzL728bVqMrCTLddkGjTeRE93MogERzX
	UciLoxxHVMrc19xW/idoVH+xaHv4RpaNKPwnSwCogQmDVZV0MHaDytd4Bwi41npTSUX+BJv9I6e
	YfqYA3xAeIlez/Es3hT43JY1GFPwz43voxWX8xYKjAcDHHaIdYhdIVcvq/yRj7vxSr2oJb1We63
	t6IVAvygSJ1/NzjoTVHLGe7Wm3zPUtsEPoWDo2ISKzc88zZ5fA0PlzxO+hYJfSH2/qIgE8=
X-Received: by 2002:a2e:bc84:0:b0:385:f2fb:14db with SMTP id
 38308e7fff4ca-386b513b416mr17372541fa.36.1770400521052; Fri, 06 Feb 2026
 09:55:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260202-vfio-selftest-only-64bit-v2-1-9c3ebb37f0f4@fb.com>
In-Reply-To: <20260202-vfio-selftest-only-64bit-v2-1-9c3ebb37f0f4@fb.com>
From: David Matlack <dmatlack@google.com>
Date: Fri, 6 Feb 2026 09:54:52 -0800
X-Gm-Features: AZwV_QgTrk3DAg7DGpaF40s0Bjc0dzuDlKfmgb-NfhnAhfOJ4GnGSp8CJdyHMsI
Message-ID: <CALzav=d3Yd_v8WJHkhB==22hsbrroNZguk=2ssT==AVBzxkN0w@mail.gmail.com>
Subject: Re: [PATCH v2] vfio: selftests: only build tests on arm64 and x86_64
To: Ted Logan <tedlogan@fb.com>
Cc: Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	NEURAL_HAM(-0.00)[-0.998];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-70466-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+]
X-Rspamd-Queue-Id: 0A4E0101881
X-Rspamd-Action: no action

On Mon, Feb 2, 2026 at 5:24=E2=80=AFPM Ted Logan <tedlogan@fb.com> wrote:
>
> Only build vfio self-tests on arm64 and x86_64; these are the only
> architectures where the vfio self-tests are run. Addresses compiler
> warnings for format and conversions on i386.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202601211830.aBEjmEFD-lkp@i=
ntel.com/
> Signed-off-by: Ted Logan <tedlogan@fb.com>

Reviewed-by: David Matlack <dmatlack@google.com>

