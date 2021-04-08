Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50653358338
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 14:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhDHMZ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 08:25:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25520 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230412AbhDHMZ5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 08:25:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617884745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N8WC71YVcH2PzB7/MRu3TT5EAfVDS68BDlRAwibePTY=;
        b=BFOymnrUexHM4qGR2E/L1kdleoZo3oPz7gym6MmGdt0XOo5BHj13XzNePVRDjH6Mp6qJDb
        gZu5CmvVBrJo9fTfcYD6GG85I33d5DC+uhujSq9AjdL8QNj/vIb7s/RbKg5ADFDj9NPNpy
        ROm1UFeDrdFeruPCvmK1baDqexnL/vw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-NRFgAPW1MiCBbkaerBSaeg-1; Thu, 08 Apr 2021 08:25:44 -0400
X-MC-Unique: NRFgAPW1MiCBbkaerBSaeg-1
Received: by mail-ed1-f71.google.com with SMTP id q12so946849edv.9
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 05:25:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N8WC71YVcH2PzB7/MRu3TT5EAfVDS68BDlRAwibePTY=;
        b=FV8CHEEG6IvxVqzHaPq/9U67ghAgVu+77rD9xH6MtnxL03Y2PDOxLmRDkUweVn7L7+
         ND8mJUFjpdinISGN4NV1VjH9fznNZZwWBpo/tXYH9jEh+BbHiV7wc8RrqMM7gUdjATD6
         u3yOMkkHIvD/2GbEKkygcE/JsW4PJrD5GtxkWoThhA13Sbco37CiZSrpTHAj01vcdxfI
         UdKs+eiEadZBSlh4+AddJiugqM5HNz+h6G2UVsU6qFeeeufTsbofxusKYECtgPZSdQJ3
         xc/ZC/eJZQ14xbL1jUI0f5f3mwhd0+EeoxwioZeUWDczOzvjyBFiCWuBmwWHXwo84Y16
         1Ymw==
X-Gm-Message-State: AOAM53273Pd7rKwb5nxbQ5jSvnh1HAPIkAQ/Bbjhs7PRsi7tmFNTtD4P
        8N1qEVNkYXKVDB9k2NJ1cJ3qrjLP+4kZ9zUwu6VcHa7AbzrFiJ5dD5qNzmz2rt0Q9qt2Xk8uJfv
        UNqk2rS9H2MV8
X-Received: by 2002:a17:907:1614:: with SMTP id hb20mr9988510ejc.77.1617884742924;
        Thu, 08 Apr 2021 05:25:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOrCIDnw2gn0DIxYl9xIccpQ4md4ymI/6JnKD1M3OovnJwb9XKE+/tFGcSy6GkB9tvyHovaQ==
X-Received: by 2002:a17:907:1614:: with SMTP id hb20mr9988481ejc.77.1617884742753;
        Thu, 08 Apr 2021 05:25:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x24sm12332509edr.36.2021.04.08.05.25.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 05:25:42 -0700 (PDT)
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, dwmw@amazon.co.uk
References: <20210330165958.3094759-1-pbonzini@redhat.com>
 <20210330165958.3094759-2-pbonzini@redhat.com>
 <20210407174021.GA30046@fuller.cnet>
 <51cae826-8973-5113-7e12-8163eab36cb7@redhat.com>
 <20210408120021.GA65315@fuller.cnet>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: reduce pvclock_gtod_sync_lock critical
 sections
Message-ID: <2abe4b19-e41e-34f9-0a3c-30812c7b719e@redhat.com>
Date:   Thu, 8 Apr 2021 14:25:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210408120021.GA65315@fuller.cnet>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/04/21 14:00, Marcelo Tosatti wrote:
>>
>> KVM_REQ_MCLOCK_INPROGRESS is only needed to kick running vCPUs out of the
>> execution loop;
> We do not want vcpus with different system_timestamp/tsc_timestamp
> pair:
> 
>   * To avoid that problem, do not allow visibility of distinct
>   * system_timestamp/tsc_timestamp values simultaneously: use a master
>   * copy of host monotonic time values. Update that master copy
>   * in lockstep.
> 
> So KVM_REQ_MCLOCK_INPROGRESS also ensures that no vcpu enters
> guest mode (via vcpu->requests check before VM-entry) with a
> different system_timestamp/tsc_timestamp pair.

Yes this is what KVM_REQ_MCLOCK_INPROGRESS does, but it does not have to 
be done that way.  All you really need is the IPI with KVM_REQUEST_WAIT, 
which ensures that updates happen after the vCPUs have exited guest 
mode.  You don't need to loop on vcpu->requests for example, because 
kvm_guest_time_update could just spin on pvclock_gtod_sync_lock until 
pvclock_update_vm_gtod_copy is done.

So this morning I tried protecting the kvm->arch fields for kvmclock 
using a seqcount, which is nice also because get_kvmclock_ns() does not 
have to bounce the cacheline of pvclock_gtod_sync_lock anymore.  I'll 
post it tomorrow or next week.

Paolo

