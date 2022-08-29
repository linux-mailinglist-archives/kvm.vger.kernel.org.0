Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9125F5A4B0F
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 14:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiH2MH3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 08:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiH2MHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 08:07:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5785E1EED9
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 04:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661773869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JxYStZcImyV6pg+KupRauvweBTIy9m8if0nxzKPXP30=;
        b=Vtvwyf554ucJRFsx/8PKvtEW4DkROqD4HmXIHeQurKxQ1wcR4Y/dtXXdcuKdqVGkXtUAQ9
        YvYu1qlCW/0QhhDOCKkCCLTuMuDxO0yqCZeI0snqmDJEAqmUdphPiRoXDAcDRPl9eW8Q7d
        souJVoqp4kfagTBIf3dpt+xc2roRDx4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-VdLVpJssO5irTeJghS9HbA-1; Mon, 29 Aug 2022 07:51:04 -0400
X-MC-Unique: VdLVpJssO5irTeJghS9HbA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DEB629AA387;
        Mon, 29 Aug 2022 11:51:03 +0000 (UTC)
Received: from localhost (unknown [10.39.193.155])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 089DFC15BC3;
        Mon, 29 Aug 2022 11:51:02 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH v2 3/3] vfio/pci: Simplify the is_intx/msi/msix/etc defines
In-Reply-To: <3-v2-1bd95d72f298+e0e-vfio_pci_priv_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <3-v2-1bd95d72f298+e0e-vfio_pci_priv_jgg@nvidia.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Mon, 29 Aug 2022 13:51:01 +0200
Message-ID: <871qszfeu2.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 26 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:

> Only three of these are actually used, simplify to three inline functions,
> and open code the if statement in vfio_pci_config.c.
>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c |  2 +-
>  drivers/vfio/pci/vfio_pci_intrs.c  | 22 +++++++++++++++++-----
>  drivers/vfio/pci/vfio_pci_priv.h   |  2 --
>  3 files changed, 18 insertions(+), 8 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

