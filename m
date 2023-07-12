Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8314750360
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 11:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbjGLJiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 05:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbjGLJif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 05:38:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9CE2101
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 02:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689154560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ACCFahbLyK33raGRj/W0sACOpn4jX0KHwZxmYOgITVg=;
        b=iqFH1OI398RAQ+AJyuKO2e4E0CN8v48+EfXiASgkhflMSTbdg1PJrPpoxVpqI4h8+LLAZi
        XyG+KwPjObLuPXTr8ZFMZfaAhr7dvKKILcJxQVV3/nbNaDW33HU7bC7R6SVivGN7+UhOJv
        pJNI7d2CMF798roWqA4bVEihTsxth90=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-QSVSnOx2PWyXybpvf3q_5A-1; Wed, 12 Jul 2023 05:35:50 -0400
X-MC-Unique: QSVSnOx2PWyXybpvf3q_5A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E251A8FBA20;
        Wed, 12 Jul 2023 09:35:49 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8711FC09A09;
        Wed, 12 Jul 2023 09:35:49 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "clg@redhat.com" <clg@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
Subject: RE: [RFC PATCH v4 02/24] Update linux-header per VFIO device cdev v14
In-Reply-To: <PH7PR11MB67221F2DE29B1995918B94159236A@PH7PR11MB6722.namprd11.prod.outlook.com>
Organization: Red Hat GmbH
References: <20230712072528.275577-1-zhenzhong.duan@intel.com>
 <20230712072528.275577-3-zhenzhong.duan@intel.com>
 <87v8epk1sh.fsf@redhat.com>
 <PH7PR11MB67221F2DE29B1995918B94159236A@PH7PR11MB6722.namprd11.prod.outlook.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Wed, 12 Jul 2023 11:35:48 +0200
Message-ID: <87sf9tjwuj.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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

On Wed, Jul 12 2023, "Duan, Zhenzhong" <zhenzhong.duan@intel.com> wrote:

>>-----Original Message-----
>>From: Cornelia Huck <cohuck@redhat.com>
>>Sent: Wednesday, July 12, 2023 3:49 PM
>>Subject: Re: [RFC PATCH v4 02/24] Update linux-header per VFIO device cdev
>>v14
>>
>>On Wed, Jul 12 2023, Zhenzhong Duan <zhenzhong.duan@intel.com> wrote:
>>
>>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
>>> ---
>>>  linux-headers/linux/iommufd.h | 347
>>++++++++++++++++++++++++++++++++++
>>>  linux-headers/linux/kvm.h     |  13 +-
>>>  linux-headers/linux/vfio.h    | 142 +++++++++++++-
>>>  3 files changed, 498 insertions(+), 4 deletions(-)
>>>  create mode 100644 linux-headers/linux/iommufd.h
>>
>>Hi,
>>
>>if this patch is intending to pull code that is not yet integrated in
>>the Linux kernel, please mark this as a placeholder patch. If the code
>>is already integrated, please run a full headers update against a
>>released version (can be -rc) and note that version in the patch
>>description.
> Thanks for point out, will do in next post.
> About "placeholder patch", should I claim it is placeholder in patch
> subject or description field, or there is official step to do that?

Just put a notice into the subject and/or the patch description; the
main idea is to prevent a maintainer from applying it by accident.

