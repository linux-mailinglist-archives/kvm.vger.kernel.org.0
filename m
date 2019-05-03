Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA06413367
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 19:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbfECRyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 13:54:40 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40876 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728437AbfECRyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 13:54:40 -0400
Received: by mail-pl1-f193.google.com with SMTP id b3so3026308plr.7
        for <kvm@vger.kernel.org>; Fri, 03 May 2019 10:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2U4NO/rvxs4VJml+XR2FaZxBF2TPZGlSDMhWLkBAfMU=;
        b=gLdfdN0N+5h1kPNVs/8fHv8xo9tH4Pv8nx0VyIWpJoJ87IWOpcCyo1jhaUk4VuM+af
         tiTCB0gbExqSwoeJOOx6JHy5PTAzuShwmu1BiJ7UMqpaIG2RjXD85tKU0yCnRiLSq7+6
         bwZpRaA3J8y0c99EiDW4goEZsiMW5xj+FIr5vnF9h4w8XrQkW5eLnhaDhcNbJRc7ry0u
         4Pkv8IURWVOaa4KeADdLKXsBd2vKQqbzFvMM1vBHEJj2yWmj0Y1SsC3fGWSQLljQfE4I
         oT036PHWlDTAWvZ4xrTRIKKjWIBrQdiguoSjR4+rD4/shicR0S2eCLqaMgo/3LDAgZiI
         ZedQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2U4NO/rvxs4VJml+XR2FaZxBF2TPZGlSDMhWLkBAfMU=;
        b=aL0q+2d+o8uq5pZziq8kzterkpYYzKZul7FgZkl8p4b3XATrWOIPxrkZqVOfxyaBfL
         noBqg9xHuvHG4fiasBwq2keRbI4vCtB2wwDSC/rio5HjiVnQO7i4Vs4+JW5euwkEIFc7
         oVQ61Bj5j3k1FdWGi3z9kT9u+CfNt4g1Li73GKceQb2CynPE48FqS7LPojG6Z97B8bIE
         Kq/lokt4ikMSZ7DcZneA8+zF0aZycXk0ZULYEiP7gSqjHwKQpJNqFhL2RR2heismxqS5
         XJKW0aGoqqAgXAtNqdeJoCeTCft9/WhSKsu670A+b9pSia3ZXry2AsmPf9Q+ah1OzvP2
         DJLw==
X-Gm-Message-State: APjAAAXvUlRElo/4E3J1sRPJSk5tB7EAn1sAwcJ84goxPqFnIKangnXs
        SNQX2wfiPTEgUr9k80S+NiM=
X-Google-Smtp-Source: APXvYqwzlaYi7JuAPz+mQeYinwReT1O2Lj+gy4/Gw9/q8dXTWEXkKkPE9obMstCRnp+/6n+c91GX3A==
X-Received: by 2002:a17:902:e283:: with SMTP id cf3mr12402732plb.160.1556906079231;
        Fri, 03 May 2019 10:54:39 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id p20sm3717311pgj.86.2019.05.03.10.54.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 10:54:37 -0700 (PDT)
From:   nadav.amit@gmail.com
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH v2 3/4] lib: Remove redeundant page zeroing
Date:   Fri,  3 May 2019 03:32:06 -0700
Message-Id: <20190503103207.9021-4-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190503103207.9021-1-nadav.amit@gmail.com>
References: <20190503103207.9021-1-nadav.amit@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

Now that alloc_page() zeros the page, remove the redundant page zeroing.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/virtio-mmio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/virtio-mmio.c b/lib/virtio-mmio.c
index 57fe78e..e5e8f66 100644
--- a/lib/virtio-mmio.c
+++ b/lib/virtio-mmio.c
@@ -56,7 +56,6 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev,
 	vq = calloc(1, sizeof(*vq));
 	assert(VIRTIO_MMIO_QUEUE_SIZE_MIN <= 2*PAGE_SIZE);
 	queue = alloc_pages(1);
-	memset(queue, 0, 2*PAGE_SIZE);
 	assert(vq && queue);
 
 	writel(index, vm_dev->base + VIRTIO_MMIO_QUEUE_SEL);
-- 
2.17.1

