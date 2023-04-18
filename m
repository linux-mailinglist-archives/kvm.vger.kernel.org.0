Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87AB6E68C4
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 17:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbjDRP6F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 11:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjDRP6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 11:58:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E23C9769
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 08:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681833433;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jucnprft4R7dkXcGIPdnJO21tm1y/lrpfc+RdMe0Vr4=;
        b=Z9MTuGFgeDq+An5F9xxlBDBhusaQB/0o2JbJCAL2gIOUIU05K5kNFdIyqRZpnLJCm6fslr
        l0YMgf5OT2HDbb0/VqI2woC2Gxa7rBbbGps04tXLDSbDC67mtulRK6q63P+xojNw8nTzSb
        OrN/3rRwCrq6wpNEHN/npqOykO2uKEs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-ucSSOUnQMAuOp75x4TYC7w-1; Tue, 18 Apr 2023 11:57:10 -0400
X-MC-Unique: ucSSOUnQMAuOp75x4TYC7w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B5E8884EC3;
        Tue, 18 Apr 2023 15:57:06 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FE28492C3E;
        Tue, 18 Apr 2023 15:57:06 +0000 (UTC)
Date:   Tue, 18 Apr 2023 16:57:04 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com
Subject: Re: [PATCH v19 01/21] s390x/cpu topology: add s390 specifics to CPU
 topology
Message-ID: <ZD690MgTNAxcfkKp@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
 <20230403162905.17703-2-pmorel@linux.ibm.com>
 <4118bb4e-0505-26d3-3ffe-49245eae5364@kaod.org>
 <bd5cc488-20a7-54d1-7c3e-86136db77f84@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bd5cc488-20a7-54d1-7c3e-86136db77f84@linux.ibm.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023 at 02:26:05PM +0200, Pierre Morel wrote:
> 
> On 4/4/23 09:03, Cédric Le Goater wrote:
> > On 4/3/23 18:28, Pierre Morel wrote:
> > > diff --git a/include/hw/s390x/cpu-topology.h
> > > b/include/hw/s390x/cpu-topology.h
> > > new file mode 100644
> > > index 0000000000..83f31604cc
> > > --- /dev/null
> > > +++ b/include/hw/s390x/cpu-topology.h
> > > @@ -0,0 +1,15 @@
> > > +/*
> > > + * CPU Topology
> > > + *
> > > + * Copyright IBM Corp. 2022
> > 
> > Shouldn't we have some range : 2022-2023 ?
> 
> There was a discussion on this in the first spins, I think to remember that
> Nina wanted 22 and Thomas 23,
> 
> now we have a third opinion :) .
> 
> I must say that all three have their reasons and I take what the majority
> wants.
> 
> A vote?

Whether or not to include a single year, or range of years in
the copyright statement is ultimately a policy decision for the
copyright holder to take (IBM in this case I presume), and not
subject to community vote/preferences.

I will note that some (possibly even many) organizations consider
the year to be largely redundant and devoid of legal benefit, so
are happy with basically any usage of dates (first year, most recent
year, a range of years, or none at all). With this in mind, QEMU is
willing to accept any usage wrt dates in the copyright statement.

It is possible that IBM have a specific policy their employees are
expected to follow. If so, follow that.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

