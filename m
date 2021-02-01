Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D27630B1B9
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 21:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhBAUte (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 15:49:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51745 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230179AbhBAUtc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 15:49:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612212486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dx+a2s/jKD+bm6v2qBtcJrio8FJGKN2zZWR18xESCUE=;
        b=b4DrEK7TIJCFrG2m/R85vxXAiX4EWmDVfvIqu/DnQCX48IWIss2cnjrHEmytkBBjX/y/ba
        WJNeIG7g4YyVutdPKiV7mgSleJX6DGg0KNBF1cKTOn0k/YvUdahTQ4n7V2TiD31Z/RyJSC
        gs2kL5Acb5zVjpHrD115/etUi9JPti4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-8dV7A_cmM-igASv8WzLAfg-1; Mon, 01 Feb 2021 15:48:02 -0500
X-MC-Unique: 8dV7A_cmM-igASv8WzLAfg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89FEC10054FF;
        Mon,  1 Feb 2021 20:47:59 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D80260877;
        Mon,  1 Feb 2021 20:47:58 +0000 (UTC)
Date:   Mon, 1 Feb 2021 13:47:57 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, gmataev@nvidia.com, cjia@nvidia.com,
        yishaih@nvidia.com, aik@ozlabs.ru
Subject: Re: [PATCH 6/9] vfio-pci/zdev: fix possible segmentation fault
 issue
Message-ID: <20210201134757.375c91bf@omen.home.shazbot.org>
In-Reply-To: <139adb14-f75a-25ef-06da-e87729c2ccf2@linux.ibm.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
        <20210201162828.5938-7-mgurtovoy@nvidia.com>
        <20210201175214.0dc3ba14.cohuck@redhat.com>
        <139adb14-f75a-25ef-06da-e87729c2ccf2@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 1 Feb 2021 12:08:45 -0500
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 2/1/21 11:52 AM, Cornelia Huck wrote:
> > On Mon, 1 Feb 2021 16:28:25 +0000
> > Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
> >   
> >> In case allocation fails, we must behave correctly and exit with error.
> >>
> >> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>  
> > 
> > Fixes: e6b817d4b821 ("vfio-pci/zdev: Add zPCI capabilities to VFIO_DEVICE_GET_INFO")
> > 
> > Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> > 
> > I think this should go in independently of this series. >  
> 
> Agreed, makes sense to me -- thanks for finding.
> 
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

I can grab this one, and 5/9.  Connie do you want to toss an R-b at
5/9?  Thanks,

Alex

