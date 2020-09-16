Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422F626C092
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 11:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgIPJaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 05:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgIPJaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 05:30:05 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174FBC06174A;
        Wed, 16 Sep 2020 02:30:05 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id kk9so1242500pjb.2;
        Wed, 16 Sep 2020 02:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Hvl1B1auC2/Md3/Ns69FoG4JWQf3oFK8zylbBJi7l0g=;
        b=hdhvtslzUYPMKHXkuRHLYtkrjgQT+hQLVFKAPU8BPmBvdj+BjUb5rTYDwqUwArVhEV
         A/CETvbBVJzpk9v7H9BzzMSUWU8belUllC7a4JwBPWF0vFkFMFC69P8jNVu1ye2V0Nyz
         tYezjrKiQf4wMkhAFei/D8tPHjVShQM9CLnMnYGlY3KsRenrX0KMeEMP6camDdcsrG1s
         grgCv6joFA4Zph3Z3lWIy2FS4wWYpd0PKv+V/yhzCgOyaIAxJvXjySqxWmmjdY+jK59M
         ExIWQoS7omzmSrTk4z9RPHs+5URdWGM+UmI0xOUAzu6BCmvOMiGrhElIkjTaJZDDU/Zu
         Y9Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hvl1B1auC2/Md3/Ns69FoG4JWQf3oFK8zylbBJi7l0g=;
        b=ZUZuo0LurKMFqGxgNQNsCwVZhL75ePUpvSad5vSgRW4UZNfuct3AmX8FCYPLQ5xVWR
         3bpgrwurSl842w01bN3WQ1P3B23xu9bFZhNntAHB5iwFJMSdJvK+eI6FnhiH5vVjPnND
         7va0xjsDrAVZQ7t2kJSIJ0td+unNbMINeSd9KZAdU8VTnyRcf7emPUQ94LJXZbbDiEpz
         eYXAuzA2CUaEKOFxfzoyYsCJZ6z0m/6HKj0btW7G/X0ShZVE4CSavJ/zaiENK8ggRnnF
         UsPfo8I+GmEA9iU/akOSP5EgivrI1sPQOjNPSOpAYT54Mz/D38uheMEWc8v68je2SUPu
         Li+Q==
X-Gm-Message-State: AOAM53048wmVL8uWC9ptopSGLWn+FOeJYFEp10+10I8z+E3ii2lgqBPH
        ZMOudr/S0J4sTEShE9xbVw==
X-Google-Smtp-Source: ABdhPJzXoGBH6LSvD07Rw00wUEjDsrs8OqQndfG3xrdW6l4FA6TYc3kuhtSpfSZ9CTRtRlSPvvBpdA==
X-Received: by 2002:a17:90a:e517:: with SMTP id t23mr3016287pjy.25.1600248604598;
        Wed, 16 Sep 2020 02:30:04 -0700 (PDT)
Received: from [127.0.0.1] ([203.205.141.53])
        by smtp.gmail.com with ESMTPSA id x5sm13675378pgf.65.2020.09.16.02.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2020 02:30:03 -0700 (PDT)
Subject: Re: [PATCH] Revert "KVM: Check the allocation of pv cpu mask"
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Haiwei Li <lihaiwei@tencent.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
References: <20200916090342.748452-1-vkuznets@redhat.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Message-ID: <6c2204ad-590b-025d-f728-0e6e67bf24ba@gmail.com>
Date:   Wed, 16 Sep 2020 17:29:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200916090342.748452-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/9/16 17:03, Vitaly Kuznetsov wrote:
> The commit 0f990222108d ("KVM: Check the allocation of pv cpu mask") we
> have in 5.9-rc5 has two issue:
> 1) Compilation fails for !CONFIG_SMP, see:
>     https://bugzilla.kernel.org/show_bug.cgi?id=209285
> 
> 2) This commit completely disables PV TLB flush, see
>     https://lore.kernel.org/kvm/87y2lrnnyf.fsf@vitty.brq.redhat.com/
> 
> The allocation problem is likely a theoretical one, if we don't
> have memory that early in boot process we're likely doomed anyway.
> Let's solve it properly later.

Hi, i have sent a patchset to fix this commit.

https://lore.kernel.org/kvm/20200914091148.95654-1-lihaiwei.kernel@gmail.com/T/#m6c27184012ee5438e5d91c09b1ba1b6a3ee30ee4

What do you think?

Haiwei Li
