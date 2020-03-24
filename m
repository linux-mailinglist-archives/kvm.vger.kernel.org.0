Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43774190D2A
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 13:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgCXMRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 08:17:38 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:60212 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727282AbgCXMRh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 08:17:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585052257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gLBlRqL5cZyxvUDZh1B7Yer4tbeYKgyrUrumo9mfBY0=;
        b=FeSMkoYa/SxWQo3RF7EZwh8SRO299U2prgqxiSDDkS6MWvTo7M9ide690i1JDRxHqkUXOc
        EUKBptL8eTxWovRzDai2SJlK6FR5ZR7i0LQ0MbB3NAbDx1LrL0miLLiNbOOZPQngiNo/gN
        /BoQO+CWzuEVhrGl5VAoG26rugtsa+U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-wgsQVnNUMFCE5CDg2FFvig-1; Tue, 24 Mar 2020 08:17:35 -0400
X-MC-Unique: wgsQVnNUMFCE5CDg2FFvig-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6BE0F107ACC7;
        Tue, 24 Mar 2020 12:17:34 +0000 (UTC)
Received: from localhost (ovpn-113-109.ams2.redhat.com [10.36.113.109])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 56A1F5D9E5;
        Tue, 24 Mar 2020 12:17:31 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH 1/2] s390x: add myself as reviewer
Date:   Tue, 24 Mar 2020 13:17:21 +0100
Message-Id: <20200324121722.9776-2-cohuck@redhat.com>
In-Reply-To: <20200324121722.9776-1-cohuck@redhat.com>
References: <20200324121722.9776-1-cohuck@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 48da1dbdd1ac..471767a355c6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -81,6 +81,7 @@ S390X
 M: Thomas Huth <thuth@redhat.com>
 M: David Hildenbrand <david@redhat.com>
 R: Janosch Frank <frankja@linux.ibm.com>
+R: Cornelia Huck <cohuck@redhat.com>
 L: kvm@vger.kernel.org
 F: s390x/*
 F: lib/s390x/*
--=20
2.21.1

