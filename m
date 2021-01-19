Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDED2FBE0A
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 18:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388780AbhASOxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 09:53:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43641 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404335AbhASOUj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 09:20:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611065949;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e4lGdVdmkN/Ga8lU/llQpCYxS+NnKTYRN5QUMOdV3ng=;
        b=jWo6YKIxEyHcr9EoCxnNM+L4B+1IlIlSIgafd4NCrLEe50Mjg5kwbWOVrxc0rA3v17wB/7
        XfhfC/Fdh4nFKefwJc4qTuZGj2Z8YEZ/8S6CO+guUW79kLQd9IHOMUBu6Gg09OLYLZ0lw2
        6lP3F8k2QOMCicQUPtYI46+3QkzZYg4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-4sgrMPIqMluHZvnmZ8zHwg-1; Tue, 19 Jan 2021 09:19:04 -0500
X-MC-Unique: 4sgrMPIqMluHZvnmZ8zHwg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27E94802B40;
        Tue, 19 Jan 2021 14:19:01 +0000 (UTC)
Received: from redhat.com (ovpn-112-84.ams2.redhat.com [10.36.112.84])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3162610021AA;
        Tue, 19 Jan 2021 14:18:50 +0000 (UTC)
Date:   Tue, 19 Jan 2021 14:18:48 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>, Fam Zheng <fam@euphon.net>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        qemu-block@nongnu.org,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        qemu-devel@nongnu.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Greg Kurz <groug@kaod.org>, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>, Max Reitz <mreitz@redhat.com>,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v2 8/9] tests/docker: Add dockerfile for Alpine Linux
Message-ID: <20210119141848.GC2335568@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
 <20210118063808.12471-9-jiaxun.yang@flygoat.com>
 <20210118103345.GE1789637@redhat.com>
 <929c3ec1-9419-908a-6b5e-ce3ae78f6011@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <929c3ec1-9419-908a-6b5e-ce3ae78f6011@redhat.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 19, 2021 at 02:41:47PM +0100, Thomas Huth wrote:
> On 18/01/2021 11.33, Daniel P. Berrangé wrote:
> > On Mon, Jan 18, 2021 at 02:38:07PM +0800, Jiaxun Yang wrote:
> > > Alpine Linux[1] is a security-oriented, lightweight Linux distribution
> > > based on musl libc and busybox.
> > > 
> > > It it popular among Docker guests and embedded applications.
> > > 
> > > Adding it to test against different libc.
> > > 
> > > [1]: https://alpinelinux.org/
> > > 
> > > Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > > ---
> > >   tests/docker/dockerfiles/alpine.docker | 57 ++++++++++++++++++++++++++
> > >   1 file changed, 57 insertions(+)
> > >   create mode 100644 tests/docker/dockerfiles/alpine.docker
> > > 
> > > diff --git a/tests/docker/dockerfiles/alpine.docker b/tests/docker/dockerfiles/alpine.docker
> > > new file mode 100644
> > > index 0000000000..5be5198d00
> > > --- /dev/null
> > > +++ b/tests/docker/dockerfiles/alpine.docker
> > > @@ -0,0 +1,57 @@
> > > +
> > > +FROM alpine:edge
> > > +
> > > +RUN apk update
> > > +RUN apk upgrade
> > > +
> > > +# Please keep this list sorted alphabetically
> > > +ENV PACKAGES \
> > > +	alsa-lib-dev \
> > > +	bash \
> > > +	bison \
> > 
> > This shouldn't be required.
> 
> bison and flex were required to avoid some warnings in the past while
> compiling the dtc submodule ... but I thought we got rid of the problem at
> one point in time, so this can be removed now, indeed.
> 
> > > +	build-base \
> > 
> > This seems to be a meta packae that pulls in other
> > misc toolchain packages. Please list the pieces we
> > need explicitly instead.
> 
> Looking at the "Depends" list on
> https://pkgs.alpinelinux.org/package/v3.3/main/x86/build-base there are only
> 6 dependencies and we need most of those for QEMU anyway, so I think it is
> ok to keep build-base here.

I would like to keep them all explicit, as it makes it easier for us to
ensure that we have provided the same set of dependancies across all our
dockerfiles. Ideally we'll add Alpiine to libvirt-ci, so that we can then
auto-generate this dockerfile in future.


> > > +	perl \
> > > +	pulseaudio-dev \
> > > +	python3 \
> > > +	py3-sphinx \
> > > +	shadow \
> > 
> > Is this really needed ?
> 
> See:
> https://www.spinics.net/lists/kvm/msg231556.html

Ok, so this is required by the docker.py commands running extra tools.

The other dockerfiles are working just by luck, and we should make this
package expicit on all of them too


Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

