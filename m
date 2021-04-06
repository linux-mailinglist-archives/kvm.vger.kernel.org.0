Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97A7355C3E
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 21:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242661AbhDFThw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 15:37:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40715 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242331AbhDFThu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 15:37:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617737861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L7OY+N2Q6/FRu9JVKctbQPu74TT+x5L6GqR5UhbmXrU=;
        b=DbRvzS9r+5KlxBWDpqX8VOenkJCXi39mwwmEqtDx3AP0sFdtr8Ki4brYGJC0CJ952Pzfco
        HoLgE45o5bui22Hgqm/DqkoWcmaf3XfEIsbu75NH/JWYtyheWYsXf+IJcPlI/taG29Fxa4
        tqx3Xsaj87FxQEoq0rbE/i3qMPnYJ4U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-4X-8dloyMCeIxWKJh8UVQQ-1; Tue, 06 Apr 2021 15:37:40 -0400
X-MC-Unique: 4X-8dloyMCeIxWKJh8UVQQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBE491007478;
        Tue,  6 Apr 2021 19:37:38 +0000 (UTC)
Received: from omen (ovpn-112-85.phx2.redhat.com [10.3.112.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56AEE17D04;
        Tue,  6 Apr 2021 19:37:38 +0000 (UTC)
Date:   Tue, 6 Apr 2021 13:37:28 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Fred Gao <fred.gao@intel.com>
Cc:     kvm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Swee Yee Fonn <swee.yee.fonn@intel.com>
Subject: Re: [PATCH v5] vfio/pci: Add support for opregion v2.1+
Message-ID: <20210406133728.23ecb592@omen>
In-Reply-To: <20210325170953.24549-1-fred.gao@intel.com>
References: <20210302130220.9349-1-fred.gao@intel.com>
        <20210325170953.24549-1-fred.gao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Mar 2021 01:09:53 +0800
Fred Gao <fred.gao@intel.com> wrote:

> Before opregion version 2.0 VBT data is stored in opregion mailbox #4,
> but when VBT data exceeds 6KB size and cannot be within mailbox #4
> then from opregion v2.0+, Extended VBT region, next to opregion is
> used to hold the VBT data, so the total size will be opregion size plus
> extended VBT region size.
> 
> Since opregion v2.0 with physical host VBT address would not be
> practically available for end user and guest can not directly access
> host physical address, so it is not supported.
> 
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Signed-off-by: Swee Yee Fonn <swee.yee.fonn@intel.com>
> Signed-off-by: Fred Gao <fred.gao@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_igd.c | 53 +++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)

Applied to vfio next branch for v5.13.  Thanks,

Alex

