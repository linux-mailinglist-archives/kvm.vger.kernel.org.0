Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB1E2D0A52
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 06:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbgLGFnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 00:43:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20901 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725681AbgLGFnP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 00:43:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607319709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hLuvXS3NI6D8cDyFAW5Sct9681MJ4TRf7wvMzpU1WWE=;
        b=b8FZVnlegHmTqbTQ6PVm+PuUNwqkYY16HgG3k0iTmCmiSRKXN3RolqvVJKmu50SV0eUvXC
        lvKgQDVpImnA5+OaPuTaWEoBHFdpzmApItpf78j7VzkzuBohHdczKM2I95omPdYag/BarV
        OETM0y1+hOq9t+T0viPQ6VHJw02Gpo8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-EzR6j0tzNtSU__GG2EUBMw-1; Mon, 07 Dec 2020 00:41:47 -0500
X-MC-Unique: EzR6j0tzNtSU__GG2EUBMw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F4CB1005513;
        Mon,  7 Dec 2020 05:41:44 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-85.ams2.redhat.com [10.36.112.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 409601A262;
        Mon,  7 Dec 2020 05:41:32 +0000 (UTC)
Subject: Re: [PATCH 4/8] gitlab-ci: Add KVM ARM cross-build jobs
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Willian Rampazzo <wrampazz@redhat.com>,
        Paul Durrant <paul@xen.org>, Huacai Chen <chenhc@lemote.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Claudio Fontana <cfontana@suse.de>,
        Halil Pasic <pasic@linux.ibm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-s390x@nongnu.org,
        Aurelien Jarno <aurelien@aurel32.net>, qemu-arm@nongnu.org
References: <20201206185508.3545711-1-philmd@redhat.com>
 <20201206185508.3545711-5-philmd@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <2a75c6ea-013d-896e-8478-2312957d3ed2@redhat.com>
Date:   Mon, 7 Dec 2020 06:41:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201206185508.3545711-5-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/12/2020 19.55, Philippe Mathieu-Daudé wrote:
> Cross-build ARM aarch64 target with KVM and TCG accelerators enabled.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
> later this job will build KVM-only.
> ---
>  .gitlab-ci.d/crossbuilds-kvm-arm.yml | 5 +++++
>  .gitlab-ci.yml                       | 1 +
>  MAINTAINERS                          | 1 +
>  3 files changed, 7 insertions(+)
>  create mode 100644 .gitlab-ci.d/crossbuilds-kvm-arm.yml
> 
> diff --git a/.gitlab-ci.d/crossbuilds-kvm-arm.yml b/.gitlab-ci.d/crossbuilds-kvm-arm.yml
> new file mode 100644
> index 00000000000..c74c6fdc9fb
> --- /dev/null
> +++ b/.gitlab-ci.d/crossbuilds-kvm-arm.yml
> @@ -0,0 +1,5 @@
> +cross-arm64-kvm:
> +  extends: .cross_accel_build_job
> +  variables:
> +    IMAGE: debian-arm64-cross
> +    TARGETS: aarch64-softmmu

Now that's a little bit surprising, I had expected that the KVM code is
already compiled by the "cross-arm64-system" job ... but looking at the
output of a corresponding pipeline, it says "KVM support: NO", see e.g.:

https://gitlab.com/qemu-project/qemu/-/jobs/883985039#L298

What's going wrong there? ... ah, well, it's because of the
"--target-list-exclude=aarch64-softmmu" in the template :-(
That was stupid. So instead of adding a new job, could you please simply
replace the aarch64-softmmu there by arm-softmmu?

 Thanks,
  Thomas

