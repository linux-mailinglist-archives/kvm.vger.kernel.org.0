Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A09C28F1CA
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 14:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgJOMEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 08:04:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbgJOMEA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Oct 2020 08:04:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602763438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/btEzQmaXB0ohexwTL/ejSTXCCQvXDuspQ/3UO7FNME=;
        b=VVCZkDWmAXTi9kMWjReRKKRg3CznIoT9Qog3oAd0o3k18muE5ujkvLMqm98DKyrcrcTEgu
        J09552JkQY3jzmqLRlXTGuipIM3rJ5/vnIPLWk7ju+nFBQFs5k3bxW4NqaIT9ISfImaC/k
        WqAn2vi8qoBVgymVqRTMXYd2NDzOJy8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-x1A8__gzPzWAe5-9RPELeg-1; Thu, 15 Oct 2020 08:03:57 -0400
X-MC-Unique: x1A8__gzPzWAe5-9RPELeg-1
Received: by mail-wm1-f72.google.com with SMTP id w23so1672724wmi.1
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 05:03:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/btEzQmaXB0ohexwTL/ejSTXCCQvXDuspQ/3UO7FNME=;
        b=tQBTYEJLe3GPPxuhCOdVVWyJ61k65HFYyX+7O9J+dLggrpS2S0sRxtoJmS24uo42BA
         aZPOtmfS0x1tkFJDBpsZ+qLOCjZXdhRWQEWSa+VXQ4PBGBxqW6EEUB04jXga62AP9K5T
         EPyfUrotRctB3pmZz1DFBzcuXMhhxCGSmuqz2KIFR0zgzkWLSFeTtk/VyiCEDZDmIUOM
         EvhLQTXSTKs9CxkHN4ymn5A5qtk4yBQSXg1Ktk1GWM7BAPudfeCF67KSUWeB0jgt3NYt
         sKUQIM1UuP+pCNxPMGaeByYmXNKPpwdK9i1qgoUM6StXzwAvJBE7j8bjpU7zfim6HiE8
         +Akg==
X-Gm-Message-State: AOAM531HucsG4Gj4T/gM+mWWKyWA9o8L/jCsTl35BsuGTkqXO7DR4nPJ
        Kc3WLT35EUIvhlZSrPh4nVaf2YyltqIPIBxLtWAn0c+u0qsi8UJBQWitYf9lqdgVXfG9Ctl0f9X
        WCjlcacvnEsbu
X-Received: by 2002:a5d:63c3:: with SMTP id c3mr3851603wrw.315.1602763435765;
        Thu, 15 Oct 2020 05:03:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwF0KejzsVKAVFZia3lPo1BYfQinVpF6JMKGRsZA73V0pl+Gjls/bitXKi5yd9K/699NeRy2A==
X-Received: by 2002:a5d:63c3:: with SMTP id c3mr3851569wrw.315.1602763435483;
        Thu, 15 Oct 2020 05:03:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:2110:4ced:a13b:6857? ([2001:b07:6468:f312:2110:4ced:a13b:6857])
        by smtp.gmail.com with ESMTPSA id l3sm3928504wmg.32.2020.10.15.05.03.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 05:03:54 -0700 (PDT)
Subject: Re: [PATCH v2 kvm-unit-tests] runtime.bash: skip test when checked
 file doesn't exist
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>, Andrew Jones <drjones@redhat.com>
References: <20201015083808.2488268-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ff61058b-0960-a61b-d35b-af059c1a23bf@redhat.com>
Date:   Thu, 15 Oct 2020 14:03:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201015083808.2488268-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/20 10:38, Vitaly Kuznetsov wrote:
> Currently, we have the following check condition in x86/unittests.cfg:
> 
> check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
> 
> the check, however, passes successfully on AMD because the checked file
> is just missing. This doesn't sound right, reverse the check: fail
> if the content of the file doesn't match the expectation or if the
> file is not there.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Hi Vitaly, I had already posted a fix for this but I pushed it only to
my repo and not to upstream (still getting used to CI!).  I pushed it now.

My fix actually checked whether ${check} was not empty at all.  That
said, the usage of ${check[@]} is wrong because $check is not an array.
 So it would break if we wanted to have more than one check.

Paolo

> ---
> Changes since v1:
> - tabs -> spaces [Thomas]
> ---
>  scripts/runtime.bash | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 3121c1ffdae8..99d242d5cf8c 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -118,7 +118,10 @@ function run()
>      for check_param in "${check[@]}"; do
>          path=${check_param%%=*}
>          value=${check_param#*=}
> -        if [ -f "$path" ] && [ "$(cat $path)" != "$value" ]; then
> +        if [ -z "$path" ]; then
> +            continue
> +        fi
> +        if [ ! -f "$path" ] || [ "$(cat $path)" != "$value" ]; then
>              print_result "SKIP" $testname "" "$path not equal to $value"
>              return 2
>          fi
> 

