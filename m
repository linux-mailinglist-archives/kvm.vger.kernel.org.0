Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5BC2177187
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 09:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgCCIss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 03:48:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56964 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727429AbgCCIss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 03:48:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583225327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ftw6CClaVi/KV6ybxr6PLOeZCprvp/dOBx6WJEM3zx0=;
        b=VqaTprowHSbTfBrRQSNsEYAlvJFD6Xe9a78tPiL0wQaWh2Giku2EGkEcdaBKIuD9hEdOlY
        E6mQGevk2vUvf6snnEugSdqIbUIsPt+IMQ8sXxTiH0OZoUCZW2uB4WLuo1hltq+/0HNQIs
        YHDkzDaP6I6XOioz31PofbB6ynlspjM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-EWxx5EP7NVOms32y2mghcw-1; Tue, 03 Mar 2020 03:48:45 -0500
X-MC-Unique: EWxx5EP7NVOms32y2mghcw-1
Received: by mail-wm1-f71.google.com with SMTP id k65so129070wmf.7
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 00:48:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ftw6CClaVi/KV6ybxr6PLOeZCprvp/dOBx6WJEM3zx0=;
        b=iTpkZySXrniCNsAIn0lpCazrmgDnImVn9jXX3KbGQeSVA8aHzmIAMM2Ozmpa9jICp1
         lYJkwFutPsyR5lMHdZaGUN7Kg0zxQL4oKhP34rLBWopEpS9YyJY49U6gO4NYseWLdvpX
         6wrrgASMJlQyaHWq7GlpQnaLjA2h5H7XM9uMDGR5zUYJzaVhjLzjJf+OaygYv+RJxQOp
         NF0QQOZbJt/NH/HEzHptmTKLkcnh8ZnYGVFt0HTRu2wTDnZf2NfqLLMFxvTrqKAXz7h3
         XjwaC/StC8Pu3O9mGBg21TaHkDaKe2qjIvV7Sj3lOhUJOaJqKcT+YkKDPfiMPTcEWMmH
         hPwQ==
X-Gm-Message-State: ANhLgQ3GCAW/KWAMCZ5EC5SQRsj14qT4KO+6WtQFK3ojzQfPC1FjQJRz
        DdP265DP8gnX62nmN0d2GWo1TjxYqKA8zs+hE2EWfrW+pikG+ReYEhz2XH4nPWXPmHkxECs74Ci
        PC1rcmNf7qlbe
X-Received: by 2002:adf:f2cf:: with SMTP id d15mr4284124wrp.397.1583225324615;
        Tue, 03 Mar 2020 00:48:44 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsPedn1piaC4hRCk1GX5tH2GntaDmgyO2i44PbFtdZUWg40PKgxP48EnWv8cbxXlJesnnfsMg==
X-Received: by 2002:adf:f2cf:: with SMTP id d15mr4284101wrp.397.1583225324400;
        Tue, 03 Mar 2020 00:48:44 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4c52:2f3b:d346:82de? ([2001:b07:6468:f312:4c52:2f3b:d346:82de])
        by smtp.gmail.com with ESMTPSA id h10sm2955423wml.18.2020.03.03.00.48.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 00:48:43 -0800 (PST)
Subject: Re: [PATCH 0/6] KVM: x86: CPUID emulation and tracing fixes
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f4a13ce0-1545-4ef7-d95c-2ce2db24a90d@redhat.com>
Date:   Tue, 3 Mar 2020 09:48:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200302195736.24777-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/03/20 20:57, Sean Christopherson wrote:
> Two fixes related to out-of-range CPUID emulation and related cleanup on
> top.
> 
> I have a unit test and also manually verified a few interesting cases.
> I'm not planning on posting the unit test at this time because I haven't
> figured out how to avoid false positives, e.g. if a random in-bounds
> leaf just happens to match the output of a max basic leaf.  It might be
> doable by hardcoding the cpu model?

It would be best suited for selftests rather than kvm-unit-tests.  But I 
don't really see the benefit of anything more than just

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b1c469446b07..c1abf5de4461 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1001,6 +1001,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	       u32 *ecx, u32 *edx, bool check_limit)
 {
 	u32 function = *eax, index = *ecx;
+	u32 orig_function = function;
 	struct kvm_cpuid_entry2 *entry;
 	struct kvm_cpuid_entry2 *max;
 	bool found;
@@ -1049,7 +1050,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 			}
 		}
 	}
-	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, found);
+	trace_kvm_cpuid(orig_function, *eax, *ebx, *ecx, *edx, found);
 	return found;
 }
 EXPORT_SYMBOL_GPL(kvm_cpuid);

