Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 512C1143F21
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 15:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbgAUOOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 09:14:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28197 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727255AbgAUOOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 09:14:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579616084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DQ31pQ6K/s0UNFG5JNDkqQ8k3Ifm3vetwfPhGftFwbs=;
        b=YBW22NjvABTAIqKCTK8Bospj3dhNkUL5g9e4NmpOCqUmlxUzFzNqylgF465gn9O5ys5/H+
        8A64zMGv31EaLap4SbwozZVl7tbyLonD2SFeBu+uoJF333sFvA60ATD+sY8BGEPeqS9NXt
        cDoiUkIRICsGeF8G+4DeUpPOvI8ENfk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-_ChvgpwCM2m7GKy-2j75ag-1; Tue, 21 Jan 2020 09:14:41 -0500
X-MC-Unique: _ChvgpwCM2m7GKy-2j75ag-1
Received: by mail-wm1-f70.google.com with SMTP id w205so663407wmb.5
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 06:14:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DQ31pQ6K/s0UNFG5JNDkqQ8k3Ifm3vetwfPhGftFwbs=;
        b=br5rooBZrSbqvtIUuEfBc9mB0a1qWmzECMwP1Hked4W6MboVyT6MMeNsl3vHHL3xDQ
         8iqOv8bxBZv+PdlD702kQ0uJN3x8iodo81xvPsLzGcMOebOaHv8ssS8XG32YhTQo/pH+
         ksfXhDe1DCtLndW81h73ye2ZZlXvKxPrjtEaM0cfymnm4/jjOTLcKWGI9MtfDjlN4+oZ
         zOen11bopHalVYrmupdKKvmfLOL3MF3EPoudLDhG2HkW2LTIgmI2YFxoxKO6qg0MjAmQ
         ZklyE67yIwkJQACyWtq/MZfZ+Brbk+dA1j5SFLyiF1cOOomLhNcjCUPBGLtzo+oIVWus
         i9Tw==
X-Gm-Message-State: APjAAAVS9kmXyp1M9CiXBYOBrsSIj9d3+QlorIHmRBLmOs0QslfIsGJ2
        xKC1n25HDBTbazodkCO38NtLdsHAuJ+aCQe8wHi/HqOMq9nfEF7YN0vlDpGM4CLVywFAwuaJJKR
        78Gdlepc/Y3ps
X-Received: by 2002:a05:600c:211:: with SMTP id 17mr4557542wmi.60.1579616080493;
        Tue, 21 Jan 2020 06:14:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqzmQNd6Xh5t04lNELXN8HOSVTkFien80RItl+KAQNTRyeAzyC9Sukn1Pl3DvEeDCSZvMzCMlQ==
X-Received: by 2002:a05:600c:211:: with SMTP id 17mr4557510wmi.60.1579616080183;
        Tue, 21 Jan 2020 06:14:40 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id b68sm4162860wme.6.2020.01.21.06.14.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 06:14:39 -0800 (PST)
Subject: Re: [RESEND PATCH v10 06/10] vmx: spp: Set up SPP paging table at
 vmentry/vmexit
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmattson@google.com, yu.c.zhang@linux.intel.com,
        alazar@bitdefender.com, edwin.zhai@intel.com
References: <20200102061319.10077-1-weijiang.yang@intel.com>
 <20200102061319.10077-7-weijiang.yang@intel.com>
 <20200110180458.GG21485@linux.intel.com>
 <20200113081050.GF12253@local-michael-cet-test.sh.intel.com>
 <20200113173358.GC1175@linux.intel.com>
 <20200114030820.GA4583@local-michael-cet-test.sh.intel.com>
 <20200114185808.GI16784@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5d4118d9-c501-6c59-82cc-50e317be195c@redhat.com>
Date:   Tue, 21 Jan 2020 15:14:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200114185808.GI16784@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/01/20 19:58, Sean Christopherson wrote:
> I'm not convinced the instruction length needs to be provided to userspace
> for this case.  Obviously it's not difficult to provide the info, I just
> don't understand the value added by doing so.  As above, RIP shouldn't
> need to be unwound, and blindly skipping an instruction seems like an odd
> thing for a VMI engine to do.
> 

The reason to introduce the instruction length was so that userspace
could blindly use SPP to emulate ROM behavior.  Weijiang's earlier
patches in fact _only_ provided that behavior, and I asked him to change
it so that, by default, using SPP and not handling it will basically
cause an infinite loop of SPP violations.

One possibility to clean things up is to change "fault_handled" and
fast_page_fault's return value from bool to RET_PF* (false becomes
RET_PF_INVALID, true becomes RET_PF_RETRY).  direct_page_fault would
also have to do something like

	r = fast_page_fault(vcpu, gpa, level, error_code))
	if (r != RET_PF_INVALID)
		return r;

Then fast_page_fault can just return RET_PF_USERSPACE, and this ugly
case can go away.

+		if (vcpu->run->exit_reason == KVM_EXIT_SPP)
+			r = RET_PF_USERSPACE;
+

Thanks,

Paolo

