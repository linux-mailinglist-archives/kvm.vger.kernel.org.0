Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1898067211C
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 16:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbjARPWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 10:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjARPWW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 10:22:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A014DCCD
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 07:18:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674055083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fxqiyPyz0bm5LMmALWpRHR+Gt7Wpl/8XB6QOPfhNxGs=;
        b=bwHErAME2w7icybTg4dn2JOXQ5FSsIT9B9Po/nFD8TXa+soD+sqow3tuRhli2WuaXAaDQN
        CFF91SnRqRTLdGinbL1pgvh0Pcg0Gq1WuSua0ZkdsDhD5dkbpHS4t45jv48tiOMAFLpwUY
        Rzz7cxuCwWMNkaawb+ScnP8vNI1ur3E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-f7ifZX39OSGXgg5Rf4Dc1g-1; Wed, 18 Jan 2023 10:18:02 -0500
X-MC-Unique: f7ifZX39OSGXgg5Rf4Dc1g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AFBF8A011D;
        Wed, 18 Jan 2023 15:18:00 +0000 (UTC)
Received: from redhat.com (unknown [10.39.194.202])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D6907140EBF5;
        Wed, 18 Jan 2023 15:17:56 +0000 (UTC)
Date:   Wed, 18 Jan 2023 16:17:55 +0100
From:   Kevin Wolf <kwolf@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, hreitz@redhat.com
Subject: Re: [PATCH v14 08/11] qapi/s390/cpu topology: change-topology
 monitor command
Message-ID: <Y8gNo74mLXwAxVqy@redhat.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-9-pmorel@linux.ibm.com>
 <72baa5b42abe557cdf123889b33b845b405cc86c.camel@linux.ibm.com>
 <cd9e0c88-c2a8-1eca-d146-3fd6639af3e7@redhat.com>
 <5654d88fb7d000369c6cfdbe0213ca9d2bfe013b.camel@linux.ibm.com>
 <91566c93-a422-7969-1f7e-80c6f3d214f1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91566c93-a422-7969-1f7e-80c6f3d214f1@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 18.01.2023 um 11:53 hat Thomas Huth geschrieben:
> On 17/01/2023 14.31, Nina Schoetterl-Glausch wrote:
> > On Tue, 2023-01-17 at 08:30 +0100, Thomas Huth wrote:
> > > On 16/01/2023 22.09, Nina Schoetterl-Glausch wrote:
> > > > On Thu, 2023-01-05 at 15:53 +0100, Pierre Morel wrote:
> > > > > The modification of the CPU attributes are done through a monitor
> > > > > commands.
> > > > > 
> > > > > It allows to move the core inside the topology tree to optimise
> > > > > the cache usage in the case the host's hypervizor previously
> > > > > moved the CPU.
> > > > > 
> > > > > The same command allows to modifiy the CPU attributes modifiers
> > > > > like polarization entitlement and the dedicated attribute to notify
> > > > > the guest if the host admin modified scheduling or dedication of a vCPU.
> > > > > 
> > > > > With this knowledge the guest has the possibility to optimize the
> > > > > usage of the vCPUs.
> > > > > 
> > > > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > > > ---
> ...
> > > > > +    s390_topology.sockets[s390_socket_nb(id)]--;
> > > > 
> > > > I suppose this function cannot run concurrently, so the same CPU doesn't get removed twice.
> > > 
> > > QEMU has the so-called BQL - the Big Qemu Lock. Instructions handlers are
> > > normally called with the lock taken, see qemu_mutex_lock_iothread() in
> > > target/s390x/kvm/kvm.c.
> > 
> > That is good to know, but is that the relevant lock here?
> > We don't want to concurrent qmp commands. I looked at the code and it's pretty complicated.
> 
> Not sure, but I believe that QMP commands are executed from the main
> iothread, so I think this should be safe? ... CC:-ing some more people who
> might know the correct answer.

In general yes, QMP commands are processed one after another in the main
thread while holding the BQL. And I think this is the relevant case for
you.

The exception is out-of-band commands, which I think run in the monitor
thread while some other (normal) command could be processed. OOB
commands are quite limited in what they are allowed to do, though, and
there aren't many of them. They are mainly meant to fix situations where
something (including other QMP commands) got stuck.

Kevin

