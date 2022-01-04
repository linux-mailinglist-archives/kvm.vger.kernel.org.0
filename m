Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB56848495D
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 21:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbiADUhe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 15:37:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44143 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232503AbiADUhd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Jan 2022 15:37:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641328652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IPhI6OExXxGqKy+2lHJxiUzmlj9crTloqZOkCJImBO4=;
        b=Oh5LzLcWyumVP/81JqN1KlX6WIiqxIvRLC2Lg6+d14qGJ4o7Dy5E6XDUCNAurARzwWdlnJ
        48qTJcyk1ywmy5zc16033VvCMNoYY9Z3kuL8aTkx/51OrJQhkk/5Wj1JQfc5Ua6gDYeZhd
        YhL4Ff1oLRKJyxQEeodfMZtiH1r8KmM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505-5hbjpn6XOfC6wBxDwbjH0Q-1; Tue, 04 Jan 2022 15:37:30 -0500
X-MC-Unique: 5hbjpn6XOfC6wBxDwbjH0Q-1
Received: by mail-ed1-f70.google.com with SMTP id dz8-20020a0564021d4800b003f897935eb3so26235438edb.12
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 12:37:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IPhI6OExXxGqKy+2lHJxiUzmlj9crTloqZOkCJImBO4=;
        b=eih3YTd6evzLOsmFqDziJBAW7IZOMDuGehfqYkn4/4stTlWT0rQYcPlaXUQqCTqqKr
         W8cfYGX9QTqY12y/jM1pkyzWYddZgRXhrHh1W8a607qH054CHBZ5GXs9Imd8ftG90HCi
         XVqNCMgl0udLuY3GLA0yTpvJTToWYetiHIgGb3RXhvoyQLEU71EEHBVx0FsIynLhJDPG
         sQmD5yP/SuRkv20CJ+YHv8PQshAuTyATURChjEBOZ4b5ZqAmhTm4lVjVZpMF4otIp3/w
         RKV/jQZOxG1k3//IxQ8dPO16fgZTYArReOSTILgP0/7wsMKv9AIyZHfIZ1yMLkW7x2mJ
         7Kgw==
X-Gm-Message-State: AOAM530AChouOdOs93MjGKsWMYBFWFhSU6nJfVwQIARwj3oKdYMsy1k8
        bLXcBcvY/gbvWZZUL3gwaOoHKa8hVmZz7wII7zIuyWumyuatL4kbwsrnZW1Q6t1J9VM90Sqb7JB
        BSVDqQc4IfFFx
X-Received: by 2002:a05:6402:2026:: with SMTP id ay6mr43319353edb.273.1641328649338;
        Tue, 04 Jan 2022 12:37:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxSTo5jntUK6ZUXSps5Zt9NElXirClnSHblVYWpRovERoE/hWEbYBTV+0Pgs9Fxl8dF4SQUEQ==
X-Received: by 2002:a05:6402:2026:: with SMTP id ay6mr43319345edb.273.1641328649166;
        Tue, 04 Jan 2022 12:37:29 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id s16sm15035345edt.30.2022.01.04.12.37.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 12:37:28 -0800 (PST)
Message-ID: <c16e310f-8ae5-9c29-04c7-7355834ce803@redhat.com>
Date:   Tue, 4 Jan 2022 21:37:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH 2/6] KVM: X86: Walk shadow page starting with
 shadow_root_level
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20211210092508.7185-1-jiangshanlai@gmail.com>
 <20211210092508.7185-3-jiangshanlai@gmail.com> <YdSvbsb5wt/WURtw@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YdSvbsb5wt/WURtw@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/4/22 21:34, Sean Christopherson wrote:
> On Fri, Dec 10, 2021, Lai Jiangshan wrote:
>> From: Lai Jiangshan<laijs@linux.alibaba.com>
>>
>> Walking from the root page of the shadow page table should start with
>> the level of the shadow page table: shadow_root_level.
>>
>> Also change a small defect in audit_mappings(), it is believed
>> that the current walking level is more valuable to print.
>>
>> Signed-off-by: Lai Jiangshan<laijs@linux.alibaba.com>
>> ---
>>   arch/x86/kvm/mmu/mmu_audit.c | 5 ++---
> 
> I vote we remove mmu_audit.c.  It has bitrotted horribly, and none of the
> current set of KVM developers even knows how to use it effectively.

No complaints.

Paolo

