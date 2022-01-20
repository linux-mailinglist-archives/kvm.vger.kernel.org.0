Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8A5494D8F
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 13:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbiATMBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 07:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbiATMBR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 07:01:17 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF26BC061574;
        Thu, 20 Jan 2022 04:01:16 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id s9so3154788plg.7;
        Thu, 20 Jan 2022 04:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=x6xQErWbh59MRMGPWppnidXCP7KCrvl8zZIZXHQJ4v8=;
        b=SYRqlyczXDZgRbvOhDXZ6p6W5Bq4QT8tnHBlDL7/cwOc2GxCv3oCCFm6Am5gyaFRp3
         1/ZXS3gXVA/l8KUABtLdctctQTXQwMnlzRgz8fiS2zWxcozcOjiuD9cX9MHaZ7j6pEfE
         8n1//0+ry1vThYz5hiS4/lWK55BgFneKNdy7cKuQI2gxgpL/ZEjpL5/+cxVNX78xKZBK
         S7q30h7zYxfwez+upBdXtQxKgDLkuUDJTJjgVw8yP5M4sNsFBbOiRy4vEdqPc9i6cuHo
         DcO6rKTS4YIk9c8aI2nl7UPSgU7vAzsWPlRNSyf49R3IgybPV5urcAv444CLBQrYGvng
         1BIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=x6xQErWbh59MRMGPWppnidXCP7KCrvl8zZIZXHQJ4v8=;
        b=NmL8zTk/O753IqWqBZWeSQWkTSFJwK0dUBcvyTibX3O/ZZ8rT7I1oRKXdXvO//zvNc
         Ydc/DsxMbSedBueH4/8jzdMlB96XCh5uEzds9PCF88O4aUBp9JhgDXH9GppWzVnXTRrT
         b3QJdmn8WbJqYkPOuGGkqHMHzYfdWOp0gYb3jTsZOur1uOU9FVi4hR/X2AN5cr5jeOws
         4Gtd5LLzhpoCVh8hnbo1PdW2WHQLaJ181I3Li1uhanMrnsDw7Lg8iRxBynWl7ytTgTkm
         L4HEiEhBD5WULxXCK+QUu1v7Z5i6ec35XHlDjlsqL43HaYlfo8YF4v1PeC4oyC6fEbPF
         vB/A==
X-Gm-Message-State: AOAM530FcZ3YblFSj9BVrcWwiP0J/xWh34osG6lEy+gDYlvO2aTQoyME
        pLtQZx8GzrJRSgawMM2wWLs=
X-Google-Smtp-Source: ABdhPJy3BOoGH7B5EYj2r1GYJWj5Hj3gMIYEYcM3MkqwCBJQ/gEl8hVhsNSvCV/vgQk+m/JEw7hYqg==
X-Received: by 2002:a17:902:b206:b0:149:3b5d:2b8b with SMTP id t6-20020a170902b20600b001493b5d2b8bmr37236865plr.162.1642680076472;
        Thu, 20 Jan 2022 04:01:16 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b22sm3176413pfl.121.2022.01.20.04.01.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 04:01:16 -0800 (PST)
Message-ID: <fc6b44e8-350b-7f66-132f-a02dfe7b97a8@gmail.com>
Date:   Thu, 20 Jan 2022 20:01:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [DROP][PATCH] KVM: x86/xcr0: Don't make XFEATURE_MASK_SSE a
 mandatory bit setting
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220119070427.33801-1-likexu@tencent.com>
 <1b6a8366-d1ab-536f-9bad-8c2b7a822fcb@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <1b6a8366-d1ab-536f-9bad-8c2b7a822fcb@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/1/2022 11:23 pm, Dave Hansen wrote:
> On 1/18/22 11:04 PM, Like Xu wrote:
>> Remove the XFEATURE_MASK_SSE bit as part of the XFEATURE_MASK_EXTEND
>> and opportunistically, move it into the context of its unique user KVM.
> 
> Is this a problem for xstate_required_size()?  The rules for the CPUID
> sub-functions <=1 are different than those for >1.  Most importantly,
> 'eax' doesn't enumerate the size of the feature for the XFEATURE_SSE
> sub-leaf.

Indeed.

> 
> I think XFEATURE_MASK_EXTEND was being used to avoid that oddity:

It seems that the cpuid.0xd.0.ebx size update for the SSE+AVX state needs
to be triggered by setting bit 2 which is quite odd:

  XCR0 = 001B, ebx=00000240
  XCR0 = 011B, ebx=00000240
  XCR0 = 111B, ebx=00000340

Thank you and sorry for the noise.

> 
>> u32 xstate_required_size(u64 xstate_bv, bool compacted)
>> {
>>          int feature_bit = 0;
>>          u32 ret = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
>>
>>          xstate_bv &= XFEATURE_MASK_EXTEND;
>>          while (xstate_bv) {
>>                  if (xstate_bv & 0x1) {
>>                          u32 eax, ebx, ecx, edx, offset;
>>                          cpuid_count(0xD, feature_bit, &eax, &ebx, &ecx, &edx);
>>                          /* ECX[1]: 64B alignment in compacted form */
>>                          if (compacted)
>>                                  offset = (ecx & 0x2) ? ALIGN(ret, 64) : ret;
>>                          else
>>                                  offset = ebx;
>>                          ret = max(ret, offset + eax);
>>                  }
>>
>>                  xstate_bv >>= 1;
>>                  feature_bit++;
>>          }
>>
>>          return ret;
>> }
