Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E511C3581
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 11:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgEDJZi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 05:25:38 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48865 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727108AbgEDJZh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 05:25:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588584335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IhMZKmodcmk+06K3VXjP9XK4LVnh0x6xj+7mnQK9NDg=;
        b=BAmO1aZsIph+L4mx5ymHp5QtrryaulRNeWXCeDBiZee/YyT3HNMn/tQG1XyhPgeWnd30Rs
        CQ1tBdGSI0QTrSMeV4iKu0S1cPX3TSChrPYeS/GC8+Jk68S/eID3ikSEOmIo42v+KgJOJg
        tT2rAlkKRf9we6wIS58OS2GZyOIwLF8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-iTv69iRJOeiBFdyw4U_JPQ-1; Mon, 04 May 2020 05:25:34 -0400
X-MC-Unique: iTv69iRJOeiBFdyw4U_JPQ-1
Received: by mail-wm1-f70.google.com with SMTP id n127so3195627wme.4
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 02:25:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IhMZKmodcmk+06K3VXjP9XK4LVnh0x6xj+7mnQK9NDg=;
        b=KlyrMsTQkK0NnBZWPa1lEnsmoYEQo0NjJdooni49z0VKvWZaP+Aej5YzIZ+vM2Ztsg
         w+Rw/WuL3wL26BsaHLiv69hyzuBWra+8Sd4IqGaFEUwdtAvKNCff4dR3cVnSKOIVWbWQ
         oo/z1DFDSjZpbx/qt9eZqHCPFPRXdBzJVQPs4GO58SpzhsU1Q0aTpfz82WQS48Y0WXCz
         MlvKEGDIIJEAsN6MjeZD1Ounqc6qWSBPbDWZ61M10ak/1rAOPu/5S9FJzBm5GVp8UHEw
         LQVxuOdQ6lehUDYwb64YMuFY+qcA+PMkat9jjX6IiImsnV0GaYaMxDBes46NTCcCHjAX
         pqgg==
X-Gm-Message-State: AGi0Puay27dfBC7XbV2XyP3o1hVvQbkdTCzQLNMjXsYXZu2U1nsEymXf
        dXy2/74XIzSjVa7BNmHLocr0RHRHe7YJGj58TDLPpeRWEFAi/ntIJ2KazOBH/cgzYQm5sshxHEo
        hxpbKMPpW/2F1
X-Received: by 2002:a1c:678a:: with SMTP id b132mr13997281wmc.107.1588584333115;
        Mon, 04 May 2020 02:25:33 -0700 (PDT)
X-Google-Smtp-Source: APiQypKHPvMe3Mbr6gHvkRKuFJXOkxWHpABpPIV1bkZR41x3K+aCM41VQ3ls/Ci3403M/RgjW4xx9Q==
X-Received: by 2002:a1c:678a:: with SMTP id b132mr13997258wmc.107.1588584332889;
        Mon, 04 May 2020 02:25:32 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id a8sm5031002wrg.85.2020.05.04.02.25.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 02:25:32 -0700 (PDT)
Subject: Re: AVIC related warning in enable_irq_window
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <9ce7bb5c4fb8bcc4ac21103f7534a6edfcbe195d.camel@redhat.com>
 <758b27a8-74c0-087d-d90b-d95faee2f561@redhat.com>
 <c5c32371-4b4e-1382-c616-3830ba46bf85@amd.com>
 <159382e7fdf0f9b50d79e29554842289e92e1ed7.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d22d32de-5d91-662a-bf53-8cfb115dbe8d@redhat.com>
Date:   Mon, 4 May 2020 11:25:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <159382e7fdf0f9b50d79e29554842289e92e1ed7.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/05/20 11:13, Maxim Levitsky wrote:
> On Mon, 2020-05-04 at 15:46 +0700, Suravee Suthikulpanit wrote:
>> Paolo / Maxim,
>>
>> On 5/2/20 11:42 PM, Paolo Bonzini wrote:
>>> On 02/05/20 15:58, Maxim Levitsky wrote:
>>>> The AVIC is disabled by svm_toggle_avic_for_irq_window, which calls
>>>> kvm_request_apicv_update, which broadcasts the KVM_REQ_APICV_UPDATE vcpu request,
>>>> however it doesn't broadcast it to CPU on which now we are running, which seems OK,
>>>> because the code that handles that broadcast runs on each VCPU entry, thus
>>>> when this CPU will enter guest mode it will notice and disable the AVIC.
>>>>
>>>> However later in svm_enable_vintr, there is test 'WARN_ON(kvm_vcpu_apicv_active(&svm->vcpu));'
>>>> which is still true on current CPU because of the above.
>>>
>>> Good point!  We can just remove the WARN_ON I think.  Can you send a patch?
>>
>> Instead, as an alternative to remove the WARN_ON(), would it be better to just explicitly
>> calling kvm_vcpu_update_apicv(vcpu) to update the apicv_active flag right after
>> kvm_request_apicv_update()?
>>
> This should work IMHO, other that the fact kvm_vcpu_update_apicv will be called again,
> when this vcpu is entered since the KVM_REQ_APICV_UPDATE will still be pending on it.
> It shoudn't be a problem, and we can even add a check to do nothing when it is called
> while avic is already in target enable state.

I thought about that but I think it's a bit confusing.  If we want to
keep the WARN_ON, Maxim can add an equivalent one to svm_vcpu_run, which
is even better because the invariant is clearer.

WARN_ON((vmcb->control.int_ctl & (AVIC_ENABLE_MASK | V_IRQ_MASK))
	== (AVIC_ENABLE_MASK | V_IRQ_MASK));

Paolo

