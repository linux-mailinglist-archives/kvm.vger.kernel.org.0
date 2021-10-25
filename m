Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4E9439073
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 09:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhJYHiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 03:38:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28490 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229521AbhJYHiS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 03:38:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635147356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y5DRQmk40myzdLH6kOm5CdfoAGdzaFDXdRgJp3FbWqM=;
        b=SI+9mvFRodD7bXrylxRUYWhe8UpPL7EH6HWtGy8/NiDAvtvlOmPLjeAUhTOpsBuXyyc4b4
        IGDpi0Up3C2qAAoUrzLWNO356mLEOw8BQFK+6z39R5T0LOBbTTWlAkI0PjHzUpgDAqrPUx
        rXsOesRkJvArkiVQ13SM2gxmiwiyIsE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-Ve4SucC8NsuIwcahezfUpA-1; Mon, 25 Oct 2021 03:35:54 -0400
X-MC-Unique: Ve4SucC8NsuIwcahezfUpA-1
Received: by mail-ed1-f71.google.com with SMTP id d11-20020a50cd4b000000b003da63711a8aso5526877edj.20
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 00:35:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y5DRQmk40myzdLH6kOm5CdfoAGdzaFDXdRgJp3FbWqM=;
        b=yv0auU0oOnvL4jwRgAC1gNlrZMlLWFdYxese42VFrvJpHKMFdE6inqnFNYmn+iqyCj
         O1Nnz87pggp7uaotWJIdW7uqt6S0vTygMdgyzRAxt5fAN5VsCX+bB6Cxawr+eQx9257M
         MazgCpTzT+PewQnz53U1LtdMO+bqnEatz/lyUsPVJyzxKMUqzaZqes/G8jGr8ARjUZuS
         A3xRs5ejsZzpH89elGVlwUuSLP55OiAGlbY+xCNBRaoIqPMCuJXbg/D6XIah7IuofXXY
         jtH/BQzSKHNWOT4X6dSgOX/HssoIIbC6/eLQmfaG9bAEyB8m6ClHtymiez1V/MIvgwcc
         AG7g==
X-Gm-Message-State: AOAM531qIY4J21iJD7TWU5i9Z5yDktzQrsGOS5w3JwxM6a2ElVLlAMeC
        qwJep+iXnyX/dzsfNfhPjNroPbNe45A4fAIMCVTmk0gP1IJ20NTxvq4Ww3HpTVh4OW94UbCap8v
        OUSyTGqa58chv
X-Received: by 2002:a17:906:44b:: with SMTP id e11mr12564860eja.146.1635147353573;
        Mon, 25 Oct 2021 00:35:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzz1l1WaLOSx7+iob8JWMrbd4u84UsZXkbOruaiyj1DgGC2KYDfkrbeIC5WNyhXDhSmA8TMtg==
X-Received: by 2002:a17:906:44b:: with SMTP id e11mr12564831eja.146.1635147353406;
        Mon, 25 Oct 2021 00:35:53 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id r16sm6918866ejj.89.2021.10.25.00.35.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 00:35:52 -0700 (PDT)
Message-ID: <acc619e9-9133-1c12-7dea-4f0aff631cf9@redhat.com>
Date:   Mon, 25 Oct 2021 09:35:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC 00/16] KVM: selftests: Add tests for SEV, SEV-ES, and
 SEV-SNP guests
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>
Cc:     linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Nathan Tempelman <natet@google.com>,
        Marc Orr <marcorr@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Mingwei Zhang <mizhang@google.com>,
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
 <71547952-c3e7-6683-5eea-70d3003d5224@redhat.com>
 <20211025042716.af5gdct3b36swl37@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211025042716.af5gdct3b36swl37@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/21 06:27, Michael Roth wrote:
> 
> Glad to hear:)  For v2 I'll work on getting SEV/SEV-ES broken out into a
> separate series with all the review comments addressed. Still a little
> unsure about the best way to address some things in patch #3, but
> outlined a tentative plan that hopefully seems reasonable. Can re-visit
> in v2 as well.

Sounds good, all I can do is point out things that seem "weird", but 
nothing beats the experience of actually working with the code.

Paolo

