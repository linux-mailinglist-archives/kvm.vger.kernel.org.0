Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97321424215
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 18:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239306AbhJFQDY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 12:03:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35199 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239305AbhJFQDX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 12:03:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633536091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S/uPg/nCAXV7q6/DjRq+99N39L6tnAPjQjp4bBi868M=;
        b=FZAgHluiztKtVSb2CS7BDymMAAktTj2aMFs7TFV/Ku2eme2aCs84vfzMe8rev4RJZZHD52
        k2OHOIEMMdRvyxxcCwYXmNqgoD/fAKYHtTN4MAk4X19439SldjRAmDiE1Mchi+5uQluNN6
        5vEOXWNwCjnARDP5XVOlUZt2CGkz/iA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-F4JJ6sO-MxGfWvLT5sc2OQ-1; Wed, 06 Oct 2021 12:01:28 -0400
X-MC-Unique: F4JJ6sO-MxGfWvLT5sc2OQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EDA7718125C0;
        Wed,  6 Oct 2021 16:01:26 +0000 (UTC)
Received: from gondolin.fritz.box (unknown [10.39.193.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 789116091B;
        Wed,  6 Oct 2021 16:01:25 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH 1/2] KVM: s390: remove myself as reviewer
Date:   Wed,  6 Oct 2021 18:01:19 +0200
Message-Id: <20211006160120.217636-2-cohuck@redhat.com>
In-Reply-To: <20211006160120.217636-1-cohuck@redhat.com>
References: <20211006160120.217636-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I currently don't have time anymore to review KVM/s390
code.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index abdcbcfef73d..0149e1a3e65e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10275,7 +10275,6 @@ KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
 M:	Christian Borntraeger <borntraeger@de.ibm.com>
 M:	Janosch Frank <frankja@linux.ibm.com>
 R:	David Hildenbrand <david@redhat.com>
-R:	Cornelia Huck <cohuck@redhat.com>
 R:	Claudio Imbrenda <imbrenda@linux.ibm.com>
 L:	kvm@vger.kernel.org
 S:	Supported
-- 
2.31.1

