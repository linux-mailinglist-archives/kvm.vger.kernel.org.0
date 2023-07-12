Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5578E75006B
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 09:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbjGLHuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 03:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbjGLHt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 03:49:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61BB1739
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 00:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689148149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TI8sMo9dcspBHPFjOtplyLd7Y+0Eky95LPprMfjsfxk=;
        b=Kzz/grwW7zt9/HBfCBx0opTwAqlbs1rtpju72ouFlRkoYYKUcReXTqlgzCGHj42hVG5EQd
        3IqcEj5piW/JwSv0K7RYCkKg/an0zxQdOCod5g0qVzWySMmUaOTmuru8HG1aGsuJsVtQbp
        O4SDkXEqjp+VF+Teyn9MWSzNFxmTuQw=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-jtxp9N1cO0KZx57ioc8AZw-1; Wed, 12 Jul 2023 03:49:04 -0400
X-MC-Unique: jtxp9N1cO0KZx57ioc8AZw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0786D384CC4C;
        Wed, 12 Jul 2023 07:49:04 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9179B492B01;
        Wed, 12 Jul 2023 07:49:03 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Zhenzhong Duan <zhenzhong.duan@intel.com>, qemu-devel@nongnu.org
Cc:     alex.williamson@redhat.com, clg@redhat.com, jgg@nvidia.com,
        nicolinc@nvidia.com, eric.auger@redhat.com, peterx@redhat.com,
        jasowang@redhat.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        yi.y.sun@intel.com, chao.p.peng@intel.com,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH v4 02/24] Update linux-header per VFIO device cdev v14
In-Reply-To: <20230712072528.275577-3-zhenzhong.duan@intel.com>
Organization: Red Hat GmbH
References: <20230712072528.275577-1-zhenzhong.duan@intel.com>
 <20230712072528.275577-3-zhenzhong.duan@intel.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Wed, 12 Jul 2023 09:49:02 +0200
Message-ID: <87v8epk1sh.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 12 2023, Zhenzhong Duan <zhenzhong.duan@intel.com> wrote:

> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
> ---
>  linux-headers/linux/iommufd.h | 347 ++++++++++++++++++++++++++++++++++
>  linux-headers/linux/kvm.h     |  13 +-
>  linux-headers/linux/vfio.h    | 142 +++++++++++++-
>  3 files changed, 498 insertions(+), 4 deletions(-)
>  create mode 100644 linux-headers/linux/iommufd.h

Hi,

if this patch is intending to pull code that is not yet integrated in
the Linux kernel, please mark this as a placeholder patch. If the code
is already integrated, please run a full headers update against a
released version (can be -rc) and note that version in the patch
description.

Thanks!

