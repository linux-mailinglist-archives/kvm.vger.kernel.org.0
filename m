Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E63264143
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 11:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730287AbgIJJQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 05:16:37 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32263 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726847AbgIJJPi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Sep 2020 05:15:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599729337;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W4LhbyuqlF5S6rmEVd7X2hXE/FDCj8fqPB7MayxFhdk=;
        b=A8TEpczKA1ro7p6GoZA1IxbfYh2K71LzX6OvH1UJ0vN5PMLaDX+lpTP4g5cPqWnR/XJoub
        8zgjEYSSScAi+rMWqQXFj6LaMtfIBgV3kDYc51d8hEMuL28KoTXlon0jm43lRYp7EbwTSF
        8OEPWd/Yn62qy8LwUTv8+Rq1Z/7qza4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-j17T7367PC2YHoZh06ZP8g-1; Thu, 10 Sep 2020 05:15:09 -0400
X-MC-Unique: j17T7367PC2YHoZh06ZP8g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A0481091061;
        Thu, 10 Sep 2020 09:15:07 +0000 (UTC)
Received: from redhat.com (ovpn-112-4.ams2.redhat.com [10.36.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA18960C07;
        Thu, 10 Sep 2020 09:14:56 +0000 (UTC)
Date:   Thu, 10 Sep 2020 10:14:54 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org, Laurent Vivier <lvivier@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Alistair Francis <alistair@alistair23.me>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Joel Stanley <joel@jms.id.au>, qemu-trivial@nongnu.org,
        qemu-arm@nongnu.org,
        =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH 5/6] hw/pci-host/q35: Rename PCI 'black hole as '(memory)
 hole'
Message-ID: <20200910091454.GE1083348@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20200910070131.435543-1-philmd@redhat.com>
 <20200910070131.435543-6-philmd@redhat.com>
 <7dbdef90-1ca6-bf27-7084-af0c716d01d9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7dbdef90-1ca6-bf27-7084-af0c716d01d9@redhat.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 10, 2020 at 09:15:02AM +0200, Thomas Huth wrote:
> On 10/09/2020 09.01, Philippe Mathieu-Daudé wrote:
> > In order to use inclusive terminology, rename "blackhole"
> > as "(memory)hole".
> 
> A black hole is a well-known astronomical term, which is simply named
> that way since it absorbes all light. I doubt that anybody could get
> upset by this term?

In this particular case I think the change is the right thing to do
simply because the astronomical analogy is not adding any value in
understanding. Calling it a "memoryhole" is more descriptive in what
is actually is.

> 
> > Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> > ---
> >  include/hw/pci-host/q35.h |  4 ++--
> >  hw/pci-host/q35.c         | 38 +++++++++++++++++++-------------------
> >  tests/qtest/q35-test.c    |  2 +-
> >  3 files changed, 22 insertions(+), 22 deletions(-)
> > 
> > diff --git a/include/hw/pci-host/q35.h b/include/hw/pci-host/q35.h
> > index 070305f83df..0fb90aca18b 100644
> > --- a/include/hw/pci-host/q35.h
> > +++ b/include/hw/pci-host/q35.h
> > @@ -48,8 +48,8 @@ typedef struct MCHPCIState {
> >      PAMMemoryRegion pam_regions[13];
> >      MemoryRegion smram_region, open_high_smram;
> >      MemoryRegion smram, low_smram, high_smram;
> > -    MemoryRegion tseg_blackhole, tseg_window;
> > -    MemoryRegion smbase_blackhole, smbase_window;
> > +    MemoryRegion tseg_hole, tseg_window;
> > +    MemoryRegion smbase_hole, smbase_window;
> 
> Maybe rather use smbase_memhole and tseg_memhole?
> 
>  Thomas
> 
> 

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

