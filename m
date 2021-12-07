Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F0246B9E6
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 12:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbhLGLUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 06:20:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57225 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235631AbhLGLUL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 06:20:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638875801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E5VGewCEz4fmcYf4Xe+YasUAuTzVOfztXoWjA/QsgxY=;
        b=BfAZxWrMymUedDWlYoO5y5SKaTWlrvGB79u8jjv4kT3mPWSfHwWtoCfBznVibqARPDbNiU
        DgcB0AcEkt+BbiMe3IyQvP8pI1m+YLOeaBVg6XfLGnmVnbinWRIfW7fTYdxnRivpnsw+ee
        R6Xf09oHv5XVaiHM/TOa0pakyv6ai3U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-2qrI2RQoP4ykCg57d5Zf0w-1; Tue, 07 Dec 2021 06:16:36 -0500
X-MC-Unique: 2qrI2RQoP4ykCg57d5Zf0w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6FAB8042E1;
        Tue,  7 Dec 2021 11:16:34 +0000 (UTC)
Received: from localhost (unknown [10.39.193.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 438B219C59;
        Tue,  7 Dec 2021 11:16:34 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
In-Reply-To: <20211206191933.GM4670@nvidia.com>
Organization: Red Hat GmbH
References: <20211130102611.71394253.alex.williamson@redhat.com>
 <20211130185910.GD4670@nvidia.com>
 <20211130153541.131c9729.alex.williamson@redhat.com>
 <20211201031407.GG4670@nvidia.com> <20211201130314.69ed679c@omen>
 <20211201232502.GO4670@nvidia.com>
 <20211203110619.1835e584.alex.williamson@redhat.com>
 <87zgpdu3ez.fsf@redhat.com> <20211206173422.GK4670@nvidia.com>
 <87tufltxp0.fsf@redhat.com> <20211206191933.GM4670@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Tue, 07 Dec 2021 12:16:32 +0100
Message-ID: <87o85su0kv.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Dec 06, 2021 at 07:06:35PM +0100, Cornelia Huck wrote:
>
>> We're discussing a complex topic here, and we really don't want to
>> perpetuate an unclear uAPI. This is where my push for more precise
>> statements is coming from.
>
> I appreciate that, and I think we've made a big effort toward that
> direction.
>
> Can we have some crisp feedback which statements need SHOULD/MUST/MUST
> NOT and come to something?

I'm not sure what I should actually comment on, some general remarks:

- If we consider a possible vfio-ccw implementation that will quiesce
  the device and not rely on tracking I/O, we need to make the parts
  that talk about tracking non-mandatory.
- NDMA sounds like something that needs to be non-mandatory as well.
- The discussion regarding bit group changes has me confused. You seem
  to be saying that mlx5 needs that, so it needs to have some mandatory
  component; but are actually all devices able to deal with those bits
  changing as a group?
- In particular, the flow needs definitive markings about what is
  mandatory to implement, what is strongly suggested, and what is
  optional. It is unclear to me what is really expected, and what is
  simply one way to implement it.

>
> The world needs to move forward, we can't debate this endlessly
> forever. It is already another 6 weeks past since the last mlx5 driver
> posting.

6 weeks is already blazingly fast in any vfio migration discussion. /s

Remember that we have other things to do as well, not all of which will
be visible to you.

