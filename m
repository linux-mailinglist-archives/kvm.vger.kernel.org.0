Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDF31CF281
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 12:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729537AbgELKdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 06:33:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55187 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726193AbgELKdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 06:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589279581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oWSfUmBy5G7w8s0mFzIrpHSBiQEAL75l96FocmDeH+w=;
        b=beGElXichNoGlVPHOfVGmAr499YoorKbPvV4JXgufmwsi5Sl/bCoj4+cfiK++3EjwXWQth
        wPtyMCf1myp/HRe3ZIdBtCJnvJf4/xnWh9GIqyYoKwWWs+7BqJI44REayIZBfZIQi6masY
        znujiaP1TlEj2qdv4g5WDECotYw3CBo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-4PVQ_z-YNyGnm2Np0QjCDw-1; Tue, 12 May 2020 06:32:55 -0400
X-MC-Unique: 4PVQ_z-YNyGnm2Np0QjCDw-1
Received: by mail-wm1-f71.google.com with SMTP id p185so2451489wmp.5
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 03:32:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oWSfUmBy5G7w8s0mFzIrpHSBiQEAL75l96FocmDeH+w=;
        b=VTo6whdNsOEwAb/HspuGiUGHJTTDjlkeVvFI1dTn9cViybeT2Gd7u+t89BOPed7VeN
         c4W8tF+Hn8HwHQyYR6TlLlphmrhlyEQdSlucpqiGHw+ukGv92V/BKxxhf7AN8CLhSCEw
         RRdcy9pEu7texlZyDClskhR65HpLb8vGgkPxL9yRu6Y+e+Bym8st6mxieQEy0GBh+zDr
         UHuHRfESSjcxBUgrGWkZbZ9CqAaK39VeR0GdmG+Md2oyRjLIdDfHhVvPDQWZMQi/gm88
         4KqZr7BxekKKik5mLZhWejer56jEZ1dd3WDLV+51ckNa8K42fzsEpDsky5TKy/XZFHHV
         0xXA==
X-Gm-Message-State: AGi0PubIzgF5TAeqJrTeapM9sPySEkpfccsE50rnYT3Cm196lzvKGHEy
        u79j6UfyvKH64/GT9cozn7InFJg0yTXc6QpB96aa9FsSquC7sFv0IVNZFbrYo58pFcWpHqWvtYe
        iIZX8LRb5oY8/
X-Received: by 2002:a5d:560c:: with SMTP id l12mr23822070wrv.309.1589279574898;
        Tue, 12 May 2020 03:32:54 -0700 (PDT)
X-Google-Smtp-Source: APiQypIQhhMzrfHJzuqqGpCMtne83+qTrDIGPL9GtO3XV5eyvzYb43eEF0XvrPWMJEaysSiQNLomJg==
X-Received: by 2002:a5d:560c:: with SMTP id l12mr23822059wrv.309.1589279574750;
        Tue, 12 May 2020 03:32:54 -0700 (PDT)
Received: from x1w.redhat.com (17.red-88-21-202.staticip.rima-tde.net. [88.21.202.17])
        by smtp.gmail.com with ESMTPSA id b18sm1112431wrn.82.2020.05.12.03.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 03:32:54 -0700 (PDT)
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
Subject: [PATCH v4 3/6] scripts/qmp: Use Python 3 interpreter
Date:   Tue, 12 May 2020 12:32:35 +0200
Message-Id: <20200512103238.7078-4-philmd@redhat.com>
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
 scripts/qmp/qom-get  | 2 +-
 scripts/qmp/qom-list | 2 +-
 scripts/qmp/qom-set  | 2 +-
 scripts/qmp/qom-tree | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/qmp/qom-get b/scripts/qmp/qom-get
index 007b4cd442..7c5ede91bb 100755
--- a/scripts/qmp/qom-get
+++ b/scripts/qmp/qom-get
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 ##
 # QEMU Object Model test tools
 #
diff --git a/scripts/qmp/qom-list b/scripts/qmp/qom-list
index 03bda3446b..bb68fd65d4 100755
--- a/scripts/qmp/qom-list
+++ b/scripts/qmp/qom-list
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 ##
 # QEMU Object Model test tools
 #
diff --git a/scripts/qmp/qom-set b/scripts/qmp/qom-set
index c37fe78b00..19881d85e9 100755
--- a/scripts/qmp/qom-set
+++ b/scripts/qmp/qom-set
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 ##
 # QEMU Object Model test tools
 #
diff --git a/scripts/qmp/qom-tree b/scripts/qmp/qom-tree
index 1c8acf61e7..fa91147a03 100755
--- a/scripts/qmp/qom-tree
+++ b/scripts/qmp/qom-tree
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 ##
 # QEMU Object Model test tools
 #
-- 
2.21.3

