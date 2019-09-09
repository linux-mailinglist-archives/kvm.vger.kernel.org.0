Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03F7CADC86
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 17:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbfIIP4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 11:56:35 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40817 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729209AbfIIP4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 11:56:35 -0400
Received: by mail-io1-f68.google.com with SMTP id h144so29829476iof.7
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2019 08:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eCPj62l3A6REMyrmpXQABp9kXimmH8PW2Uyv0frDZaE=;
        b=XJB9fVvDLdRPArIUafpoI/zRxhZk1aErpNQxSes8qdjTudUdpV3MBne703FGW+C42S
         a03RgkI+96nFkeyN5ZIanyNTpjBN1pJZsaQvMEIoLLrwnElGs671lvwztDrTxn3HjNzK
         MM5dd+KzK1VY5LCBD2xhPKXLuJ/wzWW0rSG8X4bRmzbyHh0jZ/q8WNeoqfPj27ViU3Xn
         Gx3GVqiJd3ZqMGv0PAbnzQn+dG/seM4Ehs7PZd/g6LdzGABUQCweusx3Y1jm7XbiwvJ0
         qU2gYy6mCy1XNY8QvpFHidJJxdcnpttnYk1zkVFLLQL77Wseto1pEfmcPCL1Kh1xgeGg
         SCew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eCPj62l3A6REMyrmpXQABp9kXimmH8PW2Uyv0frDZaE=;
        b=kUNlvooUXgw2SeHTsM+gtXE5Efrzxz2Kk+rl11nHzN/yx29JoGYV23aEDvxfvapufL
         NvCxlM5FOcDH/UmDRJBsmaY5mvQ65JqnsEs+2DoI5Z5+wdSFn8PRcCeaq7uQN57KV+YV
         rd8YIlHl1CM9idQBBTDR7CqcOKbaUELwoe8lUK4SuhvoAoJjL4acRsyAq6X4Vt+7o6XQ
         5gryWLUBxImMlAl0OWqTI434dFaOQk88qjGacKj0DqD+IsYNc+z9PMGN8ZIpnk6lwhAX
         /eQNugJshLDbbk+CRnfPPJd3EEyobRoXyGMXKVbZ88LpJourbmQ+/RR7MjRjj2tk//TI
         Lu3w==
X-Gm-Message-State: APjAAAXtennECm4lpuP44YOmdM3yGz4PgofwX0DSHIA+m9JK4YAftKpz
        DAnV9NOnHdut/zAuZjgK3rRkbLkdaqvtoGUgCNTtNg==
X-Google-Smtp-Source: APXvYqwCX+twuMgs6KR0dK/OCLs2NRQnBfy6rVNDWAapzXt69+FdQ3PX1WRt+DO4rYft4QskSKza3QB64YqKJYROH8M=
X-Received: by 2002:a5e:d616:: with SMTP id w22mr14398618iom.118.1568044594249;
 Mon, 09 Sep 2019 08:56:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
 <20190829205635.20189-3-krish.sadhukhan@oracle.com> <CALMp9eSekWEvvgwhMXWOtRZG1saQDOaKr+_4AacuM9JtH5guww@mail.gmail.com>
 <a4882749-a5cc-f8cd-4641-dd61314e6312@oracle.com> <CALMp9eTBPRT+Re9rZzmutAiy62qSMQRfMrnyiYkNHkCKDy-KPQ@mail.gmail.com>
 <CALMp9eRWSvg22JPUKOssOHwOq=uXn6GumXP1-LB2ZiYbd0N6bQ@mail.gmail.com>
 <e229bea2-acb2-e268-6281-d8e467c3282e@oracle.com> <CALMp9eTObQkBrKpN-e=ejD8E5w3WpbcNkXt2gJ46xboYwR+b7Q@mail.gmail.com>
 <e8a4477c-b3a9-b4e4-1283-99bdaf7aa29b@oracle.com> <CALMp9eTO_ChOHQ4paR1SgmxnpSGZrMjHTa2aUWHSCn0+tCGvAA@mail.gmail.com>
 <9eb99666-7af8-6a59-51ee-f5285d9a67f0@oracle.com>
In-Reply-To: <9eb99666-7af8-6a59-51ee-f5285d9a67f0@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 9 Sep 2019 08:56:23 -0700
Message-ID: <CALMp9eQ-eJEusJnhDuVzxnF6Fa4VHdzx+dw5fMmRSFSB5DUthg@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 8, 2019 at 9:11 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:

> It seems like a good solution. The only problem I see in this is that
> using the reserved bits is not guaranteed to work forever as the
> hardware vendors can decide to use them anytime.

Unlikely, but point taken.

> Instead, I was wondering whether we could set bits 31:0 in the first
> entry in the VM-entry MSR-load area of vmcs02 to a value of C0000100H.
> According to Intel SDM, this will cause VM-entry to fail:
>
>             "The value of bits 31:0 is either C0000100H (the
> IA32_FS_BASE MSR) or C0000101 (the IA32_GS_BASE MSR)."
>
> We can use bits 127:64 of that entry to indicate which MSR entry in the
> vmcs12 MSR-load area had an error and then we synthesize an exit
> qualification from that information.

That seems reasonable to me.
