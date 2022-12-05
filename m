Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95EE6642CC9
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 17:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbiLEQ2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 11:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiLEQ2w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 11:28:52 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5662D10E
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 08:28:47 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3b48b605351so128369797b3.22
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 08:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qNZRZOs6tZrgxMD+AymHl4JxTdSLkvuAeQ6yayWzmP4=;
        b=hhgfi/WB/IHgtahMUphAOBfOSVskcKsjJP5VqIMwQTTysETxoWyQipK/zT/bS+I/Sz
         luhRRPhVTXVKJ0M3O/XNfatA3H5noWwmiNJYsrI5LtU7eT2LtgwcMVY657Hdwe6zc348
         KbsSNAm/4poFS5f1iKh3/z9pr112CRdpHTGMmr10yyS9nLwGQyNdvm+GtCIx63GkwKpj
         gwgNJOW60jj1JnLv0YyAyWRzYHdZQpbJS6j1jvNP18KeQKSf3hwI6+Uxi6t2isbO+EmB
         oagvD/DxCsAuey9O8JyJhF7I5KBbeUo6qVxO964133Id/lIBm8NvhkelGw/a7Nd0URD4
         yZ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qNZRZOs6tZrgxMD+AymHl4JxTdSLkvuAeQ6yayWzmP4=;
        b=R1Wn999tSr0zzNiqBwajT5oBgL6FUZFErMTdAmnAhM69hUQyE2HnFHxGK5YrQkyeGt
         kq0IKXMvH4zUZ34LzTYIKHC8PVAaLzTvZHTf6scuOzx2/ZpNz6riz5SQWhx4Fhm9V49h
         whT05u7AGp90JHTXWHRGwMG+A1BpsL4xTZUkz1NkDj5TaYKYXeN+Zb+PEkUzB0Y+lCHj
         4DZ0t0q04PNcp2npG9XzqZpjNGtkg8B/ph+KWSx5jwF5BE06YAya9APCPBdefoAGyUQT
         fAO4TCIROo0txNbJkruOrudHBHshWs9Azi3KMMslGK4s7mU4+aVRnuM4j7mQaoTipIMy
         S5SQ==
X-Gm-Message-State: ANoB5pnIe82l08x3HS5nOIU5sEtMN+dF6i4HNPQb8hivLmHVYGzTrFi7
        wEe2Wz+JLnQS/OjomklSE5VpssLhrHBhW7msns6D1jKV8ta+X++zO50Mv5DgzOaYhB6lpi7we+e
        53UN9c2d0FpUZeUACGvQutDYu16XOnaRgIfEt2bE2ZRQ0WfgplzWl77UnNPvT
X-Google-Smtp-Source: AA0mqf67nBY61JQMBYcA267FyqCUBMSW2xP69QAoCXr0bhNNGdhtDYHNByeMSSa0HpHuKbn1weZt1/jlGJoV
X-Received: from gthelen2.svl.corp.google.com ([2620:15c:2d4:203:3b47:b903:a6ef:6a5])
 (user=gthelen job=sendgmr) by 2002:a81:144:0:b0:3f2:16fa:2647 with SMTP id
 65-20020a810144000000b003f216fa2647mr1765158ywb.75.1670257726711; Mon, 05 Dec
 2022 08:28:46 -0800 (PST)
Date:   Mon,  5 Dec 2022 08:28:40 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221205162840.535675-1-gthelen@google.com>
Subject: [kvm-unit-tests PATCH] avoid encoding mtime in standalone scripts
From:   Greg Thelen <gthelen@google.com>
To:     kvm@vger.kernel.org
Cc:     Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reproducible builds aid in caching builds and tests. Ideally rebuilding
the same source produces identical outputs.

The standalone kvm test scripts contain base64 encoded gzip compressed
test binaries. Compression and encoding is done with
"gzip -c FILE | base64" which stores FILE's name and mtime in the
compressed output.

Binaries are expanded with
  base64 -d << 'BIN_EOF' | zcat > OUTPUT
This expansion pipeline ignores the gzip stored name and mtime.

Use "gzip -n" to avoid saving mtime in the output. This makes the
standalone test scripts reproducible. Their contents are the same
regardless of when they are built.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 scripts/mkstandalone.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index 86c7e5498246..1e6d308b43f7 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -16,7 +16,8 @@ temp_file ()
 	echo "cleanup=\"\$$var \$cleanup\""
 	echo "base64 -d << 'BIN_EOF' | zcat > \$$var || exit 2"
 
-	gzip -c "$file" | base64
+	# For reproductible builds avoid saving $file mtime with -n
+	gzip -nc "$file" | base64
 
 	echo "BIN_EOF"
 	echo "chmod +x \$$var"
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

