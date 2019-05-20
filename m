Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68923239EA
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 16:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732739AbfETOZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 10:25:03 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39379 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732702AbfETOZD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 10:25:03 -0400
Received: by mail-wr1-f66.google.com with SMTP id w8so14863782wrl.6
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 07:25:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=illAOdE59mTMm72I2WyB8ev4NJE+g+STjttga8vJ3tQ=;
        b=qyB89XP0Ikbzy48HQAfryJuVDrekbtAX3tVtTBB+NttvrgppPM290DF8ao6zLxJrbK
         zmOhSpfj/RkD1D27S2Frya3oWXos+zKf1ezYfvOxU0o/g4JbC8HD/7bk0JOZOAkv0M/g
         xvpMGyu3OL2us1HBLq6iAKvC6CeT/MzDw5X8frEN0NJx2TWVhWmj1b+o9LJ1Tl6qxbKC
         kfZUNHF/K/zm6R3bj2Y/PNVamHGb4owNUEUlfydceWT/XbOuqGof3es59tPchH4AxDJv
         SOvRMRTIhboTrjuwQD0r1RmpEHRKvDRoRg+umTOPqYrgehuxTbMZReWSYs9+g7Hnvkan
         BkTA==
X-Gm-Message-State: APjAAAUqiFPS9L76ATes4WKvcDMGGzTUyMYyvTGcKuKtJOTruSrbX8Xn
        mllfCxObVIE5GsPUTMzQ8RvdHwlz98qVXA==
X-Google-Smtp-Source: APXvYqymD3RWTb5eUl/x2bYPjrGplER8G8j50hGajec6STTyNa1yTb9LWmwmo9dfEsuIzhfa3Ilogg==
X-Received: by 2002:adf:db11:: with SMTP id s17mr6775442wri.43.1558362301571;
        Mon, 20 May 2019 07:25:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id q11sm1267847wmc.15.2019.05.20.07.25.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 07:25:00 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 0/2] x86: nVMX: Fix NMI/INTR-window
 tests
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190518160231.4063-1-nadav.amit@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1f502e48-7770-15cd-ecb2-629a5619c52f@redhat.com>
Date:   Mon, 20 May 2019 16:25:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190518160231.4063-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/05/19 18:02, Nadav Amit wrote:
> NMI/INTR-window test in VMX have a couple of bugs. Each of the patches
> fixes one. The first version of this patch-set claimed that one of the
> bugs might be a silicon issue. However, according to Sean, it is a
> just a test and KVM issue, once you read the SDM more carefully.
> 
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Nadav Amit (2):
>   x86: nVMX: Use #DB in nmi- and intr-window tests
>   x86: nVMX: Set guest as active after NMI/INTR-window tests
> 
>  x86/vmx_tests.c | 80 +++++++++++++++++++++++--------------------------
>  1 file changed, 38 insertions(+), 42 deletions(-)
> 

Queued, thanks.

Paolo
