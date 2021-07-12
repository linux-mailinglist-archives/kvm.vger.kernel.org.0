Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A923C606B
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 18:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbhGLQ1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 12:27:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27907 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233207AbhGLQ1h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Jul 2021 12:27:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626107088;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I6N7G//TnrgB0muUq3po6aYpsEbMh78wpzpeCxHNHWE=;
        b=LZcLNVdnUMOSHFSDezwUGgOK5BjCxom/0fZZPNVvwuyX6JzNyhdXhz6D0o6cLnnl3+zUHi
        kgW8lMq42KsZOOyUWsMwU1UUZ0RE4B7X61q6/AC2UBwLvAIAmAXpRve9cGMBf2tjNVKy8X
        HKLRXspsyEW/OsOEyY2+zz73VkhFOJs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-0HyX2XqCP_O57od5GgF0EQ-1; Mon, 12 Jul 2021 12:24:45 -0400
X-MC-Unique: 0HyX2XqCP_O57od5GgF0EQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 846DD19057A2;
        Mon, 12 Jul 2021 16:24:43 +0000 (UTC)
Received: from redhat.com (ovpn-114-105.ams2.redhat.com [10.36.114.105])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E8A260C17;
        Mon, 12 Jul 2021 16:24:36 +0000 (UTC)
Date:   Mon, 12 Jul 2021 17:24:33 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     qemu-devel@nongnu.org, Connor Kuehl <ckuehl@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 2/6] i386/sev: extend sev-guest property to include
 SEV-SNP
Message-ID: <YOxswVowx3ksqMm3@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-3-brijesh.singh@amd.com>
 <YOxVIjuQnQnO9ytT@redhat.com>
 <cd63ed13-ba05-84de-ecba-6e497cf7874d@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cd63ed13-ba05-84de-ecba-6e497cf7874d@amd.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 12, 2021 at 10:56:40AM -0500, Brijesh Singh wrote:
> 
> 
> On 7/12/21 9:43 AM, Daniel P. Berrangé wrote:
> > On Fri, Jul 09, 2021 at 04:55:46PM -0500, Brijesh Singh wrote:
> > > To launch the SEV-SNP guest, a user can specify up to 8 parameters.
> > > Passing all parameters through command line can be difficult.
> > 
> > This sentence applies to pretty much everything in QEMU and the
> > SEV-SNP example is nowhere near an extreme example IMHO.
> > 
> > >                                                               To simplify
> > > the launch parameter passing, introduce a .ini-like config file that can be
> > > used for passing the parameters to the launch flow.
> > 
> > Inventing a new config file format for usage by just one specific
> > niche feature in QEMU is something I'd say we do not want.
> > 
> > Our long term goal in QEMU is to move to a world where 100% of
> > QEMU configuration is provided in JSON format, using the QAPI
> > schema to define the accepted input set.
> > 
> 
> I am open to all suggestions. I was trying to avoid passing all these
> parameters through the command line because some of them can be huge (up to
> a page size)
> 
> 
> > > 
> > > The contents of the config file will look like this:
> > > 
> > > $ cat snp-launch.init
> > > 
> > > # SNP launch parameters
> > > [SEV-SNP]
> > > init_flags = 0
> > > policy = 0x1000
> > > id_block = "YWFhYWFhYWFhYWFhYWFhCg=="
> > 
> > These parameters are really tiny and trivial to provide on the command
> > line, so I'm not finding this config file compelling.
> > 
> 
> I have only included 3 small parameters. Other parameters can be up to a
> page size. The breakdown looks like this:
> 
> policy: 8 bytes
> flags: 8 bytes
> id_block: 96 bytes
> id_auth: 4096 bytes
> host_data: 32 bytes
> gosvw: 16 bytes

Only the id_auth parameter is really considered large here.

When you say "up to a page size", that implies that the size is
actually variable.  Is that correct, and if so, what is a real
world common size going to be ? Is the common size much smaller
than this upper limit ? If so I'd just ignore the issue entirely.

If not, then, 4k on the command line is certainly ugly, but isn't
technically impossible. It would be similarly ugly to have this
value stuffed into a libvirt XML configuration for that matter.

One option is to supply only that one parameter via an external
file, with the file being an opaque blob whose context is the
parameter value thus avoiding inventing a custom file format
parser.

When "id_auth" is described as "authentication data", are there
any secrecy requirements around this ?

QEMU does have the '-object secret' framework for passing blobs
of sensitive data to QEMU and can allow passing via a file:

  https://qemu-project.gitlab.io/qemu/system/secrets.html

Even if this doesn't actually need to be kept private, we
could decide to simply (ab)use the 'secret' object anyway
as a way to let it be passed in out of band via a file.

Libvirt also has a 'secret' concept for passing blobs of
sensitive data out of band from the main XML config, which
could again be leveraged.

It does feel a little dirty to be using 'secrets' in libvirt
and QEMU for data that doesn't actually need to be secret,
just as a way to avoid huge config files. So we could just
ignore the secrets and directly have 'id_auth_file' as a
parameter and directly reference a file.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

