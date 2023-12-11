Return-Path: <kvm+bounces-4096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B6B780D9B9
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 19:56:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBAEF1C214F7
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 18:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90571524CA;
	Mon, 11 Dec 2023 18:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hbmXrEGO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CFEAC
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 10:56:14 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5e03f0ede64so17336397b3.0
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 10:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702320973; x=1702925773; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z/TRiMrd8RanNuxK1z5tY35iy/s57//+YI0rclS1ptg=;
        b=hbmXrEGO8mQqa3ZDjQjWPN/Op6Ldz6Wl1p25XZLqmYVetbVPwQlWS2tQMXjzVWKU2i
         MWt6MWP+cp1ePP9OQJed96WWTHc7UjrqqKSxyh/yziXCKs/LFINsrW3pMJGCOxH/Rbqq
         07ZG//u1grghMdOawzwK0BgCzwjuSa7T7dbA4rZPOZi7hhSBAw3nESEfCSQ0azVGx+Nq
         /m5BYFFfKK4AXD9SzzFDGNmUiC9EjXbacOyM4V4YTx7I5eNQcCXQfQyYtpa+zkjTJEjI
         /GgwGuNEY5u/owS+w/l87F4JyjL6a1Hk/4STotdj/qk6tHswpKeRorViERE0WJVWmNll
         H8wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702320973; x=1702925773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z/TRiMrd8RanNuxK1z5tY35iy/s57//+YI0rclS1ptg=;
        b=rXTa/3HLxHDPOHwSbdo3Q6LGja9W/vRgOgg1gxAi52i0UAOpHfp2TVlQFzFVuutvLk
         A2RLYiBoEoaZrFmOXrH/Dsj4C49bPjDmEiKUaBAteyIgSj5dGZKQlROJyZpNANl2VPb7
         MWN7qEbZzRkHgK4f0otSxnEpR4BfI+C3h4Nzx/XtFZuchTtut+D0giqtL/oeUFkKUUmY
         Y+xoQWU8BhKJ+wieWzgUwjVXzVBxaFRj/udJGBXDhyS5KHHIF2enmT2597qO+hLDVyDj
         FhLVZDeY49cy0gaxk3WjmzDWetpq78ceDynMgJxWma6J0FSyK3aDbksDChA6rdRFS3MT
         2pWw==
X-Gm-Message-State: AOJu0Yz6kuuyjSYrfidYSWzGChsPqIo1RMZp1VWuyqzR46HtdbVlDrMk
	0ZK2sUvY8IIRp8v4PuGCAXLIzdUpXNat6Q==
X-Google-Smtp-Source: AGHT+IFk+8HJZyDLOUVGpYVbrRex0qsvgWex8LVKGs7JRAgFWCnBwvMVPx7YjqzXSfJfGRE1mbPl4crTptJxug==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a05:690c:3508:b0:5d6:cdd0:d496 with SMTP
 id fq8-20020a05690c350800b005d6cdd0d496mr48166ywb.3.1702320973484; Mon, 11
 Dec 2023 10:56:13 -0800 (PST)
Date: Mon, 11 Dec 2023 10:55:48 -0800
In-Reply-To: <20231211185552.3856862-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231211185552.3856862-1-jmattson@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231211185552.3856862-2-jmattson@google.com>
Subject: [kvm-unit-tests PATCH 1/5] nVMX: Enable x2APIC mode for
 virtual-interrupt delivery tests
From: Jim Mattson <jmattson@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, pbonzini@redhat.com
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Since "virtualize x2APIC mode" is enabled for these tests, call
enable_x2apic() so that the x2apic_ops function table will be
installed.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 x86/vmx_tests.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index c1540d396da8..e5ed79b7da4a 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -9305,6 +9305,7 @@ static void enable_vid(void)
 
 	assert(cpu_has_apicv());
 
+	enable_x2apic();
 	disable_intercept_for_x2apic_msrs();
 
 	virtual_apic_page = alloc_page();
-- 
2.43.0.472.g3155946c3a-goog


