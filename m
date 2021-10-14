Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2461242E2E1
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 22:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhJNUw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 16:52:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23357 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230525AbhJNUwz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 16:52:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634244650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sypR1zkCMni3m2sdFQ3BSQIDoKFbj8FkIME4KbCvGjw=;
        b=Lbb7o2HzS0ccFdG0tIWW6o6pHki3clrSzkzi3kNpyucVJE3FssQhwce2PDsyMz3zg0GL0v
        HncDS0fE56tDKZE3cJU1hQjv+uPwij+3RMRsOSR0eOncooeCnnaYhfRYAfk9W1g5AHcpYp
        zzE1qNKYXtcokZfRohYt3sOF2xjC2+E=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203--P4znZ1YP56UOMWlO7-Q2g-1; Thu, 14 Oct 2021 16:50:49 -0400
X-MC-Unique: -P4znZ1YP56UOMWlO7-Q2g-1
Received: by mail-ed1-f69.google.com with SMTP id c8-20020a50d648000000b003daa53c7518so6236837edj.21
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 13:50:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sypR1zkCMni3m2sdFQ3BSQIDoKFbj8FkIME4KbCvGjw=;
        b=SgKKNPnFl7sHJuUBMbl8NUfNcY39JEjOsA5Tjr3UjXP5RXZp4479Ie/aF06vpiZzHm
         kv6wEajGDdnLByaMK4tWyNEawb5ob5A0AREXqLPUrrdgf3H41pgYt1JhIR75NsvBua75
         EWWA/73R5rfTb7n34aWIfhCF5UdgLvkIiIpXEY9BNGSvH9xFsv77VD730wz8TRZpb6E9
         gG707lCSCxkuMmNIM8LzCiIeYF7ukjUYO/XZqDhN6gz4N4khNmjgtIC2Xk17Wa03s8WU
         CNCzHJPIztOkCFM/uzdkdyL9lWPP46jfLLWTP+LzHgTJBOwEZb+Sak1im93bAdpV8oE3
         IifA==
X-Gm-Message-State: AOAM530ox0dXRnT3JpUbNPppQnOv+VurqjEqrCVsQosw1NbXdmceZ+0e
        2V/kLyDJ/Z1kfzjpt26XwywPZMA6A8LzY872mYFF/pFUYtBHX2dV5dIvbP5ciduTYCzlcXpebWv
        BwkJqEqvmIloS
X-Received: by 2002:a17:906:16d0:: with SMTP id t16mr1604025ejd.199.1634244648002;
        Thu, 14 Oct 2021 13:50:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJsui/zLztmaCtq7PZZAnYLvjtuLTIY7DyTbjU6/j2AfstfTpweChWvh8P8EnNk983+ht2hw==
X-Received: by 2002:a17:906:16d0:: with SMTP id t16mr1603992ejd.199.1634244647742;
        Thu, 14 Oct 2021 13:50:47 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id s24sm3044871edy.38.2021.10.14.13.50.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 13:50:47 -0700 (PDT)
Message-ID: <fb1da4d3-9e3e-4604-2f30-30292f9d13aa@redhat.com>
Date:   Thu, 14 Oct 2021 22:50:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [BUG] [5.15] Compilation error in arch/x86/kvm/mmu/spte.h with
 clang-14
Content-Language: en-US
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Jim Mattson <jmattson@google.com>, torvic9@mailbox.org,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>
References: <1446878298.170497.1633338512925@office.mailbox.org>
 <b6abc5a3-39ea-b463-9df5-f50bdcb16d08@redhat.com>
 <936688112.157288.1633339838738@office.mailbox.org>
 <c4773ecc-053f-9bc6-03af-5039397a4531@redhat.com>
 <CAKwvOd=rrM4fGdGMkD5+kdA49a6K+JcUiR4K2-go=MMt++ukPA@mail.gmail.com>
 <CALMp9eRzadC50n=d=NFm7osVgKr+=UG7r2cWV2nOCfoPN41vvQ@mail.gmail.com>
 <YWht7v/1RuAiHIvC@archlinux-ax161> <YWh3iBoitI9UNmqV@google.com>
 <CAKwvOdkC7ydAWs+nB3cxEOrbb7uEjiyBWg1nOOBtKqaCh3zhBg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAKwvOdkC7ydAWs+nB3cxEOrbb7uEjiyBWg1nOOBtKqaCh3zhBg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/21 21:06, Nick Desaulniers wrote:
>> If we want to fix this, my vote is for casting to an int and updating the comment
> 
> At the least, I think bitwise operations should only be performed on
> unsigned types.

This is not a bitwise operation, it's a non-short-circuiting boolean 
operation.  I'll apply Jim's suggestion.

Paolo

