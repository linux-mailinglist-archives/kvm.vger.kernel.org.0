Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6F0FAFA5
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 12:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbfKML07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 06:26:59 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26339 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727733AbfKML06 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 06:26:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573644417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Tga5Plkk2EboDbtp5MdAr+0aF35TW0b9/8N/X6FsuCY=;
        b=A2N+cvbK+/igjgRAXQQjUszwtwq9lE0HBmNxLnxDmSd0iXAc3TAiGude7+nI/MEIWUTU2b
        PF0tSBdnwNsGWix+3qEWNjNZvbYBCnjlknWNAuxeS5wPIHvRaeyGUrRPYCa/Trw7yUlaXD
        HiE00pjuetfc2cwBJzI9ctzXPhj9JOU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-SdyI06YdNauOc5Wy4CQhSQ-1; Wed, 13 Nov 2019 06:26:56 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7DC8107B273;
        Wed, 13 Nov 2019 11:26:55 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-183.ams2.redhat.com [10.36.116.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0DE360464;
        Wed, 13 Nov 2019 11:26:51 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-test PATCH 0/5] Improvements for the Travis CI
Date:   Wed, 13 Nov 2019 12:26:44 +0100
Message-Id: <20191113112649.14322-1-thuth@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: SdyI06YdNauOc5Wy4CQhSQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first two patches make the test matrix a little bit more flexible,
and the fourth patch enables the 32-bit builds on x86.

But the most important patch is likely the third one: It is possible to
test with KVM on Travis now, so we can run the tests within a real KVM
environment, without TCG! The only caveat is that qemu-system-x86_64
has to run as root ... fixing only the permissions of /dev/kvm did
not help here, I still got a "Permission denied" in that case.

Thomas Huth (5):
  travis.yml: Re-arrange the test matrix
  travis.yml: Install only the required packages for each entry in the
    matrix
  travis.yml: Test with KVM instead of TCG (on x86)
  travis.yml: Test the i386 build, too
  travis.yml: Expect that at least one test succeeds

 .travis.yml | 155 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 104 insertions(+), 51 deletions(-)

--=20
2.23.0

