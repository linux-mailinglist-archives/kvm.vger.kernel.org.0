Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA5A1BDC8B
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 14:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgD2Mod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 08:44:33 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43172 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726760AbgD2Moc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Apr 2020 08:44:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588164271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F1gmxzYwGYkHsTP2qdw/Zf43U7oFKL4OKxMuAWff220=;
        b=bMNPVBibbmGZdP96JWBwhqkmgH9IPz5GGBYv79mrDJjWOH1YGovzYIJgWgBf3SBi4nr5o6
        w9Q109Ak8Mq/u8LUv1GFvtv43uCYapMFwKhFaPR0rn4msvGWyLtX7rvIgh78SaWqZ6HaYX
        NJiyoa9ZivPw650jrcGTcRzF92ukoBM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-h0sgf5yAPW-4ij694NWZgQ-1; Wed, 29 Apr 2020 08:44:29 -0400
X-MC-Unique: h0sgf5yAPW-4ij694NWZgQ-1
Received: by mail-wr1-f72.google.com with SMTP id q10so1658042wrv.10
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 05:44:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=F1gmxzYwGYkHsTP2qdw/Zf43U7oFKL4OKxMuAWff220=;
        b=DbVNs9z18L4ylJ/mvB/j9kVI4BaWsEmWRS4KncSJkv+zBoGpo6NbdzKbgDjcMWVyt3
         yqUXvpAGBLLKnvInBoowpErdJlSD5KTwaV/YNoVvo7FZXzTwOO9yzmR2RIgw5urlshUG
         YAwqrImvutcCGuHAo0r3PfNZBFCgsBrivURxYHbze/r+I8iGzE0QH7Dl2MVb5X31I3oG
         4LfsSqDpI40bdAxE6ElCbGr5b9/RMjh1bcIVMH0O7q4UtD3byCex73tP7eVplmqbSWDx
         DdGmKFuv7bC8S4Su5OG7LRIb7JvE/no0mTQ5NiyjxyzfKirOlv++tmF8dUa63kvJDq92
         0KnQ==
X-Gm-Message-State: AGi0PuZ16VULCuklB5u/d5gkX9eKPghlGXnxfgpOvT7IcvWE4C7bpXCi
        58rYclxy93u4oTKDKFGyDgHk8ObPr9604LwizcN8v1yhj4VHlYPs9mMcxddT3HLFSEaRog13vXv
        h4LT4H51I07wO
X-Received: by 2002:a7b:c7d6:: with SMTP id z22mr3293696wmk.73.1588164268561;
        Wed, 29 Apr 2020 05:44:28 -0700 (PDT)
X-Google-Smtp-Source: APiQypIDy1Gzn5KS6sVj5+mwG0tU6gsAr1QHam6y8lBLNR9VXqx4RnhI2p/igJAUJzVkMROC5wddIQ==
X-Received: by 2002:a7b:c7d6:: with SMTP id z22mr3293673wmk.73.1588164268383;
        Wed, 29 Apr 2020 05:44:28 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n2sm30796885wrq.74.2020.04.29.05.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 05:44:27 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFC 6/6] KVM: x86: Switch KVM guest to using interrupts for page ready APF delivery
In-Reply-To: <ee587bd6-a06f-8a38-9182-94218f7d08bb@redhat.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com> <20200429093634.1514902-7-vkuznets@redhat.com> <ee587bd6-a06f-8a38-9182-94218f7d08bb@redhat.com>
Date:   Wed, 29 Apr 2020 14:44:25 +0200
Message-ID: <87blnah36e.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 29/04/20 11:36, Vitaly Kuznetsov wrote:
>> +
>> +	if (__this_cpu_read(apf_reason.enabled)) {
>> +		reason = __this_cpu_read(apf_reason.reason);
>> +		if (reason == KVM_PV_REASON_PAGE_READY) {
>> +			token = __this_cpu_read(apf_reason.token);
>> +			/*
>> +			 * Make sure we read 'token' before we reset
>> +			 * 'reason' or it can get lost.
>> +			 */
>> +			mb();
>> +			__this_cpu_write(apf_reason.reason, 0);
>> +			kvm_async_pf_task_wake(token);
>> +		}
>
> If tokens cannot be zero, could we avoid using reason for the page ready
> interrupt (and ultimately retire "reason" completely)?

Yes, we can switch to using 'token' exclusively but personally I'm not
sure it is worth it. We'll still have to have a hole and reason + token
is only u64. Keeping 'reason' in place allows us to easily come up with
any other type of notification through this mecanism (if the reson is
... then 'token' means ...).

-- 
Vitaly

