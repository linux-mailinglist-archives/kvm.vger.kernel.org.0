Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF281BDA1F
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 12:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgD2Kxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 06:53:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49375 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726426AbgD2Kxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 06:53:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588157618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gj8fIWPa2CeyWIO94x3oC1OAlW1QijlTfsM+igUr3wo=;
        b=euDAA9LcrfMGYE5h3ub1k8IglrRuu15cOPI6Ub6HFqWpkbBoXlY0LrUYcvM9OEDMkIabo5
        I33liij2mPD1WxDF80Jy7011Qi+xxpHs9CAa3Z99sFBojfNmN//TMTsgK4NUrTVgFpMixF
        uXsFrAjqgiC+cMvyAvLGgZxS/IdsI9c=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-vlJNJTntNBi2E2YBO4QQnA-1; Wed, 29 Apr 2020 06:53:36 -0400
X-MC-Unique: vlJNJTntNBi2E2YBO4QQnA-1
Received: by mail-wr1-f69.google.com with SMTP id f4so1530804wrp.14
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 03:53:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gj8fIWPa2CeyWIO94x3oC1OAlW1QijlTfsM+igUr3wo=;
        b=d+ITQMMt5Aua2ToREp/FiO+bC4pwahSZY5WHbT5X70/LJgm0c8cQwY9SULJteGWUTD
         dw02HEp0eMJpHJYqV0m6uyFSiJHQEPyGayD/KW552cem+k9ifmyOIU95lYFxB8tpfmiL
         jGtzjpO9xvPRn0VrTJww1goor/6Qbe+prf3vLrscjX7bvam8Uot6e5GrNPNp3h3yuCJi
         NPEw94O4Gc5XfQWIJO+eVIs+zlvEwxLMhqxUQipsK5xunPOIAf6/A76yA7wRB4P39nAb
         R883ARzbQA11ZRVUFXIaRNZufozyOotuhQ1+JK9ZsAh/SsHLMBXsK200e61znXoGnR/X
         AbDg==
X-Gm-Message-State: AGi0Pubp5Zwr+geNc5G5tAQB+YEFHJMVvq4K0ld6GuK/G1ZegEgm8Lf8
        i4OJCcXDvTF922nINFWaqqXXgVz9Cb+PWaTH4NWCjuFHgL+pWRHT949/Va8RyHPA+hzLXA/dOww
        PmEj7CqSFG9sG
X-Received: by 2002:a05:600c:210b:: with SMTP id u11mr2726818wml.133.1588157615288;
        Wed, 29 Apr 2020 03:53:35 -0700 (PDT)
X-Google-Smtp-Source: APiQypIpa3WPxNCQZbis9Xa4WSbuWEW/EHTeU5IyoGtjsiOXu0kixJo8iOl1+UjOd46HemWzC0wBrw==
X-Received: by 2002:a05:600c:210b:: with SMTP id u11mr2726791wml.133.1588157615060;
        Wed, 29 Apr 2020 03:53:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac19:d1fb:3f5f:d54f? ([2001:b07:6468:f312:ac19:d1fb:3f5f:d54f])
        by smtp.gmail.com with ESMTPSA id v7sm7016551wmg.3.2020.04.29.03.53.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 03:53:34 -0700 (PDT)
Subject: Re: [PATCH RFC 6/6] KVM: x86: Switch KVM guest to using interrupts
 for page ready APF delivery
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
 <20200429093634.1514902-7-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ee587bd6-a06f-8a38-9182-94218f7d08bb@redhat.com>
Date:   Wed, 29 Apr 2020 12:53:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200429093634.1514902-7-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/20 11:36, Vitaly Kuznetsov wrote:
> +
> +	if (__this_cpu_read(apf_reason.enabled)) {
> +		reason = __this_cpu_read(apf_reason.reason);
> +		if (reason == KVM_PV_REASON_PAGE_READY) {
> +			token = __this_cpu_read(apf_reason.token);
> +			/*
> +			 * Make sure we read 'token' before we reset
> +			 * 'reason' or it can get lost.
> +			 */
> +			mb();
> +			__this_cpu_write(apf_reason.reason, 0);
> +			kvm_async_pf_task_wake(token);
> +		}

If tokens cannot be zero, could we avoid using reason for the page ready
interrupt (and ultimately retire "reason" completely)?

Paolo

