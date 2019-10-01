Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93D7DC3764
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 16:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388957AbfJAOaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 10:30:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41438 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbfJAOaL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 10:30:11 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 16406C057F88
        for <kvm@vger.kernel.org>; Tue,  1 Oct 2019 14:30:11 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id j2so6092583wre.1
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2019 07:30:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uYAaBtdM1jqbgvAOY1l3EFV1qXvd/OnWbcIm/a50FEs=;
        b=YsAaIivkddD0h9c4uKB9tcECoSiYuShzUN/cvLk12T9KRpDeyNeXm7Oc509MMpNJuV
         771yoPfvsL7F09VmV7I0Ji66YXWprgt+qjKMyIIu0ttpw5aWWylzwjJEl3TBkDRs1YYe
         Hti4X0tcXyfBr5m1t9dzj07YvONDIwJImYM5ISMSWpPrEIzJqGPz8/EDCETdzLg+YnVX
         /3HMks5/X0xhrqeXPjUkFwmYZwizUavYV8+BjZAc1gqWGkclQmyT2s6cfH/LKAt4vgrl
         2/LpSEb7pPid2Nf22s0AHVfvE2iSSjZUvfa2xa0RJLSbM2oT+6M/4FdIA4xGEqrcxYIc
         Anmg==
X-Gm-Message-State: APjAAAVtiSn2lB1GAGjOTPR5FMNoU1DXpyQ1GykVu6u/BLon5ogmxANw
        78SJ5GJ5eYFy7HglPuo5rPbtCNb9SvKypa9nYR3qehz8usMg93SEWT/b/9XKIGOGiT5tR1QQnk+
        oQCBaEFM9mMGT
X-Received: by 2002:a1c:1aca:: with SMTP id a193mr4161240wma.120.1569940209421;
        Tue, 01 Oct 2019 07:30:09 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy/WlI+lYuUZS81xaehQkpRwr1hpFSG9V2x//ifO6p6Xm7Un5FeK4P1ilSGpeYn6EiKCXQ/Og==
X-Received: by 2002:a1c:1aca:: with SMTP id a193mr4161215wma.120.1569940209148;
        Tue, 01 Oct 2019 07:30:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b903:6d6f:a447:e464? ([2001:b07:6468:f312:b903:6d6f:a447:e464])
        by smtp.gmail.com with ESMTPSA id g11sm2938837wmh.45.2019.10.01.07.30.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Oct 2019 07:30:08 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Remove proprietary handling of unexpected
 exit-reasons
To:     Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, tao3.xu@intel.com,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>
References: <20190929145018.120753-1-liran.alon@oracle.com>
 <874l0u5jb4.fsf@vitty.brq.redhat.com>
 <CALMp9eS7wF1b6yBJrj_VL+HMEYjuZrYhmMHiCqJq8-33d9QE6A@mail.gmail.com>
 <20190930172038.GE14693@linux.intel.com>
 <2299BCA8-8FEF-4857-9680-8CE3E58034A6@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dfacb83a-332a-69ec-fc2d-bd4ba841da05@redhat.com>
Date:   Tue, 1 Oct 2019 16:30:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <2299BCA8-8FEF-4857-9680-8CE3E58034A6@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/19 02:33, Liran Alon wrote:
> OK Ok I apologise for my bad English. ^_^
> Paolo, feel free to reword this commit title & message to something else when applying…

I'll replace it with "specialized", no problem.  I agree with Sean's
assessment. :)

Paolo
