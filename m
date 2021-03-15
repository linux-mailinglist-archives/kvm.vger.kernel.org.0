Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121E233C837
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 22:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbhCOVJx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 17:09:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42421 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234094AbhCOVJ2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 17:09:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615842567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q6pYNXzlBUy6CQUTp7+4XJuVu3ymwKliQzSLa0SUmY8=;
        b=W0juX1kI87sZQWQLTnH0GIoyaBRc3X3/zylGljvVu9ro/+UK37ahki9J3y2QGF7+/kJyjm
        20CCiI7lnF6iy8mMEpZ2e0tGdum6MJrNi79jyRTkh8NOewAic19mHsiHfTC2Q8qrJgFRPU
        Sf+NkF/UbzK20x9HswgNqKoByT8MCo4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-9dSY1uLMOseTgeBMeVdyMA-1; Mon, 15 Mar 2021 17:09:26 -0400
X-MC-Unique: 9dSY1uLMOseTgeBMeVdyMA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F00AE87A83C
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 21:09:24 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.207.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2583460C0F;
        Mon, 15 Mar 2021 21:09:23 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 1/2] x86/msr: run this test with intel vendor id
Date:   Mon, 15 Mar 2021 23:09:20 +0200
Message-Id: <20210315210921.626351-2-mlevitsk@redhat.com>
In-Reply-To: <20210315210921.626351-1-mlevitsk@redhat.com>
References: <20210315210921.626351-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Part of this test, tests that sysenter msrs are 64 bit wide
which is only true on Intel.

We emulate Intel variant of SYSENTER in KVM when
Intel's vendor ID is used to help with cross-vendor migration,
which includes extending SYSENTER msrs to 64 bit.

The later was done unconditionally which soon will be limited
to VMs which use Intel's vendor ID.

So run the test with Intel's vendor ID so it continues to pass.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/unittests.cfg | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 0698d15..60c4b13 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -168,6 +168,7 @@ arch = x86_64
 
 [msr]
 file = msr.flat
+extra_params = -cpu host,vendor=GenuineIntel
 
 [pmu]
 file = pmu.flat
-- 
2.26.2

