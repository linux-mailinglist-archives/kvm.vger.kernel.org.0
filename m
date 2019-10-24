Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3242BE216C
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 19:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbfJWRI0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 13:08:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51713 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727648AbfJWRI0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 13:08:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571850505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5i2V5gs6KA30KkIAaoVKaoCZzrYOsax9Xuom4ymjp0I=;
        b=HSA3CAJQCcWfRrg5C4QFw1ua+dqI7FIP+K+yt7PSlewtX4IvVM8PUsAYAGv0MZA2zqG16x
        R9sgK9PJzXj4SdfmAM/Hc2ezh9XOcDNMhNxBeiA/DHISf+dYO20/yI6JBY757XZHOcgtff
        smkANaaRKOCkrMvPgvTlhdLomETVXqI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-k0Itp5FhNDqb_6KHYPi4AQ-1; Wed, 23 Oct 2019 13:08:23 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BC6C800D49;
        Wed, 23 Oct 2019 17:08:23 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C424260BE1;
        Wed, 23 Oct 2019 17:08:22 +0000 (UTC)
Date:   Wed, 23 Oct 2019 11:08:22 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] VFIO fixes for v5.4-rc5
Message-ID: <20191023110822.6122562f@x1.home>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: k0Itp5FhNDqb_6KHYPi4AQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit 4f5cafb5cb8471e54afdc9054d973535614f7675=
:

  Linux 5.4-rc3 (2019-10-13 16:37:36 -0700)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.4-rc5

for you to fetch changes up to 95f89e090618efca63918b658c2002e57d393036:

  vfio/type1: Initialize resv_msi_base (2019-10-15 14:07:01 -0600)

----------------------------------------------------------------
VFIO fixes for v5.4-rc5

 - Fix (false) uninitialized variable warning (Joerg Roedel)

----------------------------------------------------------------
Joerg Roedel (1):
      vfio/type1: Initialize resv_msi_base

 drivers/vfio/vfio_iommu_type1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

