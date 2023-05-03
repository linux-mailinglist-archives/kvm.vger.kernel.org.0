Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4635F6F61C2
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 01:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjECXKG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 19:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjECXKF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 19:10:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0726E81;
        Wed,  3 May 2023 16:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=E6JZS3DKCRYlBsGp2X75EmTEQgW3GIdCBADkkYj1ih4=; b=MpOTIstqnDpVe+1e/q/7kwPBTR
        Tl2/1JsfqOQVTbSn54WpmqehTLLVUbwX6qZnbRxSyrELAiUcNN/Nqo1fUJbWWW4GW/PUieG9upl5O
        FkhTBP+cHkuNJIoepBsjZhcpnUsZQIrVskrGjvQNXw7iotoea8UpWHK9s/xK2Ou1AhUiRerbEgrEt
        EwpxFb2T798RG1M39h9Whjp9f6zQa2QasueclxFkLhDCBZl9FadsRePDHFj+3DE1gpJnuCFDzDwPL
        qVZbWxPABCtYRbTqqY9c/tVY3MhhwEF8CsdouKmwTI98GF/FrqwiJpl0k/YTJ0dF/a7hP127QqPd1
        vnDNhYBA==;
Received: from [2601:1c2:980:9ec0::2764] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1puLbn-0064MP-00;
        Wed, 03 May 2023 23:10:03 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH] KVM: MAINTAINERS: note that linux-kvm.org isn't current
Date:   Wed,  3 May 2023 16:10:00 -0700
Message-Id: <20230503231000.14330-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

www.linux-kvm.org is not kept current. It contains antiquated
and historical information. Don't send people to it for current
information on KVM.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -- a/MAINTAINERS b/MAINTAINERS
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11334,7 +11334,7 @@ KERNEL VIRTUAL MACHINE (KVM)
 M:	Paolo Bonzini <pbonzini@redhat.com>
 L:	kvm@vger.kernel.org
 S:	Supported
-W:	http://www.linux-kvm.org
+W:	http://www.linux-kvm.org (antiquated/historical)
 T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
 F:	Documentation/virt/kvm/
 F:	include/asm-generic/kvm*
