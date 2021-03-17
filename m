Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC83E33EE66
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 11:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhCQKhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 06:37:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49609 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230150AbhCQKhJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Mar 2021 06:37:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615977429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nW+e4W6mUgw7b+Ffenh9YMPc5/TxvG+oZhsdeRzO8Zw=;
        b=dSlokIaqnwU/yAskUxbnEakZxyjNY6hur2IcAq1OPcps/9noQFbTBAR7dFffUCwvNu9SiO
        kE3wt2vEW2cSPiBCl2wIuqF3z3btTkg/YdmiGkK/X4u6BpoZfjV6yewoI3XMjAiRTq5gWV
        OzEfMFWUG4/XiwbHDpdigRrYm973byU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-JmeAbd6eNI-k4-3bEcmjwg-1; Wed, 17 Mar 2021 06:37:05 -0400
X-MC-Unique: JmeAbd6eNI-k4-3bEcmjwg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8AC6381621;
        Wed, 17 Mar 2021 10:37:03 +0000 (UTC)
Received: from gondolin (ovpn-113-255.ams2.redhat.com [10.36.113.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3EA073805;
        Wed, 17 Mar 2021 10:36:58 +0000 (UTC)
Date:   Wed, 17 Mar 2021 11:36:55 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 11/14] vfio/mdev: Make to_mdev_device() into a static
 inline
Message-ID: <20210317113655.7a446fd0.cohuck@redhat.com>
In-Reply-To: <11-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <11-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Mar 2021 20:56:03 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> The macro wrongly uses 'dev' as both the macro argument and the member
> name, which means it fails compilation if any caller uses a word other
> than 'dev' as the single argument. Fix this defect by making it into
> proper static inline, which is more clear and typesafe anyhow.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/mdev/mdev_private.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

