Return-Path: <kvm+bounces-698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0206B7E1F72
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:07:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 329011C20BF2
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:07:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 084FE182DB;
	Mon,  6 Nov 2023 11:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CSK+K7sw"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7233918053
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:07:03 +0000 (UTC)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F8DCC
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:07:00 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-32da4ffd7e5so2578569f8f.0
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268819; x=1699873619; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W+HrE2ba95t1ooYtGszc36ebWNEUF8WT6p6gpPtPmuY=;
        b=CSK+K7swZEwWSSxB+KJXD62WjY42VcBtBnV+/LTH2znGOyIsQQxXHW/bNVsNSSaIrM
         SMxSsCsfSOeEYlVlewbq9ivI+j3Dy6GMtcsKaUc5S7JApfDeTaSj2OT2zLxRRzGRBjHN
         14Sd7TJqOCqgOTIuO6O9QyOyGM9SEKVbg3/KQ/qH3mw9yfEmQgAE4ha3maf6Tfl0Ym6g
         NEDtQmk9lsjMNPvsebHYprHvzWSnWPsYAfvyDXwQhMtUk2vP2sIdVBA04yB9X/jF9n2e
         mfqM+Ro1VSXHK4ksQY+/DYPS6hkJ4mF2plk0Zy9mrjj+8Bpuzd7Y+cfeB9YG7VDi/GnG
         G2og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268819; x=1699873619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W+HrE2ba95t1ooYtGszc36ebWNEUF8WT6p6gpPtPmuY=;
        b=aJplUpFfhMiL6OJmwhh302F5mS3AUyVupPmObOE6/Ek41zNbMP6eDpHJnPjKu57YhC
         wavSaMvuYxWiNGy2DD6oOFXB4OSaFgZWuGBp5c+zLDlbxxER/oDbfTeu0iYFk4FQ8dA7
         51fu+Qgdw3l5JOQnq+rplfi+Ge6vk6BHfpmktm/Gc0xYdUY+JxIWQB2iZiAOGQgoWK6s
         Vp5X1zsDLz3mjcMPk81OSGzdyzPMe+Szk9KdhiJ2rQOO9b6NjalkOUJl9ZVnH8WAjSxr
         v6yAAxmhppSxiIznBP9CPoqblUvaaCrzk+60nkuQsXSc4ANjGBjRRL0BeQUux6pEcusp
         53EA==
X-Gm-Message-State: AOJu0YxE0Rq+R5Y+1wR5sWTk8KywONZG4BbycFTmeBsuV196XUyAh0dQ
	qfEGaCPBX9YN6XqcNlutLWl1GA==
X-Google-Smtp-Source: AGHT+IEt4PrEy7npLJh89eCdwNzRVAyjkPfVkzj/Lltpi44y5ZAeM5YDAM8Cq8QFxZb/uU2kaiqCHg==
X-Received: by 2002:a05:6000:12ca:b0:32f:76a0:a99b with SMTP id l10-20020a05600012ca00b0032f76a0a99bmr8610843wrx.19.1699268819099;
        Mon, 06 Nov 2023 03:06:59 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id f4-20020a5d6644000000b0032da49e18fasm9178802wrw.23.2023.11.06.03.06.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:06:58 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Joe Jin <joe.jin@oracle.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Juan Quintela <quintela@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PULL 29/60] target/i386/monitor: synchronize cpu state for lapic info
Date: Mon,  6 Nov 2023 12:03:01 +0100
Message-ID: <20231106110336.358-30-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106110336.358-1-philmd@linaro.org>
References: <20231106110336.358-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dongli Zhang <dongli.zhang@oracle.com>

While the default "info lapic" always synchronizes cpu state ...

mon_get_cpu()
-> mon_get_cpu_sync(mon, true)
   -> cpu_synchronize_state(cpu)
      -> ioctl KVM_GET_LAPIC (taking KVM as example)

... the cpu state is not synchronized when the apic-id is available as
argument.

The cpu state should be synchronized when apic-id is available. Otherwise
the "info lapic <apic-id>" always returns stale data.

Reference:
https://lore.kernel.org/all/20211028155457.967291-19-berrange@redhat.com/

Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Message-ID: <20231030085336.2681386-1-armbru@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Message-ID: <20231026211938.162815-1-dongli.zhang@oracle.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/monitor.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index 6512846327..950ff9ccbc 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -28,6 +28,7 @@
 #include "monitor/hmp-target.h"
 #include "monitor/hmp.h"
 #include "qapi/qmp/qdict.h"
+#include "sysemu/hw_accel.h"
 #include "sysemu/kvm.h"
 #include "qapi/error.h"
 #include "qapi/qapi-commands-misc-target.h"
@@ -654,7 +655,11 @@ void hmp_info_local_apic(Monitor *mon, const QDict *qdict)
 
     if (qdict_haskey(qdict, "apic-id")) {
         int id = qdict_get_try_int(qdict, "apic-id", 0);
+
         cs = cpu_by_arch_id(id);
+        if (cs) {
+            cpu_synchronize_state(cs);
+        }
     } else {
         cs = mon_get_cpu(mon);
     }
-- 
2.41.0


