Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841E53EA509
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 15:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235463AbhHLNBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 09:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbhHLNBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 09:01:09 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48849C061765;
        Thu, 12 Aug 2021 06:00:44 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id w14so9338215pjh.5;
        Thu, 12 Aug 2021 06:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sAliowc/SjsE5X1vyZOKBiyoKHZ0mEXialFmSnCOX7I=;
        b=Tcu6LOX+ngK5SkTBAa3fCqk+Cldmn/JeN5h8Ltx1H/N9xlWl3AU2WpJUf2kXlQVEE1
         panHLnXO3m7KARxf1KqRDl1ndy0SfAiOrx0axifIgsHwkeH90V4uPuWWfcQ5h+9g+eKx
         Wiq+GiBxXRcsSt5XZ6hy+uyD4FGhqPgsDoSrTiGTiBVKCkCrF20ywovx8fGZE2U5wT+x
         KQ8KDlN90flrNzW9ZTUSFwFx9b7MeXoDlS4dpjijU9048rwlPzUAOR0CDXfTERGioSGJ
         hQ3ZrAS/+cPeUrWZ19dm8AtXgJKNO5ZVM+C6iZPejPJT0TjIIwmQtNT1PHFPCueQ1vss
         WOjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=sAliowc/SjsE5X1vyZOKBiyoKHZ0mEXialFmSnCOX7I=;
        b=I2lbBMDjrCLf1qPW3EuuYUZl6LDaJR1clFG0lyB7Ml0iDzhHVxVAzKeVhCQ6kNtNt5
         rPUQmO6x52SGYqxaTMZzUEfxjZxT32zkP8O9zlJGGThfgT4pmjX9D+S8MP8i07fJol/6
         uaPAat6jMCtsWTXaGBowdW98ZnOjcy1QKLlJE0oJy1bmRPEyc2AM6LdSGJPEI5jim/Cr
         Gz/vP/r+NTmtJshRuxWqzOEshrfiYJXEawjKe8ND4ZWNGJgQd6ePa+X5ZvtEq5yNLNXp
         OjS8aabt0gC281r1+n49IDYHva8fs61u7fdPpaOF42Fl44O3wztuxxzrDul0F+IX9gAH
         8CjA==
X-Gm-Message-State: AOAM5301w4f/nhmvjI5r5D+iivxmMR0rjjUF8Q9pYXVM79PnPDqCPfRL
        RDHopFuLITyoxTKphW6/Sm1mjb5yHGzXb7dZ
X-Google-Smtp-Source: ABdhPJyDzB5dfb1xonDXVwIn89hikTf2vT2gKP2IZ+NNEWVjeQXj5Z5JrOu2v8TpX7bvbh92r3/oSg==
X-Received: by 2002:a17:90a:2842:: with SMTP id p2mr16770327pjf.196.1628773243160;
        Thu, 12 Aug 2021 06:00:43 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x19sm3467919pfo.40.2021.08.12.06.00.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 06:00:42 -0700 (PDT)
Subject: Re: [PATCH 5/5] KVM: x86: Clean up redundant pr_fmt(fmt) macro
 definition for svm
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210809093410.59304-1-likexu@tencent.com>
 <20210809093410.59304-6-likexu@tencent.com>
 <ef84c98d-9b33-052b-0747-2d2d327b1dfb@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Message-ID: <ccda637a-faba-1a8c-036b-22d834036c7a@gmail.com>
Date:   Thu, 12 Aug 2021 21:00:33 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <ef84c98d-9b33-052b-0747-2d2d327b1dfb@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/8/2021 1:48 am, Paolo Bonzini wrote:
> On 09/08/21 11:34, Like Xu wrote:
>> +#undef pr_fmt
>> +#define pr_fmt(fmt) "SVM: " fmt
>> +
>>   #include <linux/kvm_types.h>
> 
> Why do you need the #undef?
> 
> Paolo
> 
>
I've seen most of the redefinition code for 'pr_fmt' like this,
for example:

- 3bfaf95cb1fe81872df884956c704469e68a5bee
- d157aa0fb241646e8818f699653ed983e6581b11
