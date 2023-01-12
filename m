Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C873667D76
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 19:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240405AbjALSFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 13:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240190AbjALSEd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 13:04:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E25055BE
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 09:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673544633;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i/lvS+ojIOxa33FISjD+yVm9wbamhlAkCJM+NcfjFlc=;
        b=gXBgBQ/onhhSQ5Z4j9vMDX5pFLEGy6jw0Iy0aaNvEpzDPpgBLkcjqcoiJAU3fZ5TUH/z2V
        LfdBT3SceRSf4/FqDN6qKhKAY3LPn96Xx2H7tkqp4sklH8EwkKEzqOzcteHkRY5IY8/OGW
        mG0v/X4A44MQxQsAtkJnWsz07DFwjzI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-vMTougR0OeitbYJ6baXRag-1; Thu, 12 Jan 2023 12:30:30 -0500
X-MC-Unique: vMTougR0OeitbYJ6baXRag-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75B673806721;
        Thu, 12 Jan 2023 17:30:29 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.222])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 08DD5492B02;
        Thu, 12 Jan 2023 17:30:26 +0000 (UTC)
Date:   Thu, 12 Jan 2023 17:30:24 +0000
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
Subject: Re: [PATCH v14 09/11] qapi/s390/cpu topology: monitor query topology
 information
Message-ID: <Y8BDsKzEqJ2Jm1OM@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-10-pmorel@linux.ibm.com>
 <Y7/4rm9JYihUpLS1@redhat.com>
 <71b5c6d559cec1eeb003ef7bc892a81da4efa613.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71b5c6d559cec1eeb003ef7bc892a81da4efa613.camel@linux.ibm.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 06:27:04PM +0100, Nina Schoetterl-Glausch wrote:
> On Thu, 2023-01-12 at 12:10 +0000, Daniel P. Berrangé wrote
> 
> [...]
> > 
> > We already have 'query-cpus-fast' wich returns one entry for
> > each CPU. In fact why do we need to add query-topology at all.
> > Can't we just add book-id / drawer-id / polarity / dedicated
> > to the query-cpus-fast result ?
> 
> Is there an existing command for setting cpu properties, also?

No, there's nothing applicable that I recall for runtime property
changes on CPUs.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

