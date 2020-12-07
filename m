Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85892D0A79
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 07:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgLGGAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 01:00:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59461 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725773AbgLGGAh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 01:00:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607320751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J79ha+sdFVJY1jQ5SwPfSjjvCpXuHs7w7E0i9lDztTg=;
        b=Mf4DPmD7vZ6/zk+ycgkF3NO47KOkf9/IzzOIYPL97qOMZFR+gRu0y1fyJPSrObAgyTUrgk
        mMOCub9rP5xGEYj/i043Wz3rnLmFzFxZZNO+BQyEbr73DsdaPlVA+VqjjzGZE083r2cX7o
        5zxoQ9RKt8AY93sZtJs5ZxRasy+4srA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-GsG9jOd1Pp6VMq2f2a2Jhg-1; Mon, 07 Dec 2020 00:59:09 -0500
X-MC-Unique: GsG9jOd1Pp6VMq2f2a2Jhg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98228802B40;
        Mon,  7 Dec 2020 05:59:06 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-85.ams2.redhat.com [10.36.112.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5295A5D6AB;
        Mon,  7 Dec 2020 05:58:56 +0000 (UTC)
Subject: Re: [PATCH 7/8] gitlab-ci: Add KVM MIPS cross-build jobs
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
 <20201206185508.3545711-8-philmd@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <112e7a72-1269-2df5-e573-74963db7396a@redhat.com>
Date:   Mon, 7 Dec 2020 06:58:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201206185508.3545711-8-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/12/2020 19.55, Philippe Mathieu-Daudé wrote:
> Cross-build mips target with KVM and TCG accelerators enabled.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
> later we'll build KVM-only.
> ---
>  .gitlab-ci.d/crossbuilds-kvm-mips.yml | 5 +++++
>  .gitlab-ci.yml                        | 1 +
>  MAINTAINERS                           | 1 +
>  3 files changed, 7 insertions(+)
>  create mode 100644 .gitlab-ci.d/crossbuilds-kvm-mips.yml
> 
> diff --git a/.gitlab-ci.d/crossbuilds-kvm-mips.yml b/.gitlab-ci.d/crossbuilds-kvm-mips.yml
> new file mode 100644
> index 00000000000..81eeeb315bb
> --- /dev/null
> +++ b/.gitlab-ci.d/crossbuilds-kvm-mips.yml
> @@ -0,0 +1,5 @@
> +cross-mips64el-kvm:
> +  extends: .cross_accel_build_job
> +  variables:
> +    IMAGE: debian-mips64el-cross
> +    TARGETS: mips64el-softmmu

That's already covered, see:

https://gitlab.com/qemu-project/qemu/-/jobs/883985068#L296

 Thomas

