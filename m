Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75294365F2
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbhJUPZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:25:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53684 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231624AbhJUPZI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 11:25:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634829772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xi3Exzq4O8MBJAFUK0RiNBXpwkHIMrkkmR7icPEpJVg=;
        b=hlBcIjmkEauT3bN8J+Ckx8MRlkCpRE5y8jwE8TbJryoI/ekZSCaCI1uBlYAjCPRSigjBI0
        npFkDTb/V7F+3AthEgW53Y64yIx70/Y5KuGFV4XfQ9oyOnq76CrWerGAdERRv5vkrlF9vC
        F6Rv56iOc67OQM3EvpWbqldYXMtnVTk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-dAJ8KVlcNNKLEn6lH2i1DA-1; Thu, 21 Oct 2021 11:22:51 -0400
X-MC-Unique: dAJ8KVlcNNKLEn6lH2i1DA-1
Received: by mail-ed1-f69.google.com with SMTP id x5-20020a50f185000000b003db0f796903so681228edl.18
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 08:22:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xi3Exzq4O8MBJAFUK0RiNBXpwkHIMrkkmR7icPEpJVg=;
        b=qRXP+jof0+AsxOso3ilw/O71XPYJaZnZ5eH8KMEFrL48JA3pbpSwJsZOdn0umUaRim
         OwHP9a1FkY4gYwxDaOZ6a9WIVq2Id9k/qzQ1KCiiwy+ZbHIPimsNawj47BEhb6djTrQ6
         VLp2IugEs2FENjVEj1DzsSGxN/SwbpLoPYArwywCr8JCqvK392kIsEOwU5GysYqhSss+
         WeZZPTrb9XgJRcl9YTt2rHg66tvLBEgR9BBMzuvNdmCg2YyFEifTiat2/o/tEXHxq3Rx
         5SrCzJp1SrQDcGAxTzIWRu8RDFMTNzTYKLo7cxKOuMGHfyvR/WeVopptr6nvyGWmpz15
         UX8A==
X-Gm-Message-State: AOAM532akCOcyR38m9WixICUb2SMMItTggpsIfkntzn7WhoMEQZ476Oz
        vgYv9cM0LkEcFkz78oPMsEOVU085CrCTyCIbxkgTRGqZhR+lFH2DzK6O4XPgm1OFxeITkeHIsWz
        lDRq944ooAjAI
X-Received: by 2002:a17:907:6da3:: with SMTP id sb35mr3553404ejc.41.1634829770023;
        Thu, 21 Oct 2021 08:22:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCDcZ8imB3vqmfg8OBQVDBDiZ4wUrpL3XnmxUHQPH6cpm4itttcYgZZZK9ceORITZrp1M+hg==
X-Received: by 2002:a17:907:6da3:: with SMTP id sb35mr3553369ejc.41.1634829769793;
        Thu, 21 Oct 2021 08:22:49 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id mp5sm878222ejc.68.2021.10.21.08.22.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 08:22:49 -0700 (PDT)
Message-ID: <775667ae-3e82-bba1-d1af-e11d04ddb03d@redhat.com>
Date:   Thu, 21 Oct 2021 17:22:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC 02/16] KVM: selftests: add hooks for managing encrypted
 guest memory
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
 <20211005234459.430873-3-michael.roth@amd.com>
 <CAL715W+-H7ZSQZeZmAbbJNGKaZCNqf4VdLismivxux=gerFuDw@mail.gmail.com>
 <20211021033723.tfnhazbnlz4z5czl@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211021033723.tfnhazbnlz4z5czl@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/10/21 05:37, Michael Roth wrote:
>> Do we have to make a copy for the sparsebit? Why not just return the
>> pointer? By looking at your subsequent patches, I find that this data
>> structure seems to be just read-only?
> Yes, it's only intended to be used for read access. But I'll if I can
> enforce that without the need to use a copy.
> 

Return it as a const pointer?

Paolo

