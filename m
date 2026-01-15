Return-Path: <kvm+bounces-68164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 965B1D2340F
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 09:49:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DC24B302106F
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 08:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFE3D33A708;
	Thu, 15 Jan 2026 08:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oY/oDF+N";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oY/oDF+N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEA222A4EB
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 08:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768466937; cv=none; b=LKu0QWudtZzIN6qzutIUUcNC90eoGNw5h8X7N5SLpPH413MSgVigi9V5S9MD6FjT817Hg0h7FWSJcVAAuSqzTr6tA2p2myLLNOWpvvZ1nxUlPFT0JPPU+Q/0JtG+ZKbm3bxtMmcqneIvfs4xibd8SUtml2v6OOIfs+einEajsCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768466937; c=relaxed/simple;
	bh=FxwDNa3KSC2/Vu/T2oGTKgNI3YzjmFWxBDANh7dfFng=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IG/705PeCmb1AIIuq4mhI9r20pQE8BEhEDnQLYXZbupa7FTbDXF+IZR0FZgImFUTqLzXsFBGWBY0bg8nqa0zLniz8WtimAniA0OD8r7bKB/zaGQyLnkrv/HkHuQzXEUtKIURv1gublpBwdd9pmaXtGvh4a0t5yIAZhk8lcE8uL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oY/oDF+N; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oY/oDF+N; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 012EB5BCEB;
	Thu, 15 Jan 2026 08:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1768466934; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=T4gQhUuagqLQmvTbN6c66jJbuGTJE17NFmXSnIA/TI8=;
	b=oY/oDF+NuXX3VQAMqj48JB2uJpwCE02l/tyX1XP8NP8s8NDMfNclL60SpFFymmyPD8xbKm
	3zQFJ7U6Dsz2aQ7TBXM+KT0K5gugtITLCIqJaODaSpR2C3X3UjJBR5+hk/YzNFViJrRj7q
	gg7DeJg2TV0yKBcuSezRh2RRr5lGf+4=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="oY/oDF+N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1768466934; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=T4gQhUuagqLQmvTbN6c66jJbuGTJE17NFmXSnIA/TI8=;
	b=oY/oDF+NuXX3VQAMqj48JB2uJpwCE02l/tyX1XP8NP8s8NDMfNclL60SpFFymmyPD8xbKm
	3zQFJ7U6Dsz2aQ7TBXM+KT0K5gugtITLCIqJaODaSpR2C3X3UjJBR5+hk/YzNFViJrRj7q
	gg7DeJg2TV0yKBcuSezRh2RRr5lGf+4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B147A3EA63;
	Thu, 15 Jan 2026 08:48:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PESNKPSpaGnEIAAAD6G6ig
	(envelope-from <jgross@suse.com>); Thu, 15 Jan 2026 08:48:52 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-block@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	xen-devel@lists.xenproject.org,
	Denis Efremov <efremov@linux.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v3 0/5] x86: Cleanups around slow_down_io()
Date: Thu, 15 Jan 2026 09:48:44 +0100
Message-ID: <20260115084849.31502-1-jgross@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[20];
	ARC_NA(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 012EB5BCEB
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

While looking at paravirt cleanups I stumbled over slow_down_io() and
the related REALLY_SLOW_IO define.

Do several cleanups, resulting in a deletion of REALLY_SLOW_IO and the
io_delay() paravirt function hook.

Patch 4 is removing the config options for selecting the default delay
mechanism and sets the default to "no delay". This is in preparation of
removing the io_delay() functionality completely, as suggested by Ingo
Molnar.

Patch 5 is adding an additional config option allowing to avoid
building io_delay.c (default is still to build it).

Changes in V2:
- patches 2 and 3 of V1 have been applied
- new patches 4 and 5

Changes in V3:
- rebase to tip/master kernel branch

Juergen Gross (5):
  x86/paravirt: Replace io_delay() hook with a bool
  block/floppy: Don't use REALLY_SLOW_IO for delays
  x86/io: Remove REALLY_SLOW_IO handling
  x86/io_delay: Switch io_delay() default mechanism to "none"
  x86/io_delay: Add config option for controlling build of io_delay.

 arch/x86/Kconfig                      |  8 +++
 arch/x86/Kconfig.debug                | 30 ----------
 arch/x86/include/asm/floppy.h         | 31 ++++++++--
 arch/x86/include/asm/io.h             | 19 ++++---
 arch/x86/include/asm/paravirt-base.h  |  6 ++
 arch/x86/include/asm/paravirt.h       | 11 ----
 arch/x86/include/asm/paravirt_types.h |  2 -
 arch/x86/kernel/Makefile              |  3 +-
 arch/x86/kernel/cpu/vmware.c          |  2 +-
 arch/x86/kernel/io_delay.c            | 81 +--------------------------
 arch/x86/kernel/kvm.c                 |  8 +--
 arch/x86/kernel/paravirt.c            |  3 +-
 arch/x86/kernel/setup.c               |  4 +-
 arch/x86/xen/enlighten_pv.c           |  6 +-
 drivers/block/floppy.c                |  2 -
 15 files changed, 60 insertions(+), 156 deletions(-)

-- 
2.51.0


