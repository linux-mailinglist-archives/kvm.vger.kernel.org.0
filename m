Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816D146C0BE
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 17:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbhLGQeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 11:34:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39341 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232748AbhLGQeI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 11:34:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638894637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZI8DDXBtMcsQTTWl4J78FS+UoJsIi2WLN7f77nuHbQY=;
        b=i549l7lYkdVRxvJCN4gMTnyd0QAzH72xWj0aiUWrjI+tpRiu8fcKlblDDGbcUPwem2wa3O
        Xsln0/00rJIdMcNrFIXiqMK7XwVbUosKytJv1y9mXdDKhYHMUIgS9y0hczieQHtfFFeWnb
        8/Wci/0kkQ/f2qOPVD6U+VQ8HYnYdbw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-egm9lRoFPte4-rOzsNnBVA-1; Tue, 07 Dec 2021 11:30:34 -0500
X-MC-Unique: egm9lRoFPte4-rOzsNnBVA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5068B8015B7;
        Tue,  7 Dec 2021 16:30:32 +0000 (UTC)
Received: from localhost (unknown [10.39.193.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BE6E60BF1;
        Tue,  7 Dec 2021 16:30:31 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
In-Reply-To: <20211207155145.GD6385@nvidia.com>
Organization: Red Hat GmbH
References: <20211130153541.131c9729.alex.williamson@redhat.com>
 <20211201031407.GG4670@nvidia.com> <20211201130314.69ed679c@omen>
 <20211201232502.GO4670@nvidia.com>
 <20211203110619.1835e584.alex.williamson@redhat.com>
 <87zgpdu3ez.fsf@redhat.com> <20211206173422.GK4670@nvidia.com>
 <87tufltxp0.fsf@redhat.com> <20211206191933.GM4670@nvidia.com>
 <87o85su0kv.fsf@redhat.com> <20211207155145.GD6385@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Tue, 07 Dec 2021 17:30:29 +0100
Message-ID: <87ilw0tm1m.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 07 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Dec 07, 2021 at 12:16:32PM +0100, Cornelia Huck wrote:
>> On Mon, Dec 06 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
>> 
>> > On Mon, Dec 06, 2021 at 07:06:35PM +0100, Cornelia Huck wrote:
>> >
>> >> We're discussing a complex topic here, and we really don't want to
>> >> perpetuate an unclear uAPI. This is where my push for more precise
>> >> statements is coming from.
>> >
>> > I appreciate that, and I think we've made a big effort toward that
>> > direction.
>> >
>> > Can we have some crisp feedback which statements need SHOULD/MUST/MUST
>> > NOT and come to something?
>> 
>> I'm not sure what I should actually comment on, some general remarks:
>
> You should comment on the paragraphs that prevent you from adding a
> reviewed-by.

On which copy? There have been updates, and I haven't found a conchise
email to reply to.

>
>> - If we consider a possible vfio-ccw implementation that will quiesce
>>   the device and not rely on tracking I/O, we need to make the parts
>>   that talk about tracking non-mandatory.
>
> I'm not sure what you mean by 'tracking I/O'?

MMIO.

>
> I thought we were good on ccw?

We are, if we don't make things mandatory that are not needed for
non-MMIO.

>
>> - NDMA sounds like something that needs to be non-mandatory as well.
>
> I agree, Alex are we agreed now ?
>
>> - The discussion regarding bit group changes has me confused. You seem
>>   to be saying that mlx5 needs that, so it needs to have some mandatory
>>   component; but are actually all devices able to deal with those bits
>>   changing as a group?
>
> Yes, all devices can support this as written.
>
> If you think of the device_state as initiating some action pre bit
> group then we have multiple bit group that can change at once and thus
> multiple actions that can be triggered.
>
> All devices must support userspace initiating actions one by one in a
> manner that supports the reference flow. 
>
> Thus, every driver can decompose a request for multiple actions into
> an ordered list of single actions and execute those actions exactly as
> if userspace had issued single actions.
>
> The precedence follows the reference flow so that any conflicts
> resolve along the path that already has defined behaviors.

Well, yes. I'm just wondering where bit groups are coming in
then. That's where I'm confused (by the discussion).

>
> I honestly don't know why this is such a discussion point, beyond
> being a big oversight of the original design.
>
>> - In particular, the flow needs definitive markings about what is
>>   mandatory to implement, what is strongly suggested, and what is
>>   optional. It is unclear to me what is really expected, and what is
>>   simply one way to implement it.
>
> I'm not sure either, this hasn't been clear at all to me. Alex has
> asked for things to be general and left undefined, but we need some
> minimum definition to actually implement driver/VMM interoperability
> for what we need to do.
>
> Really what qemu does will set the mandatory to implement.

We really, really need to revisit QEMU before that. I'm staring at the
code and I'm not quite sure if that really is what we want. We might
have been too tired after years of review cycles when merging that.

>
>> > The world needs to move forward, we can't debate this endlessly
>> > forever. It is already another 6 weeks past since the last mlx5 driver
>> > posting.
>> 
>> 6 weeks is already blazingly fast in any vfio migration discussion. /s
>
> We've invested a lot of engineer months in this project, it is
> disrespectful to all of this effort to leave us hanging with no clear
> path forward and no actionable review comments after so much
> time. This is another kernel cycle lost.

Well... it's not only you who are spending time on this. I'm trying to
follow the discussion, which is not easy, and try to come up with
feedback, which is not easy, either. This is using up a huge chunk of my
time. Compared with the long and tedious discussions that led to the
initial code being merged, we're really going very fast. And expecting
people to drop everything and make a definite desicion quickly when
there are still open questions on a complex topic does not strike me as
particularly respectful, either.

>
>> Remember that we have other things to do as well, not all of which will
>> be visible to you.
>
> As do we all, but your name is in the maintainer file, and that comes
> with some responsibility.

It, however, does not mean that someone listed in MAINTAINERS must
immediately deal with anything that is thrown at them to the detriment
of everything else. It *especially* does not mean that someone listed in
MAINTAINERS is neglecting their responsibilies if things are not going
as well as you'd hope them to go.

[There is a reason why I have dropped out of some maintainership entries
recently, the asymmetry of people requiring feedback and merging and
people actually giving feedback and merging seems to have gotten worse
over the last years. I can certainly delist myself as a vfio reviewer as
well, and while that would certainly help my wellbeing, I'm not sure
whether that is what you want.]

