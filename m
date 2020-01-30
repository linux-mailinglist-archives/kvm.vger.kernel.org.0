Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A54B14DB50
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 14:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgA3NLk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 08:11:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26704 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727268AbgA3NLk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 08:11:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580389898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wFef1Z8pe/3QrGP9GABVxJ+r/1++7M4pEyg9A1p4qt8=;
        b=S2MtYznR805LSbx7PLX5WSWOY54YY+Bjpv+rL8ccVYRoVLYaVbMWQEw28pZIcwvQqN5gpg
        JmeWYlTBue+18Nf63pt4hPRMQftgyEahuP9Z52/KdI6l50tsFpLfw85LTsl7Hq7AiPaLb6
        HEZypi0UB/IdMZO6H5PdSu9kTJ8UYtM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-uonWhtG5PJCGNXJDqL0UNQ-1; Thu, 30 Jan 2020 08:11:36 -0500
X-MC-Unique: uonWhtG5PJCGNXJDqL0UNQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDABE477;
        Thu, 30 Jan 2020 13:11:35 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-117-219.ams2.redhat.com [10.36.117.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B17B077947;
        Thu, 30 Jan 2020 13:11:32 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, david@redhat.com,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [kvm-unit-tests PULL 3/6] s390x: lib: fix stfl wrapper asm
Date:   Thu, 30 Jan 2020 14:11:13 +0100
Message-Id: <20200130131116.12386-4-david@redhat.com>
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

the stfl wrapper in lib/s390x/asm/facility.h was lacking the "memory"
clobber in the inline asm.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-Id: <20200120184256.188698-4-imbrenda@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 lib/s390x/asm/facility.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/s390x/asm/facility.h b/lib/s390x/asm/facility.h
index 5103dd4..e34dc2c 100644
--- a/lib/s390x/asm/facility.h
+++ b/lib/s390x/asm/facility.h
@@ -24,7 +24,7 @@ static inline bool test_facility(int nr)
=20
 static inline void stfl(void)
 {
-	asm volatile("	stfl	0(0)\n");
+	asm volatile("	stfl	0(0)\n" : : : "memory");
 }
=20
 static inline void stfle(uint8_t *fac, unsigned int len)
--=20
2.24.1

