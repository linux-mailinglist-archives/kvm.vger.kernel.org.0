Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C687B4AB6B8
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 09:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237807AbiBGIiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 03:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238518AbiBGIgI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 03:36:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D9EF3C043184
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 00:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644222966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EnlsbuxwF4ALdiCaBmB6LDE1NtPSwP5sAmBAFk/m7Ms=;
        b=N+2lxbhU+Kyr6g1zogRinYWZPkDCcTZhQoZwG0biM47o/8rRPuMVYt42LGM36uISLZulFL
        8/f5fMGOIFMDezRffLDxQk3isxV0ZtjtNxE8X13BR6QdfzDmFl94ya+OiGrr1dAK2YXHDM
        B1VFWZA5abn4bK5IYvFRC3gLR6usk0s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-GjHXXjkVODuR9_aUygqaJw-1; Mon, 07 Feb 2022 03:36:03 -0500
X-MC-Unique: GjHXXjkVODuR9_aUygqaJw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C24E0802926;
        Mon,  7 Feb 2022 08:36:00 +0000 (UTC)
Received: from localhost (unknown [10.39.193.241])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C7B362D6E;
        Mon,  7 Feb 2022 08:35:41 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 14/30] vfio/pci: re-introduce CONFIG_VFIO_PCI_ZDEV
In-Reply-To: <20220204211536.321475-15-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
 <20220204211536.321475-15-mjrosato@linux.ibm.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Mon, 07 Feb 2022 09:35:39 +0100
Message-ID: <87czjzvztw.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04 2022, Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> This was previously removed as unnecessary; while that was true, subsequent
> changes will make KVM an additional required component for vfio-pci-zdev.
> Let's re-introduce CONFIG_VFIO_PCI_ZDEV as now there is actually a reason
> to say 'n' for it (when not planning to CONFIG_KVM).

Hm... can the file be split into parts that depend on KVM and parts that
don't? Does anybody ever use vfio-pci on a non-kvm s390 system?

[Apologies if that has been discussed before, this is my first look at
this series.]

>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/vfio/pci/Kconfig      | 11 +++++++++++
>  drivers/vfio/pci/Makefile     |  2 +-
>  include/linux/vfio_pci_core.h |  2 +-
>  3 files changed, 13 insertions(+), 2 deletions(-)
>

