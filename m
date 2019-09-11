Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 604E2B000E
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 17:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfIKPaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 11:30:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42942 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727656AbfIKPaX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 11:30:23 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7B7294DB1F
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 15:30:23 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id m6so1395654wmf.2
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 08:30:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z7lafOYhtiFSVZBjFt7cCboQX2EFnKyrbRJdJUQ/9b4=;
        b=ZQSXgelBgPzvbH8XNFfOTJF6d0squstJHnUOvBRwlwgOqCrj0oGJtV7sNp54cwagLD
         Qa60vCC/gNAV6ZT5GpTyYU1Vv3A1b5P/eRt/g5iFpLKHgSY806baejtoaluuHjBRo//U
         MGSYem1bt6dBgBFzPmZNpSzlBmQIwH2dxsJbF4DxEXjGimfvESgU6nqp/1uMSAHD/3Hj
         ylQfACsaP+f/6v12JX077VW9JLlB+GlPopQMPWw01PUOd9OwHHiyzGtHe3taR/TgY+t7
         qvhK0d1I2FkgZa37QkbAoEsN6336GcIDGjxmuYx2mnb5JVNNkU7qB8MpynOWVXGEV5HI
         DjNg==
X-Gm-Message-State: APjAAAWWd8ju97FVr/6SiDBYapFVCQrUVwSOA2Bf8jkigYDrY2cT6Hs4
        NZOP3pqHIp6cfPhMu3yTbMTmXsCdkBtlhJr6pZVRKAf58C+2ZbQfmqqlm0bYzW3xfpFWpozfiKx
        mPQVrbjuKE7lo
X-Received: by 2002:adf:a54d:: with SMTP id j13mr29827439wrb.261.1568215821855;
        Wed, 11 Sep 2019 08:30:21 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyD8pPbPfDZ/edqU+cGQLR6Pyu/I5VLJqzd03XyBba6NkqPfSXkqcsLZ10KQ+Wo3r2IG6g6eA==
X-Received: by 2002:adf:a54d:: with SMTP id j13mr29827414wrb.261.1568215821612;
        Wed, 11 Sep 2019 08:30:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:102b:3795:6714:7df6? ([2001:b07:6468:f312:102b:3795:6714:7df6])
        by smtp.gmail.com with ESMTPSA id a190sm4225249wme.8.2019.09.11.08.30.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2019 08:30:21 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Only print persistent reasons for kvm disabled
 once
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20190826182320.9089-1-tony.luck@intel.com>
 <87imqjm8b4.fsf@vitty.brq.redhat.com> <20190827190810.GA21275@flask>
 <20190827192416.GG27459@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ec2ac833-e441-b136-fbd0-365917082fe6@redhat.com>
Date:   Wed, 11 Sep 2019 17:30:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190827192416.GG27459@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/19 21:24, Sean Christopherson wrote:
> On Tue, Aug 27, 2019 at 09:08:10PM +0200, Radim Krčmář wrote:
>> I am also not inclined to apply the patch as we will likely merge the
>> kvm and kvm_{svm,intel} modules in the future to take full advantage of
>> link time optimizations and this patch would stop working after that.
> 
> Any chance you can provide additional details on the plan for merging
> modules?  E.g. I assume there would still be kvm_intel and kvm_svm, just
> no vanilla kvm?

Yes, that is the idea.  Basically trade disk space for performance,
since kvm+kvm_intel+kvm_amd are never loaded together and kvm never has
>1 user.

Paolo

