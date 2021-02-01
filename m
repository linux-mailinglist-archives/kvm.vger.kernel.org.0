Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FCD30A6E0
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 12:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhBALw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 06:52:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47921 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229609AbhBALwZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 06:52:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612180259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UfWT8NBa3Z8EcBGImJFEzi/n2eKZb9k3BSqSQscMvIo=;
        b=PZ0TrpadUR4KJx94CWiBL6lwdIkmD29fwsDxTW/jTnQm1GId4Q6VBR/0RwnVrgRi61oDxO
        kHPhDu2//2qPqUFGiBVImtjvvKw+kkVWwE37M/qep7qy3p4b/UpvfRrpAOD+Buo0FrDg+n
        zzwBV8PMobo3Bcekze+rbaLktG4eS8U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-qJZRGFGLMmmE9AR43aKarQ-1; Mon, 01 Feb 2021 06:50:57 -0500
X-MC-Unique: qJZRGFGLMmmE9AR43aKarQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A838107ACE4;
        Mon,  1 Feb 2021 11:50:56 +0000 (UTC)
Received: from gondolin (ovpn-113-126.ams2.redhat.com [10.36.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43ECF10013C0;
        Mon,  1 Feb 2021 11:50:52 +0000 (UTC)
Date:   Mon, 1 Feb 2021 12:50:49 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V3 2/9] vfio/type1: unmap cleanup
Message-ID: <20210201125049.5e82fb0b.cohuck@redhat.com>
In-Reply-To: <1611939252-7240-3-git-send-email-steven.sistare@oracle.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
        <1611939252-7240-3-git-send-email-steven.sistare@oracle.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Jan 2021 08:54:05 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Minor changes in vfio_dma_do_unmap to improve readability, which also
> simplify the subsequent unmap-all patch.  No functional change.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 38 +++++++++++++++-----------------------
>  1 file changed, 15 insertions(+), 23 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

