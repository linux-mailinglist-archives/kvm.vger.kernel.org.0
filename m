Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF632FA84D
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 19:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407472AbhARSE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 13:04:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60569 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407468AbhARSEs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 13:04:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610993002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v3fOsl24D+clK1mP7t8IC2anP5pI+fdytFfqpN21NNg=;
        b=QXZYV0PBHonl3OKxYya3dFDY0ca274HkWxnsrRxdzcNDjJXINuDUgNhZAjgv7wLRcErAha
        Y3DXkBAA1HE4RdQq8fgp2OjnOkskvAANiFh+iO7aLgHV9CxaR8sksW55Jhza/sU09XEUM5
        d5kEZhN3ELJeew4WZuiQQ761Z98WzhA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-rjIRqrOFOFeequYepCccFA-1; Mon, 18 Jan 2021 13:03:21 -0500
X-MC-Unique: rjIRqrOFOFeequYepCccFA-1
Received: by mail-wm1-f70.google.com with SMTP id x20so4874904wmc.0
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 10:03:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v3fOsl24D+clK1mP7t8IC2anP5pI+fdytFfqpN21NNg=;
        b=ZdENCD7eGEk3CYJPzKfMkkZ7PjoPbNO05M+pjiK4mX+lMiGlOWqflGVmRhz47X0K1x
         ZbSgei8ZrsrB8BF1KI+uLGmdqYWHAegnW6m80XL4BYP/a9DI9HV2ZJHqUZ+Pj5Nnb7aC
         msFiBRYDHVUB7vEHLt+81SyWkGZqADN1v2oPX3KXXmqyd3cdwRNI7/gGRWkm5KXAKznE
         tomuqT1TqEnhzJoUEUC8yP+L44v9j91NkzSuzG5G16T/2XbhEvHu1zkBL9RS3Ju8/vgA
         Tribxzft+ANXHkODqDIyCmwgGTwUN9p9SCJGe4/CQpcpuruPSC4OzZqGwjDB4LcSTJzu
         KYQg==
X-Gm-Message-State: AOAM533gU4VHHmVVz/RdmNtGDfS95R68RgrlZpTD9h26eX8HCRLekzm1
        7ZQYCb2m4sR2WExYz9CW1UJqihgt4iNm6lO4vQsPiS5uneEvfJIgzhMZmmPWPPr7XE9yEl9R86u
        lKBZYUNIwO6cQ
X-Received: by 2002:a05:600c:4ed3:: with SMTP id g19mr494652wmq.95.1610992999925;
        Mon, 18 Jan 2021 10:03:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzGH/62H+In2XTV+JBTIIODitgnHjg2s+H947E9xDwCPeLH1Tz18EkxBmDXrthGgZ8q4IzwEQ==
X-Received: by 2002:a05:600c:4ed3:: with SMTP id g19mr494637wmq.95.1610992999778;
        Mon, 18 Jan 2021 10:03:19 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m21sm167198wml.13.2021.01.18.10.03.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 10:03:18 -0800 (PST)
Subject: Re: [PATCH] x86/sev: Add AMD_SEV_ES_GUEST Kconfig for including
 SEV-ES support
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>
References: <20210116002517.548769-1-seanjc@google.com>
 <015821b1-9abc-caed-8af6-c44950bd04f0@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2d795f19-2ac8-ea74-4365-41ea07f8eeec@redhat.com>
Date:   Mon, 18 Jan 2021 19:03:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <015821b1-9abc-caed-8af6-c44950bd04f0@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/01/21 06:40, Tom Lendacky wrote:
> 
>> Introduce a new Kconfig, AMD_SEV_ES_GUEST, to control the inclusion of
>> support for running as an SEV-ES guest.  Pivoting on AMD_MEM_ENCRYPT for
>> guest SEV-ES support is undesirable for host-only kernel builds as
>> AMD_MEM_ENCRYPT is also required to enable KVM/host support for SEV and
>> SEV-ES.
> 
> I believe only KVM_AMD_SEV is required to enable the KVM support to run 
> SEV and SEV-ES guests. The AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT setting is 
> only used to determine whether to enable the KVM SEV/SEV-ES support by 
> default on module load.

Right:

         if (IS_ENABLED(CONFIG_KVM_AMD_SEV) && sev) {
                 sev_hardware_setup();
         } else {
                 sev = false;
                 sev_es = false;
         }

I removed the addition to "config AMD_MEM_ENCRYPT_ from Sean's patch, 
but (despite merging it not once but twice) I don't really like the 
hidden dependency on AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT and thus 
AMD_MEM_ENCRYPT.  Is there any reason to not always enable sev/sev_es by 
default?

Paolo

