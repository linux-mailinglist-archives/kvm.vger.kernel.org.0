Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBF541623E4
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 10:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgBRJvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 04:51:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42152 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726437AbgBRJvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 04:51:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582019471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f6S3H9Q+xCWLQbxsvGz1L63SOHDRI/P/SP31mReQZeM=;
        b=YycXRqav6l+knyFrrfbRa4WyZbQkUcrldIQlkoPcYrKPasqp5PmyPs2pOtDvAEp4/b6eqZ
        t6A8unCTu9IJEuOjqwV0UsPFMuVJpfmFzP18mjj0rxD+Vdzz7giuy/tfN+RfP5xKpJii61
        /oMy7XssNxxunbaeSLJMzF3DFQ1pTGw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-nm7MhXr8MJOjIzXJCQqoDg-1; Tue, 18 Feb 2020 04:51:10 -0500
X-MC-Unique: nm7MhXr8MJOjIzXJCQqoDg-1
Received: by mail-wm1-f71.google.com with SMTP id g138so237527wmg.8
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 01:51:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=f6S3H9Q+xCWLQbxsvGz1L63SOHDRI/P/SP31mReQZeM=;
        b=uXBpSvxTWyfUkg1sshLPmr8tHeHZSliw2tzlp6aZgV0w/K0maNhZPAaXpaosZ93ndv
         JbOlEnZfup1v6DVNwMY004Xs9lt7OrD/jFkWf5wvxzPNJbxO8suP3/DOAalJM993arqu
         meoAlwYbzUz1oWzdm9jshYWVaOj1hD9uvoBX8UOhKflo/C1nVSQyIxKqbcB8hCQxee7y
         vR1n9+K6d8iXzJfxHeoyYbpaBskSqAIfnnOZi2eRMLmBde73PvDLmGH7LV5LvnAvoYAv
         h1uGkmXKMiNHWJs9BxfJbRdvS9QMSpgwC5GeSr381TBY4o3lxX5oF/L8/kEjpnR06kFk
         0Hag==
X-Gm-Message-State: APjAAAXq5tAdM56IbSv8K4E9HoNX2S79zpbhvbxJ+vmm6S09a10PqQ6d
        FgrHwgY+qW4lhPPtQk+KrR1IgTeyPSnFSAc4NEwGJrUCMUIkiKZXN7iDidqrSCTDJvFEtLfFK33
        BBZpNbublfOAS
X-Received: by 2002:adf:ef92:: with SMTP id d18mr26767555wro.234.1582019469077;
        Tue, 18 Feb 2020 01:51:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqzbsVWsC/clpUSMI+QxchpdxgMAvfJu1v5ks+QAVdg84JW43xe6pTbomJpPHIiBlicc26MBfg==
X-Received: by 2002:adf:ef92:: with SMTP id d18mr26767533wro.234.1582019468906;
        Tue, 18 Feb 2020 01:51:08 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id e16sm5329978wrs.73.2020.02.18.01.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 01:51:08 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86\@kernel.org" <x86@kernel.org>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar\@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson\@intel.com" <sean.j.christopherson@intel.com>,
        "wanpengli\@tencent.com" <wanpengli@tencent.com>,
        "jmattson\@google.com" <jmattson@google.com>,
        "joro\@8bytes.org" <joro@8bytes.org>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "mingo\@redhat.com" <mingo@redhat.com>,
        "bp\@alien8.de" <bp@alien8.de>, "hpa\@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: x86: don't notify userspace IOAPIC on edge-triggered interrupt EOI
In-Reply-To: <edf7454be5a743928cbc1bec5dce238d@huawei.com>
References: <edf7454be5a743928cbc1bec5dce238d@huawei.com>
Date:   Tue, 18 Feb 2020 10:51:07 +0100
Message-ID: <8736b89qb8.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
>>linmiaohe <linmiaohe@huawei.com> writes:
>>
>>> @@ -417,7 +417,7 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
>>>  
>>>  			kvm_set_msi_irq(vcpu->kvm, entry, &irq);
>>>  
>>> -			if (irq.level &&
>>> +			if (irq.trig_mode &&
>>>  			    kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
>>>  						irq.dest_id, irq.dest_mode))
>>>  				__set_bit(irq.vector, ioapic_handled_vectors);
>>
>>Assuming Radim's comment (13db77347db1) is correct, the change in
>>3159d36ad799 looks wrong and your patch restores the status quo. Actually, kvm_set_msi_irq() always sets irq->level = 1 so checking it is pointless.
>>
>>Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> Thanks for review.
>
>>
>> (but it is actually possible that there's a buggy userspace out there which expects EOI notifications; we won't find out unless we try to fix the bug).
>>
>
> Yeh, there may be a buggy userspace hidden from this unexpected EOI notifications. It may not be worth enough to fix it as we may spend many time
> to catch the bug.
> Perhaps we should only remove the pointless checking of irq->level for cleanup. :)

I'm feeling brave so in case nobody expresses any particular concerns
let's just fix it :-)

-- 
Vitaly

