Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4333A1CF282
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 12:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgELKdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 06:33:05 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59770 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729365AbgELKdE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 May 2020 06:33:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589279583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FN/9Q7LqiT7yOKM3lyj2/vvjplGjuC96R8PuYHJ2hZI=;
        b=MsNC4uVksMZaeiI/oTccX+OOK0OGB1xJ2ZTo5Sk7VQtHP8nkM1kU+drA5/rjt/dHzgqvMD
        lEtxcVbIRZ1dyyqU0D5dF3Xt+JOzFMkbpHCeH3HVPoJXrwxa3XEhdmEeNVkzj8e8Inkgur
        g+Z9/R+6695OYcGrIj0Mp6AWDz/GJJ0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-4x6skZNAMFWiIs_LGqWm5A-1; Tue, 12 May 2020 06:33:00 -0400
X-MC-Unique: 4x6skZNAMFWiIs_LGqWm5A-1
Received: by mail-wr1-f71.google.com with SMTP id j16so6709099wrw.20
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 03:33:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FN/9Q7LqiT7yOKM3lyj2/vvjplGjuC96R8PuYHJ2hZI=;
        b=sRdZitX5IYQpoHULqXkakqqmO82cGxhnGwjAxFIRTPhOBNeK4OSnoBxUGms8kh5nQF
         /EXjgrvSdjupVxYApJ4nj5REfwlI5Te8qVwLMZbBLVFn+RNaOYH9iQ9iP7QXqR5WZRXp
         h2liD0IliwFzxc/13ADiHQUnoEFn0ABzP+9VUdORICaZGlXpW/va+xr0/sJ6Kc1e2WNa
         EpsOr05rwBdrAZHJJJtP+AOnu8CYD9FnUC5C4ug5a2PKjBFKaAGnIxw2Dg+5q8WY9Y0S
         Va+ca1Qsoq2847nV4Ek7nQ0xYNcYncrTqUzAJjJ6xK4u4I/95kU6tu8h6hS0ahhbieiT
         53Ew==
X-Gm-Message-State: AGi0Pubk58Xh54s/byzFGfZfqqh3lEjUvdufkSk6Ucsj2j1ye0Wp8PGH
        ECUFbj0IdAKvAwL7WMnxuOTGbIG5GXDcrmG9mmjcUMrzc5b+LdWrSQJBBnDdpLDfQ1B3ANBJn4T
        eEOxURMH0YIEX
X-Received: by 2002:a1c:a3c1:: with SMTP id m184mr18797671wme.91.1589279579783;
        Tue, 12 May 2020 03:32:59 -0700 (PDT)
X-Google-Smtp-Source: APiQypLoVobmiuPPC5yzEHiFpfHm0s+HDrmev5jafrGVEC8Jo2mwsLRcy5dqC4UGFChZXKNb5cxJ4A==
X-Received: by 2002:a1c:a3c1:: with SMTP id m184mr18797645wme.91.1589279579565;
        Tue, 12 May 2020 03:32:59 -0700 (PDT)
Received: from x1w.redhat.com (17.red-88-21-202.staticip.rima-tde.net. [88.21.202.17])
        by smtp.gmail.com with ESMTPSA id v131sm3712043wmb.27.2020.05.12.03.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 03:32:59 -0700 (PDT)
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
        Fam Zheng <fam@euphon.net>
Subject: [PATCH v4 4/6] scripts/kvm/vmxcap: Use Python 3 interpreter and add pseudo-main()
Date:   Tue, 12 May 2020 12:32:36 +0200
Message-Id: <20200512103238.7078-5-philmd@redhat.com>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 scripts/kvm/vmxcap | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/scripts/kvm/vmxcap b/scripts/kvm/vmxcap
index 971ed0e721..6fe66d5f57 100755
--- a/scripts/kvm/vmxcap
+++ b/scripts/kvm/vmxcap
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 #
 # tool for querying VMX capabilities
 #
@@ -275,5 +275,6 @@ controls = [
         ),
     ]
 
-for c in controls:
-    c.show()
+if __name__ == '__main__':
+    for c in controls:
+        c.show()
-- 
2.21.3

