Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAD2351A39
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235971AbhDAR6p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:58:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20016 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236767AbhDARzR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:55:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OpC0Pma1PFWAjwr0iJYckO0JsmXmNzZhIFWhXwl6Ie0=;
        b=GbI9sizh/YSXQzaRX6S7Fn3Yx9vOSAz+uW7Bzv3r71X50ahYy1xhoy32/tQMguo1O53zdz
        IO3HwqtUNvrF+ebBxr7+JNwCcxFhZmM6N8I9OPiVFaHtRc1O5kt94lpTitPOY1UPF7rIvL
        tx+c1J/A9WYAogQNuDK3ixZ/Y+HNZXM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-nh_W3_pHM3mH_4LrDX9pXg-1; Thu, 01 Apr 2021 08:54:21 -0400
X-MC-Unique: nh_W3_pHM3mH_4LrDX9pXg-1
Received: by mail-ej1-f72.google.com with SMTP id v27so2168938ejq.0
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 05:54:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OpC0Pma1PFWAjwr0iJYckO0JsmXmNzZhIFWhXwl6Ie0=;
        b=gtFwqC9C30XO32r3vyTMEm6AfUj1WWIRh/labjsjU/hXgwqT4SIJXBGOUVxpvqmiX4
         ksv5OXqHDU2ivSgVRtfYE9/sqSAH/lg2JXIs6KFBVLEgyunO1VcNqGSSZLYzyHMWdRCo
         shKXXCfUrNsAr+Q82e88IzFLqTCAR1HetmQCk+if1TofAuoPhl6DeHXk0HYSppx6BaH9
         2webz/9VBGOrZY16Em/J9mT16fX/pqHrZR1xrz9swtaaFeLpqghIkB2oky7WynbU43Lu
         fonlDRLzD57+mtEw4zmdFtX7IEU3BM6WWp5qIEeETgiMakFsN7UD0Jdlt75iycYciBzN
         SNeA==
X-Gm-Message-State: AOAM53194Jk/tVK/2rRmp/cL5rh1nXG3cAO+KDNWoZ6qkuIDsUWkkise
        mE8F0QeUjSZKqCavxsK/fg8bJIEaAJvh5MscJ6QvJH7V3DhW/hUqQwPsPgLrZZ35LDbU7ef1dD1
        q5T1aN2Rs06EG
X-Received: by 2002:a17:907:76a3:: with SMTP id jw3mr9124305ejc.353.1617281660489;
        Thu, 01 Apr 2021 05:54:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMYpcr1VxmrLPcRqAXFqV+5+DVqQuWK1tQ2PT+nlPN+mKom8Wytem2m1aqXpphzINgdJwsZQ==
X-Received: by 2002:a17:907:76a3:: with SMTP id jw3mr9124288ejc.353.1617281660342;
        Thu, 01 Apr 2021 05:54:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id gr16sm2753013ejb.44.2021.04.01.05.54.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 05:54:19 -0700 (PDT)
Subject: Re: [PATCH v5 0/5] KVM: x86: dump_vmcs: don't assume GUEST_IA32_EFER,
 show MSR autoloads/autosaves
To:     David Edmondson <david.edmondson@oracle.com>,
        linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210318120841.133123-1-david.edmondson@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7bbf736c-efd8-6169-171c-098a2869944f@redhat.com>
Date:   Thu, 1 Apr 2021 14:54:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210318120841.133123-1-david.edmondson@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/03/21 13:08, David Edmondson wrote:
> v2:
> - Don't use vcpu->arch.efer when GUEST_IA32_EFER is not available (Paolo).
> - Dump the MSR autoload/autosave lists (Paolo).
> 
> v3:
> - Rebase to master.
> - Check only the load controls (Sean).
> - Always show the PTPRs from the VMCS if they exist (Jim/Sean).
> - Dig EFER out of the MSR autoload list if it's there (Paulo).
> - Calculate and show the effective EFER if it is not coming from
>    either the VMCS or the MSR autoload list (Sean).
> 
> v4:
> - Ensure that each changeset builds with just the previous set.
> 
> v5:
> - Rebase.
> - Remove some cruft from changeset comments.
> - Add S-by as appropriate.
> 
> David Edmondson (5):
>    KVM: x86: dump_vmcs should not assume GUEST_IA32_EFER is valid
>    KVM: x86: dump_vmcs should not conflate EFER and PAT presence in VMCS
>    KVM: x86: dump_vmcs should consider only the load controls of EFER/PAT
>    KVM: x86: dump_vmcs should show the effective EFER
>    KVM: x86: dump_vmcs should include the autoload/autostore MSR lists
> 
>   arch/x86/kvm/vmx/vmx.c | 58 +++++++++++++++++++++++++++++-------------
>   arch/x86/kvm/vmx/vmx.h |  2 +-
>   2 files changed, 42 insertions(+), 18 deletions(-)
> 

Queued, thanks.

Paolo

