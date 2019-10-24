Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71DE9E336B
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393513AbfJXNHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:07:09 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57407 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2393510AbfJXNHJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 09:07:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571922427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=H/iWffyJRiYvzY9mn8fv0wMywOEHlPukE8X8vQ9C3BE=;
        b=JJUluO96Ccy3GPF/yQojqyyb6yFTeyR4/orNyA6GfidxvgWxheQSiH3cxNsn29sicRAV0Z
        nBo3cQBYw8gWJxZczHO/hfgCeYOkVRaerW592OfuqAEy7dS2cVksde4Hpv/h0hCi3ynRPp
        xJtksJlA/jeC26AYojUZpcLLiNYzjV0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-b_Ujd3lTPJiR2IcNZRRfGQ-1; Thu, 24 Oct 2019 09:07:05 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B0FC800D49
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 13:07:04 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 739F361F21;
        Thu, 24 Oct 2019 13:07:03 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PULL kvm-unit-tests 00/10] arm/arm64 updates
Date:   Thu, 24 Oct 2019 15:06:51 +0200
Message-Id: <20191024130701.31238-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: b_Ujd3lTPJiR2IcNZRRfGQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit ac033c9a2cb287c1bb5ebe414c63067563a05bbb=
:

  Revert "lib: use an argument which doesn't require default argument promo=
tion" (2019-10-23 11:03:31 +0200)

are available in the Git repository at:

  https://github.com/rhdrjones/kvm-unit-tests pull-arm-oct-24-2019

for you to fetch changes up to 00d7e26501263263877465d2a74a330897de1e70:

  arm: Add PL031 test (2019-10-24 14:41:01 +0200)

----------------------------------------------------------------
Alexander Graf (1):
  arm: Add PL031 test

Alexandru Elisei (3):
  lib: arm64: Add missing ISB in flush_tlb_page
  lib: arm/arm64: Add function to clear the PTE_USER bit
  arm64: Add cache code generation test

Andre Przywara (6):
  arm: gic: check_acked: add test description
  arm: gic: Split variable output data from test name
  arm: timer: Split variable output data from test name
  arm: selftest: Split variable output data from test name
  arm: selftest: Make MPIDR output stable
  arm: Add missing test name prefix calls

 arm/Makefile.arm64    |   1 +
 arm/Makefile.common   |   1 +
 arm/cache.c           | 122 ++++++++++++++++++++
 arm/gic.c             |  64 ++++++-----
 arm/pci-test.c        |   2 +
 arm/pl031.c           | 262 ++++++++++++++++++++++++++++++++++++++++++
 arm/psci.c            |   2 +
 arm/selftest.c        |  23 +++-
 arm/timer.c           |   3 +-
 arm/unittests.cfg     |   6 +
 lib/arm/asm/gic.h     |   1 +
 lib/arm/asm/mmu-api.h |   1 +
 lib/arm/mmu.c         |  15 +++
 lib/arm64/asm/mmu.h   |   1 +
 14 files changed, 472 insertions(+), 32 deletions(-)
 create mode 100644 arm/cache.c
 create mode 100644 arm/pl031.c

--=20
2.21.0

