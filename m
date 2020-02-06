Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2476154532
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 14:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgBFNpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 08:45:21 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28626 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727361AbgBFNpV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 08:45:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580996720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NDU1pecxlc+BOyhBmEht8Gi+UsDhBE70bSJ3aCURxjY=;
        b=BINwRiA955dn+mQmP5Yzz/eHLrv1JZ17Wmy7/cGbr0CMDtE2lORWkr+c/GIofGkI4m7/W4
        albqPN0qG5tgRQfOQfyFM/DKhQwz1P4jiXmiPKkJ41WIlthe4ZwVPmwoz/ankKLjuMp0Sj
        4N9dokfZfQVdVzC6HGuyBmby4jYQ4FQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-_j4sQ72kNc6cDjhpHwN4kA-1; Thu, 06 Feb 2020 08:45:16 -0500
X-MC-Unique: _j4sQ72kNc6cDjhpHwN4kA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 059468024DB;
        Thu,  6 Feb 2020 13:45:15 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1BE484DB4;
        Thu,  6 Feb 2020 13:45:09 +0000 (UTC)
Date:   Thu, 6 Feb 2020 14:45:06 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dev@dpdk.org, mtosatti@redhat.com,
        thomas@monjalon.net, bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com
Subject: Re: [RFC PATCH 6/7] vfio/pci: Remove dev_fmt definition
Message-ID: <20200206144506.178ba10a.cohuck@redhat.com>
In-Reply-To: <158085758432.9445.12129266614127683867.stgit@gimli.home>
References: <158085337582.9445.17682266437583505502.stgit@gimli.home>
        <158085758432.9445.12129266614127683867.stgit@gimli.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 04 Feb 2020 16:06:24 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> It currently results in messages like:
> 
>  "vfio-pci 0000:03:00.0: vfio_pci: ..."
> 
> Which is quite a bit redundant.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 026308aa18b5..343fe38ed06b 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -9,7 +9,6 @@
>   */
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> -#define dev_fmt pr_fmt
>  
>  #include <linux/device.h>
>  #include <linux/eventfd.h>
> 

Yes, that looks a bit superfluous.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

