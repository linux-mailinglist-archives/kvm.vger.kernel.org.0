Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDF023C91
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 17:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390599AbfETPwp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 11:52:45 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37230 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732806AbfETPwo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 11:52:44 -0400
Received: by mail-wm1-f67.google.com with SMTP id 7so13586674wmo.2
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 08:52:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sesleVeouyfNGOjM1fW6zUnzbiiSryOPlwu/gUB3GVU=;
        b=qCNveesmIUV1tG+AcnCHtYEiTsW3QFlAvmcZ5k2CHO7aR/cQRmJwSPpOqIP+s7jpsm
         QTL0chgFS9TUT6Dr21sgR1QHUCrXJKuRAFrkzceEbDeXk5LtbJYxXciyLGB6qGLzLkA6
         IeyIS4SLLn90vCYHz44bBhrdFmmhJwjzDRf8P9jL65rjjm6mNQBaZJhWlVy1u22bR7Nf
         Wt9aytqaxHnO74aV9bP99pfSUs4mPICoGZ1JnM3W7tWtic0KTbmLfbQbNHHd1fwiHDw2
         qJo6i0Ig/EoBfekUqSX7s30EeQ0zxxUdmQOVP0WV8BpJOghJf5QRYdRvM3p7HiP4Ebv5
         mLDg==
X-Gm-Message-State: APjAAAVJGe0l346dr8buO7gae6Z14XqHo+RwG1sDlLCkOXaWLPV9lNeM
        EpJ77VCN8FHewohuhKBVeDP96HeyZlJchg==
X-Google-Smtp-Source: APXvYqwC2M+AXZCNV91wcXNNbST+4j8H9g4vdQxBH7ambBYpdDP/ZmWBoySJF1zirDx/AxmJ/u24MA==
X-Received: by 2002:a1c:a615:: with SMTP id p21mr36974790wme.40.1558367562743;
        Mon, 20 May 2019 08:52:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id 20sm15000311wmj.36.2019.05.20.08.52.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 08:52:42 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/2] x86: nVMX: Use #DB in nmi and intr
 tests
To:     Nadav Amit <nadav.amit@gmail.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190508102715.685-1-namit@vmware.com>
 <20190508102715.685-2-namit@vmware.com>
 <CALMp9eRnqn6Jrd762UZGZ9cQSMBFaxvNFsOkqYryP8ngG7dUEw@mail.gmail.com>
 <7B8B0BFD-3D85-4062-9F44-7BA8AC7F9DAE@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <76ffb0ca-c007-05c4-7bef-5f72f03a7a4e@redhat.com>
Date:   Mon, 20 May 2019 17:52:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <7B8B0BFD-3D85-4062-9F44-7BA8AC7F9DAE@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/05/19 01:35, Nadav Amit wrote:
> I just hope that this support would convince you, and others, to prefer
> (when possible) kvm-unit-tests over the selftest environment.

kvm-unit-tests are not superseded by selftests; selftests are mostly
meant to test the KVM API.  While they are more easily debuggable than
kvm-unit-tests, the benefit is not big enough to justify the effort of
rewriting everything.

Furthermore, being able to run kvm-unit-tests on bare metal is useful,
even if it's not something that people commonly do, and consistent with
KVM's design of not departing radically for what bare metal does.

Thanks,

Paolo
