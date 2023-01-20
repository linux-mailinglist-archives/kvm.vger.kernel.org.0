Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A91E674BB3
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 06:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjATFFT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 00:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjATFFC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 00:05:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7A26E0E3
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 20:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674190134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=QCQ/rJ9OcUhFGJfEZRwZPT6ketogptymaLeWaE9tJ3Y=;
        b=XYS+xYH7xFpa2bdZnQW4BBX2rggUpe7KMDxQ9FGonuCB7EIU7QvVboZxAsmEtxMm/wBT0F
        wuyzLw9+JxaM3LE+oLTOr0eXmmhKo5FK6wmC8hkaUR4RNdbRM7D+pW0NA9bYX6e3Faw72n
        A5q44gB9BVfheTXXDxgv80Ijwg9kIHA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-1motH31IPoihUWJxAXRf3A-1; Thu, 19 Jan 2023 23:48:50 -0500
X-MC-Unique: 1motH31IPoihUWJxAXRf3A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16BAD1C0512B;
        Fri, 20 Jan 2023 04:48:50 +0000 (UTC)
Received: from tpad.localdomain (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E2AF840C6EC4;
        Fri, 20 Jan 2023 04:48:49 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
        id 002204099C362; Thu, 19 Jan 2023 22:15:17 -0300 (-03)
Message-ID: <20230120011412.530500343@redhat.com>
User-Agent: quilt/0.67
Date:   Thu, 19 Jan 2023 22:11:17 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 1/2] linux-headers: sync KVM_CLOCK_CORRECT_TSC_SHIFT flag
References: <20230120011116.134437211@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sync new KVM_CLOCK_CORRECT_TSC_SHIFT from upstream Linux headers.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Index: qemu/linux-headers/linux/kvm.h
===================================================================
--- qemu.orig/linux-headers/linux/kvm.h
+++ qemu/linux-headers/linux/kvm.h
@@ -1300,6 +1300,9 @@ struct kvm_irqfd {
 #define KVM_CLOCK_TSC_STABLE		2
 #define KVM_CLOCK_REALTIME		(1 << 2)
 #define KVM_CLOCK_HOST_TSC		(1 << 3)
+/* whether tsc_shift as seen by the guest matches guest visible TSC */
+/* This is true since commit 78db6a5037965429c04d708281f35a6e5562d31b */
+#define KVM_CLOCK_CORRECT_TSC_SHIFT	(1 << 4)
 
 struct kvm_clock_data {
 	__u64 clock;


