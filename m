Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9450034ACE6
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 17:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhCZQy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 12:54:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229986AbhCZQy2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 12:54:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616777668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+hdqVwTjvSAoXWRt2SuUjwXo5DUYgQU7gWDl4Bgpl/A=;
        b=eDJbq/cMNZ8XRLwiuMkfruSfVMHw1EmI4faYcGaiRHcxRlcZxesGfqMwXzjJcMT5wJPLJX
        PgBMWYP825iVSteHZ18CbfCqVc2VLViWCXX2T3RCZXPcswyfBu2nQuCSfpURtb0mYO5Ziu
        s0hBZKdytygb2Rz9+C8EE9wrA8FzY4U=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-Go51hB-9OLO_wicn6enhgA-1; Fri, 26 Mar 2021 12:54:24 -0400
X-MC-Unique: Go51hB-9OLO_wicn6enhgA-1
Received: by mail-ed1-f71.google.com with SMTP id w18so4735230edu.5
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 09:54:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+hdqVwTjvSAoXWRt2SuUjwXo5DUYgQU7gWDl4Bgpl/A=;
        b=YrOYRY2pnSH42clkHX5YSvmgsCayIHLckjNjX/jpDUB5W6pdqz7MZhJGKiCvJ1Wzrn
         nyVucsw3VQB4hrKVMUY1egE+bQZAbAxv6wBTc35SxMSeBonjb9jo6PwW+EXGTkmLJIcp
         e/++BlQjyCPKw9cGIdqIZLJ9CNbhfAnDOlo5ddMD/1pSmt3hNGvjvIhQx6M+hxsJoDzP
         1zRB4Wd494Iuz15Ukz+0+vearvKoBwN6qMUp6Kn3i+/azVn3uhIq9kKhl8ItSPrubfsF
         v62jEIiY52aET+vfMpcIVkPY7dus5ks8pfQF1iW86bvOlUUc6D72q9J6Sykr7VKSUMHJ
         TgjA==
X-Gm-Message-State: AOAM531NykoZfDcAffOMcbbpK4k6YDE9SpUYaX9HgpDFCUGfxgebEvWp
        qPWQvjsyh2b6kAPLMR/rruuaqNfTtmgAU/tKkB0fCqKCpKbPufqln9EJXjHmOKJFArbZeVtNVyy
        9cg0+O76VOAfd
X-Received: by 2002:aa7:d94c:: with SMTP id l12mr15589060eds.311.1616777663043;
        Fri, 26 Mar 2021 09:54:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxctECcYRvbgJmiXwqiuFOS/nA2af3e0mSAiuEO41/fUIO42dw3JPXQR3AFOubTmTlXh5L9iA==
X-Received: by 2002:aa7:d94c:: with SMTP id l12mr15589047eds.311.1616777662903;
        Fri, 26 Mar 2021 09:54:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r25sm4568813edv.78.2021.03.26.09.54.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 09:54:22 -0700 (PDT)
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <20210326155551.17446-1-vkuznets@redhat.com>
 <20210326155551.17446-2-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: hyper-v: Forbid unsigned
 hv_clock->system_time to go negative after KVM_REQ_CLOCK_UPDATE
Message-ID: <5e5ba386-99d1-162a-4e70-520af9581994@redhat.com>
Date:   Fri, 26 Mar 2021 17:54:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210326155551.17446-2-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/03/21 16:55, Vitaly Kuznetsov wrote:
> Another solution is to cast 'hv_clock.system_time' to
> 's64' in compute_tsc_page_parameters() but it seems we also use
> 'hv_clock.system_time' in trace_kvm_pvclock_update() as unsigned.

I think that is better.  There is no reason really to clamp the value to
to 0, while we know already that tsc_ref->tsc_offset can be either
positive or negative.  So treating hv_clock->system_time as signed
before the division would make sense.

It should be just

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 58fa8c029867..e573e987f41b 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1070,9 +1070,7 @@ static bool compute_tsc_page_parameters(struct pvclock_vcpu_time_info *hv_clock,
  				hv_clock->tsc_to_system_mul,
  				100);
  
-	tsc_ref->tsc_offset = hv_clock->system_time;
-	do_div(tsc_ref->tsc_offset, 100);
-	tsc_ref->tsc_offset -=
+	tsc_ref->tsc_offset = div_s64(hv_clock->system_time, 100) -
  		mul_u64_u64_shr(hv_clock->tsc_timestamp, tsc_ref->tsc_scale, 64);
  	return true;
  }

right?  The test passes for me with this change.

Paolo

