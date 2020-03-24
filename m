Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A233F190D2C
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 13:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbgCXMRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 08:17:40 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:43959 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727223AbgCXMRk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 08:17:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585052259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gM/qBRZ1vPXzzi29k+79zCqskUfQZNPMdzVA5EVMebU=;
        b=Tq3iQjrmr9LcFcF5P3+a8mF52AOjtRkn988jCnNrHeCDUiAsySMHsp2t41TbWdbxYTQlsf
        o8bRJFEjKTgVM1E8DLV/3hKdgCUnl6jc8TjzmS09SJ02Y30i2SiQ5/oSvnuw+zYLxWEkin
        Q5rjZI4fk7oydzlFBh+IKgZgTfTwPDc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-Epq7U598MeGyharIV1g9Rw-1; Tue, 24 Mar 2020 08:17:37 -0400
X-MC-Unique: Epq7U598MeGyharIV1g9Rw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E5CBDBA3;
        Tue, 24 Mar 2020 12:17:36 +0000 (UTC)
Received: from localhost (ovpn-113-109.ams2.redhat.com [10.36.113.109])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DD435D9E5;
        Tue, 24 Mar 2020 12:17:36 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH 2/2] s390x: add linux-s390 list
Date:   Tue, 24 Mar 2020 13:17:22 +0100
Message-Id: <20200324121722.9776-3-cohuck@redhat.com>
In-Reply-To: <20200324121722.9776-1-cohuck@redhat.com>
References: <20200324121722.9776-1-cohuck@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It makes sense to cc: patches there as well.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 471767a355c6..8912533e441d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -83,6 +83,7 @@ M: David Hildenbrand <david@redhat.com>
 R: Janosch Frank <frankja@linux.ibm.com>
 R: Cornelia Huck <cohuck@redhat.com>
 L: kvm@vger.kernel.org
+L: linux-s390@vger.kernel.org
 F: s390x/*
 F: lib/s390x/*
=20
--=20
2.21.1

