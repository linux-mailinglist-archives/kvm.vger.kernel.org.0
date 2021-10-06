Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DA5424216
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 18:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239305AbhJFQD0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 12:03:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30835 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239308AbhJFQDZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 12:03:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633536093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LEl+i4Q5vQVY6PXzlnIHOyFJNjpzsr4LDFHpJofizVs=;
        b=e9/I5y5E9BELWwPa2VPRiwB3m/+ljZvKGXmljNtTIchWfRUBUS1MiNhV5HI/oHUt/s6mtR
        9BiEex0A/uQ90QwN/Tm5IzdNtVvtHAp92XU9cyV+Pm6neD/fOrIoRdX080Q/P1e3IMpQ7Y
        ZZSry76QrvTF2ARPfRIWR0/3gBn2x1Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-Dnva_suzO-KGrXuU2kNM7w-1; Wed, 06 Oct 2021 12:01:29 -0400
X-MC-Unique: Dnva_suzO-KGrXuU2kNM7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF44018125C1;
        Wed,  6 Oct 2021 16:01:28 +0000 (UTC)
Received: from gondolin.fritz.box (unknown [10.39.193.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 459C960936;
        Wed,  6 Oct 2021 16:01:27 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH 2/2] vfio-ccw: step down as maintainer
Date:   Wed,  6 Oct 2021 18:01:20 +0200
Message-Id: <20211006160120.217636-3-cohuck@redhat.com>
In-Reply-To: <20211006160120.217636-1-cohuck@redhat.com>
References: <20211006160120.217636-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I currently don't have time to act as vfio-ccw maintainer
anymore, but I trust that I leave it in capable hands.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0149e1a3e65e..92db89512678 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16374,7 +16374,6 @@ F:	drivers/s390/crypto/vfio_ap_ops.c
 F:	drivers/s390/crypto/vfio_ap_private.h
 
 S390 VFIO-CCW DRIVER
-M:	Cornelia Huck <cohuck@redhat.com>
 M:	Eric Farman <farman@linux.ibm.com>
 M:	Matthew Rosato <mjrosato@linux.ibm.com>
 R:	Halil Pasic <pasic@linux.ibm.com>
-- 
2.31.1

