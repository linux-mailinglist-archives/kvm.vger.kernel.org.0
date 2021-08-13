Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0623EB47A
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 13:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239815AbhHMLTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 07:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239428AbhHMLTO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 07:19:14 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A31C061756
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 04:18:48 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id f5so12727124wrm.13
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 04:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5Mmkam9O/UpwiQ+qQ55WV4Lak3wddszqynkZDpggYeg=;
        b=hVGNcmbpPNABi/+DJAEUpsh+l5uRF0m/O/ZoEipftTBxu0PN8vCpTmf8RMR7RFS/p2
         LOOI7s+zOq+ib6L2PxHcvzQ9ji1ilMVaqeMAFMbb0r7M3unvfMzloHVGA8raOOlqVOFt
         HBFOPb1Fqzjr3C3V/Ext9koej8+UtM9gePyIIjGAXV+fPxkvwEyW+p0srEzoIxreJ0rv
         jibSEOwFIogmvAh1hA/X/5jwUedWfNydHhj4kFkQtmfQhPofxcA0t7YzPnUUq+PiMiS8
         mRb4+fWz6EpnQJp8V20lv08XNrWyfq4jGCTHSedpIHnlDXBni74LYT8KY1FAEd5iB2t1
         WK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5Mmkam9O/UpwiQ+qQ55WV4Lak3wddszqynkZDpggYeg=;
        b=tvzk3rY0jV8oYtqvUe5oTna3U3FZw9+pLQxWa6nnJp0SlHdUwEJHbQQb/HzbpHYYvT
         a/UX8+izt7TQ1U475VQU6uK28S+uL/tmlPY7gDs99OxQzxrehzmJ2ZuLySM/1ZcKpVo4
         QnA4wX8TNoIl3Irp99HHlrUQI3F725wXzvJcbnItBad4qKAP+5QcOoH0WTQRKG7SbIxy
         bnpfsh0DnyspH5LKkfZNCXXvRcd8aGVGDJM+gPD1tO1KOUmB+VhjR9TSkCILiUpzXppe
         Tjifsn9/p37d3WmEfgDg2YgmLi2k8Anp/spbSWcY8AfzbT/tirVPWFaCOvvkOVTcIzB4
         k09w==
X-Gm-Message-State: AOAM531ccD+oL6rieqJb5c/mDL1qhKpA7CVbTglrFYKW121QyUolZoxN
        CDagSQA+I4jW5N9KnimmR3fBVHYBjpY=
X-Google-Smtp-Source: ABdhPJyj0tDMcxpF06RNhlEUXe4qZh0zMmL0dxHC7cxgcMjNRJ8IYkKYnVgRbzyH7xBdm/wwn28hXQ==
X-Received: by 2002:adf:bb85:: with SMTP id q5mr2447106wrg.186.1628853526787;
        Fri, 13 Aug 2021 04:18:46 -0700 (PDT)
Received: from laral.fritz.box (200116b82b135c001c03be39bbe0e42b.dip.versatel-1u1.de. [2001:16b8:2b13:5c00:1c03:be39:bbe0:e42b])
        by smtp.gmail.com with ESMTPSA id i3sm1143777wmb.17.2021.08.13.04.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 04:18:46 -0700 (PDT)
From:   Lara Lazier <laramglazier@gmail.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Lara Lazier <laramglazier@gmail.com>
Subject: [PATCH kvm-unit-tests] x86: Added LA57 support to is_canonical
Date:   Fri, 13 Aug 2021 13:18:33 +0200
Message-Id: <20210813111833.42377-1-laramglazier@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In case LA57 is enabled, the function is_canonical would need to
check if the address is correctly sign-extended from bit 57 (instead of 48)
to bit 63.

Signed-off-by: Lara Lazier <laramglazier@gmail.com>
---
 lib/x86/processor.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index a08ea1f..3b43fc4 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -640,7 +640,10 @@ static inline void write_pkru(u32 pkru)
 
 static inline bool is_canonical(u64 addr)
 {
-	return (s64)(addr << 16) >> 16 == addr;
+	int va_width = (raw_cpuid(0x80000008, 0).a & 0xff00) >> 8;
+	int shift_amt = 64 - va_width;
+
+	return (s64)(addr << shift_amt) >> shift_amt == addr;
 }
 
 static inline void clear_bit(int bit, u8 *addr)
-- 
2.25.1

