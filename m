Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75E2274A03
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 22:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgIVUTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 16:19:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35486 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726448AbgIVUTe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 16:19:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600805973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9x1hlobF7KdJZj9Gxk1LjuIS+slLQ+pwDxPhU6e65XM=;
        b=PTFU2SDdUQQ67SQzGisHHYk75sge+GvSZ8REiUK19OFvlBPdGYBv0RcIMwOae0XaPTEJKl
        IuAL4sCZL1GBDRh7OPTx1UIbSWlr4o5dmN9xk5pj/E854UpBLIv/mBeq0UOy13dpVFY8mI
        PLMELVcD6B2THaCavPqucw+ZicFh5b0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-Bz2zwGMvOnmXRDFrPmH-aw-1; Tue, 22 Sep 2020 16:19:31 -0400
X-MC-Unique: Bz2zwGMvOnmXRDFrPmH-aw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF4C118B9ECB;
        Tue, 22 Sep 2020 20:19:29 +0000 (UTC)
Received: from localhost (unknown [10.10.67.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 946A519D6C;
        Tue, 22 Sep 2020 20:19:23 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sergio Lopez <slp@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 0/3] i386/kvm: Assume IRQ routing is always available
Date:   Tue, 22 Sep 2020 16:19:19 -0400
Message-Id: <20200922201922.2153598-1-ehabkost@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_CAP_IRQ_ROUTING is available since 2019 (Linux v2.6.30), so=0D
we can safely assume it's always present and remove some runtime=0D
checks.=0D
=0D
Eduardo Habkost (3):=0D
  i386/kvm: Require KVM_CAP_IRQ_ROUTING=0D
  i386/kvm: Remove IRQ routing support checks=0D
  i386/kvm: Delete kvm_allows_irq0_override()=0D
=0D
 target/i386/kvm_i386.h |  1 -=0D
 hw/i386/fw_cfg.c       |  2 +-=0D
 hw/i386/kvm/apic.c     |  5 ++---=0D
 hw/i386/kvm/ioapic.c   | 33 ++++++++++++++++-----------------=0D
 hw/i386/microvm.c      |  2 +-=0D
 hw/i386/pc.c           |  2 +-=0D
 target/i386/kvm-stub.c |  5 -----=0D
 target/i386/kvm.c      | 17 +++++------------=0D
 8 files changed, 26 insertions(+), 41 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

