Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6622FBA2B
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 15:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390571AbhASOp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 09:45:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20797 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389466AbhASKEp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 05:04:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611050599;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=uJE0F33cZMQfWxlJld0rtbaTxrpyNj2SkPYOONCRxug=;
        b=Rg5tKtyed1UIKDoqnR9aVSt2Kfgpa6I2hYSG3vHChl8X62r6PHHFehZOsr89jg3FwtwZun
        DPGLWfp2XpU2kbHJoIrwmOyZrjOrGtJEd6C7KekloQokMm+xMIjrO8LB1O6IABol1mDCc+
        cPwKmqvzwr6XaPkSlOehPE577ru/Wls=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-r1dRp5oVNaOO9PjcuK64uA-1; Tue, 19 Jan 2021 04:59:47 -0500
X-MC-Unique: r1dRp5oVNaOO9PjcuK64uA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EC581842140;
        Tue, 19 Jan 2021 09:59:45 +0000 (UTC)
Received: from redhat.com (ovpn-112-84.ams2.redhat.com [10.36.112.84])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 80B556A90C;
        Tue, 19 Jan 2021 09:59:30 +0000 (UTC)
Date:   Tue, 19 Jan 2021 09:59:27 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, pair@us.ibm.com,
        brijesh.singh@amd.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
        frankja@linux.ibm.com, david@redhat.com, mdroth@linux.vnet.ibm.com,
        Halil Pasic <pasic@linux.ibm.com>, borntraeger@de.ibm.com,
        David Gibson <david@gibson.dropbear.id.au>, thuth@redhat.com,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Greg Kurz <groug@kaod.org>, dgilbert@redhat.com,
        qemu-s390x@nongnu.org, rth@twiddle.net,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-ppc@nongnu.org,
        pbonzini@redhat.com
Subject: Re: Re: [for-6.0 v5 11/13] spapr: PEF: prevent migration
Message-ID: <20210119095927.GB1830870@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210104134629.49997b53.pasic@linux.ibm.com>
 <20210104184026.GD4102@ram-ibm-com.ibm.com>
 <20210105115614.7daaadd6.pasic@linux.ibm.com>
 <20210105204125.GE4102@ram-ibm-com.ibm.com>
 <20210111175914.13adfa2e.cohuck@redhat.com>
 <20210111195830.GA23898@ram-ibm-com.ibm.com>
 <20210112091943.095c3b29.cohuck@redhat.com>
 <20210112185511.GB23898@ram-ibm-com.ibm.com>
 <20210113090629.2f41a9d3.cohuck@redhat.com>
 <20210115185514.GB24076@ram-ibm-com.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210115185514.GB24076@ram-ibm-com.ibm.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 15, 2021 at 10:55:14AM -0800, Ram Pai wrote:
> On Wed, Jan 13, 2021 at 09:06:29AM +0100, Cornelia Huck wrote:
> > On Tue, 12 Jan 2021 10:55:11 -0800
> > Ram Pai <linuxram@us.ibm.com> wrote:
> > 
> > > On Tue, Jan 12, 2021 at 09:19:43AM +0100, Cornelia Huck wrote:
> > > Actually the two options are inherently NOT incompatible.  Halil also
> > > mentioned this in one of his replies.
> > > 
> > > Its just that the current implementation is lacking, which will be fixed
> > > in the near future. 
> > > 
> > > We can design it upfront, with the assumption that they both are compatible.
> > > In the short term  disable one; preferrably the secure-object, if both 
> > > options are specified. In the long term, remove the restriction, when
> > > the implemetation is complete.
> > 
> > Can't we simply mark the object as non-migratable now, and then remove
> > that later? I don't see what is so special about it.
> 
> This is fine too. 
> 
> However I am told that libvirt has some assumptions, where it assumes
> that the VM is guaranteed to be migratable if '--only-migratable' is
> specified. Silently turning off that option can be bad.

TO be clear libvirt does *not* currently use --only-migratable.

What you're describing here is QEMU's own definition of this flag

 $ qemu-system-x86_64 | grep migratable
 -only-migratable     allow only migratable devices


Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

