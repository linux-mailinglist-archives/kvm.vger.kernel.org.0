Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56FF2A6F90
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 22:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731941AbgKDVYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 16:24:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55921 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731641AbgKDVYJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 16:24:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604525048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BgfqlHiVzPQV0alMIDRscA9ajfbeWecA6MPXXpKz1Ro=;
        b=JQZlGmJqGkoTfVRlSf5alKS0T/IJPz+YXXgL0XMTPL6yRZRlqry38B6mh620v9LJ3MPOkq
        P6N3LlWvK9lkxNGNUiQxBIaWwBLJDcS2IV42AeXFyM9ggxFkq0hVJpm214aEWDmY/I8HXC
        s0sZyBE8CKzwn2YD52Kc8Y8cR7Og8Xo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-IVVCkqhGP-O1OinQi1LsGg-1; Wed, 04 Nov 2020 16:24:07 -0500
X-MC-Unique: IVVCkqhGP-O1OinQi1LsGg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD645100F775;
        Wed,  4 Nov 2020 21:24:05 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D577E5DA6B;
        Wed,  4 Nov 2020 21:24:03 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH 01/11] KVM: selftests: Add x86_64/tsc_msrs_test to .gitignore
Date:   Wed,  4 Nov 2020 22:23:47 +0100
Message-Id: <20201104212357.171559-2-drjones@redhat.com>
In-Reply-To: <20201104212357.171559-1-drjones@redhat.com>
References: <20201104212357.171559-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index d2c2d6205008..06c71dc2f7e2 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -15,6 +15,7 @@
 /x86_64/vmx_preemption_timer_test
 /x86_64/svm_vmcall_test
 /x86_64/sync_regs_test
+/x86_64/tsc_msrs_test
 /x86_64/vmx_apic_access_test
 /x86_64/vmx_close_while_nested_test
 /x86_64/vmx_dirty_log_test
-- 
2.26.2

