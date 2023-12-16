Return-Path: <kvm+bounces-4619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AECA815975
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:44:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA50428564F
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22E533035F;
	Sat, 16 Dec 2023 13:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JE5ytiAU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3460730357
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6ce939ecfc2so1499430b3a.2
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734247; x=1703339047; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YUAtQDtApcgVJAqnWOXyR/Ya4iTsAGlBvKQ21gyDzAY=;
        b=JE5ytiAUwu9ZMjg0rSofYQH2uHgyrF/NpWPhC9qcsKvjCRNVrDWtpe9Neg2p3Os8w4
         zDwr01zOMLBvaiuErT1leP89YQx2MGItp2ik9plCiURnuDyenRQosaxgIyv96vYl+i5d
         uqiqpmigUo9EsFzP29tFp04c3nl956mBkettfZKNW/rCfkJWAUtdqlpGJBytXwVKb/JO
         EcGlCMUw6uarT3+h01w4ycYQQQMCMbHl6B4Gmu8Grh4+FLXWBf9nPLNzvXbBgigE5x0w
         oJJ3lEXyMBafVP4DpzPUoE03YiynPSmIc2XAPRvxaYliVu5uYE0k9em6HgS+RpGvAw92
         m3rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734247; x=1703339047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YUAtQDtApcgVJAqnWOXyR/Ya4iTsAGlBvKQ21gyDzAY=;
        b=ejat63xwsSQnuA1bHS+gLq3NesflMYEWJvYngPXnfzp2CzxSgkh9XWJdpWAh/MzhKC
         bp/v+ZS9QshXCwS+DidiO1b6ShQN60IjjW4YX9boQQ79FEsRRboCE5pea/Vg3fQr4n5P
         NpULBdQE/K0H8/Zq/CXJ0Tj+1M2mIjlWmnqcnHQOnAXsXv/m2TBCsTDliLelvIsUP9en
         ymoy2qejnT/TmJzKMxF8elZtfETGy71QPjvJmCjhDp+gXskFNHGlWOU+0V7JgWhq1rRs
         WTc3v1B1RW4KVDZc1B3oG60F6OqoojxBml4IIDsIOZ73FS+MCv2cjiKSoG+t0cuktY/9
         Zh8w==
X-Gm-Message-State: AOJu0YxHjc6xVyTfFe6mlg/672pVXJMe1lIRAxSNsElr6yZgnBXsJITu
	1pjdGpCbgAiJN5gzv4gM3SIqzJyX1XU=
X-Google-Smtp-Source: AGHT+IGXiPYOu3Brmfx95kDfKpD6ZJoVeXT7ugdb1G7RY9S++SLmazxazUBOvPCTWBw75wG1Vk42Yg==
X-Received: by 2002:a05:6a20:2583:b0:18c:d38:9169 with SMTP id k3-20020a056a20258300b0018c0d389169mr15658268pzd.21.1702734247178;
        Sat, 16 Dec 2023 05:44:07 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:44:06 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 12/29] powerpc/sprs: Avoid taking async interrupts caused by register fuzzing
Date: Sat, 16 Dec 2023 23:42:39 +1000
Message-ID: <20231216134257.1743345-13-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231216134257.1743345-1-npiggin@gmail.com>
References: <20231216134257.1743345-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Storing certain values in some registers can cause asynchronous
interrupts that can crash the test case, for example decrementer
or PMU interrupts.

Change the msleep to mdelay which does not enable MSR[EE] and so
avoids the problem. This allows removing some of the SPR special
casing.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/sprs.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index 01041912..313698e0 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -481,12 +481,7 @@ static void set_sprs(uint64_t val)
 			continue;
 		if (sprs[i].type & SPR_HARNESS)
 			continue;
-		if (!strcmp(sprs[i].name, "MMCR0")) {
-			/* XXX: could use a comment or better abstraction! */
-			__mtspr(i, (val & 0xfffffffffbab3fffULL) | 0xfa0b2070);
-		} else {
-			__mtspr(i, val);
-		}
+		__mtspr(i, val);
 	}
 }
 
@@ -536,12 +531,7 @@ int main(int argc, char **argv)
 	if (pause) {
 		migrate_once();
 	} else {
-		msleep(2000);
-
-		/* Taking a dec updates SRR0, SRR1, SPRG1, so don't fail. */
-		sprs[26].type |= SPR_ASYNC;
-		sprs[27].type |= SPR_ASYNC;
-		sprs[273].type |= SPR_ASYNC;
+		mdelay(2000);
 	}
 
 	get_sprs(after);
-- 
2.42.0


