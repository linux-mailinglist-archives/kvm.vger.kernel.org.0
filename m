Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309A4375A32
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 20:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbhEFScQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 14:32:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24374 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231839AbhEFScP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 14:32:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620325877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=RKug1+n7aNUKpd2/5y9E1AAuMfgec3Gz+e4TxaTVI6A=;
        b=C5LENBDArtySyBFU5b76iygBHTOpOtYFldYP4seV0zBMURLcohBlUvknlIvhlRo7psLdcn
        aKW7o8gGTqIW5+D8ptO8WWFeKYMwWoGok7tgxwv1tDRrw6Sds7RDDJcusNmrRku2KxP1br
        wH5AFj1n65fcPbD14Ewk/ukPAr8w7cE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-tKPEBZXnM1CNUh-qlS8Vww-1; Thu, 06 May 2021 14:31:15 -0400
X-MC-Unique: tKPEBZXnM1CNUh-qlS8Vww-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C5D68014D8;
        Thu,  6 May 2021 18:31:13 +0000 (UTC)
Received: from redhat.com (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 382D65D9DE;
        Thu,  6 May 2021 18:31:12 +0000 (UTC)
Date:   Thu, 6 May 2021 12:31:11 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, hi@alyssa.is,
        dan.carpenter@oracle.com
Subject: [GIT PULL] VFIO updates for v5.13-rc1 pt2
Message-ID: <20210506123111.6b6c0bf3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

A 2nd small set of commits for this merge window, primarily to unbreak
some deletions from our uAPI header before rc1.  Thanks,

Alex

The following changes since commit 5e321ded302da4d8c5d5dd953423d9b748ab3775:

  Merge tag 'for-5.13/parisc' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux (2021-05-03 13:47:17 -0700)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.13-rc1pt2

for you to fetch changes up to cc35518d29bc8e38902866b74874b4a3f1ad3617:

  docs: vfio: fix typo (2021-05-05 10:20:33 -0600)

----------------------------------------------------------------
VFIO updates for v5.13-rc1 pt2

 - Additional mdev sample driver cleanup (Dan Carpenter)

 - Doc fix (Alyssa Ross)

 - Unbreak uAPI from NVLink2 support removal (Alex Williamson)

----------------------------------------------------------------
Alex Williamson (1):
      vfio/pci: Revert nvlink removal uAPI breakage

Alyssa Ross (1):
      docs: vfio: fix typo

Dan Carpenter (1):
      vfio/mdev: remove unnecessary NULL check in mbochs_create()

 Documentation/driver-api/vfio.rst |  2 +-
 include/uapi/linux/vfio.h         | 46 +++++++++++++++++++++++++++++++++++----
 samples/vfio-mdev/mbochs.c        |  2 --
 samples/vfio-mdev/mdpy.c          |  3 +--
 4 files changed, 44 insertions(+), 9 deletions(-)

