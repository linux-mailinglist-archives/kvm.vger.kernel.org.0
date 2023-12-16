Return-Path: <kvm+bounces-4615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FF56815971
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:44:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1252B2861D3
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:44:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A53F32E632;
	Sat, 16 Dec 2023 13:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CCLmaGfp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4262E3F7
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6d411636a95so121376b3a.0
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734231; x=1703339031; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J9vi9A8BnmxecfXccnjGMyaVEwAoVGuHqLljFDxu3Rs=;
        b=CCLmaGfpQYQKch67HA98QRNbRnbFi5+wHvNZ3v/WHjyJFhAwg+0gXCxBaFMsxe6XeN
         64fJ+lhbcvAMqnHT5coQ+82I8JKjZ/7RY1So874K25E/1fFPLCT25L9lTj0/ncTauNgq
         pcrPG0ri5sUpuOx0Gu109o5KnH0Ooy425avlzRjdj44C7UDe2iv7Y0kABkoT5A1YsaSA
         CPx75O8bS0s2vsb58zSaz/6/n8/lE64Gls9sB+pw7JO6n0YDE3ik7y8+vAlG3eqpOA+F
         KvWrdepPXOR2CqhL+hteJQc+3DZg06mVsutJ1p1dHja7j5uhzpSEevHvFZvyzo5ZEZFC
         yjow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734231; x=1703339031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J9vi9A8BnmxecfXccnjGMyaVEwAoVGuHqLljFDxu3Rs=;
        b=GvC4ghjZ5pN0QkeT1jgrkygPuU/wH43tj7lc+lLjuxyIgtnNSAKt2ouqrtusMT0s3R
         9f0poS4wUiNi1oq6DOo6V/SDH/g9r0+YK2TBgAANh4plxFVoOEwZrcjNpZecsZC5xmr6
         KXVlSPFYcoa+X2fYxVxdiHgUqbsidfDmNCt75W8fIt3V/2FWyA0yj9tybDEW3sXfr8ZA
         NQNlngDXrxN2nf0Mmb3TYMj/PCvTVl20KVQvW3vJLy5pLzk2G9CZDzKMKylGwYA/L1cF
         XLxSGtlYsYHNONbMervTyDYhlWDb2Dl9CMN4Y6ARR9otaovaNdohwaQNf1MhwPJQ8a2Z
         7m1Q==
X-Gm-Message-State: AOJu0Yxth76zvwI3a1mI+JMJQOoNsNmF16UC+ebUoQgT3GkXh8hXw5l1
	nr7hE+KMics4y/3/kVUrb8Qu9MYchHw=
X-Google-Smtp-Source: AGHT+IGdwNSCwOhDAOfpfhtW+4neqd5nq+yI9WKHRC7yWx21sjisF8bpQUbPNR4+zqj564R8RiVGwQ==
X-Received: by 2002:a05:6a20:6a03:b0:18b:1f82:7d74 with SMTP id p3-20020a056a206a0300b0018b1f827d74mr18984224pzk.2.1702734230843;
        Sat, 16 Dec 2023 05:43:50 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:43:50 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 08/29] powerpc: Require KVM for the TM test
Date: Sat, 16 Dec 2023 23:42:35 +1000
Message-ID: <20231216134257.1743345-9-npiggin@gmail.com>
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

QEMU TCG does not support TM. Skip this test gracefully when not on KVM.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/unittests.cfg | 1 +
 1 file changed, 1 insertion(+)

diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index dd5f361c..e71140aa 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -65,6 +65,7 @@ file = emulator.elf
 
 [h_cede_tm]
 file = tm.elf
+accel = kvm
 smp = 2,threads=2
 extra_params = -machine cap-htm=on -append "h_cede_tm"
 groups = h_cede_tm
-- 
2.42.0


