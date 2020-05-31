Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E281E98F4
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgEaQkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:40:11 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32843 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728341AbgEaQkK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 May 2020 12:40:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pSwnlYyy2B0PZW1yLAYRpAT/9w1HRsIxeqH6YbUmUyo=;
        b=T6tQ4IUZISIe+f02JMSbr2yuKCRpRruFYCdCzS7DLPuCtXLwyPYOF5eKZlSysH7VsIPvEO
        s8so2qnuDb3kRSKTyIFDFs5cQskDDsCIKDqAJS0cGcH5I4NToynstw4gB9iLAEditNeKtT
        JU0+ZP6DDD7+USsfSIMIveK7vNI+KXU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-VJ-6hlDCMtCwMulOxaD5RQ-1; Sun, 31 May 2020 12:40:07 -0400
X-MC-Unique: VJ-6hlDCMtCwMulOxaD5RQ-1
Received: by mail-wr1-f72.google.com with SMTP id w4so3623426wrl.13
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:40:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pSwnlYyy2B0PZW1yLAYRpAT/9w1HRsIxeqH6YbUmUyo=;
        b=lVElUqJseVY6DMMqjfiqhmQDi6TMoHhpLmNxfnUUNmvAVW/B34PYRXe7vE2RByk35y
         2u8VOGL5wDQxX9WQ4aWHdZkhNEs4rEVDcfzWbzTkihv+t4wm/wvJvhjn35FfeXBbzfIZ
         a2suTbLB6spz2Q4Bl+fS557DActwYx3Hy/ajraisKTdoK7v4rgwz5mat5F0c2YNAU/Tt
         BWLnElHYnVR/LgNAP5ScD5c/IV2ZI5KLKfc4QJC2o9i+qqbpAEkExQpAKcSq3xAiB4Pi
         EzHoFlhHCJC9/1FLou4HBirfBc2MystQWpPUmyUHWYrnWxpzC2NCYUCphR46pVUPNegh
         MAaA==
X-Gm-Message-State: AOAM530+snZGMe37ekxEOr0Ah0UNJLXICN8uyE5MWdFA8Z7EFgHn9mvP
        GLTMc/AfBrtXBwRAz6WNxM/Jnz72LpvZNg4BMqaqNLOIPY0+BGDUPPQ2XNpkdcQW9HIpruAhG5S
        QXginyiQDl3Ry
X-Received: by 2002:a1c:4c05:: with SMTP id z5mr6191172wmf.129.1590943206333;
        Sun, 31 May 2020 09:40:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzK6EJL9ukNUJVtb0DzQQtMY6apR9VUSafpsaZhu2G7jdYEUit4j1V2cYWBkGwNjw7QAftH3A==
X-Received: by 2002:a1c:4c05:: with SMTP id z5mr6191153wmf.129.1590943206180;
        Sun, 31 May 2020 09:40:06 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id k16sm16048090wrp.66.2020.05.31.09.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:40:05 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Cleber Rosa <crosa@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
        kvm@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        John Snow <jsnow@redhat.com>
Subject: [PULL 15/25] python/qemu/qmp: use True/False for non/blocking modes
Date:   Sun, 31 May 2020 18:38:36 +0200
Message-Id: <20200531163846.25363-16-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200531163846.25363-1-philmd@redhat.com>
References: <20200531163846.25363-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: John Snow <jsnow@redhat.com>

The type system doesn't want integers.

Signed-off-by: John Snow <jsnow@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Message-Id: <20200514055403.18902-15-jsnow@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 python/qemu/qmp.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/python/qemu/qmp.py b/python/qemu/qmp.py
index b91c9d5c1c..a634c4e26c 100644
--- a/python/qemu/qmp.py
+++ b/python/qemu/qmp.py
@@ -120,14 +120,14 @@ def __get_events(self, wait=False):
         """
 
         # Check for new events regardless and pull them into the cache:
-        self.__sock.setblocking(0)
+        self.__sock.setblocking(False)
         try:
             self.__json_read()
         except OSError as err:
             if err.errno == errno.EAGAIN:
                 # No data available
                 pass
-        self.__sock.setblocking(1)
+        self.__sock.setblocking(True)
 
         # Wait for new events, if needed.
         # if wait is 0.0, this means "no wait" and is also implicitly false.
-- 
2.21.3

