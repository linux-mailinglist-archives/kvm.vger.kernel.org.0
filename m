Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3979A2D0FBC
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 12:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgLGLw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 06:52:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23809 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726935AbgLGLw4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 06:52:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607341889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fZbtPO9TKtQkBSC6vY2I2aKZfTmFL8HdRvz1iHz5xEM=;
        b=bDezUNc5uTQczcQ2QXUYj2rRctQ83cHjszSoBT488sQip6LXeoDLEP8UFP5eeC6SdPSOMQ
        XOgR9/ZIUq155RK1IcsbgluG1IYYXFXTJcqjLiKQz5ujihAY0n9yWKKUcMtz+LHNCI+GrW
        7U3ewoAgDIkFs2CVQsLwn3h9+qSvdOA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-OLykk5vMNfObUY5WAyj2jg-1; Mon, 07 Dec 2020 06:51:26 -0500
X-MC-Unique: OLykk5vMNfObUY5WAyj2jg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC390107ACE4;
        Mon,  7 Dec 2020 11:51:23 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-85.ams2.redhat.com [10.36.112.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AE7C5D9E2;
        Mon,  7 Dec 2020 11:51:11 +0000 (UTC)
Subject: Re: [PATCH v2 5/5] gitlab-ci: Add Xen cross-build jobs
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Fontana <cfontana@suse.de>,
        Willian Rampazzo <wrampazz@redhat.com>, qemu-s390x@nongnu.org,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        xen-devel@lists.xenproject.org, Paul Durrant <paul@xen.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Stefano Stabellini <sstabellini@kernel.org>
References: <20201207112353.3814480-1-philmd@redhat.com>
 <20201207112353.3814480-6-philmd@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <9bfd1ed4-baa2-ece8-5b96-ec8fc7a8c547@redhat.com>
Date:   Mon, 7 Dec 2020 12:51:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201207112353.3814480-6-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/12/2020 12.23, Philippe Mathieu-Daudé wrote:
> Cross-build ARM and X86 targets with only Xen accelerator enabled.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  .gitlab-ci.d/crossbuilds.yml | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/.gitlab-ci.d/crossbuilds.yml b/.gitlab-ci.d/crossbuilds.yml
> index 7a94a66b4b3..31f10f1e145 100644
> --- a/.gitlab-ci.d/crossbuilds.yml
> +++ b/.gitlab-ci.d/crossbuilds.yml
> @@ -135,3 +135,18 @@ cross-win64-system:
>    extends: .cross_system_build_job
>    variables:
>      IMAGE: fedora-win64-cross
> +
> +cross-amd64-xen:
> +  extends: .cross_accel_build_job
> +  variables:
> +    IMAGE: debian-amd64-cross
> +    ACCEL: xen
> +    TARGETS: i386-softmmu,x86_64-softmmu
> +    ACCEL_CONFIGURE_OPTS: --disable-tcg --disable-kvm
> +
> +cross-arm64-xen:
> +  extends: .cross_accel_build_job
> +  variables:
> +    IMAGE: debian-arm64-cross
> +    ACCEL: xen
> +    TARGETS: aarch64-softmmu
Could you please simply replace aarch64-softmmu by arm-softmmu in the
target-list-exclude statement in this file instead of adding a new job for
arm64? That should have the same results and will spare us one job...

 Thanks,
  Thomas

