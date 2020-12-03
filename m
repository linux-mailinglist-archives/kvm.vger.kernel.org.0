Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D465E2CDD15
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 19:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729321AbgLCSGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 13:06:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51163 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729068AbgLCSGw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 13:06:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607018726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dS5FZ2kyk8sGXYqm0Tj1dSWrX7o1D6D7qBWGkJ2jPUE=;
        b=A+ZY20vBSBBqHqQpgDWkrfxV0FipQzyj8OBH0+UuA9PCTttHQInxrhPNRRhN3mPcAM2AUC
        U056PVV0wdsmtefItKzVQs7ScDb+9QKq0uKvB4ZBL03SbQlpkinWKiD+zlQmoJN3WjMENJ
        Za2EieWjKPwILvYngYLDdOY8SfF+Y74=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-qT8c-9hvOLW9Fu3Q4Vax6w-1; Thu, 03 Dec 2020 13:05:22 -0500
X-MC-Unique: qT8c-9hvOLW9Fu3Q4Vax6w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3EC46800D55;
        Thu,  3 Dec 2020 18:05:21 +0000 (UTC)
Received: from w520.home (ovpn-112-10.phx2.redhat.com [10.3.112.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEC955C1CF;
        Thu,  3 Dec 2020 18:05:17 +0000 (UTC)
Date:   Thu, 3 Dec 2020 11:05:17 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v1 2/5] vfio: platform: Switch to use
 platform_get_mem_or_io_resource()
Message-ID: <20201203110517.156ba3c1@w520.home>
In-Reply-To: <20201027175806.20305-2-andriy.shevchenko@linux.intel.com>
References: <20201027175806.20305-1-andriy.shevchenko@linux.intel.com>
        <20201027175806.20305-2-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 27 Oct 2020 19:58:03 +0200
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> Switch to use new platform_get_mem_or_io_resource() instead of
> home grown analogue.
> 
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/vfio/platform/vfio_platform.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)

Acked-by: Alex Williamson <alex.williamson@redhat.com>

