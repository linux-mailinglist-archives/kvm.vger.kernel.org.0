Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B05C178C05
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 08:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbgCDH7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 02:59:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60099 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725271AbgCDH7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 02:59:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583308739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9idwP0YJKo3uKB+4bzwXcoMlOXVhMKCyZCmIOhNfVTg=;
        b=afef5u5+UV2WH3WdeVrDLGwWJwupUfC3KC3RBf3XpEkkVRGZU1GPDS1qipiUq2B07z1YCz
        2Jb2MxevwLUBTIC+sjMo79o+WW05WzpoaA3/RIOKG2I2GNza1Gte5VkHoAG6WBNaLueKU7
        W36dTxm2fs4J/TLgAhMHCmevwKyWHlM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-yLe8b3VrNzmllxzsrtHg0g-1; Wed, 04 Mar 2020 02:58:58 -0500
X-MC-Unique: yLe8b3VrNzmllxzsrtHg0g-1
Received: by mail-wm1-f70.google.com with SMTP id v21so237604wml.5
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 23:58:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9idwP0YJKo3uKB+4bzwXcoMlOXVhMKCyZCmIOhNfVTg=;
        b=am2dj4BwtBpxWG3Qx5QpFq7+7NFLXid7icPctXDWwUu7isX+tO49I3FLXCU1r8J5S8
         1g8arnAJ/uP8bdA6xJpoWEwFZn8yYmcOB/ZBOKqi78P03bV/exUpDSoLtBkbyAqZDziD
         JiwFzzrKSFJjp8gNPiQeWa7gvekFhoAU3dACZ7d/IWCburXkleOIVfgA+ChojpQtNElS
         fkMkhshrtZBDPqzOxrwBdH2nlkxTY2wCsXkXXRUJk+c6fH8dKsuuc+XFWdJ/A2Yg4xtb
         ecA9oIThazytcsaLCdHfInN4WEPHQ2E63JyJEalwD3131usU7+QoG7IIelqlWn4SipJj
         3ttA==
X-Gm-Message-State: ANhLgQ3s5mVAF1Dl+BEV1X9EHJFItdEDbRmyqUhZHn8LiXQAG0og4l5P
        ZEh01My7XvFu2MQyL7y4UDyCBfIQBB4Vxlg/mP3bn0y6Fp8Zh/ZvrJ8xswzlAume1F2700elOrl
        nGKRROG4S+hv/
X-Received: by 2002:a1c:9a88:: with SMTP id c130mr2353129wme.73.1583308737285;
        Tue, 03 Mar 2020 23:58:57 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuCZt1yb/8rNJw+Sp6DJi+8Wr7JwjrnuNcVtNzhZUDGNMJZymKyNSwEnYnpAXn/hqNe2lQEAA==
X-Received: by 2002:a1c:9a88:: with SMTP id c130mr2353106wme.73.1583308737024;
        Tue, 03 Mar 2020 23:58:57 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id c8sm11521398wrt.19.2020.03.03.23.58.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 23:58:56 -0800 (PST)
Subject: Re: [PATCH 3/4] KVM: x86: Revert "KVM: X86: Fix fpu state crash in
 kvm guest"
To:     "Liu, Jing2" <jing2.liu@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Derek Yerger <derek@djy.llc>,
        kernel@najdan.com, Thomas Lambertz <mail@thomaslambertz.de>,
        Rik van Riel <riel@surriel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20200117062628.6233-1-sean.j.christopherson@intel.com>
 <20200117062628.6233-4-sean.j.christopherson@intel.com>
 <ca47fce8-a042-f967-513c-93cabac2122d@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3c467967-a499-af4e-29df-ddfeb196714f@redhat.com>
Date:   Wed, 4 Mar 2020 08:58:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <ca47fce8-a042-f967-513c-93cabac2122d@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/03/20 08:41, Liu, Jing2 wrote:
>>       trace_kvm_entry(vcpu->vcpu_id);
>>       guest_enter_irqoff();
>>   -    /* The preempt notifier should have taken care of the FPU
>> already.  */
>> -    WARN_ON_ONCE(test_thread_flag(TIF_NEED_FPU_LOAD));
>> +    fpregs_assert_state_consistent();
>> +    if (test_thread_flag(TIF_NEED_FPU_LOAD))
>> +        switch_fpu_return();
>>         if (unlikely(vcpu->arch.switch_db_regs)) {
>>           set_debugreg(0, 7);
> 
> Can kvm be preempt out again after this (before really enter to guest)?

No, irqs are disabled here.

Paolo

