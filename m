Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D584B29E3CC
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 08:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgJ2HV2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 03:21:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57434 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726076AbgJ2HVJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Oct 2020 03:21:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603956067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k+MySIa0GO5sAsedbOJklvkP1JxXrpHRlnL4dRpsf/4=;
        b=G4hu6+LPzLZiY1zNpGWejRN1iRAMp2Q2GNLdqbmT257sRo+Bf1ysqV76lin2NVdC+gC5Sh
        No6beNH6NsXdi/Tmmh9Ux0nYYZnj2F4Rw8fbM6NpyN+MWhCDkE15FY8CvZIP3Z7h8kTUP9
        /Nafq0HQkbH7z+N7kfT/JkJvMux6zjQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-BCJTrzTLMXyVmLaaU3O0Fg-1; Thu, 29 Oct 2020 03:04:35 -0400
X-MC-Unique: BCJTrzTLMXyVmLaaU3O0Fg-1
Received: by mail-wm1-f72.google.com with SMTP id t201so560740wmt.1
        for <kvm@vger.kernel.org>; Thu, 29 Oct 2020 00:04:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k+MySIa0GO5sAsedbOJklvkP1JxXrpHRlnL4dRpsf/4=;
        b=aCURdgmfGlegiX2oexTEomUDLU8L10msI4auDZGqa7RRTBnXKS24+aVXcOvbruEfUb
         1oaa5hLSnz/LZUsJK6K8cR/RtCU1UnJMkprR3IQH5zPDOtt0S8qTQ21SAWzu+R8+tjCX
         YranLHzN/KsqovcaNPk0gE+ArxMLKqDyxUmSv9UwBn/eWWpEsj6GKtJNPD4tddkiKKHk
         F37hsBk7gP6jUVxS+zwDRSZe7yOeWGJkR94D/FoY3iPOF+DaLtRPyqkw2SVZClM52sNa
         t/wob018YUOjdCaWZnlgJEKN/9Lj2QbnMPWlFRFjvpDOEXF60lQqah9buIGtlP8dxR7X
         tfTg==
X-Gm-Message-State: AOAM5301t+F4hUI7EKYgDiXdKW5s3Smda22QPXmvFwTbgxABC8yDyLo5
        r1lZwgz0o8Q3tS7B767q2Dv+NVqh05zAdcTWuSeX351+wr7LfC3E7xMcFdHA+lK447y/PaHY6Hy
        bIu+7AwD3NEy2
X-Received: by 2002:adf:e4ca:: with SMTP id v10mr3780271wrm.53.1603955073919;
        Thu, 29 Oct 2020 00:04:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjtd7rX2GzPMeGPldc12GMpi5saPCqNeQJ2ZCa70evuRQIB96hYYOHQ+JlKqMs5entrVHldQ==
X-Received: by 2002:adf:e4ca:: with SMTP id v10mr3780234wrm.53.1603955073729;
        Thu, 29 Oct 2020 00:04:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id 3sm2825527wmd.19.2020.10.29.00.04.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 00:04:33 -0700 (PDT)
Subject: Re: [PATCH] [v2] x86: apic: avoid -Wshadow warning in header
To:     Arnd Bergmann <arnd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        xen-devel@lists.xenproject.org, iommu@lists.linux-foundation.org
References: <20201028212417.3715575-1-arnd@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ea34f1d3-ed54-a2de-79d9-5cc8decc0ab3@redhat.com>
Date:   Thu, 29 Oct 2020 08:04:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201028212417.3715575-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/10/20 22:20, Arnd Bergmann wrote:
> Avoid this by renaming the global 'apic' variable to the more descriptive
> 'x86_system_apic'. It was originally called 'genapic', but both that
> and the current 'apic' seem to be a little overly generic for a global
> variable.

The 'apic' affects only the current CPU, so one of 'x86_local_apic',
'x86_lapic' or 'x86_apic' is probably preferrable.

I don't have huge objections to renaming 'apic' variables and arguments
in KVM to 'lapic'.  I do agree with Sean however that it's going to
break again very soon.

Paolo

