Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4971E98FA
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgEaQkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:40:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21824 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727932AbgEaQkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 May 2020 12:40:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VtnVaYYGa7/aqTUYxIxdKhEN8NJpUIW8xv7x+iz9PNM=;
        b=IKIquA7fLNpyHb+TuthMfBWabTtdNw98PN1EBRsai1y17yTO+39YA3ItxHNiA7lscFZGhN
        RRyTdbn+9gJil721kMA5Ixghc5KT0JyMrPqJXjI9yYoob0HiOublrx9FOvwqUeX/jSl3hX
        qZUPTDjfpzld6AeIWhZTE9BQAqStE6o=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-Lg84mT8MMI2kR5Q06z77Eg-1; Sun, 31 May 2020 12:40:37 -0400
X-MC-Unique: Lg84mT8MMI2kR5Q06z77Eg-1
Received: by mail-wr1-f71.google.com with SMTP id l1so3615872wrc.8
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:40:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VtnVaYYGa7/aqTUYxIxdKhEN8NJpUIW8xv7x+iz9PNM=;
        b=o8R5eZTSy9DV2YOFoNixCRjWn4OQFVV0kZaMh+avI1epRquR3eiiZ6ZpL3CUcl/379
         eWCVKmXQDL1WSP0BiUmE1LN53uJ8bJj0H2K9/+HeAIywZ5JelPuWf9XHG7V4rabmMYrJ
         dMUopPCV3ghhN+THnseaxHbBEI0UA6qiZrykM85V1GnGvGAzAOAPLHSvejWYV30AGYlv
         Rrz2pq6+XNxwCX0oaZ++az12NPegfS3JCtwzBAdM/14o0sjMmqXI4CgqIrz3igeBwYHH
         Slql4b3YALi+q+nOn7QQtZh/kH8x0xktFUPIRDrdABZBYo1gpR36S+LeKfApiYEfPRiE
         9+hg==
X-Gm-Message-State: AOAM532neeeaobxfO59MyxkqsxjrB0ATHwxZOai0jgRwJdB16PfsssmV
        4qD6wcsXtGuRSLqXV6nJY63IWIGecI60YVLyeTWthZJGBrr3wMgjhJA+ApCeJe5zbtP7ennjKD9
        W6b3+rZpFycZ9
X-Received: by 2002:a5d:4484:: with SMTP id j4mr17681264wrq.325.1590943236590;
        Sun, 31 May 2020 09:40:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxgZwwOTcr688HaliXjwVILCgXMwwdoueLVIOVtH/2dXXqGIkOpERxl7rjGuHjeNfqMMGldnQ==
X-Received: by 2002:a5d:4484:: with SMTP id j4mr17681252wrq.325.1590943236436;
        Sun, 31 May 2020 09:40:36 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id d13sm8390301wmb.39.2020.05.31.09.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:40:35 -0700 (PDT)
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
Subject: [PULL 21/25] tests/migration/guestperf: Use Python 3 interpreter
Date:   Sun, 31 May 2020 18:38:42 +0200
Message-Id: <20200531163846.25363-22-philmd@redhat.com>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Reviewed-by: John Snow <jsnow@redhat.com>
Reviewed-by: Kevin Wolf <kwolf@redhat.com>
Message-Id: <20200512103238.7078-7-philmd@redhat.com>
---
 tests/migration/guestperf-batch.py | 2 +-
 tests/migration/guestperf-plot.py  | 2 +-
 tests/migration/guestperf.py       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/migration/guestperf-batch.py b/tests/migration/guestperf-batch.py
index cb150ce804..f1e900908d 100755
--- a/tests/migration/guestperf-batch.py
+++ b/tests/migration/guestperf-batch.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 #
 # Migration test batch comparison invokation
 #
diff --git a/tests/migration/guestperf-plot.py b/tests/migration/guestperf-plot.py
index d70bb7a557..907151011a 100755
--- a/tests/migration/guestperf-plot.py
+++ b/tests/migration/guestperf-plot.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 #
 # Migration test graph plotting command
 #
diff --git a/tests/migration/guestperf.py b/tests/migration/guestperf.py
index 99b027e8ba..ba1c4bc4ca 100755
--- a/tests/migration/guestperf.py
+++ b/tests/migration/guestperf.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 #
 # Migration test direct invokation command
 #
-- 
2.21.3

