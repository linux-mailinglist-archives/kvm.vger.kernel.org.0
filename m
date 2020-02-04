Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF623151C60
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 15:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgBDOhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 09:37:05 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45432 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727250AbgBDOhF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 09:37:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580827023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d4oID/MjfqTQ+n08/EIWcONdJe6Z2nq4WI7xtUbHDEI=;
        b=c9fJMBM6ZYnRbGPjlRXHnODLHFwS5tatjIvH0mQ6Jufd3Noeq6ej27JUr/jCzaTvx6fTLr
        NQMbNWEDjHN5xXB88hnkOkArqQYUzSTm377bMKI3R9EH4+bHSWxEvuDgle9kPZX3dUO/T8
        3JBgZkx8x/HCjkq9IJi+tZB7Sdeezn0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-QqJkwqhEOayxTuNMGeLPoQ-1; Tue, 04 Feb 2020 09:36:56 -0500
X-MC-Unique: QqJkwqhEOayxTuNMGeLPoQ-1
Received: by mail-wm1-f72.google.com with SMTP id b133so1272642wmb.2
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 06:36:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=d4oID/MjfqTQ+n08/EIWcONdJe6Z2nq4WI7xtUbHDEI=;
        b=uef7zpl46p4zpvJGCQokgaQm+PifNty4eqTzTDFy7ax3YD/jTDek+dVE4jcrEMNEa6
         H+E2LEqWeToZGnG1DaFlx8AXRnRt4h5jIIelZvRuaRBH4m24VOifq3QLLnlwIXxGRPAC
         tQ6759A9x5Tsaw6cYvLnLUWJtSE3w56iOTkjSArqRzOYAJZrOHHV/6mtTg9yuaEQIf0k
         get8fGOcfz69WjnLmJUrUwdjBTfTAiiuvClbxJtqcxYW566VrPX+/NzLuRFByd8f2GNg
         gDUTEdF7mMtwZX2L491Xl79rmPwAxGz6XXVafxHFffeQIubzZT2E7wvIBmMjluHgRAVO
         Jj2Q==
X-Gm-Message-State: APjAAAWj8y4tEfyXkRl1OjzxVIE8l6OjoOXdfgNDdxB1lHcwjyceZa8z
        ymWXmbkkV75uF0JKB6TTcfm/GHlSubZTrrhOYuBZUKealkreQ+TTBuH46BsrYPgpLztrbOsym2O
        e6xI10EMEAPbG
X-Received: by 2002:a1c:9dce:: with SMTP id g197mr5906155wme.23.1580827015072;
        Tue, 04 Feb 2020 06:36:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqyac0/Vwg6esCkpMW9u2CVE28Xh1fpnOCRV5CRBnFdTm1nx54yPw5Wkor5FBNIjnBmuYfZhGg==
X-Received: by 2002:a1c:9dce:: with SMTP id g197mr5906138wme.23.1580827014828;
        Tue, 04 Feb 2020 06:36:54 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id e18sm29407471wrw.70.2020.02.04.06.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 06:36:54 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: Re: [PATCH] KVM: Pre-allocate 1 cpumask variable per cpu for both pv tlb and pv ipis
In-Reply-To: <CANRm+CzkN9oYf4UqWYp2SHFii02=pvVLbW4oNkLmPan7ZroDZA@mail.gmail.com>
References: <CANRm+CwwYoSLeA3Squp-_fVZpmYmxEfqOB+DGoQN4Y_iMT347w@mail.gmail.com> <878slio6hp.fsf@vitty.brq.redhat.com> <CANRm+CzkN9oYf4UqWYp2SHFii02=pvVLbW4oNkLmPan7ZroDZA@mail.gmail.com>
Date:   Tue, 04 Feb 2020 15:36:53 +0100
Message-ID: <874kw6o1ve.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

>>
>> Honestly, I'd simplify the check in kvm_alloc_cpumask() as
>>
>> if (!kvm_para_available())
>>         return;
>>
>> and allocated masks for all other cases.
>
> This will waste the memory if pv tlb and pv ipis are not exposed which
> are the only users currently.
>

My assumption is that the number of cases where we a) expose KVM b)
don't expose IPIs and PV-TLB and c) care about 1 cpumask per cpu is
relatively low. Ok, let's at least have a function for

	if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
	    !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME))

as we now check it twice: in kvm_alloc_cpumask() and kvm_guest_init(),
something like pv_tlb_flush_supported(). We can also do
pv_ipi_supported() and probably others for consistency.

Also, probably not for this patch but it all makes me wonder why there's
no per-cpu 'scratch' cpumask for the whole kernel to use. We definitely
need it for hypervisor support but I also see
arch/x86/kernel/apic/x2apic_cluster.c has similar needs.

-- 
Vitaly

