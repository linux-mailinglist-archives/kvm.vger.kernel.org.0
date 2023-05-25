Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F64710FA5
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 17:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241819AbjEYPcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 11:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241804AbjEYPcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 11:32:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B1E1A6;
        Thu, 25 May 2023 08:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=PWMoR1em10oPsoH4458n8fWq74LAmsb/QxKA6lhb7PA=; b=YbnOhdmgTXfraqzngMcZxf/+ci
        1XN/bavJ1TZ8rgHzbu+1t7yIjc8Q9R95Swk+B+3pDM9+JxucGfbT2L9kTKr5jCO1S7UhuD8tnjz9m
        fRQrh7meZdzxpJkAxvMVxo0lX/PkkV7Pd1ofmi5yQbKxBUEBnSsCqJ4r/Xe2NXFyB5YVeJJIWf4nw
        +D7TWG0hRBxI+Iw9Iq6qgCNXzQOX7EWrkipBDgdpVRQ4yyGrd6wpyPuJRUD1lzMtcFqsHho3GLLsG
        1UZfk3EU5y9A7pnNl0GdsQGCJb3njZ6Y8a+wpKDtBZnK72vFV5OsOVM02+JdDK2enN7CuBLUBkzni
        O32CJr/g==;
Received: from [2601:1c2:980:9ec0::2764] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q2Cwf-00GyaB-0v;
        Thu, 25 May 2023 15:32:05 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2] KVM: MAINTAINERS: note that linux-kvm.org isn't current
Date:   Thu, 25 May 2023 08:32:04 -0700
Message-Id: <20230525153204.27960-1-rdunlap@infradead.org>
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
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
---
v2: change wording; drop one bouncing email address (Ramkumar)

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -- a/MAINTAINERS b/MAINTAINERS
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11359,7 +11359,7 @@ KERNEL VIRTUAL MACHINE (KVM)
 M:	Paolo Bonzini <pbonzini@redhat.com>
 L:	kvm@vger.kernel.org
 S:	Supported
-W:	http://www.linux-kvm.org
+W:	http://www.linux-kvm.org (historical/not up-to-date)
 T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
 F:	Documentation/virt/kvm/
 F:	include/asm-generic/kvm*
