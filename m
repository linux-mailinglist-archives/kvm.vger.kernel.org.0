Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECCA1AC539
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 16:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442011AbgDPOOU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 10:14:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30480 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732651AbgDPOOM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 10:14:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587046450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZwfafyNJV35A9XzjzoUpov1lD8f8Bo7599mF7Sou/xg=;
        b=b788A+6CBsTaipsg5c8XHbAKkmc0lN1IDfg/8c9otW/KthOc1FX69n5zqh1ynrq7sjfehc
        L8iFnNYHtRmlAXplilDBrHFnaQ9HgzqBjVFNLopBbJrhK/1Jm1e7AgXXMi5Pi4jNsu5xEg
        9oxEEoPzK9V5FvhM2OAvVwHQgcjhh8s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-idB3zs8VMOmdavDkQQ7Txg-1; Thu, 16 Apr 2020 10:14:08 -0400
X-MC-Unique: idB3zs8VMOmdavDkQQ7Txg-1
Received: by mail-wm1-f69.google.com with SMTP id n127so1239398wme.4
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 07:14:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZwfafyNJV35A9XzjzoUpov1lD8f8Bo7599mF7Sou/xg=;
        b=p1e0QbVxexbPM7mBbyp7pWkOXSsnWgWQ5DxxzQjYde/wT3QR4xlW5L2IxWTDgWak65
         78MX6TZLJcYz7eufHo+jAwsCTNBZHwacRn6x+ajTe4Yl/8PFCoNwjyk9noH12xEsNwnC
         80sOdzGh9RB6w3AUfgYKjDxXVE778LwNeifSN1MROoVRyQNvRemmBkayZICPkPEI187F
         XXEvk2KE0FbuLAnVUKL67QnYganX6VQWvnPh2/aq7rP88A+7v0tZC9FcjzwEuTRmoXE6
         iSrs1qN2JgZdklMslCX9TFxC3M9J/YsNBVHh69U7WmQ+zj2tZD+P+pXjiDmDjGYRJZ6f
         I8Jw==
X-Gm-Message-State: AGi0PuZfQh0DMrP38iZumw1QJYtadaxHSUgm5B2ajtu5PEdt6f+BZJwe
        X3ISa7RP5i7n5FeJXSzv3Hc6PS8CorJ0AtRU489ISIxxPlwJYsq+TAK5ajFjBOPjKnHpZXwaYaQ
        j/Y+dkVAUawAD
X-Received: by 2002:a7b:c941:: with SMTP id i1mr4761804wml.132.1587046446917;
        Thu, 16 Apr 2020 07:14:06 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ5Hb6SR8Fvh2FXPLrhFm6KxJHb0F0gaOopm4Hzze+cRXgN3/biIfKsxemtqaSiStUFpWNlMQ==
X-Received: by 2002:a7b:c941:: with SMTP id i1mr4761786wml.132.1587046446638;
        Thu, 16 Apr 2020 07:14:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:399d:3ef7:647c:b12d? ([2001:b07:6468:f312:399d:3ef7:647c:b12d])
        by smtp.gmail.com with ESMTPSA id l16sm12705971wrp.91.2020.04.16.07.14.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 07:14:06 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Disable Intel PT before VM-entry
To:     "Kang, Luwei" <luwei.kang@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>
References: <1584503298-18731-1-git-send-email-luwei.kang@intel.com>
 <20200318154826.GC24357@linux.intel.com>
 <82D7661F83C1A047AF7DC287873BF1E1738A9724@SHSMSX104.ccr.corp.intel.com>
 <20200330172152.GE24988@linux.intel.com>
 <82D7661F83C1A047AF7DC287873BF1E1738B1A1C@SHSMSX104.ccr.corp.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <21fa3505-8198-5f32-9dfd-3c9d9cc5ef7e@redhat.com>
Date:   Thu, 16 Apr 2020 16:14:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <82D7661F83C1A047AF7DC287873BF1E1738B1A1C@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/03/20 05:29, Kang, Luwei wrote:
>> Ah, right.  What about enhancing intel_pt_handle_vmx() and 'struct
>> pt' to replace vmx_on with a field that incorporates the KVM mode?
>
> Some history is the host perf didn't fully agree with introducing
> HOST_GUEST mode for PT in KVM.

I don't think this is accurate.  IIRC the maintainers wanted packets in 
the host-side trace to signal where the trace was interrupted.  In the 
end we solved the issue by 1) dropping host-only mode since it can be 
achieved in userspace 2) making host-guest an opt in feature.

I think it would make sense to rename vmx_on into vmx_state and make it an

enum pt_vmx_state {
	PT_VMX_OFF,
	PT_VMX_ON_DISABLED,
	PT_VMX_ON_SYSTEM,
	PT_VMX_ON_HOST_GUEST
};

KVM would pass the enum to intel_pt_handle_vmx (one of PT_VMX_OFF, 
PT_VMX_ON_SYSTEM, PT_VMX_ON_HOST_GUEST).  Inside intel_pt_handle_vmx you 
can do

	if (pt_pmu.vmx) {
		WRITE_ONCE(pt->vmx_state, state);
		return;
	}

	local_irq_save(flags);
	WRITE_ONCE(pt->vmx_state,
		   state == PT_VMX_OFF ? PT_VMX_OFF : PT_VMX_ON_DISABLED);
	...

and in pt_config_start:

	...
	vmx = READ_ONCE(pt->vmx_start);
	if (vmx == PT_VMX_ON_DISABLED)
                perf_aux_output_flag(&pt->handle, PERF_AUX_FLAG_PARTIAL);
        else if (vmx == PT_VMX_ON_SYSTEM ||
		 !(current->flags & PF_VCPU))
                wrmsrl(MSR_IA32_RTIT_CTL, ctl);
	...

Thanks,

Paolo

