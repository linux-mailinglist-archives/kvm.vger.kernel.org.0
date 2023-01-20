Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B676754A9
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 13:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjATMgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 07:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbjATMgM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 07:36:12 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31211BFF53;
        Fri, 20 Jan 2023 04:35:45 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id k13so5256639plg.0;
        Fri, 20 Jan 2023 04:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+XT9kad4yNYrmYBEVNX5sJ/vTlzpH7jOnDJsBQpKUaY=;
        b=o1DizLMpkK/XWtupOkGIL0XJkwy5IvcKxYbOInCIMcgwXpUlGb3XbnVWRRSXoVptUZ
         qvJIFMD1FvcHncGKgonqG1rlQKlgeVxcU9cPYCyiDRijYNw7cd3YgGzwuTqGjv6Upxo1
         dfwwz08WXNvcRbhCrGhevuFpZlnx/6vLcAxHq55K754d7q1I/7k3BpXeBwcZjrYObJlH
         xWMg5+igvxefRAE0dr77Y3pJezVM13Xu7UAHiKJ4k+5xQXfphuxdFQeLprWYZOA855fJ
         yauL6r3ayGXFR6o9GcJGOFR8ZTl8GLzdQBeOcFuHxPUU0lL+V3e6tXtEFp3JkK0+Lfcc
         YkMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+XT9kad4yNYrmYBEVNX5sJ/vTlzpH7jOnDJsBQpKUaY=;
        b=3iz1yVnEfFbKYA3HJcHkVuDBS/Ksq3rM1fFE6ivswEyC7J2PZVdyvQYnRA1xscOYTU
         Zx3NXCTW0nAKDNlw+8PxT5e8a7sN0cMaj8vgbT+ZsTVQjI08pmXS71STNA+jkWK/ps+P
         rOfFU5ND4o1PrkYZnLXFCwFFOjqTbAC43WR+eKETRN21/16pvrNYay1aSenl/HVEOA3K
         ft2FTqcQyaIWiRzuPyiRLA34Y/d9mHlDmOPORL4kwlx7kdFUigk6NNyMgOb4k9GMJczp
         utdf3qyvoxJochtN37I4njfAlzJR8IUPMGK7d31dXfFnKyDtI33z8G4vmWBugOl9b/4t
         Ulyg==
X-Gm-Message-State: AFqh2kqLGxykb9w3VGe+cXqgxDFaUZbRaA9E1TneubQauawntMBzhQJK
        3DMY0A8YNqyJNLZWlbVgbV0=
X-Google-Smtp-Source: AMrXdXtR2dp2lGd836pplDAnvwEYyR4FgT1yvTQphEkpDyqJKKc/zFKYkS4KybH4feu7AhdF/DFATQ==
X-Received: by 2002:a05:6a20:12d0:b0:b6:a6c4:87b0 with SMTP id v16-20020a056a2012d000b000b6a6c487b0mr20697785pzg.41.1674218143103;
        Fri, 20 Jan 2023 04:35:43 -0800 (PST)
Received: from debian.me (subs02-180-214-232-6.three.co.id. [180.214.232.6])
        by smtp.gmail.com with ESMTPSA id nm1-20020a17090b19c100b0022717d8d835sm1422965pjb.16.2023.01.20.04.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 04:35:42 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 44717104FA4; Fri, 20 Jan 2023 19:35:37 +0700 (WIB)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Freedesktop DRI List <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation <linux-doc@vger.kernel.org>,
        Linux KVM <kvm@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Oded Gabbay <ogabbay@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jeffrey Hugo <quic_jhugo@quicinc.com>,
        Ofir Bitton <obitton@habana.ai>,
        Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH linux-next 1/3] Documentation: accel: escape wildcard in special file path
Date:   Fri, 20 Jan 2023 19:35:32 +0700
Message-Id: <20230120123534.137413-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230120123534.137413-1-bagasdotme@gmail.com>
References: <20230120123534.137413-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1452; i=bagasdotme@gmail.com; h=from:subject; bh=1v1ZVN3QD/qaEbSGAKvpr7+XFzT7pgg0PCoXuklJFvo=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDMmnuqZa5MVnegeFrN/LpCgsEKFssnv28cyqSyuvH1voFf3k rL9ORykLgxgXg6yYIsukRL6m07uMRC60r3WEmcPKBDKEgYtTACZyrpnhv1dNBkdmUOZE7x515wDLSc 9DDPZLtaVuKN20l0FwSdSxPQz/3ZdM/7P784x1RZ7frfOjK45z9torf7sa/DTWsVbUa8dkdgA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stephen Rothwell reported htmldocs warning then merging accel tree:

Documentation/accel/introduction.rst:72: WARNING: Inline emphasis start-string without end-string.

Sphinx confuses the file wildcards with inline emphasis (italics), hence
the warning.

Fix the warning by escaping wildcards.

Link: https://lore.kernel.org/linux-next/20230120132116.21de1104@canb.auug.org.au/
Fixes: f65c5dac207322 ("docs: accel: Fix debugfs path")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/accel/introduction.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/accel/introduction.rst b/Documentation/accel/introduction.rst
index 11cade51f387a6..89984dfececf0b 100644
--- a/Documentation/accel/introduction.rst
+++ b/Documentation/accel/introduction.rst
@@ -67,9 +67,9 @@ tree - drivers/accel/.
 The accelerator devices will be exposed to the user space with the dedicated
 261 major number and will have the following convention:
 
-- device char files - /dev/accel/accel*
-- sysfs             - /sys/class/accel/accel*/
-- debugfs           - /sys/kernel/debug/accel/*/
+- device char files - /dev/accel/accel\*
+- sysfs             - /sys/class/accel/accel\*/
+- debugfs           - /sys/kernel/debug/accel/\*/
 
 Getting Started
 ===============
-- 
An old man doll... just what I always wanted! - Clara

