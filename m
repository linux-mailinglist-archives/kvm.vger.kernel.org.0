Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EAB324242
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 17:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbhBXQih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 11:38:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37437 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232616AbhBXQhT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 11:37:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614184552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vqM3jBqcK0WlcpFWakq278CLcazYhvJjJtccE6zbFGE=;
        b=eTa1tw7s27oyYecTUr//18yLGuyKUhwy51qjWb3mfyRaG550GTpVLlBq4xI5HZ8IbUYUfN
        KxBGnvrGxJq5YFDGxL05yhwmtTir9UWxawz6IB20JSFkbTRIGZBeXP5522KcRLj6gN9ukH
        R2rPb9KDWQ3FRrtMdVtyq9JZXYmBzy4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-fh_DROU6OziVRTRzKkZcwA-1; Wed, 24 Feb 2021 11:35:50 -0500
X-MC-Unique: fh_DROU6OziVRTRzKkZcwA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF4451008312
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 16:35:49 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.221])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A10A819C46;
        Wed, 24 Feb 2021 16:35:48 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH kvm-unit-tests v2 0/4] x86: hyperv_stimer: test direct mode
Date:   Wed, 24 Feb 2021 17:35:43 +0100
Message-Id: <20210224163547.197100-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v1:
- Minor cosmetic changes. v1 was sent in October, 2019 and I completely
 forgot about it. Time to dust it off!

Original description:

Testing 'direct' mode requires us to add 'hv_stimer_direct' CPU flag to
QEMU, create a new entry in unittests.cfg to not lose the ability to test
stimers in 'VMbus message' mode.

Vitaly Kuznetsov (4):
  x86: hyperv_stimer: keep SINT number parameter in 'struct stimer'
  x86: hyperv_stimer: define union hv_stimer_config
  x86: hyperv_stimer: don't require hyperv-testdev
  x86: hyperv_stimer: add direct mode tests

 x86/hyperv.h        |  29 ++++++--
 x86/hyperv_stimer.c | 159 +++++++++++++++++++++++++++++++++++---------
 x86/unittests.cfg   |   8 ++-
 3 files changed, 157 insertions(+), 39 deletions(-)

-- 
2.29.2

