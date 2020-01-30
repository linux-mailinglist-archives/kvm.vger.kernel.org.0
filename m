Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C280914DB4D
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 14:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgA3NLc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 08:11:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26804 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726980AbgA3NLc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 08:11:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580389891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/yBCkgn6MjP+rp3S4FWnEQM+jVlF/8K3ad/cp5egTrw=;
        b=KtLZKfghbxeu9yEf2W8EW1qp+4KxsYF66/ALAbGYF+56zeOqFZ/KlkyJexdby5ma/5wn6+
        qR7xBGjs38+csg+/qgL5cSp5XqW1hvao5eCrtWT4BxExwYbrF77E1F5oUV07kJ1VEHJqoY
        Z3RR/1M4NxJ4CIFvzzUBiU7bt7kGf2A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-4kMBjVA2O5CHeH1LEnes0w-1; Thu, 30 Jan 2020 08:11:28 -0500
X-MC-Unique: 4kMBjVA2O5CHeH1LEnes0w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65692800D4E;
        Thu, 30 Jan 2020 13:11:27 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-117-219.ams2.redhat.com [10.36.117.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41E9677927;
        Thu, 30 Jan 2020 13:11:25 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, david@redhat.com,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [kvm-unit-tests PULL 1/6] s390x: export sclp_setup_int
Date:   Thu, 30 Jan 2020 14:11:11 +0100
Message-Id: <20200130131116.12386-2-david@redhat.com>
In-Reply-To: <20200130131116.12386-1-david@redhat.com>
References: <20200130131116.12386-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Export sclp_setup_int() so that it can be used in tests.

Needed for an upcoming unit test.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20200120184256.188698-2-imbrenda@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 lib/s390x/sclp.c | 2 +-
 lib/s390x/sclp.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 7798f04..123b639 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -45,7 +45,7 @@ static void mem_init(phys_addr_t mem_end)
 	page_alloc_ops_enable();
 }
=20
-static void sclp_setup_int(void)
+void sclp_setup_int(void)
 {
 	uint64_t mask;
=20
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 6d40fb7..675f07e 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -265,6 +265,7 @@ typedef struct ReadEventData {
 } __attribute__((packed)) ReadEventData;
=20
 extern char _sccb[];
+void sclp_setup_int(void);
 void sclp_handle_ext(void);
 void sclp_wait_busy(void);
 void sclp_mark_busy(void);
--=20
2.24.1

