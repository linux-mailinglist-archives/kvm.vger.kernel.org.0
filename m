Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718B541E294
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 22:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347131AbhI3USg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 16:18:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50951 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229745AbhI3USf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Sep 2021 16:18:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633033011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eusVO5LfXa7mGn2GpNRhygQHQtLSModaJSWwgqV4gTY=;
        b=bZLh4+pWd0FMegM5fHWxNlGbmNIzpVCGYOM3SzUiB0IlobzlSGOB+OHqp3G9igcdYQaXVs
        ikDt9mVk3I/8t2SwfA7UexkU7Urbjd3uLWRiFIO2e2iBZMUHIyPTqSbUgBLFbcNXg4yv3/
        ssMCNZGcp+Vlk4Y2pCiyNVvLxWgfxas=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-CuQxaxHUMoij0NiEtzHjpA-1; Thu, 30 Sep 2021 16:16:50 -0400
X-MC-Unique: CuQxaxHUMoij0NiEtzHjpA-1
Received: by mail-oo1-f69.google.com with SMTP id j26-20020a4a92da000000b002a80a30e964so5539499ooh.13
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 13:16:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eusVO5LfXa7mGn2GpNRhygQHQtLSModaJSWwgqV4gTY=;
        b=UGOz0MAt2pvPr0W1Hy7299APIzGxppP+UjRXbAnCTbZhZZEoIgPwOeQu09tXXCAjR+
         9zUQD9wkJ2J3Ocgm3l58Yk/tsdR/pYSZR4CTWcpj6fl4NwqTR9MNoZUz8TBQH1wtOynt
         MKCnK1+YVm0Bm16VOatu/lxSo5YjW+SyuS+hRWh75uO5QC7UPL/fjnem9ss7uYhNqKYa
         wXrwKlaikgazhHdA+AhEPmzfwF7CJg7HLcZGSH/EG8mVTymm8ZnjU3ZSSYmmHplCPXJ4
         9pgCiIkWF+JprfUUUuxlBq1njuY0RACZdNpdgOjTabcdQrp/tcosg9ELkKjnmoeUJmk8
         qHMw==
X-Gm-Message-State: AOAM532337W4SoSijGa2Cm153Aojo7K1VfS/ncwACMuRi/qY5WhH2PIe
        NaclVxxIuISMcbZ6seWDp9xG5jORoGinqT/3I6scxNq+Za0OtroWi+gUoCIS7dLvhJP2wXjAfPS
        k3cOPgx3nMVuo
X-Received: by 2002:a9d:75c2:: with SMTP id c2mr7035569otl.230.1633033009749;
        Thu, 30 Sep 2021 13:16:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxd08YQO3eMRP21dr1GQbLtvUPJPDju2LEHcSf7wzmDZVO6QAav4UgGs+SVgi6eokKZp9HtEw==
X-Received: by 2002:a9d:75c2:: with SMTP id c2mr7035549otl.230.1633033009518;
        Thu, 30 Sep 2021 13:16:49 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id h1sm796313otm.45.2021.09.30.13.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 13:16:49 -0700 (PDT)
Date:   Thu, 30 Sep 2021 14:16:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Terrence Xu <terrence.xu@intel.com>, kvm@vger.kernel.org
Subject: Re: cleanup vfio iommu_group creation v6
Message-ID: <20210930141647.54a28088.alex.williamson@redhat.com>
In-Reply-To: <20210924155705.4258-1-hch@lst.de>
References: <20210924155705.4258-1-hch@lst.de>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Sep 2021 17:56:50 +0200
Christoph Hellwig <hch@lst.de> wrote:

> Hi Alex,
> 
> this series cleans up how iommu group are created in VFIO as well as
> various other lose ends around that.
> 
> Changes since v5:
>  - update a ommit messag
>  - move a hunk into the correct patch
>  - add a new patch to initialize pgsize_bitmap to ULONG_MAX in ->open

Applied to vfio next branch for v5.16 with PAGE_MASK change discussed
in patch 13.  Thanks,

Alex

