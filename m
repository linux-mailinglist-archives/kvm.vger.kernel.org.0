Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1AB83AEB22
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 16:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhFUOZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 10:25:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35992 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229876AbhFUOZt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 10:25:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624285414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YNu5Bg5Blog31a4R2un4VWYXZOCNOgVuIDk7FGHXa5U=;
        b=NR/FvaKa0bWpUiAPiGWSLc3AN1jQf6I5Wfsz4WAvfv1Zn52Csw5Cl+TfbJMp+iSGjejF6v
        UcPU7GW0rP+FRiNcWPA+QisVt5JTZPq8FTWg4hDN5qeEsUsfUhebhzrfadpmF3x/kkO2vF
        /tebJtY4aX8ZR2hzX7izTcmqM9lEXp0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-GkXdPMaXOt6XXh4wig7E0Q-1; Mon, 21 Jun 2021 10:23:32 -0400
X-MC-Unique: GkXdPMaXOt6XXh4wig7E0Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 121A2A0CAC;
        Mon, 21 Jun 2021 14:23:31 +0000 (UTC)
Received: from localhost (unknown [10.22.8.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98C2560938;
        Mon, 21 Jun 2021 14:23:30 +0000 (UTC)
Date:   Mon, 21 Jun 2021 10:23:29 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Claudio Fontana <cfontana@suse.de>
Cc:     Markus Armbruster <armbru@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Denis Lunev <den@openvz.org>, Eric Blake <eblake@redhat.com>,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
Subject: Re: [PATCH v9] qapi: introduce 'query-kvm-cpuid' action
Message-ID: <20210621142329.atlhrovqkblbjwgh@habkost.net>
References: <20210617074919.GA998232@dhcp-172-16-24-191.sw.ru>
 <87a6no3fzf.fsf@dusky.pond.sub.org>
 <790d22e1-5de9-ba20-6c03-415b62223d7d@suse.de>
 <877dis1sue.fsf@dusky.pond.sub.org>
 <20210617153949.GA357@dhcp-172-16-24-191.sw.ru>
 <e69ea2b4-21cc-8203-ad2d-10a0f4ffe34a@suse.de>
 <20210617165111.eu3x2pvinpoedsqj@habkost.net>
 <87sg1fwwgg.fsf@dusky.pond.sub.org>
 <20210618204006.k6krwuz2lpxvb6uh@habkost.net>
 <6f644bbb-52ff-4d79-36bb-208c6b6c4eef@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6f644bbb-52ff-4d79-36bb-208c6b6c4eef@suse.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 21, 2021 at 10:07:44AM +0200, Claudio Fontana wrote:
> On 6/18/21 10:40 PM, Eduardo Habkost wrote:
> > On Fri, Jun 18, 2021 at 07:52:47AM +0200, Markus Armbruster wrote:
> >> Eduardo Habkost <ehabkost@redhat.com> writes:
> >>
> >>> On Thu, Jun 17, 2021 at 05:53:11PM +0200, Claudio Fontana wrote:
> >>>> On 6/17/21 5:39 PM, Valeriy Vdovin wrote:
> >>>>> On Thu, Jun 17, 2021 at 04:14:17PM +0200, Markus Armbruster wrote:
> >>>>>> Claudio Fontana <cfontana@suse.de> writes:
> >>>>>>
> >>>>>>> On 6/17/21 1:09 PM, Markus Armbruster wrote:
> >>
> >> [...]
> >>
> >>>>>>>> If it just isn't implemented for anything but KVM, then putting "kvm"
> >>>>>>>> into the command name is a bad idea.  Also, the commit message should
> >>>>>>>> briefly note the restriction to KVM.
> >>>>>>
> >>>>>> Perhaps this one is closer to reality.
> >>>>>>
> >>>>> I agree.
> >>>>> What command name do you suggest?
> >>>>
> >>>> query-exposed-cpuid?
> >>>
> >>> Pasting the reply I sent at [1]:
> >>>
> >>>   I don't really mind how the command is called, but I would prefer
> >>>   to add a more complex abstraction only if maintainers of other
> >>>   accelerators are interested and volunteer to provide similar
> >>>   functionality.  I don't want to introduce complexity for use
> >>>   cases that may not even exist.
> >>>
> >>> I'm expecting this to be just a debugging mechanism, not a stable
> >>> API to be maintained and supported for decades.  (Maybe a "x-"
> >>> prefix should be added to indicate that?)
> >>>
> >>> [1] https://lore.kernel.org/qemu-devel/20210602204604.crsxvqixkkll4ef4@habkost.net
> >>
> >> x-query-x86_64-cpuid?
> >>
> > 
> > Unless somebody wants to spend time designing a generic
> > abstraction around this (and justify the extra complexity), this
> > is a KVM-specific command.  Is there a reason to avoid "kvm" in
> > the command name?
> > 
> 
> If the point of all of this is "please get me the cpuid, as seen by the guest", then I fail to see how this should be kvm-only.
> We can still return "not implemented" of some kind for HVF, TCG etc.
> 
> But maybe I misread the use case?

A generic interface would require additional glue to connect the
generic code to the accel-specific implementation.  I'm trying to
avoid wasting everybody's time with the extra complexity unless
necessary.

But if you all believe the extra complexity is worth it, I won't
object.

-- 
Eduardo

