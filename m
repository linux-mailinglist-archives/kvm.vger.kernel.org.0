Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B440BE0806
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 17:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388106AbfJVP4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 11:56:17 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58158 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731061AbfJVP4R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Oct 2019 11:56:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571759776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=syfYLZ69n6ZvR2Wxg/DomdMV5PVywHfQ/vJiuX+xZw0=;
        b=hdqNF5Jwp6GhDSkgoOy6l16uYzQ9nPJZzcKL9Co5fb3TEjSA4vVUIS0um//qRVrXXSbcsy
        mZDs6dbGdpWUE0aCLAnJ1hoxvmR+v3/am/j2gSfGKH8Ra40CrvxJJf63cgIL91t1P+f2wY
        6blDivGu+TuW0F2jhZhjoFMRh+LH+hE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-s7q-IpU4MSSmufE_YLR0TA-1; Tue, 22 Oct 2019 11:56:13 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27D34107AD31;
        Tue, 22 Oct 2019 15:56:12 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.43.2.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 963155D6A9;
        Tue, 22 Oct 2019 15:56:09 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: [PATCH kvm-unit-tests 0/4] x86: hyperv_stimer: test direct mode
Date:   Tue, 22 Oct 2019 17:56:04 +0200
Message-Id: <20191022155608.8001-1-vkuznets@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: s7q-IpU4MSSmufE_YLR0TA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I should've done that when QEMU patche for 'hv_stimer_direct' landed but
better late than never, right?

Testing 'direct' mode requires us to add 'hv_stimer_direct' CPU flag to
QEMU, create a new entry in unittests.cfg to not lose the ability to test
stimers in 'message' mode with older QEMUs/kernels. Unfortunately, a
failure with './run_tests' will still be visible.

Vitaly Kuznetsov (4):
  x86: hyperv_stimer: keep SINT number parameter in 'struct stimer'
  x86: hyperv_stimer: define union hv_stimer_config
  x86: hyperv_stimer: don't require hyperv-testdev
  x86: hyperv_stimer: add direct mode tests

 x86/hyperv.h        |  29 +++++++--
 x86/hyperv_stimer.c | 152 ++++++++++++++++++++++++++++++++++----------
 x86/unittests.cfg   |   8 ++-
 3 files changed, 150 insertions(+), 39 deletions(-)

--=20
2.20.1

