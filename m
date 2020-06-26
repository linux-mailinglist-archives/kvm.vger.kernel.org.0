Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC0020ACBF
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 09:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgFZHFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 03:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgFZHFY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 03:05:24 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3068AC08C5C1
        for <kvm@vger.kernel.org>; Fri, 26 Jun 2020 00:05:24 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id l17so7823938wmj.0
        for <kvm@vger.kernel.org>; Fri, 26 Jun 2020 00:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:from:to:cc:references:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ed8U9AwGW0CzzyP4TPcyZPt8dyiZRz+wWbbwYhaT2kE=;
        b=XbRSyYjwp1a2pLOLy+VkJdmvrpuYB5IRIvOjNiyUzcZ4v2rUKKNHRAJNzL1Y4wy9QA
         sgXu7pXpK6ubzhwMBDpRo5ApSw4aKN3K9ttPwuRmJ3Pcu7pk8DgSuDo8lIUqWRDBp4+U
         wJ9pnjGtcylnRfCH/IL4PNpmnwHMrw6K+vvRO1FGSeK2KkK9eSUacmLIrAlSDVK+k3uz
         FYEDVpdk0u7nYJQmkqm2vllPRrmRO/ob5W/em886ThOhJAvyPrHChZRU1zncN8VLTM61
         fhdUDh3QtjZt1+Bmq4OMwG8BXCvrynogW352xCrQZieFhybwgwn6U1iAimCjt29vYWhz
         HrWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ed8U9AwGW0CzzyP4TPcyZPt8dyiZRz+wWbbwYhaT2kE=;
        b=ZnjzJrHMd7inOfsyY1HsjjZTACsKVqVKIEZaOOe3miExAXFs/jZhQb0drsBOy98dz7
         o3kU5eUZYqckcB/F3sUvJtt15Nlo8Hr4juB6+a7hHYRvaEFx+iN2YhGUeDOfNBe5ebOc
         1o5gI7Gw8ZVpHPOwbDrFobQvzYMl/WQGcmW66FSRTi47R7b1tUcOF36OY+07dv6rwTRz
         IOrHaMNyBnWtVXQzIGgB8ZyVenjQ2r73lmabG2C0W7cKwkoN7PdEeN0LbcDNskHfJbpm
         Xh84px02LcAhut0yu7o86UoUo6QbWBio+oE3qSmBkSDnwY2KIIkBMk28JCBpI5YCg97F
         vu4g==
X-Gm-Message-State: AOAM531rKqIylCtVFuxktWMAp3A5cphIAx4jDFRt6h6T3RMqgUORlqDk
        uJB4sdQlRefq9kIAhxZ6pro=
X-Google-Smtp-Source: ABdhPJwXEXk6JS8EBpC17a5393hxrBZSUmx0OzKHdEgZr+YV783OzELcsrY8GG7oogz6akZUBcOC/Q==
X-Received: by 2002:a7b:cb51:: with SMTP id v17mr1957523wmj.17.1593155122923;
        Fri, 26 Jun 2020 00:05:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91d0:a5f0:9f34:4d80? ([2001:b07:6468:f312:91d0:a5f0:9f34:4d80])
        by smtp.googlemail.com with ESMTPSA id l190sm15621861wml.12.2020.06.26.00.05.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2020 00:05:22 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] x86: move IDT away from address 0
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm <kvm@vger.kernel.org>, mcondotta@redhat.com,
        Thomas Huth <thuth@redhat.com>
References: <20200624165455.19266-1-pbonzini@redhat.com>
 <8926010E-3AC0-4707-B1E2-A8DF576660F9@gmail.com>
 <ded0805e-15a4-5af8-0edd-10f9c9cf57d7@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
 uUHgL9dKIfvpm+rNXRn9wAwGjk0X/A==
Message-ID: <1b981258-6b03-a120-622f-8e597570ed53@redhat.com>
Date:   Fri, 26 Jun 2020 09:05:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <ded0805e-15a4-5af8-0edd-10f9c9cf57d7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/20 21:18, Paolo Bonzini wrote:
> On 25/06/20 20:59, Nadav Amit wrote:
>> I think that there is a hidden assumption about the IDT location in
>> realmode’s test_int(), which this would break:
>>
>> static void test_int(void)
>> {
>>         init_inregs(NULL);
>>
>>         boot_idt[11] = 0x1000; /* Store a pointer to address 0x1000 in IDT entry 0x11 */
>>         *(u8 *)(0x1000) = 0xcf; /* 0x1000 contains an IRET instruction */
>>
>>         MK_INSN(int11, "int $0x11\n\t");
>>
>>         exec_in_big_real_mode(&insn_int11);
>>         report("int 1", 0, 1);
>> }
> 
> Uuuuuuuuuuuuuuuumph... you're right. :(  Will send a patch tomorrow.

Actually the IDTR is not reloaded by exec_in_big_real_mode, so this
(while a bit weird) works fine.

Paolo
