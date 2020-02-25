Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2622716C12D
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 13:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbgBYMnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 07:43:40 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44079 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729181AbgBYMnk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 07:43:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582634618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iaNn1ynq48vLpTxDrAlYN1oM6Y/pu6+O3QE2MamshO4=;
        b=QcngjVQ2hHoyBHV0/FoOCpRuS6eZn/Cd4qkkAtd5NhH40pDutNAjS4HPYNDpHzEfoL3ID2
        usqgI03JpnohH+JPSBSA/zd/nYPNfVSguOt3BNPfuNPTzmHfMQB+jWtBHm5PTX2m+5i0Vi
        En/EnPa7RDiviExxgqOfD+67ZJdEn5g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-o1DR7_WdMaSgEbTvc6Ltbg-1; Tue, 25 Feb 2020 07:43:37 -0500
X-MC-Unique: o1DR7_WdMaSgEbTvc6Ltbg-1
Received: by mail-wr1-f69.google.com with SMTP id 90so7243775wrq.6
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 04:43:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=iaNn1ynq48vLpTxDrAlYN1oM6Y/pu6+O3QE2MamshO4=;
        b=FBTgwN6qc8cRbUtYiJ0z2aADWZnjkxdmAjVV42Lf1vCCpqSI681KdCk+2E9/zpMUEd
         aIJKl0SBClEoAoGqjo0XZ2UEnsfWWq7sVHqYu+hAGazBOnhI7iRY/5KLvKo0OAFi7/vC
         zQRFVn425bn9j6WuMadNURqukHn4QMruoJJWQtBCV2wLcYSHmOGeZMSfH3LITN7UC7g/
         9qEQvqUDd5i9FwIiLNX3/a0QwEiQAb+nAYMlAFR8TiG6ojCNP1W/UUvDpoF3yjDVflhN
         SvfLXiuKCHxQXE2hmDJkEyCIoPXFXtzLH1b5BauPHu7JFo4lqqI8+czSiv1Z79ePGcQx
         23pA==
X-Gm-Message-State: APjAAAVJqcC56qSuP1OkjWJtjeDgvKDgCXOsPJw+JxgV0ggQ5CAML5C8
        liB0LRT6cby5UGyr16ky3lhMCHFNvvXrGz9yQPGc7sn0WLJzjrk69jwbVd+EvKZu0yy2wBWZi8C
        RRLh6LE3GGE5S
X-Received: by 2002:a1c:2089:: with SMTP id g131mr4891486wmg.63.1582634615991;
        Tue, 25 Feb 2020 04:43:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqwXpLSxXihQUnUiQh0jNgbtVlRTh4HV6fmkshzIW/LXmyh0n1o+t0mLFMw203AeYdGahwTdKg==
X-Received: by 2002:a1c:2089:: with SMTP id g131mr4891454wmg.63.1582634615709;
        Tue, 25 Feb 2020 04:43:35 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id o27sm6334675wro.27.2020.02.25.04.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 04:43:35 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: X86: avoid meaningless kvm_apicv_activated() check
In-Reply-To: <1582597279-32297-1-git-send-email-linmiaohe@huawei.com>
References: <1582597279-32297-1-git-send-email-linmiaohe@huawei.com>
Date:   Tue, 25 Feb 2020 13:43:34 +0100
Message-ID: <87d0a2n8g9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> After test_and_set_bit() for kvm->arch.apicv_inhibit_reasons, we will
> always get false when calling kvm_apicv_activated() because it's sure
> apicv_inhibit_reasons do not equal to 0.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/x86.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ddcc51b89e2c..fa62dcb0ed0c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8018,8 +8018,7 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
>  		    !kvm_apicv_activated(kvm))
>  			return;
>  	} else {
> -		if (test_and_set_bit(bit, &kvm->arch.apicv_inhibit_reasons) ||
> -		    kvm_apicv_activated(kvm))
> +		if (test_and_set_bit(bit, &kvm->arch.apicv_inhibit_reasons))
>  			return;
>  	}

This seems to be correct in a sense that we are not really protected
against concurrent modifications of 'apicv_inhibit_reasons' (like what
if 'apicv_inhibit_reasons' gets modified right after we've checked
'kvm_apicv_activated(kvm)').

The function, however, still gives a flase impression it is somewhat
protected against concurent modifications. Like what are these
test_and_{set,clear}_bit() for?

If I'm not mistaken, the logic this function was supposed to implement
is: change the requested bit to the requested state and, if
kvm_apicv_activated() changed (we set the first bit or cleared the
last), proceed with KVM_REQ_APICV_UPDATE. What if we re-write it like

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2103101eca78..b97b8ff4a789 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8027,19 +8027,19 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
  */
 void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 {
+       bool apicv_was_activated = kvm_apicv_activated(kvm);
+
        if (!kvm_x86_ops->check_apicv_inhibit_reasons ||
            !kvm_x86_ops->check_apicv_inhibit_reasons(bit))
                return;
 
-       if (activate) {
-               if (!test_and_clear_bit(bit, &kvm->arch.apicv_inhibit_reasons) ||
-                   !kvm_apicv_activated(kvm))
-                       return;
-       } else {
-               if (test_and_set_bit(bit, &kvm->arch.apicv_inhibit_reasons) ||
-                   kvm_apicv_activated(kvm))
-                       return;
-       }
+       if (activate)
+               clear_bit(bit, &kvm->arch.apicv_inhibit_reasons);
+       else
+               set_bit(bit, &kvm->arch.apicv_inhibit_reasons);
+
+       if (kvm_apicv_activated(kvm) == apicv_was_activated)
+               return;
 
        trace_kvm_apicv_update_request(activate, bit);
        if (kvm_x86_ops->pre_update_apicv_exec_ctrl)

Is this equal?

-- 
Vitaly

