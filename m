Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 634E0100218
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 11:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfKRKIQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 05:08:16 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32485 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfKRKIQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 05:08:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574071695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q9/21UM7sPX+fr8RxiF1Rp1FbeR5FKDFOLwbAWbjJXQ=;
        b=H7GPZgpt7zIeq3fgZikXJhCKOR7n1jQMJzI9qACLe3yW1Fp4INDEaN6SJzvp6k1xK0Vmiw
        BumsF5NwZookO7tTK0e32EBoqgvPXc4R2o7fa09VP0uykkR4/5pnltwhwFojNdeS0bfoTj
        Z8eMFIYl0fECA7v7ZXBzk1gqUDcEkes=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-gT_z_zUdPuSVxMhRuB_pUQ-1; Mon, 18 Nov 2019 05:08:11 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9ECF1034B3A;
        Mon, 18 Nov 2019 10:08:09 +0000 (UTC)
Received: from t460s.redhat.com (unknown [10.36.118.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE5CA75E30;
        Mon, 18 Nov 2019 10:08:05 +0000 (UTC)
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
Subject: [kvm-unit-tests PULL 04/12] s390x: sclp: expose ram_size and max_ram_size
Date:   Mon, 18 Nov 2019 11:07:11 +0100
Message-Id: <20191118100719.7968-5-david@redhat.com>
In-Reply-To: <20191118100719.7968-1-david@redhat.com>
References: <20191118100719.7968-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: gT_z_zUdPuSVxMhRuB_pUQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Expose ram_size and max_ram_size through accessor functions.

We only use get_ram_size in an upcoming patch, but having an accessor
for the other one does not hurt.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <1572023194-14370-4-git-send-email-imbrenda@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 lib/s390x/sclp.c | 10 ++++++++++
 lib/s390x/sclp.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 56fca0c..7798f04 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -167,3 +167,13 @@ void sclp_memory_setup(void)
=20
 =09mem_init(ram_size);
 }
+
+uint64_t get_ram_size(void)
+{
+=09return ram_size;
+}
+
+uint64_t get_max_ram_size(void)
+{
+=09return max_ram_size;
+}
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index f00c3df..6d40fb7 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -272,5 +272,7 @@ void sclp_console_setup(void);
 void sclp_print(const char *str);
 int sclp_service_call(unsigned int command, void *sccb);
 void sclp_memory_setup(void);
+uint64_t get_ram_size(void);
+uint64_t get_max_ram_size(void);
=20
 #endif /* SCLP_H */
--=20
2.21.0

