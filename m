Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F342D5A6A
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 13:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732029AbgLJMYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 07:24:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39754 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731297AbgLJMYE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 07:24:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607602957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CbL1hr0MkH3C8eOOjZugT5xr3j1bVGFoTW4KwOXJn84=;
        b=FADjFgus8Ht8oHvdnM8Xpc8zbTZHP1Ql41t/xNQ1w8gEHQ8Dzft2GHS1HQ56Lr42aVdRv3
        JnrLXa4cv1zMJtLdDWrUOeVncxg9Bm8XXqSQgU6QhSuwVWl15f/Gh6/6THdwU2iOhkTnLm
        GM5uESIkjtem5vgp5OGUxRMRXKS0Pt8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-cpSkmWRHNci6ngzvrg-cyQ-1; Thu, 10 Dec 2020 07:22:35 -0500
X-MC-Unique: cpSkmWRHNci6ngzvrg-cyQ-1
Received: by mail-ed1-f70.google.com with SMTP id ca7so2366122edb.12
        for <kvm@vger.kernel.org>; Thu, 10 Dec 2020 04:22:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CbL1hr0MkH3C8eOOjZugT5xr3j1bVGFoTW4KwOXJn84=;
        b=UXgIjwE3ShSNd1vutJfsRqhYRV3zCpvXCN3NvdiaNHvmXDTGDKwcQ3TNQ0XtfCfD+c
         mhAzkIx1iWbl+/YzrZBM0tavDvud548f0AMFDWXbo0bS8eQqM3yfw9egso78hbriiDxX
         YU3NF9x2gx04iOuYUc+aLajM2NwjkRtmvfjleBIp9NKaNnSXhztpdTrAX6r9xaFYvZNZ
         YV7PsIAQbJHutePLxwQSZifKdElhu/FS1GPOebnC0l9+AvHqaE6dxc+TLzeUpoo69IZ8
         nMWb13vbDUU/Wt3bQWlhBLDafgCk3VkIh3EQLmvmbo1IJRlsHc9MTW0X4J/GVe6WdmO+
         +fTA==
X-Gm-Message-State: AOAM530pAJXEkk7JoMBcNwRgFBP3IKBI5xjNzmUPmoTnAIyAf0yH3W7F
        4ZG1Aumws+gLARpxSyUHD5rFY6mCsg9O0SiLuoaRnrvM+7gsbyVBOg4nFYRpV1tpgSgv/I6TCTi
        Jnb/oe2HPNNTP
X-Received: by 2002:a17:906:b79a:: with SMTP id dt26mr5915901ejb.337.1607602954585;
        Thu, 10 Dec 2020 04:22:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxAlEpsTIBduQ0dhGOGwUDMxag4uvl0NcWL+0EXFkE/Un+PxEJA6gX5IQoaqO17v6zbkBdfsA==
X-Received: by 2002:a17:906:b79a:: with SMTP id dt26mr5915894ejb.337.1607602954422;
        Thu, 10 Dec 2020 04:22:34 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id d4sm4873994edq.36.2020.12.10.04.22.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 04:22:33 -0800 (PST)
Subject: Re: [PATCH] tools/kvm_stat: Exempt time-based counters
To:     Stefan Raspl <raspl@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com
References: <20201208210829.101324-1-raspl@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <012bef63-9ef4-98d3-5ec7-53ce9bee8643@redhat.com>
Date:   Thu, 10 Dec 2020 13:22:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201208210829.101324-1-raspl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/12/20 22:08, Stefan Raspl wrote:
> From: Stefan Raspl <raspl@de.ibm.com>
> 
> The new counters halt_poll_success_ns and halt_poll_fail_ns do not count
> events. Instead they provide a time, and mess up our statistics. Therefore,
> we should exclude them.
> Removal is currently implemented with an exempt list. If more counters like
> these appear, we can think about a more general rule like excluding all
> fields name "*_ns", in case that's a standing convention.
> 
> Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
> Tested-and-reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>   tools/kvm/kvm_stat/kvm_stat | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
> index d199a3694be8..b0bf56c5f120 100755
> --- a/tools/kvm/kvm_stat/kvm_stat
> +++ b/tools/kvm/kvm_stat/kvm_stat
> @@ -742,7 +742,11 @@ class DebugfsProvider(Provider):
>           The fields are all available KVM debugfs files
>   
>           """
> -        return self.walkdir(PATH_DEBUGFS_KVM)[2]
> +        exempt_list = ['halt_poll_fail_ns', 'halt_poll_success_ns']
> +        fields = [field for field in self.walkdir(PATH_DEBUGFS_KVM)[2]
> +                  if field not in exempt_list]
> +
> +        return fields
>   
>       def update_fields(self, fields_filter):
>           """Refresh fields, applying fields_filter"""
> 

Queued, thanks.

Paolo

