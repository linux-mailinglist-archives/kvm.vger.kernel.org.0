Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB15540B3BF
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 17:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbhINPxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 11:53:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48443 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231928AbhINPxh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 11:53:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631634740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rsc7F78hfpb2cAPyQAe2qVvV2kE4WtG8AgRwBpIg1Ek=;
        b=gN3+S48OYs2B9Q64FHWV5HU+BEOagPrJP60go8TaCcNYAMcNoVL0rl8icO21WVXCUBaivi
        /pLaMnosooKXEto8+fXP73cOt1GVLnci2jzlZegzSHgdxd+/VMY29NV9I6kwaUTjXGw6Tl
        /7BS7VWQWo5zPgvAHUfHvOHpJmTZFV8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-HMinhiJtNM6AW3I-2Hl-Pw-1; Tue, 14 Sep 2021 11:52:19 -0400
X-MC-Unique: HMinhiJtNM6AW3I-2Hl-Pw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC6A1835DEA;
        Tue, 14 Sep 2021 15:52:17 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 141875D9D3;
        Tue, 14 Sep 2021 15:52:15 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/3] KVM: qemu patches for few KVM features I developed
Date:   Tue, 14 Sep 2021 18:52:11 +0300
Message-Id: <20210914155214.105415-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These patches implement the qemu side logic to support=0D
the KVM features I developed recently.=0D
=0D
First two patches are for features that are already accepted=0D
upstream, and I already posted them on the qemu mailing list once.=0D
=0D
And the 3rd patch is for nested TSC scaling on SVM=0D
which isn't yet accepted in KVM but can already be added to qemu since=0D
it is conditional on KVM supporting it, and ABI wise it only relies=0D
on SVM spec.=0D
=0D
Best regards,=0D
    Maxim Levitsky=0D
=0D
Maxim Levitsky (3):=0D
  KVM: use KVM_{GET|SET}_SREGS2 when supported.=0D
  gdbstub: implement NOIRQ support for single step on KVM=0D
  KVM: SVM: add migration support for nested TSC scaling=0D
=0D
 accel/kvm/kvm-all.c   |  30 +++++++++++=0D
 gdbstub.c             |  60 +++++++++++++++++----=0D
 include/sysemu/kvm.h  |  17 ++++++=0D
 target/i386/cpu.c     |   5 ++=0D
 target/i386/cpu.h     |   7 +++=0D
 target/i386/kvm/kvm.c | 122 +++++++++++++++++++++++++++++++++++++++++-=0D
 target/i386/machine.c |  53 ++++++++++++++++++=0D
 7 files changed, 282 insertions(+), 12 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

