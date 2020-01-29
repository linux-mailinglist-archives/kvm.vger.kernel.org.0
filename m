Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7696314CADA
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 13:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgA2M3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 07:29:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45216 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726358AbgA2M3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 07:29:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580300946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D6pDmYXo35nTvtnL6PMZ8gTak+ufVaorXRiG1stOEQ8=;
        b=dHcCc9ouNtHlNDQUbBFOQPXbjsUAf7Np7MFDMveV1NwQ1EJ4G6KEZ0mJhnclLviH6GEJMN
        jBCehvbM1LWYXIhc/fG1J8KJnEedBz6FxUGwzOO3wMIPjd8HAQRRawzDHxBT3P4GEeLcZe
        xV+7sir5sOdO7aazBECBspch6j+KrDQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-db-xxJQnN2CgKUG7Yj58Qw-1; Wed, 29 Jan 2020 07:29:04 -0500
X-MC-Unique: db-xxJQnN2CgKUG7Yj58Qw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 829AB63ADB;
        Wed, 29 Jan 2020 12:29:02 +0000 (UTC)
Received: from gondolin (ovpn-116-225.ams2.redhat.com [10.36.116.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F67C5C545;
        Wed, 29 Jan 2020 12:28:44 +0000 (UTC)
Date:   Wed, 29 Jan 2020 13:28:41 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, david@gibson.dropbear.id.au,
        pbonzini@redhat.com, alex.williamson@redhat.com, peterx@redhat.com,
        mst@redhat.com, eric.auger@redhat.com, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        hao.wu@intel.com, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v3 07/25] header file update VFIO/IOMMU vSVA APIs
Message-ID: <20200129132841.6900963f.cohuck@redhat.com>
In-Reply-To: <1580300216-86172-8-git-send-email-yi.l.liu@intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
        <1580300216-86172-8-git-send-email-yi.l.liu@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 Jan 2020 04:16:38 -0800
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> From: Liu Yi L <yi.l.liu@intel.com>
> 
> The kernel uapi/linux/iommu.h header file includes the
> extensions for vSVA support. e.g. bind gpasid, iommu
> fault report related user structures and etc.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  linux-headers/linux/iommu.h | 372 ++++++++++++++++++++++++++++++++++++++++++++
>  linux-headers/linux/vfio.h  | 148 ++++++++++++++++++
>  2 files changed, 520 insertions(+)
>  create mode 100644 linux-headers/linux/iommu.h

Please add a note that this is to be replaced with a full headers
update, so that it doesn't get missed :)

