Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C6438F156
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 18:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbhEXQUc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 12:20:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36063 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232676AbhEXQUb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 12:20:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621873143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zx+Q390U8pLPzbAiF6wzLy2oac+v3wRma2N/BJbHIrA=;
        b=bAnP9DNb0FnNFcYY7hAHmaaJ05q6GBBKZy8ndqzliKYxitX6acj9NMqcIwMZNbnpp2FVBr
        MU0ykkZWZ9NymJ+ajBRVHMpmJyL3TEOs68V8PMwFwfMTGSwz8zYrHbi5xIWw5RqcX3BnZp
        C3yynSBGIAICkd9bTpxw0ziX7029D+c=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-Dna3DI6NNwqcSlzLWH0fug-1; Mon, 24 May 2021 12:19:01 -0400
X-MC-Unique: Dna3DI6NNwqcSlzLWH0fug-1
Received: by mail-ej1-f72.google.com with SMTP id i8-20020a1709068508b02903d75f46b7aeso7459591ejx.18
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 09:19:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zx+Q390U8pLPzbAiF6wzLy2oac+v3wRma2N/BJbHIrA=;
        b=UepkeftFWrlwipeTJAJME3AXXh4k0EALgeKXNZfF8MollX0dnBLIae2GDnx/b3rLRy
         0VJs0G9N4RZ4nvTrVyxJZCu14g4QTDX5KHG/Enc2PWUOM2HK6WX8FJOu6UTNeg7pZKlh
         P04Gz7C/I66dJjdrzS7qwoQEIYwSoL++gaqFOHqgCOcupEvBXizbq17lzC4ax/XGJCaz
         tREOBUp03LznQ5FkJRiTdnOFlOUYCmNXLJ4PKBl2yBZakbqONE7ELoeCN42PXXDlz+Vc
         yfOivNWmTXFvuQyCoHj4NZkZIR2y54dDte2G68D7fyPjGVwbdaglBynRQRlv+ib3Nq8z
         Ypqg==
X-Gm-Message-State: AOAM533lanWtyhj4Tg8WTTi25pyCMJWokgi9fS+fX44KGX7M4DSS3ezi
        uX+pbYHCDDFMKf0V0g3IiB3z+sosd/aU/Vb6Q1zRnF9uVfrzZNzGDlbwoKOM8OtSq3hVlhN1lX8
        3J63lE+7qRBpr
X-Received: by 2002:a17:906:4714:: with SMTP id y20mr12021982ejq.235.1621873140399;
        Mon, 24 May 2021 09:19:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/+1MKBcytF0mddgWHhWR2Rr4Ab0MBYT96t0xHKcOjWgUHEzAof7QfJACzqp6Tfyn9ofc37Q==
X-Received: by 2002:a17:906:4714:: with SMTP id y20mr12021960ejq.235.1621873140194;
        Mon, 24 May 2021 09:19:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p11sm3043022edt.22.2021.05.24.09.18.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 09:18:59 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org
References: <20210518144339.1987982-1-vkuznets@redhat.com>
 <20210518144339.1987982-4-vkuznets@redhat.com> <YKQmG3rMpwSI3WrV@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 3/5] KVM: x86: Use common 'enable_apicv' variable for
 both APICv and AVIC
Message-ID: <12eadbce-f688-77a1-27bf-c33fee2e7543@redhat.com>
Date:   Mon, 24 May 2021 18:18:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YKQmG3rMpwSI3WrV@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/05/21 22:39, Sean Christopherson wrote:
>> +/* enable / disable AVIC */
>> +static int avic;
>> +module_param(avic, int, 0444);
> We should opportunistically make avic a "bool".
> 

And also:

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 11714c22c9f1..48cb498ff070 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -185,9 +185,12 @@ module_param(vls, int, 0444);
  static int vgif = true;
  module_param(vgif, int, 0444);
  
-/* enable / disable AVIC */
-static int avic;
-module_param(avic, int, 0444);
+/*
+ * enable / disable AVIC.  Because the defaults differ for APICv
+ * support between VMX and SVM we cannot use module_param_named.
+ */
+static bool avic;
+module_param(avic, bool, 0444);
  
  bool __read_mostly dump_invalid_vmcb;
  module_param(dump_invalid_vmcb, bool, 0644);
@@ -1013,11 +1016,7 @@ static __init int svm_hardware_setup(void)
  			nrips = false;
  	}
  
-	if (!npt_enabled || !boot_cpu_has(X86_FEATURE_AVIC))
-		avic = false;
-
-	/* 'enable_apicv' is common between VMX/SVM but the defaults differ */
-	enable_apicv = avic;
+	enable_apicv = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);
  	if (enable_apicv) {
  		pr_info("AVIC enabled\n");
  

The "if" can come back when AVIC is enabled by default.

Paolo

