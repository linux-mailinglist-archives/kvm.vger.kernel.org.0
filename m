Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE327474224
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 13:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhLNMMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 07:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhLNMMN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 07:12:13 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA56C061574
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 04:12:12 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id r11so61530353edd.9
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 04:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=m0jxrDVuFbZ68aeDsqItDKkmE2tlaLscDQoPeb6sn38=;
        b=pjiN839rK1Y2lCe19LEznw0Jl+MMNm3vEtD37VGtM5VbHKG7egpbzIv+LX1Tgo4qU/
         Arj1Zjaf8SX8le51OS1NbVQP2KahCQxY5DoD9fzWVbhpOCirQx7mYZ/RX2VY0qfHRouc
         Io+SJAlbf0OVooBGm3WhpzAD+SqP9nXlg+5RvfaRIxojS25CNzhGotmRrWe2MdqsgvCI
         JZIKTlAVqToepYl5oV8BLxcB+GJ8mvIGJG2MVeiMzU5dK/zcW5yQ3gvRV6gwy2cz322M
         BzopreL07OqyMFPiJJ+aaTgDHxV1MaDi9Trb1RI1UTvtQsN2No6ArxzwJMvjyD6448Ju
         tpXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=m0jxrDVuFbZ68aeDsqItDKkmE2tlaLscDQoPeb6sn38=;
        b=zXMvHU6Jj8lgJWpAzmsenSkbLSyCvN9jHBE4S1aCdvymIqQ5aP7DCKa0+x40dotGFl
         SlbJway7sCIOmKIgONtOibo4LK/+DCji7dQXR3ljYAD0Pagnjisu/d/L23hwgOaTLffU
         3tJRgKN4rFVAam+zaC1HKsBHV0TEnuJi7+vt/kPdETnpuLnwaR7ScSUYFfeXsFh09USW
         EZ4ghMQG+bjbRdCiiparv4MTvwRuOQrbRx0DU71RP/KE0V1kRwYS4zD2mOjKKKJQ2i1F
         2bJ2UdcLmWXq/gYWg3gPC/nzVAOWVUgJeelvLEP+u2h4jeQHWuRTY5gTvxLjbLlPTIrP
         Hgyw==
X-Gm-Message-State: AOAM533YRnTt6bjuIKsH535Q5hI0GRN2bgM7q9P9KgBnqoZ/GxjxA++v
        iUOzc/3nSA1ZiU1+1lERHMH99Tnv/QQ=
X-Google-Smtp-Source: ABdhPJxJuso+qRYKTYlUWQkyuJHM7CQQBSEJpr5GTIN8skhOX15gz+3mPG6uoTfco/yk9ke5EKLj9A==
X-Received: by 2002:a05:6402:1a58:: with SMTP id bf24mr7336204edb.16.1639483930754;
        Tue, 14 Dec 2021 04:12:10 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id d14sm7547507edu.57.2021.12.14.04.12.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 04:12:10 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <ae2c74cb-5b84-e27c-a7ab-66b092663556@redhat.com>
Date:   Tue, 14 Dec 2021 13:12:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH] x86: Remove invalid clwb test code
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>, kvm@vger.kernel.org
Cc:     chao.gao@intel.com, yuan.yao@intel.com
References: <20211201092619.60298-1-zhenzhong.duan@intel.com>
 <4fc2aa84-1748-397d-d468-ff8e48c65e47@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <4fc2aa84-1748-397d-d468-ff8e48c65e47@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/3/21 06:54, Xiaoyao Li wrote:
> + Paolo explicitly
> 
> On 12/1/2021 5:26 PM, Zhenzhong Duan wrote:
>> When X86_FEATURE_WAITPKG(CPUID.7.0:ECX.WAITPKG[bit 5]) supported,
>> ".byte 0x66, 0x0f, 0xae, 0xf0" sequence no longer represents clwb
>> instruction with invalid operand but tpause instruction with %eax
>> as input register.
>>
>> Execute tpause with invalid input triggers #GP with below customed
>> qemu command line:
>>
>> qemu -kernel x86/memory.flat -overcommit cpu-pm=on ...
>>
>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
>> ---
>>   x86/memory.c | 7 -------
>>   1 file changed, 7 deletions(-)
>>
>> diff --git a/x86/memory.c b/x86/memory.c
>> index 8f61020..351e7c0 100644
>> --- a/x86/memory.c
>> +++ b/x86/memory.c
>> @@ -67,13 +67,6 @@ int main(int ac, char **av)
>>       asm volatile(".byte 0x66, 0x0f, 0xae, 0x33" : : "b" (&target));
>>       report(ud == expected, "clwb (%s)", expected ? "ABSENT" : 
>> "present");
>> -    ud = 0;
>> -    /* clwb requires a memory operand, the following is NOT a valid
>> -     * CLWB instruction (modrm == 0xF0).
>> -     */
>> -    asm volatile(".byte 0x66, 0x0f, 0xae, 0xf0");
>> -    report(ud, "invalid clwb");
>> -
>>       expected = !this_cpu_has(X86_FEATURE_PCOMMIT); /* PCOMMIT */
>>       ud = 0;
>>       /* pcommit: */
>>
> 

Applied, thanks.

Paolo
