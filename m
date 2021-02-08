Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFAC1313980
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 17:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbhBHQci (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 11:32:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44037 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234373AbhBHQcc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 11:32:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612801866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wn8I/qJ1un2ZJdSVwTB0v/DOi4MI+17hJgbx/HbxT80=;
        b=f2ogFJ/Vxiev4hyovRF1gdSMYTRfx0uILqtMaYii/3oWBLn4bKfnHq8pSJBhISIUU72wk7
        tM0tb5rwnBWgOGIjk8ehK2XMCtXaq/QcDSc5qKldmyVMmmYYYZKT0ueq2Jr48QeGMGbUir
        SYdW5uEFi+ftJJ8gvd6RMC++e+DNcUw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-QKn-Iz_TNtGKAN1Q2Q1iBQ-1; Mon, 08 Feb 2021 11:31:04 -0500
X-MC-Unique: QKn-Iz_TNtGKAN1Q2Q1iBQ-1
Received: by mail-wr1-f71.google.com with SMTP id s15so13505657wrt.14
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 08:31:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wn8I/qJ1un2ZJdSVwTB0v/DOi4MI+17hJgbx/HbxT80=;
        b=FrsM/5rDGS762/ATWXgCewcM7YVZDQcRqet+y/JJKuTRskzaRZrEGteS940U/cRP3n
         U0O13YnWyMMpQ5a3JBCGkqCHFM3MIHK+A+tZ0tftLtNkMmkMDQ+XlsTasvsN7lb0m5+I
         2M2vxRGKbL/r3mZOxC5sUSN+PMnv9E1qmPJ1iN/g7pAyGHSLC9RRoOom7g1etFle4NEs
         uyeL20savdtuUm56zmsfTAL+M/7DjAbtW07ogTMdwgXtsa85JFqVat92REgpM7pcG7YE
         CQIErn45PHv0FWGBjp5lSMnjo5H9tqE8uH3oa6qihdv1kYkbyzNwj4+NJCHh0DbyQ5ft
         CeOg==
X-Gm-Message-State: AOAM530qMA10OzEeCcYT/HurV0Td6Bvfc4KWTBUmwuuF/E3S1r6NdkhQ
        UtITG3HK/+8FECHeMlKSjHnCWmsa4bDa26Up6hFMZ1PPdKP777iz0RMvCczUf/IEmwd0x9q2kyc
        6k3rvvX6m7rIy
X-Received: by 2002:adf:e4c9:: with SMTP id v9mr20432000wrm.277.1612801863011;
        Mon, 08 Feb 2021 08:31:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxfWh4Gw4F1maYiyuME3xdHTAofYjpshxRYsDIc3ialXANCrUJ5Cop5pxlm9pNuSR1QSpqSqA==
X-Received: by 2002:adf:e4c9:: with SMTP id v9mr20431972wrm.277.1612801862835;
        Mon, 08 Feb 2021 08:31:02 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e4sm29630045wrw.96.2021.02.08.08.31.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 08:31:01 -0800 (PST)
Subject: Re: [PATCH v6 0/6] Qemu SEV-ES guest support
To:     Tom Lendacky <thomas.lendacky@amd.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        David Gibson <david@gibson.dropbear.id.au>,
        David Hildenbrand <david@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
References: <cover.1611682609.git.thomas.lendacky@amd.com>
 <9cfe8d87-c440-6ce8-7b1c-beb46e17c173@redhat.com>
 <6fe16992-a122-5338-4060-6d585ca7183f@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f4e12261-c3e3-8934-5fd7-79fd30eccfe5@redhat.com>
Date:   Mon, 8 Feb 2021 17:31:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <6fe16992-a122-5338-4060-6d585ca7183f@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/02/21 16:48, Tom Lendacky wrote:
>>>
>>
>> Queued, thanks.
> 
> It looks like David Gibson's patches for the memory encryption rework 
> went into the main tree before mine. So, I think I'm going to have to 
> rework my patches. Let me look into it.

I was going to ask you to check out my own rebase, but it hadn't 
finished CI yet.  Please take a look at branch sev-next at 
https://gitlab.com/bonzini/qemu (commit 
15acccb1b769aa3854bfd875d3d17945703e3f2a, ignore the PPC failure).

Paolo

