Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23462100215
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 11:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKRKIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 05:08:09 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27553 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726646AbfKRKIJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Nov 2019 05:08:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574071688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RYH4thB6j6aBghyZyhHkBFN46zj5pZJ7K3MvGDSM+uo=;
        b=QrWGW2NgnLRwHa7cI/5MffQyr30I34uJF/viN2tvtnS3xUGvPLuAMPOYs2Cuz5+c6W9b4D
        axfKmKlEf+wBZf5uQYvbHyBUndK1LncPB7WI8kxuIj0CiXqM2c3uw+nEoSr2zDzPZ0iGg5
        RzCZUlTI8+Nkci3qDfPVkan9DCUUTyE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-AyC8rkvUPXKiT34g1IZ_sQ-1; Mon, 18 Nov 2019 05:08:06 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 830851802CE0;
        Mon, 18 Nov 2019 10:08:05 +0000 (UTC)
Received: from t460s.redhat.com (unknown [10.36.118.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C69075E30;
        Mon, 18 Nov 2019 10:08:01 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 03/12] s390x: improve error reporting for interrupts
Date:   Mon, 18 Nov 2019 11:07:10 +0100
Message-Id: <20191118100719.7968-4-david@redhat.com>
In-Reply-To: <20191118100719.7968-1-david@redhat.com>
References: <20191118100719.7968-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: AyC8rkvUPXKiT34g1IZ_sQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Improve error reporting for unexpected external interrupts to also
print the received external interrupt code.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Message-Id: <1572023194-14370-3-git-send-email-imbrenda@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 lib/s390x/interrupt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 5cade23..1636207 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -118,8 +118,8 @@ void handle_ext_int(void)
 {
 =09if (!ext_int_expected &&
 =09    lc->ext_int_code !=3D EXT_IRQ_SERVICE_SIG) {
-=09=09report_abort("Unexpected external call interrupt: at %#lx",
-=09=09=09     lc->ext_old_psw.addr);
+=09=09report_abort("Unexpected external call interrupt (code %#x): at %#lx=
",
+=09=09=09     lc->ext_int_code, lc->ext_old_psw.addr);
 =09=09return;
 =09}
=20
--=20
2.21.0

