Return-Path: <kvm+bounces-70901-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gKaCH0RmjWlk2AAAu9opvQ
	(envelope-from <kvm+bounces-70901-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 06:33:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EC3F012A772
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 06:33:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2E41C308F150
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 05:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D25E28B4F0;
	Thu, 12 Feb 2026 05:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lkIzpJak"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071EC2877D6
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 05:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770874431; cv=pass; b=amvFFgLUsBCW7LlH1rbPfmnTARVyLdQkona4gBV4ID4tp35TeHZZnFzyHM6GTmoHYAsWv4RarjiM494RSBar5EWPG6s3t6N+dvdygU3Ca8PpPB83SruQOxQ1RRNg7y3pHRxhJc9jf92aoP0MhdYtQ3s+0uxrdztVuSaiqfnsr4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770874431; c=relaxed/simple;
	bh=xAiAvaB1uVPriD2WydyDP33n/t3IN2zix+CDBfiLTqI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=RJ49vtgSzcwNt67GUzZII5IW7Mzu8vXGXR2lRLVWgWM+qMpMRH6P3TYWbJ+gpz1/AdrPxHc+OpuE8bttrnGNi093DRMMWAbyAhhGNhWRPwb7HW8qA63ABLnI9I4YHK4bhWCZ1EmQyqKPnABoaRzUXRxeInRXTLjL6IJlEdkG0lM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lkIzpJak; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b88593aa4dcso1021155066b.3
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 21:33:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770874428; cv=none;
        d=google.com; s=arc-20240605;
        b=UlDt0gifphpUeu7k4ZxScx8Kj46FY4FdSPQp1AImUDpFszjRqcg28+vCBS5J5/BQiX
         /DOpUnU5H1emE4ng7Z4D5EuQAhruw1CFJBM2X9z3jmTcWneKPuUAjeicGTtEZVhp25PT
         802DisGTG6uCllXA5GXqjNKTHHAab4Q5eKklhWHMF1omAmEsZwn8SNWh1UJzsJ6ZC4mv
         kAxy+NkI6FkHqiTQgFTmpdHlDbN9QFXYt9HeOtvwQurGVhBY4xPDsR9aPv2T63y4RwCr
         +a7eylFMoZgQExGSorA0l0FnRjXtnFw1C7MBAXVqdmmGJobYrvnpvjABDySY0WIisujw
         YU5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:reply-to:mime-version
         :dkim-signature;
        bh=xAiAvaB1uVPriD2WydyDP33n/t3IN2zix+CDBfiLTqI=;
        fh=4iab8j2rU0x4zvoNz8rJqrLr3gnMwzpNb4p18x6lBrQ=;
        b=LzIDB/a6prMdw5Rx/lJr/0UGaNiOik3RYv4fjij7O6oeexXmxMSpy2ut1hhbkEWN+b
         m9q+XRzrf6RFuPMfDKfedNl32rzWmqc+OmVnDKrWWipU9tdfCdrE4E8X3b3gWXBFOh6B
         i7GJOXDjis509TJ/GtgJTXXZathpzBXJeJfjSx+YSa6HxEU1PoFcwrPGwuTuzWLqCNz0
         JZMvTLcaDpLhMwYvaNfJUpeLqszzLNe4DsJSMA88JL0U25rgAuRB2Q0syoXOSVZbFUuU
         AxQP+MspWXtgpwtodohd+HHS0iRI5PTprUZpyFy6Mz546RFtGr0AefHUjm00Vy7U3dul
         wIvQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770874428; x=1771479228; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xAiAvaB1uVPriD2WydyDP33n/t3IN2zix+CDBfiLTqI=;
        b=lkIzpJakunL9c5st8nFEpfLXyTPB5ZCZrqkZygik+zaS+ggGqaI6Bq9JAygxsyLkwK
         1q0qoMvf8xwRuii//iN/48BiV1ALqpHjz3AEmz5JurjveUq405CD3LFnwWRcSbnqKOXc
         gB0HKKspnR7IU0kvMYYL1YMmXIn2ZkdCuhUbqRIMTXaU/dWdQI5IYZIfHf8HUeniP2Lg
         YW4r4yjMfHNAPJ3YPVz7nG3kvfa2p2jCikNzWz+Q0vdynZc9W9dT0tUU1YEaPrY/tMJ1
         a6fntQTBDqpHGSFpHYOiBQYKWzgEWZBvr37xEag4R3ivETjSm5txa8IZekWU40oaTDn1
         2SPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770874428; x=1771479228;
        h=cc:to:subject:message-id:date:from:reply-to:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xAiAvaB1uVPriD2WydyDP33n/t3IN2zix+CDBfiLTqI=;
        b=Nbi5QEqutW/1qhG0Fx14JdsrSKeEYaYo3oCexrVW7/efbVQuGq5J+1eCOa73fLev9j
         1F8kXSHwwCO04HO/BhEBLgroLznlvS+EFTWI3Hgp/r9DcDBPVXFhobLStnRcZoB1ihj/
         p3prEs/GQOwVg7/vR85a4XZsN/UYBuGOnhCFxprlwQDOZcP75tvyM0DDb2TWjnSj1ApR
         DxExEKJPxZyE++wdfPj8LX7CFDoSn6x9PBJkfO7J2PyhKNXpYT175kKWorJRj/UzTOhk
         /9F3DGQLUzn/YC7yHlkTqq6gKySwxgsDURm2zc1FNTdZgmQpXv1eHljVQoB+aTwtz5os
         7DDw==
X-Forwarded-Encrypted: i=1; AJvYcCVYE99PtU1HOo6ipmxNYmcTyyFpNn/fjKOVl7IzmQ0ExwaEBG1N18ft8AyoUKKyX8EhooA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLRnNbHn7DpZlMqhk/yC870mCNSn8rtuYKSnfBFhmkcohJuuk/
	AJ1tdtw44c+PnT2AODVPabz4C7jSOtTy/8Tej03nLFncE6GkpIqmrT8idh/yPfxLVw7zG9Yp74D
	IMNAv2yB8QrxJ0KpYBepTu3APyyJwLwE=
X-Gm-Gg: AZuq6aKIt0wbMG5dg4zv54bUr3wVOkxNW9JNWey3VIV8Rac6wweowSfwvgVZGIAMUYX
	rkHdSqtkDCXJaDZxiKJ9YsfuwKQok5pczzezwuWpgKDmhJt+KL6DJuiSHa65RyvPuaZS/aBz5eC
	2E/Tz6qNbQtxC+D7lDkbA9+EJpWSkYkpPXFonpmOLoNjbHFcKDSCS4f11+UsiB0YKmDJx3mAI4c
	Eh0H2JqBC6Q4eyoi81aaJyYlsEXkpJWMeTa1oXdG4UKe4gXb09AccYIg+Xl2iSBOOx0pacDf+Q+
	oA0R1bTFZ8kiXR6N8GBuAB+njRjTDXCmF77+2/IG
X-Received: by 2002:a17:907:980d:b0:b88:646b:ae32 with SMTP id
 a640c23a62f3a-b8f8f658d93mr83784366b.22.1770874428171; Wed, 11 Feb 2026
 21:33:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Reply-To: ludloff@gmail.com
From: Christian Ludloff <ludloff@gmail.com>
Date: Wed, 11 Feb 2026 21:33:37 -0800
X-Gm-Features: AZwV_QhadkSbOa8Eq6pNDj97BG-nLpsCh0FEeQ_NOUW4x27Wa9Fjh5SgBVTS9rw
Message-ID: <CAKSQd8W3ijML2L6hPTR6+eFUh3bZXjrMjSsdbMaZrmpGTSFoOQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Drop obsolete branch hint prefixes from
 inline asm
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@kernel.org, 
	pbonzini@redhat.com, seanjc@google.com, tglx@kernel.org, x86@kernel.org, 
	ubizjak@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	FAKE_REPLY(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_REPLYTO(0.00)[gmail.com];
	TAGGED_FROM(0.00)[bounces-70901-lists,kvm=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	HAS_REPLYTO(0.00)[ludloff@gmail.com];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ludloff@gmail.com,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[alien8.de,linux.intel.com,zytor.com,vger.kernel.org,kernel.org,redhat.com,google.com,gmail.com];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: EC3F012A772
X-Rspamd-Action: no action

Andrew Cooper wrote:
> The branch-taken hint has new meaning in Lion Cove cores and later,
> along with a warning saying "performance penalty for misuse".

Make that Redwood Cove. For details, see the
Intel ORM Vol1 #248966-050 Section 2.1.1.1.

Also, for the sake of completeness, the officially
undocumented old "Alternate Taken/Not Taken"
hint on the P4 (prefix 0x64) is covered in Agner
Vol3 Section 3.4; in the 2025-12-14 pdf you can
find it in the top half of page 26 of 277.

--
C.

