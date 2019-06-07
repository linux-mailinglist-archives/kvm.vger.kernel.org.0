Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 813C138320
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 05:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfFGD11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 23:27:27 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:44654 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbfFGD11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 23:27:27 -0400
Received: by mail-yw1-f65.google.com with SMTP id m80so169185ywd.11
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 20:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Zyj15udNYieUJw2Ks35d0Z0UvTo9Y5pUANdgp/TRDBA=;
        b=ak+3D+HUjxzhO+gbm0TCBsG+zy2uKT7ujn9SgegKB6eo3Sadhf5Ea/f7soCcsKwFtY
         Jv4fV7IX3lJSuU2o7I3BQaSwIDfxhecOlgri2KDpvIpwT0C7w0zJgKe9ioBN7IsQHFNa
         DbTIELIFH7qz/xNTlI1PdWpf1zAkfJoRU+B64suVEtQrplcHf0y4DiSwZ8p1eRZ9SK7e
         9zOmtwVSMs4FpdtxzHvZMo/JPkt6MLRobmGWAyFJQzJ3augGcxTNv8cEaKZpEynkGZgr
         9iMfCBFiRpVGu7+mbbfR0XaWePYlF2Qt2TaK+fG5ljsURVJw/i+E2VlIPtT7otNiQMnY
         Wkwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Zyj15udNYieUJw2Ks35d0Z0UvTo9Y5pUANdgp/TRDBA=;
        b=iTHmcxnWZdUxLYHJQ5/hMfXvD/Ucv5ltFTHJWcwfYBvv1wzbY3iOzSo23HnxOrzwdS
         MY4CiepovcVwl4gUSPzSh1w6YFCnTeTQ6HLpHOLWs95kDUslbRWkOF4pNTdOUbUHeqzz
         NytYGpC+fiH96+o/JefKJk9zFqjVNOz5fhkQfNGB2JoOtzJFPa7wnxfOJQ3QId6nlQIf
         4KfEMgXgJ+XhJnyXGWWv5VMN1jIr4CfHbnCW+sf74m5XNiXkQtcDmm8uyElb24K1eyT6
         sf4h1tRMQjteIhKNeVN8yNsWVrB97NG8xjhGTwHMkVuBC6+xGWDMZfFQRT90q4W7t7XB
         9Uxg==
X-Gm-Message-State: APjAAAUGs+Hy6YcUsiD2cFQtLleR3dz5dMZLtcIrsxC6g2pZNsYk3r3q
        uV+2bUWMir66X2H56htjDKI=
X-Google-Smtp-Source: APXvYqzfeDPrupgVZ9c0+xfTPRyZVztf4nWVw44A5jPzXkO4RVZN0mjSGQRHfaoyFx+Nj8d3acFLVQ==
X-Received: by 2002:a81:834c:: with SMTP id t73mr5260819ywf.74.1559878045881;
        Thu, 06 Jun 2019 20:27:25 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id d21sm241377ywa.29.2019.06.06.20.27.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 20:27:25 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH] x86: Remove xfail in entry check in
 enter_guest_with_bad_controls()
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <bdc2e93d-ede8-4dab-981d-95e0a9a0558b@redhat.com>
Date:   Thu, 6 Jun 2019 20:27:23 -0700
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>
Content-Transfer-Encoding: 7bit
Message-Id: <14D1452D-35AC-41E8-8418-F94445935676@gmail.com>
References: <20190520095516.15916-1-nadav.amit@gmail.com>
 <bdc2e93d-ede8-4dab-981d-95e0a9a0558b@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 6, 2019, at 5:26 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> On 20/05/19 11:55, Nadav Amit wrote:
>> The test succeeds in failing entry. This is not an expected failure.
>> 
>> Cc: Marc Orr <marcorr@google.com>
>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>> ---
>> x86/vmx.c | 3 +--
>> 1 file changed, 1 insertion(+), 2 deletions(-)
>> 
>> diff --git a/x86/vmx.c b/x86/vmx.c
>> index f540e15..014bf50 100644
>> --- a/x86/vmx.c
>> +++ b/x86/vmx.c
>> @@ -1833,8 +1833,7 @@ void enter_guest_with_bad_controls(void)
>> 			"Called enter_guest() after guest returned.");
>> 
>> 	ok = vmx_enter_guest(&failure);
>> -	report_xfail("vmlaunch fails, as expected",
>> -		     true, ok);
>> +	report("vmlaunch fails, as expected", !ok);
>> 	report("failure occurred early", failure.early);
>> 	report("FLAGS set correctly",
>> 	       (failure.flags & VMX_ENTRY_FLAGS) == X86_EFLAGS_ZF);
> 
> Superseded by commit 74f7e9b ("vmx: introduce
> enter_guest_with_invalid_guest_state", 2019-04-18); thanks anyway!

I have some related fixes for recent commits, so I will be waiting for you
to push the updated kvm-unit-tests before I send the next batch of fixes.

