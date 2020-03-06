Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C322117BA05
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 11:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgCFKP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 05:15:26 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57437 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726866AbgCFKP0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Mar 2020 05:15:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583489725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R8cCEdC5FaVv+MdnVESNIfOZjXxz+5prIcEo1XcPS0s=;
        b=KdkNycRPZR2tz20TZRQYUZNZx3hVaU8BpnyI78N1CaEjSZGSdpsDJyzA6LvZQWhBb12oaB
        G+L5tnhSODDSiaU6Aujjgbl864mCaNsZ2PdTwjd0ssc//QNe0XBshk2cTIUpB0mYgNPbou
        UqCo3SXtMe3p2cIUYhZQwNzLF70OPM4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-X2sA29-_NsSAg0nuIyle8w-1; Fri, 06 Mar 2020 05:15:24 -0500
X-MC-Unique: X2sA29-_NsSAg0nuIyle8w-1
Received: by mail-wr1-f71.google.com with SMTP id z16so791348wrm.15
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2020 02:15:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=R8cCEdC5FaVv+MdnVESNIfOZjXxz+5prIcEo1XcPS0s=;
        b=OboIJU2uGvAFtjyhIx/L2n97Z4Uv6Mbhi4mDJxW95nkF5cwnWLxvqrQyHIxhWt6un5
         paGR0HxfhjnO/vQxZCJytlfDrVaUUhbLO1bfyzceSxiHfqAQ/GxYtJxbjJnbCWwCzWBN
         yzlZQVGOwAuYnRkNP1BG4VQeKa7EZSY9SZ/y4PQLb9efKPTDUun9t/O1V05ib20lEmkV
         ePXnlw4zgny5BAMjGk3LPhgjYAUUx5WCXQfadxPt9jcE99Iayg5yW97H8PXIU4RW5/I3
         ncV5bPrLbl+BM5IWjyN9b1ze6XBT6G7LTFKlCcAFE/ANWfdOsueADsIvUqBY8K1jQoO0
         l8pw==
X-Gm-Message-State: ANhLgQ3+G8B+XBg358zsmeJKCmZ4kOfpV1FfJPsJqotKFWkzD+qMv4R2
        71S+TyqZz+4FGBvn60/R41Z1hSl7MQ3Tc4fnuVOXpHmcZkgMV+Yt1rMhlQWy9qLssLhtWWtWm2d
        pZ+sZZ5J9BAxK
X-Received: by 2002:adf:f58c:: with SMTP id f12mr3213688wro.22.1583489722135;
        Fri, 06 Mar 2020 02:15:22 -0800 (PST)
X-Google-Smtp-Source: ADFU+vu8zlAWdb1cgYZu04XUt1QbGIL0sJCkz9ENy7Jgx3MKegXXX1wp00ARy8EXOG7ML94pK8W+lw==
X-Received: by 2002:adf:f58c:: with SMTP id f12mr3213666wro.22.1583489721922;
        Fri, 06 Mar 2020 02:15:21 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id m11sm1461332wrn.92.2020.03.06.02.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 02:15:21 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        linmiaohe <linmiaohe@huawei.com>
Cc:     "rkrcmar\@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson\@intel.com" <sean.j.christopherson@intel.com>,
        "jmattson\@google.com" <jmattson@google.com>,
        "joro\@8bytes.org" <joro@8bytes.org>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "mingo\@redhat.com" <mingo@redhat.com>,
        "bp\@alien8.de" <bp@alien8.de>, "hpa\@zytor.com" <hpa@zytor.com>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86\@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] KVM: VMX: Use wrapper macro ~RMODE_GUEST_OWNED_EFLAGS_BITS directly
In-Reply-To: <2cde5e91-b357-81f9-9e39-fd5d99bb81fd@redhat.com>
References: <f1b01b4903564f2c8c267a3996e1ac29@huawei.com> <1e3f7ff0-0159-98e8-ba21-8806c3a14820@redhat.com> <87sgiles16.fsf@vitty.brq.redhat.com> <2cde5e91-b357-81f9-9e39-fd5d99bb81fd@redhat.com>
Date:   Fri, 06 Mar 2020 11:15:20 +0100
Message-ID: <87lfodeqmf.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 06/03/20 10:44, Vitaly Kuznetsov wrote:
>>>> Define a macro RMODE_HOST_OWNED_EFLAGS_BITS for (X86_EFLAGS_IOPL |
>>>> X86_EFLAGS_VM) as suggested by Vitaly seems a good way to fix this ?
>>>> Thanks.
>>> No, what if a host-owned flag was zero?  I'd just leave it as is.
>>>
>> I'm not saying my suggestion was a good idea but honestly I'm failing to
>> wrap my head around this. The suggested 'RMODE_HOST_OWNED_EFLAGS_BITS'
>> would just be a define for (X86_EFLAGS_IOPL | X86_EFLAGS_VM) so
>> technically the patch would just be nop, no?
>
> It would not be a nop for the reader.
>
> Something called RMODE_{GUEST,HOST}_OWNED_EFLAGS_BITS is a mask.  It
> tells you nothing about whether those bugs are 0 or 1.  It's just by
> chance that all three host-owned EFLAGS bits are 1 while in real mode.
> It wouldn't be the case if, for example, we ran the guest using vm86
> mode extensions (i.e. setting CR4.VME=1).  Then VIF would be host-owned,
> but it wouldn't necessarily be 1.

Got it, it's the name which is causing the confusion, we're using mask
as something different. Make sense, let's keep the code as-is then.

-- 
Vitaly

