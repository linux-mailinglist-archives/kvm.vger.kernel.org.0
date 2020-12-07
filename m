Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A142D0A76
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 06:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgLGF7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 00:59:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31293 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725773AbgLGF7S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 00:59:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607320671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R0BBgmAIun19ecWxrxGSMAu6pxT4TBupQwMGoVA8c7E=;
        b=Hgc5eHXFDGIotYxtivf3YmhIc4vBVKwPq99psVPqGssJUAPwCUPjUfgp06w/Rj1fUKB+Cd
        DCg8GOUHNHAvmsW6nBbv1PG3rxrnvG6LX9g2HWHj70MzRpaiY/xrK5cPaAeHbVCGC3QCJ5
        3x0mTl9AfNMhSgXaR2l235NkkN08oFY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-DGCDi2V8PqC2tkcP-WhOyg-1; Mon, 07 Dec 2020 00:57:48 -0500
X-MC-Unique: DGCDi2V8PqC2tkcP-WhOyg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B19E180E460;
        Mon,  7 Dec 2020 05:57:45 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-85.ams2.redhat.com [10.36.112.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31A93100239A;
        Mon,  7 Dec 2020 05:57:32 +0000 (UTC)
Subject: Re: [PATCH 6/8] gitlab-ci: Add KVM PPC cross-build jobs
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
 <20201206185508.3545711-7-philmd@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <ffafcb2d-c32e-95ef-82c7-20bf5c366df7@redhat.com>
Date:   Mon, 7 Dec 2020 06:57:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201206185508.3545711-7-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/12/2020 19.55, Philippe Mathieu-Daudé wrote:
> Cross-build PPC target with KVM and TCG accelerators enabled.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
> later this job build KVM-only.
> ---
>  .gitlab-ci.d/crossbuilds-kvm-ppc.yml | 5 +++++
>  .gitlab-ci.yml                       | 1 +
>  MAINTAINERS                          | 1 +
>  3 files changed, 7 insertions(+)
>  create mode 100644 .gitlab-ci.d/crossbuilds-kvm-ppc.yml
> 
> diff --git a/.gitlab-ci.d/crossbuilds-kvm-ppc.yml b/.gitlab-ci.d/crossbuilds-kvm-ppc.yml
> new file mode 100644
> index 00000000000..9df8bcf5a73
> --- /dev/null
> +++ b/.gitlab-ci.d/crossbuilds-kvm-ppc.yml
> @@ -0,0 +1,5 @@
> +cross-ppc64el-kvm:
> +  extends: .cross_accel_build_job
> +  variables:
> +    IMAGE: debian-ppc64el-cross
> +    TARGETS: ppc64-softmmu

Compilation of the ppc KVM code should already be covered by the
cross-ppc64el-system job, see e.g.:

https://gitlab.com/qemu-project/qemu/-/jobs/883985074#L297

Thus there is no need to add a new job for this here. It might be a good
idea to remove ppc64-softmmu from the exclude list in crossbuilds.yml,
though, so that we also check the 64-bit builds and not only the 32-bit ones.

 Thomas

