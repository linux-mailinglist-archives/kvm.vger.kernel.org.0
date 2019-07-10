Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC6B6649A0
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 17:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbfGJPbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 11:31:34 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37353 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728091AbfGJPbd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 11:31:33 -0400
Received: by mail-lj1-f196.google.com with SMTP id z28so2542809ljn.4
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2019 08:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=eng.ucsd.edu; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C1wKrfnxE3aI/zW2IlICe9/kKX5YLvazS2tqbYwzR+s=;
        b=Lt9tEdlf/gZn4VTbkqpKUtk0yBIj0i1oFbgIxKD+jkjofB9nYD7V2uLfHpoXrkdLTx
         NddoA0ouc8CwjRwyrW+zJC8NqAJAG4EteW9bapre+WW88VVW/3z79sGNTxMMnArP58Rs
         sZHXZBaRIbSMAUshC1WD2E24T9nAx+236CsiI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C1wKrfnxE3aI/zW2IlICe9/kKX5YLvazS2tqbYwzR+s=;
        b=PSv4pvIrv9luaQOwJHXePl45cGWLGb/+bZ8zb6rlkp3Bdn2SGIwytC+NX8UwZWOeW+
         cLNRrr/KNKy6vju5kS6zEhX6Wftkv03ieQozIcNSY7Qsy8txlFqzVQHyubHxTX0JTzJs
         2ouMjFdEGpwixUnQM25LUsH5pplvrbGqRzjY7d18R5QrJ4xfW/nVPSZDm80I6i+5mFdk
         PiMo3YZntvqHw9fM4GsXgU9yPP7eS0+rxyECCsun1fhfTwPyr+jICYeVVrdgvXgykyb1
         J6ovH/V+Z55c/up/RMmue+2WTHmgoeVG85JY/eHDmZqN9Gqu/jlDst8EHGancCRGjPQp
         ox9g==
X-Gm-Message-State: APjAAAU8RUNDqlHgH4GG79vVTkFH7FDqCEQ7vxt3H0dQvx4EKHxtwdmt
        wrE2EpoQjfFHcUPdT//jXrSrig==
X-Google-Smtp-Source: APXvYqzcZ1IiJN2Vu2KTzh2QcFqncKYeHJK0TUMUpy06XEaOG0cQVGDxKxcKSP+zFKizUHdpDSNY5w==
X-Received: by 2002:a2e:8892:: with SMTP id k18mr18168234lji.239.1562772691184;
        Wed, 10 Jul 2019 08:31:31 -0700 (PDT)
Received: from luke-XPS-13.home (159-205-76-204.adsl.inetia.pl. [159.205.76.204])
        by smtp.gmail.com with ESMTPSA id o17sm517208ljg.71.2019.07.10.08.31.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 08:31:30 -0700 (PDT)
From:   Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
X-Google-Original-From: Luke Nowakowski-Krijger <lnowakow@neg.ucsd.edu>
To:     linux-kernel-mentees@lists.linuxfoundation.org
Cc:     Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>,
        pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3] Documentation: virtual: Convert paravirt_ops.txt to .rst
Date:   Wed, 10 Jul 2019 08:30:52 -0700
Message-Id: <20190710153054.29564-2-lnowakow@neg.ucsd.edu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190710153054.29564-1-lnowakow@neg.ucsd.edu>
References: <20190710153054.29564-1-lnowakow@neg.ucsd.edu>
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
much more clear and easy to read. Added default kernel license to the
document.

Signed-off-by: Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
---
 Changes since v3:
 none
 Changes since v2:
 none
 Changes since v1:
 + Converted doc to .rst format
 
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

