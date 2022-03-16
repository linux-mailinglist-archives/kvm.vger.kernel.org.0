Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6E64DB9F3
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 22:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358108AbiCPVLt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 17:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355934AbiCPVLn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 17:11:43 -0400
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D5042A16;
        Wed, 16 Mar 2022 14:10:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:35::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id C53FE2CD;
        Wed, 16 Mar 2022 21:10:27 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net C53FE2CD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1647465027; bh=6PY+oP187Km4X4DENxa30QTAKestJk5QoK9x4lPxiXw=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=kc1Km2RbeQki+bPzH8xgB8YhtJLFbkat9ffYIcuRayQbjxnhYXQoj2ank61Srmfoj
         DsbzBoPZBH9m8b1R9mD791Xs4GSMHN5UdEybAdtEGhMp/xaeCH7+z0BQ4CMrQLWiYC
         ZuKdUol8/ew8nNw02U6lzDSIzxpTEcXPc/2Jq4VJNO/my6bdlw/aNcKVI1Y9qwUe6O
         a1FBuIwBY60lCoi55q4i5tWsmywdd3ky4qaeH4ARiMLfYgmZ7dIh1ScDLiPMzSaApv
         hYazpkfTdxN2HXQUl35MGEMeflZdpi9Rv0E+7a+gFqJFql/7MNUwtNspJxwnYq8V0k
         sR9+gcu8DkjDA==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Alex Williamson <alex.williamson@redhat.com>,
        alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        yishaih@nvidia.com, linux-doc@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH v4] vfio-pci: Provide reviewers and acceptance criteria
 for variant drivers
In-Reply-To: <164736509088.181560.2887686123582116702.stgit@omen>
References: <164736509088.181560.2887686123582116702.stgit@omen>
Date:   Wed, 16 Mar 2022 15:10:27 -0600
Message-ID: <87wngtsiws.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alex Williamson <alex.williamson@redhat.com> writes:

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

So this seems fine to me.  Did you want it to go through the docs tree,
or did you have another path in mind for it?

Thanks,

jon
