Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDE12F9D26
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 11:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389166AbhARKsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 05:48:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57565 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388909AbhARKOR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 05:14:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610964749;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=hBNYY1QnhCoztLa28EBa6DIVUIemTWrN7XrdDXxnMrU=;
        b=dszS/lrt+RM7MwGSAKDNsSEp2gR5aX7FgvWvXRAqZjsStTG0gunm0+2ZaHMh7SsEPn/ozh
        dqe2ybcRCyKWZ3pih8HaW1opXEsHD8+vrs7XDFqf2Vj1+paGqPDm0nB/WIeh/dWScRwIsW
        Wv1MyMM+iQhKWJhKy6RgZgtGdWXvoHc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-Sz94-NtJP6ObNS-fQtVvXQ-1; Mon, 18 Jan 2021 05:12:26 -0500
X-MC-Unique: Sz94-NtJP6ObNS-fQtVvXQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E23A7801817;
        Mon, 18 Jan 2021 10:12:23 +0000 (UTC)
Received: from redhat.com (ovpn-116-34.ams2.redhat.com [10.36.116.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D9CD671C9B;
        Mon, 18 Jan 2021 10:12:02 +0000 (UTC)
Date:   Mon, 18 Jan 2021 10:11:59 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     qemu-devel@nongnu.org, Fam Zheng <fam@euphon.net>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        kvm@vger.kernel.org,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Alistair Francis <alistair@alistair23.me>,
        Greg Kurz <groug@kaod.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Max Reitz <mreitz@redhat.com>, qemu-ppc@nongnu.org,
        Kevin Wolf <kwolf@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v2 9/9] gitlab-ci: Add alpine to pipeline
Message-ID: <20210118101159.GC1789637@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
 <20210118063808.12471-10-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210118063808.12471-10-jiaxun.yang@flygoat.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021 at 02:38:08PM +0800, Jiaxun Yang wrote:
> We only run build test and check-acceptance as their are too many
> failures in checks due to minor string mismatch.

Can you give real examples of what's broken here, as that sounds
rather suspicious, and I'm not convinced it should be ignored.

> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>  .gitlab-ci.d/containers.yml |  5 +++++
>  .gitlab-ci.yml              | 23 +++++++++++++++++++++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/.gitlab-ci.d/containers.yml b/.gitlab-ci.d/containers.yml
> index 910754a699..90fac85ce4 100644
> --- a/.gitlab-ci.d/containers.yml
> +++ b/.gitlab-ci.d/containers.yml
> @@ -28,6 +28,11 @@
>      - if: '$CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH'
>      - if: '$CI_COMMIT_REF_NAME == "testing/next"'
>  
> +amd64-alpine-container:
> +  <<: *container_job_definition
> +  variables:
> +    NAME: alpine
> +
>  amd64-centos7-container:
>    <<: *container_job_definition
>    variables:
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index 4532f1718a..6cc922aedb 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -72,6 +72,29 @@ include:
>      - cd build
>      - du -chs ${CI_PROJECT_DIR}/avocado-cache
>  
> +build-system-alpine:
> +  <<: *native_build_job_definition
> +  variables:
> +    IMAGE: alpine
> +    TARGETS: aarch64-softmmu alpha-softmmu cris-softmmu hppa-softmmu
> +      moxie-softmmu microblazeel-softmmu mips64el-softmmu
> +    MAKE_CHECK_ARGS: check-build
> +    CONFIGURE_ARGS: --enable-docs
> +  artifacts:
> +    expire_in: 2 days
> +    paths:
> +      - build
> +
> +acceptance-system-alpine:
> +  <<: *native_test_job_definition
> +  needs:
> +    - job: build-system-alpine
> +      artifacts: true
> +  variables:
> +    IMAGE: alpine
> +    MAKE_CHECK_ARGS: check-acceptance
> +  <<: *acceptance_definition
> +
>  build-system-ubuntu:
>    <<: *native_build_job_definition
>    variables:
> -- 
> 2.30.0
> 
> 

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

