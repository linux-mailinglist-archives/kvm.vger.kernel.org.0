Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2813591C6
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 03:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhDIB6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 21:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhDIB6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 21:58:21 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF6FC061760;
        Thu,  8 Apr 2021 18:58:09 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id n2so6139554ejy.7;
        Thu, 08 Apr 2021 18:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K61jOSa+LKqRTwPuPI9a1IlNu4EbgF+ip5oLHXlETtQ=;
        b=eruGQ/it3GG5I44DAyAo6XJkaDa6Ut0gNHHDz4rTVZy5K7kl8WdvuKSF6gBN1tM4mr
         BXl+IIQ8qu1xgEZt7sjWxmFXXe0SBCOP7TowZOiKQ3eeIBslF/b9hXGVLHBY8lYBVEXG
         o1MstPgsv9tKAQxW7vbzf/rI7ZJuQjGbtKoUafDC30RVSx1o0r7+v9XwIn2fC3OxXXyd
         OoLnL4/MgESAfD6BUi1Y7l1fbwG3W/cILbrnQsiMK5E7AQNix0d8GUTrXIthzTr7uqAu
         Lb+cYUEEw20c3goNxL/C4Vck1djZ76Pp7aZqEkneg2pMTmy70rukfdmGQVR+sh5efWpu
         po9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K61jOSa+LKqRTwPuPI9a1IlNu4EbgF+ip5oLHXlETtQ=;
        b=fKVtGn6YXoe0Jk1hN1TGe5iXt+RksJpzlvC9Xg/0vL8CQ67oIeoWNggcPzVRLdh0Mc
         qxMERfkgizsKWZyGaSmWitNALf2hJ/SMMX6mab1+G1TlutDppA45Yqd3wsn1ysK7Wxnc
         vWfW5fKnKFZZO0pds8cmAK3c6YmI/QITuu6XiH+WmloGCPMFLTCjAkmni9aMKx8vBzC/
         R0K5Z4HbuYT3SkEqbrT5sXWBysPIl+UTsKkPKrIKUwkx6LNKc/6DSSxOjfb8F5mQre1y
         NYHY7p0HmCyPWfQpm/RvZuLP/BAMxadEn/JwE+tsT4usR83/fWJJs4q7RYqJt9QygkSb
         XO5w==
X-Gm-Message-State: AOAM5337Db3Dq2KgTwVwXL2M5kIjCCRg8VbseIZb13a4LF3Z47qFcp5t
        PaBJRfreu7UxtoaQhEmm1dnMdjGb+Rv7DFD0Ba8xqmLE5w==
X-Google-Smtp-Source: ABdhPJxxQSQQWf6otGt9fgkLhV4fj15oMxyGLbp4P+heUpT6lWeYldfoQQQU9Mmznw6VptDllKiPpkIVJ5F0XYJkxUo=
X-Received: by 2002:a17:906:8293:: with SMTP id h19mr3443534ejx.217.1617933488270;
 Thu, 08 Apr 2021 18:58:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210408075436.13829-1-lihaiwei.kernel@gmail.com> <YG8pwERmjxYQoquP@google.com>
In-Reply-To: <YG8pwERmjxYQoquP@google.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Date:   Fri, 9 Apr 2021 09:57:57 +0800
Message-ID: <CAB5KdObQ=HN2YBZCB2iV5U_uuOuwtgrX=CcApstwKwHeaRqy8w@mail.gmail.com>
Subject: Re: [PATCH] KVM: vmx: add mismatched size in vmcs_check32
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 9, 2021 at 12:05 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Apr 08, 2021, lihaiwei.kernel@gmail.com wrote:
> > From: Haiwei Li <lihaiwei@tencent.com>
> >
> > vmcs_check32 misses the check for 64-bit and 64-bit high.
>
> Can you clarify in the changelog that, while it is architecturally legal to
> access 64-bit and 64-bit high fields with a 32-bit read/write in 32-bit mode,
> KVM should never do partial accesses to VMCS fields.  And/or note that the
> 32-bit accesses are done in vmcs_{read,write}64() when necessary?  Hmm, maybe:
>
>   Add compile-time assertions in vmcs_check32() to disallow accesses to
>   64-bit and 64-bit high fields via vmcs_{read,write}32().  Upper level
>   KVM code should never do partial accesses to VMCS fields.  KVM handles
>   the split accesses automatically in vmcs_{read,write}64() when running
>   as a 32-bit kernel.

Good suggestion, thanks. I will send v2.
