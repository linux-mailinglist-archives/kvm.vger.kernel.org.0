Return-Path: <kvm+bounces-163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5927A7DC8C5
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 09:58:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08F0828138E
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 08:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E1DF12E64;
	Tue, 31 Oct 2023 08:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lIRRkAAc"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A59EEA3
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 08:58:07 +0000 (UTC)
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99ACC2
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 01:58:05 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-507a98517f3so7547895e87.0
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 01:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698742684; x=1699347484; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d4STdM0jYEXN+54aJ9JQEaU7mf4zySlUWnw/NPnMyOY=;
        b=lIRRkAAcg+uQNDo+L7xqz+20yba9RZQ55trzNV8YpjJBCjy4NneV5kx1NBy9U5A2iT
         Kzck1Fb6Lnf0XFB1KXYzVDILn72xlZseWGeC1XbDBkKPnM8zdoSyeQ8iBvhB+synZ52L
         H9916lelA8YBHU307XEaHX8XNRFZgiUHjcEBgexfPYTccOI4bpDeJXnCevwaCUcZQ/7A
         xpQfarpj776xq2dz0ssMWUb742NIC+oWh0dEk1wNpz+1HpSmVvjTo11U7Pm2CBeovqdm
         /id6UbqFdCFIsX7BvnoCrF7ayhTJCPxsNI2m3ZCDy8XwYw0FUi1/TZQV0uNgs+7KNgzx
         SXvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698742684; x=1699347484;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d4STdM0jYEXN+54aJ9JQEaU7mf4zySlUWnw/NPnMyOY=;
        b=iWzRsN08Fj5zg8bH3+1IvKWv0b/uC3Lg3ssfUAL8FIPt346Wy9nXRcrart0Nbe6mg6
         gKJA0q4wLaoxFhnV9oM9dNI83VCRyEEEMkNDP5UejgR89EmJZemS0Gbtrvw08LndjgDP
         iA9awtTYr1n4VExExw41M7QQnKOrZgoAK4SrVUb4gkz4FsBxQeTMeO47SH3IFC6T94jL
         dbU5AtmMYdJhqBtzgEsAeQ+jfFpI30wqKlMx3iiAMGVexknWKhGT7oOHbZWEi6uebq/M
         5YRPAsWOy7332MrcqmEsO9yyDQNgd5bakHih1A3igFV+zjy2dk5vL5QfGRmmzg0S4PdE
         /lAQ==
X-Gm-Message-State: AOJu0Yz4+LG3FiwQZzH1XCcXLmdnS724jvXv/CVg0M1Za53ISP8fJSqg
	tNclNkJSW3MQnEr24wkCZHkP1A==
X-Google-Smtp-Source: AGHT+IGpyL5LNThnF9EVE+It32ZKweaZuoUkY2L75q/AthejDBJRPtrL7WQrHmLGI6tPuRs941KE2w==
X-Received: by 2002:ac2:5f51:0:b0:507:9f4c:b72 with SMTP id 17-20020ac25f51000000b005079f4c0b72mr8428895lfz.15.1698742683962;
        Tue, 31 Oct 2023 01:58:03 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id y17-20020adff6d1000000b0032f7d7ec4adsm973923wrp.92.2023.10.31.01.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 01:58:03 -0700 (PDT)
Date: Tue, 31 Oct 2023 11:58:00 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	kvm@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] KVM: Add missing fput() on error path
Message-ID: <64117a7f-ece5-42b1-a88a-3a1412f76dca@moroto.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

Call fput() on this error path.

Fixes: fcbef1e5e5d2 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 virt/kvm/guest_memfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 7f62abe3df9e..039f1bb70a0c 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -473,7 +473,7 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	inode = file_inode(file);
 
 	if (offset < 0 || !PAGE_ALIGNED(offset))
-		return -EINVAL;
+		goto err;
 
 	if (offset + size > i_size_read(inode))
 		goto err;
-- 
2.42.0


