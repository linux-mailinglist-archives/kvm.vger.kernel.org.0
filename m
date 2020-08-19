Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860B724A682
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 21:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgHSTE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 15:04:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39812 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725997AbgHSTE1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 15:04:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597863866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=sqbCREBbabhpyfGFi+VXhTJ7T5nvH5EOefWiEBNhsWM=;
        b=D3GPfmQmDzVh/R4WmBqZRP4psILc/qbD+rxh0USse29fwllAgoZ9jTu30Vibwy9MLFHOP5
        xF3G+Zct8H+bc73EHtvFbuSZ3lsYAc+7ffMlur60uZbPuL3rF1S1e/Uy84NEjLLbD0Oe4G
        YIqh3tRM8ElUWJQwmfWWstY4kjOyScs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-d2fSpksPMeWwlhNrmsvBzA-1; Wed, 19 Aug 2020 15:04:24 -0400
X-MC-Unique: d2fSpksPMeWwlhNrmsvBzA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDE46801ADD;
        Wed, 19 Aug 2020 19:04:22 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94AA1100AE55;
        Wed, 19 Aug 2020 19:04:22 +0000 (UTC)
Date:   Wed, 19 Aug 2020 13:04:22 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO fix for v5.9-rc2
Message-ID: <20200819130422.357ea56c@x1.home>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit 9123e3a74ec7b934a4a099e98af6a61c2f80bbf5:

  Linux 5.9-rc1 (2020-08-16 13:04:57 -0700)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.9-rc2

for you to fetch changes up to aae7a75a821a793ed6b8ad502a5890fb8e8f172d:

  vfio/type1: Add proper error unwind for vfio_iommu_replay() (2020-08-17 11:09:13 -0600)

----------------------------------------------------------------
VFIO fixes for v5.9-rc2

 - Fix lockdep issue reported for recursive read-lock (Alex Williamson)

 - Fix missing unwind in type1 replay function (Alex Williamson)

----------------------------------------------------------------
Alex Williamson (2):
      vfio-pci: Avoid recursive read-lock usage
      vfio/type1: Add proper error unwind for vfio_iommu_replay()

 drivers/vfio/pci/vfio_pci_private.h |   2 +
 drivers/vfio/pci/vfio_pci_rdwr.c    | 120 ++++++++++++++++++++++++++++--------
 drivers/vfio/vfio_iommu_type1.c     |  71 +++++++++++++++++++--
 3 files changed, 164 insertions(+), 29 deletions(-)

