Return-Path: <kvm+bounces-66323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F389BCCFAC4
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 12:55:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D5F75309D977
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 11:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E8D3254A3;
	Fri, 19 Dec 2025 11:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XTjPwnM6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wXAZs50k";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cqv9azIJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Udd2lz1F"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0098324B3E
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 11:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766144629; cv=none; b=QKScfLB94eNlCTVOE5VBJatASDcmHV32ZD1ZAEQpln7w56eMYMJYnrEAoI/eAi3gcW29KTaooxGBBwIj2fifi2HtMTwx17uLWpeq/2xdqBY7MF3qRY9uHaVEgKiZGJXrs2/MLGm4rd+mETNsbE6hvyXfUCCrFscdm/H9E8wSG9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766144629; c=relaxed/simple;
	bh=zlVaL1UBMPqFxLz80smA6Z07R1HNNV7ZU1MWmDntpbM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=h3xrQr+iZ4ka4pFpbnE7O9kJxekq6z8mGXvDzj0OyQkFboWNPz5ECWsHnluGQyjfz1lItA8JkKhQPftJ0ay4RniohzP+Q45OJBvcDxgYM6elUF1D3BWnKaa7l9rh5FN5fuaT0e2UXcPHtS8tKVYOMecTnbotW6xlRfBNWx9vEyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XTjPwnM6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wXAZs50k; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cqv9azIJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Udd2lz1F; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4B136336B8;
	Fri, 19 Dec 2025 11:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1766144619; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eRSTAVfNEo/l4vH1TUrxP06y0rkPuFRyuTmx/ranUZ8=;
	b=XTjPwnM6a4dmqE0Gi4FM7VYLEtPx8+2xNZLsJ/HI4NDXkjG8576inPg3FK7Bo3KZHcDJSd
	mZ6ogfqPaeAN5miut8T99QAAfEXJLngB+VBkU8cY0y3Kjol6YgsefVXhj06EexLQ/HtmAG
	WctZq5I2dZRQVtclEou6D2NaNmD+UrI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1766144619;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eRSTAVfNEo/l4vH1TUrxP06y0rkPuFRyuTmx/ranUZ8=;
	b=wXAZs50k3/P1Wq2JxO0zEBIq0P6Voj+Fi/oYkJ9JpVC8MhdHcNeFjSaWZzBY+6FwT+hqh9
	5yuKGUjnhX1k3ADg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cqv9azIJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Udd2lz1F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1766144618; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eRSTAVfNEo/l4vH1TUrxP06y0rkPuFRyuTmx/ranUZ8=;
	b=cqv9azIJ/nZCf3V9Vg/zIC98797C9MUDwpMcMdGCLGSvdXU+RiMIJ1fN7DOq+uk/U0M/Cr
	xBes4DcuGHU4dJPY0dkEzior1RLYKSkqac+BcKyHWnUyQM8ULVjirwkRkU3UJrVtR2104o
	+4c3X+ZA7yh39EehWPH1rbVPzr90zH4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1766144618;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eRSTAVfNEo/l4vH1TUrxP06y0rkPuFRyuTmx/ranUZ8=;
	b=Udd2lz1F65NqANk88K43Ss21lWfSyNyCqTaXvgscpTMLraxg0BQsDaKxRhYannbcccBlMZ
	b9h5LJ8tIW2F3NAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AA19C3EA63;
	Fri, 19 Dec 2025 11:43:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jgPXJmk6RWnWGgAAD6G6ig
	(envelope-from <clopez@suse.de>); Fri, 19 Dec 2025 11:43:37 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
Subject: [PATCH 0/6] KVM: SEV: use mutex guards for simpler error handling
Date: Fri, 19 Dec 2025 12:41:55 +0100
Message-ID: <20251219114238.3797364-1-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 4B136336B8
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

Replace several uses of mutex_lock() / mutex_unlock() pairs with mutex
guards, which are less error-prone and help simplify error paths,
allowing removal of all gotos in some functions. This removes around 40
lines of code in total.

This does not remove all uses of the manual lock APIs, only those that
have their error handling improved by switching to the newer API.

Changes are separated per-function for ease of review.

Carlos López (6):
  KVM: SEV: use mutex guard in snp_launch_update()
  KVM: SEV: use mutex guard in sev_mem_enc_ioctl()
  KVM: SEV: use mutex guard in sev_mem_enc_register_region()
  KVM: SEV: use mutex guard in sev_mem_enc_unregister_region()
  KVM: SEV: use mutex guard in snp_handle_guest_req()
  KVM: SEV: use scoped mutex guard in sev_asid_new()

 arch/x86/kvm/svm/sev.c | 135 ++++++++++++++---------------------------
 1 file changed, 47 insertions(+), 88 deletions(-)


base-commit: 0499add8efd72456514c6218c062911ccc922a99
-- 
2.51.0


