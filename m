Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2852936FD
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 10:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389498AbgJTIsc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 04:48:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40405 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389469AbgJTIsc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Oct 2020 04:48:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603183710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Exr3JEpwl/BxzRKczzHakQYIFkSCQvCsSI/Q1fUqmHU=;
        b=EHW7jR1oIfugyH6nJGHqfmTyyLeJSngVqB+9bpja5f1UvY4IffcQT42MRcFARvhub1spDj
        o6D4SW+6MEY3XPci0cuCm9l1KSt4N48LulyUDVwkolGceGh5dp3QTtYzGu4FRwPbQkhVfh
        OBZR+v0SK6PhfG32q70WqcHmg9BcqEM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-ioy2wwmBOzeu_rmLs0OMOQ-1; Tue, 20 Oct 2020 04:48:28 -0400
X-MC-Unique: ioy2wwmBOzeu_rmLs0OMOQ-1
Received: by mail-wr1-f72.google.com with SMTP id t11so525077wrv.10
        for <kvm@vger.kernel.org>; Tue, 20 Oct 2020 01:48:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Exr3JEpwl/BxzRKczzHakQYIFkSCQvCsSI/Q1fUqmHU=;
        b=fIKh+/iyhzKr5kioxy9nHxHwLHDGxgo38HvoWN24gX2WKh7XuYoLJm8Z6soyyKamK2
         XKn7JAY90EOiDEfKbJ05B49zlN/Jqf1laywOd8BzbfGDYj50Msr4t5RMbTLhDU4kwC23
         v9GL/bMiaZiOWm72pjqxWC5eJpjmYoG3fYD1samzskERGzN8nSKkFwr0nyQSCQvy9Ac2
         tJbq/NXcwt2dknVw1WE2mD3ULQPpAeK/Ks68v0n37HZiTvbyHAcbA3T4uZB0JlpQ7B75
         opfS+u+mfIdJZsqWTnsr5BiUmoZi7lxKkVnlEf3xOVvIqIsKilkSBWsIt6jRHUlHfVah
         oGsw==
X-Gm-Message-State: AOAM530EUTEnDpmIZodsmri+n/XXfUcVOlEBZqCk0x/YjdX8yvPgGoXo
        lnXLfnm/KRfoF0rHvJned1XlbAr2Up6HiI+749JYJLUhAbZ536wrlc6GFgu+syROSWm9rj3S6Fp
        o27ey0gfqYNim
X-Received: by 2002:a7b:c305:: with SMTP id k5mr1811742wmj.102.1603183706276;
        Tue, 20 Oct 2020 01:48:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrkMw9qmI5HmnbTOsfcg5EICQEvupTqIP4x6KdbAzj7ON79u1C/QuHrpTvSiLEg6CNmVpPWw==
X-Received: by 2002:a7b:c305:: with SMTP id k5mr1811721wmj.102.1603183706024;
        Tue, 20 Oct 2020 01:48:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c130sm1616484wma.17.2020.10.20.01.48.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 01:48:25 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCHv2] unittests.cfg: Increase timeout for apic
 test
To:     Nadav Amit <nadav.amit@gmail.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20201013091237.67132-1-po-hsu.lin@canonical.com>
 <87d01j5vk7.fsf@vitty.brq.redhat.com>
 <20201015163539.GA27813@linux.intel.com>
 <87o8ky4fkf.fsf@vitty.brq.redhat.com>
 <a6e33cd7d0084d6389a02786225db0e8@intel.com>
 <C67F3473-32FE-4099-BBB1-8BB31B1ED95D@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d1277875-6b7a-f7fe-8a58-78ba5ae0ba1d@redhat.com>
Date:   Tue, 20 Oct 2020 10:48:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <C67F3473-32FE-4099-BBB1-8BB31B1ED95D@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/20 18:52, Nadav Amit wrote:
> IIRC, this test failed on VMware, and according to our previous discussions,
> does not follow the SDM as NMIs might be collapsed [1].
> 
> [1] https://marc.info/?l=kvm&m=145876994031502&w=2

So should KVM be changed to always collapse NMIs, like this?

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 105261402921..4032336ecba3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -668,7 +668,7 @@ EXPORT_SYMBOL_GPL(kvm_inject_emulated_page_fault);

 void kvm_inject_nmi(struct kvm_vcpu *vcpu)
 {
-	atomic_inc(&vcpu->arch.nmi_queued);
+	atomic_set(&vcpu->arch.nmi_queued, 1);
 	kvm_make_request(KVM_REQ_NMI, vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_inject_nmi);
@@ -8304,18 +8304,7 @@ static void inject_pending_event(struct kvm_vcpu
*vcpu, bool *req_immediate_exit

 static void process_nmi(struct kvm_vcpu *vcpu)
 {
-	unsigned limit = 2;
-
-	/*
-	 * x86 is limited to one NMI running, and one NMI pending after it.
-	 * If an NMI is already in progress, limit further NMIs to just one.
-	 * Otherwise, allow two (and we'll inject the first one immediately).
-	 */
-	if (kvm_x86_ops.get_nmi_mask(vcpu) || vcpu->arch.nmi_injected)
-		limit = 1;
-
-	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
-	vcpu->arch.nmi_pending = min(vcpu->arch.nmi_pending, limit);
+	vcpu->arch.nmi_pending |= atomic_xchg(&vcpu->arch.nmi_queued, 0);
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 }


Paolo

