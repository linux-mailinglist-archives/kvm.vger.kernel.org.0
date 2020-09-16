Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D766226C0EB
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 11:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgIPJoO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 05:44:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29819 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726369AbgIPJoL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Sep 2020 05:44:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600249450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SFaZWPLKSCf3bE5hLnZDxFsTVIgAlxg96TUTz46i64w=;
        b=GURjBdA1XqOF9pxwQHHqvWA48WVnZO1/ZNT7V5Qozv64IehAapQOtGRlYkv227aTJ/K1sG
        O/DMSuarLpRTAMfW6KsuneHM+01ExM1DxLUeLDnkiReWQ4Nc47Yv5yUSmiNg8bSuET3+FS
        arnMDO4laLC+WENEFJ9NRDDuD2Li9XI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-0M9Tfb-_MIGuYoFDQeNTGg-1; Wed, 16 Sep 2020 05:44:07 -0400
X-MC-Unique: 0M9Tfb-_MIGuYoFDQeNTGg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E0CB1007469;
        Wed, 16 Sep 2020 09:44:05 +0000 (UTC)
Received: from gondolin (ovpn-112-252.ams2.redhat.com [10.36.112.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B77A819D6C;
        Wed, 16 Sep 2020 09:44:00 +0000 (UTC)
Date:   Wed, 16 Sep 2020 11:41:59 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, pmorel@linux.ibm.com,
        schnelle@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vfio iommu: Add dma available capability
Message-ID: <20200916114159.42e145fd.cohuck@redhat.com>
In-Reply-To: <1600196718-23238-2-git-send-email-mjrosato@linux.ibm.com>
References: <1600196718-23238-1-git-send-email-mjrosato@linux.ibm.com>
        <1600196718-23238-2-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Sep 2020 15:05:18 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Commit 492855939bdb ("vfio/type1: Limit DMA mappings per container")
> added the ability to limit the number of memory backed DMA mappings.
> However on s390x, when lazy mapping is in use, we use a very large
> number of concurrent mappings.  Let's provide the current allowable
> number of DMA mappings to userspace via the IOMMU info chain so that
> userspace can take appropriate mitigation.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 17 +++++++++++++++++
>  include/uapi/linux/vfio.h       | 15 +++++++++++++++
>  2 files changed, 32 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

