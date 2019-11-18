Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C09A100220
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 11:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfKRKIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 05:08:42 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20580 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726956AbfKRKIl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Nov 2019 05:08:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574071720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JCxaUCZLLy3tTwT9N1l1ulIsEarmu4H/s/AHqsHjk00=;
        b=Niih3T+UUzvP3apTeiquGpnGVNc+oUjOMQLUU2JEhlwVXAgivoxvRJhpfP1c3F+py5lim4
        Vire7PoTg9h/j3iNiEjoMhj/Ewr3cqKnr6gN4uAKkaMinPK89RzncWkxqaRDpaPKYKit1r
        ygxw+IBi7VtWUxxnhg+xf6eahiEcNMs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-ZvmXdU10Mu6TpM86W3qAcw-1; Mon, 18 Nov 2019 05:08:39 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25E15802691;
        Mon, 18 Nov 2019 10:08:38 +0000 (UTC)
Received: from t460s.redhat.com (unknown [10.36.118.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32CC866856;
        Mon, 18 Nov 2019 10:08:34 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 12/12] travis.yml: Expect that at least one test succeeds
Date:   Mon, 18 Nov 2019 11:07:19 +0100
Message-Id: <20191118100719.7968-13-david@redhat.com>
In-Reply-To: <20191118100719.7968-1-david@redhat.com>
References: <20191118100719.7968-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: ZvmXdU10Mu6TpM86W3qAcw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

While working on the travis.yml file, I've run into cases where
all tests are reported as "SKIP" by the run_test.sh script (e.g.
when QEMU could not be started). This should not result in a
successful test run, so mark it as failed if not at least one
test passed.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Message-Id: <20191113112649.14322-6-thuth@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 .travis.yml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.travis.yml b/.travis.yml
index 6858c3a..4162366 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -116,3 +116,4 @@ script:
   - make -j3
   - ACCEL=3D"${ACCEL:-tcg}" ./run_tests.sh -v $TESTS | tee results.txt
   - if grep -q FAIL results.txt ; then exit 1 ; fi
+  - if ! grep -q PASS results.txt ; then exit 1 ; fi
--=20
2.21.0

