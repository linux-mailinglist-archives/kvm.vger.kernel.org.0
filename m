Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB553B60B3
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 16:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbhF1O2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 10:28:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21630 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233386AbhF1O0P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 10:26:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624890229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gS97gb30cUD6A4GFBfFHF0i2JBykL2d9ZYSKCC/RISc=;
        b=fOs6PnbEn2MbLCZWRamMdPCsvnGnxOwh7wVZXYNHylK0Z3fQsy+oR6Dhc8yh5g8CeJV4w4
        cdyzX4bMi3t+zkQN0SZdnxSHBfNIAE0syssdtJLKAc2LbCfUyUXvO/O14zdVSMIt4K6sLA
        GFXBz6A2RDMQPt8kTptZ1k6ylibCTFA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-uRlX0CkpPIC1JOWAJN4THw-1; Mon, 28 Jun 2021 10:23:37 -0400
X-MC-Unique: uRlX0CkpPIC1JOWAJN4THw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA0DD81CCB4;
        Mon, 28 Jun 2021 14:23:05 +0000 (UTC)
Received: from localhost (ovpn-112-191.ams2.redhat.com [10.36.112.191])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DBFD5C1D0;
        Mon, 28 Jun 2021 14:23:05 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        alex.williamson@redhat.com
Cc:     kwankhede@nvidia.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com
Subject: Re: [PATCH] vfio/mtty: Enforce available_instances
In-Reply-To: <162465624894.3338367.12935940647049917981.stgit@omen>
Organization: Red Hat GmbH
References: <162465624894.3338367.12935940647049917981.stgit@omen>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Mon, 28 Jun 2021 16:23:03 +0200
Message-ID: <875yxym5ko.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 25 2021, Alex Williamson <alex.williamson@redhat.com> wrote:

> The sample mtty mdev driver doesn't actually enforce the number of
> device instances it claims are available.  Implement this properly.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>
> Applies to vfio next branch + Jason's atomic conversion
>
>  samples/vfio-mdev/mtty.c |   22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
>

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

