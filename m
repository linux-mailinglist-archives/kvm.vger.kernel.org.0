Return-Path: <kvm+bounces-70915-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qNm7HOZyjWk+2wAAu9opvQ
	(envelope-from <kvm+bounces-70915-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:27:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B452112AA25
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:27:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B913A3054617
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 06:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D46729ACFC;
	Thu, 12 Feb 2026 06:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N91RSOog";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="K1k4UIPN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB741EB9FA
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 06:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770877596; cv=none; b=NWOZ9oMeZ9b4rIzLbR7RXAm6JaTbdwtP2GM5aaNC4s+qn1bGwYtxk5nCsrksWoljjxEFiM9GUmVOUmoiOWlCJpWO0chZOkm+HbuQhiakp28bf9IU9IAWHRWL/d1OLxY6nWfpk/HdnwUpJHUWZwIZjCuvrX0WUBNnIN19XgeY/jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770877596; c=relaxed/simple;
	bh=oyuneKzvdez0/AzYtX0YpwFHbqcpf5Ank1kplg3Akrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qv8u3NnBlAaf9KCHIKcL+ROPFHuznq56gn/rWc9qeM32Khs4D9rOCuJwVs0WYTZ9PI9GyZYj+06WUSDIGz03KSSZHQHfftB+NWOa93vQnBMaHuoWeWQ+z87sFX16bRsb1PqEv70uB4kjgQiLD/537T5nPkI6g7MPXfKT4TJxnRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N91RSOog; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=K1k4UIPN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770877594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N2v6djobNSdTdF+YCpvzDQ17kkQi5jILZoPxzgDYLR8=;
	b=N91RSOogkor8hu4JuMLwNZd8DlGmGkooV474rc8tsq0fIADtW7tkplXofivGA1M2CkpyWT
	vuTTVZ02JHIgY/W8l0ydUcrtNeMKmOVxxJWS3oFjRLUwk7MIuR6W47NxbW7U9bQPuACLKd
	yvwQUce9cKFYIslXQY62gYQE8q20ftc=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-9DSrQmz_MF2ixmrLhOeHfQ-1; Thu, 12 Feb 2026 01:26:32 -0500
X-MC-Unique: 9DSrQmz_MF2ixmrLhOeHfQ-1
X-Mimecast-MFC-AGG-ID: 9DSrQmz_MF2ixmrLhOeHfQ_1770877592
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3562bdba6f7so12398395a91.2
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 22:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770877591; x=1771482391; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N2v6djobNSdTdF+YCpvzDQ17kkQi5jILZoPxzgDYLR8=;
        b=K1k4UIPNuXGcgI/N8FidVXrTHahL7ndaxtpxsQeyyYD4uqY4e1n+B5cXzH3NPVxlvf
         SehcNOWwfHRW646sxP4Hd5wOfmVKqfhYssdvBgDosWBm8TFkZbGNW9b4vJHsgXufA+0U
         TI/W6QnL4Yp5Dx7V8VBF6KuP4tuXf/j7iOugXNHON4EmTG7WzbwUpSxjOHhArdhyNTmX
         wjbIAExAqPASSHuYyqlTNH1lO3eVMn44wdGeQCmnC6+RzajXFlx4jR5aTwAjGMYU7z7t
         hTmmc0Hmm+glKR2alRiIbPP6GgI0EQRmFVQCd+x3z/7a2vzpSgcgNh28gYLrq7jlBsMM
         g0vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770877591; x=1771482391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N2v6djobNSdTdF+YCpvzDQ17kkQi5jILZoPxzgDYLR8=;
        b=KOKPVG15DITOnwhiQR8eEUmV8/VSvBk9UfJPgzPEVeiZDlqRh00w1yDDfYcQqIDWA9
         Pz89fAXjdvr2jmrzw38/VrKmLkcc9FoVSd3eq8YmfN9tvFBJgHMV25btkeUCTjRvRKLT
         TvpMANfVl4jCBOrpc098NUSCi0EhS/Kbg53uWVNoqxDWW84KSdTjF2JzWjYlG+woPe1/
         uinpNq4vtZymh6aCPi69Pm0UISCCOsnr+P8fTlJeHEhoCxpMAW5ZpuG6zY+VECRMRaIQ
         FYh9xRjQXpyX/jIxCPBC8OeU2Hz9VOnl/PmxvGWyevgeq4oQAaKh6MHmMttHFXMig8rf
         ErlQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9xTOQJ1M938dO8PshUj35xWI38/BkiWJspMqFeFr4iP5DX75OHBXESv1nAETnuDBQiWs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXJZCBGTBJeCM20v8OEdqQqwntj6tef7y0CktYGWmWL7hPwQED
	uJ1j8aRa/Zx7YOzjCD96qNBQNR0uFrIHQe69r59XOo54P16bLbUynZkMvhTHnlR1Xz5jIJf5Xvq
	RfoVHnPu+exrq+/RKjLDKqlpqteglJta4l2fwbXZIWAX4Ha8CfA579Q==
X-Gm-Gg: AZuq6aJdZT3zv1aGUhOy7TrkQrah4qOZfLGnxJ4nlXV8wJ8IhIJI2Mq3sqPIcbOBjjS
	fuYDbDmlwds95V5AKedthGxRtcR0uMJ98kFqDM9I7hB/hOoAWt6wIJePP9tV8CUAPdNT7KHiH3c
	n5AEr1V4dT+ELsUWCaBPJVoGoKr4B1ILinU26p6g2lEgUB1N1USuuoslaUTy/OMuA+ZbN4U0r/c
	XEGnhCTM7Dc4uIjUzPMsBbNlfYkQE7FLuw2SGTrNR13fbJpeyQUvX9Y7I6FOIHIfjLjwVlvJAS/
	Zc3ru4GUS36p/HVMxi+/ruw8bkGUkN4l2U+PO5YmUEuwyHpybNjLnz2/gYypAdcxLWzCHF4XggM
	lR0ZLM80NPnE2rqrPNipKv9X5bBO/K8Ae/KbzFNqYZi0F3FG6hCrxl5U=
X-Received: by 2002:a17:90b:350c:b0:353:883:affc with SMTP id 98e67ed59e1d1-3568f3e4ccdmr1651317a91.18.1770877591667;
        Wed, 11 Feb 2026 22:26:31 -0800 (PST)
X-Received: by 2002:a17:90b:350c:b0:353:883:affc with SMTP id 98e67ed59e1d1-3568f3e4ccdmr1651305a91.18.1770877591360;
        Wed, 11 Feb 2026 22:26:31 -0800 (PST)
Received: from rhel9-box.lan ([122.164.27.113])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm4894122a91.2.2026.02.11.22.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 22:26:31 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v4 18/31] i386/sev: add notifiers only once
Date: Thu, 12 Feb 2026 11:55:02 +0530
Message-ID: <20260212062522.99565-19-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260212062522.99565-1-anisinha@redhat.com>
References: <20260212062522.99565-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70915-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B452112AA25
X-Rspamd-Action: no action

