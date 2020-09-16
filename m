Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A3326C154
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 12:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgIPKB4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 06:01:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47618 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726781AbgIPKBY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 06:01:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600250483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b+BtD94FO8ZoxunpXlbSATsg5yugE548JCHe/T+26L4=;
        b=RE5vF2dUduubdzxrc+zaiG3kWWbdzr1WD1g9rAvLObtY1qENrPUMRRGK/Z2jqKZiWTkKyN
        2Aore36Rko9WSXEZ3MbmE5DkwHxLdqFplvk98tQQXQf3kow8oPbcFRkJVDMvqWhQgRJp3Z
        IIIqPvM4xkWJJnCNqODbCOe25/RC2QI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-i8KH1gPENEiL-uHX4p442Q-1; Wed, 16 Sep 2020 06:01:19 -0400
X-MC-Unique: i8KH1gPENEiL-uHX4p442Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5A19EA323;
        Wed, 16 Sep 2020 10:01:17 +0000 (UTC)
Received: from gondolin (ovpn-112-252.ams2.redhat.com [10.36.112.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBA2B75123;
        Wed, 16 Sep 2020 10:01:14 +0000 (UTC)
Date:   Wed, 16 Sep 2020 12:01:12 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, pmorel@linux.ibm.com,
        schnelle@linux.ibm.com, rth@twiddle.net, david@redhat.com,
        thuth@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 3/5] vfio: Find DMA available capability
Message-ID: <20200916120112.53604f46.cohuck@redhat.com>
In-Reply-To: <1600197283-25274-4-git-send-email-mjrosato@linux.ibm.com>
References: <1600197283-25274-1-git-send-email-mjrosato@linux.ibm.com>
        <1600197283-25274-4-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Sep 2020 15:14:41 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> The underlying host may be limiting the number of outstanding DMA
> requests for type 1 IOMMU.  Add helper functions to check for the
> DMA available capability and retrieve the current number of DMA
> mappings allowed.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  hw/vfio/common.c              | 31 +++++++++++++++++++++++++++++++
>  include/hw/vfio/vfio-common.h |  2 ++
>  2 files changed, 33 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

