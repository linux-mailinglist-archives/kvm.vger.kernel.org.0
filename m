Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F283AC2F5
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 07:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbhFRFzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 01:55:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38428 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232622AbhFRFzK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Jun 2021 01:55:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623995581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pt7s6thOZ7bruleZlMytZjolyQHwvGo+oh9LKoATJaQ=;
        b=GNDWWUnaItN3xQhAMn66u9AipP6+Uki6r90IKXZ2dy1FWTBS142Sl0wvhbi/5sfWlCTakA
        v+snXo55L173dZPo8qJNuP+EDuSDopPMfoN1KByi3UiiuL/is4jhyOJ1WiX82qs/X/E2OR
        GF1ZyjO056pJmxmk5OYfDUY0wUOerkc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-z2giWGiJPCaVzEnRt1VuKQ-1; Fri, 18 Jun 2021 01:52:58 -0400
X-MC-Unique: z2giWGiJPCaVzEnRt1VuKQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 784128015DB;
        Fri, 18 Jun 2021 05:52:56 +0000 (UTC)
Received: from blackfin.pond.sub.org (ovpn-112-104.ams2.redhat.com [10.36.112.104])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A448116E4D;
        Fri, 18 Jun 2021 05:52:48 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 3AC80113865F; Fri, 18 Jun 2021 07:52:47 +0200 (CEST)
From:   Markus Armbruster <armbru@redhat.com>
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     Claudio Fontana <cfontana@suse.de>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>,
        Denis Lunev <den@openvz.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Blake <eblake@redhat.com>
Subject: Re: [PATCH v9] qapi: introduce 'query-kvm-cpuid' action
References: <20210603090753.11688-1-valeriy.vdovin@virtuozzo.com>
        <87im2d6p5v.fsf@dusky.pond.sub.org>
        <20210617074919.GA998232@dhcp-172-16-24-191.sw.ru>
        <87a6no3fzf.fsf@dusky.pond.sub.org>
        <790d22e1-5de9-ba20-6c03-415b62223d7d@suse.de>
        <877dis1sue.fsf@dusky.pond.sub.org>
        <20210617153949.GA357@dhcp-172-16-24-191.sw.ru>
        <e69ea2b4-21cc-8203-ad2d-10a0f4ffe34a@suse.de>
        <20210617165111.eu3x2pvinpoedsqj@habkost.net>
Date:   Fri, 18 Jun 2021 07:52:47 +0200
In-Reply-To: <20210617165111.eu3x2pvinpoedsqj@habkost.net> (Eduardo Habkost's
        message of "Thu, 17 Jun 2021 12:51:11 -0400")
Message-ID: <87sg1fwwgg.fsf@dusky.pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eduardo Habkost <ehabkost@redhat.com> writes:

> On Thu, Jun 17, 2021 at 05:53:11PM +0200, Claudio Fontana wrote:
>> On 6/17/21 5:39 PM, Valeriy Vdovin wrote:
>> > On Thu, Jun 17, 2021 at 04:14:17PM +0200, Markus Armbruster wrote:
>> >> Claudio Fontana <cfontana@suse.de> writes:
>> >>
>> >>> On 6/17/21 1:09 PM, Markus Armbruster wrote:

[...]

>> >>>> If it just isn't implemented for anything but KVM, then putting "kvm"
>> >>>> into the command name is a bad idea.  Also, the commit message should
>> >>>> briefly note the restriction to KVM.
>> >>
>> >> Perhaps this one is closer to reality.
>> >>
>> > I agree.
>> > What command name do you suggest?
>> 
>> query-exposed-cpuid?
>
> Pasting the reply I sent at [1]:
>
>   I don't really mind how the command is called, but I would prefer
>   to add a more complex abstraction only if maintainers of other
>   accelerators are interested and volunteer to provide similar
>   functionality.  I don't want to introduce complexity for use
>   cases that may not even exist.
>
> I'm expecting this to be just a debugging mechanism, not a stable
> API to be maintained and supported for decades.  (Maybe a "x-"
> prefix should be added to indicate that?)
>
> [1] https://lore.kernel.org/qemu-devel/20210602204604.crsxvqixkkll4ef4@habkost.net

x-query-x86_64-cpuid?

