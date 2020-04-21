Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F571B24BE
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 13:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgDULQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 07:16:48 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44643 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728391AbgDULQs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 07:16:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587467806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=97DLxg4Yjg3km/mFNl5Zacv6VSLE1VXtqLZ5V4giXi0=;
        b=HlrVX0GsVKY+PNOhH8kTEyTdXU1qVbiJHKgccyIqX3DhE6pqXPhMEgn7owWA0C3bBOWVnf
        T8eHCQPdf0JTtQ1kTLSllOrjsYfchMeq8RNEo8uoJBxNRx1hz0tBmFVCgt90lnTAqFz/ZM
        rgo4EOYKmdzPYEx+hVdV4wjssYoW+Nk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-OlETAWi4PQ2-JPhZ95-H9g-1; Tue, 21 Apr 2020 07:16:44 -0400
X-MC-Unique: OlETAWi4PQ2-JPhZ95-H9g-1
Received: by mail-wr1-f71.google.com with SMTP id h95so7302240wrh.11
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 04:16:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=97DLxg4Yjg3km/mFNl5Zacv6VSLE1VXtqLZ5V4giXi0=;
        b=Lv+UJqUUESVdCu2sEMMW3l77gPb46J+clzv3cXmltvL2XOpAhJezzNJeQx11cET34M
         ssnCGif0H3LUHVzI2fbMafLvOUi4Q4vfMKSnn7SNS6Nh4PjeRh1XgT9gAV09DBE+abI0
         wTO50Y+5McHxhcAJz+1Rw+h4CT/24btK4QuTyK/h3QWTb+mI4jEuwlgKvy1mqAWC/kWv
         m1vHuYsVrkG4fQxLn2yGLco9euaNAcLZDFNDxXFQwgGfxYAUm+ozzZWi5Oajm0HLEJ1W
         ibSXT8hy9f5uf4bkso+Ujt1dUyMdR0Vpg5DZFhsyJ6nbmBqKfDqh6Gg5fw49YmBg/wR6
         NYAQ==
X-Gm-Message-State: AGi0PuaSSSJRWA20IonV3LK6UMJvE2sktuCK9OIWueiUnXDJzOa+hLEo
        xwHzcSV5xDv2HgyuiRDfzGxma/vA5Sk3NLWX94RZ0HYYppIl7QIU34cU5I0S6tkH6ftb8zcN/oA
        GfK9wcFmpf/o1
X-Received: by 2002:a5d:5652:: with SMTP id j18mr6767443wrw.40.1587467803536;
        Tue, 21 Apr 2020 04:16:43 -0700 (PDT)
X-Google-Smtp-Source: APiQypIM+q3J6iSnskRnURVF3g9hh9MdKKvxJisuR8ZZlbkBs6sJqC1TWZ4HVghfB2r6qghAm3/t8A==
X-Received: by 2002:a5d:5652:: with SMTP id j18mr6767417wrw.40.1587467803259;
        Tue, 21 Apr 2020 04:16:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id t17sm3290485wro.2.2020.04.21.04.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 04:16:42 -0700 (PDT)
Subject: Re: [PATCH 1/4] KVM: x86: hyperv: Remove duplicate definitions of
 Reference TSC Page
To:     Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
References: <20200420173838.24672-1-mikelley@microsoft.com>
 <20200420173838.24672-2-mikelley@microsoft.com>
 <20200421092925.rxb72yep4paruvi6@debian>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6c2bae31-14a8-39cf-6e6d-139d84146477@redhat.com>
Date:   Tue, 21 Apr 2020 13:16:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200421092925.rxb72yep4paruvi6@debian>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/04/20 11:29, Wei Liu wrote:
> On Mon, Apr 20, 2020 at 10:38:35AM -0700, Michael Kelley wrote:
>> The Hyper-V Reference TSC Page structure is defined twice. struct
>> ms_hyperv_tsc_page has padding out to a full 4 Kbyte page size. But
>> the padding is not needed because the declaration includes a union
>> with HV_HYP_PAGE_SIZE.  KVM uses the second definition, which is
>> struct _HV_REFERENCE_TSC_PAGE, because it does not have the padding.
>>
>> Fix the duplication by removing the padding from ms_hyperv_tsc_page.
>> Fix up the KVM code to use it. Remove the no longer used struct
>> _HV_REFERENCE_TSC_PAGE.
>>
>> There is no functional change.
>>
>> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
>> ---
>>  arch/x86/include/asm/hyperv-tlfs.h | 8 --------
>>  arch/x86/include/asm/kvm_host.h    | 2 +-
>>  arch/x86/kvm/hyperv.c              | 4 ++--
> 
> Paolo, this patch touches KVM code. Let me know how you would like to
> handle this.

Just include it, I don't expect conflicts.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

