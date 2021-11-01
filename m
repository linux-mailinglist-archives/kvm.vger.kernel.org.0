Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A516C441BAA
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 14:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbhKANZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 09:25:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43318 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230417AbhKANZv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 09:25:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635772997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=RZLftubQZhcRywV/L4ITsBdUbnfH9UsZVxjpxPe8d9E=;
        b=JytEJGPbAu+nK3JacP/IcKFMoRmz5qk7NqJwsQ9V65bN6bwI8I3MbsuvoKDvRD4C2PIbw5
        qlgtRLApsCXwS+sbhgb7jD4t8/jQWKjxH1pVEGqpE0Ux/zYh5gb1gHkCu5kbQPWUFzVt3p
        p52OPpJJ4Jzlwhvx5YRHwe6hV9oN/jk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-YrwGze3yM1qCJwoCR6itjw-1; Mon, 01 Nov 2021 09:23:16 -0400
X-MC-Unique: YrwGze3yM1qCJwoCR6itjw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7C138026AD;
        Mon,  1 Nov 2021 13:23:14 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10BDD60C0F;
        Mon,  1 Nov 2021 13:23:04 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 0/3] KVM: qemu patches for few KVM features I developed
Date:   Mon,  1 Nov 2021 15:22:57 +0200
Message-Id: <20211101132300.192584-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These patches implement the qemu side logic to support=0D
the KVM features I developed recently.=0D
=0D
All 3 patches are for features that are accepted upstream in KVM.=0D
=0D
V2: rebased and fixed patch 2 to compile without kvm=0D
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
 gdbstub.c             |  62 +++++++++++++++++----=0D
 include/sysemu/kvm.h  |  19 +++++++=0D
 target/i386/cpu.c     |   5 ++=0D
 target/i386/cpu.h     |   7 +++=0D
 target/i386/kvm/kvm.c | 122 +++++++++++++++++++++++++++++++++++++++++-=0D
 target/i386/machine.c |  52 ++++++++++++++++++=0D
 7 files changed, 284 insertions(+), 13 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

