Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6AE128391
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 22:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfLTVDr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 16:03:47 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56284 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727783AbfLTVDm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 16:03:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576875821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vtGsufOEBQRYi5aVidxZ4SgIBK6STwpDg+qKmGEtjBY=;
        b=R/emlo9R5UQXw8PqKfzhl2ZegQEKn9Y0HiAQyeoXzEFPKroTGAT4nsQXaFfOKhzHMhLUql
        8IaK5gVfnq1n7D/1nZTfUYtNFM+Ck05CQa2w9P0fgrjFhtjuzu4CTZ2b5nkAVOJWf0GLbW
        fJkeIvu/p7tYD6u1Vu6/Nw9QNRmgDrc=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-g5s4pMEYPj2-ipEzDn0xrw-1; Fri, 20 Dec 2019 16:03:39 -0500
X-MC-Unique: g5s4pMEYPj2-ipEzDn0xrw-1
Received: by mail-qt1-f197.google.com with SMTP id o18so6783237qtt.19
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 13:03:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vtGsufOEBQRYi5aVidxZ4SgIBK6STwpDg+qKmGEtjBY=;
        b=UQrXd2J0jS4NQVunaCGWj1+MHFUXn7dTQXV5Be6/Ag0QsbBavsPiAWjfFjQXMxZjXO
         9GyzUfA7+sE+J3aOL1Il0sXzjWev/LYZ2mq1cMVhyBThz95rDxYIUeFNzOjYuS17x1iW
         i0BdRkg6P2xHDvF5kRwTpbfwHN9enYbfXANkTb7XZ9Mhjmvo14OOyFsY0V7CGr1paCkE
         KpBBmwPuYMNW8vfhlb5OBJDxo3JkbghN69zO450PhytMkjfIQ1NMwH2kne2c4QI63Yl+
         n/NxKAlD3W+YD2Eixo5SLWL9EefqapXzvfYNq3yRGIrLSB3aulOt1EfiqdwHalMhtoNt
         +mdA==
X-Gm-Message-State: APjAAAWOnPqundw8E55LO/lyBqGHeH2sgYuHYOVg7ao06kkRWxnYu9L6
        LZXxPpfoq4Dfg4NdoHPirZ6hvEm0cmzOtRNCtxrfgL5yoN4w6Nj9UevBuYltJT8LoH/1t0Ua+fz
        5Py+SGtuSufJI
X-Received: by 2002:ac8:21b5:: with SMTP id 50mr13151560qty.10.1576875818729;
        Fri, 20 Dec 2019 13:03:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqxlRImFhrwNawCgIAgsSOJ1EXj2A5IDQwkpl6IsO1iQYvfDSTKLXH5QiQ2SH4/hegAbB9Mfzg==
X-Received: by 2002:ac8:21b5:: with SMTP id 50mr13151548qty.10.1576875818573;
        Fri, 20 Dec 2019 13:03:38 -0800 (PST)
Received: from xz-x1.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id a9sm3061018qtb.36.2019.12.20.13.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 13:03:36 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH v2 05/17] KVM: Add build-time error check on kvm_run size
Date:   Fri, 20 Dec 2019 16:03:14 -0500
Message-Id: <20191220210326.49949-6-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220210326.49949-1-peterx@redhat.com>
References: <20191220210326.49949-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's already going to reach 2400 Bytes (which is over half of page
size on 4K page archs), so maybe it's good to have this build-time
check in case it overflows when adding new fields.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 virt/kvm/kvm_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cea4b8dd4ac9..c80a363831ae 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -338,6 +338,7 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->pre_pcpu = -1;
 	INIT_LIST_HEAD(&vcpu->blocked_vcpu_list);
 
+	BUILD_BUG_ON(sizeof(struct kvm_run) > PAGE_SIZE);
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!page) {
 		r = -ENOMEM;
-- 
2.24.1

