Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4A4289E57
	for <lists+kvm@lfdr.de>; Sat, 10 Oct 2020 06:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgJJEmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Oct 2020 00:42:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28688 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725844AbgJJEmC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 10 Oct 2020 00:42:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602304916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vs68KN6xy3tJ50oUSJLZxJXUkrP9J+jFxUF8lhzeWpw=;
        b=Ru2QOGCuuBcJdjCPovrBQ8RYi1broBeEmgUYaObc7NFC+F4b9jm0gVmxnY2fWFX81AzWYO
        tRUbE/AwW9L66h3G0DaIF1zX9TFi5zjFRXX8Mq8/0y3XsyvyqhUEA5u0h2abp6VZuq6Eb2
        6YuNgnFjSFRkStHLW7at+BaLU9KdUQs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-4E_qwnJ1OKyYLgLWbobiBA-1; Sat, 10 Oct 2020 00:41:54 -0400
X-MC-Unique: 4E_qwnJ1OKyYLgLWbobiBA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3504EEDBFC;
        Sat, 10 Oct 2020 04:41:53 +0000 (UTC)
Received: from blackfin.pond.sub.org (ovpn-112-182.ams2.redhat.com [10.36.112.182])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D58655779;
        Sat, 10 Oct 2020 04:41:50 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 9E36011329AE; Sat, 10 Oct 2020 06:41:48 +0200 (CEST)
From:   Markus Armbruster <armbru@redhat.com>
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Daniel Berrange <berrange@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        John Snow <jsnow@redhat.com>
Subject: Re: KVM call for agenda for 2020-10-06
References: <874kndm1t3.fsf@secure.mitica>
        <20201005144615.GE5029@stefanha-x1.localdomain>
        <CAJSP0QVZcEQueXG1gjwuLszdUtXWi1tgB5muLL6QHJjNTOmyfQ@mail.gmail.com>
        <8fce8f99-56bd-6a87-9789-325d6ffff54d@redhat.com>
        <20201008080345.GB4672@linux.fritz.box>
        <20201009164548.GC7303@habkost.net>
Date:   Sat, 10 Oct 2020 06:41:48 +0200
In-Reply-To: <20201009164548.GC7303@habkost.net> (Eduardo Habkost's message of
        "Fri, 9 Oct 2020 12:45:48 -0400")
Message-ID: <87sgamae0j.fsf@dusky.pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eduardo Habkost <ehabkost@redhat.com> writes:

> On Thu, Oct 08, 2020 at 10:03:45AM +0200, Kevin Wolf wrote:
>> Am 07.10.2020 um 19:50 hat Paolo Bonzini geschrieben:
>> > On 06/10/20 20:21, Stefan Hajnoczi wrote:
>> > >     * Does command-line order matter?
>> > >         * Two options: allow any order OR left-to-right ordering
>> > >         * Andrea Bolognani: Most users expect left-to-right ordering,
>> > > why allow any order?
>> > >         * Eduardo Habkost: Can we enforce left-to-right ordering or do
>> > > we need to follow the deprecation process?
>> > >         * Daniel Berrange: Solve compability by introducing new
>> > > binaries without the burden of backwards compability
>> > 
>> > I think "new binaries" shouldn't even have a command line; all
>> > configuration should happen through QMP commands.  Those are naturally
>> > time-ordered, which is equivalent to left-to-right, and therefore the
>> > question is sidestepped.  Perhaps even having a command line in
>> > qemu-storage-daemon was a mistake.
>> > 
>> > For "old binaries" we are not adding too many options, so apart from the
>> > nasty distinction between early and late objects we're at least not
>> > making it worse.
>> > 
>> > The big question to me is whether the configuration should be
>> > QAPI-based, that is based on QAPI structs, or QMP-based.  If the latter,
>> > "object-add" (and to a lesser extent "device-add") are fine mechanisms
>> > for configuration.  There is still need for better QOM introspection,
>> > but it would be much simpler than doing QOM object creation via QAPI
>> > struct, if at all possible.
>> 
>> I would strongly vote for QAPI-based. It doesn't have to be fully based
>> on QAPI structs internally, but the defining property for me is that the
>> external interface is described in the QAPI schema (which implies using
>> QAPI structs for the external facing code).
>> 
>> Not only is it a PITA to work with things like "gen": false or "props":
>> "any", but having two systems to configure things side by side is also
>> highly inconsistent.
>> 
>> I have recently discussed object-add with Markus, or to be more precise,
>> a QAPIfied --object in qsd wrapping it. This doesn't work well without
>> having a schema. I believe the right thing to do there is build a QAPI
>> schema describing the existing QOM properties in a first step (which
>> already gives you all of the advantages of QAPI like introspection), and
>> then in a second step generate the respective QOM code for initialising
>> the properties from the schema instead of duplicating it.
>> 
>> This can get challenging with dynamic properties, but as far as I can
>> see, user creatable objects only have class properties or object
>> properties created right in .instance_init (which should be equivalent).
>
> I've just submitted a series to ensure 100% of
> TYPE_USER_CREATABLE types have only class properties:
>
> https://lore.kernel.org/qemu-devel/20201009160122.1662082-1-ehabkost@redhat.com

Lovely idea!

Additional benefit: QOM introspection becomes more useful.

>> As the number of user creatable objects isn't too large, this shouldn't
>> be too hard. I'm less sure about device-add, though in theory the same
>> approch would probably result in the best interface.
>
> Doing the same for all user creatable device types would be nice
> too.  We can use the property locking mechanism from the series above
> to find out how bad the situation is.

Yes, please!

