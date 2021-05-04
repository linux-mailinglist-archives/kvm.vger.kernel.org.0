Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406683726E9
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 10:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbhEDIHq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 04:07:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37210 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230029AbhEDIHq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 04:07:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620115611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fnZe71Z03G+GeuFZEGo29g9lHgOD/bxvNQsCK+sXxoI=;
        b=Ci9A1hGAlPge6h39xq9Pr0pAafzZGxXp1c6MyMIjej8oJGsbUyhgIY8QS9lin3+dR8Mg3m
        Mm59BwdK12RA+ikXkuGeOFLwch0AQVOAWIHQtxJLOTbKX+wwfNTbBquMIJtrWGxjsRR6ro
        /ujQ/ov4pSrPpemtAeTlq3fOPhVtCoY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-V_i8051jNTKp2mNxT-OtAQ-1; Tue, 04 May 2021 04:06:50 -0400
X-MC-Unique: V_i8051jNTKp2mNxT-OtAQ-1
Received: by mail-ej1-f70.google.com with SMTP id bi3-20020a170906a243b02903933c4d9132so2831268ejb.11
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 01:06:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fnZe71Z03G+GeuFZEGo29g9lHgOD/bxvNQsCK+sXxoI=;
        b=moEOHPWAQCfsI7XgIhSj/8hZAUWEtSWiedKuack+ep6pDznBbXBUvhKgn7GvhE3Vyl
         uTcFtq3ysOxXPpDQ7MlPY8ZktjO2PN4pN3L614Jt3LXKC/sU5viiKNebuUMYDFXHGy6g
         uuj3h5OcEeR7uyY/SF5T+rVG723RzX0/cGEqG/t5iCTHDNwU+eLtCIEkn+7LVfJsLMC7
         rLOSGhdtQ8sSQ5ZOhBYgpu64etiYitJ+/SUIS8mhW/FPbP18TCOCMFbv8qiwZ0/baX8I
         lgSOcjpGPPHcqVXI6eJzmyV9lnQAsAF5PGZr+AzIyrP6PgFrgxnRRj/CKumbCi+ujSA4
         pzDg==
X-Gm-Message-State: AOAM532fBMovN4Zd1XoyE7FSWfeS+QIsk1X3ZOmlZn3qykpk8Dthvf/Z
        WryaW+q0XKsVzIZfoDPV0gh1Ep3NuZRP1JcsEq7OnREiUmQsiOD1yUJKi4paPsTYlxrhfgLkC5s
        y2Bb+9IOj926R
X-Received: by 2002:a17:907:3e27:: with SMTP id hp39mr20899584ejc.373.1620115609285;
        Tue, 04 May 2021 01:06:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGcOcInD/43MTk+q2tA+hGucwFY4vTHO/DlghpF7kOgLuaL29CbKw1EO3abdvtPzJndytl5w==
X-Received: by 2002:a17:907:3e27:: with SMTP id hp39mr20899564ejc.373.1620115609117;
        Tue, 04 May 2021 01:06:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v14sm166212edx.5.2021.05.04.01.06.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 01:06:48 -0700 (PDT)
Subject: Re: [PATCH v3 2/2] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
To:     Steve Rutherford <srutherford@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        X86 ML <x86@kernel.org>
References: <20210429104707.203055-1-pbonzini@redhat.com>
 <20210429104707.203055-3-pbonzini@redhat.com> <YIxkTZsblAzUzsf7@google.com>
 <c4bf8a05-ec0d-9723-bb64-444fe1f088b5@redhat.com>
 <CABayD+f41GQwCL1818S7iogNHO+MLesLJ-hCX5Bbf_0vFfDMrw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7c8f388c-1c0e-1fa8-24a5-46ffd40f8b24@redhat.com>
Date:   Tue, 4 May 2021 10:06:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CABayD+f41GQwCL1818S7iogNHO+MLesLJ-hCX5Bbf_0vFfDMrw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/05/21 01:22, Steve Rutherford wrote:
> As far as I know, because of MSR filtering, the only "code" that needs
> to be in KVM for MSR handling is a #define reserving the PV feature
> number and a #define for the MSR number.
> 
> Arguably, you don't even need to add the new PV bits to the supported
> cpuid, since MSR filtering is really what determines if kernel support
> is present.

Not only I don't need to do that, I must not. :)

>> At this point I very much prefer the latter, which is basically Ashish's
>> earlier patch.
>
> The minor distinction would be that if you expose the cpuid bit to the
> guest you plan on intercepting the MSR with filters, and would not
> need any handler code in the kernel.

Yep, and it's not a minor distinction after all (especially from the PoV 
of the guy who actually ends up maintaining the code, i.e. me), so 
that's what I'm going for.

Paolo

