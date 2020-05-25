Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED2C1E1095
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 16:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390911AbgEYObT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 10:31:19 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43745 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725809AbgEYObT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 May 2020 10:31:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590417077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qtVdMEs5mGMG8jYfIEbIaxy/lAqV2cE34Qd0SGuHDWw=;
        b=LdN0Q2rIdlVoaaAnW5bDuhQGaeWrPNoDtyMWUoUTYZPH0+FsFB6BBRvvmSZTXXZUsKWtCQ
        VIvvzUq5KtUUccnGTYdPB8q+BvzsZWU4UD0XOEXgnOJbHFsUIwjZr4UDM49qmB2L1cyeMk
        g7PrRQF/mmAb94+31iGR8bc8jF4M3oE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-P3iPhbUtOOeDqny5105p-g-1; Mon, 25 May 2020 10:31:13 -0400
X-MC-Unique: P3iPhbUtOOeDqny5105p-g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EA761009441;
        Mon, 25 May 2020 14:31:10 +0000 (UTC)
Received: from gondolin (ovpn-112-215.ams2.redhat.com [10.36.112.215])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CDB45798D;
        Mon, 25 May 2020 14:31:00 +0000 (UTC)
Date:   Mon, 25 May 2020 16:30:57 +0200
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
Subject: Re: [PATCH Kernel v23 1/8] vfio: UAPI for migration interface for
 device state
Message-ID: <20200525163057.21dd789c.cohuck@redhat.com>
In-Reply-To: <1589998088-3250-2-git-send-email-kwankhede@nvidia.com>
References: <1589998088-3250-1-git-send-email-kwankhede@nvidia.com>
        <1589998088-3250-2-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 May 2020 23:38:01 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> - Defined MIGRATION region type and sub-type.
> 
> - Defined vfio_device_migration_info structure which will be placed at the
>   0th offset of migration region to get/set VFIO device related
>   information. Defined members of structure and usage on read/write access.
> 
> - Defined device states and state transition details.
> 
> - Defined sequence to be followed while saving and resuming VFIO device.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 228 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 228 insertions(+)

Looks sane to me now.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

