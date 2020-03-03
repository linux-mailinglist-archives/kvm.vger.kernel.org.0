Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D27C81777F5
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 14:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbgCCN73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 08:59:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728037AbgCCN73 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 08:59:29 -0500
Received: from mail.kernel.org (ip-109-40-2-133.web.vodafone.de [109.40.2.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA2692166E;
        Tue,  3 Mar 2020 13:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583243969;
        bh=s0m7dutvhHUxy0GagWG09NA7+534PrANWICiABloyXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VHd1+Rd8iKbiniMJBzd3ZSrKtuo3VTCThxt/tGg4YtrBn8kgYQimTjGz6/kyZKI04
         AovqYF4jNVqQyJIz8L6QNA6lPBPbX2IB6xEhMwhBJeGyWGuGvCf90jQKG1cpWF+bOH
         +1h5fL0iOcwtUR60JNM7RD+zJ4h7iN2bp0GF6LCI=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1j9850-001Ye9-MH; Tue, 03 Mar 2020 14:59:26 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v3 18/18] docs: kvm: get read of devices/README
Date:   Tue,  3 Mar 2020 14:59:25 +0100
Message-Id: <6e9c4aaf704cdc7b4e517122fb87cbe05f0ffd23.1583243827.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1583243826.git.mchehab+huawei@kernel.org>
References: <cover.1583243826.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the information there inside devices/index.rst

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/devices/README    | 1 -
 Documentation/virt/kvm/devices/index.rst | 3 +++
 2 files changed, 3 insertions(+), 1 deletion(-)
 delete mode 100644 Documentation/virt/kvm/devices/README

diff --git a/Documentation/virt/kvm/devices/README b/Documentation/virt/kvm/devices/README
deleted file mode 100644
index 34a69834124a..000000000000
--- a/Documentation/virt/kvm/devices/README
+++ /dev/null
@@ -1 +0,0 @@
-This directory contains specific device bindings for KVM_CAP_DEVICE_CTRL.
diff --git a/Documentation/virt/kvm/devices/index.rst b/Documentation/virt/kvm/devices/index.rst
index 192cda7405c8..cbadafc0e36e 100644
--- a/Documentation/virt/kvm/devices/index.rst
+++ b/Documentation/virt/kvm/devices/index.rst
@@ -4,6 +4,9 @@
 Devices
 =======
 
+The following documentation contains specific device bindings
+for KVM_CAP_DEVICE_CTRL.
+
 .. toctree::
    :maxdepth: 2
 
-- 
2.24.1

