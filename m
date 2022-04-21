Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7F750A0AD
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 15:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbiDUNZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 09:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbiDUNZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 09:25:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF51EDEA3
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 06:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650547373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t7IBdGoqOwSFP+YaMGdHIFPmEARTtPjt8X8bAHmafsQ=;
        b=cGMepHpoxIqFiJ2U2D7qthyfw58Is18QrOoouk0zVlAUlPzSpbiownVW4jBkfNsz8T0An4
        yS50ing6yIBji0A4DE3JKdxOC97+lWQC3IXVXDQL9+DjfTkeoh/f3AC8kq46FKfO960/Ye
        8XV/1Myp1YO49sKufOPxr7Pl0RQgdxs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-kbvYr2WAOge_rUr1Zinv5g-1; Thu, 21 Apr 2022 09:22:51 -0400
X-MC-Unique: kbvYr2WAOge_rUr1Zinv5g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A873280534C;
        Thu, 21 Apr 2022 13:22:51 +0000 (UTC)
Received: from localhost (unknown [10.39.193.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C8A3040CFD22;
        Thu, 21 Apr 2022 13:22:50 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 1/8] kvm/vfio: Move KVM_DEV_VFIO_GROUP_* ioctls into
 functions
In-Reply-To: <1-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <1-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Thu, 21 Apr 2022 15:22:49 +0200
Message-ID: <87v8v28tau.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 20 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:

> To make it easier to read and change in following patches.
>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  virt/kvm/vfio.c | 271 ++++++++++++++++++++++++++----------------------
>  1 file changed, 146 insertions(+), 125 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

