Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D85A45E1DF
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 21:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350340AbhKYVBv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 16:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbhKYU7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 15:59:49 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E24AC0613FB;
        Thu, 25 Nov 2021 12:54:15 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d24so14235058wra.0;
        Thu, 25 Nov 2021 12:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gcUHvcOv/I7I60+yb6kAsH4XNlAdW3FNsBO8EOevoh4=;
        b=jpHPoQwaDBwPIyj5q0IRY0VElIL+sGsEKFqwJRRSHTL/twFKN9aGVPiwlVQv9SpiB0
         asbQQG/bKbilJEuB72iNJvFM9sFZlV9qSt+YyYG+WVrO1VR2h1PE2htT82mwQXxyUPF7
         Skz7jmQ5WvVY55ZptaSPkiDFHRZpomV6tMsU5Ex2efNs2/PizN0nxR1FXvKFdV31sxQF
         D1k500UGgyrIa+09Kj7FpcprzEmASHs1txGgF27TA/1OSRHXzYzgGxGwaHIOYgUYH0Vq
         PEoJSAOuIY1f21m3R57pZHFtqsHFA8/s1LmhEmysd9rX1YNgwV7E5ABHhrXHZ0n8KprV
         oUrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gcUHvcOv/I7I60+yb6kAsH4XNlAdW3FNsBO8EOevoh4=;
        b=ZdAxG0+gqSXqQJcfsPnnbH/UeEvbBWstmxkPhnqKYINK018Sz0J1oh9BHgRbHpefa3
         s2AC0QIPCrKyolCNnwWdv20iv+m2YLdNsDmu+mPZJ8w9kFaFy2D+VgWwF4uPjclmQSmp
         5aE1nkcDDvrZyU8f3AGR5KNQyT/as3aAk1Nna96Jcsf8sAV1bynKgxUNnx/erFlMK2aM
         XFljCLbHhu2WmH7cofDib2QBQRzXry8Zu/yGEJrxMrCYMGs/fcvT7U3CzL8AZrMb3Yxt
         ZydGkaQbJV471FmV7Co5mLlMaamirPEkwDr5B1I5vI/3ShNNgFw5WN4fdfivU4L0kjNy
         ZA0A==
X-Gm-Message-State: AOAM533msdJsqMdCt2qFy0jrcZCkWxBhwrrt85/bx5NBzv0pgDLZQpMC
        LydzeCf9/5801mMMbY5Elc0=
X-Google-Smtp-Source: ABdhPJxZvWCYx3MdH+01yNqpOEmNHcKCwvDwwio1FOPPtYcr2uqrtsz6B3A13pJPI58OHGORIF/XLQ==
X-Received: by 2002:adf:e747:: with SMTP id c7mr10060003wrn.38.1637873653083;
        Thu, 25 Nov 2021 12:54:13 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id p12sm4770961wrr.10.2021.11.25.12.54.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 12:54:12 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <21e8d65c-62bd-b410-1260-1ff4b0e0c251@redhat.com>
Date:   Thu, 25 Nov 2021 21:54:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH v3 26/59] KVM: x86: Introduce vm_teardown() hook in
 kvm_arch_vm_destroy()
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>, isaku.yamahata@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <1fa2d0db387a99352d44247728c5b8ae5f5cab4d.1637799475.git.isaku.yamahata@intel.com>
 <87a6hsj9wd.ffs@tglx>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87a6hsj9wd.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/25/21 20:46, Thomas Gleixner wrote:
> On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
>> Add a second kvm_x86_ops hook in kvm_arch_vm_destroy() to support TDX's
>> destruction path, which needs to first put the VM into a teardown state,
>> then free per-vCPU resource, and finally free per-VM resources.
>>
>> Note, this knowingly creates a discrepancy in nomenclature for SVM as
>> svm_vm_teardown() invokes avic_vm_destroy() and sev_vm_destroy().
>> Moving the now-misnamed functions or renaming them is left to a future
>> patch so as not to introduce a functional change for SVM.
> That's just the wrong way around. Fixup SVM first and then add the TDX
> muck on top. Stop this 'left to a future patch' nonsense. I know for
> sure that those future patches never materialize.

Or just keep vm_destroy for the "early" destruction, and give a new name 
to the new hook.  It is used to give back the TDCS memory, so perhaps 
you can call it vm_free?

Paolo
