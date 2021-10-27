Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D5243C2C6
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 08:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238469AbhJ0GTS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 02:19:18 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:50319 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbhJ0GTS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Oct 2021 02:19:18 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HfJPH59GYz4xbC;
        Wed, 27 Oct 2021 17:16:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1635315411;
        bh=mwm4J8jrzKugb5lA+yxnuCYG70ULHBCpxrPxQS0JCHM=;
        h=From:To:Cc:Subject:Date:From;
        b=YF9f95hwNKpwFqoyV0xqLfnItvZdM5KkMVTwB9YLeKMka7WUaHUTGZQ4wfNO2vBQO
         EVcgXIvSIu+E8YhNR1v8Ql1CgD+srnAfamNkh+PNVQzvRTtk5rnnNuCqHHxsM58zJH
         zhh+LbFQy/6yEJT9qvi7vAD6/tel0RvOLU1P3tQ2/U8bIpnq86I3+HADuaGv1T+YNK
         6aVxIFZswJhxcukszR6hOvch51kO+qxzUsCKh1Sv3KYC2JXku7dlxn4W7S5wqAZ1tT
         5RQN66g/AgtIM+bHu0WNifKmgKbXgcWCUnj1cEvpwMbUo05r9zpz8tSOuY6+IKnEv8
         vBicmdMMv/a9w==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     <linuxppc-dev@lists.ozlabs.org>, <paulus@samba.org>
Cc:     <npiggin@gmail.com>, <kvm-ppc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>
Subject: [PATCH] MAINTAINERS: Update powerpc KVM entry
Date:   Wed, 27 Oct 2021 17:16:46 +1100
Message-Id: <20211027061646.540708-1-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paul is no longer handling patches for kvmppc.

Instead we'll treat them as regular powerpc patches, taking them via the
powerpc tree, using the topic/ppc-kvm branch when necessary.

Also drop the web reference, it doesn't have any information
specifically relevant to powerpc KVM.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 MAINTAINERS | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ca6d6fde85cf..fbfd3345c40d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10260,11 +10260,8 @@ F:	arch/mips/include/uapi/asm/kvm*
 F:	arch/mips/kvm/
 
 KERNEL VIRTUAL MACHINE FOR POWERPC (KVM/powerpc)
-M:	Paul Mackerras <paulus@ozlabs.org>
-L:	kvm-ppc@vger.kernel.org
-S:	Supported
-W:	http://www.linux-kvm.org/
-T:	git git://github.com/agraf/linux-2.6.git
+L:	linuxppc-dev@lists.ozlabs.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git topic/ppc-kvm
 F:	arch/powerpc/include/asm/kvm*
 F:	arch/powerpc/include/uapi/asm/kvm*
 F:	arch/powerpc/kernel/kvm*
-- 
2.31.1

