Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6284B193D41
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 11:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgCZKt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 06:49:56 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:57983 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726338AbgCZKtz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Mar 2020 06:49:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585219794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uAOE0B/1U0YpiEe7/I1rRfCCdwWWpmdQewQN0rqMhdY=;
        b=Ib5zDSxWwBLS9m/zn16J25+p0NZWbxFUw7khr4armY7NtmCgpqkL+vOx9pnZKXjNXI57+J
        H55YCWg7rFIz6UmqOI4DGUQdCzEo/KA9fNDip+Gs5ktxGQes3jGj6hrv2EkLFEbXrrHg3V
        QR6KcfUZjzfCbjNsoaTgK4Tz6QzjTlk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-bNmrdSRpPRK2enNHNeoTmQ-1; Thu, 26 Mar 2020 06:49:51 -0400
X-MC-Unique: bNmrdSRpPRK2enNHNeoTmQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA140189F760;
        Thu, 26 Mar 2020 10:49:48 +0000 (UTC)
Received: from gondolin (ovpn-112-191.ams2.redhat.com [10.36.112.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D4911BC6D;
        Thu, 26 Mar 2020 10:49:40 +0000 (UTC)
Date:   Thu, 26 Mar 2020 11:49:35 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     <alex.williamson@redhat.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v16 Kernel 2/7] vfio iommu: Remove atomicity of
 ref_count of pinned pages
Message-ID: <20200326114935.4e729fba.cohuck@redhat.com>
In-Reply-To: <1585078359-20124-3-git-send-email-kwankhede@nvidia.com>
References: <1585078359-20124-1-git-send-email-kwankhede@nvidia.com>
        <1585078359-20124-3-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 25 Mar 2020 01:02:34 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> vfio_pfn.ref_count is always updated by holding iommu->lock, using atomic

s/by/while/

> variable is overkill.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

