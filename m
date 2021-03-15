Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBF633C838
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 22:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbhCOVJx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 17:09:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56391 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234002AbhCOVJ1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 17:09:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615842566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WaSFqC/ENxU5MJhb5PdNljtQvKtogr2JobEHM9p+t6M=;
        b=UBaBFdYCLGVBeuelQLZENop4yuvRzn7yeLN6IZgkgfKbW3zrEb+U7oC525QxkTCAnwWuFT
        0bBAUSiCzQ2h7pndo5WuI3JXVvYlAY8I8Wcb3ZUpxD/bWZPweKB7/WNVaYqI6e6wnhuUuI
        EdBtXap8Nlqj+0Z6Qfr7RJvU9V14wZ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-UnlnbXwINsiZlBfNzCz9BQ-1; Mon, 15 Mar 2021 17:09:24 -0400
X-MC-Unique: UnlnbXwINsiZlBfNzCz9BQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA2DE107465E
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 21:09:23 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.207.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E220417B80;
        Mon, 15 Mar 2021 21:09:22 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 0/2] Simple test for sysenter instruction
Date:   Mon, 15 Mar 2021 23:09:19 +0200
Message-Id: <20210315210921.626351-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,=0D
=0D
This patch series adds a simple test for sysenter instruction running in=0D
comp32 mode, while using Intel vendor ID.=0D
=0D
In this setting, KVM emulates this instruction to help with cross-vendor=0D
migration on AMD.=0D
=0D
I also added a patch to 'msr' test to run it with Intel's vendor ID, since =
this=0D
test tests that SYSENTER EIP/ESP msrs are 64 bit wide which is only true on=
 AMD.=0D
=0D
KVM used to emulate these msrs to be always 64 bit on AMD, but this soon wi=
ll=0D
be changed to do the emulation only when guest CPU vendor ID is of Intel.=0D
=0D
Best regards,=0D
    Maxim Levitsky=0D
=0D
Maxim Levitsky (2):=0D
  x86/msr: run this test with intel vendor id=0D
  Add a simple test for SYSENTER instruction.=0D
=0D
 x86/Makefile.x86_64 |  3 ++=0D
 x86/cstart64.S      |  1 +=0D
 x86/sysenter.c      | 91 +++++++++++++++++++++++++++++++++++++++++++++=0D
 x86/unittests.cfg   |  6 +++=0D
 4 files changed, 101 insertions(+)=0D
 create mode 100644 x86/sysenter.c=0D
=0D
-- =0D
2.26.2=0D
=0D

