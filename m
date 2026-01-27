Return-Path: <kvm+bounces-69188-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uPsfCUtKeGn2pAEAu9opvQ
	(envelope-from <kvm+bounces-69188-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:16:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 74D008FFD2
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:16:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9A7723012EBF
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 05:16:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6674C329387;
	Tue, 27 Jan 2026 05:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bbRniVQZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uhb8M1hv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56323242925
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 05:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491000; cv=none; b=k+gZV/TxmS5db6UvpR7dp9b7DjsI0du9C48o49L13WPnf6fZz1NrAc6AlxIKsdZWokVWsjxJ/a7IVDtSOTGCOnS0NiHfFo3PaubnMnGfv7O35J09Kx5isujkYYMXwysSu7qhE+6Bz9wX5FboFsg+Qbw1r4atR6WSgPaXKLf6lLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491000; c=relaxed/simple;
	bh=bm79w2PJYnuKL5B43j7eXO9kPpjmW1vbDan2MVWOKQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlaTFSv1MoYnmSMOH1dEwTrTeLQANk/uGgwPOC20h8n/FIlCS4WwnCdQAXk++EcKiQ2B6XItk2j2FJ9mAFWJyP0D6FSA4kgbFqjcUZI/Tm/WeFl0h856IFBCUl2uYVQwYQc18zki6tiDMjpvYheS6D+MLjvKJh0P5UGhHTTC5P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bbRniVQZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uhb8M1hv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769490998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g+khot+OVhL5+e3tOQKUptJ6m/mk7Ksd4tDhst7pTHg=;
	b=bbRniVQZuq0ZR4EpvIbwWm3hB2rzbAlFwEkFetzfpdEnAgA4cBABgAugZJFN5L1odjSqCM
	0CAaChgoHtIn9U7KvZzJgnmdFKyvURwhUL/clyvo0LMJ5x0xMZAlSYpptKEDNhE+24ythy
	EMGaw6xEPlc+aAhPeD0fpw96o6+fy6g=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-3pEQQKLVNROl5FOFnef5Zg-1; Tue, 27 Jan 2026 00:16:36 -0500
X-MC-Unique: 3pEQQKLVNROl5FOFnef5Zg-1
X-Mimecast-MFC-AGG-ID: 3pEQQKLVNROl5FOFnef5Zg_1769490996
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34c38781efcso4920441a91.2
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 21:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769490995; x=1770095795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g+khot+OVhL5+e3tOQKUptJ6m/mk7Ksd4tDhst7pTHg=;
        b=Uhb8M1hvmzyK/ig9wWtP9J23taA5KsWWEg9DCR0bwRr8J8NkGZ3iChCDHwZdKpJ6hw
         w1s0qGLa6DLoqjnl9PhlhL9O9fWzYLIdm9S7T3oP1wDMgsuabPrrbREIhYsDFGPP4Q5E
         cXwdKeW4TlxDArjA2p8XjCCjNhjI/ivoLekPygzsWzhZeMd7/6yaZ6UTh67JG6cylBP6
         i4X2JLCthd/Ruy/K3Ermq4ia8y9YAZwfVhKLa1HDJxBF3ELxEegDid8KMmmY1XEVwzf4
         Xw8klYI0v5KjFROMpU1tBnSEVDdW31mP9MD0E13Q12GDBklpWr3cIqWSENBuj/unuAbD
         7ONg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769490995; x=1770095795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g+khot+OVhL5+e3tOQKUptJ6m/mk7Ksd4tDhst7pTHg=;
        b=se8SQInzBjCLvHQtAO1n42pSVVplQ89gpSRacYs9CqlFFmS3XkohY+yP/T0MnmHTRP
         1flv2hIs/BrbpGqkgYJ+eOXFdmvDSSAyVz6aJlXiss0iTTMP405RFTub6P8exzsFzNmO
         1sQmR2el9JMQ1y4Un7gAIb3xofWp0j5MYmOJ9NwzhU5hX5QAUw2cS3WMv5p8SNwgmdM3
         7ys4kluULisX/aocomQm62l2VcwVdqvXtm9Cuh1do26yAb/t+THuiT0m1/nPCwCtJFKc
         z+hkJutgXPm9toTMec4/X6fFAk5JKWv4ATxHgjO/vw4soE+Pl8Qi6GSyjdWy+nZWXmCh
         TZHw==
X-Forwarded-Encrypted: i=1; AJvYcCWWh+6BIoc/P4flkoH8EcSlxQQ4P3Trr6sZ6xcPAvGblmk9gaNXtutzbz91f+qmHYykrmo=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywxl0PvYXFLrxDpjaP0KJhQL2aT0LoIWUxv/pjr3FVD9oZMggwl
	nX+H7O5Stth2QJdVk1Dpw2ztttHKqmaAu+FtimAuFtgy9LYt4TIBrePIIcFBMMeDCmUpO1ttSq5
	rV9ePEcuvgG/2auK37HU3TRsw3judkLQhb5QpKddxaYF+8fet/z/rNv8xJpPz4Q==
X-Gm-Gg: AZuq6aLDGHJUWxW6jP+lPE5xxLuQX1NFTXwBnCpHVSwuZWjuV2y5O3Rqn/9BDycdQu3
	/qqFnUWzr0eGUQ0Y/Os3yLsGuLqgOnSiiIYtRm2fmBUWxLPDCcxhyOAZo8AxAilyRyhvZMAKm/6
	dLRqZ5X3ItPKqI7dCyY2Hg8g0GZIdaZ8PIjNVTqln/p3HO0KMsQKa0JtVI5PzjP/cF9dpry1aR5
	8LFj0/ZCbwx0y6uXQ6YDcuTkBnm0grpXSxQWOfpe+XVDbO8sXtGhc2U3IclG86jnDjeePY1WMlD
	Fs8opYGyjaKt2zCFQ4//e7WyKJE3HLRaAquPN2JdzpH0s6dmBGtbkuKoH1lh8DOESqoWtNvXYh8
	Oy1Q+YnoblstyB9GsusHMUiWG2wXCEHFbEn/y/zTtUw==
X-Received: by 2002:a17:90b:5208:b0:341:c964:126c with SMTP id 98e67ed59e1d1-353fedae2a1mr663344a91.34.1769490995481;
        Mon, 26 Jan 2026 21:16:35 -0800 (PST)
X-Received: by 2002:a17:90b:5208:b0:341:c964:126c with SMTP id 98e67ed59e1d1-353fedae2a1mr663332a91.34.1769490995166;
        Mon, 26 Jan 2026 21:16:35 -0800 (PST)
Received: from rhel9-box.lan ([122.163.48.79])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-353f6230d5dsm1110925a91.17.2026.01.26.21.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 21:16:34 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 01/33] i386/kvm: avoid installing duplicate msr entries in msr_handlers
Date: Tue, 27 Jan 2026 10:45:29 +0530
Message-ID: <20260127051612.219475-2-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260127051612.219475-1-anisinha@redhat.com>
References: <20260127051612.219475-1-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69188-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 74D008FFD2
X-Rspamd-Action: no action

