Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3FE93C6BA6
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 09:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbhGMHsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 03:48:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29624 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233762AbhGMHsi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 03:48:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626162348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NzhMW8UmyexogLd7WLsnQ7mohPd+vth26CSjnwu5sho=;
        b=GLXQBXPmA3Bt6x73kDHcT4WtQhPX3IFqb5EouQoybixG+EZCa/FLb8Na3hqwGbX8rLqdY5
        V3ygiVKyABr/vKI1cVbMaoj3yX/L1LheVP2lUOM4yBYjjRJV9hAhFd2jSUA3w80Vig4XWy
        l+XGQQVb454e5ECjTDu8QxvqWf9VmOs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-Ht4US0QcMjG6oqlg43cMvA-1; Tue, 13 Jul 2021 03:45:47 -0400
X-MC-Unique: Ht4US0QcMjG6oqlg43cMvA-1
Received: by mail-wr1-f70.google.com with SMTP id a4-20020a0560001884b02901401e436a18so1257039wri.21
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 00:45:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NzhMW8UmyexogLd7WLsnQ7mohPd+vth26CSjnwu5sho=;
        b=J/Uk/F3kCHPd8nyfQFVrKABq1iwUmp5zOFByQ4D7kAtfF/OQLxoDtM5ViPLqE9WSkF
         66Q5yut/Jvarzet0RtDLUAOZPxWp72ja35hRTsNhDzLFHmNcfQo1vBc9ukV4AbrEDhXG
         N46vVKVQcgoIkg1U8SYXIslpwHfvY9zh+YKIYFB0Zx8alhFQCGNgpUnwOtdmVfGwSbnw
         DtlcLJzQzw98J/YeF7Nx3dHVaXTPh7Z+D6laRRzY+G6kGjUqvl35fZlDju4K7kE6Blj7
         taUMLbZJSbIAPYUA4tGzAaGkeXUYGv6Grud3z4QGQVZZEGT3mNyvRC/8r9IpQeOm+BvA
         xyWQ==
X-Gm-Message-State: AOAM532ulFedS33Q9m0Bdnr8vix17xxI1okaBgDgDSTiYBBxfVsZ4Qiz
        KfNKx1FiuOQnranuQWbHl9fmZ1RUZ6RFBdMFQQf1DmZ2zXm7Ml3wNUr9s/4Te20dYS0egAgEx72
        XVYTD7WA0wICg
X-Received: by 2002:a5d:4f82:: with SMTP id d2mr3896507wru.345.1626162346314;
        Tue, 13 Jul 2021 00:45:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCWsmYfh0hjLY/M0FVKG9/E4Vh+zpZr2m1Ysr7LX2IDMssKj2c36kIzZD77QuB8ng/nRFXng==
X-Received: by 2002:a5d:4f82:: with SMTP id d2mr3896486wru.345.1626162346098;
        Tue, 13 Jul 2021 00:45:46 -0700 (PDT)
Received: from thuth.remote.csb (pd9575fd2.dip0.t-ipconnect.de. [217.87.95.210])
        by smtp.gmail.com with ESMTPSA id z17sm865725wrs.54.2021.07.13.00.45.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jul 2021 00:45:45 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC PATCH 2/5] scripts: Rename run_qemu_status ->
 run_test_status
To:     Alexandru Elisei <alexandru.elisei@arm.com>, drjones@redhat.com,
        pbonzini@redhat.com, lvivier@redhat.com, kvm-ppc@vger.kernel.org,
        david@redhat.com, frankja@linux.ibm.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     andre.przywara@arm.com, maz@kernel.org, vivek.gautam@arm.com
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-3-alexandru.elisei@arm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <24f5629f-eff4-11b3-30a3-c6052f533ced@redhat.com>
Date:   Tue, 13 Jul 2021 09:45:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210702163122.96110-3-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/07/2021 18.31, Alexandru Elisei wrote:
> kvm-unit-tests will get support for running tests automatically under
> kvmtool, rename the function to make it more generic.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>   scripts/arch-run.bash | 2 +-
>   powerpc/run           | 2 +-
>   s390x/run             | 2 +-
>   3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 5997e384019b..8ceed53ed7f8 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -69,7 +69,7 @@ run_qemu ()
>   	return $ret
>   }
>   
> -run_qemu_status ()
> +run_test_status ()
>   {
>   	local stdout ret
>   
> diff --git a/powerpc/run b/powerpc/run
> index 597ab96ed8a8..312576006504 100755
> --- a/powerpc/run
> +++ b/powerpc/run
> @@ -31,4 +31,4 @@ command="$(migration_cmd) $(timeout_cmd) $command"
>   # to fixup the fixup below by parsing the true exit code from the output.
>   # The second fixup is also a FIXME, because once we add chr-testdev
>   # support for powerpc, we won't need the second fixup.
> -run_qemu_status $command "$@"
> +run_test_status $command "$@"
> diff --git a/s390x/run b/s390x/run
> index c615caa1b772..5a4bb3bda805 100755
> --- a/s390x/run
> +++ b/s390x/run
> @@ -28,4 +28,4 @@ command+=" -kernel"
>   command="$(timeout_cmd) $command"
>   
>   # We return the exit code via stdout, not via the QEMU return code
> -run_qemu_status $command "$@"
> +run_test_status $command "$@"
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

