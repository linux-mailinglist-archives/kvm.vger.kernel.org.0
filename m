Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F564CD21E
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 11:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239553AbiCDKM3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 05:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239546AbiCDKM2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 05:12:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 94EED1A9494
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 02:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646388699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sSLRnYb2QNIjWpP3fV5flR6BmyZe4IaIK5k4ivhzeY4=;
        b=RD3nViRHiL1zp+YkMpUkjCtB8blIYADyGP+Qj5kUJH5DJjO8D/1OV1DubA8X0kslGHlCZS
        P89Pr/ofSEAbB6cfILdphQOkVEkDs/3Y1zpVKkQZpAdAGOO4GZuFZYLFO/TXzPOqxpXjhU
        M7ZlXHZhkFzb/CynPr53JVSgdPIFgI8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-MMtLvB3SPmu79DVmnNaAaA-1; Fri, 04 Mar 2022 05:11:36 -0500
X-MC-Unique: MMtLvB3SPmu79DVmnNaAaA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98BD31091DA1;
        Fri,  4 Mar 2022 10:11:34 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.33.36.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA54C842BA;
        Fri,  4 Mar 2022 10:11:29 +0000 (UTC)
From:   Sergio Lopez <slp@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, qemu-block@nongnu.org,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-s390x@nongnu.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Jagannathan Raman <jag.raman@oracle.com>, vgoyal@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>, Sergio Lopez <slp@redhat.com>
Subject: [PATCH v4 4/4] docs: vhost-user: add subsection for non-Linux platforms
Date:   Fri,  4 Mar 2022 11:08:54 +0100
Message-Id: <20220304100854.14829-5-slp@redhat.com>
In-Reply-To: <20220304100854.14829-1-slp@redhat.com>
References: <20220304100854.14829-1-slp@redhat.com>
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
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 docs/interop/vhost-user.rst | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index edc3ad84a3..4dbc84fd00 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -38,6 +38,26 @@ conventions <backend_conventions>`.
 *Master* and *slave* can be either a client (i.e. connecting) or
 server (listening) in the socket communication.
 
+Support for platforms other than Linux
+--------------------------------------
+
+While vhost-user was initially developed targeting Linux, nowadays it
+is supported on any platform that provides the following features:
+
+- A way for requesting shared memory represented by a file descriptor
+  so it can be passed over a UNIX domain socket and then mapped by the
+  other process.
+
+- AF_UNIX sockets with SCM_RIGHTS, so QEMU and the other process can
+  exchange messages through it, including ancillary data when needed.
+
+- Either eventfd or pipe/pipe2. On platforms where eventfd is not
+  available, QEMU will automatically fall back to pipe2 or, as a last
+  resort, pipe. Each file descriptor will be used for receiving or
+  sending events by reading or writing (respectively) an 8-byte value
+  to the corresponding it. The 8-value itself has no meaning and
+  should not be interpreted.
+
 Message Specification
 =====================
 
-- 
2.35.1

