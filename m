Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3861C4365DF
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbhJUPWo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:22:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37150 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231533AbhJUPWk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 11:22:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634829623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NOe3cFJFILZdz8eTftQ7v5VvvEiNDk+j+1cks9VzhR8=;
        b=e2lR4AQyRbyJIaBoMllyvYOlZ0G+JXB8mG4LDSdW8OG9SLu8Va6z+cCkgkbPsp1sRKMBOx
        y2D3aL6QKuBpqln2iC86lJXo8/23XJcgFqLy6fnOeYugNbX63SLVMXIZWTGniufq9Ek0fr
        bR8uH06fso1AnMmwwi7UMV0iRJKhljM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-597-TIIjVZ7MOzWMOopFcTmoAA-1; Thu, 21 Oct 2021 11:20:22 -0400
X-MC-Unique: TIIjVZ7MOzWMOopFcTmoAA-1
Received: by mail-ed1-f69.google.com with SMTP id h19-20020aa7de13000000b003db6ad5245bso715110edv.9
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 08:20:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NOe3cFJFILZdz8eTftQ7v5VvvEiNDk+j+1cks9VzhR8=;
        b=NRsNJJSo7r1BAOVlCHVXeiri74RJTATPwvI/4HQyNq7rIRUmb2Yffcd3iDxXIO850l
         E/Kmvy1WpT2krKodtdqU272FRLmrlzVT+3p2gSSDxSOCfBvf2mB36AmJxq2Pzy1uF/7Y
         S/mFu3TPhvXy6EuKWUlXj+G7mJgOVH1rJBE1ooNr4qqdhI0ac3xMXlS3sTFNA/j6IGi2
         ZQiYG3lGprwI40u5uRglzauTLMenyMmfgXAnhbFst23+zMUFHN3Oq231nfcUnY3l3NAt
         GLfdqW9s6ApW6/5qF8rqV7oXhl5WVOOgtNtXOl4zunoSpEnpC/c+96Xvp2Dp1Fo+YDI4
         sukA==
X-Gm-Message-State: AOAM531CgNj/edaagnV1rfORRUn5sqS2ZeLA4O7dpgqoGamOg9IFcEfR
        CeR3/poUH8cO+ctLKn3i/PF2K1PbVdCnz0U8Cq1DEGFnBBMcOSDqfVmIbUk3OZHnx9i0vdcCUAM
        H/WLfysAzMXiE
X-Received: by 2002:a17:906:2310:: with SMTP id l16mr8121411eja.118.1634829621445;
        Thu, 21 Oct 2021 08:20:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjeZqyJXsmAoXhDVP1zKKfZ0Y7fUe4znDsFRJP/2IiYcz3JF2glaBceal0TUeS55/ECM+NVA==
X-Received: by 2002:a17:906:2310:: with SMTP id l16mr8121368eja.118.1634829621264;
        Thu, 21 Oct 2021 08:20:21 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id a1sm3008008edu.43.2021.10.21.08.20.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 08:20:20 -0700 (PDT)
Message-ID: <811ec8ba-433e-b167-6a60-cf3b5ceabb63@redhat.com>
Date:   Thu, 21 Oct 2021 17:20:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC 01/16] KVM: selftests: move vm_phy_pages_alloc() earlier in
 file
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>,
        Mingwei Zhang <mizhang@google.com>
Cc:     linux-kselftest@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Nathan Tempelman <natet@google.com>,
        Marc Orr <marcorr@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Shuah Khan <shuah@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Ricardo Koller <ricarkol@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>
References: <20211005234459.430873-1-michael.roth@amd.com>
 <20211005234459.430873-2-michael.roth@amd.com>
 <CAL715WK2toExGW7GGWGQyzhqBijMEhQfhamyb9_eZkrU=+LKnQ@mail.gmail.com>
 <20211021034529.gwv3hz5xhomtvnu7@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211021034529.gwv3hz5xhomtvnu7@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/10/21 05:45, Michael Roth wrote:
>> Why move the function implementation? Maybe just adding a declaration
>> at the top of kvm_util.c should suffice.
> At least from working on other projects I'd gotten the impression that
> forward function declarations should be avoided if they can be solved by
> moving the function above the caller. Certainly don't mind taking your
> suggestion and dropping this patch if that's not the case here though.

I don't mind moving the code, so the patch is fine.

Paolo

