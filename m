Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B625E4CBD44
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 13:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbiCCMBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 07:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbiCCMBO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 07:01:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9162F16FDDF
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 04:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646308828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SChHcwg/89XMGoVWOn4WPsullesTZfsuoF5vcE1hxbw=;
        b=QxA6kedIPZQN3bFZTC5ucHtK0xDzM24Al4i61nunqWBDdyQzhPGM4o0Edx1xJAHPOEQx0x
        Ep9gg+NzPE097tunHb4vOI/xbWNGfLGCONuH4eIYcVp8MtwZMlpb+ZbUAqWzMUoX2M8ZQq
        ti/4SS1dblWVGL+vrDr/lCRDoB/gcC4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-XBLt5vFsMViTWgAkHsQfNw-1; Thu, 03 Mar 2022 07:00:25 -0500
X-MC-Unique: XBLt5vFsMViTWgAkHsQfNw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F344D801AAD;
        Thu,  3 Mar 2022 12:00:22 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.33.37.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C688842CC;
        Thu,  3 Mar 2022 12:00:18 +0000 (UTC)
From:   Sergio Lopez <slp@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        kvm@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Fam Zheng <fam@euphon.net>,
        John G Johnson <john.g.johnson@oracle.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Hanna Reitz <hreitz@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        qemu-s390x@nongnu.org, vgoyal@redhat.com,
        Jagannathan Raman <jag.raman@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>, qemu-block@nongnu.org,
        Eric Farman <farman@linux.ibm.com>,
        Sergio Lopez <slp@redhat.com>
Subject: [PATCH v3 4/4] docs: vhost-user: add subsection for non-Linux platforms
Date:   Thu,  3 Mar 2022 12:59:11 +0100
Message-Id: <20220303115911.20962-5-slp@redhat.com>
In-Reply-To: <20220303115911.20962-1-slp@redhat.com>
References: <20220303115911.20962-1-slp@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a section explaining how vhost-user is supported on platforms
other than Linux.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
 docs/interop/vhost-user.rst | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index edc3ad84a3..590a626b92 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -38,6 +38,24 @@ conventions <backend_conventions>`.
 *Master* and *slave* can be either a client (i.e. connecting) or
 server (listening) in the socket communication.
 
+Support for platforms other than Linux
+--------------------------------------
+
+While vhost-user was initially developed targeting Linux, nowadays is
+supported on any platform that provides the following features:
+
+- The ability to share a mapping injected into the guest between
+  multiple processes, so both QEMU and the vhost-user daemon servicing
+  the device can access simultaneously the memory regions containing
+  the virtqueues and the data associated with each request.
+
+- AF_UNIX sockets with SCM_RIGHTS, so QEMU can communicate with the
+  vhost-user daemon and send it file descriptors when needed.
+
+- Either eventfd or pipe/pipe2. On platforms where eventfd is not
+  available, QEMU will automatically fallback to pipe2 or, as a last
+  resort, pipe.
+
 Message Specification
 =====================
 
-- 
2.35.1

