Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88CD41ADFA7
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 16:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgDQOTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 10:19:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44790 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725272AbgDQOTn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 10:19:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587133181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DAdieQ2sXt/NeBUDGNTNawrWk821Y/E983QoU7SMcFs=;
        b=cZQ8nzD5W2Ql6SNeT1/iu0VOpe+O9Dqt4bfN5mTDK8z2m3IEUm0lCH0MXWsasvzBZ9t/+b
        GViUIDSY+zkNo6JHcg10FPcaPG8wj2+NEXVDD9UBInobTrj4jZ84cC2KeY2+xHXRLga3JX
        RZ4FNpjWAHV7BkU6RxKUqm0JBY8DwSw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-vGpsQ0tpMTKVm92W1FbZBQ-1; Fri, 17 Apr 2020 10:19:40 -0400
X-MC-Unique: vGpsQ0tpMTKVm92W1FbZBQ-1
Received: by mail-ej1-f69.google.com with SMTP id c22so1096174ejm.2
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 07:19:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DAdieQ2sXt/NeBUDGNTNawrWk821Y/E983QoU7SMcFs=;
        b=oudJmosGLLZ4Op6BtVFQeKUirF/VsszgbnaFhl9DNEzPJKB0K8eaSx7Jg1VfFgKeOL
         zFvxogTdTbnALP/3lIoHnN47+wBGMAi39PxHFYT4+RbNVC6R3059CiKBbYo1ZDsPN3sj
         k6ULibVuWzZyJHN9kE2ztiT+doyq0GABTNZ3Q6mZ3MFYMJHr8la9oce/OwDtN6qfz8rN
         4bEP2AfTTy9L9exEuOasgNKJqLFa4mxRfMPA1+w9e4hqXhojdBKEum6Ita379RKRXlGa
         V0FvrUiLAvycGlxBGuZP+ftWsj7v2jMKZg2waRP1HFf+wbJdqPcRlO53w+w6gUpW9/Ck
         DG/g==
X-Gm-Message-State: AGi0PuYevQBxgRT8UN8s8DhovJjOQW2aiOTV6TlI1g82lEMd/oA9p6ym
        JdS3bc0NLHBB0++3T4CtH1WZxCwPJ0Zg91xHVg/MR0EZSPA0Oe0URkp+8ntd3Oi52BHZWQ9qCLA
        omQ8qCELjM8ME
X-Received: by 2002:a50:9dc9:: with SMTP id l9mr2672153edk.39.1587133178658;
        Fri, 17 Apr 2020 07:19:38 -0700 (PDT)
X-Google-Smtp-Source: APiQypLSNonCa7KPxn9j8grfL9YTWfd/4UpcKCI2QJ3npNEUbmnpJku3CrPOj8XqHh7la5HhfBBELQ==
X-Received: by 2002:a50:9dc9:: with SMTP id l9mr2672131edk.39.1587133178375;
        Fri, 17 Apr 2020 07:19:38 -0700 (PDT)
Received: from [192.168.1.39] (116.red-83-42-57.dynamicip.rima-tde.net. [83.42.57.116])
        by smtp.gmail.com with ESMTPSA id l91sm2911342ede.64.2020.04.17.07.19.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 07:19:37 -0700 (PDT)
Subject: Re: [PATCH v3 03/19] target/arm: Restrict DC-CVAP instruction to TCG
 accel
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-4-philmd@redhat.com>
 <f570579b-da9c-e89a-3430-08e82d9052c1@linaro.org>
 <CAFEAcA8K-njh=TyjS_4deD4wTjhqnc=t6SQB1DbKgWWS5rixSQ@mail.gmail.com>
 <5d9606c9-f812-f629-e03f-d72ddbce05ee@redhat.com>
 <CAFEAcA-4+Jcfxc5dax8exV+kBJKYEnWZ2d-V1A6sm6uJafZdPg@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <16bd73d1-ec39-7da6-77c3-a18eea5992e0@redhat.com>
Date:   Fri, 17 Apr 2020 16:19:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA-4+Jcfxc5dax8exV+kBJKYEnWZ2d-V1A6sm6uJafZdPg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/17/20 3:54 PM, Peter Maydell wrote:
> On Fri, 17 Apr 2020 at 14:49, Philippe Mathieu-Daudé <philmd@redhat.com> wrote:
>>
>> On 3/16/20 9:11 PM, Peter Maydell wrote:
>>> On Mon, 16 Mar 2020 at 19:36, Richard Henderson
>>> <richard.henderson@linaro.org> wrote:
>>>> I'm not 100% sure how the system regs function under kvm.
>>>>
>>>> If they are not used at all, then we should avoid them all en masse an not
>>>> piecemeal like this.
>>>>
>>>> If they are used for something, then we should keep them registered and change
>>>> the writefn like so:
>>>>
>>>> #ifdef CONFIG_TCG
>>>>       /* existing stuff */
>>>> #else
>>>>       /* Handled by hardware accelerator. */
>>>>       g_assert_not_reached();
>>>> #endif
>>
>> I ended with that patch because dccvap_writefn() calls probe_read()
>> which is an inlined call to probe_access(), which itself is only defined
>> when using TCG. So with KVM either linking fails or I get:
>>
>> target/arm/helper.c: In function ‘dccvap_writefn’:
>> target/arm/helper.c:6898:13: error: implicit declaration of function
>> ‘probe_read’;
>>        haddr = probe_read(env, vaddr, dline_size, mem_idx, GETPC());
>>                ^~~~~~~~~~
> 
> IN this particular case, DC CVAP is really a system insn rather
> than a 'register'; our register struct for it is marked up as
> ARM_CP_NO_RAW, which means we'll effectively ignore it when
> running KVM (it will not be migrated, have its state synced
> against the kernel, or be visible in gdb). If dccvap_writefn()
> ever gets called somehow that's a bug, so having it end up
> with an assert is the right thing.
> 
>> I'll use your suggestion which works for me:
> 
> Your suggested patch isn't quite the same as RTH's suggestion,
> because it puts the assert inside a stub probe_read()
> implementation rather than having the ifdef at the level
> of the writefn body. I have no opinion on whether one or
> the other of these is preferable.

I'll let Richard modify the writefn() bodies if required, as he 
understand what they do :)

Btw since we have this rule:

obj-$(call lnot,$(CONFIG_TCG))  += tcg-stub.o

I'll use the following patch which is less intrusive:

-- >8 --
index 677191a69c..e4bbf997aa 100644
--- a/accel/stubs/tcg-stub.c
+++ b/accel/stubs/tcg-stub.c
@@ -22,3 +22,10 @@ void tb_flush(CPUState *cpu)
  void tlb_set_dirty(CPUState *cpu, target_ulong vaddr)
  {
  }
+
+void *probe_access(CPUArchState *env, target_ulong addr, int size,
+                   MMUAccessType access_type, int mmu_idx, uintptr_t 
retaddr)
+{
+     /* Handled by hardware accelerator. */
+     g_assert_not_reached();
+}
---

> 
> thanks
> -- PMM
> 

