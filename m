Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89ACF4668D1
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 18:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359562AbhLBRJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 12:09:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30503 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347960AbhLBRJE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 12:09:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638464741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mUrN1A9hYkigJ+nEx2jcstUeT4FNegKPka9a1x+mxz4=;
        b=jEX1PF47UAbd4YK1RALgkxPzcV7+6RlDpoyaD+/KzqcFGmkSuTkvwwuwja+F1ppHCW5G2k
        LmBpL345p2mTw/oPBkeukhYdims67wFeFUtXK/aaGH4qvBjuzGp+tNq5FU3kJPfPBhSSf0
        SjWt87WHP2oHEPdC5mggdXbMnZfdw8A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-iccA8fSPN7u8aTPGVXqo7w-1; Thu, 02 Dec 2021 12:05:40 -0500
X-MC-Unique: iccA8fSPN7u8aTPGVXqo7w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 898AB839A53;
        Thu,  2 Dec 2021 17:05:38 +0000 (UTC)
Received: from localhost (unknown [10.39.192.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 218D360C05;
        Thu,  2 Dec 2021 17:05:37 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
In-Reply-To: <20211201232502.GO4670@nvidia.com>
Organization: Red Hat GmbH
References: <0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com>
 <20211130102611.71394253.alex.williamson@redhat.com>
 <20211130185910.GD4670@nvidia.com>
 <20211130153541.131c9729.alex.williamson@redhat.com>
 <20211201031407.GG4670@nvidia.com> <20211201130314.69ed679c@omen>
 <20211201232502.GO4670@nvidia.com>
User-Agent: Notmuch/0.33.1 (https://notmuchmail.org)
Date:   Thu, 02 Dec 2021 18:05:36 +0100
Message-ID: <87tufrgcnz.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 01 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Dec 01, 2021 at 01:03:14PM -0700, Alex Williamson wrote:
>> But if this document is suggesting the mlx5/QEMU interpretation is the
>> only valid interpretations for driver authors, those clarifications
>> should be pushed back into the uAPI header.
>
> Can we go the other way and move more of the uAPI header text here?

Where should a userspace author look when they try to implement support
for vfio migration? I think we need to answer that question first.

Maybe we should separate "these are the rules that an implementation
must obey" from "here's a more verbose description of how things work,
and how you can arrive at a working implementation". The former would go
into the header, while the latter can go into this document. (The
generated documentation can be linked from the header file.)

