Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C466139187
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 14:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgAMNAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 08:00:49 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39248 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726277AbgAMNAt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Jan 2020 08:00:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578920448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EkS+XB1Ns/9Hyh+RmqcN6uCGCO0+4bXjZaEm/l9P19A=;
        b=Z0iYB/jKHh+aUGcvIRTjfwoAY1yFDF6tuD0V/72GkV5YCbbx3s6oxF0VuVhWsecF6NpXhT
        Jlpe3xOXJRy2Sn8KJcm+Q28LM+kwHYHD1zZMAgA3lwdBISxcB/vj9NgJeLTvKhSCwP5JOl
        K/T7UAfLtU3UkVUkVqKqbAtwzanHZwo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-VZ-fsZIIMe-6upmb9trs7Q-1; Mon, 13 Jan 2020 08:00:46 -0500
X-MC-Unique: VZ-fsZIIMe-6upmb9trs7Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBE2918A6ED1;
        Mon, 13 Jan 2020 13:00:45 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BAA480F6C;
        Mon, 13 Jan 2020 13:00:44 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com
Subject: [PATCH kvm-unit-tests 0/3] arm/arm64: selftest for pabt
Date:   Mon, 13 Jan 2020 14:00:40 +0100
Message-Id: <20200113130043.30851-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch 3/3 is a rework of Alexandru's pabt test on top of a couple of
framework changes allowing it to be more simply and robustly implemented.

Andrew Jones (3):
  arm/arm64: Improve memory region management
  arm/arm64: selftest: Allow test_exception clobber list to be extended
  arm/arm64: selftest: Add prefetch abort test

 arm/selftest.c      | 199 ++++++++++++++++++++++++++++++++------------
 lib/arm/asm/setup.h |   8 +-
 lib/arm/mmu.c       |  24 ++----
 lib/arm/setup.c     |  56 +++++++++----
 lib/arm64/asm/esr.h |   3 +
 5 files changed, 203 insertions(+), 87 deletions(-)

--=20
2.21.1

