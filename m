Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6DB690468
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 11:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjBIKFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 05:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBIKFo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 05:05:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAA72CFF6
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 02:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675937100;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=wgzRSwUJt+/Wuqa/U2KO5cWEATdDgbA4uh3Jah3p2gE=;
        b=W/CQn9nR51sAX2z4m0zesAJ9ff4F2xkAkvPF3tfqHVJHZUX7rAmpMoZMj6NLw8B33Kq6nx
        N+nqlGiuwk0KUJS/aKo4FV6YJ1MYH/oJ/hhHOCOq0eV91RanEmEabT38cH3WRAS8hWQ6uu
        2pI2RpqJfQKZ5TqNEsUkCCPqExmhSQk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-IO6HwxpHNKaD8BlfXprTpg-1; Thu, 09 Feb 2023 05:04:58 -0500
X-MC-Unique: IO6HwxpHNKaD8BlfXprTpg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E71101C0512B;
        Thu,  9 Feb 2023 10:04:57 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B55042166B29;
        Thu,  9 Feb 2023 10:04:54 +0000 (UTC)
Date:   Thu, 9 Feb 2023 10:04:52 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        clg@kaod.org
Subject: Re: [PATCH v15 10/11] qapi/s390x/cpu topology: CPU_POLARITY_CHANGE
 qapi event
Message-ID: <Y+TFRNoOAfZ7QTvp@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-11-pmorel@linux.ibm.com>
 <5b26ee514ccbbfaf5670cbf0cb006d8e706fe5ae.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5b26ee514ccbbfaf5670cbf0cb006d8e706fe5ae.camel@linux.ibm.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 08, 2023 at 06:35:39PM +0100, Nina Schoetterl-Glausch wrote:
> On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
> > When the guest asks to change the polarity this change
> > is forwarded to the admin using QAPI.
> > The admin is supposed to take according decisions concerning
> > CPU provisioning.
> > 
> > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > ---
> >  qapi/machine-target.json | 30 ++++++++++++++++++++++++++++++
> >  hw/s390x/cpu-topology.c  |  2 ++
> >  2 files changed, 32 insertions(+)
> > 
> > diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> > index 58df0f5061..5883c3b020 100644
> > --- a/qapi/machine-target.json
> > +++ b/qapi/machine-target.json
> > @@ -371,3 +371,33 @@
> >    },
> >    'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
> >  }
> > +
> > +##
> > +# @CPU_POLARITY_CHANGE:
> > +#
> > +# Emitted when the guest asks to change the polarity.
> > +#
> > +# @polarity: polarity specified by the guest
> > +#
> > +# The guest can tell the host (via the PTF instruction) whether the
> > +# CPUs should be provisioned using horizontal or vertical polarity.
> > +#
> > +# On horizontal polarity the host is expected to provision all vCPUs
> > +# equally.
> > +# On vertical polarity the host can provision each vCPU differently.
> > +# The guest will get information on the details of the provisioning
> > +# the next time it uses the STSI(15) instruction.
> > +#
> > +# Since: 8.0
> > +#
> > +# Example:
> > +#
> > +# <- { "event": "CPU_POLARITY_CHANGE",
> > +#      "data": { "polarity": 0 },
> > +#      "timestamp": { "seconds": 1401385907, "microseconds": 422329 } }
> > +#
> > +##
> > +{ 'event': 'CPU_POLARITY_CHANGE',
> > +  'data': { 'polarity': 'int' },
> > +   'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM'] }
> 
> I wonder if you should depend on CONFIG_KVM or not. If tcg gets topology
> support it will use the same event and right now it would just never be emitted.
> On the other hand it's more conservative this way.
> 
> I also wonder if you should add 'feature' : [ 'unstable' ].
> On the upside, it would mark the event as unstable, but I don't know what the
> consequences are exactly.

The intention of this flag is to allow mgmt apps to make a usage policy
decision.

Libvirt's policy is that we'll never use features marked unstable.

IOW, the consequence of marking it unstable is that it'll likely
go unused until the unstable marker gets removed.

Using 'unstable' is useful if you want to get complex code merged
before you're quite happy with the design, and then iterate on the
impl in-tree. This is OK if there's no urgent need for apps to
consume the feature. If you want the feature to be used for real
though, the unstable flag is not desirable and you need to finalize
the design.

> Also I guess one can remove qemu events without breaking backwards compatibility,
> since they just won't be emitted? Unless I guess you specify that a event must
> occur under certain situations and the client waits on it?

As Markus says, that's not a safe assumption. If a mgmt app is expecting
to receive an event, ceasing to emit it would likely be considered a
regression.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

