Return-Path: <kvm+bounces-66067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BE9FCC3B1B
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 15:45:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B2DD230C3370
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 14:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9D8F3612C0;
	Tue, 16 Dec 2025 13:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nwkDB4XJ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nwkDB4XJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A812435CBD6
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 13:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765892516; cv=none; b=HUti7oFfD62jLlmymgLuGUTIcIY7CtiRHCZD/0001fCG2JVKGQzF0k6sdrXk8d86gCEwNCYFFV54ERGkvXF1qkyzd0SoMmGkxaun9g5VDrN7HoHd/o+o7xnCc1gwr2VHk/d2Argz8007PFVvPS1k30cigrfTnHUgadqszr+AKIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765892516; c=relaxed/simple;
	bh=kkr3l3BReGUxarSRhXDLxB+y7uVke2R1nF/K/knhNM0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tx6IKEYnZKMCbvdmB942EyI+NnmA/d87TnNVylNDq7OKrbyC1WsTFZQMREkP8di/lIUOfjYu9VtTerm7xxSelh0uvgC1DGkmgFm0GL013JQsVsvphymnyIiIj0fU5vV7+VqWljxyfrCSLu/a3gssB3EY3ibc2fHABe1OQPqYP3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nwkDB4XJ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nwkDB4XJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DCB9F5BCDC;
	Tue, 16 Dec 2025 13:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1765892512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Kst14HrOHOUE5u6TMXwha6+cn8BnRd3Oo7OuhXwUE9I=;
	b=nwkDB4XJwqJ5qg8riyEUZwJ05UQqY+ll/6mkuKlVY7KytI0cCnU9IrZbiJq0/yhm5ZnQD8
	vp9oDeShUgYaPH7GYSu59SUTywMJ1jjetdQCLuE/Anm/9dvdMV/rytY7xz7XBHbLGJNsdY
	Qp+UFjHGULvUo/2u0S8ZGvTzquVnO6I=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1765892512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Kst14HrOHOUE5u6TMXwha6+cn8BnRd3Oo7OuhXwUE9I=;
	b=nwkDB4XJwqJ5qg8riyEUZwJ05UQqY+ll/6mkuKlVY7KytI0cCnU9IrZbiJq0/yhm5ZnQD8
	vp9oDeShUgYaPH7GYSu59SUTywMJ1jjetdQCLuE/Anm/9dvdMV/rytY7xz7XBHbLGJNsdY
	Qp+UFjHGULvUo/2u0S8ZGvTzquVnO6I=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1793F3EA63;
	Tue, 16 Dec 2025 13:41:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ug7mA6BhQWmEHwAAD6G6ig
	(envelope-from <jgross@suse.com>); Tue, 16 Dec 2025 13:41:52 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-block@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Thomas Gleixner <tglx@linutronix.de>,
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
Subject: [PATCH v2 0/5] x86: Cleanups around slow_down_io()
Date: Tue, 16 Dec 2025 14:41:44 +0100
Message-ID: <20251216134150.2710-1-jgross@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.992];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -2.80

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

Juergen Gross (5):
  x86/paravirt: Replace io_delay() hook with a bool
  block/floppy: Don't use REALLY_SLOW_IO for delays
  x86/io: Remove REALLY_SLOW_IO handling
  x86/io_delay: Switch io_delay() default mechanism to "none"
  x86/io_delay: Add config option for controlling build of io_delay.

 arch/x86/Kconfig                      |  8 +++
 arch/x86/Kconfig.debug                | 30 ----------
 arch/x86/include/asm/floppy.h         | 31 ++++++++--
 arch/x86/include/asm/io.h             | 17 +++---
 arch/x86/include/asm/paravirt.h       | 11 +---
 arch/x86/include/asm/paravirt_types.h |  3 +-
 arch/x86/kernel/Makefile              |  3 +-
 arch/x86/kernel/cpu/vmware.c          |  2 +-
 arch/x86/kernel/io_delay.c            | 81 +--------------------------
 arch/x86/kernel/kvm.c                 |  8 +--
 arch/x86/kernel/paravirt.c            |  3 +-
 arch/x86/kernel/setup.c               |  4 +-
 arch/x86/xen/enlighten_pv.c           |  6 +-
 drivers/block/floppy.c                |  2 -
 14 files changed, 55 insertions(+), 154 deletions(-)

-- 
2.51.0


