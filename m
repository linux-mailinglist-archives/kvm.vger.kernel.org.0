Return-Path: <kvm+bounces-1372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A6BB7E7343
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 22:04:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CA4C1C20C5A
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 21:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C9AD38F88;
	Thu,  9 Nov 2023 21:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="glMoh0xi"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF03374F8
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 21:03:47 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4D544B6
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 13:03:47 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da033914f7cso1623608276.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 13:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563826; x=1700168626; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2mOhK5FoYcXL75GR8axKmDOtKXDH3smigWBB7T8RqTw=;
        b=glMoh0xiBz3HGxjxGGyIaFmB+d1hF2pn2FcEtM4xyB9IiWQlCcnuTUUpQT7RFTBwLu
         bn+8jLI9A0H+jOr8TPQZWCyvzP9vZ3IUioAAKsPhkgO1xgf8QEf4wsb9pd4me7Td12sK
         8ARyoHUKdL/y9cmNIyfUV45MK5cHdZwJ/+q1Ti8pgXiBBfnKRF1Xl5Wwnn+HJARgEVIZ
         4yi17/28voOqfH5A8XOKWej3+4+3dqm/drr1VpP1B1cCkvPm1F4GtkDmslbJBVq3n2gV
         t6HpW/J6yYpaaN8wF6SqEPGY6/33wgH/ORIa0dBO4U2fIlfMVbFHY8HdIWyP1teqOfbE
         216w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563826; x=1700168626;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2mOhK5FoYcXL75GR8axKmDOtKXDH3smigWBB7T8RqTw=;
        b=f6/BvskYOay+Jv0pgIXZccCK6X8E7UeXOrIEz45RkF/+BEEo/bdiXxPVsTu4vKIFS2
         XrMcCLbnSqgD06Pk+fTj+ZbgwJSSDclYr/FvaJ0cxT4jh6eTfHor4a2802JACX79tMG5
         eXbrkI4TM4p56a3Wn6Pq2H4XOHDHC+PxcuvAofiPNPdE+5KEX5HGgHqdZDjXlYSYPCTX
         ZDtbWxps7NNBgjX9o2pnSOOvQl+5ESeCGlgWjDM3/dp0cXLI8Cjc3DGXmfHoq8X5nNyp
         U/UEoifvDdhTKGNWQHDNifMXq8Gt/KcakUR0NCv2j/83jVWfR9McG0767Gzu24GE9ISY
         nq0w==
X-Gm-Message-State: AOJu0Yy9PPfHUfytQPkG7C2nZs0WHlWfBaiLQoksv/fJUlBDxijecGru
	Q+3AOwlSDDIl8EbkhKvWKjHd/1QR6SdVOw==
X-Google-Smtp-Source: AGHT+IEevm9gxrKUT+zKzL4wMuDoD2o6L3pgb1/3TA3DxCiu1yUYlIaSqbwc2y/dH2L/0EUx5ZlxnIF/gqvflg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:e64a:0:b0:da0:29ba:668c with SMTP id
 d71-20020a25e64a000000b00da029ba668cmr143892ybh.10.1699563826668; Thu, 09 Nov
 2023 13:03:46 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:14 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-4-amoorthy@google.com>
Subject: [PATCH v6 03/14] KVM: Simplify error handling in __gfn_to_pfn_memslot()
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

KVM_HVA_ERR_RO_BAD satisfies kvm_is_error_hva(), so there's no need to
duplicate the "if (writable)" block. Fix this by bringing all
kvm_is_error_hva() cases under one conditional.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f521b6fd808f..88946d5d102b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3055,15 +3055,13 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 	if (hva)
 		*hva = addr;
 
-	if (addr == KVM_HVA_ERR_RO_BAD) {
-		if (writable)
-			*writable = false;
-		return KVM_PFN_ERR_RO_FAULT;
-	}
-
 	if (kvm_is_error_hva(addr)) {
 		if (writable)
 			*writable = false;
+
+		if (addr == KVM_HVA_ERR_RO_BAD)
+			return KVM_PFN_ERR_RO_FAULT;
+
 		return KVM_PFN_NOSLOT;
 	}
 
-- 
2.42.0.869.gea05f2083d-goog


