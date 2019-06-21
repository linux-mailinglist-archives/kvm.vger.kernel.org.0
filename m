Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 342874E243
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 10:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfFUIne (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 04:43:34 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52560 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbfFUInd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 04:43:33 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so5553091wms.2
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2019 01:43:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=RGP6lrdFeiyCR8bFc4y9TBM1FWLgB81TixkDIMIJnYg=;
        b=CPFHLTtuIcIX7aG/kVNY4VRkDWnV8Qp97Mhfo7PT/AqjD4bbOWdoqP3TMUct1JCB0C
         W1cyned/oG2KC0SpbL8ME4exAIQRFDz95ChiSXsNTVAtfWy6WNfu721aOsGbiJnMWwED
         7N1b8qP/CKMkXanrN7tKpcCnLq1LAay427p+5TVwJzAQn2i0xgzY498z47R4ZLcPuOsV
         3RzqkTXNky4b7MEhcMhpyuSvxU8XFWZBEy3XCrAipXvEKmBFmCE/WnIUl2ZZP82+nDx2
         ONVjAtQ0zWT0FpF1LD6qD1hpyxuec/39pksoent4pe5t65j44Q56eiFCtZhxzHhE8oPi
         chyw==
X-Gm-Message-State: APjAAAVLZCYktaAl2i7cwQwyQUNer+xm0cdWq96QnSOXpySRSAXUgp2n
        ffIkz0fuWpya9531JlbxVgNewA==
X-Google-Smtp-Source: APXvYqwZFutXN6BvKeDJNb/D/OOiLk+eQ4ygcLMq6gGb3r3C2Sg0Vxxr+txQdjtA94eBouvi/KXLLw==
X-Received: by 2002:a1c:e90f:: with SMTP id q15mr3293812wmc.89.1561106611736;
        Fri, 21 Jun 2019 01:43:31 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-89-176-127-31.net.upcbroadband.cz. [89.176.127.31])
        by smtp.gmail.com with ESMTPSA id r4sm2447702wra.96.2019.06.21.01.43.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 01:43:31 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH RFC 3/5] x86: KVM: svm: clear interrupt shadow on all paths in skip_emulated_instruction()
In-Reply-To: <CALMp9eQ85h58NMDh-yOYvHN6_2f2T-wu63f+yLnNbwuG+p3Uvw@mail.gmail.com>
References: <20190620110240.25799-1-vkuznets@redhat.com> <20190620110240.25799-4-vkuznets@redhat.com> <CALMp9eQ85h58NMDh-yOYvHN6_2f2T-wu63f+yLnNbwuG+p3Uvw@mail.gmail.com>
Date:   Fri, 21 Jun 2019 10:43:30 +0200
Message-ID: <87o92rfhvx.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> On Thu, Jun 20, 2019 at 4:02 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> Regardless of the way how we skip instruction, interrupt shadow needs to be
>> cleared.
>
> This change is definitely an improvement, but the existing code seems
> to assume that we never call skip_emulated_instruction on a
> POP-SS/MOV-to-SS/STI. Is that enforced anywhere?

Hm, good question. I'll try to check before v1.

-- 
Vitaly
