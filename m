Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64F8915DA0B
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 15:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387471AbgBNO7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 09:59:32 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48189 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729475AbgBNO7b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 09:59:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581692371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gvpxTHTAPtZtzgXZ+Vsyf3goMgALrnpynweu0cvjJ/w=;
        b=SQbq36dc4m0YIDfdIXSfscxd8Juxz/fhy5nhLEjnW5EQADmbOszQ5djCpzFoQLc5TCLP8l
        vBcWQmj8ikqAcDHG6UXTBlTcNJJLf4zmvH+0aDg4KkzG8bpgYr5g/axjV/KVm6Pov5zVMp
        OuCV2S11DOI4XKCELdL59eDsSAcDDSY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-Z8PjcnaSPayVwNimC8ARFA-1; Fri, 14 Feb 2020 09:59:29 -0500
X-MC-Unique: Z8PjcnaSPayVwNimC8ARFA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25AB3107ACC7;
        Fri, 14 Feb 2020 14:59:28 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C75119E9C;
        Fri, 14 Feb 2020 14:59:26 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, peterx@redhat.com
Subject: [PATCH 01/13] HACK: Ensure __NR_userfaultfd is defined
Date:   Fri, 14 Feb 2020 15:59:08 +0100
Message-Id: <20200214145920.30792-2-drjones@redhat.com>
In-Reply-To: <20200214145920.30792-1-drjones@redhat.com>
References: <20200214145920.30792-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Without this hack kvm/queue kvm selftests don't compile for x86_64.
---
 tools/testing/selftests/kvm/demand_paging_test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/tes=
ting/selftests/kvm/demand_paging_test.c
index df1fc38b4df1..ec8860b70129 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -20,6 +20,10 @@
 #include <linux/bitops.h>
 #include <linux/userfaultfd.h>
=20
+#ifndef __NR_userfaultfd
+#define __NR_userfaultfd 282
+#endif
+
 #include "test_util.h"
 #include "kvm_util.h"
 #include "processor.h"
--=20
2.21.1

