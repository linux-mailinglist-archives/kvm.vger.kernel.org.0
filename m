Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A418F3CB57C
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 11:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235401AbhGPJ45 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 05:56:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230360AbhGPJ44 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Jul 2021 05:56:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626429241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qSYQoQIXt9Z2BtB3kqZMkIjAxOf7dLzf1YUeJiDHuZY=;
        b=in4I6idmhMYfQqAiMdmhT7iN9pWXxX1m00Pz2DkT/kGJWpkyULSCSu/JnfxKYsI5Wh9YR2
        CXWOj4u3t4olm3ngI6x3sl5YkZO3toRuhkdn3rj+QlB2p+8JxPnhv319pNnSZuNMJblDWo
        4EIWI3H2L5j0gpFFsAQJ/v6SwgHTvoo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-0tunkZtVOHq7p0SO_hv5Mw-1; Fri, 16 Jul 2021 05:54:00 -0400
X-MC-Unique: 0tunkZtVOHq7p0SO_hv5Mw-1
Received: by mail-wr1-f72.google.com with SMTP id j6-20020adff5460000b029013c7749ad05so4632088wrp.8
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 02:53:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qSYQoQIXt9Z2BtB3kqZMkIjAxOf7dLzf1YUeJiDHuZY=;
        b=NQLLsp8l5WdlKE9d8GN2TEL5Hkd0euA91DMvuCGUjBKyvIoXL0F5tF/OveyzFbe5nS
         ptX2LEpG2Ne90ZkmSF08mb5xfZDMBmircRNXcuIdyQw46SqSEz5iI+8y2/+M6/uhSwE8
         27mcGquI/Tb1he84a84NLyZfL6128pXzgF1cJ6A68mmkqKbQSjms8NV2vUD0/OaEJkTI
         g9hpfhvQRY8K65+Dr13MyeWKIjHL19/GHQQA4RcaEzT91w1Uno1lp9mG51r1kRDQGc7L
         7RDWV+aSvmiIs0IS/MfBRHtzpzl/zS5OmN2Cm3rsl6PmiLW7sEkov9SwewNYt0ih4sI3
         1uGw==
X-Gm-Message-State: AOAM532hiHMZ5OgGGRICDynU+hZVOUQJOSCt1TSGhfLSZkemdHO3PgGY
        xNOGTMwdp1sBMADW+X68HLYTpJANeSMK74bzl5a+OVDtMX8lLKjNSLwOuBf1wUxfNmqDv4EOsKN
        s7F1H6V0I6WLa
X-Received: by 2002:adf:e7cc:: with SMTP id e12mr11476529wrn.51.1626429239057;
        Fri, 16 Jul 2021 02:53:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2vTSZObp/rgdL0tzhlpszUJsjlqhYQTTiKg2QOCa9BOVpsuGr2fQ5ScgYC92bHnkX8bwEmw==
X-Received: by 2002:adf:e7cc:: with SMTP id e12mr11476507wrn.51.1626429238851;
        Fri, 16 Jul 2021 02:53:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id o5sm6375839wms.43.2021.07.16.02.53.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 02:53:58 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] ci: Update the macOS CI jobs to Big Sur
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>
References: <20210716074616.1176282-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a203f90e-7488-e073-0734-98043c142d2f@redhat.com>
Date:   Fri, 16 Jul 2021 11:53:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210716074616.1176282-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/07/21 09:46, Thomas Huth wrote:
> Homebrew stopped working for the Catalina-based images. After updating
> to Big Sur and adding an explicit "brew update", the pipelines go green
> again.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>   ci/cirrus-ci-macos-i386.yml   | 3 ++-
>   ci/cirrus-ci-macos-x86-64.yml | 3 ++-
>   2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/ci/cirrus-ci-macos-i386.yml b/ci/cirrus-ci-macos-i386.yml
> index b837101..ef0861e 100644
> --- a/ci/cirrus-ci-macos-i386.yml
> +++ b/ci/cirrus-ci-macos-i386.yml
> @@ -1,8 +1,9 @@
>   
>   macos_i386_task:
>     osx_instance:
> -    image: catalina-base
> +    image: big-sur-base
>     install_script:
> +    - brew update
>       - brew install coreutils bash git gnu-getopt make qemu i686-elf-gcc
>     clone_script:
>       - git clone --depth 100 "@CI_REPOSITORY_URL@" .
> diff --git a/ci/cirrus-ci-macos-x86-64.yml b/ci/cirrus-ci-macos-x86-64.yml
> index f72c8e1..676646f 100644
> --- a/ci/cirrus-ci-macos-x86-64.yml
> +++ b/ci/cirrus-ci-macos-x86-64.yml
> @@ -1,8 +1,9 @@
>   
>   macos_task:
>     osx_instance:
> -    image: catalina-base
> +    image: big-sur-base
>     install_script:
> +    - brew update
>       - brew install coreutils bash git gnu-getopt make qemu x86_64-elf-gcc
>     clone_script:
>       - git clone --depth 100 "@CI_REPOSITORY_URL@" .
> 

Queued, thanks.

Paolo

