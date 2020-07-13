Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2559D21E182
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 22:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgGMUfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 16:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgGMUfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 16:35:40 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF39C061755;
        Mon, 13 Jul 2020 13:35:40 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id gc9so464496pjb.2;
        Mon, 13 Jul 2020 13:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=Hc91sxEuoSk8EdIe1r3k/U/UpC/yMdx5sG7UaEcRO1A=;
        b=Fb1RLuNlYB7IFjYJtdGwvMwg6ZZ7VhlNEP0GfFhgr+3A5uCMSBrZvQZjprg7iCYZxZ
         M/OlHWw0Kg9y6Jh73kEdwsxkQ6pSpvToeGMDGu3DO5bq0Dy/1MTCeB+7ivMh3jvSEoLW
         M2YDF7Pxe+3S/qpc79nnMmlX6JCoQeymgqbSEg8+BxoXzOP7OD3P0yNrqMp4scfsjal0
         f6qf3byVx0qvF3GJxAdoajvRuQMdWTRwrTnhfZeXVvdXHvwoVbr6p3DZDKJkTCWSzsyu
         N0jlWPasj5i3Yb90jJPyoTsaMMHO/uiDkt9dnI5OzRQ9GhyWPxX/pS9E0A7MrndARwVJ
         hfcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=Hc91sxEuoSk8EdIe1r3k/U/UpC/yMdx5sG7UaEcRO1A=;
        b=qlTJTdQ3+amCk2FOWbu6W+h7mTc5JE4uKfBFKuqOCCuV1bBYZrxBFBWUt/EvKzDwY+
         Tr2CurcJJ6BVhdYpDQVoWHt5j36yh8vSb3nuKYwIKstPeJRw/zWvaYUqmDDN3OMLXwIW
         H1RhwRIl5tbC/pVcU/Fn9TogWrFdWB6cg+jG1SFvzs3H2WffAGec/Kqqnfp3gXomHZCW
         xruhjv1yloNGL1LaiKh+p14G3L3xK7vwJZ5y4lGOb8cV6hmq+kfrW1BBkime9MbdGUVx
         UrIDg4ICCvToO+UX7Q23wAheCOKxGAymYNlmotQs5bW8H41ztWKtpjdbBlIwTp55NLYL
         Rr/Q==
X-Gm-Message-State: AOAM532q0ZWaZIkKs1NSlyPVVlPTg4MRgTlQWjIXZHc3DXd5hYjbjaM6
        FiaL2nXq+XPAx0Bsla+ZNn6Uvnr1NI0=
X-Google-Smtp-Source: ABdhPJyHJEIZ21G8jzUigVI0jSe79fjGm4gXhEhPUJ1TAYcnshBv+OR/UGqht1JVvn0SUpgmb3f9PQ==
X-Received: by 2002:a17:90a:7483:: with SMTP id p3mr1194846pjk.64.1594672540173;
        Mon, 13 Jul 2020 13:35:40 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id 137sm14232950pgg.72.2020.07.13.13.35.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2020 13:35:39 -0700 (PDT)
Subject: [PATCH] virtio-balloon: Document byte ordering of poison_val
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     david@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, mst@redhat.com
Cc:     virtio-dev@lists.oasis-open.org
Date:   Mon, 13 Jul 2020 13:35:39 -0700
Message-ID: <20200713203539.17140.71425.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

The poison_val field in the virtio_balloon_config is treated as a
little-endian field by the host. Since we are currently only having to deal
with a single byte poison value this isn't a problem, however if the value
should ever expand it would cause byte ordering issues. Document that in
the code so that we know that if the value should ever expand we need to
byte swap the value on big-endian architectures.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/virtio/virtio_balloon.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 1f157d2f4952..d0fd8f8dc6ed 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -974,6 +974,11 @@ static int virtballoon_probe(struct virtio_device *vdev)
 		/*
 		 * Let the hypervisor know that we are expecting a
 		 * specific value to be written back in balloon pages.
+		 *
+		 * If the PAGE_POISON value was larger than a byte we would
+		 * need to byte swap poison_val here to guarantee it is
+		 * little-endian. However for now it is a single byte so we
+		 * can pass it as-is.
 		 */
 		if (!want_init_on_free())
 			memset(&poison_val, PAGE_POISON, sizeof(poison_val));

