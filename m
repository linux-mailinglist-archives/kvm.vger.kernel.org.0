Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D8C1C45D7
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 20:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730811AbgEDS1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 14:27:37 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:6434 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730700AbgEDS1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 14:27:37 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eb05e180000>; Mon, 04 May 2020 11:25:28 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 04 May 2020 11:27:36 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 04 May 2020 11:27:36 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 May
 2020 18:27:36 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 4 May 2020 18:27:29 +0000
From:   Kirti Wankhede <kwankhede@nvidia.com>
To:     <alex.williamson@redhat.com>, <cjia@nvidia.com>
CC:     <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: [PATCH v1 0/2] Sample mtty: Add migration support
Date:   Mon, 4 May 2020 23:24:18 +0530
Message-ID: <1588614860-16330-1-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1588616728; bh=Pb04Iu62xKvSrOf93txxsuT7GSxKY/A1qJ9hHxmcZuw=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         X-NVConfidentiality:MIME-Version:Content-Type;
        b=XIkUIBsG/2E3lUv77T7YmZp3/8PEYGrkbFAMksY3qDhYXCtfGyogTciOwsAsMc9l8
         fPkc0fv01NfPurK2cnjLdu6Nnq4hqfTzcgwCmIsfi/GKjbZ9DoKDqT7yqqDKqNYfhS
         72q/9cmZTpr1Ha925S7Z+5lz59DCcD5hhzt/k2cpyOe/BiypOtPpbXlwN75n7gnWa+
         5kApbA6kXPIVuPuS35kL0tcNuktGWFHG56BSv6XPvDd7QGoPOWUBD1ZRwYQhxZlld0
         zjLVpvK6OkNsILm5PSOU46cId8j6PuN/gGX4T4eS6P3NvqAsyp2kNBGV2hBZtwWNPj
         DRKKmwZaRZ8cw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

These patches add migration support to mtty module.

mtty module doesn't pin pages, but to test migration interface which
queries dirty pages, first patch adds sysfs file to pin pages. Input to
this file is guest pfn. Each write to sysfs file pins one page.

Second patch add migration interface to mtty module.

Only stop-and-copy phase is implemented.
Postcopy migration is not supported.
This series is for testing purpose only.

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>

Kirti Wankhede (2):
  Sample mtty: Add sysfs interface to pin pages
  Sample mtty: Add migration capability to mtty module

 samples/vfio-mdev/mtty.c | 778 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 749 insertions(+), 29 deletions(-)

-- 
2.7.0

