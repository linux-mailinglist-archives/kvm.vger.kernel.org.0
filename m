Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E995302C9C
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 21:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732261AbhAYUf0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 15:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732295AbhAYUfL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 15:35:11 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB32C061573;
        Mon, 25 Jan 2021 12:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=WiGs1qgslmQVm39ErD8FtEC6YDu9ozQcsFkJHMOI2oc=; b=eZ8aDB5ZjP439EyzjUsxb2Omrs
        pv4125X9udbw90Pa8WcK+X5aWTVUx97W7l0D2xai6lRWw+hg6ECKbzarQnqRk/n/6xr97uDVUvFm1
        pH6Yduz5vyjw2NSWX/jn4b70SgPSavVvFzhvAnoNk/0c+FuLRd0jnnBcdZUhJeF0V2V5FCnDaQcRU
        FDQqcZ9hXIYRNn5DHmTc7NGLq7maKunmcaj2pf6vcxTyYzqzpcl9bw8ZVd/1vxNwjUZ0zfhzVPmMb
        zfXpWVog6L4xZ73AmCYoYMHS6sjvOyzaUhHqeRCyDKlWW/aXd67qofS528Mdxm0YEF0Ortj3eyvNY
        zxNO1Xfw==;
Received: from [2601:1c0:6280:3f0::7650] (helo=merlin.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l48Z7-0003zB-RN; Mon, 25 Jan 2021 20:34:26 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH RESEND] kvm: mmu.h: delete duplicated word
Date:   Mon, 25 Jan 2021 12:34:19 -0800
Message-Id: <20210125203420.26069-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 
