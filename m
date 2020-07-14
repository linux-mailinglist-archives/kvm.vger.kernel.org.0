Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E94721EF38
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 13:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgGNL0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 07:26:36 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45721 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726252AbgGNL0e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jul 2020 07:26:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594725992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TJeEki0uVQWPb/ob8M4M4Jdb/RfjLFoi2GnA8loZRLE=;
        b=GQmkI4ApBiDzW5raoAArd4twe+vBJGYkHfi5u+dTpJVzPjq/Vs4HdZ2ZJTCptahZ7xC7e5
        CQF6cqyN1pq2MYdPNbQtWXCeBMALcvYaNVkE49oFg5CYb3dWtGyKehxUGv31jVOTTgpLQz
        XAevn/OJ1nsG9UjNcadfXNO9Be207vM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-TZsCqKnTP0yatmiYxigPSg-1; Tue, 14 Jul 2020 07:26:28 -0400
X-MC-Unique: TZsCqKnTP0yatmiYxigPSg-1
Received: by mail-wm1-f70.google.com with SMTP id 65so3476742wmd.8
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 04:26:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=TJeEki0uVQWPb/ob8M4M4Jdb/RfjLFoi2GnA8loZRLE=;
        b=TcavZVLSH4iTVKeidxJJ8dhXheUC8NR/yC2DxpZvt2BmQ4MJ1TFZSjciMKv1B3TAdr
         LGzovxh2FwbcsP8dr1CDKOf9/eDlQcEoCN9iGQftlOjam2P8q8jyqynMHLzP5uMVatei
         UGnM3iZpW9dPVNoVYXD9hiv1rjztWDGBu4hsjWprsON/xQlFsLkIG9jlHNKNhwymg8lS
         rOwyOJ2Y8bIhd0Tlt1pr2uNsxlTpUMTxUvrn+3eCm5MjeuN94XqKsDRcOLJWX+n1waM3
         o92T2WaJkev/nRluJQ2iIPa5HEESkWvnMJtkxUye9Qu/I1BmV/ZUxx9VpH2Ivrs1C01x
         Nm1g==
X-Gm-Message-State: AOAM531UI0AJXn3sII7O2KzcJs/cpoKOIIrWbzIJvQuoDWTpE7FEhUE3
        doeOT00BV2IUq1VVAHa2A7ia2lBHK39oJVb8NmPEqWUq6FPgMgSeIEVvgc7QqlHhwC2dAdPxmIx
        0rCYpOqRMLWfA
X-Received: by 2002:a1c:96c5:: with SMTP id y188mr3975658wmd.71.1594725987820;
        Tue, 14 Jul 2020 04:26:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwA3dbtC9qEktPNuMFfj1zuUincAvX+x7FO+MKHJvpEqbG+SjBNiazEyUSs5r5lPOuDz6bycg==
X-Received: by 2002:a1c:96c5:: with SMTP id y188mr3975628wmd.71.1594725987509;
        Tue, 14 Jul 2020 04:26:27 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id 78sm4256270wma.31.2020.07.14.04.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 04:26:26 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/9] KVM: nSVM: introduce nested_svm_load_cr3()/nested_npt_enabled()
In-Reply-To: <20200713223814.GG29725@linux.intel.com>
References: <20200710141157.1640173-1-vkuznets@redhat.com> <20200710141157.1640173-6-vkuznets@redhat.com> <20200713223814.GG29725@linux.intel.com>
Date:   Tue, 14 Jul 2020 13:26:24 +0200
Message-ID: <87zh82s5gf.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Fri, Jul 10, 2020 at 04:11:53PM +0200, Vitaly Kuznetsov wrote:
>> As a preparatory change for implementing nested specifig PGD switch for
>
> s/specifig/specific
>
>> nSVM (following nVMX' nested_vmx_load_cr3()) instead of relying on
>
> nVMX's
>
>> kvm_set_cr3() introduce nested_svm_load_cr3().
>
> The changelog isn't all that helpful to understanding the actual change.
> All this is doing is wrapping kvm_set_cr3(), but that's not at all obvious
> from reading the above.
>
> E.g.
>
>   Add nested_svm_load_cr3() as a pass-through to kvm_set_cr3() as a
>   preparatory change for implementing nested specific PGD switch for nSVM,
>   (following nVMx's nested_vmx_load_cr3()).
>

Sounds better indeed, thanks!

>> No functional change intended.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/svm/nested.c | 21 +++++++++++++++++++--
>>  1 file changed, 19 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index 5e6c988a4e6b..180929f3dbef 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -311,6 +311,21 @@ static void nested_vmcb_save_pending_event(struct vcpu_svm *svm,
>>  	nested_vmcb->control.exit_int_info = exit_int_info;
>>  }
>>  
>> +static inline bool nested_npt_enabled(struct vcpu_svm *svm)
>> +{
>> +	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
>> +}
>> +
>> +/*
>> + * Load guest's cr3 at nested entry. @nested_npt is true if we are
>> + * emulating VM-Entry into a guest with NPT enabled.
>> + */
>> +static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
>> +			       bool nested_npt)
>
> IMO the addition of nested_npt_enabled() should be a separate patch, and
> the additoin of @nested_npt should be in patch 7.
>
> Hypothetically speaking, if nested_npt_enabled() is inaccurate at the call
> site in nested_prepare_vmcb_save(), then this patch is technically wrong
> even though it doesn't introduce a bug.  Given that the call site of
> nested_svm_load_cr3() is moved in patch 7, I don't see any value in adding
> the placeholder parameter early.
>

I see and I mostly agree, I put it here to avoid the unneeded churn and
make it easier to review the whole thing: this patch is technically a
nop so it can be reviewed in "doesn't change anything" mode and patches
which actually change things are smaller.

Paolo already said 'queued' here and your comments can't be addressed in
a follow-up patch but I can certainly do v5 if needed.

Thanks for your review!

-- 
Vitaly

