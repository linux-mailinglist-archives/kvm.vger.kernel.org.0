Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFDAE5AB875
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 20:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiIBSnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 14:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiIBSnH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 14:43:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D6C112EF1
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 11:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662144184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1nd4P68uBzLxzSF6eGPfN8amzg0r15taaZBfhWhybWk=;
        b=AXENKOoEBxMS0VYcLVDk9HHRLzYAsOfs6cSvBTATuqhkMc7mtYdZKrJ30ckm+vIY2YHx9a
        GDrEoY6b5CZxrujxYfC4MgPbddRZ3KFEJuDizWKKAjIKqQoTYQHHc5tMkm+OWx7MMPD+Nz
        IuLUzsY33TJuosasvPdKHdv01hURRjI=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-625-3ONy5ynBNbK7Irg0hnDTbA-1; Fri, 02 Sep 2022 14:43:03 -0400
X-MC-Unique: 3ONy5ynBNbK7Irg0hnDTbA-1
Received: by mail-il1-f199.google.com with SMTP id o2-20020a056e0214c200b002eb8acbd27cso2370824ilk.22
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 11:43:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=1nd4P68uBzLxzSF6eGPfN8amzg0r15taaZBfhWhybWk=;
        b=V3c1y/c9V4WEvHvrUOLCMBAZA1Z/quemDSzr+u+KupHmlWS81OHcrdfFwkb4An0h3u
         NHjRwC794mWojAPox7DbFZE+5Dfo+2P+XRoX8A4ridey591XfcZZdNM3NQyNFWRjhQLa
         MPmrkNyVXXDzHz0i2xYoAdrqE1KPQws76WOvyV6py4paCVITmXokR2QBRs9kYpPolWbe
         EbgVeCRAjAOwBokxzLJGP+59ldNgG6v4nrmM1bfX17nF2Z+cqBnxsByOu5GKiDAgP5YN
         /glACq2jpmaSBJ3HkGPp7hBoGPsHW8NYrwgdkTZux83n73sOL2/mMP0Y2CGp1C9c+gBo
         WwOw==
X-Gm-Message-State: ACgBeo1p3oG7dsHqZBjGWiMmIQPu2YHIKAbdwOE+U9gfJXiMTdTPLjO5
        WAjUkoSyoKiyF+cri6bGzXqbb+mJMQlkPjTqVTI0TmfXwChLUsz4DBsCJZz+aV0QU8rZCfdcNaN
        UMuVqriox9sij
X-Received: by 2002:a02:c014:0:b0:34c:dec:1e10 with SMTP id y20-20020a02c014000000b0034c0dec1e10mr7344932jai.99.1662144182700;
        Fri, 02 Sep 2022 11:43:02 -0700 (PDT)
X-Google-Smtp-Source: AA6agR65teln+MSqeLxq5ZwVuLQUgTCZQYYRkVzx9NixYTzTJQaDUYxUmsamBNnsQIuMukAj7e3hCA==
X-Received: by 2002:a02:c014:0:b0:34c:dec:1e10 with SMTP id y20-20020a02c014000000b0034c0dec1e10mr7344926jai.99.1662144182541;
        Fri, 02 Sep 2022 11:43:02 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x6-20020a056602160600b0067b7a057ee8sm1126680iow.25.2022.09.02.11.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 11:43:02 -0700 (PDT)
Date:   Fri, 2 Sep 2022 12:42:35 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v2] vfio: Remove vfio_group dev_counter
Message-ID: <20220902124235.46794868.alex.williamson@redhat.com>
In-Reply-To: <0-v2-d4374a7bf0c9+c4-vfio_dev_counter_jgg@nvidia.com>
References: <0-v2-d4374a7bf0c9+c4-vfio_dev_counter_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Aug 2022 16:13:04 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This counts the number of devices attached to a vfio_group, ie the number
> of items in the group->device_list.
> 
> It is only read in vfio_pin_pages(), as some kind of protection against
> limitations in type1.
> 
> However, with all the code cleanups in this area, now that
> vfio_pin_pages() accepts a vfio_device directly it is redundant.  All
> drivers are already calling vfio_register_emulated_iommu_dev() which
> directly creates a group specifically for the device and thus it is
> guaranteed that there is a singleton group.
> 
> Leave a note in the comment about this requirement and remove the logic.
> 
> Reviewed-by: Yi Liu <yi.l.liu@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio_main.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)

Applied to vfio next branch for v6.1.  Thanks,

Alex

