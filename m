Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97AD918FDDD
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 20:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgCWTmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 15:42:33 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:45400 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbgCWTmc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 15:42:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584992551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=smmSxlhEOR5qNhn11L1ve0W1BbFnYt0RhPTc7f7mic0=;
        b=i2ZRIgCfppNiAOGVsnkTGA7D+iQBu85SsCnVN80e/SsYLfmGR14J24Mv4bB5at9Br6NR3Y
        nnYFN5lj3rc7G4SPgCdyIR14eXd44mxCCSLARr9OfuhsNlv4xFrg5xW1w21BnjZmP1sSXe
        qVux2s1HpUz1o+DYfTvwredTH60KC6U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-5jTiuHSYOPuBqINWs0NKiQ-1; Mon, 23 Mar 2020 15:42:30 -0400
X-MC-Unique: 5jTiuHSYOPuBqINWs0NKiQ-1
Received: by mail-wr1-f69.google.com with SMTP id h17so7882377wru.16
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 12:42:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=smmSxlhEOR5qNhn11L1ve0W1BbFnYt0RhPTc7f7mic0=;
        b=jrjlw/D6/z+QBA5yiA4lVT3zxQjhzP6Lbhu4Ev+widXQYhDaN0l0IZs5LyubDien3m
         RnyvSTtv4STIb3iyCYKhpwLFb+wtm65XGT9/v9kByndvujtOYl48oDr+OsFke2Fsd5Ep
         A2qBPjAf3ghOfnQmZiNUtryul9QsWhO847VE+v8/QCu+zZK8AntpbD1N/3Eh4APvlu+H
         aC5BwuSvavBF+2sXGRxF0UQ7k8jJBYeJnaKGEam1ubgvRHGu3knzX5XbKl+axpND1R6s
         39JQRUZ5Dr6hNZr3Hsl1L9ZdSJM2Syk94ImxeYfDxp7wVx/LGkiUj6ZbcLvezGi6B8CL
         F1Bg==
X-Gm-Message-State: ANhLgQ2henoK1GdtH76vgPMnEnwlaEAq9v2lhfNsf+9ffRLMwpdRdKRm
        qNBwARdx2YZESpxiDH8srSzXsulNhROp6TUpy9pec4widg/9yZqGzF8UBDNMdVb4wNcv0+aLOC+
        5GRCiB8lsFU0O
X-Received: by 2002:a5d:44d0:: with SMTP id z16mr9536738wrr.28.1584992548664;
        Mon, 23 Mar 2020 12:42:28 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtQtBDqi8UHm7eMe+WXYdgVpyqZ4rAOMGiQwUhT4b15bVIuSlqY9zZJBAt+/xHFll+hTH7sBQ==
X-Received: by 2002:a5d:44d0:: with SMTP id z16mr9536706wrr.28.1584992548365;
        Mon, 23 Mar 2020 12:42:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:24d8:ed40:c82a:8a01? ([2001:b07:6468:f312:24d8:ed40:c82a:8a01])
        by smtp.gmail.com with ESMTPSA id h26sm831009wmb.19.2020.03.23.12.42.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 12:42:27 -0700 (PDT)
Subject: Re: [PATCH 0/2] Fix errors when try to build kvm selftests on
To:     shuah <shuah@kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200315093425.33600-1-xiaoyao.li@intel.com>
 <7f7a2945-300d-d62c-e5f5-de55c2e3fd2f@redhat.com>
 <ed26428d-00bc-e90c-f2ee-ee7c0f874715@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d89b9433-7825-c204-a7b7-cce07d4ba7e7@redhat.com>
Date:   Mon, 23 Mar 2020 20:42:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <ed26428d-00bc-e90c-f2ee-ee7c0f874715@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/03/20 16:44, shuah wrote:
> On 3/18/20 7:13 AM, Paolo Bonzini wrote:
>> On 15/03/20 10:34, Xiaoyao Li wrote:
>>> I attempted to build KVM selftests on a specified dir, unfortunately
>>> neither    "make O=~/mydir TARGETS=kvm" in tools/testing/selftests, nor
>>> "make OUTPUT=~/mydir" in tools/testing/selftests/kvm work.
>>>
>>> This series aims to make both work.
>>>
>>> Xiaoyao Li (2):
>>>    kvm: selftests: Fix no directory error when OUTPUT specified
> 
> This definitely isn't thr right fix for this issue.
> 
>>>    selftests: export INSTALL_HDR_PATH if using "O" to specify output dir
> 
> Might be okay, but hard to find problems with the limited testing
> done just on the kvm test.
> 
>>>
>>>   tools/testing/selftests/Makefile     | 6 +++++-
>>>   tools/testing/selftests/kvm/Makefile | 3 ++-
>>>   2 files changed, 7 insertions(+), 2 deletions(-)
>>>
>>
>> Queued, thanks.
>>
>> Paolo
>>
>>
> Can you please drop these for your queue. I would like to make sure
> they work with other patches queued in kselftest next and would like
> these go through kselftest tree.
> 
> It will be easier to find regressions when tested with other patches
> to framework as opposed to limited testing on just the kvm test.

Sure, thanks.

Paolo

