Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4EE7A0542
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 15:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238794AbjINNQC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 09:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238337AbjINNQB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 09:16:01 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667B31BEC
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 06:15:57 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-31f853f2f3aso1392046f8f.0
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 06:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1694697356; x=1695302156; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to
         :content-language:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=QLvdeLJFaVHjTuDoy38D6XQS7QdszFti2O5CeB4RYlA=;
        b=H79lOWAX5BPBFOdAn1Ls5n/4U5LrplNHBcu1rIc7moNmBpym0HelwhDGyK3yWrCkK6
         YAnVKR5qigfI+orFzxqnSf+VxYJ/OAgSD2+fPBosbnB3Dg6ODx4xFcF8Y5OfLIazP0q+
         +JJvOLGq1e7SwSoTNzHpPwoBD7HAV3nLiof+E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694697356; x=1695302156;
        h=content-transfer-encoding:in-reply-to:references:cc:to
         :content-language:subject:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QLvdeLJFaVHjTuDoy38D6XQS7QdszFti2O5CeB4RYlA=;
        b=C/GaKFN8n0Hzc4T7O7DNaUpL0mP6C+FH6cycBUuWSf+8fQIiObw7LjvF32Qu7V2joc
         4rFyWZN1eTuFUJGnKgdaK2MaOwOTfmYOzg99VQqbMkADnJGiQxAwJNd+LkDn/+IATF8n
         fTmtf+nxODSde+ei4CFYWjqDH7WxfBuI7PaCQHLqyw61ywdxoTr65DKwIoEEakSf+t9H
         BrxQIS+S33hhMrcLNDkkNF8ehOqNWMgeX0ARQ6r5x3usKq2RizuDzXEPua3dRg53b8Cc
         AQsA/WNKjxg2QjeXM9xXqdPrgL2fcI3MKA8Tbfe5ndYchb9mvaChw19MJWtK40wc787W
         paBw==
X-Gm-Message-State: AOJu0YxGKJGDSUx8Ani9UjDnzwfKsbdufOrJ4kfgXnZu3loiJvkOwXdc
        4N8ZsUlaxOLFMAxouYbho2w/Kw==
X-Google-Smtp-Source: AGHT+IEIu7wWXsXFgmC0TpcZPq12QhcsescNI+urHKtYHceqhxoChsC2ACdOD0NH7oyI9K+8uKKgUg==
X-Received: by 2002:a05:6000:4013:b0:319:735f:92c5 with SMTP id cp19-20020a056000401300b00319735f92c5mr1634592wrb.32.1694697355769;
        Thu, 14 Sep 2023 06:15:55 -0700 (PDT)
Received: from [10.80.67.28] (default-46-102-197-194.interdsl.co.uk. [46.102.197.194])
        by smtp.gmail.com with ESMTPSA id r10-20020adfdc8a000000b0031aeca90e1fsm1775995wrj.70.2023.09.14.06.15.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 06:15:55 -0700 (PDT)
Message-ID: <7d907488-d626-0801-3d4b-af42d00a5537@citrix.com>
Date:   Thu, 14 Sep 2023 14:15:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
From:   andrew.cooper3@citrix.com
Subject: Re: [PATCH v10 08/38] x86/cpufeatures: Add the cpu feature bit for
 FRED
Content-Language: en-GB
To:     Jan Beulich <jbeulich@suse.com>, Juergen Gross <jgross@suse.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, jiangshanlai@gmail.com,
        Xin Li <xin3.li@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-9-xin3.li@intel.com>
 <d98a362d-d806-4458-9473-be5bea254db7@suse.com>
 <77ca8680-02e2-cdaa-a919-61058e2d5245@suse.com>
In-Reply-To: <77ca8680-02e2-cdaa-a919-61058e2d5245@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/09/2023 7:09 am, Jan Beulich wrote:
> On 14.09.2023 08:03, Juergen Gross wrote:
>> On 14.09.23 06:47, Xin Li wrote:
>>> From: "H. Peter Anvin (Intel)" <hpa@zytor.com>
>>>
>>> Any FRED CPU will always have the following features as its baseline:
>>>    1) LKGS, load attributes of the GS segment but the base address into
>>>       the IA32_KERNEL_GS_BASE MSR instead of the GS segment’s descriptor
>>>       cache.
>>>    2) WRMSRNS, non-serializing WRMSR for faster MSR writes.
>>>
>>> Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
>>> Tested-by: Shan Kang <shan.kang@intel.com>
>>> Signed-off-by: Xin Li <xin3.li@intel.com>
>> In order to avoid having to add paravirt support for FRED I think
>> xen_init_capabilities() should gain:
>>
>> +    setup_clear_cpu_cap(X86_FEATURE_FRED);
> I don't view it as very likely that Xen would expose FRED to PV guests
> (Andrew?), at which point such a precaution may not be necessary.

PV guests are never going to see FRED (or LKGS for that matter) because
it advertises too much stuff which simply traps because the kernel is in
CPL3.

That said, the 64bit PV ABI is a whole lot closer to FRED than it is to
IDT delivery.  (Almost as if we decided 15 years ago that giving the PV
guest kernel a good stack and GSbase was the right thing to do...)

In some copious free time, I think we ought to provide a
minorly-paravirt FRED to PV guests because there are still some
improvements available as low hanging fruit.

My plan was to have a PV hypervisor leaf advertising paravirt versions
of hardware features, so a guest could see "I don't have architectural
FRED, but I do have paravirt-FRED which is as similar as we can
reasonably make it".  The same goes for a whole bunch of other features.

~Andrew
