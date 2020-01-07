Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2593B132200
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 10:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgAGJOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 04:14:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43515 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727715AbgAGJOS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 04:14:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578388458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mzHsx/Rrd3lLiiC7W87+hNI2uYZ3BAUjcjxT/JMbIlA=;
        b=ftV4kYU2/k6g14FEgGqhi709qQHZj1fkD2EVZcixEhz25be+ddsCA0O1eZYi+s9wpvxPLW
        +UKvbtjURSiBkxfK/R4p8yJReBbOZDKfgsBmJOH+pFjOpBOkTiuFh5YlLgyLixxThsfw81
        XG65NEOU0JqJhleQSNOJedISVGOZZDk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126--LRj-Qx8NKOoRGZjA9y0Xw-1; Tue, 07 Jan 2020 04:14:12 -0500
X-MC-Unique: -LRj-Qx8NKOoRGZjA9y0Xw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3644F801E6C;
        Tue,  7 Jan 2020 09:14:11 +0000 (UTC)
Received: from gondolin (ovpn-117-222.ams2.redhat.com [10.36.117.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63B501C4;
        Tue,  7 Jan 2020 09:14:07 +0000 (UTC)
Date:   Tue, 7 Jan 2020 10:14:04 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        kernel-janitors@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] vfio: vfio_pci_nvlink2: use mmgrab
Message-ID: <20200107101404.340a3442.cohuck@redhat.com>
In-Reply-To: <1577634178-22530-3-git-send-email-Julia.Lawall@inria.fr>
References: <1577634178-22530-1-git-send-email-Julia.Lawall@inria.fr>
        <1577634178-22530-3-git-send-email-Julia.Lawall@inria.fr>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 29 Dec 2019 16:42:56 +0100
Julia Lawall <Julia.Lawall@inria.fr> wrote:

> Mmgrab was introduced in commit f1f1007644ff ("mm: add new mmgrab()
> helper") and most of the kernel was updated to use it. Update a
> remaining file.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> <smpl>
> @@ expression e; @@
> - atomic_inc(&e->mm_count);
> + mmgrab(e);
> </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> 
> ---
>  drivers/vfio/pci/vfio_pci_nvlink2.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

