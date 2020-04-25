Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16FA1B86C1
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 15:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgDYNTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 09:19:31 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53344 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726107AbgDYNTb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 25 Apr 2020 09:19:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587820770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZURiLBETOzpWxA+m+Ly+zcrAkCfuj4ARVrSBfsuIAdg=;
        b=dUNLV25qYQXn5GRNAZJUuT0wBn5WdiFx4vknSkgb8ubRBPFbSV1C76wwMU2xh7f/rm7Fh+
        vio3d3xSLO8HJW32bOUI9vnM9ctqIg2SBRHiMrmiluXIXhNg8+3VQ/olQY3tVMYUgb3zJS
        LorlUJavV/ycQDqtSKqQBAP7w8xaKhY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-XRXUzeY3Od2SL7Cu9IJ0Nw-1; Sat, 25 Apr 2020 09:19:28 -0400
X-MC-Unique: XRXUzeY3Od2SL7Cu9IJ0Nw-1
Received: by mail-wr1-f72.google.com with SMTP id s11so6691496wru.6
        for <kvm@vger.kernel.org>; Sat, 25 Apr 2020 06:19:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZURiLBETOzpWxA+m+Ly+zcrAkCfuj4ARVrSBfsuIAdg=;
        b=cHk6LV7nRvErfsVuC276Ne8M649RHxs5YiNVLoFXEPtVXbQHwzisvG8EuxEsHGJ6+f
         Xnig533QUbyDCF0Ede8i5a/VI8i+txTLhBkvtLkfklxw04T4YbGWVvt2SqNgrkYdQgYA
         AAOG2NKTIHh4oqsyWCbY8GT6WAgS7KwRktY9LIPsV8q7NPbYRQg2XLbJQkTap31bQ8e9
         oyUgtYtYPX5Lp3/RAI8vDr1W+AVlcnKpHyGpy4YQdD4Z/YlqHX73MW32Dn9MKr1TciAi
         uPPRIjE9gL3KV5l9wv3NWWrX8mX9D75Z3GxxzUa2vXZMtmQkpishplff7hdAFZv8IY1r
         3Lww==
X-Gm-Message-State: AGi0PuZQlxyXph9ANO5XlzMq+OFMfMLVDlFHaroKOMsV2sxBtFc0d6y9
        sn/E52WNtRaPSeGLoDV7sfVBot7zAqzUTaxAQr680eKSnqWUrfZ4o/2U4FhiO1XLH+96FKpvPVL
        No7qN/5XT7Wi3
X-Received: by 2002:a7b:c642:: with SMTP id q2mr16619779wmk.41.1587820766823;
        Sat, 25 Apr 2020 06:19:26 -0700 (PDT)
X-Google-Smtp-Source: APiQypJXwcuRtpHk4zpLOp3jvcBubezJLdQBQ3UTl4H8+n7Honsj/U58BP1wRrfhHGtK6n55KUIt+Q==
X-Received: by 2002:a7b:c642:: with SMTP id q2mr16619766wmk.41.1587820766602;
        Sat, 25 Apr 2020 06:19:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d0a0:f143:e9e4:2926? ([2001:b07:6468:f312:d0a0:f143:e9e4:2926])
        by smtp.gmail.com with ESMTPSA id a125sm7153885wme.3.2020.04.25.06.19.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Apr 2020 06:19:26 -0700 (PDT)
Subject: Re: [PATCH v11 5/9] KVM: X86: Refresh CPUID once guest XSS MSR
 changes
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmattson@google.com, yu.c.zhang@linux.intel.com
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-6-weijiang.yang@intel.com>
 <20200423173450.GJ17824@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6e1076a5-edbf-e8fe-dd99-fbb92f3cc8d0@redhat.com>
Date:   Sat, 25 Apr 2020 15:19:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200423173450.GJ17824@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/20 19:34, Sean Christopherson wrote:
>>  	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
>>  		supported_xss = 0;
>> +	else
>> +		supported_xss = host_xss & KVM_SUPPORTED_XSS;
> Silly nit: I'd prefer to invert the check, e.g.
> 
> 	if (kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> 		supported_xss = host_xss & KVM_SUPPORTED_XSS;
> 	else
> 		supported_xss = 0;
> 

Also a nit: Linux coding style should be

	supported_xss = 0;
	if (kvm_cpu_cap_has(X86_FEATURE_XSAVES))
		supported_xss = host_xss & KVM_SUPPORTED_XSS;

Paolo

