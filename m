Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98AF92F4B7D
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 13:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbhAMMlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 07:41:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56455 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725773AbhAMMlw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 07:41:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610541625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fZ+YcApOL1FyWbUbySK29mXu2RIMEwNXmpAvze3hxpQ=;
        b=MLsfJQOrkSvdYQCwOGs7x/PW+BxpN1teIrNDAJwRLr8kaVtS35PB3RdF/g0SEmrNH7f+W1
        wKuejsGlH+9UrlSZ00OQYBl9FaaH4iNoOiafDKLW2ueX5Aabx/JipMOGArvkiOFego3gIX
        7BTfPDIrf8ud67ZOy1se7MpJGkbyeOk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-FXrm_ooZOLG4Ostc9whKaw-1; Wed, 13 Jan 2021 07:40:23 -0500
X-MC-Unique: FXrm_ooZOLG4Ostc9whKaw-1
Received: by mail-ej1-f70.google.com with SMTP id s22so805850eju.21
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 04:40:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fZ+YcApOL1FyWbUbySK29mXu2RIMEwNXmpAvze3hxpQ=;
        b=NpCBxHBCQ3Hfn9F2WIEg5jUWBlCld/W2kPB+PFjzpgrNnxt+I3KH9+/uLOLGbaReBD
         UBr0FsMvR5E7s5QLMSbBexz+Gu3Da4ofYU2ZlY5EKe8NusQ+okGiz9S8TEHw2w2m2myS
         BoUam0SS8OdgNAJDGWhdF2c/STC296LWojTUFBFNklpd0rgxbphUetHM2sSiXEH9+l7c
         WB/4PwkRkDVEwZJcVMhfb2vQwg1Xe6Ak49Boagei22yJbRMdF2PgUQEkUL3a7HCtFGZ4
         01EjnixIqlVTxjFa5+xWl3FOPQDPT732OIlTw9wDIo4/p4zbcRm3L9mckXRc1A8t4N6w
         7hJQ==
X-Gm-Message-State: AOAM530JUQJE7laQzF6P7kBAShvZuSvnN0X580ZO5ezyM/dWIAhap/dV
        g0dkxz/GfszlzZmvkiESw9P3ouHrOQxLC+tFlRTfT1Dz9pkJBxP3rdDjvohitFeIevMG3SeV3NI
        eZB3YJOyfWsdy
X-Received: by 2002:a17:906:d19b:: with SMTP id c27mr1456546ejz.234.1610541622671;
        Wed, 13 Jan 2021 04:40:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzBxb43X8rAHWK+3MIYiYYqUJPhoX/hIjXwpQROEnILuJ7vX2lEjEloOcqruZqwlFH5PoG5DQ==
X-Received: by 2002:a17:906:d19b:: with SMTP id c27mr1456525ejz.234.1610541622538;
        Wed, 13 Jan 2021 04:40:22 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u2sm669767ejb.65.2021.01.13.04.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 04:40:21 -0800 (PST)
To:     Sean Christopherson <seanjc@google.com>,
        Wei Huang <wei.huang2@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        vkuznets@redhat.com, joro@8bytes.org, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, mlevitsk@redhat.com
References: <20210112063703.539893-1-wei.huang2@amd.com>
 <X/3eAX4ZyqwCmyFi@google.com> <X/3jap249oBJ/a6s@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by
 VM instructions
Message-ID: <61622212-4f7a-bf24-dab2-a40f2142835d@redhat.com>
Date:   Wed, 13 Jan 2021 13:40:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <X/3jap249oBJ/a6s@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/01/21 18:59, Sean Christopherson wrote:
>> It would be very helpful to list exactly which CPUs are/aren't affected, even if
>> that just means stating something like "all CPUs before XYZ".  Given patch 2/2,
>> I assume it's all CPUs without the new CPUID flag?
> Ah, despite calling this an 'errata', the bad behavior is explicitly documented
> in the APM, i.e. it's an architecture bug, not a silicon bug.

I would still call it an errata for the case when virtualized 
VMSAVE/VMLOAD is enabled (and therefore VMLOAD intercepts are disabled). 
  In that case, the problem is that the GPA does not go through NPT 
before it is checked against *host* reserved memory regions.

In fact I hope that,  on processors that have the fix, VMSAVE/VMLOAD 
from guest mode _does_ check the GPA after it's been translated!

Paolo

