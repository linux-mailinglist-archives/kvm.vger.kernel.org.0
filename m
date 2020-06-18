Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459DB1FF2E0
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 15:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbgFRNWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 09:22:04 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:26061 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728049AbgFRNWC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Jun 2020 09:22:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592486521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IrGlZfeq1ulUHocq8AnjSLbU7gwN1WZOemxSJQXMZqQ=;
        b=AYaQXhfItH7hOFm2Ir5czSY0wRyt+ZhrbXmS6MLzyf1xv8BGtGJ9BlFcovLHs8uUuzl7oR
        DudXWG2tcmVMB24nDGl66sp038fnYNDeVS0YOklpzv+tEYIXOKcdBYD3h0mgxOesaiT3om
        DE2csAsOtSDBvrAu1OKy+Yr7FWcrBEw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-4bnbllHPOEGfPIHDMNDFKA-1; Thu, 18 Jun 2020 09:21:58 -0400
X-MC-Unique: 4bnbllHPOEGfPIHDMNDFKA-1
Received: by mail-wm1-f69.google.com with SMTP id q7so1785438wmj.9
        for <kvm@vger.kernel.org>; Thu, 18 Jun 2020 06:21:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IrGlZfeq1ulUHocq8AnjSLbU7gwN1WZOemxSJQXMZqQ=;
        b=R2RhzJF8T/ul+7xDv3ANIv9nlbUNVcSNJFWXp150+1Ab1xpLjBLNXXmWbO2KqlbO+d
         5UFL51qbcHLkoasiaiu2gC4aB/8jpNdExt3sYNJW4mIDscaZ4NLBk474oesGitZcDsFY
         HWuuQTqN8JPr+ZnHgF11SIweL8oibbntpIV+BJw+z/vKi9BENcBGGTGwJyI9oKbZHOpq
         aHJVd87utu59qoFfqssYUlQdwuQaOLkyyDAuXUyyvTv1MWQLMIXll3G/k/bnWbaJmq+f
         1ndSmunnkLBWiEhg4yw6I3ODoUOewcLWkt8KTzRaa4l9h3aNQ6RJFvG4eRZqCq23YPCI
         QWxw==
X-Gm-Message-State: AOAM531AQSG08dD8eNkE+2vJan7KFagkuIQL4vgawpZZG/xXqoNvAKOP
        oFoKpwRDVbQWLKPIbHmHgBp+6F1sL091ihu+JUzqAfQaEOGXU5Tldtv8cb02udUbNymtnuK5iXB
        2/+wrTlvA08Ix
X-Received: by 2002:a1c:2b86:: with SMTP id r128mr4262215wmr.13.1592486516885;
        Thu, 18 Jun 2020 06:21:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymxwdYQWvQbXE8ARnQo904uTYfAl6mm/1E4F5nzGGAimPob6Q2xh4UUsh6Qsvjdqh+1rgImA==
X-Received: by 2002:a1c:2b86:: with SMTP id r128mr4262202wmr.13.1592486516680;
        Thu, 18 Jun 2020 06:21:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e1d2:138e:4eff:42cb? ([2001:b07:6468:f312:e1d2:138e:4eff:42cb])
        by smtp.gmail.com with ESMTPSA id d9sm3490622wre.28.2020.06.18.06.21.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 06:21:56 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: SVM: emulate MSR_IA32_PERF_CAPABILITIES
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Like Xu <like.xu@linux.intel.com>, linux-kernel@vger.kernel.org
References: <20200618111328.429931-1-vkuznets@redhat.com>
 <adc8b307-4ec4-575f-ff94-c9b820189fb1@redhat.com>
 <87ftash6ui.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8e3b2eef-b4f1-01cc-e033-c1ece70bd7db@redhat.com>
Date:   Thu, 18 Jun 2020 15:21:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87ftash6ui.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/06/20 14:54, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
>> On 18/06/20 13:13, Vitaly Kuznetsov wrote:
>>> state_test/smm_test selftests are failing on AMD with:
>>> "Unexpected result from KVM_GET_MSRS, r: 51 (failed MSR was 0x345)"
>>>
>>> MSR_IA32_PERF_CAPABILITIES is an emulated MSR on Intel but it is not
>>> known to AMD code, emulate it there too (by returning 0 and allowing
>>> userspace to write 0). This way the code is better prepared to the
>>> eventual appearance of the feature in AMD hardware.
>>>
>>> Fixes: 27461da31089 ("KVM: x86/pmu: Support full width counting")
>>> Suggested-by: Jim Mattson <jmattson@google.com>
>>> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
>>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>> ---
>>>  arch/x86/kvm/svm/pmu.c | 29 ++++++++++++++++++++++++++++-
>>>  1 file changed, 28 insertions(+), 1 deletion(-)
>> This is okay and I'll apply it, but it would be even better to move the
>> whole handling of the MSR to common x86 code.
> I thought about that but intel_pmu_set_msr() looks at
> vmx_get_perf_capabilities(), we'll need to abstract this somehow.

Indeed, you could use kvm_get_msr_feature for that.

Paolo

