Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740E3333854
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 10:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbhCJJJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 04:09:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35876 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232622AbhCJJJC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Mar 2021 04:09:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615367341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BmockwskQjMF5QAoMpBw7lnx9hxakWy3Uk40dCq8ECk=;
        b=U1lyzCNowXrGphX46uwpzj+PVcshjmU5KyF3DPj4OpCtMkZ0XF+mSzCX0mPc3yxfBSQjfn
        8TKI5MXZGUSqqwyijxyDtW8MtvPSkliZ0KAVaLbRuKgLVbPDETqXZDtFLPWodpqDNgY6Xn
        HRLZn/NvAnWXS+IZZcC9gQFNDtnFUg0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-cvmE-TzOMb-0th8leQk6Mg-1; Wed, 10 Mar 2021 04:09:00 -0500
X-MC-Unique: cvmE-TzOMb-0th8leQk6Mg-1
Received: by mail-wm1-f70.google.com with SMTP id n25so2389168wmk.1
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 01:08:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BmockwskQjMF5QAoMpBw7lnx9hxakWy3Uk40dCq8ECk=;
        b=s04ptGjwzZ4C/Un3VGjWf21TzjSNfRNGQviTxRmfAVaVUAtdK/9RsYrA2vJ/9RfOC2
         0hfjiQLJTT6WOJ5zmRyJ9thHpEALQqPKOf1KWYe3kB0qlt49hlmIwPWShp39NR6nqGd7
         lLxMqGHZKOPwlue7WYkrAtAIbucMFbu/3nZiXSpg1ZVfONJXTO6QI2cu8s92iW3zP4yA
         ENx/lUDMqEqWj7YUyNN/vvPI/h9PklMw7i2w0sUbLIzIWcx5C4vgcubY+2JpY7haE7Uv
         J4csXuGjL4mbKLKMe3IWLt6Gnn+4JlNaTZ2OWUiLX+qKUpb8LZiRgUebCNerU77qtCGo
         z7nw==
X-Gm-Message-State: AOAM531ykqrq8NPMZOrFwHHGS2ppkN8zRLVvhy7dDX5XHA/ZL5zWghgI
        dGS0W0yjqUlKNVhBjSx+xjAkEU55O424L9Gbr2bz9yNmRqZGscip3/j4sUxYwqp1cKTpduVhnRt
        4yU1GaucHjSrs
X-Received: by 2002:a05:600c:2d42:: with SMTP id a2mr2316385wmg.77.1615367338737;
        Wed, 10 Mar 2021 01:08:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzxQCipYAWNB0txuNi1jdo9rluJARSnskL/vwWkiJ/cIOzii1j16GaSPbgIx+cPvASjDYCFMQ==
X-Received: by 2002:a05:600c:2d42:: with SMTP id a2mr2316363wmg.77.1615367338594;
        Wed, 10 Mar 2021 01:08:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d29sm28275541wra.51.2021.03.10.01.08.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 01:08:57 -0800 (PST)
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
To:     Babu Moger <babu.moger@amd.com>, Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
 <83a96ca9-0810-6c07-2e45-5aa2da9b1ab0@redhat.com>
 <5df9b517-448f-d631-2222-6e78d6395ed9@amd.com>
 <CALMp9eRDSW66+XvbHVF4ohL7XhThoPoT0BrB0TcS0cgk=dkcBg@mail.gmail.com>
 <bb2315e3-1c24-c5ae-3947-27c5169a9d47@amd.com>
 <CALMp9eQBY50kZT6WdM-D2gmUgDZmCYTn+kxcxk8EQTg=SygLKA@mail.gmail.com>
 <21ee28c6-f693-e7c0-6d83-92daa9a46880@amd.com>
 <01cf2fd7-626e-c084-5a6a-1a53d111d9fa@amd.com>
 <84f42bad-9fb0-8a76-7f9b-580898b634b9@amd.com>
 <032386c6-4b4c-2d3f-0f6a-3d6350363b3c@amd.com>
 <CALMp9eTTBcdADUYizO-ADXUfkydVGqRm0CSQUO92UHNnfQ-qFw@mail.gmail.com>
 <0ebda5c6-097e-20bb-d695-f444761fbb79@amd.com>
 <0d8f6573-f7f6-d355-966a-9086a00ef56c@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1451b13e-c67f-8948-64ff-5c01cfb47ea7@redhat.com>
Date:   Wed, 10 Mar 2021 10:08:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <0d8f6573-f7f6-d355-966a-9086a00ef56c@amd.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/03/21 02:04, Babu Moger wrote:
> Debian kernel 4.10(tag 4.10~rc6-1~exp1) also works fine. It appears the
> problem is on Debian 4.9 kernel. I am not sure how to run git bisect on
> Debian kernel. Tried anyway. It is pointing to
> 
> 47811c66356d875e76a6ca637a9d384779a659bb is the first bad commit
> commit 47811c66356d875e76a6ca637a9d384779a659bb
> Author: Ben Hutchings<benh@debian.org>
> Date:   Mon Mar 8 01:17:32 2021 +0100
> 
>      Prepare to release linux (4.9.258-1).
> 
> It does not appear to be the right commit. I am out of ideas now.
> hanks

Have you tried bisecting the upstream stable kernels (from 4.9.0 to 
4.9.258)?

Paolo

