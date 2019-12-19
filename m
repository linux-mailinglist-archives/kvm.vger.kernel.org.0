Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5E2B126D4D
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 20:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfLSTKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 14:10:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54889 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727179AbfLSTKD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 14:10:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576782602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TsFvSsTqVBZ+tF91hnxKk0O+iZiuPyz2pCFwyuo+kkY=;
        b=YFZAvi8IgjpnhNafd99YSnm1tGzhhYLt9t8+Ev0A4N+yAwj4bA3K622oIREH5cz+4a7s/L
        Awh0LyO5W/gIVA+KWuUfMI91yrcnhnp5IXI4l5lM+OXhyZPqWmr0h9iksdWqXNzzOQ8yTb
        GSdfpLQxMS7f9PMQDv1uc4xhjoOp1u0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-xKX_cPXqPaiy5xGEr3GwDQ-1; Thu, 19 Dec 2019 14:10:00 -0500
X-MC-Unique: xKX_cPXqPaiy5xGEr3GwDQ-1
Received: by mail-wr1-f69.google.com with SMTP id f15so2759001wrr.2
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2019 11:10:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=TsFvSsTqVBZ+tF91hnxKk0O+iZiuPyz2pCFwyuo+kkY=;
        b=Tz6M5OIgjfnLgRr9u/vI2EXNnr+yAvb5kL/nH0FIE2yPYz36DjFjdjFkJYX5tHrEZq
         f9vHw06jbnotKB0USJgDn7+qs2ucY8l30oTQ66i6CdYC8dufAYOK8bW5iKsg7caTT28F
         eMApf3o2pePG+ipWyZ19eJ8cqNsa64E928gyAIUoPXbpmqJDPpCLKnIUvARsR4riOUiF
         iF2SXIqI85aQdidYpKJtV7J+kthXFrj9dzIF2ARxaLijf3Onle2c/4cWoaUp9eenh9Wz
         OZSJPfjkLVBWJc0Om0/eWikJ2AawMWepD194hQSo/gOmHXwzbK2Iei09AyJir5oAUbiP
         o/mQ==
X-Gm-Message-State: APjAAAWNElM/lIvjbpZ1IeU3NIzv8wkvZ5y95Gn0pZZBXx2pZs0z1Jtq
        31OiKBVFcka7+f2eT4tIN+2Eh0uDfahwozpvgTVaEzgvhJtGUlWd54srLavxPGUavtY20nlH9RC
        GHwVuaiY/mWeN
X-Received: by 2002:a1c:4d03:: with SMTP id o3mr11976163wmh.164.1576782599916;
        Thu, 19 Dec 2019 11:09:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqyCPSAQBtZpVyCHuMDoSVEQwEOPH4leBjaVKeWb7GppTaUWkTOvT9jwqDl7h6ChPbVt3S9Xrw==
X-Received: by 2002:a1c:4d03:: with SMTP id o3mr11976139wmh.164.1576782599685;
        Thu, 19 Dec 2019 11:09:59 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f65sm7124998wmf.2.2019.12.19.11.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 11:09:58 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     John Allen <john.allen@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, John Allen <john.allen@amd.com>
Subject: Re: [PATCH] kvm/svm: PKU not currently supported
In-Reply-To: <20191219152332.28857-1-john.allen@amd.com>
References: <20191219152332.28857-1-john.allen@amd.com>
Date:   Thu, 19 Dec 2019 20:09:57 +0100
Message-ID: <87immc873u.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

John Allen <john.allen@amd.com> writes:

> Current SVM implementation does not have support for handling PKU. Guests
> running on a host with future AMD cpus that support the feature will read
> garbage from the PKRU register and will hit segmentation faults on boot as
> memory is getting marked as protected that should not be. Ensure that cpuid
> from SVM does not advertise the feature.
>
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
>  arch/x86/kvm/svm.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 122d4ce3b1ab..f911aa1b41c8 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5933,6 +5933,8 @@ static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
>  		if (avic)
>  			entry->ecx &= ~bit(X86_FEATURE_X2APIC);
>  		break;
> +	case 0x7:
> +		entry->ecx &= ~bit(X86_FEATURE_PKU);

Would it make more sense to introduce kvm_x86_ops->pku_supported() (and
return false for SVM and boot_cpu_has(X86_FEATURE_PKU) for vmx) so we
don't set the bit in the first place?

>  	case 0x80000001:
>  		if (nested)
>  			entry->ecx |= (1 << 2); /* Set SVM bit */

-- 
Vitaly

