Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4323746C015
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239291AbhLGQAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 11:00:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44589 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239265AbhLGQAA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 11:00:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638892588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qVjy2Lwsez23TXi55s3xtBv8BUsuKro2drSiELcWbqs=;
        b=a8oraGeTK3nCJQ5c6tJkUD2NUp14fxAMDMT5cW6gWdnqwRjLDMU7MC4VchQcrW40bA2hHV
        XicElusFyT0xAk0IK+kqtWeThPJVa0Vzd7UgzTXVY9MzR5NSjDApxRt79Xcgag5cya4ctf
        yGQc7wfBbEPKiMn1VDDCbXRVaIsNzLs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-NlK8JtzRMaiBJsBYZLCWAw-1; Tue, 07 Dec 2021 10:56:22 -0500
X-MC-Unique: NlK8JtzRMaiBJsBYZLCWAw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C5E585B665;
        Tue,  7 Dec 2021 15:56:20 +0000 (UTC)
Received: from localhost (unknown [10.39.193.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 62A5560843;
        Tue,  7 Dec 2021 15:56:19 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
In-Reply-To: <20211207153743.GC6385@nvidia.com>
Organization: Red Hat GmbH
References: <0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com>
 <20211130102611.71394253.alex.williamson@redhat.com>
 <20211130185910.GD4670@nvidia.com>
 <20211130153541.131c9729.alex.williamson@redhat.com>
 <20211201031407.GG4670@nvidia.com> <20211201130314.69ed679c@omen>
 <20211201232502.GO4670@nvidia.com>
 <20211203110619.1835e584.alex.williamson@redhat.com>
 <20211206191500.GL4670@nvidia.com> <87r1aou1rs.fsf@redhat.com>
 <20211207153743.GC6385@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Tue, 07 Dec 2021 16:56:17 +0100
Message-ID: <87lf0wtnmm.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 07 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Dec 07, 2021 at 11:50:47AM +0100, Cornelia Huck wrote:
>> On Mon, Dec 06 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
>> 
>> > On Fri, Dec 03, 2021 at 11:06:19AM -0700, Alex Williamson wrote:
>> 
>> >> This is exactly the sort of "designed for QEMU implementation"
>> >> inter-operability that I want to avoid.  It doesn't take much of a
>> >> crystal ball to guess that gratuitous and redundant device resets
>> >> slow VM instantiation and are a likely target for optimization.
>> >
>> > Sorry, but Linus's "don't break userspace" forces us to this world.
>> >
>> > It does not matter what is written in text files, only what userspace
>> > actually does and the kernel must accommodate existing userspace going
>> > forward. So once released qemu forms some definitive spec and the
>> > guardrails that limit what we can do going forward.
>> 
>> But QEMU support is *experimental*, i.e. if it breaks, you get to keep
>> the pieces, things may change in incompatible ways. And it is
>> experimental for good reason!
>
> And we can probably make an breakage exception for this existing
> experimental qemu.
>
> My point was going forward, once we userspace starts to become
> deployed, it doesn't matter what we write in these text files and
> comments. It only matters what deployed userspace actually does.

Absolutely, as soon as QEMU support is made non-experimental, this needs
to be stable.

>
>> It would mean that we must never introduce experimental interfaces
>> in QEMU that may need some rework of the kernel interface, but need
>> to keep those out of the tree -- and that can't be in the best
>> interest of implementing things requiring interaction between the
>> kernel and QEMU.
>
> In general we should not be merging uAPI to the kernel that is so
> incomplete as to be unusable. 
>
> I'm sorry, this whole thing from the day the migration stuff was first
> merged to include/uapi is a textbook example how not to do things in
> the kernel community.

Honestly, I regret ever acking this and the QEMU part. Maybe the history
of this and the archived discussions are instructive to others so that
they don't repeat this :/

