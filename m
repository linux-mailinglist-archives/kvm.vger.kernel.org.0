Return-Path: <kvm+bounces-5465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 838D082245B
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 23:02:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9326D1C22B8B
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 22:02:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9596A17998;
	Tue,  2 Jan 2024 21:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TTK06OR8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9825D17982;
	Tue,  2 Jan 2024 21:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so7693319a12.1;
        Tue, 02 Jan 2024 13:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704232281; x=1704837081; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MsTHcO9Y5JVcsmfDaLhOfpZInAyHoz2K8KWwCnlqA74=;
        b=TTK06OR8+dB14S1ekOvvi07PpfoJE1QG9nVvLOwQW6I61dcT4EUWptyAoGg9zruIqF
         8M1Ziz66RqAyTJF0jdrwCQZJk5Fi0vmrvekl4vOPpw0s7QrSYdHAuuaAjnwf5mT+ZrNC
         zNgBpWYcT8IZ+3U70kEORFAt7RtyXIzBcULl9ocAj9bOQprG6I/kpAoS8xbGAlAVfqHz
         AE9EzNyVnD5Ym+uM8dVsOhSglDrqDDWlxzcNxgYrUjSNDWMO+VxSadUUDGIdUtutHmd8
         4pgFvMHk4xbvGWzf43difrfDd9N9Rijru7v8QjXKNM3uWQBdiuCj8GSRpCTy2Jd71Mh2
         9ZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704232281; x=1704837081;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MsTHcO9Y5JVcsmfDaLhOfpZInAyHoz2K8KWwCnlqA74=;
        b=FAfofU07Y7q7fXstx+hibkHcU3r/lxfjyz9ucwT5sdRkkZrFEnp42lkUxDOiy6sCHF
         Vb8cXdllnwBXf05SnyyAOAh7fK6ndCf0R+jK1sHbikDAyJ7JFnWJOz+R/CY4hPZcwkuK
         dki0sK/WTObBZjdOKGKQTIMK/Gh72vQUnyfIC0YpjGBBun7gxSCduWkHVTTK6MmgQzlK
         N4d3Zph8I9UZN+BWvep9vh2kQonvEZVJaEkfkeXQsghTXgwjH16UldV7YEoizJbeAUtK
         qcfmlCVxzIpAHi4c7nFadDrsqwxVOrZi+PnIYTAqkZHQEnrgaUhf8I9iq3SBfgmV3jep
         d/sg==
X-Gm-Message-State: AOJu0YwBDPfvM2YN8vD8TAIbSwzemXPh0UCHdsSmtkPimGykwkvP1Nsj
	DH9bymqAkz3Ah4PTz3bzazM=
X-Google-Smtp-Source: AGHT+IF4LnL5q2ASVk0f7a7NnEXHJkQow5McuAKWHQuQKCloTJ95bLjkdhs6onVHBbM8aixG9I+4vA==
X-Received: by 2002:a05:6a20:b920:b0:195:f99f:d46 with SMTP id fe32-20020a056a20b92000b00195f99f0d46mr10468670pzb.119.1704232280845;
        Tue, 02 Jan 2024 13:51:20 -0800 (PST)
Received: from changyuanl-desktop.svl.corp.google.com ([2620:15c:2a3:200:38ca:1992:d2e1:472a])
        by smtp.gmail.com with ESMTPSA id q36-20020a635c24000000b005ce979b861dsm3374286pgb.84.2024.01.02.13.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jan 2024 13:51:20 -0800 (PST)
From: Changyuan Lyu <changyuan.lv@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Changyuan Lyu <changyuan.lv@gmail.com>
Subject: [PATCH v1] docs: kvm: x86: document EAGAIN in KVM_RUN
Date: Tue,  2 Jan 2024 13:50:53 -0800
Message-ID: <20240102215053.32829-1-changyuan.lv@gmail.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The EAGAIN errno is returned when an application processor was
blocked because of an uninitialized MP state [1].

[1] commit c5ec153402b6 ("KVM: enable in-kernel APIC INIT/SIPI handling")

Signed-off-by: Changyuan Lyu <changyuan.lv@gmail.com>
---
 Documentation/virt/kvm/api.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7025b3751027..fccdbb366770 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -370,6 +370,8 @@ Errors:
 
   =======    ==============================================================
   EINTR      an unmasked signal is pending
+  EAGAIN     the vcpu is an application processor (AP) and had not received
+             an INIT signal [x86]
   ENOEXEC    the vcpu hasn't been initialized or the guest tried to execute
              instructions from device memory (arm64)
   ENOSYS     data abort outside memslots with no syndrome info and
-- 
2.43.0.472.g3155946c3a-goog


