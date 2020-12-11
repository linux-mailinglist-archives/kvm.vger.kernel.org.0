Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92FA2D7C62
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 18:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405068AbgLKRGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 12:06:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32983 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394182AbgLKRFN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 12:05:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607706226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Leog1T7cuecv5R6fqJMs7ncd85agCnp/s8z42hrWKr0=;
        b=NF6G+CbThvASc9torbmVurRMcVKi73DWtowOtQ9RtrVQGufaTmta/xB865SGtfP732sJb/
        ZS/T1pjRPxixjg54s7IIiUvYwiPQjEIeIXCgEchXt3zPaVvkqhcWrGP4FwoAAMBioCtXZE
        t+YJeXjY+QBOZeaLkEG61dCaBGcDUQQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-j0uHi-AaORKFbfD_QMHVaQ-1; Fri, 11 Dec 2020 12:03:44 -0500
X-MC-Unique: j0uHi-AaORKFbfD_QMHVaQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDC751087D78;
        Fri, 11 Dec 2020 17:03:40 +0000 (UTC)
Received: from wainer-laptop.localdomain (ovpn-114-123.rdu2.redhat.com [10.10.114.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E77FB5D9E8;
        Fri, 11 Dec 2020 17:03:31 +0000 (UTC)
Subject: Re: [PATCH v3 1/5] gitlab-ci: Document 'build-tcg-disabled' is a KVM
 X86 job
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-s390x@nongnu.org, Halil Pasic <pasic@linux.ibm.com>,
        Willian Rampazzo <wrampazz@redhat.com>,
        Paul Durrant <paul@xen.org>, Cornelia Huck <cohuck@redhat.com>,
        xen-devel@lists.xenproject.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Claudio Fontana <cfontana@suse.de>
References: <20201207131503.3858889-1-philmd@redhat.com>
 <20201207131503.3858889-2-philmd@redhat.com>
From:   Wainer dos Santos Moschetta <wainersm@redhat.com>
Message-ID: <41db8ee1-23bf-bbde-f99a-5a314fac215d@redhat.com>
Date:   Fri, 11 Dec 2020 14:03:30 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201207131503.3858889-2-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 12/7/20 10:14 AM, Philippe Mathieu-Daudé wrote:
> Document what this job cover (build X86 targets with
> KVM being the single accelerator available).
>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   .gitlab-ci.yml | 5 +++++
>   1 file changed, 5 insertions(+)

Reviewed-by: Wainer dos Santos Moschetta <wainersm@redhat.com>

>
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index d0173e82b16..ee31b1020fe 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -220,6 +220,11 @@ build-disabled:
>         s390x-softmmu i386-linux-user
>       MAKE_CHECK_ARGS: check-qtest SPEED=slow
>   
> +# This jobs explicitly disable TCG (--disable-tcg), KVM is detected by
> +# the configure script. The container doesn't contain Xen headers so
> +# Xen accelerator is not detected / selected. As result it build the
> +# i386-softmmu and x86_64-softmmu with KVM being the single accelerator
> +# available.
>   build-tcg-disabled:
>     <<: *native_build_job_definition
>     variables:

