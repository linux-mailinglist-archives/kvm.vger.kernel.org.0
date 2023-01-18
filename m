Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6449F6722C2
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 17:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjARQPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 11:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjARQOI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 11:14:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B5356EDD
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674058124;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I/uYMi6JWgVe4uvjmjmyIXlGNgTThxELKzyBUKBYyxQ=;
        b=hIPnRQRzawYc5gINGvnkONS/bWlbGHErEbwqOdf+VjBN1qL1T3ZczsN4udEf8geQlLzP0i
        coc8X5Iyhz8iOF7CQhqOthAsD4QiKN0GGpPso4tZOPvDgPMBmlnpuhRJZJOFKST2LAf8kw
        hK+6hRkkeiAeTrfBILrSu4iPQhMonpQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-ygQ1T7sDPVycWbYs6PRfrQ-1; Wed, 18 Jan 2023 11:08:40 -0500
X-MC-Unique: ygQ1T7sDPVycWbYs6PRfrQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22D398A0108;
        Wed, 18 Jan 2023 16:08:40 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A623240C6EC4;
        Wed, 18 Jan 2023 16:08:37 +0000 (UTC)
Date:   Wed, 18 Jan 2023 16:08:35 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, clg@kaod.org
Subject: Re: [PATCH v14 09/11] qapi/s390/cpu topology: monitor query topology
 information
Message-ID: <Y8gZg/+k04+LPEd4@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-10-pmorel@linux.ibm.com>
 <Y7/4rm9JYihUpLS1@redhat.com>
 <d97d0a6a-a87e-e0d2-5d95-0645c09d9730@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d97d0a6a-a87e-e0d2-5d95-0645c09d9730@linux.ibm.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 18, 2023 at 04:58:05PM +0100, Pierre Morel wrote:
> 
> 
> On 1/12/23 13:10, Daniel P. Berrangé wrote:
> > On Thu, Jan 05, 2023 at 03:53:11PM +0100, Pierre Morel wrote:
> > > Reporting the current topology informations to the admin through
> > > the QEMU monitor.
> > > 
> > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > ---
> > >   qapi/machine-target.json | 66 ++++++++++++++++++++++++++++++++++
> > >   include/monitor/hmp.h    |  1 +
> > >   hw/s390x/cpu-topology.c  | 76 ++++++++++++++++++++++++++++++++++++++++
> > >   hmp-commands-info.hx     | 16 +++++++++
> > >   4 files changed, 159 insertions(+)
> > > 
> > > diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> > > index 75b0aa254d..927618a78f 100644
> > > --- a/qapi/machine-target.json
> > > +++ b/qapi/machine-target.json
> > > @@ -371,3 +371,69 @@
> > >     },
> > >     'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
> > >   }
> > > +
> > > +##
> > > +# @S390CpuTopology:
> > > +#
> > > +# CPU Topology information
> > > +#
> > > +# @drawer: the destination drawer where to move the vCPU
> > > +#
> > > +# @book: the destination book where to move the vCPU
> > > +#
> > > +# @socket: the destination socket where to move the vCPU
> > > +#
> > > +# @polarity: optional polarity, default is last polarity set by the guest
> > > +#
> > > +# @dedicated: optional, if the vCPU is dedicated to a real CPU
> > > +#
> > > +# @origin: offset of the first bit of the core mask
> > > +#
> > > +# @mask: mask of the cores sharing the same topology
> > > +#
> > > +# Since: 8.0
> > > +##
> > > +{ 'struct': 'S390CpuTopology',
> > > +  'data': {
> > > +      'drawer': 'int',
> > > +      'book': 'int',
> > > +      'socket': 'int',
> > > +      'polarity': 'int',
> > > +      'dedicated': 'bool',
> > > +      'origin': 'int',
> > > +      'mask': 'str'
> > > +  },
> > > +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
> > > +}
> > > +
> > > +##
> > > +# @query-topology:
> > > +#
> > > +# Return information about CPU Topology
> > > +#
> > > +# Returns a @CpuTopology instance describing the CPU Toplogy
> > > +# being currently used by QEMU.
> > > +#
> > > +# Since: 8.0
> > > +#
> > > +# Example:
> > > +#
> > > +# -> { "execute": "cpu-topology" }
> > > +# <- {"return": [
> > > +#     {
> > > +#         "drawer": 0,
> > > +#         "book": 0,
> > > +#         "socket": 0,
> > > +#         "polarity": 0,
> > > +#         "dedicated": true,
> > > +#         "origin": 0,
> > > +#         "mask": 0xc000000000000000,
> > > +#     },
> > > +#    ]
> > > +#   }
> > > +#
> > > +##
> > > +{ 'command': 'query-topology',
> > > +  'returns': ['S390CpuTopology'],
> > > +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
> > > +}
> > 
> > IIUC, you're using @mask as a way to compress the array returned
> > from query-topology, so that it doesn't have any repeated elements
> > with the same data. I guess I can understand that desire when the
> > core count can get very large, this can have a large saving.
> > 
> > The downside of using @mask, is that now you require the caller
> > to parse the string to turn it into a bitmask and expand the
> > data. Generally this is considered a bit of an anti-pattern in
> > QAPI design - we don't want callers to have to further parse
> > the data to extract information, we want to directly consumable
> > from the parsed JSON doc.
> 
> Not exactly, the mask is computed by the firmware to provide it to the guest
> and is already available when querying the topology.
> But I understand that for the QAPI user the mask is not the right solution,
> standard coma separated values like (1,3,5,7-11) would be much easier to
> read.

That is still inventing a second level data format for an attribute
that needs to be parsed, and its arguably more complex.

> > We already have 'query-cpus-fast' wich returns one entry for
> > each CPU. In fact why do we need to add query-topology at all.
> > Can't we just add book-id / drawer-id / polarity / dedicated
> > to the query-cpus-fast result ?
> 
> Yes we can, I think we should, however when there are a lot of CPU it will
> be complicated to find the CPU sharing the same socket and the same
> attributes.

It shouldn't be that hard to populate a hash table, using the set of
socket + attributes you want as the hash key.

> I think having both would be interesting.

IMHO this is undesirable if we can make query-cpus-fast report
sufficient information, as it gives a maint burden to QEMU and
is confusing to consumers to QEMU to have multiple commands with
largely overlapping functionality.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

