Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A154EBB9F1
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 18:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439990AbfIWQvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 12:51:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44564 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390657AbfIWQvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 12:51:48 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B38A576520
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 16:51:47 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id s25so5216590wmh.1
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 09:51:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3RbYm8r31nf5/CgoKO2hq1IVIw3F2t6/IIFZwh76KkU=;
        b=DLHFW6L+qVa6y4HJi3/bxWNOF4bqz9bVmq9I4wrTEXpG+MxrzEiv38Shi2zkxL5KBt
         OSyOaEQX+xApqWde9cPYGwUP2BHXJto4NVor3q8ZagjkfyzTPH7f2eQoK6h9jwWXrZkE
         LmQnAZrNixxtTzoOOXGArDi2Toi73ie4yBLSVuzjKdSeFgm2/YC9wtlrUNFRdbGwB2qp
         aGUUK9Lu/aHwZDJW4D9mRVU0DJw1GlAqTlrUxxI1yZFRSVHz6BU0592DlBHyPPy8hetI
         wTTfswhXZc7j0RlD+WwZLVDj5JqUIbcz+YJOZd/IIcnEyKbqmCOvMUAlEOmvb54lLmv7
         eKXg==
X-Gm-Message-State: APjAAAUYQ+AGjyVSvL5zAAd2ncbppI7LHmJMZIWE5h5UyfrXN3Wudxos
        74caWwcpCayqcFEx6SEO6rMxYx0lG1pHs1S2vAtCNk+vpUG0AGy2skmqtLa9D215K9hvqUphY1X
        LLTt9EDwSwhyr
X-Received: by 2002:a5d:430f:: with SMTP id h15mr289718wrq.177.1569257506293;
        Mon, 23 Sep 2019 09:51:46 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyajlkv9A6Ku4HYClKecGn3/36UfGhv+IfcMvF2aTqfZ8o+21QEdB5W3/2BDE+bNBaUn3Nghg==
X-Received: by 2002:a5d:430f:: with SMTP id h15mr289702wrq.177.1569257506049;
        Mon, 23 Sep 2019 09:51:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id n2sm10154924wmc.1.2019.09.23.09.51.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 09:51:45 -0700 (PDT)
Subject: Re: [PATCH 02/17] KVM: monolithic: x86: convert the kvm_x86_ops
 methods to external functions
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-3-aarcange@redhat.com>
 <9b188fb8-b930-047f-d1c0-fe27cbe27338@redhat.com>
 <20190923161352.GC18195@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <0ffed044-c5e1-4cc9-365a-ae51c4d2b2cb@redhat.com>
Date:   Mon, 23 Sep 2019 18:51:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190923161352.GC18195@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/19 18:13, Sean Christopherson wrote:
> Alternatively, what if we use macros in the call sites, e.g. keep/require
> vmx_ and svm_ prefixes for all functions, renaming VMX and SVM code as
> needed?  E.g.:
> 
> 
>   #define X86_OP(name) kvm_x86_vendor##_##name
> 
>   int kvm_arch_init(void *opaque)
>   {
> 	if (X86_OP(supported_by_cpu())) {

Please no, the extra parentheses would be a mess to review.

Paolo
