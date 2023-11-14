Return-Path: <kvm+bounces-1662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB5A67EB283
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:39:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57247B20B70
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:39:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20A4741749;
	Tue, 14 Nov 2023 14:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="I4Ulp5/v"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7187841748
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 14:39:23 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37812114
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:39:22 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-9becde9ea7bso1375282166b.0
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699972760; x=1700577560; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UNMQSJ9n3HwpNaurQlo3tUtiIa6U/WmLwhKlbRCATs0=;
        b=I4Ulp5/vp5DjC68RrjwLH64SvFRq1P/P6ylDBXfmgUwn4bWpt2Hxc7fdQD1TuLIAC5
         8gPvJr9tIwWvDrigjTkr+Ixh+gWSjQiWFFXrtaIKqV5WI9bFHiINvFFL7zOHvUEe5Ml0
         sIgp4OplAnmgC9Rp7WxmfSDn6kUUqDPhR1MmUx/XGGrmz0ClNiDLcTCVHV0EOaMfoDjq
         xPjceqqyMR8LnCWvTJpi07fLt9cq9OFUgiU3JPwqPxUNAjVwUKsnK3G5QxT6v6xp53ZU
         lrBbGaVHFH+5pHi9Esbr/unabxe/s29TltyCsrvY4lEdTsWy7FQ/4ajhFkgawTfMxcUp
         WUnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699972760; x=1700577560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UNMQSJ9n3HwpNaurQlo3tUtiIa6U/WmLwhKlbRCATs0=;
        b=VMG+i6HnLEfeYZTzM1Wz3W19grCv3WUMY3Zf8CqsHdt2jZi3VItg4U14y+DoUrZ8pi
         dLCHBqBCQp3kctb5776ppV+loYzQWyxPtMS1JApHBxgkOjypJWfZTZ5Iu3+HVJA6ixYL
         DNEIO88+9aSLXvCfM2ELZseYZpllKIhD5yVIV2LsOJDkBLnl/Zog7FQ7jccdaqB818WB
         6SaiSj1EQ776dPieYKD9YEdtwOfW0HqZa9YFeyIyP8FaO2EihtTQ0d0mxS7SEzuKpIV2
         xizBZw6D1L1VPdugP/OV7J9enzRTR06W6ZxvIEuP7SrFPyOHWBrC6UgDELAfkosfwnsa
         IdCA==
X-Gm-Message-State: AOJu0Yx6YS/PpbuWSwUkk5UvZvg4UmtcvHVAkW+aIWrw7aTG4vWlJAsu
	DuAsrRr2PswoB8a4e0vki6hrow==
X-Google-Smtp-Source: AGHT+IEprkHMikBtwTk6Pc2HglM2aACFqynKnIxKilr0MgI5mWMBku8mpMF5XwofVv89mcZ1ndbJxA==
X-Received: by 2002:a17:906:d7b2:b0:9ef:b466:abe0 with SMTP id pk18-20020a170906d7b200b009efb466abe0mr1430110ejb.8.1699972760684;
        Tue, 14 Nov 2023 06:39:20 -0800 (PST)
Received: from m1x-phil.lan (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id rp13-20020a170906d96d00b009ddb919e0aasm5622830ejb.138.2023.11.14.06.39.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Nov 2023 06:39:20 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: David Woodhouse <dwmw@amazon.co.uk>,
	qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paul Durrant <paul@xen.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	xen-devel@lists.xenproject.org,
	qemu-block@nongnu.org,
	Anthony Perard <anthony.perard@citrix.com>,
	kvm@vger.kernel.org,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>
Subject: [RFC PATCH-for-9.0 v2 09/19] hw/block/xen_blkif: Align structs with QEMU_ALIGNED() instead of #pragma
Date: Tue, 14 Nov 2023 15:38:05 +0100
Message-ID: <20231114143816.71079-10-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231114143816.71079-1-philmd@linaro.org>
References: <20231114143816.71079-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Except imported source files, QEMU code base uses
the QEMU_ALIGNED() macro to align its structures.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/block/xen_blkif.h | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/hw/block/xen_blkif.h b/hw/block/xen_blkif.h
index 99733529c1..c1d154d502 100644
--- a/hw/block/xen_blkif.h
+++ b/hw/block/xen_blkif.h
@@ -18,7 +18,6 @@ struct blkif_common_response {
 };
 
 /* i386 protocol version */
-#pragma pack(push, 4)
 struct blkif_x86_32_request {
     uint8_t        operation;        /* BLKIF_OP_???                         */
     uint8_t        nr_segments;      /* number of segments                   */
@@ -26,7 +25,7 @@ struct blkif_x86_32_request {
     uint64_t       id;               /* private guest value, echoed in resp  */
     blkif_sector_t sector_number;    /* start sector idx on disk (r/w only)  */
     struct blkif_request_segment seg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
-};
+} QEMU_ALIGNED(4);
 struct blkif_x86_32_request_discard {
     uint8_t        operation;        /* BLKIF_OP_DISCARD                     */
     uint8_t        flag;             /* nr_segments in request struct        */
@@ -34,15 +33,14 @@ struct blkif_x86_32_request_discard {
     uint64_t       id;               /* private guest value, echoed in resp  */
     blkif_sector_t sector_number;    /* start sector idx on disk (r/w only)  */
     uint64_t       nr_sectors;       /* # of contiguous sectors to discard   */
-};
+} QEMU_ALIGNED(4);
 struct blkif_x86_32_response {
     uint64_t        id;              /* copied from request */
     uint8_t         operation;       /* copied from request */
     int16_t         status;          /* BLKIF_RSP_???       */
-};
+} QEMU_ALIGNED(4);
 typedef struct blkif_x86_32_request blkif_x86_32_request_t;
 typedef struct blkif_x86_32_response blkif_x86_32_response_t;
-#pragma pack(pop)
 
 /* x86_64 protocol version */
 struct blkif_x86_64_request {
-- 
2.41.0


