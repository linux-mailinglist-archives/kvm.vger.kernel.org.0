Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F835BD0A5
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 19:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439523AbfIXR3w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 13:29:52 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33721 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439514AbfIXR3v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 13:29:51 -0400
Received: by mail-pg1-f195.google.com with SMTP id i30so1707443pgl.0
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 10:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Vjl8SvTYNlKul8rzGD5kO7/X+kQkW9944VYnSnHxu4g=;
        b=ciYESTmw7QLU/JOb7QocTQaPN3UPX9r3ZjCu9g3mwokREQGEU85813F4PrPbA0K5yl
         qRcJJ8gHUNH/O+0sNAKuLuFAeb0cIrZYLLllvzPK++p3KcVHRqTOyqrvv8h0/ZWn2jj6
         FBh7PCFcowPuowABLvmMT2g4L4cUyNTy2iMzOLm/XxZqkdRjbg//kAoEkoo5JGHklwRf
         fHF4eSu0LSG2ISBsvvJA5S2bh9tF5DtIqGJ5cblAwaT/u8QgVbsdqRRuLlM6bn8t9GhR
         SklkUcrOui+rhHP+1nJPvYPxmRq3UZxjRx2FdqoabfwIW8CvGD3H97rmrG/VEfrrHP5n
         k0JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Vjl8SvTYNlKul8rzGD5kO7/X+kQkW9944VYnSnHxu4g=;
        b=JFPlSv4HVYDFGfXZ7G7BaiXxvxacnOBywqbcV+sSbA/WOHdY5gEZ3guqB3E73LzYQ2
         jhjq/BJT5EfBeCS2u4LO+nlyPA8SVdTvk4rKb05Dcf6Wzg12/gqK8714GpHUuf6zddgH
         0rEWMqgzaezLVWXMClY2U+iUWKKLxD9tYfCTV/ZZawXyHzeivANlo6V9SKSbVmvzlQ61
         3HIGKlViCBRVsNxUQWq9YK8z4c6xcNvs0kBU7C6yYps2x7Zkp/2SalFdQajawDStVw7t
         /B3+aehO2dunvPG1Z20MQAZ/H9ofPMEM5l33PsoauPtyoEHtGAYUCf4zz3BIjRRDF6PE
         hWfQ==
X-Gm-Message-State: APjAAAUBq9CZYQp3DPqRiOP0SyM/3grN0FsvVQ7tMsj9ENJMctYSNl7B
        nvjbn+rN85g4nEzvKet3hZY=
X-Google-Smtp-Source: APXvYqyaYEM4FkSxE3jOQhMT+JJ4vaih1EAWKU8Vm7xVo3y+M9iuDDumur0GQbgBvBmkxjjSo6OX6w==
X-Received: by 2002:a17:90a:32c8:: with SMTP id l66mr1299539pjb.44.1569346190925;
        Tue, 24 Sep 2019 10:29:50 -0700 (PDT)
Received: from [10.33.115.159] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id u17sm457484pjn.7.2019.09.24.10.29.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 10:29:50 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH] kvm-unit-test: x86: Add RDPRU test
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CALMp9eQh445HEfw0rbUaJQhb7TeFszQX1KXe8YY-18FyMd6+tA@mail.gmail.com>
Date:   Tue, 24 Sep 2019 10:29:49 -0700
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>
Content-Transfer-Encoding: 7bit
Message-Id: <30499036-99CD-4008-A6CA-130DBC273062@gmail.com>
References: <20190919230225.37796-1-jmattson@google.com>
 <368a94f2-3614-a9ea-3f72-d53d36a81f68@oracle.com>
 <CALMp9eQh445HEfw0rbUaJQhb7TeFszQX1KXe8YY-18FyMd6+tA@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Sep 20, 2019, at 12:44 PM, Jim Mattson <jmattson@google.com> wrote:
> 
> On Fri, Sep 20, 2019 at 12:36 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>> On 9/19/19 4:02 PM, Jim Mattson wrote:
>>> Ensure that support for RDPRU is not enumerated in the guest's CPUID
>>> and that the RDPRU instruction raises #UD.
>> 
>> 
>> The AMD spec says,
>> 
>>         "When the CPL>0 with CR4.TSD=1, the RDPRUinstruction will
>> generate a #UD fault."
>> 
>> So we don't need to check the CR4.TSD value here ?
> 
> KVM should set CPUID Fn8000_0008_EBX[RDPRU] to 0.
> 
> However, I should modify the test so it passes (or skips) on hardware. :-)

Thanks for making this exception. Just wondering: have you or anyone else
used this functionality - of running tests on bare-metal?

I ask because it would also save me the trouble of checking (occasionally)
that nothing broke.

