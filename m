Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDB72D0DF9
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 11:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgLGK0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 05:26:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49040 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726076AbgLGK0w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 05:26:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607336725;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lgvE6LyH4jrE6pQS01wyiRU9NGcs0HDZI4+lkUVm7vc=;
        b=HEhpMnQ+XLIrHO4FWkVVCTFIgHBRpY+s0JhdVTs64XOAWq0nEdzU4lEdnoz/nQ+q6fCaSQ
        kNVnigQsYBNIz5UAsXCTWaYWDu5YbKZR9LiolZIy8ov4uDKzVqwF30ERJxECHST+FsFhzJ
        3d1H1DPIBgLpflcCCgvpzGJ7oKPXgBg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-VhlrEtJON5GtTXd0WawECg-1; Mon, 07 Dec 2020 05:25:23 -0500
X-MC-Unique: VhlrEtJON5GtTXd0WawECg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADC311005513;
        Mon,  7 Dec 2020 10:25:20 +0000 (UTC)
Received: from redhat.com (ovpn-113-137.ams2.redhat.com [10.36.113.137])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6921C60BE2;
        Mon,  7 Dec 2020 10:25:12 +0000 (UTC)
Date:   Mon, 7 Dec 2020 10:25:08 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        kvm@vger.kernel.org, Paul Durrant <paul@xen.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Willian Rampazzo <wrampazz@redhat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        xen-devel@lists.xenproject.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Claudio Fontana <cfontana@suse.de>
Subject: Re: [PATCH 5/8] gitlab-ci: Add KVM s390x cross-build jobs
Message-ID: <20201207102450.GG3102898@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20201206185508.3545711-1-philmd@redhat.com>
 <20201206185508.3545711-6-philmd@redhat.com>
 <66d4d0ab-2bb5-1284-b08a-43c6c30f30dc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <66d4d0ab-2bb5-1284-b08a-43c6c30f30dc@redhat.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 07, 2020 at 06:46:01AM +0100, Thomas Huth wrote:
> On 06/12/2020 19.55, Philippe Mathieu-Daudé wrote:
> > Cross-build s390x target with only KVM accelerator enabled.
> > 
> > Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> > ---
> >  .gitlab-ci.d/crossbuilds-kvm-s390x.yml | 6 ++++++
> >  .gitlab-ci.yml                         | 1 +
> >  MAINTAINERS                            | 1 +
> >  3 files changed, 8 insertions(+)
> >  create mode 100644 .gitlab-ci.d/crossbuilds-kvm-s390x.yml
> > 
> > diff --git a/.gitlab-ci.d/crossbuilds-kvm-s390x.yml b/.gitlab-ci.d/crossbuilds-kvm-s390x.yml
> > new file mode 100644
> > index 00000000000..1731af62056
> > --- /dev/null
> > +++ b/.gitlab-ci.d/crossbuilds-kvm-s390x.yml
> > @@ -0,0 +1,6 @@
> > +cross-s390x-kvm:
> > +  extends: .cross_accel_build_job
> > +  variables:
> > +    IMAGE: debian-s390x-cross
> > +    TARGETS: s390x-softmmu
> > +    ACCEL_CONFIGURE_OPTS: --disable-tcg
> > diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> > index 573afceb3c7..a69619d7319 100644
> > --- a/.gitlab-ci.yml
> > +++ b/.gitlab-ci.yml
> > @@ -14,6 +14,7 @@ include:
> >    - local: '/.gitlab-ci.d/crossbuilds.yml'
> >    - local: '/.gitlab-ci.d/crossbuilds-kvm-x86.yml'
> >    - local: '/.gitlab-ci.d/crossbuilds-kvm-arm.yml'
> > +  - local: '/.gitlab-ci.d/crossbuilds-kvm-s390x.yml'
> 
> KVM code is already covered by the "cross-s390x-system" job, but an
> additional compilation test with --disable-tcg makes sense here. I'd then
> rather name it "cross-s390x-no-tcg" or so instead of "cross-s390x-kvm".
> 
> And while you're at it, I'd maybe rather name the new file just
> crossbuilds-s390x.yml and also move the other s390x related jobs into it?

I don't think we really should split it up so much - just put these
jobs in the existing crosbuilds.yml file.


Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

