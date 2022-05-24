Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31777532EA0
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 18:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239640AbiEXQIF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 12:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239711AbiEXQH4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 12:07:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C37D96F483
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 09:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653408464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4LwcXrIKv9x0Mf2x0EaHmSXiWcvTYj/VJq4XvycqoUs=;
        b=b8dNzZPL+P/etSr5vjwIuHCmlldTfc4lIL381bO2FOslDAAC33IpogUI+iYMNJv02H634d
        H5GiJvyhGfIqzQt9JVK3GHiFhWZIOh7jayO0PI1b4uuTnU85mkb231eS/AtjMhMtMg+UYv
        j7q72G+bjdlVlTyjA4hubmj2pj1eLfM=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-251-rXpjJ8lrMZWX0hr1Kcbrsg-1; Tue, 24 May 2022 12:07:42 -0400
X-MC-Unique: rXpjJ8lrMZWX0hr1Kcbrsg-1
Received: by mail-il1-f197.google.com with SMTP id q15-20020a056e0220ef00b002d15dcd2750so9929815ilv.1
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 09:07:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=4LwcXrIKv9x0Mf2x0EaHmSXiWcvTYj/VJq4XvycqoUs=;
        b=B0YUxAuEw7tjm9+2c+OZB7airH+8hFmWyQGuYW/T4XAZP4v6tmVzUOsbbmVRwYx9eH
         B1OzoHyne0RI0te9mAEloH2HBiXA520qrN4AZjyoBcBMu8g108cCM4IEqWlPSVLJ+vWB
         4zEIURIBs3/HqnMJdaLLXQrDkEk2TQSuOGNOk6Xi5ehro8J0o8QA9KK8beHdnCiyKBDO
         kETvq8CGdlXv1vYJwiF1CwoadkqtqDAVdp+/OSVRieLfXAKutSwGofritd+eroVM0sRd
         ONjZEJZ0iDxjp+m6P98wmPmuPWwbarb7pbOAL+ZXgL1kTHfc16iMMCri5jlQQeQVLcHO
         ihtw==
X-Gm-Message-State: AOAM532OK9n4uDzry5NLQONsUldW7gdGsue1AGGnEo8BCR10Oe9zM6yV
        QEh9zM3TwSUMdZs1A/Me/lgzKLpV1xEyJF4OT/Fy6PEV4wQ2jLXsVb4FtjOIRHqoxEKwhjsBmNZ
        kZRLZVp8uJGg1
X-Received: by 2002:a02:9582:0:b0:32e:98ba:75e4 with SMTP id b2-20020a029582000000b0032e98ba75e4mr10429502jai.305.1653408460391;
        Tue, 24 May 2022 09:07:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrvqWk8ngiJV3Knc6VMVBwVD0PeuAK67QqhdEBmUAwKPRdwCD+sBPuLMVAGTutZeXhMBorEQ==
X-Received: by 2002:a02:9582:0:b0:32e:98ba:75e4 with SMTP id b2-20020a029582000000b0032e98ba75e4mr10429493jai.305.1653408460126;
        Tue, 24 May 2022 09:07:40 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id o26-20020a02741a000000b0032e85741287sm3509843jac.141.2022.05.24.09.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 09:07:39 -0700 (PDT)
Date:   Tue, 24 May 2022 10:07:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        Robin Murphy <robin.murphy@arm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH] vfio: Do not manipulate iommu dma_owner for fake iommu
 groups
Message-ID: <20220524100737.24420c3f.alex.williamson@redhat.com>
In-Reply-To: <0-v1-9cfc47edbcd4+13546-vfio_dma_owner_fix_jgg@nvidia.com>
References: <0-v1-9cfc47edbcd4+13546-vfio_dma_owner_fix_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 May 2022 14:03:48 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Since asserting dma ownership now causes the group to have its DMA blocked
> the iommu layer requires a working iommu. This means the dma_owner APIs
> cannot be used on the fake groups that VFIO creates. Test for this and
> avoid calling them.
> 
> Otherwise asserting dma ownership will fail for VFIO mdev devices as a
> BLOCKING iommu_domain cannot be allocated due to the NULL iommu ops.
> 
> Fixes: 0286300e6045 ("iommu: iommu_group_claim_dma_owner() must always assign a domain")
> Reported-by: Eric Farman <farman@linux.ibm.com>
> Tested-by: Eric Farman <farman@linux.ibm.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)

Applied to vfio next branch for v5.19.  Thanks,

Alex

