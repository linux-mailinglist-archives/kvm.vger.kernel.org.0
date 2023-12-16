Return-Path: <kvm+bounces-4629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E5CC815980
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:45:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3AE60B23A3B
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E964C31A83;
	Sat, 16 Dec 2023 13:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LyFgs7Qw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098DB31A64
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-5cd86e3a9afso80562a12.1
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734288; x=1703339088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=++ZpxvP8vNWeF7k9O8gsby5Qru97SRT8q80ApP6mYYI=;
        b=LyFgs7QwTxIwt3j66kRdmPs+KxS0VR06tnv+J2RcVAlb7/HCr6tAin5yTpZSCy6GFY
         Kfw06RSj8IwVDiyKbav7wW9QOi9qgFxBRnTg3jKF0EA6yZNyYXdyeXnQql0ZNrdmvE77
         tJLzpUMtAKe4XqQgFq9ftv8J3Ev4lHNlStfTD1RfzmDtHGIl8Q8d6jjKlO0ZFMSYMMtw
         YOECtXE1wvpCh/WY3gIlxnNjxEAuvR/GY8U3nj4er7W0oJd1FismVzUQnBzz2v9D8Xoi
         g/DkHAD7aFshDXN6JMkrPEHIxNvhFAt+Aok0yA/U0YqZHlPjHdMN+OLnVVDh0yQfMiIm
         BzTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734288; x=1703339088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=++ZpxvP8vNWeF7k9O8gsby5Qru97SRT8q80ApP6mYYI=;
        b=UOhFZNLZHG/tPcdFs9PNc7puy0jNcya74sGvSeLcTLn4RVoNSBnV1dt4Id7MAn+pcO
         HE7ftBpdRNjmb7u1pBnVc+rwztnLMg23dw7VSjN3QLe03DtjgIeEEhG/LHccZsY5xpuo
         KuERS8GG/djmAbRbT4XchGwDDxemEtBL66VkjmjUVnFBOjLgVQyFTHIjQFtAn8BYAzsr
         WvSZ/zI73YEjsjXXIt1HUYqpuzmM2ymW3e0GA8RyXWD992zqv8PMcYz/7SR3j5XnDS7V
         SeSasMD7yERps0WhjCjeey0eM0uAwCcvVdaM4w/xE3vDTqiXTMrZLh9+NTNXTuSioDwv
         oWkw==
X-Gm-Message-State: AOJu0Yy3BxvMyc1AvwAAK7E52ku0qBdU/+qf7zRW/0bXdvIRWdTNOupt
	1u+CcibivQLpLjfV3aGNItEXTD76gPs=
X-Google-Smtp-Source: AGHT+IEypAbmCCWLwXKqe4Re1RxPWLqJQ80AzT3PY7FXIpVeefqeGBi4L08W/+Vfrm9dgD9hI5QGig==
X-Received: by 2002:a17:90a:2f64:b0:28b:430d:ad20 with SMTP id s91-20020a17090a2f6400b0028b430dad20mr1741659pjd.3.1702734288005;
        Sat, 16 Dec 2023 05:44:48 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:44:47 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 22/29] powerpc: Fix emulator illegal instruction test for powernv
Date: Sat, 16 Dec 2023 23:42:49 +1000
Message-ID: <20231216134257.1743345-23-npiggin@gmail.com>
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

Illegal instructions cause 0xe40 (HEAI) interrupts rather
than program interrupts.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/emulator.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/powerpc/emulator.c b/powerpc/emulator.c
index 39dd5964..035a903c 100644
--- a/powerpc/emulator.c
+++ b/powerpc/emulator.c
@@ -31,6 +31,20 @@ static void program_check_handler(struct pt_regs *regs, void *opaque)
 	regs->nip += 4;
 }
 
+static void heai_handler(struct pt_regs *regs, void *opaque)
+{
+	int *data = opaque;
+
+	if (verbose) {
+		printf("Detected invalid instruction %#018lx: %08x\n",
+		       regs->nip, *(uint32_t*)regs->nip);
+	}
+
+	*data = 8; /* Illegal instruction */
+
+	regs->nip += 4;
+}
+
 static void alignment_handler(struct pt_regs *regs, void *opaque)
 {
 	int *data = opaque;
@@ -362,7 +376,10 @@ int main(int argc, char **argv)
 {
 	int i;
 
-	handle_exception(0x700, program_check_handler, (void *)&is_invalid);
+	if (machine_is_powernv())
+		handle_exception(0xe40, heai_handler, (void *)&is_invalid);
+	else
+		handle_exception(0x700, program_check_handler, (void *)&is_invalid);
 	handle_exception(0x600, alignment_handler, (void *)&alignment);
 
 	for (i = 1; i < argc; i++) {
-- 
2.42.0


