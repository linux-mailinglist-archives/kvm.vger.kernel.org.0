Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66676BBFB6
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 03:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392671AbfIXBZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 21:25:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35940 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388857AbfIXBZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 21:25:37 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 148162026F
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 01:25:37 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id v18so54237wro.16
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 18:25:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xj3D9weBvvGH4QzczcqBFTO/vVNmZQd4hYXQQeqeaII=;
        b=ZJL2mf1onSiEru7XFX7Sf7fUsDQRmgyBxEQ06PAWDRuDGVQYq4uG7bTeCE1nVJz6J0
         nKklHxDx9qyL3qExF2C4tc72kSSjPnSNT/uYw7MfLouIASRTRjw57oss6bb/DtIvJ9QF
         xxcdjy9Acjkx31ci7KSp9prOLEms330Db37YorRDg/UC3b3qZ0Aaei/ROEbGf14WNp2c
         8z+/n0bbtCoENSsD+erW7tguGPWujq7GMtjychhvk1z+WDqiLkOr+bEK2pdbmNP+m6pE
         HLTmG7kEBZX/eXEQUpzAQY4D/0pY7goeG+zeKky6PdCl30zj/CfWjYPhMfYPV18l+dsI
         w0gQ==
X-Gm-Message-State: APjAAAUbtmllyoSXI0c8G+yBfPJGFs3OIqTbdYELoujkWLwYaBzmXIuG
        Scq50xRhUHPsqHv/s6+svBhnnjacEpaTL41zPYcXoo8ejocx3hl5VFih5JS3DgcLlFmGyvQZgZ7
        mq+sKJUj3OPIy
X-Received: by 2002:a05:6000:1184:: with SMTP id g4mr127595wrx.361.1569288335717;
        Mon, 23 Sep 2019 18:25:35 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyJvHeB3EfxNQ+c0VPwzgcez8G6EPsqpQZUikOxoYmksWOE7tQWSxWJ9eRpcysQ5/DTMSQ6og==
X-Received: by 2002:a05:6000:1184:: with SMTP id g4mr127577wrx.361.1569288335478;
        Mon, 23 Sep 2019 18:25:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id q10sm268496wrd.39.2019.09.23.18.25.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 18:25:34 -0700 (PDT)
Subject: Re: [PATCH 14/17] KVM: monolithic: x86: inline more exit handlers in
 vmx.c
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-15-aarcange@redhat.com>
 <6a1d66a1-74c0-25b9-692f-8875e33b2fae@redhat.com>
 <20190924010056.GB4658@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a75d04e1-cfd6-fa2e-6120-1f3956e14153@redhat.com>
Date:   Tue, 24 Sep 2019 03:25:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190924010056.GB4658@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/19 03:00, Andrea Arcangeli wrote:
> Before and after this specific commit there is a difference with gcc 8.3.
> 
> full patchset applied
> 
>  753699   87971    9616  851286   cfd56 build/arch/x86/kvm/kvm-intel.ko
> 
> git revert
> 
>  753739   87971    9616  851326   cfd7e  build/arch/x86/kvm/kvm-intel.ko
> 
> git reset --hard HEAD^
> 
>  753699   87971    9616  851286   cfd56  build/arch/x86/kvm/kvm-intel.ko
> 
> git revert
> 
>  753739   87971    9616  851326   cfd7e  build/arch/x86/kvm/kvm-intel.ko

So it's forty bytes.  I think we can leave this out.

Paolo
