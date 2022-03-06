Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6FAA4CE867
	for <lists+kvm@lfdr.de>; Sun,  6 Mar 2022 04:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbiCFDUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 22:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiCFDUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 22:20:08 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15DC31DD1;
        Sat,  5 Mar 2022 19:19:17 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id o22so1028081qta.8;
        Sat, 05 Mar 2022 19:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lMASJJCoiiD92VG8QMsK+BGdXGVonOXG2QPBFjtPUH0=;
        b=C07TzkzVmbn2w2dSL8xl1ynvgj9D5nMDYoopeFBaueQoZG09BSRbWTTrBPVmeM45dO
         aMVrxysvvxahIhhz4OQDZFL5I1zq3feiXtWFDlLCYHHiDp+xSizKGDolnUQbvbOFNdNG
         93frbCYCdSnI8V3Lp9lNWFQIyO6D83Hzy9hyOHF39VG03TmaQtXIXsU8rwYW0AJUBq6h
         D7aZw4+Oey+7BXxVgiS0isurg2ItV2uBOm/VdA9bqrPLahKOrLPM5PZzjDaL96eNAZZl
         XD4woM0yrzKs0lp1utRlvSKd+3Pv0rJfkGX/UTdutKbHexkwM6iABpSlSpuzQWCeOvmb
         RbgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lMASJJCoiiD92VG8QMsK+BGdXGVonOXG2QPBFjtPUH0=;
        b=NWLyrj5huAHRYk9N4M+Sba7TH/KyqyQYSi8pbnVEjFaIuOVDzb0oRqOXITWripyaij
         UuTgumTCOiITsQGmHqftGw/sy3cCVAQJ8WyvgIhFUq2Fbn8WCR1Mf6GMCZ+K8HbsyK8/
         Ycy4DRkk5A19Uxdfp8zMUMlZ44e4Xthcqr+sMz106+OcyDafosyuxWV8b0LXRSDY92kX
         afJvZu6mxcJ2WJtSneMu1YVGIhwW/OvECL9SmvGik7Z3bREgrW5MKVyUHxuq0cVSUbWX
         rlPoWL8rxntwReFGDjG7vfuEHDG6CNTvCROHY/bOrNk3kQ7vrDSbJBjxixKnI1dNVRTS
         BFcQ==
X-Gm-Message-State: AOAM530xRyHL7eT5P8uO2GX8Q3vBeixXZtBYULu7avnUp5akCSrunZ46
        ftjZOSWo/jF312rI9+YLjDFEPUyFmgE9lrQr
X-Google-Smtp-Source: ABdhPJxHV2OTx6ktsXZAftaiD46wElnrSobZuNZaREkSrDP6zSOHAIuYlZDtqqrzzQ0yCxKdmZoQ8Q==
X-Received: by 2002:a05:622a:8:b0:2dc:915a:9d20 with SMTP id x8-20020a05622a000800b002dc915a9d20mr5039048qtw.74.1646536757060;
        Sat, 05 Mar 2022 19:19:17 -0800 (PST)
Received: from henry-arch.studentwireless.binghamton.edu ([149.125.84.173])
        by smtp.googlemail.com with ESMTPSA id f1-20020a37ad01000000b0064919f4b37csm4463183qkm.75.2022.03.05.19.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 19:19:16 -0800 (PST)
From:   Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, Henry Sloan <henryksloan@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/7] KVM: Use typical SPDX comment style
Date:   Sat,  5 Mar 2022 22:19:01 -0500
Message-Id: <20220306031907.210499-3-henryksloan@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220306031907.210499-1-henryksloan@gmail.com>
References: <20220306031907.210499-1-henryksloan@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixed some checkpatch warnings by adjusting comment style. C files have
been fixed to use //-style comments, while header files have been fixed
to use /* */-style comments.

Signed-off-by: Henry Sloan <henryksloan@gmail.com>
---
 virt/kvm/dirty_ring.c | 2 +-
 virt/kvm/kvm_mm.h     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 222ecc81d7df..f4c2a6eb1666 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * KVM dirty ring implementation
  *
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 34ca40823260..41da467d99c9 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0-only
+/* SPDX-License-Identifier: GPL-2.0-only */
 
 #ifndef __KVM_MM_H__
 #define __KVM_MM_H__ 1
-- 
2.35.1

