Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7A830A88D
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 14:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhBANVU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 08:21:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51141 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232040AbhBANTk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 08:19:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612185489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zq7qsOfq6BB1QZ7TOSrlMLNPrf87AgDEV4yE8gwms5w=;
        b=bYBf54r5ThehPlZ2qHKr6RX1YvKLrofgqllsnI6IjifrGMD2ocaIUF557Q38nm3PnT7i3T
        iM+4RwPHrbwXM2EbT5z8AzfgPjgVLEAmfTt5UVA0vn1vaXCABoZNW9aKO0KH1leo2v+7iU
        WpWkMODu+55Mw312qvGVXpv4WmBEBug=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413--bsU7VZKPxO-be7fk9o6AQ-1; Mon, 01 Feb 2021 08:18:07 -0500
X-MC-Unique: -bsU7VZKPxO-be7fk9o6AQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58380835DE4;
        Mon,  1 Feb 2021 13:18:06 +0000 (UTC)
Received: from gondolin (ovpn-113-126.ams2.redhat.com [10.36.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A10699D4E;
        Mon,  1 Feb 2021 13:18:01 +0000 (UTC)
Date:   Mon, 1 Feb 2021 14:17:59 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V3 7/9] vfio: iommu driver notify callback
Message-ID: <20210201141759.282316c4.cohuck@redhat.com>
In-Reply-To: <1611939252-7240-8-git-send-email-steven.sistare@oracle.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
        <1611939252-7240-8-git-send-email-steven.sistare@oracle.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Jan 2021 08:54:10 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Define a vfio_iommu_driver_ops notify callback, for sending events to
> the driver.  Drivers are not required to provide the callback, and
> may ignore any events.  The handling of events is driver specific.
> 
> Define the CONTAINER_CLOSE event, called when the container's file
> descriptor is closed.  This event signifies that no further state changes
> will occur via container ioctl's.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio.c  | 5 +++++
>  include/linux/vfio.h | 5 +++++
>  2 files changed, 10 insertions(+)

For the version in Alex' git branch:

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

