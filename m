Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C44C278B25
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 16:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbgIYOpQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 10:45:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27557 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728423AbgIYOpQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 10:45:16 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601045115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YWrEKiXUQzCQW4k3DZiB2b+KUsaAHtEPuTJoi07vmxY=;
        b=AZkoBau98+0N1+VCUHJF2ZqkqlWEFPmf5IBaglLUhtVDIBp+V7GAp6rT+ya1d5283QcVji
        u0ZdnHzRtx8UtMBCJCo5xgbsnyAhFqDxF23s1i8uiKYzmE9qQuaggrOiwfGurutNbLIwFc
        OJfaarWOh2fLGjX1/3A8Oj9vlGfRZYM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-0-O5aO_dMlyyEP9AU9BbIA-1; Fri, 25 Sep 2020 10:45:13 -0400
X-MC-Unique: 0-O5aO_dMlyyEP9AU9BbIA-1
Received: by mail-wm1-f71.google.com with SMTP id x81so1169999wmg.8
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 07:45:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YWrEKiXUQzCQW4k3DZiB2b+KUsaAHtEPuTJoi07vmxY=;
        b=jKbB1oQx1ULfp/Fd5Aie6cudWteA926Yl/5uIyCw5d2rpcZBpBU8xtPbgiLh4CO8zM
         jQ3vhNThfnxvPG1Z5hTmqbdhI+ItQxQKLTqtZE1axq87hCMpkfKnBxj1cuBw36PciX2H
         rL0bNBve+3yr7kNx8JZ/8r5SecIrQMIv7KDdXC2X8ZzWUTjT/u0qrpoq9X2ymKxN9nhx
         m+t0Gsrbto4WSAb6AjmsHLh6PsxjrZbvuQzbjAi+bKWtUf2C2bECSDK/j3dBY3uz26p0
         P+pS4CySkAw76wTr0GuRH3j126YVk/Lhi5ebj/Oschva0j0rdTt1zWj5SUKZthBhtve0
         0IGQ==
X-Gm-Message-State: AOAM530ehGdC6KYc+XUm4lnG7GXMwZ3BSM7pUbvVS7thL/U7UFyraloY
        Gv6mbjToGqDby3WW5fhnCeM58SXrwWIb4x37c5wY1zjJ17EY4eNHviW47dz2YeUfHKaou8r9L89
        I6yg1wYZZqYRG
X-Received: by 2002:a7b:ce17:: with SMTP id m23mr3392334wmc.98.1601045112115;
        Fri, 25 Sep 2020 07:45:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrVrFDOuRCKbNQeFoHufkBMliI9OSIqLaQx8VzyqkwHM1IVW2MrTOgQcoB17dOA+Rm8VEvXQ==
X-Received: by 2002:a7b:ce17:: with SMTP id m23mr3392307wmc.98.1601045111858;
        Fri, 25 Sep 2020 07:45:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id h17sm3406007wro.27.2020.09.25.07.45.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 07:45:11 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] configure: Add a check for the bash
 version
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     drjones@redhat.com
References: <20200925143852.227908-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <57fb7e44-1181-61cc-b581-851bf830e361@redhat.com>
Date:   Fri, 25 Sep 2020 16:45:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200925143852.227908-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 16:38, Thomas Huth wrote:
> Our scripts do not work with older versions of the bash, like the
> default Bash 3 from macOS (e.g. we use the "|&" operator which has
> been introduced in Bash 4.0). Add a check to make sure that we use
> at least version 4 to avoid that the users run into problems later.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  configure | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/configure b/configure
> index f930543..39b63ae 100755
> --- a/configure
> +++ b/configure
> @@ -1,5 +1,10 @@
>  #!/usr/bin/env bash
>  
> +if [ -z "${BASH_VERSINFO[0]}" ] || [ "${BASH_VERSINFO[0]}" -lt 4 ] ; then
> +    echo "Error: Bash version 4 or newer is required for the kvm-unit-tests"
> +    exit 1
> +fi
> +
>  srcdir=$(cd "$(dirname "$0")"; pwd)
>  prefix=/usr/local
>  cc=gcc
> 

Looks good, would you like me to apply it or do you prefer to send a
pull request once you have more stuff?

Paolo

