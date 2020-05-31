Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8F51E98EC
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgEaQjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:39:40 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38547 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728296AbgEaQjj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 May 2020 12:39:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gbfmbJetD8UXBRyHPiWp2CZGSyL0yCJiZ8wSWR7Ajrc=;
        b=RqjfETu8ke3T2NkI9jEjHaVvS7H/EFpLBaeeSjrz2KYAIjAFkcdzAUIyexKy7DViwLfnc5
        Uggs8OvJqFC7XuG/fOtT5Pv5Ql4Jl0xQOOMQL9WsfEZMYdb/32GkasQSyWTwdpu+uDdZB3
        px6v8Yrw7zs1RO+08aUKZDZs9imXmkY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-QWjtuNHxMGSYOBZFzSzNwQ-1; Sun, 31 May 2020 12:39:36 -0400
X-MC-Unique: QWjtuNHxMGSYOBZFzSzNwQ-1
Received: by mail-wr1-f70.google.com with SMTP id l1so3615005wrc.8
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:39:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gbfmbJetD8UXBRyHPiWp2CZGSyL0yCJiZ8wSWR7Ajrc=;
        b=kYyEofCeEemfZm1v1wXKyNszniSR8fW56A2cOgIGzWCQ9Swm7kY1SJtcUxDPa6OwSZ
         7rlVoumhTwM/k2g95MkCr+xy7L3ror9UGbpnGoc55EIm7I/ki2qrgMTwQTaIojzHUYAc
         xLxPW4JaDUlcrjDs1rlh06FV29MJHhXJ0P0rTULHxZDNnTfQBEbsJV27radqouPXVgiq
         saSPg4CJwne/g16Bjaw5ZmpJcJQXRKWX/whH2ScjCNVcOyQKb31kmtsX1vGfdBSkvPHV
         5HjxQBQmyAl8RXK6Tq/bB0VYf7XUe9RSkx1fFEcnVVWshwMEIFc+pHCdJgWay/Xu9Qay
         DV3Q==
X-Gm-Message-State: AOAM532CeGYsSJ8U2FWGYYc9O2ovG4OXATES6jLa8wMHGGH0ct+vlPMX
        +x9yRl4tiypZTSQgLKc1VHxObgWLW8pYyfy+EHSjahVYSYRMojv1d9d44Xk5GTkXUNoiy5TwsAa
        tuS94alup9zvG
X-Received: by 2002:a5d:6905:: with SMTP id t5mr17760707wru.113.1590943175696;
        Sun, 31 May 2020 09:39:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyR0WKTSgw9DfCBwsj7WS7gvkIpsMb9ekd4IwqI/sxgbznb+YzTnTNNzeC4sMj2PMSV+Th05w==
X-Received: by 2002:a5d:6905:: with SMTP id t5mr17760696wru.113.1590943175563;
        Sun, 31 May 2020 09:39:35 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id s7sm17688910wrr.60.2020.05.31.09.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:39:35 -0700 (PDT)
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
Subject: [PULL 09/25] python/qemu/machine: remove logging configuration
Date:   Sun, 31 May 2020 18:38:30 +0200
Message-Id: <20200531163846.25363-10-philmd@redhat.com>
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

Python 3.5 and above do not print a warning when logging is not
configured. As a library, it's best practice to leave logging
configuration to the client executable.

Signed-off-by: John Snow <jsnow@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Message-Id: <20200514055403.18902-22-jsnow@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 python/qemu/machine.py | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/python/qemu/machine.py b/python/qemu/machine.py
index d2f531f1b4..41554de533 100644
--- a/python/qemu/machine.py
+++ b/python/qemu/machine.py
@@ -119,9 +119,6 @@ def __init__(self, binary, args=None, wrapper=None, name=None,
         self._console_socket = None
         self._remove_files = []
 
-        # just in case logging wasn't configured by the main script:
-        logging.basicConfig()
-
     def __enter__(self):
         return self
 
-- 
2.21.3

