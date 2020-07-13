Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A5621D53E
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 13:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbgGMLr3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 07:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727890AbgGMLr3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 07:47:29 -0400
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488BBC061755;
        Mon, 13 Jul 2020 04:47:29 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 82EB3BC0FD;
        Mon, 13 Jul 2020 11:47:26 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] docs: kvm: Replace HTTP links with HTTPS ones
Date:   Mon, 13 Jul 2020 13:47:19 +0200
Message-Id: <20200713114719.33839-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++
X-Spam-Level: *****
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
            If both the HTTP and HTTPS versions
            return 200 OK and serve the same content:
              Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 Continuing my work started at 93431e0607e5.
 See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
 (Actually letting a shell for loop submit all this stuff for me.)

 If there are any URLs to be removed completely or at least not just HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also: https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See: https://lkml.org/lkml/2020/6/26/837

 If you apply the patch, please let me know.

 Sorry again to all maintainers who complained about subject lines.
 Now I realized that you want an actually perfect prefixes,
 not just subsystem ones.
 I tried my best...
 And yes, *I could* (at least half-)automate it.
 Impossible is nothing! :)


 Documentation/virt/kvm/amd-memory-encryption.rst | 6 +++---
 Documentation/virt/kvm/mmu.rst                   | 2 +-
 Documentation/virt/kvm/nested-vmx.rst            | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 57c01f531e61..2d44388438cc 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -270,6 +270,6 @@ References
 See [white-paper]_, [api-spec]_, [amd-apm]_ and [kvm-forum]_ for more info.
 
 .. [white-paper] http://amd-dev.wpengine.netdna-cdn.com/wordpress/media/2013/12/AMD_Memory_Encryption_Whitepaper_v7-Public.pdf
-.. [api-spec] http://support.amd.com/TechDocs/55766_SEV-KM_API_Specification.pdf
-.. [amd-apm] http://support.amd.com/TechDocs/24593.pdf (section 15.34)
-.. [kvm-forum]  http://www.linux-kvm.org/images/7/74/02x08A-Thomas_Lendacky-AMDs_Virtualizatoin_Memory_Encryption_Technology.pdf
+.. [api-spec] https://support.amd.com/TechDocs/55766_SEV-KM_API_Specification.pdf
+.. [amd-apm] https://support.amd.com/TechDocs/24593.pdf (section 15.34)
+.. [kvm-forum]  https://www.linux-kvm.org/images/7/74/02x08A-Thomas_Lendacky-AMDs_Virtualizatoin_Memory_Encryption_Technology.pdf
diff --git a/Documentation/virt/kvm/mmu.rst b/Documentation/virt/kvm/mmu.rst
index 46126ecc70f7..1c030dbac7c4 100644
--- a/Documentation/virt/kvm/mmu.rst
+++ b/Documentation/virt/kvm/mmu.rst
@@ -480,4 +480,4 @@ Further reading
 ===============
 
 - NPT presentation from KVM Forum 2008
-  http://www.linux-kvm.org/images/c/c8/KvmForum2008%24kdf2008_21.pdf
+  https://www.linux-kvm.org/images/c/c8/KvmForum2008%24kdf2008_21.pdf
diff --git a/Documentation/virt/kvm/nested-vmx.rst b/Documentation/virt/kvm/nested-vmx.rst
index 89851cbb7df9..6ab4e35cee23 100644
--- a/Documentation/virt/kvm/nested-vmx.rst
+++ b/Documentation/virt/kvm/nested-vmx.rst
@@ -22,7 +22,7 @@ its implementation and its performance characteristics, in the OSDI 2010 paper
 "The Turtles Project: Design and Implementation of Nested Virtualization",
 available at:
 
-	http://www.usenix.org/events/osdi10/tech/full_papers/Ben-Yehuda.pdf
+	https://www.usenix.org/events/osdi10/tech/full_papers/Ben-Yehuda.pdf
 
 
 Terminology
-- 
2.27.0

