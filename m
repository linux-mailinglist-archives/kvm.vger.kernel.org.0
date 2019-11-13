Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07471FAFAD
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 12:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbfKML11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 06:27:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21912 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727733AbfKML10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 06:27:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573644445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HOVovCio+WLnA1ZCsJ6egR16eHtP8JxsABFT4kxRGog=;
        b=UAxosVQYmnOG1oSjo926TycgxDokDkHbLDBcDtO8J9Cy9j3LlRXzEN37WwukvGvlnle2Kg
        myAvBhaId72wENc5bmKI5kkiPESDXRFAqkWpeYRu675rLKTVRFPkUP/gzxupGBmLAAQlUU
        hZN34ZyxRGW3OsMAGAP1WmymyBXojys=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-O6Uvhf_mO9KewSMQ5h-oZg-1; Wed, 13 Nov 2019 06:27:21 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DC3A1852E2A;
        Wed, 13 Nov 2019 11:27:19 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-183.ams2.redhat.com [10.36.116.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F3C86046B;
        Wed, 13 Nov 2019 11:27:09 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-test PATCH 5/5] travis.yml: Expect that at least one test succeeds
Date:   Wed, 13 Nov 2019 12:26:49 +0100
Message-Id: <20191113112649.14322-6-thuth@redhat.com>
In-Reply-To: <20191113112649.14322-1-thuth@redhat.com>
References: <20191113112649.14322-1-thuth@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: O6Uvhf_mO9KewSMQ5h-oZg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While working on the travis.yml file, I've run into cases where
all tests are reported as "SKIP" by the run_test.sh script (e.g.
when QEMU could not be started). This should not result in a
successful test run, so mark it as failed if not at least one
test passed.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.travis.yml b/.travis.yml
index 9ceb04d..aacf7d2 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -115,3 +115,4 @@ script:
   - make -j3
   - ACCEL=3D"${ACCEL:-tcg}" ./run_tests.sh -v $TESTS | tee results.txt
   - if grep -q FAIL results.txt ; then exit 1 ; fi
+  - if ! grep -q PASS results.txt ; then exit 1 ; fi
--=20
2.23.0

