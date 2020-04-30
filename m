Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF651C0010
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 17:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgD3PYo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 11:24:44 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58244 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726805AbgD3PYn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 11:24:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588260282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ucYm1NuI/VXAeGAVtOlvWxH+ORjiRCmatFstqqQZ7KU=;
        b=Na/IVXj2JqQwfuWYkIcUNM7UasjaehymPbTF80Lm4poCQ+3bDN4cqGq5NbRFwvG8S9+5TZ
        f+sDG/ciiVYNYaX0PTFIPx7QYZzqsanOA50iU7nezXSDeFwsmnk2zwth0APcAfP08uzl20
        zPig1PWVLL+JT60isiiHkWpbd7RNwfg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-eNo0tr8iPluIq8yBEgmDrg-1; Thu, 30 Apr 2020 11:24:40 -0400
X-MC-Unique: eNo0tr8iPluIq8yBEgmDrg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74F4B462;
        Thu, 30 Apr 2020 15:24:39 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA0D15EDE3;
        Thu, 30 Apr 2020 15:24:37 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 02/17] MAINTAINERS: s390x: add myself as reviewer
Date:   Thu, 30 Apr 2020 17:24:15 +0200
Message-Id: <20200430152430.40349-3-david@redhat.com>
In-Reply-To: <20200430152430.40349-1-david@redhat.com>
References: <20200430152430.40349-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Cornelia Huck <cohuck@redhat.com>

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20200324121722.9776-2-cohuck@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 082be95..4642909 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -81,6 +81,7 @@ S390X
 M: Thomas Huth <thuth@redhat.com>
 M: David Hildenbrand <david@redhat.com>
 M: Janosch Frank <frankja@linux.ibm.com>
+R: Cornelia Huck <cohuck@redhat.com>
 L: kvm@vger.kernel.org
 F: s390x/*
 F: lib/s390x/*
--=20
2.25.3

