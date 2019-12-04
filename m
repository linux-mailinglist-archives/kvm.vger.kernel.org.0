Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1EFA112D7F
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 15:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbfLDOdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 09:33:40 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39801 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727887AbfLDOdj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 09:33:39 -0500
Received: by mail-wm1-f65.google.com with SMTP id s14so8161421wmh.4;
        Wed, 04 Dec 2019 06:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lzBlgZY8Eh46qsnlMJQl2UIjKvxdbeDw64m/NdYI+9g=;
        b=OEKH0QMwb4VBZufUS19qcCqQT5bhHUWA3JZf660ysP2uXnElhv/3IpQvE9YdJpYr6M
         iMoFvO8lSZA33K8kjy0/fcgFD8boDWBcw0wyH0eyuAkhvO7BwNsMq9K+LJ6JlgOTRnku
         92JvdAh6PeAr6I8eMD6keN45wDR9f92VnluEZk2Lm5zhcrtRzXa54HNIjZMS1t5vwgQc
         uXDRyoy9BaUI0raUSF1ySVcg6q6Hu0DNt5Jm0c2P3m1as2cTf9s94/f3JvGlow0iUuyK
         iGb0a0bUj+CeV+TVvBCsYHb8CvvQqQ0/lswNtBH8pmajFifqCw5Y0vGznpK4AftAl9OA
         h1pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=lzBlgZY8Eh46qsnlMJQl2UIjKvxdbeDw64m/NdYI+9g=;
        b=DVqKf2ERxAGhZjWPz3VZQMXBEN90MNs9z0jLYRsMcKePmF6lknH/4idy0AidIbpsBT
         StI31ah1PaN9ceDv9Rx36YXMF+W7TzndI44OIlehreXN9kDaQu5XN58LWs+IFpYvsjiV
         /iDTruujaiZoHu+BAVd7/ojyU2T/wJ+69vE+AmOQo4miesx0ZW6jXilgr2nsIw3kZhpO
         KEZBdQBRIOo8X1UTJq4cBssjlweuKef+f8lSz4EgMvz9n/piER4dJ3cLJSrnVRxSFytu
         X7wm2+V0JE7GMUdn7P50+z5Ds2b9W7V+VXnkJ/6u47EEWcZq1goIr61R9An4PoRXHl/j
         BPRg==
X-Gm-Message-State: APjAAAUxEdAPqyXIjyp1h9W34cMzuLKvWMfr73qtvCPdoMoS/oaIQcYZ
        wNsVjzB8m0ldTiIj1pqMooNgJtom
X-Google-Smtp-Source: APXvYqwi8xQUPMu8oCE9IIOZwcO4pLfcCFfRmNRvfKsHgTLAGmnkldXlwqiIEdVpO3y2IuAQLrbz/Q==
X-Received: by 2002:a1c:a70e:: with SMTP id q14mr15775757wme.142.1575470017470;
        Wed, 04 Dec 2019 06:33:37 -0800 (PST)
Received: from donizetti.redhat.com ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id m3sm8278047wrs.53.2019.12.04.06.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 06:33:36 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] MAINTAINERS: remove Radim from KVM maintainers
Date:   Wed,  4 Dec 2019 15:33:35 +0100
Message-Id: <20191204143335.14168-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Radim's kernel.org email is bouncing, which I take as a signal that
he is not really able to deal with KVM at this time.  Make MAINTAINERS
match the effective value of KVM's bus factor.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fc36fe5e9873..d3a6282d69f2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9023,7 +9023,6 @@ F:	include/linux/umh.h
 
 KERNEL VIRTUAL MACHINE (KVM)
 M:	Paolo Bonzini <pbonzini@redhat.com>
-M:	Radim Krčmář <rkrcmar@redhat.com>
 L:	kvm@vger.kernel.org
 W:	http://www.linux-kvm.org
 T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
@@ -9095,7 +9094,6 @@ F:	tools/testing/selftests/kvm/*/s390x/
 
 KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)
 M:	Paolo Bonzini <pbonzini@redhat.com>
-M:	Radim Krčmář <rkrcmar@redhat.com>
 R:	Sean Christopherson <sean.j.christopherson@intel.com>
 R:	Vitaly Kuznetsov <vkuznets@redhat.com>
 R:	Wanpeng Li <wanpengli@tencent.com>
-- 
2.21.0

