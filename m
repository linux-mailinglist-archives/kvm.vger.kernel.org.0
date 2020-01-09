Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B496F135BEC
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 15:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731942AbgAIO5v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 09:57:51 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35330 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731932AbgAIO5u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 09:57:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578581869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nm8O4Xii0OuE4zFVyte5k6dYfDYh4EMQdTOkPftgaqU=;
        b=bUBu4NfTvNOwNeOlih9btuxvpeY9H6uKq2FmwrA0QYPDVUNARjU81YtW1s1sLSyf2CyV75
        WupAccSjwWd1DbO1i8O1+rF3u6RKGwxrrOVL2WcssDZbaKQRiTgnI4yP7Q0zFMQFeeCxar
        rA+Gp/Npm5Yl1Qx4dwyJF79XONEJ66Q=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-quoVFkJcOWi9IAEy97b2hg-1; Thu, 09 Jan 2020 09:57:46 -0500
X-MC-Unique: quoVFkJcOWi9IAEy97b2hg-1
Received: by mail-qk1-f200.google.com with SMTP id n128so4298116qke.19
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 06:57:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nm8O4Xii0OuE4zFVyte5k6dYfDYh4EMQdTOkPftgaqU=;
        b=b1J+gK/4qaD3OjuzY6vP04irX+yQrPB/9ZA7808lzrlc3y6sBdoZTb5P3riVOVPYwW
         wO8NguCGFQhHYJVojzEBgfUssG1XiFssT4mrR/p4cQgtGuYSxsHWXDYgNohv9cgzYltR
         eRsKmKK1BpV66ksS+vKulHwKG9vxscGuGOy5dWmDVpGGvWHPS36+o1/KvsadJaSSuwx1
         uQOjj+kBLyVDt1D92QA43vEH6WOvfo54ykVB/8l/Rftp0DQyxnl91cAlo13LpB71IaL/
         ic9pum4flrgH3xGE5zaz4M4wlpCEHeZhOCsqp4wmUpo3igt0CRd5Wk4oT+bBnzX6lR/Z
         j+mw==
X-Gm-Message-State: APjAAAUrf/4NE+lD0GsL14yxMmB8ebnx/0/aLpos9yboqJpYLPHYM2PT
        EWPaKu9yo6vuBXAJFlKgZ9zIDm77IJitpjZODfhJrUAwmemu/LtuAdGctDgq2uXo10QP8kJz/NY
        68PEE4hc1nins
X-Received: by 2002:ae9:ec01:: with SMTP id h1mr10129989qkg.33.1578581864674;
        Thu, 09 Jan 2020 06:57:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqzNTAs/SAnbPG+ivO60ziyJlazNT+NDxUAFeemJ1UyIi2OiGROdyCVheaB21amr6IgdyN2YNA==
X-Received: by 2002:ae9:ec01:: with SMTP id h1mr10129964qkg.33.1578581864482;
        Thu, 09 Jan 2020 06:57:44 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q2sm3124179qkm.5.2020.01.09.06.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 06:57:43 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, peterx@redhat.com,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH v3 04/21] KVM: Add build-time error check on kvm_run size
Date:   Thu,  9 Jan 2020 09:57:12 -0500
Message-Id: <20200109145729.32898-5-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109145729.32898-1-peterx@redhat.com>
References: <20200109145729.32898-1-peterx@redhat.com>
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
index 24c9cf4c8a52..70b78ccaf3b5 100644
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

