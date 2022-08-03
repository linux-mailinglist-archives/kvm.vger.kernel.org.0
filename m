Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133F2588B68
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 13:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237557AbiHCLhv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 07:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236055AbiHCLht (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 07:37:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 68415FD04
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 04:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659526667;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=MvCIBfHP9wv9N0NzFtCKO1EbIOAB+DlbcsYuDC1zSHo=;
        b=QDn9hz+OAd+IHStHDwcJk9UqAgm777SXn6+5vxlCOvNnZj2eoMNb4aczYlzoZ6kLXb/sjQ
        /nAmEPPNTIxwtxq/1ExOqm17Rf7309o8uC6S6/PP75x9CqUyNlrjFt+WQggx4IoYZp/6BN
        U6mHkzU6SFMAG6nyeK5XDTT/vYEw9KY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-EMvY7AWyMue9gtYKu1d1xg-1; Wed, 03 Aug 2022 07:37:44 -0400
X-MC-Unique: EMvY7AWyMue9gtYKu1d1xg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A825A811E7A;
        Wed,  3 Aug 2022 11:37:41 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.173])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 524204010E37;
        Wed,  3 Aug 2022 11:37:30 +0000 (UTC)
Date:   Wed, 3 Aug 2022 12:37:27 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     "Richard W.M. Jones" <rjones@redhat.com>
Cc:     Alberto Faria <afaria@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org,
        =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Peter Lieven <pl@kamp.de>, kvm@vger.kernel.org,
        Xie Yongji <xieyongji@bytedance.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Jeff Cody <codyprime@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        Stefan Weil <sw@weilnetz.de>, Klaus Jensen <its@irrelevant.dk>,
        Laurent Vivier <lvivier@redhat.com>,
        Alberto Garcia <berto@igalia.com>,
        Michael Roth <michael.roth@amd.com>,
        Juan Quintela <quintela@redhat.com>,
        David Hildenbrand <david@redhat.com>, qemu-block@nongnu.org,
        Konstantin Kostiuk <kkostiuk@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Greg Kurz <groug@kaod.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Amit Shah <amit@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Fam Zheng <fam@euphon.net>, Thomas Huth <thuth@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        John Snow <jsnow@redhat.com>
Subject: Re: [RFC v2 02/10] Drop unused static function return values
Message-ID: <Yupd96RyyEcm1BCb@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220729130040.1428779-1-afaria@redhat.com>
 <20220729130040.1428779-3-afaria@redhat.com>
 <YupSAhFRK962i+nL@work-vm>
 <CAELaAXyh0MzuVzDCfhC8hJNAwb=niwFRsXqhc63JiWGxxitkqg@mail.gmail.com>
 <20220803111520.GO1127@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220803111520.GO1127@redhat.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 03, 2022 at 12:15:20PM +0100, Richard W.M. Jones wrote:
> On Wed, Aug 03, 2022 at 12:07:19PM +0100, Alberto Faria wrote:
> > On Wed, Aug 3, 2022 at 11:46 AM Dr. David Alan Gilbert
> > <dgilbert@redhat.com> wrote:
> > >
> > > * Alberto Faria (afaria@redhat.com) wrote:
> > > > Make non-void static functions whose return values are ignored by
> > > > all callers return void instead.
> > > >
> > > > These functions were found by static-analyzer.py.
> > > >
> > > > Not all occurrences of this problem were fixed.
> > > >
> > > > Signed-off-by: Alberto Faria <afaria@redhat.com>
> > >
> > > <snip>
> > >
> > > > diff --git a/migration/migration.c b/migration/migration.c
> > > > index e03f698a3c..4698080f96 100644
> > > > --- a/migration/migration.c
> > > > +++ b/migration/migration.c
> > > > @@ -175,7 +175,7 @@ static MigrationIncomingState *current_incoming;
> > > >
> > > >  static GSList *migration_blockers;
> > > >
> > > > -static bool migration_object_check(MigrationState *ms, Error **errp);
> > > > +static void migration_object_check(MigrationState *ms, Error **errp);
> > > >  static int migration_maybe_pause(MigrationState *s,
> > > >                                   int *current_active_state,
> > > >                                   int new_state);
> > > > @@ -4485,15 +4485,15 @@ static void migration_instance_init(Object *obj)
> > > >   * Return true if check pass, false otherwise. Error will be put
> > > >   * inside errp if provided.
> > > >   */
> > > > -static bool migration_object_check(MigrationState *ms, Error **errp)
> > > > +static void migration_object_check(MigrationState *ms, Error **errp)
> > > >  {
> > >
> > > I'm not sure if this is a good change.
> > > Where we have a function that returns an error via an Error ** it's
> > > normal practice for us to return a bool to say whether it generated an
> > > error.
> > >
> > > Now, in our case we only call it with error_fatal:
> > >
> > >     migration_object_check(current_migration, &error_fatal);
> > >
> > > so the bool isn't used/checked.
> > >
> > > So I'm a bit conflicted:
> > >
> > >   a) Using error_fatal is the easiest way to handle this function
> > >   b) Things taking Error ** normally do return a flag value
> > >   c) But it's not used in this case.
> > >
> > > Hmm.
> > 
> > I guess this generalizes to the bigger question of whether a global
> > "return-value-never-used" check makes sense and brings value. Maybe
> > there are too many cases where it would be preferable to keep the
> > return value for consistency? Maybe they're not that many and could be
> > tagged with __attribute__((unused))?
> > 
> > But in this particular case, perhaps we could drop the Error **errp
> > parameter and directly pass &error_fatal to migrate_params_check() and
> > migrate_caps_check().
> 
> If it helps to think about this, Coverity checks for consistency.
> Across the whole code base, is the return value of a function used or
> ignored consistently.  You will see Coverity errors like:

> What it's saying is that in this code base, nbd_poll's return value
> was checked by the caller 5 out of 6 times, but ignored here.  (This
> turned out to be a real bug which we fixed).
>
> It seems like the check implemented in your patch is: If the return
> value is used 0 times anywhere in the code base, change the return
> value to 'void'.  Coverity would not flag this.
> 
> Maybe a consistent use check is better?

Inconsistent return value checking is designed-in behaviour for
QEMU's current Error handling coding pattern with error_abort/fatal.

If we wanted to make it consistent we would need to require that
all methods with 'Error **errp' are tagged 'attribute(unused)'
and then provide

  # define ignore_value(x) \
     (__extension__ ({ __typeof__ (x) __x = (x); (void) __x; }))

Such that if you want to use  error_abort/error_fatal, you
need to explicitly discard the return value eg

   ignore_value(some_method(&error_abort));

If I was starting QEMU fresh, I think like the attribute(unused)
anntation and explicit discard, but to retrofit it now would
require updated about 3000 current callers which pass &error_abort
and &error_fatal.

On the flipside I am willing to bet that doing this work would
identify existing bugs where we don't pass error_abort/fatal
and also fail to check for failure. So there would be potential
payback for the vast churn

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

