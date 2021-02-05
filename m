Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C223116F2
	for <lists+kvm@lfdr.de>; Sat,  6 Feb 2021 00:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbhBEXVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 18:21:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42619 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229721AbhBEKK4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 05:10:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612519725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XQAmpeiwjTLNRxNDH8Fc0DNgLit8cCAihA/yreIw74s=;
        b=YXouJe54IlVTt5aKY88hGzLZm9O2nPzJmYenCccSEM7vBvO2veSED/pZfbvnLHfCY6rXw5
        5s2XLdPP+ppSnyhqjdsLQMD76JkZl7vdFP/7r6oNAtQQdQOSw+g5kwnIt48qpOB20Xk8wx
        BYumgebRBfWF1rMM9OGe4MkDAH69P4Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-Hxue3r6vOuqsC-0KHn0CLg-1; Fri, 05 Feb 2021 05:08:43 -0500
X-MC-Unique: Hxue3r6vOuqsC-0KHn0CLg-1
Received: by mail-wm1-f71.google.com with SMTP id r13so2824152wmq.9
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 02:08:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XQAmpeiwjTLNRxNDH8Fc0DNgLit8cCAihA/yreIw74s=;
        b=EKWmXJLxRPwuFgVhO85HByHchUSeK2W2MyoVLj9DO3ABjaf3+IvmDmeEVGmhIWX+lY
         X3/rvh4f/Ds6cyoJUZ8EofCjAYL5tzi3miD3BauqXjqAaSEvY1udr3oOvkNZQMZjTkZz
         c4xI6y5UVAe+9GRjE7m6GtKtb2x6mo3cSzeE297lUNggfH2dJp23ahlje4o1j0VVCCUQ
         M9Vm72lvrIBJDmyRDCZHqj1sC+qZIpeablUqdgukZSH1uqsC1dyKknv4swqKh8yBt1sj
         jIGF2Py0824OPIVQdY+PL9FhB3y1eglAI/qMZRcGZUpyuCVfYscdM3lDcNgHeN7NKLVC
         H+Sw==
X-Gm-Message-State: AOAM5304aMhSHNhsjJtZ2yo1JPU763HbmshfWLEt8vgoHKQIwCL+sfE3
        FHA8Cpx981kikm9kbnflRKXPLEF8MJKmbR3MIWHYvnU/uoxQYBVVvidZo1rgpjO4n1nOTGwjqQL
        zIT809aiEX+WW
X-Received: by 2002:adf:f303:: with SMTP id i3mr4098908wro.60.1612519721740;
        Fri, 05 Feb 2021 02:08:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJygnV5PVQbw8IB48V2+j6ejVS7WeCWn7No/UZJIzRZQZzqTlpByGGeGJZYMFj/b3HUjRWFm7w==
X-Received: by 2002:adf:f303:: with SMTP id i3mr4098899wro.60.1612519721586;
        Fri, 05 Feb 2021 02:08:41 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y63sm8267192wmd.21.2021.02.05.02.08.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 02:08:40 -0800 (PST)
To:     Stephen Rothwell <sfr@canb.auug.org.au>, KVM <kvm@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20210205160224.279c6169@canb.auug.org.au>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: linux-next: build failure after merge of the kvm tree
Message-ID: <cac800cb-2e3e-0849-1a97-ef10c29b4e10@redhat.com>
Date:   Fri, 5 Feb 2021 11:08:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210205160224.279c6169@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/02/21 06:02, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the kvm tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> ERROR: modpost: ".follow_pte" [arch/powerpc/kvm/kvm.ko] undefined!
> 
> Caused by commit
> 
>    bd2fae8da794 ("KVM: do not assume PTE is writable after follow_pfn")
> 
> follow_pte is not EXPORTed.
> 
> I have used the kvm tree from next-20210204 for today.
> 

Stephen, can you squash in the following for the time being?

diff --git a/mm/memory.c b/mm/memory.c
index feff48e1465a..15cbd10afd59 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4775,6 +4775,7 @@ int follow_pte(struct mm_struct *mm, unsigned long 
address,
  out:
  	return -EINVAL;
  }
+EXPORT_SYMBOL_GPL(follow_pte);

  /**
   * follow_pfn - look up PFN at a user virtual address

A similar patch has been posted already, but Jason Gunthorpe asked to 
add some kerneldoc comments.  Therefore it will not be in kvm/next for a 
few more days.

Paolo

