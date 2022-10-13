Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2285FE45D
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 23:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiJMVs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 17:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiJMVs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 17:48:57 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4CC1849A7
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:48:57 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id x31-20020a17090a38a200b0020d2afec803so3068778pjb.2
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=to:from:cc:content-transfer-encoding:mime-version:message-id:date
         :subject:from:to:cc:subject:date:message-id:reply-to;
        bh=mpYh04Q3DjlI17Rhho09EJ79/GDmjZTt6la/N71F8B4=;
        b=zBZPybDZNWh0wskUsbS4NK/YN1WJN7j/VTZPGNWss6CuvIgFCDE/TUfG3dMIUyiHIP
         6vafwla//z3BmGexBI0dvVf9KRQfSDNsltnsG4Vhg81lm831akj3WNTxI/xvrmxakual
         4zvjv3TLF/XG8ts2lesWYruHX962zn9Mujg7xNoZU+IZJO5lLp0oAbs1ASDm/PzaS0xD
         DXA580Ycb6z2Hr75Gt9LVqxjDTFts36QaaVqYuq3Gat2dDfXPkN5iBZmZi6L3qmg5z8c
         xRCmOcQMjoWsfkCL/WCFvQOfqDrqLjEh0oBiRa0U9DN96g3Tz9GeCOhA4URiE8OrtnxK
         G2eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:cc:content-transfer-encoding:mime-version:message-id:date
         :subject:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mpYh04Q3DjlI17Rhho09EJ79/GDmjZTt6la/N71F8B4=;
        b=k+I4CYUlxZ48fc6FVY/Lj378cGmY4rsCvUMy7Lfcl/jzOqVGaNgqxKKWzrauZX1J8J
         4bcCpu/2f4GwGohJhFfor5Y0URr06XxSzoft9hSrzM8J+lUIqQ7LuiriLYIHhevOQKEP
         G/qQZMXMfIfFgWr3vvPkuNU3af0mOeKq48oRPaqRRPiep/dkh3GppQE0dVTf8nLI5r5z
         660AK96a6eYd/CFQ+tHTn/oSs03fasQ+DDl72Hyey/+fVwmh9Lvgdl+xAd0Z8Krx15FG
         b2BtLfxP1kLP+5q920cMnydAqs4wwySP1frmpu5HB8oa1q9Cr7Gl0duR/fPuJkGE5zgi
         QXTA==
X-Gm-Message-State: ACrzQf0QCfczcv2ZLjmIMjouxJBxbP8SAcF+Mgs/93vkSHxoXQph230P
        5ekwHISW7OEAZt+MUnJ3fPUyfg==
X-Google-Smtp-Source: AMsMyM5uSktAQYhJmahw0FgwYcraN3cyOGbXNxi5pDP7skcwP5gAuMAO+oUqTn+89Bhe/9HO9PMSgg==
X-Received: by 2002:a17:902:9048:b0:17f:93a5:4638 with SMTP id w8-20020a170902904800b0017f93a54638mr2029735plz.108.1665697736640;
        Thu, 13 Oct 2022 14:48:56 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id z3-20020aa79483000000b00562b389292bsm179728pfk.51.2022.10.13.14.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 14:48:56 -0700 (PDT)
Subject: [PATCH] MAINTAINERS: git://github -> https://github.com for awilliam
Date:   Thu, 13 Oct 2022 14:46:36 -0700
Message-Id: <20221013214636.30721-1-palmer@rivosinc.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:        linux-kernel@vger.kernel.org,
           Palmer Dabbelt <palmer@rivosinc.com>,
           Conor Dooley <conor.dooley@microchip.com>
From:   Palmer Dabbelt <palmer@rivosinc.com>
To:     alex.williamson@redhat.com, kvm@vger.kernel.org
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Github deprecated the git:// links about a year ago, so let's move to
the https:// URLs instead.

Reported-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://github.blog/2021-09-01-improving-git-protocol-security-github/
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
---
I've split these up by github username so folks can take them
independently, as some of these repos have been renamed at github and
thus need more than just a sed to fix them.
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3705c487450b..41a925931cc3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21305,7 +21305,7 @@ M:	Alex Williamson <alex.williamson@redhat.com>
 R:	Cornelia Huck <cohuck@redhat.com>
 L:	kvm@vger.kernel.org
 S:	Maintained
-T:	git git://github.com/awilliam/linux-vfio.git
+T:	git https://github.com/awilliam/linux-vfio.git
 F:	Documentation/driver-api/vfio.rst
 F:	drivers/vfio/
 F:	include/linux/vfio.h
-- 
2.38.0

