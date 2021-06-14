Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D183A5F9C
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 12:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbhFNKEE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 06:04:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45360 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232579AbhFNKEE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 06:04:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623664921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QTk45eTGp6PXfnl/37FOKO1zA5Munn4V9gFgi4ccWlE=;
        b=G3E7+Q1I1lbsVswH+IFZ/doB8zBSmADC5CnJna0UKbSavG50MrGclSk6zJPbNARHxjCeIG
        uoayxhPRzknaePtfukcKmM0UwF9ILgdTkEEw54wnqmCGmYPApFzn+fQGCoKFYVMJ8D/TMg
        oAr/yieOuvf6g3iPhB1AhHhqRTZ+eqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-PFC5SwKlM1W2fcRR_hYyMQ-1; Mon, 14 Jun 2021 06:01:59 -0400
X-MC-Unique: PFC5SwKlM1W2fcRR_hYyMQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF94C100C663
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 10:01:58 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-175.ams2.redhat.com [10.36.113.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C38175D9D5;
        Mon, 14 Jun 2021 10:01:53 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH] README.md: remove duplicate "to adhere"
Date:   Mon, 14 Jun 2021 12:01:51 +0200
Message-Id: <20210614100151.123622-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes: 844669a9631d ("README.md: add guideline for header guards format")
Reported-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 README.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/README.md b/README.md
index 687ff50d0af1..b498aafd1a77 100644
--- a/README.md
+++ b/README.md
@@ -158,7 +158,7 @@ Exceptions:
 
 Header guards:
 
-Please try to adhere to adhere to the following patterns when adding
+Please try to adhere to the following patterns when adding
 "#ifndef <...> #define <...>" header guards:
     ./lib:             _HEADER_H_
     ./lib/<ARCH>:      _ARCH_HEADER_H_
-- 
2.31.1

