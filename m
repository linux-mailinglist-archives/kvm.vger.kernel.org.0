Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12D6740A60
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjF1IDT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:03:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55386 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232203AbjF1IBO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jun 2023 04:01:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687939224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=If/NIFLMKu1pHmU36jyH1nSFqHTvzR8BXIpiRJwo1tQ=;
        b=C7EE0CDmPTbHMfpTxHFFYzf7Yd8njUL0k79shrW6PI7442nZ2yGJzYsPwQRkUOP1miWZAd
        PUAlfh9z4MgYKCGXYn71GfhIbHNHZ1hHqEAFpX13ER3qbR5aVs6tsw6sqRYrOLyHfgA1nO
        mXIDZNcFGMABhtvkmEatNjmgTklkFcs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-ahSWMK_PObiHDB3lryCl3g-1; Wed, 28 Jun 2023 02:59:27 -0400
X-MC-Unique: ahSWMK_PObiHDB3lryCl3g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACD6A2812946;
        Wed, 28 Jun 2023 06:59:26 +0000 (UTC)
Received: from server.redhat.com (ovpn-13-142.pek2.redhat.com [10.72.13.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 235F1492B02;
        Wed, 28 Jun 2023 06:59:22 +0000 (UTC)
From:   Cindy Lu <lulu@redhat.com>
To:     lulu@redhat.com, jasowang@redhat.com, mst@redhat.com,
        maxime.coquelin@redhat.com, xieyongji@bytedance.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [RFC 0/4] reconnect support in vduse
Date:   Wed, 28 Jun 2023 14:59:15 +0800
Message-Id: <20230628065919.54042-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all

Here is the reconnect support in vduse, The steps
is map the pages from kernel to userland, usespace    
app will wirte the vq_info in the pages
And then sync this information in kernel/user-space
I just the split mode, So only use the last_avail_idx
here, Will send the patch for DPDK later

Tested in vduse + dpdk test-pmd

Cindy Lu (4):
  vduse: Add the struct to save the vq reconnect info
  vduse: Add file operation for mmap
  vduse: Add the function for get/free the mapp pages
  vduse: update the vq_info in ioctl

 drivers/vdpa/vdpa_user/vduse_dev.c | 107 +++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

-- 
2.34.3

