Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B8626A17F
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 11:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgIOJGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 05:06:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43408 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726157AbgIOJGL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Sep 2020 05:06:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600160770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8NlAUI/3E3zNTeerG9TOujk5Z1icGeVixAzsrryh2bA=;
        b=bl5u+On+KIdQedEhb3/axbVgaT6ZYeBBvfAg7ICw5IvrD4E2sBNnxutTfHGLrECyChgPIr
        kjM4Xj/EUfEN37wAxAAVlg89DTaRJyQikTwmUos0EB7RxKKVYwO7pHOzF+4ltVlfQEijcf
        Ny7Zd2GSWJq1J3gRHERLE8sPWg8bNWA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-XK6CCgT9MTCQygJyT8g_ZQ-1; Tue, 15 Sep 2020 05:06:08 -0400
X-MC-Unique: XK6CCgT9MTCQygJyT8g_ZQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88EA364080;
        Tue, 15 Sep 2020 09:06:07 +0000 (UTC)
Received: from gondolin (ovpn-113-4.ams2.redhat.com [10.36.113.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE40F61462;
        Tue, 15 Sep 2020 09:06:03 +0000 (UTC)
Date:   Tue, 15 Sep 2020 11:06:01 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     alex.williamson@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: fix a missed vfio group put in vfio_pin_pages
Message-ID: <20200915110601.5adb7129.cohuck@redhat.com>
In-Reply-To: <20200915002835.14213-1-yan.y.zhao@intel.com>
References: <20200915002835.14213-1-yan.y.zhao@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Sep 2020 08:28:35 +0800
Yan Zhao <yan.y.zhao@intel.com> wrote:

> when error occurs, need to put vfio group after a successful get.
> 
> Fixes: 95fc87b44104 (vfio: Selective dirty page tracking if IOMMU backed
> device pins pages)

The format of the Fixes: line should be

Fixes: 95fc87b44104 ("vfio: Selective dirty page tracking if IOMMU backed device pins pages")

> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  drivers/vfio/vfio.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

