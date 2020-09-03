Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFDB25C9E4
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 22:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgICUCp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 16:02:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56066 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729357AbgICUCm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Sep 2020 16:02:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599163360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eTM798jNWSto3aJECGa6KA1td+/NCZqVTNN5qgvcw9E=;
        b=LltTzNjLfhA4ZKRVqkhZX88Tn76JHpQ3S7w3L0FiYsULyuXua54NfIBT7+O/MLfJLfmiC+
        3DAYqqATDOorOlQZiFlY5HSaPOGh65E4UJl9Q6ER2MmJGBXroEDopoCsJN0Z1STueMtwhn
        J6aeobLav57U0MrOlCc19uwC1tnfXs4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-4dHv7M41MaKwTfmrm75rhA-1; Thu, 03 Sep 2020 16:02:37 -0400
X-MC-Unique: 4dHv7M41MaKwTfmrm75rhA-1
Received: by mail-ed1-f72.google.com with SMTP id d13so1741273edz.18
        for <kvm@vger.kernel.org>; Thu, 03 Sep 2020 13:02:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eTM798jNWSto3aJECGa6KA1td+/NCZqVTNN5qgvcw9E=;
        b=aVQpC9vhb9nUrSuUvZrMsJc8zzjUSXES6YWVQOw1q6spFrodpro7YhVoF6oqilzZIU
         NS1peLXYzPMkAPQk4oKg6j2O3/F8C3PQ600/19in/IFYwKj5d/gbTzR8FYFpw9oHTyTT
         ZzlZN/nFHzikScx/dbQ7m3AJxpSlfyc73bNYq3ikkTtEV1cR6qxe6jaVHZ42ZRfXiA8z
         hb3lG3WOSUmJJRv640wFe76O4rcHqwFsH3qxYgC672nKK5pbaOB+v6atSk6z7U9IWzqT
         SZHf07wRGbjL3f+YsXvm7f+LVaft/U2z3i2sH2WtrjWGxpx3HCLIxnNis3lNHdCSg4PE
         QoMg==
X-Gm-Message-State: AOAM531BwqiUmZUd3L8btF5R4xSmqFc1B0uLmUdACwjhxLK1O7H7T1sx
        YB0yoIPzM/kfs8VEQXoPR+112cG3ACW2qDPHiYydWt7xMAonvGddGrRcDaPH8DizJUBjXrcQEfu
        hG55PztD0riZ9
X-Received: by 2002:aa7:dc08:: with SMTP id b8mr5097756edu.271.1599163356709;
        Thu, 03 Sep 2020 13:02:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqAihHLVWx8nsoBhNdHXWJZozf9ULqwWiHS0vDDzSA7zMtyXkYRo+FtNbxhAEz8eRAejJChg==
X-Received: by 2002:aa7:dc08:: with SMTP id b8mr5097707edu.271.1599163356372;
        Thu, 03 Sep 2020 13:02:36 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id k16sm4043049ejg.64.2020.09.03.13.02.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 13:02:35 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: VMX: Make smaller physical guest address space
 support user-configurable
To:     Jim Mattson <jmattson@google.com>
Cc:     Mohammed Gamal <mgamal@redhat.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200903141122.72908-1-mgamal@redhat.com>
 <CALMp9eTrc8_z3pKBtLVmbnMvC+KtzXMYbYTXZPPz5F0UWW8oNQ@mail.gmail.com>
 <00b0f9eb-286b-72e8-40b5-02f9576f2ce3@redhat.com>
 <CALMp9eS6O18WcEyw8b6npRSazsyKiGtBjV+coZVGxDNU1JEOsQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <208da546-e8e3-ccd5-9686-f260d07b73fd@redhat.com>
Date:   Thu, 3 Sep 2020 22:02:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eS6O18WcEyw8b6npRSazsyKiGtBjV+coZVGxDNU1JEOsQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/09/20 20:32, Jim Mattson wrote:
>> [Checking writes to CR3] would be way too slow.  Even the current
>> trapping of present #PF can introduce some slowdown depending on the
>> workload.
>
> Yes, I was concerned about that...which is why I would not want to
> enable pedantic mode. But if you're going to be pedantic, why go
> halfway?

Because I am not sure about any guest, even KVM, caring about setting
bits 51:46 in CR3.

>>> Does the typical guest care about whether or not setting any of the
>>> bits 51:46 in a PFN results in a fault?
>>
>> At least KVM with shadow pages does, which is a bit niche but it shows
>> that you cannot really rely on no one doing it.  As you guessed, the
>> main usage of the feature is for machines with 5-level page tables where
>> there are no reserved bits; emulating smaller MAXPHYADDR allows
>> migrating VMs from 4-level page-table hosts.
>>
>> Enabling per-VM would not be particularly useful IMO because if you want
>> to disable this code you can just set host MAXPHYADDR = guest
>> MAXPHYADDR, which should be the common case unless you want to do that
>> kind of Skylake to Icelake (or similar) migration.
> 
> I expect that it will be quite common to run 46-bit wide legacy VMs on
> Ice Lake hardware, as Ice Lake machines start showing up in
> heterogeneous data centers.

If you'll be okay with running _all_ 46-bit wide legacy VMs without
MAXPHYADDR emulation, that's what this patch is for.  If you'll be okay
with running _only_ 46-bit wide VMs without emulation, you still don't
need special enabling per-VM beyond the automatic one based on
CPUID[0x8000_0008].  Do you think you'll need to enable it for some
special 46-bit VMs?

Paolo

