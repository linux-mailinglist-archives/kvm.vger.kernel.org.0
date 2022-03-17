Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF6B4DCAB3
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 17:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236316AbiCQQFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 12:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234177AbiCQQFO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 12:05:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D514BDFDC1
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 09:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647533035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pjpbf4xeM/d+LM74P4hgb4mVXuo4YOMoiMQxJouuPr4=;
        b=X0ChvJjlhVjqxMhjFT7LcHOMwfBGTky/v3uA1YaNuMJZtwxRmKAx4jivP/xiAJTPaeO6kk
        q0kplx0YrRSA1Cpg7TMew1OAh4bKu4P4zVF/gFeOoV7I9mCYLgY6Vt/nMKG0ulAUOgblvU
        F6AAFImM0qCfN8poK/a8nJuMzIeSFMo=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-tfXn46dVN2-g7qvOH43r0A-1; Thu, 17 Mar 2022 12:03:54 -0400
X-MC-Unique: tfXn46dVN2-g7qvOH43r0A-1
Received: by mail-io1-f71.google.com with SMTP id k10-20020a5d91ca000000b006414a00b160so3397832ior.18
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 09:03:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=pjpbf4xeM/d+LM74P4hgb4mVXuo4YOMoiMQxJouuPr4=;
        b=lW8rhcqP+pYWzHPS2kVtd3JN/KpEBI9m1pG0dW7eq4XQfG8Fl1weAb+z0KSpRWBdMX
         JuEUHwCyKtcfYRO3mKRsqH85vyjWLtWi91MOiLmfYUynHIlw1w1I4I7i+gllNqie6FEV
         3aqHtASa7lThtD8AWPd1Hb1463G3XzR3AhntWtl7tCX5/hqUXN44kUVczeC5I2SLWSN4
         sFC8sTVirosUovY3LhmejTMSx2C5do2kmMxKJE8NKumZwY0De+xUk2DsBV4Vsb0x9xP2
         K9JuGj0MBpXPTvr2HFx9b7SfiPkz6IzRHBdVCUEDxSmZoIL89ukkIJbHROEy5PvY4r/G
         2CXQ==
X-Gm-Message-State: AOAM5336TzAbSP+PimeELZpqyvTGzGktSgLEHV+m+9ZPTptT/Yqvv40E
        F4vf8jRxkYu8dljNJLJ+OTRpB3rC10gAWvIW2vkDb6yxtIn4uXvPM1Qu0DMNzirdIhqIf4uv8Ft
        yKgVPWz+tnJVF
X-Received: by 2002:a92:3609:0:b0:2c6:3595:2a25 with SMTP id d9-20020a923609000000b002c635952a25mr2567390ila.233.1647533033510;
        Thu, 17 Mar 2022 09:03:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3aHgYME/n6/Qs0XoLrfeBnvVUU0JQGkqMW+0T1bGE3wtNnjJnVWb0pfCfy3PJe1ny3h/xrA==
X-Received: by 2002:a92:3609:0:b0:2c6:3595:2a25 with SMTP id d9-20020a923609000000b002c635952a25mr2567374ila.233.1647533033326;
        Thu, 17 Mar 2022 09:03:53 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id k4-20020a5e9304000000b00640dfe71dc8sm2873858iom.46.2022.03.17.09.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 09:03:53 -0700 (PDT)
Date:   Thu, 17 Mar 2022 10:03:51 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        yishaih@nvidia.com, linux-doc@vger.kernel.org, corbet@lwn.net,
        hch@infradead.org
Subject: Re: [PATCH v4] vfio-pci: Provide reviewers and acceptance criteria
 for variant drivers
Message-ID: <20220317100351.344e699a.alex.williamson@redhat.com>
In-Reply-To: <164736509088.181560.2887686123582116702.stgit@omen>
References: <164736509088.181560.2887686123582116702.stgit@omen>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Mar 2022 11:29:57 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> Device specific extensions for devices exposed to userspace through
> the vfio-pci-core library open both new functionality and new risks.
> Here we attempt to provided formalized requirements and expectations
> to ensure that future drivers both collaborate in their interaction
> with existing host drivers, as well as receive additional reviews
> from community members with experience in this area.
> 
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Acked-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> Acked-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
...> 
>  Documentation/driver-api/index.rst                 |    1 +
>  .../vfio-pci-device-specific-driver-acceptance.rst |   35 ++++++++++++++++++++
>  .../maintainer/maintainer-entry-profile.rst        |    1 +
>  MAINTAINERS                                        |   10 ++++++
>  4 files changed, 47 insertions(+)
>  create mode 100644 Documentation/driver-api/vfio-pci-device-specific-driver-acceptance.rst

Applied to vfio next branch for v5.18 with Jason and Connie's sign-offs.
Thanks,

Alex

