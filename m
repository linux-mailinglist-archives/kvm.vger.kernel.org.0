Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494351CF280
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 12:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbgELKc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 06:32:56 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46967 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729365AbgELKcz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 06:32:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589279575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zOtCARhB88XtH+7DaaroGpTjVIhIb43b3LSLjds5GUw=;
        b=hii1X1x+Cawdu+B+Y7OKr81V08+1f4gIAKCAt9d5OSCb2GtLNqLPR/tgMpDaBQSZqDpjdR
        en5XVJGiBDeELQnCNCdZp210Z7EkYn04BVZV0jAY35DgTvJOkD6q6A2eJy9G+Ub74WNJIC
        UDr69wvtIBRQw5k7JTKJC0Bi2eHRpOA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-FLSWtuFRMQ-KrGOtVS5XTg-1; Tue, 12 May 2020 06:32:51 -0400
X-MC-Unique: FLSWtuFRMQ-KrGOtVS5XTg-1
Received: by mail-wr1-f72.google.com with SMTP id 37so3496548wrc.4
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 03:32:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zOtCARhB88XtH+7DaaroGpTjVIhIb43b3LSLjds5GUw=;
        b=KcVnv6JMHIFCyJNPk4jwrdZx0EenVaU9Rgf4+SWyuG25QxymFuS2WtCykcCde0oLt5
         wbGMoSDOf5Pe0su9bnTlu4jck0uosG/0HKbA6vLUUh6h9KF2t/J2ElBr7gs1HW2/t0o3
         rrfRnQMtxnTmwfO2IANEeyidWTwH7blWnfGKXmdm8O6M8YdV1k07xjS3a5h7KqNFgLd0
         dqavCz08LYYTOHk0rRI9eaFpjG/hxgtJxoBAPB5G1A+BqGFjAH7c9bCbGMpfHw5lPupR
         3PEsn5Kgh1vz/rFhTZUJwvvntfHQspco8s9NTUKJ/Co+hnRo+T2+TcRJu0+Of71H6FbV
         7XiQ==
X-Gm-Message-State: AGi0PuaVhUzXV5y9hSG2ZWo/zNeaJYW5K9OUYYc9NpYAgwR+m+TfKYCb
        D4feNdBkoHz2DlNN8qZ5Elm7jKv7Hg0f/XBjphcR1RCMMktBHEBOYuGi3dBegB+lXIkGelvaDCD
        m/+u27e/foppR
X-Received: by 2002:adf:f3cc:: with SMTP id g12mr12858081wrp.427.1589279570203;
        Tue, 12 May 2020 03:32:50 -0700 (PDT)
X-Google-Smtp-Source: APiQypIp4cKlTsev0nh13QNGo5ccEqxoYf5orH801v8Ck5Kq9gfAUjGI6X3+2CENt1I9LXed1D7kpQ==
X-Received: by 2002:adf:f3cc:: with SMTP id g12mr12858058wrp.427.1589279570025;
        Tue, 12 May 2020 03:32:50 -0700 (PDT)
Received: from x1w.redhat.com (17.red-88-21-202.staticip.rima-tde.net. [88.21.202.17])
        by smtp.gmail.com with ESMTPSA id u74sm31235914wmu.13.2020.05.12.03.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 03:32:49 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Markus Armbruster <armbru@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        qemu-trivial@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Cleber Rosa <crosa@redhat.com>, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v4 2/6] scripts/qemu-gdb: Use Python 3 interpreter
Date:   Tue, 12 May 2020 12:32:34 +0200
Message-Id: <20200512103238.7078-3-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200512103238.7078-1-philmd@redhat.com>
References: <20200512103238.7078-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Philippe Mathieu-Daudé <f4bug@amsat.org>

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 scripts/qemu-gdb.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/qemu-gdb.py b/scripts/qemu-gdb.py
index f2a305c42e..e0bfa7b5a4 100644
--- a/scripts/qemu-gdb.py
+++ b/scripts/qemu-gdb.py
@@ -1,5 +1,5 @@
-#!/usr/bin/python
-
+#!/usr/bin/env python3
+#
 # GDB debugging support
 #
 # Copyright 2012 Red Hat, Inc. and/or its affiliates
-- 
2.21.3

