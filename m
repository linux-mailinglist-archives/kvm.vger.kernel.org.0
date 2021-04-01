Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC083518B6
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 19:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbhDARrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:47:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37415 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235916AbhDARnW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:43:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Wqovkryd67AAu1yEb9Qoyk/Fi5dhTRWrAiv6mvYiJ+M=;
        b=EeyjlJRhBlWFDtA3MMfQhDiGm4IAKcJqSAXL8AJlrkFCeosDZvE96rOi+Xn4EsdleTSATD
        pF6YRJJcJOvIlzV6xaZRHisaJFtUt05sVlD4I+1/5ofSMnmk/OiYqQ3tBi28MobxMlU5A7
        HHAblSwWStrwJUsdn4kTJ5oNQ/YuYVg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-cYAo7J9-MaOgWw0At0kROw-1; Thu, 01 Apr 2021 10:42:06 -0400
X-MC-Unique: cYAo7J9-MaOgWw0At0kROw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E1961927813;
        Thu,  1 Apr 2021 14:41:55 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C3DD5D6B1;
        Thu,  1 Apr 2021 14:41:53 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/2] gdbstub: implement support for blocking interrupts on
 single stepping
Date:   Thu,  1 Apr 2021 17:41:50 +0300
Message-Id: <20210401144152.1031282-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

clone of "starship_unstable"=0D
=0D
Maxim Levitsky (2):=0D
  kvm: update kernel headers for KVM_GUESTDBG_BLOCKEVENTS=0D
  gdbstub: implement NOIRQ support for single step on KVM, when kvm's=0D
    KVM_GUESTDBG_BLOCKIRQ debug flag is supported.=0D
=0D
 accel/kvm/kvm-all.c         | 25 ++++++++++++++++=0D
 gdbstub.c                   | 59 ++++++++++++++++++++++++++++++-------=0D
 include/sysemu/kvm.h        | 13 ++++++++=0D
 linux-headers/asm-x86/kvm.h |  2 ++=0D
 linux-headers/linux/kvm.h   |  1 +=0D
 5 files changed, 90 insertions(+), 10 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