The various notifiers that are used needs to be installed only once not on
every initialization. This includes the vm state change notifier and others.
This change uses 'cgs->ready' flag to install the notifiers only one time,
the first time.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/sev.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 260d8ef88b..647f4bf63d 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1920,8 +1920,9 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         return -1;
     }
 
-    qemu_add_vm_change_state_handler(sev_vm_state_change, sev_common);
-
+    if (!cgs->ready) {
+        qemu_add_vm_change_state_handler(sev_vm_state_change, sev_common);
+    }
     cgs->ready = true;
 
     return 0;
@@ -1943,22 +1944,23 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         return -1;
     }
 
-    /*
-     * SEV uses these notifiers to register/pin pages prior to guest use,
-     * but SNP relies on guest_memfd for private pages, which has its
-     * own internal mechanisms for registering/pinning private memory.
-     */
-    ram_block_notifier_add(&sev_ram_notifier);
-
-    /*
-     * The machine done notify event is used for SEV guests to get the
-     * measurement of the encrypted images. When SEV-SNP is enabled, the
-     * measurement is part of the guest attestation process where it can
-     * be collected without any reliance on the VMM. So skip registering
-     * the notifier for SNP in favor of using guest attestation instead.
-     */
-    qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
+    if (!cgs->ready) {
+        /*
+         * SEV uses these notifiers to register/pin pages prior to guest use,
+         * but SNP relies on guest_memfd for private pages, which has its
+         * own internal mechanisms for registering/pinning private memory.
+         */
+        ram_block_notifier_add(&sev_ram_notifier);
 
+        /*
+         * The machine done notify event is used for SEV guests to get the
+         * measurement of the encrypted images. When SEV-SNP is enabled, the
+         * measurement is part of the guest attestation process where it can
+         * be collected without any reliance on the VMM. So skip registering
+         * the notifier for SNP in favor of using guest attestation instead.
+         */
+        qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
+    }
     return 0;
 }
 
-- 
2.42.0


