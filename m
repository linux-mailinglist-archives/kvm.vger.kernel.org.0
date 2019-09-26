Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47DBCBEE61
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 11:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbfIZJZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 05:25:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57680 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbfIZJZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 05:25:00 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 50A8D796E9
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 09:25:00 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id k9so887416wmb.0
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 02:25:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MitFebjy9vWMVAuqlSBlrNpkTJefENQshQKklNwCqZQ=;
        b=pvczSXErFqXeS+gtc8k/9LV0RmxqpmScKRFY5y2E0TOSYKOqrmUFzkPKCgZpB3VdFW
         9yneeNucoHpmKUE9ZOpdVANAkVNil4ufoIHIBS5mZif9zOw+ETGCdE4fvWXRqMH/x3uX
         Zr78u9+QmzlVGiKHIwAjlcs5YETT7AxG3IdmnXZ8KNRZBRMEdiSOknGTHIhRjO9vFh1F
         EgHP5CBipBcDOMaWHhndyZRbyxOdrIcncLrEdJaJmZzEvpWogHUPKB4hvYlenodmzhlH
         e4rRSt6fbdbN00X1asDOIQGL8AGGdTyE8Oi7OVopr2X8YSge5wFhinVpqLDl+cp8pJvq
         s0mA==
X-Gm-Message-State: APjAAAWCdvnBhaT3mNXNqcW8pldRp10eTLT3xDSKu3/0NwCH085OitE+
        6D8EBs0YXBj6S5GX+WwzxAsQTI13sMvsI3rjHWLFtY0ljDjFgv80He0ANtUCjoTNsrKdX5WisrZ
        iI3Y3uyNYoRqx
X-Received: by 2002:a5d:6a06:: with SMTP id m6mr2066471wru.190.1569489898736;
        Thu, 26 Sep 2019 02:24:58 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwZ2fDG8gQ5uNKfB0wd8U2WGwatSmD2QMGSTUq4VWJEELsuwgzp4pvDqrWUNS1ijxKM9lOfMA==
X-Received: by 2002:a5d:6a06:: with SMTP id m6mr2066454wru.190.1569489898443;
        Thu, 26 Sep 2019 02:24:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id s12sm4936540wra.82.2019.09.26.02.24.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 02:24:57 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v7 2/2] x86: nvmx: test max atomic switch
 MSRs
To:     Marc Orr <marcorr@google.com>, kvm@vger.kernel.org,
        jmattson@google.com, pshier@google.com,
        sean.j.christopherson@intel.com, krish.sadhukhan@oracle.com,
        rkrcmar@redhat.com, dinechin@redhat.com
References: <20190925011821.24523-1-marcorr@google.com>
 <20190925011821.24523-2-marcorr@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <91eb40a0-c436-5737-aa8a-c657b7221be2@redhat.com>
Date:   Thu, 26 Sep 2019 11:24:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190925011821.24523-2-marcorr@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/19 03:18, Marc Orr wrote:
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 694ee3d42f3a..05122cf91ea1 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -227,7 +227,7 @@ extra_params = -cpu qemu64,+umip
>  
>  [vmx]
>  file = vmx.flat
> -extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test"
> +extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test"
>  arch = x86_64
>  groups = vmx

I just noticed this, why is the test disabled by default?

Paolo
