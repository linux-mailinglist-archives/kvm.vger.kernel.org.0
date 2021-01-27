Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C813057AF
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 11:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbhA0KCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 05:02:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47247 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235676AbhA0KAm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 05:00:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611741555;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IE9lfqBYRWAXVyxhCxtNnr3w1/VHDFaexCDYTNcRvzg=;
        b=IgLf2nINvLKRqUuznH55x7CebFv9gjNIGnYe8QRBIXX3wtpn+uoWzDbZ4RgInzXd4+LbRn
        rcVxX1EibHY74+L8Ki+FeO4QawKpeihdnWeSbEBqAo56pad9zZ20lsveel5C72X3SJbRf4
        e4KkqXZeRWM+LhQ45W0oTGtsoVBIGdU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-L1RunsaFNKmpbeLOhJxudA-1; Wed, 27 Jan 2021 04:59:01 -0500
X-MC-Unique: L1RunsaFNKmpbeLOhJxudA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72628801AA3;
        Wed, 27 Jan 2021 09:58:59 +0000 (UTC)
Received: from redhat.com (ovpn-115-120.ams2.redhat.com [10.36.115.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BA76F60938;
        Wed, 27 Jan 2021 09:58:48 +0000 (UTC)
Date:   Wed, 27 Jan 2021 09:58:46 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     John Snow <jsnow@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Fam Zheng <fam@euphon.net>,
        Laurent Vivier <lvivier@redhat.com>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        qemu-block@nongnu.org,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Alistair Francis <alistair@alistair23.me>,
        qemu-devel@nongnu.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Greg Kurz <groug@kaod.org>, Max Reitz <mreitz@redhat.com>,
        qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v2 8/9] tests/docker: Add dockerfile for Alpine Linux
Message-ID: <20210127095846.GC3653144@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
 <20210118063808.12471-9-jiaxun.yang@flygoat.com>
 <20210118103345.GE1789637@redhat.com>
 <929c3ec1-9419-908a-6b5e-ce3ae78f6011@redhat.com>
 <551e153e-34da-28bd-c67f-d2a688ad987b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <551e153e-34da-28bd-c67f-d2a688ad987b@redhat.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 26, 2021 at 04:38:57PM -0500, John Snow wrote:
> On 1/19/21 8:41 AM, Thomas Huth wrote:
> > On 18/01/2021 11.33, Daniel P. Berrangé wrote:
> > > On Mon, Jan 18, 2021 at 02:38:07PM +0800, Jiaxun Yang wrote:
> > > > Alpine Linux[1] is a security-oriented, lightweight Linux distribution
> > > > based on musl libc and busybox.
> > > > 
> > > > It it popular among Docker guests and embedded applications.
> > > > 
> > > > Adding it to test against different libc.
> > > > 
> > > > [1]: https://alpinelinux.org/
> > > > 
> > > > Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > > > ---
> > > >   tests/docker/dockerfiles/alpine.docker | 57 ++++++++++++++++++++++++++
> > > >   1 file changed, 57 insertions(+)
> > > >   create mode 100644 tests/docker/dockerfiles/alpine.docker
> > > > 
> > > > diff --git a/tests/docker/dockerfiles/alpine.docker
> > > > b/tests/docker/dockerfiles/alpine.docker
> > > > new file mode 100644
> > > > index 0000000000..5be5198d00
> > > > --- /dev/null
> > > > +++ b/tests/docker/dockerfiles/alpine.docker
> > > > @@ -0,0 +1,57 @@
> > > > +
> > > > +FROM alpine:edge
> > > > +
> > > > +RUN apk update
> > > > +RUN apk upgrade
> > > > +
> > > > +# Please keep this list sorted alphabetically
> > > > +ENV PACKAGES \
> > > > +    alsa-lib-dev \
> > > > +    bash \
> > > > +    bison \
> > > 
> > > This shouldn't be required.
> > 
> > bison and flex were required to avoid some warnings in the past while
> > compiling the dtc submodule ... but I thought we got rid of the problem
> > at one point in time, so this can be removed now, indeed.
> > 
> > > > +    build-base \
> > > 
> > > This seems to be a meta packae that pulls in other
> > > misc toolchain packages. Please list the pieces we
> > > need explicitly instead.
> > 
> > Looking at the "Depends" list on
> > https://pkgs.alpinelinux.org/package/v3.3/main/x86/build-base there are
> > only 6 dependencies and we need most of those for QEMU anyway, so I
> > think it is ok to keep build-base here.
> > 
> > > > +    coreutils \
> > > > +    curl-dev \
> > > > +    flex \
> > > 
> > > This shouldn't be needed.
> > > 
> > > > +    git \
> > > > +    glib-dev \
> > > > +    glib-static \
> > > > +    gnutls-dev \
> > > > +    gtk+3.0-dev \
> > > > +    libaio-dev \
> > > > +    libcap-dev \
> > > 
> > > Should not be required, as we use cap-ng.
> > 
> > Right.
> > 
> > > > +    libcap-ng-dev \
> > > > +    libjpeg-turbo-dev \
> > > > +    libnfs-dev \
> > > > +    libpng-dev \
> > > > +    libseccomp-dev \
> > > > +    libssh-dev \
> > > > +    libusb-dev \
> > > > +    libxml2-dev \
> > > > +    linux-headers \
> > > 
> > > Is this really needed ? We don't install kernel-headers on other
> > > distros AFAICT.
> > 
> > I tried a build without this package, and it works fine indeed.
> > 
> > > > +    lzo-dev \
> > > > +    mesa-dev \
> > > > +    mesa-egl \
> > > > +    mesa-gbm \
> > > > +    meson \
> > > > +    ncurses-dev \
> > > > +    ninja \
> > > > +    paxmark \
> > > 
> > > What is this needed for ?
> > 
> > Seems like it also can be dropped.
> > 
> > > > +    perl \
> > > > +    pulseaudio-dev \
> > > > +    python3 \
> > > > +    py3-sphinx \
> > > > +    shadow \
> > > 
> > > Is this really needed ?
> > 
> > See:
> > https://www.spinics.net/lists/kvm/msg231556.html
> > 
> > I can remove the superfluous packages when picking up the patch, no need
> > to respin just because of this.
> > 
> >   Thomas
> > 
> > 
> 
> You can refer to my post earlier this January for a "minimal" Alpine Linux
> build, if you wish.
> 
> My goal was to find the smallest set of packages possible without passing
> any explicit configure flags.
> 
> I wonder if it's worth having layered "core build" and "test build" images
> so that we can smoke test the minimalistic build from time to time -- I seem
> to recall Dan posting information about a dependency management tool for
> Dockerfiles, but I admit I didn't look too closely at what problem that
> solves, exactly.

I'd rather we avoid layered images entirely as it creates extra stages
in the gitlab pipeline, and also makes it more complex to auto-generate.

Once this initial alpine image is merged, then I intend to add it to the
set which are auto-generated from my other patch series.


Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

