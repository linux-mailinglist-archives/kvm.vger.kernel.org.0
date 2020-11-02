Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521322A3387
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 20:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725806AbgKBTDH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 14:03:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56522 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725791AbgKBTDH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Nov 2020 14:03:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604343786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NQdKNE9/zc9ZzBpRKz0xCeXBkuHXUMTgObFrN15l8CM=;
        b=In1U6I9SCtZ09XVws5lxOxSg19EHrxU8ndAtTsyTIEocJuUT2Lmk1s3YJJITNjC66q287e
        6F5WHPUmkNmS7ijxHjlCFTLNW97Kai0gytJ2CD9e2S2utKJZ4g9jhlo9NpKZO+kjSkjpx8
        o/gQqK3XAUk0ftvs3/7rL7Vc+KQnURA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-pxQbgAu3OQSXlf2ZmlAbMA-1; Mon, 02 Nov 2020 14:03:04 -0500
X-MC-Unique: pxQbgAu3OQSXlf2ZmlAbMA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 812A91099F75;
        Mon,  2 Nov 2020 19:03:03 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA50B5B4C4;
        Mon,  2 Nov 2020 19:02:54 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, Dave.Martin@arm.com,
        peter.maydell@linaro.org, eric.auger@redhat.com
Subject: [PATCH v2 0/3] KVM: selftests: Add get-reg-list regression test
Date:   Mon,  2 Nov 2020 20:02:50 +0100
Message-Id: <20201102190253.50575-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This test was inspired by recent regression report about get-reg-list
losing a register between an old kernel version and a new one.

v2:
  - Added "... up to date with kernel version v5.10-rc2" comment
    to the blessed list [Marc]
  - Assert when an invalid command line argument is given rather
    than ignore it [drew]

Thanks,
drew


Andrew Jones (3):
  KVM: selftests: Add aarch64 get-reg-list test
  KVM: selftests: Update aarch64 get-reg-list blessed list
  KVM: selftests: Add blessed SVE registers to get-reg-list

 tools/testing/selftests/kvm/.gitignore        |   2 +
 tools/testing/selftests/kvm/Makefile          |   2 +
 .../selftests/kvm/aarch64/get-reg-list-sve.c  |   3 +
 .../selftests/kvm/aarch64/get-reg-list.c      | 843 ++++++++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  29 +
 6 files changed, 880 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list.c

-- 
2.26.2

