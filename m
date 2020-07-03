Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98F32140D5
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 23:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgGCV3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 17:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgGCV3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jul 2020 17:29:16 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9071BC061794;
        Fri,  3 Jul 2020 14:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=hLwDdOODJNIyfxleejAgGycdJj0RksgBnWOZNon5m/A=; b=iY3E+R1QzCRyBz9MN3RAaHLWtP
        STJD+uqYF18028figPjwKWX13RtCe6UXaNaBFqrWMsJV/wTFvJJwnr5GwKBoxHEpy91xYYaI1G/1y
        OxAtaSnorTynqPx/dBGKjUf4osJMP8hHpqyPqI7iSWhvRBvQNKlLUW4g16SHdBkTMWJhIwKglyWT8
        7hqMUX5lc0WsaKwEuzC+xHw1HpPjm0Du5581+OaO25hIFozRAZ2Ouc+LyT+SviloJlWyLDEpRu4N4
        4mX+8F7KZMqW6xGIGgNYgK1En/hJBIz6nvR9b+F/egycfZDx2M/9LF311olP/IhYe6O3tY4p17Y7n
        AVU5eiuw==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jrTFC-0006KB-7A; Fri, 03 Jul 2020 21:29:14 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 2/2] Documentation: virt: kvm/s390-pv: drop doubled words
Date:   Fri,  3 Jul 2020 14:29:05 -0700
Message-Id: <20200703212906.30655-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703212906.30655-1-rdunlap@infradead.org>
References: <20200703212906.30655-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the doubled word "the".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
---
 Documentation/virt/kvm/s390-pv.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200701.orig/Documentation/virt/kvm/s390-pv.rst
+++ linux-next-20200701/Documentation/virt/kvm/s390-pv.rst
@@ -78,7 +78,7 @@ Register Save Area.
 Only GR values needed to emulate an instruction will be copied into this
 save area and the real register numbers will be hidden.
 
-The Interception Parameters state description field still contains the
+The Interception Parameters state description field still contains
 the bytes of the instruction text, but with pre-set register values
 instead of the actual ones. I.e. each instruction always uses the same
 instruction text, in order not to leak guest instruction text.
