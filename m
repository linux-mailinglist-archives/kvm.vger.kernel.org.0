Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8512234ECEC
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 17:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbhC3Px4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 11:53:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38527 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231874AbhC3Pxr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 11:53:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617119626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rYgQNLjVHnngvSqU3qLYS7/H7MWMszzM+TPhSVMqrdY=;
        b=H6NF7NnVCF85nI2xM73M0KtAkCV+p0mKCo3sdXjYY0xR+uRE4KcdZZhx7Vg9pQkNcli8E+
        liG9xgkMshrmra/6bML+4S0yM3AFl0LYF5sad6VperQf9CLMvITOubFX9odVHyPXCXd8AR
        KZ0nRprrryaGjCkghnSeMY4q1MCFBsc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-2YF_F8A1MxuNORgdzzy7IA-1; Tue, 30 Mar 2021 11:53:42 -0400
X-MC-Unique: 2YF_F8A1MxuNORgdzzy7IA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 442B7802B7E;
        Tue, 30 Mar 2021 15:53:40 +0000 (UTC)
Received: from gondolin (ovpn-113-155.ams2.redhat.com [10.36.113.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ACA2B10016DB;
        Tue, 30 Mar 2021 15:53:37 +0000 (UTC)
Date:   Tue, 30 Mar 2021 17:53:35 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dong Jia Shi <bjsdjshi@linux.vnet.ibm.com>,
        Neo Jia <cjia@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 09/18] vfio/mdev: Add missing error handling to
 dev_set_name()
Message-ID: <20210330175335.5bbd326f.cohuck@redhat.com>
In-Reply-To: <9-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
        <9-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Mar 2021 14:55:26 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This can fail, and seems to be a popular target for syzkaller error
> injection. Check the error return and unwind with put_device().
> 
> Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/mdev/mdev_core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

