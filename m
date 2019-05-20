Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E12F23E51
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 19:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392824AbfETRVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 13:21:12 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46980 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392821AbfETRVM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 13:21:12 -0400
Received: by mail-wr1-f65.google.com with SMTP id r7so15462002wrr.13
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 10:21:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2XkW6U8tyuCedKGU5mO7OaB7yAk+TZauHH3mf/E1c94=;
        b=p44WJbKhg6aDKhtPgfYMkb/Gn1hYYvPb4DEzYZlugltKsMri3qdidnbp4wna9ma7rc
         HQbtj1e20SLPddNfUG+sGBmCo+48Ur80YCbL142d9tFp1ZjG+CW0myBn3E2HtYTOpWqS
         LKfdOFadDmMBvWzfmfahAGYD4LUGBGKog1THxUpNMrvBv0rVs5UUgm1Ae43r6FIkcErD
         Dubo/UUwJugngs2HEePgSXaXJ7iZAl6MhUwbQKkPV0EAWeoUh354IummA0Ts2A2wDQl1
         vAkKiJkqsIq+Xi60l31tNhA1ggAo2jx0S1yyV3x/1Oma3e7fbWXpyCC50YBMFcz29AVH
         Lu/w==
X-Gm-Message-State: APjAAAVnZRlSRNwk1gvL7mol+fnrDxw12tYfFszbycn2kukxaaKeNyor
        Y4NF4d9uOU5Jsf1D5byXAx+aOQ==
X-Google-Smtp-Source: APXvYqzHbMQXZY9AvzceJG4qwon/KSr7H8D9aBqmC7dwe4lLYgLGhWFslKkgf6Wj41wGvZ2Syu+j0w==
X-Received: by 2002:adf:8189:: with SMTP id 9mr44545296wra.71.1558372870599;
        Mon, 20 May 2019 10:21:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id t13sm38506608wra.81.2019.05.20.10.21.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 10:21:10 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/2] x86: nVMX: Use #DB in nmi and intr
 tests
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190508102715.685-1-namit@vmware.com>
 <20190508102715.685-2-namit@vmware.com>
 <CALMp9eRnqn6Jrd762UZGZ9cQSMBFaxvNFsOkqYryP8ngG7dUEw@mail.gmail.com>
 <7B8B0BFD-3D85-4062-9F44-7BA8AC7F9DAE@gmail.com>
 <76ffb0ca-c007-05c4-7bef-5f72f03a7a4e@redhat.com>
 <FAC1484C-8157-45F4-BF1A-514DDF4E0ABC@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <39f0658b-8ef0-feee-34a8-3f1f559c48a6@redhat.com>
Date:   Mon, 20 May 2019 19:21:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <FAC1484C-8157-45F4-BF1A-514DDF4E0ABC@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/19 18:39, Nadav Amit wrote:
> I’m sorry for not collecting the patches into a set, but I know that it
> would just cause me to resend all of them for individual patch issue.

All the patches you've sent make sense individually.  Thanks to you (and
the corporate overlord ;)) for doing the work and for sharing it, really.

Paolo
