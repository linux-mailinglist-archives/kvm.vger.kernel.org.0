Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAB735196E
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234544AbhDARx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:53:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23451 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236442AbhDARrI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:47:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=caF8NNgeAw+4v4t8bg5Tp1fnSjzea1gBUcStxuTikxY=;
        b=RjD7QMpDc6SEJrBeuAYo4e41On/2ZZ4eooGnDMPKpci3p5YaZ7iNejW5PIxEfesTCLGB9q
        Fp+jauqDqXDevZDtbjrlmTJp0tOTOgRv2FNhojFE+yuwEdG4siabrLmOgyECq8QZjZ/DuU
        2EYtIBfNLC9HTjSsLz8Ggim5nkbK+lQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-h6n7w6QxOSCSux_680o51w-1; Thu, 01 Apr 2021 10:46:04 -0400
X-MC-Unique: h6n7w6QxOSCSux_680o51w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40D2D1087C67;
        Thu,  1 Apr 2021 14:45:49 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE51E5C233;
        Thu,  1 Apr 2021 14:45:46 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/2] kvm: use KVM_{GET|SET}_SREGS2 when available
Date:   Thu,  1 Apr 2021 17:45:43 +0300
Message-Id: <20210401144545.1031704-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

clone of "starship_unstable"=0D
=0D
Maxim Levitsky (2):=0D
  kvm: update kernel headers for KVM_{GET|SET}_SREGS2=0D
  KVM: use KVM_{GET|SET}_SREGS2 when supported by kvm.=0D
=0D
 accel/kvm/kvm-all.c         |   4 ++=0D
 include/sysemu/kvm.h        |   4 ++=0D
 linux-headers/asm-x86/kvm.h |  13 +++++=0D
 linux-headers/linux/kvm.h   |   5 ++=0D
 target/i386/cpu.h           |   1 +=0D
 target/i386/kvm/kvm.c       | 101 +++++++++++++++++++++++++++++++++++-=0D
 target/i386/machine.c       |  33 ++++++++++++=0D
 7 files changed, 159 insertions(+), 2 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

