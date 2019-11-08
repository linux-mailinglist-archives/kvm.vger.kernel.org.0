Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54807F57E9
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 21:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732395AbfKHTvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 14:51:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54604 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730780AbfKHTvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 14:51:07 -0500
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 719CBC057EC4
        for <kvm@vger.kernel.org>; Fri,  8 Nov 2019 19:51:06 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id q6so409234wrv.11
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2019 11:51:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HVIeOx6nzmd9djN2e4574H+maZm9DfsxWD4R9Q206x0=;
        b=g6p0PnrFfBnY2ptadEgSVNCr5wYAv0ji8XJ7mCHGoJ8BS1wQaRdXOTtR0LB64IovXw
         NWey0V0LpWGHuW7NzEyF/SbcjecpbwIMH2ECV25z4YDCvHxvQSqqThUh0/Wetu1vfRx4
         OE6ZvahuJnG3N8e+NYcZe93GJ7Xg6gC/GMOVC+X/wQEyNdzU1/tiPSqoOCRfj5u41GLh
         Xn/6b3OolEUN//wOuyhRFyVtUq858HRznYc+YD2JA6y6jXW9nIsv3CuQS6sWt94xzMnB
         j1HPT6aWas9j+FtBp6G4JmCqCSP9BngvXe4Imz+WTtHsbe1Gh92oxRpfPWi9i9/DIfjC
         JoDA==
X-Gm-Message-State: APjAAAU2RvU8C9h3zOQ1sXLyBnXwkN3TPz27ao2v5CTKvzCxNOKAax9L
        /sLmg+Z+ilq1kGeYCww/m7f5JlFG5liDZQ6FSHywr0RoZ8DoUQhZnoQdFyWVzF6J/0wUhP6xShG
        RfYDo91HlUN0M
X-Received: by 2002:a5d:4ecd:: with SMTP id s13mr10517839wrv.216.1573242665046;
        Fri, 08 Nov 2019 11:51:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqxwh5QagsORgLMSC6facSW636Vhv994NNhYmi82cn5LKJsrOsA8bp3Br/6du+5NcGEbfP/45g==
X-Received: by 2002:a5d:4ecd:: with SMTP id s13mr10517822wrv.216.1573242664769;
        Fri, 08 Nov 2019 11:51:04 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e8cd:9f0f:a5dc:7ad5? ([2001:b07:6468:f312:e8cd:9f0f:a5dc:7ad5])
        by smtp.gmail.com with ESMTPSA id y16sm6599496wro.25.2019.11.08.11.51.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2019 11:51:04 -0800 (PST)
Subject: Re: [PATCH 03/13] kvm: monolithic: fixup x86-32 build
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Matthias Maennich <maennich@google.com>
References: <20191104230001.27774-1-aarcange@redhat.com>
 <20191104230001.27774-4-aarcange@redhat.com>
 <6ed4a5cd-38b1-04f8-e3d5-3327a1bd5d87@redhat.com>
 <678358c1-0621-3d2a-186e-b60742b2a286@redhat.com>
 <20191105135414.GA30717@redhat.com>
 <330acce5-a527-543b-84c0-f3d8d277a0e2@redhat.com>
 <20191105145651.GD30717@redhat.com>
 <ab18744b-afc7-75d4-b5f3-e77e9aae41a6@redhat.com>
 <20191108135631.GA22507@linux-8ccs>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b77283e5-a4bc-1849-fbfa-27741ab2dbd5@redhat.com>
Date:   Fri, 8 Nov 2019 20:51:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108135631.GA22507@linux-8ccs>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/11/19 14:56, Jessica Yu wrote:
> And I am
> not sure what Masahiro (who takes care of all things kbuild-related)
> thinks of this idea. But before implementing all this, is there
> absolutely no way around having the duplicated exported symbols? (e.g.,
> could the modules be configured/built in a mutally exclusive way? I'm
> lacking the context from the rest of the thread, so not sure which are
> the problematic modules.)

The problematic modules are kvm_intel and kvm_amd, so we cannot build
them in a mutually exclusive way (but we know it won't make sense to
load both).  We will have to build only one of them when built into
vmlinux, but the module case must support building both.

Currently we put the common symbols in kvm.ko, and kvm.ko acts as a kind
of "library" for kvm_intel.ko and kvm_amd.ko.  The problem is that
kvm_intel.ko and kvm_amd.ko currently pass a large array of function
pointers to kvm.ko, and Andrea measured a substantial performance
penalty from retpolines when kvm.ko calls back through those pointers.

Therefore he would like to remove kvm.ko, and that would result in
symbols exported from two modules.

I suppose we could use code patching mechanism to avoid the retpolines.
 Andrea, what do you think about that?  That would have the advantage
that we won't have to remove kvm_x86_ops. :)

Thanks,

Paolo
