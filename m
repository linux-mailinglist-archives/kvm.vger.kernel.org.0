Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1A92B8097
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 16:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbgKRPbz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 10:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbgKRPby (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Nov 2020 10:31:54 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2690C0613D6
        for <kvm@vger.kernel.org>; Wed, 18 Nov 2020 07:31:54 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id ay21so2451761edb.2
        for <kvm@vger.kernel.org>; Wed, 18 Nov 2020 07:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FwP65fTRBjJQOZTuLRa465u12tCsPFehRRoZ9l9M4Ak=;
        b=NlgRJL/Cae3P8zfPrpG7Ys7H2L1c/bhLjHaY1tJqTVN/HIcCl137mJ+M7tjQii7HSz
         7/13IqpUAed32nJyOyu8h6fm6e1cLJBaAAwr3klfcwyh2PK4acgPm4HAQWbR1q04IJrY
         XHUPbx033YZzTDMBGvQD2bMVv/B0ckiTJDFWjK21/rcc0Flp3uWD5+1UWR8rQo5JQzDM
         aKWFjTO88c3aIVkHqGQgSdigM9WqRWBl35taQkNEqj4gxaXRPAJA/+uNrwaJkA/MozNx
         szHOKXFVo0sUYe++Q62xVTGCkMfqn97t7yyAg6hW+jNHexWjL2uPVngJEOjjv9a3yzq1
         AyHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FwP65fTRBjJQOZTuLRa465u12tCsPFehRRoZ9l9M4Ak=;
        b=lsnDPXyExUslAMcxp1Hx+OWBhKQyB1QPNQrH3kZ2i1hoPHpRAkAyhbAj0MxNjwJm9y
         vdX//Cye82fF6I7zJU+27zklDhJw9qhv8GafPU3Ij3Htigwm+8lF145n997bRQWk+GJi
         H6YJYwYWGDr2H+VyCl9AekmfRNDjezdfD4MnfBsQ87YQPZgDwbqbtfO+y7dpfJwXONhU
         KP7fECivhHM0iBGF3XAfnZRoLKfzM90z/NEBjEgKhDKvsSGM7sxu20nZJVZ3vM2Ov//p
         o6pO3aodvd6hJp5j/uR/fkH+Xng+nEGBpHKQAnFQFXfXaQ3H2JHUMFWEw9rtbiAqSqt5
         wDuA==
X-Gm-Message-State: AOAM532HRN9H0707x7D4PEMHq5Gj2AhqPqSla6H5br3dWELYm3Ukb8k/
        hTD+UiSSdsM8CqXolQjuU40=
X-Google-Smtp-Source: ABdhPJw6ucG29s9FXIqAGWTrU8gli8mtYZvzOjyI+qbTm0g2sBMjhDFe/vm8hQe+/EpnaWRe7LFt7w==
X-Received: by 2002:aa7:cdd9:: with SMTP id h25mr26649646edw.294.1605713513399;
        Wed, 18 Nov 2020 07:31:53 -0800 (PST)
Received: from lb01399.pb.local (p200300ca573cea22894fd6f5c6d10f88.dip0.t-ipconnect.de. [2003:ca:573c:ea22:894f:d6f5:c6d1:f88])
        by smtp.gmail.com with ESMTPSA id k12sm13150456ejz.48.2020.11.18.07.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 07:31:52 -0800 (PST)
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, pankaj.gupta.linux@gmail.com,
        Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Subject: [RESEND kvm-unit-tests PATCH] x86: remove extra includes
Date:   Wed, 18 Nov 2020 16:31:47 +0100
Message-Id: <20201118153147.8069-1-pankaj.gupta.linux@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>

Remove extra includes.

Signed-off-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
---
 x86/vmexit.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/x86/vmexit.c b/x86/vmexit.c
index 47efb63..999babf 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -1,7 +1,5 @@
 #include "libcflat.h"
 #include "smp.h"
-#include "processor.h"
-#include "atomic.h"
 #include "pci.h"
 #include "x86/vm.h"
 #include "x86/desc.h"
-- 
2.20.1

