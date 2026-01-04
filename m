Return-Path: <kvm+bounces-66983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B1196CF0CAD
	for <lists+kvm@lfdr.de>; Sun, 04 Jan 2026 10:32:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D321F3014ACF
	for <lists+kvm@lfdr.de>; Sun,  4 Jan 2026 09:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DC7F27EFF1;
	Sun,  4 Jan 2026 09:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=0x65c.net header.i=@0x65c.net header.b="KTHFT0AA"
X-Original-To: kvm@vger.kernel.org
Received: from m204-227.eu.mailgun.net (m204-227.eu.mailgun.net [161.38.204.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727A722F772
	for <kvm@vger.kernel.org>; Sun,  4 Jan 2026 09:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=161.38.204.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767519155; cv=none; b=JHG1nSo4EOaeZdnYEMDNePcp4n357b+AbmmwRu7z9G/hzSuaXMOTzP5PJbFCK+jU3kLgrYqfujtbPL/kRneKIV1TFc6JUl0nPvVrHFKLTHhO8N2jKs8bXjZQmdkPu+VL6wRLJz2pwTX5tYnPPHt2z9xIArCeM3O12iidlJnyUaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767519155; c=relaxed/simple;
	bh=MUgFvgqEB7XgxmikpsKlkfbvurFl8ED2oN0SDRcm7vI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mppCu20QldfhJMUYVyHaXgxd4POflfwqNkEZqzA8yLEEMmqIVI4eQ44vmYbCEleTu3XNoQOlCfH/gcJp3yt5uQBWpyUCEvgRMl0u2r4H8x7nTAfG37UQcwCTD1o7fEsD6DFNfaxWOaUZw2TZO8wz27eICO+TXL1UNXt/A9MBuT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0x65c.net; spf=pass smtp.mailfrom=0x65c.net; dkim=pass (2048-bit key) header.d=0x65c.net header.i=@0x65c.net header.b=KTHFT0AA; arc=none smtp.client-ip=161.38.204.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0x65c.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0x65c.net
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=0x65c.net; q=dns/txt; s=email; t=1767519151; x=1767526351;
 h=Content-Transfer-Encoding: MIME-Version: Message-ID: Date: Subject: Subject: Cc: To: To: From: From: Sender: Sender;
 bh=XIeTYHnUQ/H/W/LI0nzsaTNmZqgXMJjMjR4cWFuMupE=;
 b=KTHFT0AADEsSN0V1C5VlOWkTpDpNJOI1mgFspEpA6pviZJBlOdv/8VHFKv8hVeOoaQUL348bTqvKxd19cuPGkggsiPcZejIMrqk4aU/Su+6o2pt/F0ddQuvUHJ3cQU/w/KsgQ1ZXqOSH7Mz8jjRRvGNpIzhGI2SFiebdQXdKDgRYmmxrsxXD1CFmKkUBb+IWPxaU4ZWDsKoy3iqh7EY/Z+tpEf50ULJpNZuzSp7KeOb5APh8c7V66gt/2r0EjYKHEXBUYol2GAWiS+B8L7+kpwoUvcWYHKaSNX0f7tMm0FWgSsl+qTuvuKGyaOqzKjXuaCuGN8OrYFjElqE+hFdJQw==
X-Mailgun-Sid: WyI1MzdiMyIsImt2bUB2Z2VyLmtlcm5lbC5vcmciLCI1NGVmNCJd
Received: from fedora (pub082136115007.dh-hfc.datazug.ch [82.136.115.7]) by
 92fd60d16f98f66e64e22c6810b3b3dfcf197ead3d84d42024c93a95946dee14 with SMTP id
 695a33aff97895dc57720484; Sun, 04 Jan 2026 09:32:31 GMT
X-Mailgun-Sending-Ip: 161.38.204.227
Sender: alessandro@0x65c.net
From: Alessandro Ratti <alessandro@0x65c.net>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+1522459a74d26b0ac33a@syzkaller.appspotmail.com,
	Alessandro Ratti <alessandro@0x65c.net>
Subject: [PATCH] KVM: x86: Retry guest entry on -EBUSY from kvm_check_nested_events()
Date: Sun,  4 Jan 2026 10:32:21 +0100
Message-ID: <20260104093221.494510-1-alessandro@0x65c.net>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a vCPU running in nested guest mode attempts to block (e.g., due
to HLT), kvm_check_nested_events() may return -EBUSY to indicate that a
nested event is pending but cannot be injected immediately, such as
when event delivery is temporarily blocked in the guest.

Currently, vcpu_block() logs a WARN_ON_ONCE() and then treats -EBUSY
like any other error, returning 0 to exit to userspace. This can cause
the vCPU to repeatedly block without making forward progress, delaying
event injection and potentially leading to guest hangs under rare timing
conditions.

Remove the WARN_ON_ONCE() and handle -EBUSY explicitly by returning 1
to retry guest entry instead of exiting to userspace. This allows the
nested event to be injected once the temporary blocking condition
clears, ensuring forward progress.

This issue was triggered by syzkaller while exercising nested
virtualization.

Fixes: 45405155d876 ("KVM: x86: WARN if a vCPU gets a valid wakeup that KVM can't yet inject")
Reported-by: syzbot+1522459a74d26b0ac33a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1522459a74d26b0ac33a
Tested-by: syzbot+1522459a74d26b0ac33a@syzkaller.appspotmail.com
Signed-off-by: Alessandro Ratti <alessandro@0x65c.net>
---
 arch/x86/kvm/x86.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff8812f3a129..d5cf9a7ff8c5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11596,7 +11596,15 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 	if (is_guest_mode(vcpu)) {
 		int r = kvm_check_nested_events(vcpu);
 
-		WARN_ON_ONCE(r == -EBUSY);
+		/*
+		 * -EBUSY indicates a nested event is pending but cannot be
+		 * injected immediately (e.g., event delivery is temporarily
+		 * blocked). Return to the vCPU run loop to retry guest entry
+		 * instead of blocking, which would lose the pending event.
+		 */
+		if (r == -EBUSY)
+			return 1;
+
 		if (r < 0)
 			return 0;
 	}
-- 
2.52.0


