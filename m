Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4174C41B476
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 18:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241905AbhI1Qyf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 12:54:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57928 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241879AbhI1Qye (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 12:54:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632847974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eYeM2BwVL2FH1znTttVwQ9drxcw+lrSQPQ/aZbJu5sk=;
        b=dUbG5P7a1Zdz1YHzOVNQEEPN7NXOTp2IXcXHHK8fzfClOxQJIZ5Drn3o8faxTzDqnr1ic3
        icvfKxB/hVnorppUi4mS3wjDIk34mbZAJMhc8AsdVgbG9G1xzf6ipEOONH37HrMpa2f6Es
        Sn2Ga3jSFur9x1686GIAsa07xlXFK1s=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-3A8aJ1i_PVW8zYA3ZSqnOg-1; Tue, 28 Sep 2021 12:52:53 -0400
X-MC-Unique: 3A8aJ1i_PVW8zYA3ZSqnOg-1
Received: by mail-ed1-f72.google.com with SMTP id 2-20020a508e02000000b003d871759f5dso22491613edw.10
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 09:52:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eYeM2BwVL2FH1znTttVwQ9drxcw+lrSQPQ/aZbJu5sk=;
        b=uiSf+LXZi8sN4qKA5f2Ffetq+JQCLBBzeWiimKaJPzzZufIH9cM6cAhqB1lWs6LjNb
         rpdMj8aHKPmtOnncRIeMPQQwYZlhOnQuF2u2Nw4NraqHl+3Q5HwvJjhtN/A2mz3zUVi5
         +mKRcMvvpaEtAV+4/imhli47t0OEVvkd74A3PTDTKrhGH0V2ayWkF93chuYctlJ5DyjY
         RCBcIEVhDmCHGiM3bavAvASyVkmTs9bWgSJNgkK8wnMs+fCbNCpqfI0VsLiRiVunqGJd
         0ihYKclkWILz7qP4TaPxKY5YmRlheX2Cg8XQ/suradxoiit4drY9al1PX69tfjDC9ZR2
         XijA==
X-Gm-Message-State: AOAM531ZW2E7WamvLdHWoDVUN7vGnsblU0Lb+9SBRvuR2FuDqwoxTX7Z
        CxbJol1H/+W5RodsfQ6k905fa+G8fVetzBy2O4gli6zyx7p33mLpukyjW60Byn45whN94Wmkd//
        Attjv1+ojwacJ
X-Received: by 2002:a17:906:784:: with SMTP id l4mr7804196ejc.469.1632847971510;
        Tue, 28 Sep 2021 09:52:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxBqMKGvFrekO+7KM5NYn5YmtQu7sPlCKCYqGEhvrLCtQi3c3I98CsXt4Lv8daCmNKbH67eXQ==
X-Received: by 2002:a17:906:784:: with SMTP id l4mr7804171ejc.469.1632847971294;
        Tue, 28 Sep 2021 09:52:51 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q17sm3459787edd.57.2021.09.28.09.52.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 09:52:50 -0700 (PDT)
Message-ID: <41b9a6c6-37b0-5d23-ebfb-134af360ebf9@redhat.com>
Date:   Tue, 28 Sep 2021 18:52:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 0/4] KVM: nSVM: avoid TOC/TOU race when checking vmcb12
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
References: <20210917120329.2013766-1-eesposit@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210917120329.2013766-1-eesposit@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/09/21 14:03, Emanuele Giuseppe Esposito wrote:
> Currently there is a TOC/TOU race between the check of vmcb12's
> efer, cr0 and cr4 registers and the later save of their values in
> svm_set_*, because the guest could modify the values in the meanwhile.
> 
> To solve this issue, this serie introuces and uses svm->nested.save
> structure in enter_svm_guest_mode to save the current value of efer,
> cr0 and cr4 and later use these to set the vcpu->arch.* state.
> 
> Patch 1 just refactor the code to simplify the next two patches,
> patch 2 introduces svm->nested.save to cache the efer, cr0 and cr4 fields
> and in patch 3 and 4 we use it to avoid TOC/TOU races.
> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>

Most of my remarks from the RFC still apply, so I will wait for v3. 
Thanks, and sorry for the time between send and review.

Paolo

