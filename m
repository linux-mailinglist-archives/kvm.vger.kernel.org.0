Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6DA61313
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 23:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfGFVjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 17:39:06 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41599 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727147AbfGFVi7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 17:38:59 -0400
Received: by mail-lj1-f195.google.com with SMTP id d24so3227686ljg.8
        for <kvm@vger.kernel.org>; Sat, 06 Jul 2019 14:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=eng.ucsd.edu; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bfvjrsks1RUnIEvn0hCGuNZczvVTBiXDr5mImW45S1o=;
        b=T5hJy5VwX4Yi2YSs8M9tdGzLdBr0DMzcD1H8KQDcqt5tlOuObylrEK9pxa6ls7RlSu
         uDzE1ESX3c8T3+wOaOXscu4VM6nFpw0hphU7ffrU8D5F/sMc5mPDcjVYL1abYK4phRFo
         C7WRF2uKjvUDmxWY8qj/AD6KhfBFQKaWL0mjE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bfvjrsks1RUnIEvn0hCGuNZczvVTBiXDr5mImW45S1o=;
        b=ITvux0c1Y4x3SP2Hn/aZRFSnKk7pdzM2wSUR4K2SFcjt2AaSsxFxLRLInIveT7x4nw
         JWxBvVUacjwJFBEimHkHlGKPWJx6slJFx/dr4gis70xKHiiVj9fixDolq29oHwjfquyR
         DiybKPkx8W0cpyaCNcirnPYbxEqlwzPGsO4K+ed+NbxvsxzG6vaPr45QwJp2cSL9WJ9F
         GC1NUBFxT/3xA0/FsFGlJ/Q75fsDlSHFlA0hRL/5I5A36J19yXB9XPdrfzIWFr1ObiuI
         EqHKczBdUXwRdSA8azXC08V+2jYu5zhePhvUdc2BU88KryqzM9Nq2sV3o/5uJIuEEAVJ
         RYKQ==
X-Gm-Message-State: APjAAAU5km9ImNbEi6bYdmmqV2JPjmw3eGfmxZ8ZcT00yn3i9nUIWxog
        dwtKIyx+L1M0eSgsaEYT9w3pEo6rBqHoDg==
X-Google-Smtp-Source: APXvYqwpQ+/j2fYajARlIcrAGWPhBHN6vqvnRmqCuuQr+jB2jWY16xCq3+XpE3CneUnHa1lfsCd9kQ==
X-Received: by 2002:a2e:8e90:: with SMTP id z16mr5892942ljk.4.1562449137491;
        Sat, 06 Jul 2019 14:38:57 -0700 (PDT)
Received: from luke-XPS-13.home (77-255-206-190.adsl.inetia.pl. [77.255.206.190])
        by smtp.gmail.com with ESMTPSA id j3sm1322449lfp.34.2019.07.06.14.38.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 06 Jul 2019 14:38:57 -0700 (PDT)
From:   Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
X-Google-Original-From: Luke Nowakowski-Krijger <lnowakow@neg.ucsd.edu>
To:     linux-kernel-mentees@lists.linuxfoundation.org
Cc:     Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>,
        pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Documentation: virtual: Convert paravirt_ops.txt to .rst
Date:   Sat,  6 Jul 2019 14:38:15 -0700
Message-Id: <90496dad48588db8822f89b120c7cf2d3ce12078.1562448500.git.lnowakow@eng.ucsd.edu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1562448500.git.lnowakow@eng.ucsd.edu>
References: <cover.1562448500.git.lnowakow@eng.ucsd.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>

Convert paravirt_opts.txt to .rst format to be able to be parsed by
sphinx. 

Made some minor spacing and formatting corrections to make defintions
much more clear and easy to read. 

Signed-off-by: Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
---
 .../{paravirt_ops.txt => paravirt_ops.rst}    | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)
 rename Documentation/virtual/{paravirt_ops.txt => paravirt_ops.rst} (65%)

diff --git a/Documentation/virtual/paravirt_ops.txt b/Documentation/virtual/paravirt_ops.rst
similarity index 65%
rename from Documentation/virtual/paravirt_ops.txt
rename to Documentation/virtual/paravirt_ops.rst
index d4881c00e339..6b789d27cead 100644
--- a/Documentation/virtual/paravirt_ops.txt
+++ b/Documentation/virtual/paravirt_ops.rst
@@ -1,3 +1,6 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+============
 Paravirt_ops
 ============
 
@@ -18,15 +21,15 @@ at boot time.
 pv_ops operations are classified into three categories:
 
 - simple indirect call
-  These operations correspond to high level functionality where it is
-  known that the overhead of indirect call isn't very important.
+   These operations correspond to high level functionality where it is
+   known that the overhead of indirect call isn't very important.
 
 - indirect call which allows optimization with binary patch
-  Usually these operations correspond to low level critical instructions. They
-  are called frequently and are performance critical. The overhead is
-  very important.
+   Usually these operations correspond to low level critical instructions. They
+   are called frequently and are performance critical. The overhead is
+   very important.
 
 - a set of macros for hand written assembly code
-  Hand written assembly codes (.S files) also need paravirtualization
-  because they include sensitive instructions or some of code paths in
-  them are very performance critical.
+   Hand written assembly codes (.S files) also need paravirtualization
+   because they include sensitive instructions or some of code paths in
+   them are very performance critical.
-- 
2.20.1

