Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9E6640C7F
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbiLBRqJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234272AbiLBRpj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:45:39 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD32E11AA
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:45:29 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id e8-20020a05600c218800b003cf634f5280so2192863wme.8
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MnK0SbAbrFxX8lABSVfT8kY69zxWWvrnpuk1/1B8fuk=;
        b=kSuBJdt+hS5x3ZHEtRSrDlEuNlbOEXIMnxwRPZ1SivIweURft1uP22Tg/yGUhCatxW
         3G+9hc+K3EzL0ZAgvmTbOVgPvmGyonkqK/VvQrN7MqspXdSmMO3wCuonF/qZ8TZTn7JG
         TeWtmuqzBEBdUJ7jEci2npqJ1xVMHlySE9Mgs9m8E/K5jVYGmBslrxfUgIqJ2k1D7L3n
         ur1evyor+vBw78mHpgLnRE7tXpw/slvUBFibv+k1FijXJk9BzVfONSwJ9sWxP6lm8vre
         o1WaRs1Z8uI3glhb0g7EUQJltwLqoyFA5qKqk/CuwOcAlPMFHGwAURXoig2/ub4cxkh6
         HnNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MnK0SbAbrFxX8lABSVfT8kY69zxWWvrnpuk1/1B8fuk=;
        b=hCm9wwBgu0FJEW95UNgpVNekwKlPU2vkbQElT4qRFMGdMA5fZ7eXb/jPqoLbTcaLf7
         YoPYcZX25ePl3KZ/K6gJEu8TNbvq5sFHlVI6AZcRsHOORTr9dID9Ej2WyFLakUrSJZOt
         1r6hs27zxoPNNK55psI1M2QuqIFqFksvLRq3klpAxZMFt/EQLeqL7vjrnlOxDB+LGk2S
         vM2/PSG+b22r3wZlEBziAqLGfwkdZywXOu2fRQfafvRQhq3u6AgqCQf6tCuf7Nlbmnkw
         HsOgfBUMkZduDgXBjwjW+yGeHbP++wOT/D2UO77fcO3MadvtKwMu4zqynN3/4fwN/vIy
         efpQ==
X-Gm-Message-State: ANoB5pljl4DF+erej4Phmzb4SF4DD5RH/9hWV1o/l3z/15f344ZibHYV
        Eoh+Mzb9Te4iuF3ZoqngTzIl4RURspV3QV1TlK+eU9a8s/oVOMvE/9ZMnWUOpktvQr3DXEoVzQY
        /Te939W8K1KNTovdJ8WzgTs6n4fQZ57zcCk1/qoLohXHX/AwWa494T6c=
X-Google-Smtp-Source: AA0mqf5nPWg/qdRIXxY5gq6kDrNPAC3zIzmRYFmoWPe7h3o/QDE4od2BgTGULPcpbtgkL4ehwyHFzh09aA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:3d08:b0:3cf:e84d:6010 with SMTP id
 bh8-20020a05600c3d0800b003cfe84d6010mr43895963wmb.197.1670003127164; Fri, 02
 Dec 2022 09:45:27 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:44:17 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-33-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 32/32] pkvm: Unmap all guest memory after initialization
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, alex.bennee@linaro.org, will@kernel.org,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In pkvm, assume that all guest memory is private and unmap it by default.
If it's shared and needed, the host can map it later.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 builtin-run.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/builtin-run.c b/builtin-run.c
index 9ec5701..23a4f8b 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -780,6 +780,9 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 	if (init_list__init(kvm) < 0)
 		die ("Initialisation failed");
 
+	if (kvm->cfg.pkvm)
+		unmap_guest(kvm);
+
 	return kvm;
 }
 
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

