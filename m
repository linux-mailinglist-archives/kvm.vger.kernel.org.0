Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D46428875A
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 12:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731963AbgJIKzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 06:55:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30114 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725931AbgJIKzP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Oct 2020 06:55:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602240915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2i1MoIYU2pprDaQRq07YqqO5ky2p75T9cZnh7NlcO4o=;
        b=XZucWe4SXlIDjEzB9/vyHS95AonxGcIQWkEHhvhEVPTRRd9ptpx7vwGcCn2ofL+OyHFA5X
        MQvonH2rIim9YBvIi7c3q/gymPWi7fiP817PWs5YEmkVkMP6xS/d/EiVYMHWsDv0nyIc5+
        MuIiEkj48/48NwCeBZBGYvv49avsgf4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-QceRA0JvMxOE8F3XEfiInw-1; Fri, 09 Oct 2020 06:55:11 -0400
X-MC-Unique: QceRA0JvMxOE8F3XEfiInw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCDA81084D64;
        Fri,  9 Oct 2020 10:55:09 +0000 (UTC)
Received: from gondolin (ovpn-113-40.ams2.redhat.com [10.36.113.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6617760BFA;
        Fri,  9 Oct 2020 10:54:58 +0000 (UTC)
Date:   Fri, 9 Oct 2020 12:54:55 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        rth@twiddle.net, david@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 07/10] s390x/pci: clean up s390 PCI groups
Message-ID: <20201009125455.3d9e2dc6.cohuck@redhat.com>
In-Reply-To: <1602097455-15658-8-git-send-email-mjrosato@linux.ibm.com>
References: <1602097455-15658-1-git-send-email-mjrosato@linux.ibm.com>
        <1602097455-15658-8-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  7 Oct 2020 15:04:12 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Add a step to remove all stashed PCI groups to avoid stale data between
> machine resets.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  hw/s390x/s390-pci-bus.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

