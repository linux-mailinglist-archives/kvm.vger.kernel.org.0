Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24EF5144207
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 17:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgAUQVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 11:21:49 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37991 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgAUQVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 11:21:49 -0500
Received: by mail-wm1-f65.google.com with SMTP id u2so3778569wmc.3
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 08:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=fgORcTRcVPOjE/nYJxVcLMJmNeQKeZ0Sup420dt6Jog=;
        b=PCrAL/FH5qencx0LrGU3u9Yh6X5lWm9V9VKXvVnZ1jVEA6w4wAg+mKhY8/nNUBdq9n
         oeQ2VAMhScDi+RrrVjU6W4g6YjMbAUxHPdmoeFe2m1vG/kR+OmywXCRNv45syVu83pCm
         5cnTJKD+rF1MCGGeJ7DYEEOEk53mm86V8wFgXHjERHY8CxX8FWxKQbn/rUFGK5m2j4HL
         QoXhqzv+gztzZ3NUx3NjfDf4QYM93Oc6zzwW1nDAxVQoucy75I5UoDz298FsxKmPjXwC
         /Be02OO2vIHfTdfmQgI2nkfNIScFAEJyNTZ68WU5Sg4IR/vCNw1wQkwH6FfdU212vlVp
         fMkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=fgORcTRcVPOjE/nYJxVcLMJmNeQKeZ0Sup420dt6Jog=;
        b=lTMhBEGj0QwzQmYr9Jk0vltyHnK0xJE0/ZoY0Q2nH1Rph2dYQr8UurstOW6VZoh6I4
         8taWrv0QzFPEiVmKa/BSxGNyaaF/fQmcmLkwKWK9t1KBD9kWqKd5MkkqXY2rxpk0aWfy
         guQmY/dqhjUFsAVrQ4Ah/6z4N1YWGHJyQJ60HDvLZ59IiVktw7W/WoW5rPWBrKWqAPHK
         yEtQe520TC59SZqg6x9pKN62UoTRIB8z9BDc1or+QpIJJ5e3+FzHWK5AdDGAUG2Tex3c
         iCTUZ6ed/v2ZZTWlYkR2ak4OkRK5ueypEkNhqsINyz+PWrJ4x212qeD/K8hblfGPFprt
         5Kfg==
X-Gm-Message-State: APjAAAUighebKeUqDXYCoMdGyiSVj6HA/gUx+iwszzVuZCSPq8YpLRKK
        lxGQecZDwBd9DwjJPOU1BGh0Uf+I
X-Google-Smtp-Source: APXvYqz/UKnYGWmtfHbB84TAU5f+EvGdCI/grBxh8Q+zYCzWcipZK9MaYheojZmabTYHQmu6gB8Xsw==
X-Received: by 2002:a1c:66d6:: with SMTP id a205mr5230193wmc.171.1579623707100;
        Tue, 21 Jan 2020 08:21:47 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id h17sm54983664wrs.18.2020.01.21.08.21.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jan 2020 08:21:46 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com
Subject: [PATCH kvm-unit-tests] expect python3 in the path
Date:   Tue, 21 Jan 2020 17:21:45 +0100
Message-Id: <1579623705-51801-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some systems that only have Python 3.x installed will not have
a "python" binary in the path.  Since pretty_print_stacks.py
is a Python 3 program, we can use an appropriate shebang.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 scripts/pretty_print_stacks.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/pretty_print_stacks.py b/scripts/pretty_print_stacks.py
index a863c8e..1e59cde 100755
--- a/scripts/pretty_print_stacks.py
+++ b/scripts/pretty_print_stacks.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 
 import re
 import subprocess
-- 
1.8.3.1

