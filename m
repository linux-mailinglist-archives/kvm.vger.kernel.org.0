Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06898192A60
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 14:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbgCYNtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 09:49:18 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:40381 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727275AbgCYNtR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Mar 2020 09:49:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585144156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3XKqpnolU/KR2I/RWhEGaIN7Kx+pdRatBZCvszDiNWM=;
        b=T1fOzmGZagxtSut9jnHG2MORHhkrqffLGqUrhHn83x54PjCyQXy5HFLey9JAJUhDLYwLIm
        uDK3ome9lHIMFAj0ZSaf/pg5V35uVybYfx5SV0iPI+IVvxQZn/2qWY1B/1CQCPvNEbIRvx
        4eXUPPXjbmW+z8xt5P3qMV7QNW5IbZc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-tM1ts6SkPtSPwPSTx2WIOQ-1; Wed, 25 Mar 2020 09:49:14 -0400
X-MC-Unique: tM1ts6SkPtSPwPSTx2WIOQ-1
Received: by mail-wr1-f71.google.com with SMTP id u18so1163959wrn.11
        for <kvm@vger.kernel.org>; Wed, 25 Mar 2020 06:49:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3XKqpnolU/KR2I/RWhEGaIN7Kx+pdRatBZCvszDiNWM=;
        b=R0diArH3w0w86PFjgoE8u3DHNXBqRc+++0e5GSotig5QGMAK7T6U8C0evXSZmUa9tU
         zyhR3P63bZqWsKgYvCwHkBoSN44qz4MOxshHdW4rW9HycKpuEWXlbaWSqAi8owoG6wf9
         jg230b3ola9JtIeTpmTHl2B1AD2eoD0kRuBEkhZGY4dHdlx8p6px4PLDaqr1AwdqVMn+
         vkXPvIYG7HvzWXwKh6J4isaJmfyd7bOiViYHaLDJL8XWnQoiLBFeqgJB0BWUx56tWSUz
         WK9Tp0fjrhrhUT6lK4OnHSkoScCKDRbDDWPMrlyg1b2n8QCQ6KrH8o9jEk+sFpP1m8o8
         tQCQ==
X-Gm-Message-State: ANhLgQ1hXuIzh5UIvsF1kg15woY0U58vPWGBwJ5fgJhCffaWqeIGuK3E
        37xm3TGpL7TRDKyZmu4bvKyyP+aOZ929ZyHGrzaxLse6+i9EhptnhkmHy5n2XrJwVpVMXO8uE8J
        LVQsbhjdtaRRf
X-Received: by 2002:adf:8164:: with SMTP id 91mr3460115wrm.422.1585144153347;
        Wed, 25 Mar 2020 06:49:13 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsQq/lfd8vaywx8tmefsAzvzmuafH1vh5G2EJD2YvUKpOXtVzioBqPoAkz7VNtBoxGEKOqk1w==
X-Received: by 2002:adf:8164:: with SMTP id 91mr3460088wrm.422.1585144153125;
        Wed, 25 Mar 2020 06:49:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:24d8:ed40:c82a:8a01? ([2001:b07:6468:f312:24d8:ed40:c82a:8a01])
        by smtp.gmail.com with ESMTPSA id f10sm33855014wrw.96.2020.03.25.06.49.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 06:49:12 -0700 (PDT)
Subject: Re: [PATCH 0/4] KVM: SVM: Move and split up svm.c
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20200324094154.32352-1-joro@8bytes.org>
 <20200324183007.GA7798@linux.intel.com>
 <CALMp9eRYNH+=Ra=1KSJdT5Ej5kTfdV8J7Rf6JcS9NGbPOYPj8A@mail.gmail.com>
 <20200324185545.GB7798@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4599cea7-8be6-f172-976d-4155ff449b35@redhat.com>
Date:   Wed, 25 Mar 2020 14:49:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200324185545.GB7798@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/03/20 19:55, Sean Christopherson wrote:
>> here is a patch-set agains kvm/queue which moves svm.c into its own
>> subdirectory arch/x86/kvm/svm/ and splits moves parts of it into
>> separate source files:
> What are people's thoughts on using "arch/x86/kvm/{amd,intel}" instead of
> "arch/x86/kvm/{svm,vmx}"?  Maybe this won't be an issue for AMD/SVM, but on
> the Intel/VMX side, there is stuff in the pipeline that makes using "vmx"
> for the sub-directory quite awkward.  I wasn't planning on proposing the
> rename (from vmx->intel) until I could justify _why_, but perhaps it makes
> sense to bundle all the pain of a reorganizing code into a single kernel
> version?

For now I would keep it svm and vmx.  I would expect that other Intel
three-letter acronyms would still use most of the vmx concepts (e.g.
VMCS) not unlike Hyper-V's eVMCS, so the existing directory name makes
sense (possibly with vmx.c split further to something like vmx-common.c
or intel-common.c).

Paolo

