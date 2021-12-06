Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BC846A3CB
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 19:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346528AbhLFSKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 13:10:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59523 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229880AbhLFSK3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Dec 2021 13:10:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638814020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PBGplgX21hKu/O0vqc5DMO4mb2aatMiYVoGa3cXoCCE=;
        b=PIyrisNdVonHb7N/2itS7OOgQGTLI5QCww1NaF/vaW4mf2RBnnbZdko0r0Lybc6Sp5sWF/
        ezTH54W/Qoq0ei9C4Kty8M1jhaAHpa2RfbnIXwBOT2pw8yJ7YvJaVNNwKzUq/4VUKZEO0N
        PhHRdSKVJQtLf/QMvdv2QTNjObP1Oq8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-IP9VbVaBP3iQQmqwPCsydQ-1; Mon, 06 Dec 2021 13:06:57 -0500
X-MC-Unique: IP9VbVaBP3iQQmqwPCsydQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F19E6190D37A;
        Mon,  6 Dec 2021 18:06:37 +0000 (UTC)
Received: from localhost (unknown [10.39.193.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0772C19EF9;
        Mon,  6 Dec 2021 18:06:36 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
In-Reply-To: <20211206173422.GK4670@nvidia.com>
Organization: Red Hat GmbH
References: <0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com>
 <20211130102611.71394253.alex.williamson@redhat.com>
 <20211130185910.GD4670@nvidia.com>
 <20211130153541.131c9729.alex.williamson@redhat.com>
 <20211201031407.GG4670@nvidia.com> <20211201130314.69ed679c@omen>
 <20211201232502.GO4670@nvidia.com>
 <20211203110619.1835e584.alex.williamson@redhat.com>
 <87zgpdu3ez.fsf@redhat.com> <20211206173422.GK4670@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Mon, 06 Dec 2021 19:06:35 +0100
Message-ID: <87tufltxp0.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Dec 06, 2021 at 05:03:00PM +0100, Cornelia Huck wrote:
>
>> > If we're writing a specification, that's really a MAY statement,
>> > userspace MAY issue a reset to abort the RESUMING process and return
>> > the device to RUNNING.  They MAY also write the device_state directly,
>> > which MAY return an error depending on various factors such as whether
>> > data has been written to the migration state and whether that data is
>> > complete.  If a failed transitions results in an ERROR device_state,
>> > the user MUST issue a reset in order to return it to a RUNNING state
>> > without closing the interface.
>> 
>> Are we actually writing a specification? If yes, we need to be more
>> clear on what is mandatory (MUST), advised (SHOULD), or allowed
>> (MAY). If I look at the current proposal, I'm not sure into which
>> category some of the statements fall.
>
> I deliberately didn't use such formal language because this is far
> from what I'd consider an acceptable spec. It is more words about how
> things work and some kind of basis for agreement between user and
> kernel.

We don't really need formal language, but there are too many unclear
statements, as the discussion above showed. Therefore my question: What
are we actually writing? Even if it is not a formal specification, it
still needs to be clear.

>
> Under Linus's "don't break userspace" guideline whatever userspace
> ends up doing becomes the spec the kernel is wedded to, regardless of
> what we write down here.

All the more important that we actually agree before this is merged! I
don't want choices hidden deep inside the mlx5 driver dictating what
other drivers should do, it must be reasonably easy to figure out
(including what is mandatory, and what is flexible.)

> Which basically means whatever mlx5 and qemu does after we go forward
> is the definitive spec and we cannot change qemu in a way that is
> incompatible with mlx5 or introduce a new driver that is incompatible
> with qemu.

TBH, I'm not too happy with the current QEMU state, either. We need to
take a long, hard look first and figure out what we need to do to make
the QEMU support non-experimental.

We're discussing a complex topic here, and we really don't want to
perpetuate an unclear uAPI. This is where my push for more precise
statements is coming from.

