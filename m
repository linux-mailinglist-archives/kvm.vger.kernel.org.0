Return-Path: <kvm+bounces-4609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6579981596A
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:43:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05AB31F232FF
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ABC32E623;
	Sat, 16 Dec 2023 13:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WziPzlpO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6092E3F2
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-2039cb39b32so145748fac.3
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734207; x=1703339007; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EawXcrWZcj4wjBdULRz+yh78MdJFfpIVMXufen8CLio=;
        b=WziPzlpOg0LjOG+kNlY2Pa3FB6TLnHf1jnu2iGUCn1kx7q3ipQ9k3zzml2zdBUUZUo
         IUBqGr2S4A1I118jAADxsounUTyCSOMqyhUOISKQYM5hwUM726LGe9tZS2y90W2WP40L
         8VAECXulvKg0R8tyxLw5lnAD4a43qpWKJQDp7vVDWG4rQV2HW0pPoqEQQbKafpTtmYWx
         XXHtxFIhYleVxGsSIgUj8ioU9ITE/8+M9uafwg4Qso4gjwiD7zmJFKPJdmsRIyNwCwDM
         zdRyhOTXNm8L8KzmILi7KqY6FP36+vgWsiT+JZ+m0bkNWgaerigH6QFPQtAB4uPyCxpe
         5KHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734207; x=1703339007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EawXcrWZcj4wjBdULRz+yh78MdJFfpIVMXufen8CLio=;
        b=muHFatMTYxss0ztYQHROuDuG2nLjCWg1z9YnLpD3Z4briqxPfw4b89S7KJC7RBDLuN
         oMOf3aIL+3FJcyAKd+GhWA+w+zI9vN5iV0z9vUYq1yHwNRlwoF5Gwd6v80lk8N8DDT8w
         E95UraAOdr8+Yx8ywtKf7qIrjieIZVlLtdPeJDImOmgRkLlEe/xU2q6lVXFlOsjp4ZQl
         6Ryz1uYn8fX85SkPayJayMh/LYFVden1tp4WrzQOcqValVTyww5MUYdLYB7B551iARfY
         c/n/dedh5HSonPCoUR/QMMTvcuTTUjwxNUw0yAyTFQbLAo8R6Ro/xBzIYDAv3mKJMjY/
         gXIQ==
X-Gm-Message-State: AOJu0YyLQu8A30RpGD6mhC77ETihPiJFggZjUxtAEbowYz5xKlsBs6zT
	0nnIh4nE10sqgy1BZWUHQnUDC4LSK0c=
X-Google-Smtp-Source: AGHT+IEU9zGI2gfEYPclbe2FjAKlC/SIgONOnT1Zp9UynRcy6B6WBDpTyRY1h43A8d+uXhZfJbB1VA==
X-Received: by 2002:a05:6870:55d3:b0:203:83cd:c18c with SMTP id qk19-20020a05687055d300b0020383cdc18cmr1949251oac.40.1702734206762;
        Sat, 16 Dec 2023 05:43:26 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:43:26 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 02/29] arch-run: Clean up initrd cleanup
Date: Sat, 16 Dec 2023 23:42:29 +1000
Message-ID: <20231216134257.1743345-3-npiggin@gmail.com>
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

Rather than put a big script into the trap handler, have it call
a function.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index f22ead6f..cc7da7c5 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -271,10 +271,20 @@ search_qemu_binary ()
 	export PATH=$save_path
 }
 
+initrd_cleanup ()
+{
+	if [ "$KVM_UNIT_TESTS_ENV_OLD" ]; then
+		export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
+	else
+		unset KVM_UNIT_TESTS_ENV
+		unset KVM_UNIT_TESTS_ENV_OLD
+	fi
+}
+
 initrd_create ()
 {
 	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
-		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; [ "$KVM_UNIT_TESTS_ENV_OLD" ] && export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD" || unset KVM_UNIT_TESTS_ENV; unset KVM_UNIT_TESTS_ENV_OLD'
+		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; initrd_cleanup'
 		[ -f "$KVM_UNIT_TESTS_ENV" ] && export KVM_UNIT_TESTS_ENV_OLD="$KVM_UNIT_TESTS_ENV"
 		export KVM_UNIT_TESTS_ENV=$(mktemp)
 		env_params
-- 
2.42.0


