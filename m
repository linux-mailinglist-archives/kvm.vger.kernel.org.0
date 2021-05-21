Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3972338C3DA
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 11:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbhEUJxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:53:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49456 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231975AbhEUJxi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 05:53:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621590735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M7QgAXRlYiLoTJmEsH1SC4g4z8VB7CzlgnRBatZm6Pg=;
        b=eTtgG/BgWcOp0qlmYIzFKMS/KFGqZjLA7VUKveQOa8GFMm0RaQQpdax99bapeemgySpMtQ
        XCneaC3yzCGTaJNvjK5po6EBrId79mV10iZDkGxNnqSmXwrxCB4IP6t2Dp2vhK6V7EOQ5x
        tf9HsQti18fvlDl49sVxCME1cWdNHcM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-ipus7RNyPSGThzWW9vligw-1; Fri, 21 May 2021 05:52:12 -0400
X-MC-Unique: ipus7RNyPSGThzWW9vligw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EA6C1922961;
        Fri, 21 May 2021 09:52:11 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D4DA6A037;
        Fri, 21 May 2021 09:52:08 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/30] asm-generic/hyperv: add HV_STATUS_ACCESS_DENIED definition
Date:   Fri, 21 May 2021 11:51:35 +0200
Message-Id: <20210521095204.2161214-2-vkuznets@redhat.com>
In-Reply-To: <20210521095204.2161214-1-vkuznets@redhat.com>
References: <20210521095204.2161214-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From TLFSv6.0b, this status means: "The caller did not possess sufficient
access rights to perform the requested operation."

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Acked-by: Wei Liu <wei.liu@kernel.org>
---
 include/asm-generic/hyperv-tlfs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
index 515c3fb06ab3..56348a541c50 100644
--- a/include/asm-generic/hyperv-tlfs.h
+++ b/include/asm-generic/hyperv-tlfs.h
@@ -194,6 +194,7 @@ enum HV_GENERIC_SET_FORMAT {
 #define HV_STATUS_INVALID_HYPERCALL_INPUT	3
 #define HV_STATUS_INVALID_ALIGNMENT		4
 #define HV_STATUS_INVALID_PARAMETER		5
+#define HV_STATUS_ACCESS_DENIED			6
 #define HV_STATUS_OPERATION_DENIED		8
 #define HV_STATUS_INSUFFICIENT_MEMORY		11
 #define HV_STATUS_INVALID_PORT_ID		17
-- 
2.31.1

