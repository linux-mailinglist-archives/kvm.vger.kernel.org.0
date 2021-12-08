Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0A246CFA5
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 10:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhLHJHl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 04:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhLHJHk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 04:07:40 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C53BC061746;
        Wed,  8 Dec 2021 01:04:09 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id y12so5894259eda.12;
        Wed, 08 Dec 2021 01:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Qn1VpNU5jS3SEjxYjRvbAZU0c7iKvv67I84Jy0NPUuA=;
        b=g3DSJJvsXNADP3nDn+EuLQH3pEarOmveuZdH3oex6+0UzQZQR6Mm3qmzn0DVc7f6wB
         Xwd+8ow8jHc1OqWWGckFcLnlWpzxKwQMsCxAMdcPyYYFc8/qFBVS8o/iaB6u2kC+MShm
         O5KwYIe4CBhnXbNSNjjGnpnbeBHMa4ForcW2Ufnh0u12IIuSR41rca0kjSTjNcmsSSGS
         IQj6hgawKJL2IVDPLfPIjUlvAd2f7Ai6lL/Hh5FcbJm81KjKlvQt/Fe5T3qrDS6nIKVo
         jqyglm0wqFa+phEBOVY+THGQuZdUCBW0Uee63BirJxL0FkvgVtt2h4rLpNpZBSioZ0k+
         Bd8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Qn1VpNU5jS3SEjxYjRvbAZU0c7iKvv67I84Jy0NPUuA=;
        b=UUT/qNK+zTWkjQCcDhp2wVxFWOqBMySqAMqt3kj2sT/toT58p69Vb2pYt8Xg4NbBXB
         V8h6u7wUwUEavMJRLh9/e3zFO4+5YouReYZfvI0sLRP6PcW1lEzm2cDGIIfKCgZK+hTl
         RiC1ehwvYWcQ3q5IoFdeHlUKmzUMfTHc3ldQe1yGa1HbSTJ6KPA/jDosgMGfFtzHTxQ/
         wsYBHLTgviUSl5A+Ul+2t3Tlt7SpoGTQG9/CxegY1FJ7pYK1yLIZ0b+FYjsCGVhp7k/6
         gpwoyRv3b304s/WOhv6NMV+/GDGtJiG3aJCm+bV1RKSWyunoOeRNgIkWLkMqJt6kFyx9
         cQ6A==
X-Gm-Message-State: AOAM530i+e+f+vPI8FvG6EzfnhP2pkPqwHPuSXBP+Id5kNOmzaNAkus6
        4C4sYkS8v3a+IGqO07tckOA=
X-Google-Smtp-Source: ABdhPJzHGTbq2Uakezo3is2FI3Tb++4C+nyUcrsCN1578HqBvtNqFSYsulWqoqyqhmDqZPLIYSEXnw==
X-Received: by 2002:a17:906:9750:: with SMTP id o16mr5919463ejy.263.1638954247442;
        Wed, 08 Dec 2021 01:04:07 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id nd36sm1191641ejc.17.2021.12.08.01.04.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 01:04:07 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <0552f34f-3a56-f7c8-24ba-738ed7418157@redhat.com>
Date:   Wed, 8 Dec 2021 10:04:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 00/26] KVM: x86: Halt and APICv overhaul
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
References: <20211208015236.1616697-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 02:52, Sean Christopherson wrote:
> Overhaul and cleanup APIC virtualization (Posted Interrupts on Intel VMX,
> AVIC on AMD SVM) to streamline things as much as possible, remove a bunch
> of cruft, and document the lurking gotchas along the way.
> 
> Patch 01 is a fix from Paolo that's already been merged but hasn't made
> its way to kvm/queue.  It's included here to avoid a number of conflicts.
> 
> Based on kvm/queue, commit 1cf84614b04a ("KVM: x86: Exit to ...")

Thanks, I've now finally pushed to kvm/next.  Debug kernels look like 
they have a few issues that caused my tests to fail, and I wanted to 
make sure they weren't related to the sizable amount of patches already 
in the queue.

Paolo
