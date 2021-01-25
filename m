Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CC0302C9E
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 21:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732319AbhAYUfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 15:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732312AbhAYUfZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 15:35:25 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1C7C06174A;
        Mon, 25 Jan 2021 12:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=VitMP7uQjz9q5/byuL/XQS+Y0BC50vmbZT4y0BkkwD4=; b=pfinHIg0p/BZA0xPXP07v1YLs7
        ZCWeUta2AxCC7QHY9GApahX9cBD02CDPsSGyuSkxV5NiCqUXGtgaWGPQeE9Yxg5DStxQv0YxybAvf
        MJfr12bw+/V2/mxkSHRjlmpezsjabfL5qcQKLeILZsxByhVnMKLMf6SF/Y4C4HPT3v8DgTXNAQOVe
        K+tbWjF8YXz0Afv0hsqxDV0dS20nCGt/CsSNaK+jQAPXAzC3u6IJQAUwn1K5VGx+VLryqzaUECAkB
        JBREAdjpTVet1/28EU0y1Gx1Nh6EbfN5R9LIXIP1dfHmA0ssGzux1hXySREI7s5BqjV7WADZxq6oB
        9KAzyTZA==;
Received: from [2601:1c0:6280:3f0::7650] (helo=merlin.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l48ZO-00040L-4p; Mon, 25 Jan 2021 20:34:42 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH RESEND] kvm: paging_tmpl.h: delete duplicated word
Date:   Mon, 25 Jan 2021 12:34:36 -0800
Message-Id: <20210125203436.26149-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Delete the repeated word "to".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
---
 arch/x86/kvm/mmu/paging_tmpl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200720.orig/arch/x86/kvm/mmu/paging_tmpl.h
+++ linux-next-20200720/arch/x86/kvm/mmu/paging_tmpl.h
@@ -478,7 +478,7 @@ error:
 
 #if PTTYPE == PTTYPE_EPT
 	/*
-	 * Use PFERR_RSVD_MASK in error_code to to tell if EPT
+	 * Use PFERR_RSVD_MASK in error_code to tell if EPT
 	 * misconfiguration requires to be injected. The detection is
 	 * done by is_rsvd_bits_set() above.
 	 *
