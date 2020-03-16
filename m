Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A69371871CC
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 19:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732252AbgCPSBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 14:01:03 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:22159 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730437AbgCPSBD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 14:01:03 -0400
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Mar 2020 14:01:02 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584381662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ViKxMbqsfCIjJmn/ueBPsXB6IQB265H3nN3VLpBkljw=;
        b=PCKFXvnyvj9mTgKcrNv2svM8CFyOjmmzCBfbqIhd8NNetl2/ToEbpKMaY8486doUwaJUo/
        z9wKaqaoFUmtDLdn0rz4vcNxp6gOgSx76zOjHt9l86rSfFqjUM0k8/7n3h6oKh0f24dli2
        r2ejaUeWYbHnVSDIvLxQRRgl4+QRzbk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-ZCxCI5JyPqKtJ6_kXspjgA-1; Mon, 16 Mar 2020 13:52:54 -0400
X-MC-Unique: ZCxCI5JyPqKtJ6_kXspjgA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF594925064
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 17:37:13 +0000 (UTC)
Received: from kamzik.brq.redhat.com (ovpn-204-240.brq.redhat.com [10.40.204.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C44837E300;
        Mon, 16 Mar 2020 17:37:12 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH v2 1/2] fixup! KVM: selftests: Introduce steal-time test
Date:   Mon, 16 Mar 2020 18:37:02 +0100
Message-Id: <20200316173703.12785-2-drjones@redhat.com>
In-Reply-To: <20200316173703.12785-1-drjones@redhat.com>
References: <20200316173703.12785-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change the pr_info's to printf's as they're already guarded by verbose,
so shouldn't be dependent on QUIET. Also remove a pointless TEST_ASSERT.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/steal_time.c | 37 +++++++++++-------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/sel=
ftests/kvm/steal_time.c
index f976ac5e896a..21990d653099 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -91,18 +91,18 @@ static void steal_time_dump(struct kvm_vm *vm, uint32=
_t vcpuid)
 	struct kvm_steal_time *st =3D addr_gva2hva(vm, (ulong)st_gva[vcpuid]);
 	int i;
=20
-	pr_info("VCPU%d:\n", vcpuid);
-	pr_info("    steal:     %lld\n", st->steal);
-	pr_info("    version:   %d\n", st->version);
-	pr_info("    flags:     %d\n", st->flags);
-	pr_info("    preempted: %d\n", st->preempted);
-	pr_info("    u8_pad:    ");
+	printf("VCPU%d:\n", vcpuid);
+	printf("    steal:     %lld\n", st->steal);
+	printf("    version:   %d\n", st->version);
+	printf("    flags:     %d\n", st->flags);
+	printf("    preempted: %d\n", st->preempted);
+	printf("    u8_pad:    ");
 	for (i =3D 0; i < 3; ++i)
-		pr_info("%d", st->u8_pad[i]);
-	pr_info("\n    pad:       ");
+		printf("%d", st->u8_pad[i]);
+	printf("\n    pad:       ");
 	for (i =3D 0; i < 11; ++i)
-		pr_info("%d", st->pad[i]);
-	pr_info("\n");
+		printf("%d", st->pad[i]);
+	printf("\n");
 }
=20
 #elif defined(__aarch64__)
@@ -211,10 +211,10 @@ static void steal_time_dump(struct kvm_vm *vm, uint=
32_t vcpuid)
 {
 	struct st_time *st =3D addr_gva2hva(vm, (ulong)st_gva[vcpuid]);
=20
-	pr_info("VCPU%d:\n", vcpuid);
-	pr_info("    rev:     %d\n", st->rev);
-	pr_info("    attr:    %d\n", st->attr);
-	pr_info("    st_time: %ld\n", st->st_time);
+	printf("VCPU%d:\n", vcpuid);
+	printf("    rev:     %d\n", st->rev);
+	printf("    attr:    %d\n", st->attr);
+	printf("    st_time: %ld\n", st->st_time);
 }
=20
 #endif
@@ -326,9 +326,6 @@ int main(int ac, char **av)
 		while (get_run_delay() - run_delay < MIN_RUN_DELAY_NS);
 		pthread_join(thread, NULL);
 		run_delay =3D get_run_delay() - run_delay;
-		TEST_ASSERT(run_delay >=3D MIN_RUN_DELAY_NS,
-			    "Expected run_delay >=3D %ld, got %ld",
-			    MIN_RUN_DELAY_NS, run_delay);
=20
 		/* Run VCPU again to confirm stolen time is consistent with run_delay =
*/
 		run_vcpu(vm, i);
@@ -339,11 +336,11 @@ int main(int ac, char **av)
 			    run_delay, stolen_time);
=20
 		if (verbose) {
-			pr_info("VCPU%d: total-stolen-time=3D%ld test-stolen-time=3D%ld", i,
+			printf("VCPU%d: total-stolen-time=3D%ld test-stolen-time=3D%ld", i,
 				guest_stolen_time[i], stolen_time);
 			if (stolen_time =3D=3D run_delay)
-				pr_info(" (BONUS: guest test-stolen-time even exactly matches test-r=
un_delay)");
-			pr_info("\n");
+				printf(" (BONUS: guest test-stolen-time even exactly matches test-ru=
n_delay)");
+			printf("\n");
 			steal_time_dump(vm, i);
 		}
 	}
--=20
2.21.1

