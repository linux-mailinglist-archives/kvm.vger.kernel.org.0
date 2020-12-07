Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA652D0E19
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 11:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgLGKgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 05:36:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52078 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726278AbgLGKgR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 05:36:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607337290;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rHJ/6LZZ/l4zPSaAfktxXxObRN4BFZ04xcSZNsVRSp0=;
        b=FmsYVwxki2MY2x3U6b8nIYm0w/ZkwW7csemX64pQ/GotLfHXpl+wS1/nI34zFoz84uFjCZ
        c9KK0nQoJ7enNzIlg3dUkH7bLrdgJNlgn71TC1+jy7RL6ljSk2xrYg6/5gSVcxScr1IZsO
        ssLHsJz5pyzd0k/9WYP8YoNP5et6da4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-wgEpu-mVPbGqhVGeG4IaJA-1; Mon, 07 Dec 2020 05:34:49 -0500
X-MC-Unique: wgEpu-mVPbGqhVGeG4IaJA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9069190B2A2;
        Mon,  7 Dec 2020 10:34:46 +0000 (UTC)
Received: from redhat.com (ovpn-113-137.ams2.redhat.com [10.36.113.137])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F26E760C62;
        Mon,  7 Dec 2020 10:34:33 +0000 (UTC)
Date:   Mon, 7 Dec 2020 10:34:30 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paul Durrant <paul@xen.org>, Cornelia Huck <cohuck@redhat.com>,
        qemu-devel@nongnu.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, Claudio Fontana <cfontana@suse.de>,
        Willian Rampazzo <wrampazz@redhat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH 5/8] gitlab-ci: Add KVM s390x cross-build jobs
Message-ID: <20201207103430.GI3102898@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20201206185508.3545711-1-philmd@redhat.com>
 <20201206185508.3545711-6-philmd@redhat.com>
 <66d4d0ab-2bb5-1284-b08a-43c6c30f30dc@redhat.com>
 <20201207102450.GG3102898@redhat.com>
 <9233fe7f-8d56-e1ad-b67e-40b3ce5fcabb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9233fe7f-8d56-e1ad-b67e-40b3ce5fcabb@redhat.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 07, 2020 at 11:26:58AM +0100, Philippe Mathieu-Daudé wrote:
> On 12/7/20 11:25 AM, Daniel P. Berrangé wrote:
> > On Mon, Dec 07, 2020 at 06:46:01AM +0100, Thomas Huth wrote:
> >> On 06/12/2020 19.55, Philippe Mathieu-Daudé wrote:
> >>> Cross-build s390x target with only KVM accelerator enabled.
> >>>
> >>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> >>> ---
> >>>  .gitlab-ci.d/crossbuilds-kvm-s390x.yml | 6 ++++++
> >>>  .gitlab-ci.yml                         | 1 +
> >>>  MAINTAINERS                            | 1 +
> >>>  3 files changed, 8 insertions(+)
> >>>  create mode 100644 .gitlab-ci.d/crossbuilds-kvm-s390x.yml
> >>>
> >>> diff --git a/.gitlab-ci.d/crossbuilds-kvm-s390x.yml b/.gitlab-ci.d/crossbuilds-kvm-s390x.yml
> >>> new file mode 100644
> >>> index 00000000000..1731af62056
> >>> --- /dev/null
> >>> +++ b/.gitlab-ci.d/crossbuilds-kvm-s390x.yml
> >>> @@ -0,0 +1,6 @@
> >>> +cross-s390x-kvm:
> >>> +  extends: .cross_accel_build_job
> >>> +  variables:
> >>> +    IMAGE: debian-s390x-cross
> >>> +    TARGETS: s390x-softmmu
> >>> +    ACCEL_CONFIGURE_OPTS: --disable-tcg
> >>> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> >>> index 573afceb3c7..a69619d7319 100644
> >>> --- a/.gitlab-ci.yml
> >>> +++ b/.gitlab-ci.yml
> >>> @@ -14,6 +14,7 @@ include:
> >>>    - local: '/.gitlab-ci.d/crossbuilds.yml'
> >>>    - local: '/.gitlab-ci.d/crossbuilds-kvm-x86.yml'
> >>>    - local: '/.gitlab-ci.d/crossbuilds-kvm-arm.yml'
> >>> +  - local: '/.gitlab-ci.d/crossbuilds-kvm-s390x.yml'
> >>
> >> KVM code is already covered by the "cross-s390x-system" job, but an
> >> additional compilation test with --disable-tcg makes sense here. I'd then
> >> rather name it "cross-s390x-no-tcg" or so instead of "cross-s390x-kvm".
> >>
> >> And while you're at it, I'd maybe rather name the new file just
> >> crossbuilds-s390x.yml and also move the other s390x related jobs into it?
> > 
> > I don't think we really should split it up so much - just put these
> > jobs in the existing crosbuilds.yml file.
> 
> Don't we want to leverage MAINTAINERS file?

As mentioned in the cover letter, I think this is mis-using the MAINTAINERS
file to try to represent something different.

The MAINTAINERS file says who is responsible for the contents of the .yml
file, which is the CI maintainers, because we want a consistent gitlab
configuration as a whole, not everyone doing their own thing.

MAINTAINERS doesn't say who is responsible for making sure the actual
jobs that run are passing, which is potentially a completely different
person. If we want to track that, it is not the MAINTAINERS file.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

