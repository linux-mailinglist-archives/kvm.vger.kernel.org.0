Return-Path: <kvm+bounces-70710-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0K/ABYvdimlIOgAAu9opvQ
	(envelope-from <kvm+bounces-70710-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 08:26:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C755117E5A
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 08:26:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AC32E3036743
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 07:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30F40334C19;
	Tue, 10 Feb 2026 07:25:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6501331A6D
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 07:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770708341; cv=none; b=ubt9U550WDHZKI5co+R6peSEk7zJpsqSfqPv2jf+GyDOq0qRg5fWV5pb+z7F/+r/1vMBAi8vOwd7jfXMxMiH6XbCX1rtGNt0pdrJBg5o2uNhXCTdaWQ4hOwztyAgttXjrjQbsigd/GkLHoHdvNSOD9bYRIfShYQp0Vo0mjBAa1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770708341; c=relaxed/simple;
	bh=D79oDfikccmJTO2nzCKp5nyOQP5H0uAsjYlZUbPUbB4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L7H4ouW4EscwZFk/GXuIM0LTVrJZsZVmN0BWkikSvGEbe5GydpARoBTypuP2afUEPtv2d23VF32dd3Rm1lYxq9dXjYTIdGZQhwVVtKJ0EaHaNg1QNdmd1dq90bq7PhBZZMpLW+MsMLYchorrj/js+gJKGGNQykpkI6OE7ivrzI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ooseel.net; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ooseel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2aad1dc8856so16522955ad.1
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 23:25:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770708339; x=1771313139;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NlIK6Drh5/5Im48t/VJk8VIZOF2y0mJxE9VOY1y6hzY=;
        b=mLjhO71U65NC6jj345pZ03Nw+JYaknztjX6hST0G625lqN5FNJaNw8zDokbx76DJ0z
         9e3fkqJGTHiuEukB4ga5tGFnVlhCPix/GZZsVKApJRtT4gitqN6KAQk0eJWAA8Pco4Fi
         rpmZ7FOUu89qNwayC4J1rHaLVLKklzWC3NbpBpiy0dqCcHbjok2ioP0c6am0TomgTCUQ
         7I5Ek0qAGpLta1+MrqezdkgntT+zPOkd4VYSsXv5jCe4U+vY1OTvA2NtYpSu7ncqIoWN
         GrkOu1Bp47UTxWaFKnVk/bbanTyNlU1F1BRSvo5HymM5bxAZ/Yt4khW/wVn5HtGR/5c3
         NPow==
X-Forwarded-Encrypted: i=1; AJvYcCV2KHi1p8VdpOff3VpvIWSg1Oxta/1q1askJlNs8XbZPpsYCyXg1gg0l/boRK7GOYufJuM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7go+x9pRGnAkqyUToa2R6SJnUyPkUxoyAN2OXaW1nTnLsk6hy
	dzweunq5ROdS3bSlDtWQao58uk9L0CpRbnjPPG/g7YpNnC7VgfC17Hd0
X-Gm-Gg: AZuq6aI5SzEElU3dfq7VS2rB1UT01ungaC591RH7yMZBBEjdT+kICAdRBdVO1thtZMM
	NH3bFWwYx1ctVnTvSkgTvzsYQC2dxuEEj0ML9PPAP91Ul4rKFF1U0oZzaXBEGWqOCqdywCjH4Q1
	eOl48oITP9tbQqIiuS6a1xMsc6fwWboPJ7yUul2Bh8q/ANCY1BAbiLmgbZcqn7j0lOg7EePe0v/
	rebktlrrKtQ1fQissVnewpwmX8jQMMTpZCrEDx4RxnM5ySdOW1vQTiGKBB+3Qqi2tNy/u35L1PB
	rpjJS9KEaaWRTn6Pms8tosO+VnEL/p5WNqZWf+nrqVENnIp+8NyNxSmoswxDGmT8sT7Q+rCeddH
	D2rqt9KCLwEG2xhCWEIfdHe/mwETEsTAnnMDSB3DniXxeQFSaAjfoa6zUpVy/l3Bph+yZqU24Hm
	zLg7Di2zhC9elq2A==
X-Received: by 2002:a17:902:e88d:b0:2a1:e19:ff4 with SMTP id d9443c01a7336-2a9516f5a0bmr130714385ad.29.1770708339174;
        Mon, 09 Feb 2026 23:25:39 -0800 (PST)
Received: from MILKYWAY ([1.213.237.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a9521b9bebsm125323425ad.56.2026.02.09.23.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 23:25:38 -0800 (PST)
From: Leesoo Ahn <lsahn@ooseel.net>
To: lsahn@ooseel.net
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE (KVM)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1] KVM: Use memdup_user instead of kernel stack to allocate kvm_guest_debug
Date: Tue, 10 Feb 2026 16:25:30 +0900
Message-ID: <20260210072530.918038-1-lsahn@ooseel.net>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[ooseel.net];
	TAGGED_FROM(0.00)[bounces-70710-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lsahn@ooseel.net,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,ooseel.net:mid,ooseel.net:email]
X-Rspamd-Queue-Id: 6C755117E5A
X-Rspamd-Action: no action

Switch to using memdup_user to allocate its memory because the size of
kvm_guest_debug is over 512 bytes on Arm64 and is burdened allocation
from kernel stack.

Signed-off-by: Leesoo Ahn <lsahn@ooseel.net>
---
 virt/kvm/kvm_main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5b5b69c97665..bc0a53129df7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4592,12 +4592,15 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		break;
 	}
 	case KVM_SET_GUEST_DEBUG: {
-		struct kvm_guest_debug dbg;
+		struct kvm_guest_debug *dbg;
 
-		r = -EFAULT;
-		if (copy_from_user(&dbg, argp, sizeof(dbg)))
+		dbg = memdup_user(argp, sizeof(*dbg));
+		if (IS_ERR(dbg)) {
+			r = PTR_ERR(dbg);
 			goto out;
-		r = kvm_arch_vcpu_ioctl_set_guest_debug(vcpu, &dbg);
+		}
+		r = kvm_arch_vcpu_ioctl_set_guest_debug(vcpu, dbg);
+		kfree(dbg);
 		break;
 	}
 	case KVM_SET_SIGNAL_MASK: {
-- 
2.51.0


