Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3222529F26E
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 18:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgJ2RAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 13:00:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46568 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725968AbgJ2RAC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Oct 2020 13:00:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603990800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LFIk1KDbaI+imFseS7EgKO+PMROEHyYFYHvDyMX5vJs=;
        b=dSWCbKpj2w6DFFmHob56gvbFpNw5b2wuB7FI2aaN0gcPaWz67Xsjhd029zbGGIsAkH1DOL
        nrgPEx8hTWdobVXvAKIn2j9+E0w3+9yhrQV3MGVouJolKdnLKLMTUf47z6tOcMYN/3FVcP
        7M4GYkPPTuWbrqcApUVZhcQLZGTI3M4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-jeQIGK2GP-yDNyW0vSArQw-1; Thu, 29 Oct 2020 12:59:59 -0400
X-MC-Unique: jeQIGK2GP-yDNyW0vSArQw-1
Received: by mail-wr1-f72.google.com with SMTP id t14so1540830wrs.2
        for <kvm@vger.kernel.org>; Thu, 29 Oct 2020 09:59:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LFIk1KDbaI+imFseS7EgKO+PMROEHyYFYHvDyMX5vJs=;
        b=QZBWRCqEqCC/2pnTReUkjxBWP2a7QMuwcd3B9MvwbMSU0H0KNkF+0KaxY7NznFot64
         aR8uHVGmF1ZIkqN9VV+7+SS88HvFqdra/S3tNF8rG5dhAwCBdgQMqcIF/VOoU4HOuxzz
         6IhTs/vPo2JvfU9qPWzdM/Z/QDILJ2RfvfmjAVDFXx0Pi2eL6RPQhJEtPH+kMygHf3GW
         b4igDfDjyph3Cj3v85euMgdqXJ/StmSqaU6wQYOkgHFt+6UsObQonScagrlpKQo5MROW
         C4QLRU8QA9D4SuwpElan6HGuEpAkM3Xl5u4wW8yKz/rCcyqLhup2eYGJ1ctUup3eBVpt
         kHzQ==
X-Gm-Message-State: AOAM5335NdGqpxCHQT4am8tXKmecG1JGPIp92iFTsCatjccTKLuBloRK
        Xsoda3E6qmc294kMZlwlMdIexSXbvIS4tQJATw24MRYtNwPfXvgOx4AmWdfFNPW1sPrgqbJWJdF
        rX1K4aaDMMNqH
X-Received: by 2002:a5d:4e8d:: with SMTP id e13mr6897931wru.368.1603990797492;
        Thu, 29 Oct 2020 09:59:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIJpY7s5tS16KM1jeRqPRytnQIFiA4jNhSDraUoIgQqWjC9ew8fh0YJ62Gxk2fkrYU/ZAcRw==
X-Received: by 2002:a5d:4e8d:: with SMTP id e13mr6897898wru.368.1603990797308;
        Thu, 29 Oct 2020 09:59:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f17sm6577560wrm.27.2020.10.29.09.59.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 09:59:56 -0700 (PDT)
Subject: Re: [PATCH] [v2] x86: apic: avoid -Wshadow warning in header
To:     Arvind Sankar <nivedita@alum.mit.edu>,
        David Laight <David.Laight@ACULAB.COM>
Cc:     'Arnd Bergmann' <arnd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
References: <20201028212417.3715575-1-arnd@kernel.org>
 <38b11ed3fec64ebd82d6a92834a4bebe@AcuMS.aculab.com>
 <20201029165611.GA2557691@rani.riverdale.lan>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <93180c2d-268c-3c33-7c54-4221dfe0d7ad@redhat.com>
Date:   Thu, 29 Oct 2020 17:59:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201029165611.GA2557691@rani.riverdale.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/10/20 17:56, Arvind Sankar wrote:
>> For those two just add:
>> 	struct apic *apic = x86_system_apic;
>> before all the assignments.
>> Less churn and much better code.
>>
> Why would it be better code?
> 

I think he means the compiler produces better code, because it won't
read the global variable repeatedly.  Not sure if that's true,(*) but I
think I do prefer that version if Arnd wants to do that tweak.

Paolo

(*) if it is, it might also be due to Linux using -fno-strict-aliasing

