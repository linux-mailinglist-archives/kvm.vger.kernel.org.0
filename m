Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740952D0F2B
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 12:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgLGLen (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 06:34:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59762 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726709AbgLGLem (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 06:34:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607340796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7xdBCwIggNRrC/nj8pC9pamACvDBeORdRC9fwQeI4Ss=;
        b=DO31zYnL1cy7+leYgIz733Wp0lKvHUc1M0GKtEB8Ywrn15LM6VXLzF5X5FdsRnfcA7/SW7
        8E/X6TaSgL5GrTw4eUB+NB2al2HWra7/U5hXh/YDbYgsfiuf0Dw06Cuc+XnRJL86geKtlB
        bniUkTsO/CJbqmskapQTNTcQ7Eyx48Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-p6QMBE0tMBi98nP0Oz0kPQ-1; Mon, 07 Dec 2020 06:33:15 -0500
X-MC-Unique: p6QMBE0tMBi98nP0Oz0kPQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73F07180A092;
        Mon,  7 Dec 2020 11:33:13 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-85.ams2.redhat.com [10.36.112.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE8A660C13;
        Mon,  7 Dec 2020 11:32:59 +0000 (UTC)
Subject: Re: [PATCH v2 1/5] gitlab-ci: Document 'build-tcg-disabled' is a KVM
 X86 job
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
 <20201207112353.3814480-2-philmd@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <0a146451-04de-e29c-1e6e-91f2162306ee@redhat.com>
Date:   Mon, 7 Dec 2020 12:32:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201207112353.3814480-2-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/12/2020 12.23, Philippe Mathieu-Daudé wrote:
> Document what this job cover (build X86 targets with
> KVM being the single accelerator available).
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  .gitlab-ci.yml | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index d0173e82b16..ee31b1020fe 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -220,6 +220,11 @@ build-disabled:
>        s390x-softmmu i386-linux-user
>      MAKE_CHECK_ARGS: check-qtest SPEED=slow
>  
> +# This jobs explicitly disable TCG (--disable-tcg), KVM is detected by
> +# the configure script. The container doesn't contain Xen headers so
> +# Xen accelerator is not detected / selected. As result it build the
> +# i386-softmmu and x86_64-softmmu with KVM being the single accelerator
> +# available.
>  build-tcg-disabled:
>    <<: *native_build_job_definition
>    variables:
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

