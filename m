Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6AD33E2DEE
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 17:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243362AbhHFPvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 11:51:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20588 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238640AbhHFPvW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Aug 2021 11:51:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628265065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+MvzS92Uk60oNAzw+Z3d407dSFOjXozPlgK3Ui3EuhY=;
        b=SRaw/YZvlGzVq9AnNY5qKTj+UvohuR2BOGecVwrRBt+Cl6f20+zsuVEU1S/BzgitCFWR8r
        I+1/a4V7OGvzQeCpke1vlcFVM4kdZx0+mSXosNCwiuqVUIJlr9tVfOPHVPmst7RBM43WGg
        V8zkyONvuHnOkEYvpuurqi1zNUZNTrc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-pctNZIfnPua-l14sBhc8hw-1; Fri, 06 Aug 2021 11:51:04 -0400
X-MC-Unique: pctNZIfnPua-l14sBhc8hw-1
Received: by mail-ed1-f70.google.com with SMTP id de5-20020a0564023085b02903bb92fd182eso5181267edb.8
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 08:51:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+MvzS92Uk60oNAzw+Z3d407dSFOjXozPlgK3Ui3EuhY=;
        b=c0WI6EKq+8tJDcVDLlbANt0okVJHHdLTGaIsFYUjgmW+djWioCIEbCR//VcNTRBvKO
         XYE0RljJVSKaOWZljhUNmAmf10TIw86X+WQiR7jIBfjY/HYQRU592RyRz/fWpvIvpsNs
         4kZSKoAeibX5ikRfiqZV4X10WjTteTmdHiV7GRFjeLnMCHPHbjMC1f9/334vYOntRivz
         IuoUX9r4ppBm9Nv3+JzwXeEtU49UdwJxIS6tDuOnK13PDgthosr9QgjeIfDFJQWINAUI
         ShzwWjVQ8Y8WRjcs2e7+ORoa8WoE5/W3X9RTqyuG6UUNopI2HcgyDMQyYctjDzpZfWTI
         gcjQ==
X-Gm-Message-State: AOAM533CsyjWNpTuQm9GW9l8UgRXHGBw1/AoNX3DJmrkZXe6z973fybo
        Oz/FWMS2Sb2Fb/3YI8pf7C6UnB1NRFTObZ4D0jsgqnpUWSPQAmFWYuMxUaRcg9YFPV6XDF41hzq
        2qf8od6xloFPV
X-Received: by 2002:a17:906:3b87:: with SMTP id u7mr10704611ejf.66.1628265063274;
        Fri, 06 Aug 2021 08:51:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAe7/Ac/Nrk5QJgOh1300wanbnDOg/CO6BneIJR56E9sgbBIU8cyOWTJf37lCWXFCHY+PAtw==
X-Received: by 2002:a17:906:3b87:: with SMTP id u7mr10704593ejf.66.1628265063117;
        Fri, 06 Aug 2021 08:51:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id hc19sm2735104ejc.0.2021.08.06.08.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 08:51:01 -0700 (PDT)
Subject: Re: [PATCH v3 2/6] KVM: VMX: Extend BUILD_CONTROLS_SHADOW macro to
 support 64-bit variation
To:     Sean Christopherson <seanjc@google.com>,
        Zeng Guang <guang.zeng@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
References: <20210805151317.19054-1-guang.zeng@intel.com>
 <20210805151317.19054-3-guang.zeng@intel.com> <YQxnGIT7XLQvPkrz@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a984cf7e-fe3e-98bd-744f-9d0ff3759e01@redhat.com>
Date:   Fri, 6 Aug 2021 17:51:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YQxnGIT7XLQvPkrz@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/08/21 00:32, Sean Christopherson wrote:
>> -BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS)
>> -BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS)
>> -BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL)
>> -BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL)
>> -BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL)
>> +BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS, 32)
>> +BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS, 32)
>> +BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL, 32)
>> +BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL, 32)
>> +BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL, 32)
>> +BUILD_CONTROLS_SHADOW(tertiary_exec, TERTIARY_VM_EXEC_CONTROL, 64)
> 
> This fails to compile because all the TERTIARY collateral is in a later patch.
> 
> I think I'd also prefer hiding the 32/64 param via more macros, e.g.
> 
> #define __BUILD_CONTROLS_SHADOW(lname, uname, bits)				\

No, please don't. :)  Also because the 64 bit version is used only once.

Agreed on keeping everything here except for TERTIARY_VM_EXEC_CONTROL, 
and moving that line to patch 3.

Paolo

