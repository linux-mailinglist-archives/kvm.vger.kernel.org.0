Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E42432C612
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343731AbhCDA1Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:27:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59344 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240655AbhCCMzo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 07:55:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614776041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=phjGiPJew5TRezHc2+4RPt/HOIfx3wRFjFpqFvuXHn0=;
        b=FaRgKl2t4KICFhFP78er5WQNRkClCDLxgBRNKB4nGo6CHNB0+ESmpBGmGruLCVhX2Z++ZJ
        dV2CjIwIbHfcazB7xpU5cYeINlU/Y6mEbxs8hp48+iZywWhxBDzL/9knZp/e6XTj3ahQaR
        6pfwsx8mPP3p43flwUKvDmG3elIfpro=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-oHINqaF3MNeWMYk8I8GTGQ-1; Wed, 03 Mar 2021 07:53:57 -0500
X-MC-Unique: oHINqaF3MNeWMYk8I8GTGQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFC141E563;
        Wed,  3 Mar 2021 12:53:56 +0000 (UTC)
Received: from gondolin (ovpn-113-85.ams2.redhat.com [10.36.113.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CDD55C559;
        Wed,  3 Mar 2021 12:53:52 +0000 (UTC)
Date:   Wed, 3 Mar 2021 13:53:49 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] vfio/type1: fix unmap all on ILP32
Message-ID: <20210303135349.52528851.cohuck@redhat.com>
In-Reply-To: <1614281102-230747-1-git-send-email-steven.sistare@oracle.com>
References: <1614281102-230747-1-git-send-email-steven.sistare@oracle.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Feb 2021 11:25:02 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Some ILP32 architectures support mapping a 32-bit vaddr within a 64-bit
> iova space.  The unmap-all code uses 32-bit SIZE_MAX as an upper bound on
> the extent of the mappings within iova space, so mappings above 4G cannot
> be found and unmapped.  Use U64_MAX instead, and use u64 for size variables.
> This also fixes a static analysis bug found by the kernel test robot running
> smatch for ILP32.
> 
> Fixes: 0f53afa12bae ("vfio/type1: unmap cleanup")
> Fixes: c19650995374 ("vfio/type1: implement unmap all")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

