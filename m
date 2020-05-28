Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8724F1E5E97
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 13:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388478AbgE1LoV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 07:44:21 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60826 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388391AbgE1LoU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 May 2020 07:44:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590666258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lgkJrhOZc0Gmql6BW59mVLIzHXzeHqmyTqYLJYXcY78=;
        b=AreW4z6Zek05YiAHu+YnC+u4rrgQ/l4ohsiDCzGbKp1q4xdCFKgIJUDAzbcBW/4Zp5r6Rm
        WiXxZ4z0Bnc9nrFY7KpKr6KHkHQ4yDuMdb+TTTY2Hmn1kVIarkgoU85SiX/JVPD9kKCocK
        5iPFigB+nXVaflKOw909QNoChJYMRfM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-7TsQ1nuBMlGUhcxP4Pz20g-1; Thu, 28 May 2020 07:44:16 -0400
X-MC-Unique: 7TsQ1nuBMlGUhcxP4Pz20g-1
Received: by mail-wr1-f72.google.com with SMTP id w16so4288199wru.18
        for <kvm@vger.kernel.org>; Thu, 28 May 2020 04:44:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lgkJrhOZc0Gmql6BW59mVLIzHXzeHqmyTqYLJYXcY78=;
        b=iE+equndLxsLg4gZcsPvHubV5YafcH9PUYPX5gzIGa4Nf0X12lmXMQxZRpmTWhryyJ
         biCgzktY6yNSdd3ffA2zF5Q7D607nhfBuzkFbqyiqoMqDVlCCswixgkfqbhwn8t38UQI
         KU1ilxBP27rBBt6lBVB9JrCRxQ+zLzq6cRLoQOTsrCPjA0uKBcWoXZaKvvplJ0vrE0Yn
         t88lCn9ni43VqCoP1Xkmx5PYtPeM147WTolKciD9/9LxiDS1f0kDhrVvSQwan0SxuEGO
         1a9Y89SGiTCapwaT2aUC3kWaWBjLP1NrUlsJ8EQdXMvREh2wrRZ9Y9uWLcldbSyCX6HR
         WmcA==
X-Gm-Message-State: AOAM530s2LpP3oskwKR9TCqAqEHhhE76zDUvtEeO8Z3KUyNLt06Hs+Iz
        YOA1qeOtWlJfN+Y4gFAO5LjCSFE2o6yRnc3WMC7pcZxVDDKCtNlZ7TTUm7AtxEiX6bfBtb+m86C
        kvFf4dQB9dQRd
X-Received: by 2002:a7b:cc71:: with SMTP id n17mr3058750wmj.148.1590666255877;
        Thu, 28 May 2020 04:44:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzHaTkWilSw87BW7WiyiNlzanym0eR9Ue95hcqTXW/NOC53yreRPh1IoGr76Fufw/nyptOQg==
X-Received: by 2002:a7b:cc71:: with SMTP id n17mr3058733wmj.148.1590666255503;
        Thu, 28 May 2020 04:44:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id a124sm6527861wmh.4.2020.05.28.04.44.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 04:44:14 -0700 (PDT)
Subject: Re: [PATCH v2 06/10] KVM: x86: acknowledgment mechanism for async pf
 page ready notifications
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Vivek Goyal <vgoyal@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
References: <20200525144125.143875-1-vkuznets@redhat.com>
 <20200525144125.143875-7-vkuznets@redhat.com>
 <f9d32c25-9167-f1a7-cda7-182a785b92aa@redhat.com>
 <87wo4w2sra.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <690f1a02-6077-e971-f2e9-aedd89f0901a@redhat.com>
Date:   Thu, 28 May 2020 13:44:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87wo4w2sra.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/05/20 13:39, Vitaly Kuznetsov wrote:
>> How is the pageready_pending flag migrated?  Should we revert the
>> direction of the MSR (i.e. read the flag, and write 0 to clear it)?
> The flag is not migrated so it will be 'false'. This can just cause an
> extra kick in kvm_arch_async_page_present_queued() but this shouldn't be
> a big deal. Also, after migration we will just send 'wakeup all' event,
> async pf queue will be empty.

Ah, that's kvm_pv_enable_async_pf, where the destination writes to
MSR_KVM_ASYNC_PF.  Cool.

> MSR_KVM_ASYNC_PF_ACK by itself is not
> migrated, we don't even store it, not sure how invering it would change
> things.

Yes, it would only be useful to invert it if it needs to be stored and
migrated.

Thanks,

Paolo

