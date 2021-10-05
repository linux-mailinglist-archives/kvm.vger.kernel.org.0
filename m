Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF46422CC4
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 17:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235067AbhJEPng (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 11:43:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52560 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230059AbhJEPnf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 11:43:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633448504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=F1YnQ45uzsCGa+tmqxZH6Vnvkbz/oLMOdniTcirbOJg=;
        b=S0QlXBH1BD3t/1wbScjacrVYqNL2p65wUn852w5FY5I3mIG6CdEfeUP1OxrlASDJlq/yrm
        OFwpT1Hteqo6/yY0r9CQppSPzzgc2g+xXjC00LWhUpq9Igri/z8Q5hg4OW32HJZexPF1zM
        lMheQO/zgg97WMnKXJO4Fjovi+yJtwI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-Y_Lxx2xUMhKlkSuQhW3zrQ-1; Tue, 05 Oct 2021 11:41:43 -0400
X-MC-Unique: Y_Lxx2xUMhKlkSuQhW3zrQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8414100C609;
        Tue,  5 Oct 2021 15:41:39 +0000 (UTC)
Received: from gondolin.fritz.box (unknown [10.39.192.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8160C197FC;
        Tue,  5 Oct 2021 15:41:38 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH] s390x: remove myself as reviewer
Date:   Tue,  5 Oct 2021 17:41:14 +0200
Message-Id: <20211005154114.173511-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I don't really have time anymore to spend on s390x reviews
here, so don't raise false expectations. There are enough
capable people listed already :)

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4fc01a5d54a1..590c0a4fd922 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -87,7 +87,6 @@ S390X
 M: Thomas Huth <thuth@redhat.com>
 M: Janosch Frank <frankja@linux.ibm.com>
 S: Supported
-R: Cornelia Huck <cohuck@redhat.com>
 R: Claudio Imbrenda <imbrenda@linux.ibm.com>
 R: David Hildenbrand <david@redhat.com>
 L: kvm@vger.kernel.org
-- 
2.31.1

