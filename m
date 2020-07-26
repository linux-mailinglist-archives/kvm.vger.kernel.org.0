Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9CE22DABD
	for <lists+kvm@lfdr.de>; Sun, 26 Jul 2020 02:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgGZASM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Jul 2020 20:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726870AbgGZASM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Jul 2020 20:18:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B9FC08C5C0;
        Sat, 25 Jul 2020 17:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=WiGs1qgslmQVm39ErD8FtEC6YDu9ozQcsFkJHMOI2oc=; b=DQRW84hrFK4kXvxMNHnKyNutab
        EAeTNO5IF3HDyRU/gtwUTgEnXmyYBs0F7ulun+eqn+rvpgVFe3Zye309sQiZaizSvtMjayUrF4wPi
        E32Ppo8mVSMFKfQJ9k0IxSLCJOGckkuQVQepBP+I951ek6K1oCb8DhhrAieXxDdaZt/qCzLDpeRCc
        LwJP0K34aD3h98ZAX6Jpdo/oq2UDgxpSRAEq7DkSvzIEg3qwcE/sqMCVgE6yfPPAzkw+cugpla97h
        qixj+GSy3RCRNunoC5Y7+tM/bCI75nj/L/A0j7V6S4SlyozmTxu6c58wZoLW6ySeOdWWy8+53gu4X
        TJT+ANIA==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jzUMk-0002ON-1A; Sun, 26 Jul 2020 00:18:10 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH] kvm: mmu.h: delete duplicated word
Date:   Sat, 25 Jul 2020 17:18:06 -0700
Message-Id: <20200726001806.19600-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Delete the repeated word "is".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
---
 arch/x86/kvm/mmu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200720.orig/arch/x86/kvm/mmu.h
+++ linux-next-20200720/arch/x86/kvm/mmu.h
@@ -191,7 +191,7 @@ static inline u8 permission_fault(struct
 		* PKRU defines 32 bits, there are 16 domains and 2
 		* attribute bits per domain in pkru.  pte_pkey is the
 		* index of the protection domain, so pte_pkey * 2 is
-		* is the index of the first bit for the domain.
+		* the index of the first bit for the domain.
 		*/
 		pkru_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
 
