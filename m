Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1949736B2A1
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 13:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbhDZL7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 07:59:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46329 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231970AbhDZL7m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 07:59:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619438340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+nCk6Ve+TN+8pnIdsqGxzK6u1TVgQuTIbmRV1IvBlv8=;
        b=irSODoH+Ei1INot5TAB5pViGN2zp/YiKReOe9djiwMex/NXvmqK5pODMIncMbQ3ITdI/A0
        TUVf1Jm1VAisqt4o8ZmxZYeRg/XQOBHZfx2o1o77Ed3pwrMaxU+5KX+V/HmCD7Oeb3Ts5K
        qbHgldYAvDwn4uxBkiIKnZdWvusabKk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-wMXs2KOMPeWxPCW9ha64fQ-1; Mon, 26 Apr 2021 07:58:58 -0400
X-MC-Unique: wMXs2KOMPeWxPCW9ha64fQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 170135F9FF;
        Mon, 26 Apr 2021 11:58:58 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E85F960855;
        Mon, 26 Apr 2021 11:58:51 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 0/2] kvm: use KVM_{GET|SET}_SREGS2 when available
Date:   Mon, 26 Apr 2021 14:58:48 +0300
Message-Id: <20210426115850.1003501-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This implements support for using these new=0D
IOCTLS to migrate PDPTRS.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (2):=0D
  kvm: update kernel headers for KVM_{GET|SET}_SREGS2=0D
  KVM: use KVM_{GET|SET}_SREGS2 when supported.=0D
=0D
 accel/kvm/kvm-all.c         |   5 ++=0D
 include/sysemu/kvm.h        |   4 ++=0D
 linux-headers/asm-x86/kvm.h |  13 +++++=0D
 linux-headers/linux/kvm.h   |   5 ++=0D
 target/i386/cpu.h           |   3 +=0D
 target/i386/kvm/kvm.c       | 107 +++++++++++++++++++++++++++++++++++-=0D
 target/i386/machine.c       |  30 ++++++++++=0D
 7 files changed, 165 insertions(+), 2 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

