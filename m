Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C869476EE0
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 11:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236073AbhLPK2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 05:28:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbhLPK2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 05:28:05 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38029C061574;
        Thu, 16 Dec 2021 02:28:05 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id j140-20020a1c2392000000b003399ae48f58so1343505wmj.5;
        Thu, 16 Dec 2021 02:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FK38YlXZPYTzi67SuiB406zgZx74Iz6CpHREFW4oIiA=;
        b=FqUvmFwVXBS/P30wjcrcef2Q17+MrePDFMnLdj38npHtJu/GF5u2YIRmZgJrxLH2Ms
         Cp+MC6ZMmyQHwjfq7Q+HVCvQgAdAwOlTKbPt6s131E3vDlc2eGoQr9uJNc5Qf44rQJfj
         Y3QkGuD9OlMfn+3t9VIcnywMpqoseNsagZsZsn1zLHOL2QY3wsyw1fbkWsk35ihC7wwt
         NLElg+pgmxSxpDAJtsMbTHjBZXANoxuzFprF7Np/XW58GIGgfN4GeuvCBnjgvETG7trd
         nbRRaqT50f6RPnGcS3LAklut9gT4W5BDWH34wCE/sqlS05IVE1nggghqQKhl3yfjaOgN
         mHsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FK38YlXZPYTzi67SuiB406zgZx74Iz6CpHREFW4oIiA=;
        b=N8KfUiwpSLH/SAME/13bqZIe8ctz/E+BS8/6K77KRss5aqJ3FxK7s7Kts6i+KvctlE
         dbUwoYSJriqgrVGGcgTe6BFvdjfS5xn4RIh72bo9q82hXFlaA5lUJZtOwhkk5z1NvtSx
         KAQnQKCz4wa+tyZYX2WSWV8XBiUbKQFq2drCrwbLU/69gdrfode+SvO/Rdf5VGYrxYKs
         X3I+yjPiPLVyM/FP8kJl2p0jX5/BdGkMuFfRxzMP03pdP/08qrjV3HgMP+uClnm990xc
         K5JaT6snWY3nyY8PnGKiWn2m2DFsXqohgMzAcB9pDQKvWg41c3PzBrRawBTg0D3janY9
         xaNA==
X-Gm-Message-State: AOAM5320RUYmwhduBk4OsMD09DdjUQIAaGRTJU72rfsh3Or9Z0UIrBNU
        xIMMt1Q1X9ESZ5dJ5tL67tg=
X-Google-Smtp-Source: ABdhPJwpVbUjKyGKwL3viQNaRu73tPpuI+99Xkw7RrgIXBSXTfQ7wmbY3AMlm5QdiBp1+ulkq/frQg==
X-Received: by 2002:a05:600c:a0a:: with SMTP id z10mr4314208wmp.126.1639650483792;
        Thu, 16 Dec 2021 02:28:03 -0800 (PST)
Received: from [10.32.176.104] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id u10sm5970847wrs.99.2021.12.16.02.28.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 02:28:03 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <39fbf289-0a17-f24f-e497-3ae30367ac3e@redhat.com>
Date:   Thu, 16 Dec 2021 11:28:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 16/19] kvm: x86: Introduce KVM_{G|S}ET_XSAVE2 ioctl
Content-Language: en-US
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc:     "seanjc@google.com" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-17-yang.zhong@intel.com>
 <d16aab21-0f81-f758-a61e-5919f223be78@redhat.com>
 <26ea7039-3186-c23f-daba-d039bb8d6f48@redhat.com>
 <86d3c3a5d61649079800a2038370365b@intel.com>
 <bdda79b5-79e4-22fd-9af8-ec6e87a412ab@redhat.com>
 <3ec6019a551249d6994063e56a448625@intel.com>
 <ba78d142-6a97-99dd-9d00-465f7d6aa712@redhat.com>
 <0c2dae4264ae4d3b87d023879c51833c@intel.com>
 <cf329949-b81c-3e8c-0f38-4a28de22c456@redhat.com>
 <d6828340c5a64da88caf90bd283b62c9@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <d6828340c5a64da88caf90bd283b62c9@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/21 09:25, Wang, Wei W wrote:
>> It's still easier to return the full size of the buffer from 
>> KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2).  It makes the userspace code
>> a bit easier.
> 
> OK. For the "full size" returned to userspace, would you prefer to
> directly use the value retrieved from guest CPUID(0xd), or get it
> from guest_fpu (i.e. fpstate->user_size)? (retrieved from CPUID will
> be the max size and should work fine as well)

It is okay to reflect only the bits that were enabled in prctl, but 
please document it in api.rst as well.

Paolo