kvm_filter_msr() does not check if an msr entry is already present in the
msr_handlers table and installs a new handler unconditionally. If the function
is called again with the same MSR, it will result in duplicate entries in the
table and multiple such calls will fill up the table needlessly. Fix that.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 7b9b740a8e..3fdb2a3f62 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -6043,27 +6043,33 @@ static int kvm_install_msr_filters(KVMState *s)
 static int kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
                           QEMUWRMSRHandler *wrmsr)
 {
-    int i, ret;
+    int i, ret = 0;
 
     for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
-        if (!msr_handlers[i].msr) {
+        if (msr_handlers[i].msr == msr) {
+            break;
+        } else if (!msr_handlers[i].msr) {
             msr_handlers[i] = (KVMMSRHandlers) {
                 .msr = msr,
                 .rdmsr = rdmsr,
                 .wrmsr = wrmsr,
             };
+            break;
+        }
+    }
 
-            ret = kvm_install_msr_filters(s);
-            if (ret) {
-                msr_handlers[i] = (KVMMSRHandlers) { };
-                return ret;
-            }
+    if (i == ARRAY_SIZE(msr_handlers)) {
+        ret = -EINVAL;
+        goto end;
+    }
 
-            return 0;
-        }
+    ret = kvm_install_msr_filters(s);
+    if (ret) {
+        msr_handlers[i] = (KVMMSRHandlers) { };
     }
 
-    return -EINVAL;
+ end:
+    return ret;
 }
 
 static int kvm_handle_rdmsr(X86CPU *cpu, struct kvm_run *run)
-- 
2.42.0


