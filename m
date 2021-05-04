Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD85372D8E
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 18:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhEDQHq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 12:07:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48188 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230501AbhEDQHn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 12:07:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620144408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GVIxTT9uSFfUO3j3YO7sGQ1PTKDOjdIH+lYA0YgyIyA=;
        b=dycdF2qfxM8IDOjcyT5dLckHXobifrVzvi1XMcrJcXoY7l33XxFth5lB/vlpctVH8cqZ9D
        fwtoH6Br8bf6dPnOOOOowwYpuxq2AyCETLBFJSL6Tabwguygo7XVz+60soI/L7CnceH9uG
        QjbhscPjEyklitlvQ07trZQmahML5R4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-I7M62cUEMh-U8VfpQ2FvKw-1; Tue, 04 May 2021 12:06:46 -0400
X-MC-Unique: I7M62cUEMh-U8VfpQ2FvKw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF23E107ACCA;
        Tue,  4 May 2021 16:06:44 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-126.ams2.redhat.com [10.36.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C81219C71;
        Tue,  4 May 2021 16:06:39 +0000 (UTC)
Date:   Tue, 4 May 2021 18:06:36 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, groug@kaod.org, hch@lst.de,
        gregkh@linuxfoundation.org, daniel@ffwll.ch,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        qemu-devel@nongnu.org, linuxppc-dev@lists.ozlabs.org,
        qemu-ppc@nongnu.org
Subject: Re: [PATCH] vfio/pci: Revert nvlink removal uAPI breakage
Message-ID: <20210504180636.6251eaf1.cohuck@redhat.com>
In-Reply-To: <162014341432.3807030.11054087109120670135.stgit@omen>
References: <162014341432.3807030.11054087109120670135.stgit@omen>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 04 May 2021 09:52:02 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> Revert the uAPI changes from the below commit with notice that these
> regions and capabilities are no longer provided.
> 
> Fixes: b392a1989170 ("vfio/pci: remove vfio_pci_nvlink2")
> Reported-by: Greg Kurz <groug@kaod.org>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> Greg (Kurz), please double check this resolves the issue.  Thanks!
> 
>  include/uapi/linux/vfio.h |   46 +++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 42 insertions(+), 4 deletions(-)

I had already hacked up a QEMU patch that moved the definitions into
local headers, but this one is less of a hassle. (Code compiles fine
after doing a headers update.)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

