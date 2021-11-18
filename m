Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29C7455CCC
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 14:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbhKRNjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 08:39:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21406 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230088AbhKRNjA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 08:39:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637242559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=IHFHT3sJUPu83cbYBoL1no1u411zhvN0zLqeCR5zqqY=;
        b=RaTxMfLhpiq5fXxxEFnSaPa6RBEXguwxScd9Fmkj5vk+2jlYQ5+CBkOKhgHveT2Zu1Sf7R
        sSldzsgwxAEivzAnnaOuEwHk4rVp4J8jayth1zRa87+RnQs3OlwEMzYxb4eYJzQsOZqtpz
        gOriVi3Jq0h91UhThPKK//GRxNkZvIY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-TGTcRcQgNr26s9ZXQa5eCQ-1; Thu, 18 Nov 2021 08:35:56 -0500
X-MC-Unique: TGTcRcQgNr26s9ZXQa5eCQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89102802EDA;
        Thu, 18 Nov 2021 13:35:55 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.33.36.247])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF4CE5F4ED;
        Thu, 18 Nov 2021 13:35:33 +0000 (UTC)
From:   =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PULL 0/6 for-6.2] AMD SEV patches
Date:   Thu, 18 Nov 2021 13:35:26 +0000
Message-Id: <20211118133532.2029166-1-berrange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 0055ecca84cb948c935224b4f7ca1ceb26209790=
:=0D
=0D
  Merge tag 'vfio-fixes-20211117.0' of git://github.com/awilliam/qemu-vfio =
into staging (2021-11-18 09:39:47 +0100)=0D
=0D
are available in the Git repository at:=0D
=0D
  https://gitlab.com/berrange/qemu tags/sev-hashes-pull-request=0D
=0D
for you to fetch changes up to 58603ba2680fa35eade630e4b040e96953a11021:=0D
=0D
  target/i386/sev: Replace qemu_map_ram_ptr with address_space_map (2021-11=
-18 13:28:32 +0000)=0D
=0D
----------------------------------------------------------------=0D
Add property for requesting AMD SEV measured kernel launch=0D
=0D
 - The 'sev-guest' object gains a boolean 'kernel-hashes' property=0D
   which must be enabled to request a measured kernel launch.=0D
=0D
----------------------------------------------------------------=0D
=0D
Dov Murik (6):=0D
  qapi/qom,target/i386: sev-guest: Introduce kernel-hashes=3Don|off option=
=0D
  target/i386/sev: Add kernel hashes only if sev-guest.kernel-hashes=3Don=0D
  target/i386/sev: Rephrase error message when no hashes table in guest=0D
    firmware=0D
  target/i386/sev: Fail when invalid hashes table area detected=0D
  target/i386/sev: Perform padding calculations at compile-time=0D
  target/i386/sev: Replace qemu_map_ram_ptr with address_space_map=0D
=0D
 qapi/qom.json     |  7 ++++-=0D
 qemu-options.hx   |  6 +++-=0D
 target/i386/sev.c | 79 +++++++++++++++++++++++++++++++++++++++--------=0D
 3 files changed, 77 insertions(+), 15 deletions(-)=0D
=0D
-- =0D
2.31.1=0D
=0D

