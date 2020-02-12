Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0E8A15AD8A
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 17:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgBLQko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 11:40:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34810 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727439AbgBLQko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 11:40:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581525642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NrzhUur53Q4Y2ZEl1kiuBFTu/KwLXcTXVoqRdvHJiBI=;
        b=MmT6dKzIFED2xhfqhOBjly+jhYXiP1wFlnVwK+4da6z35cIqLUZEyrDvnfQqFh8nH2rw9O
        8hHQPz48rA3YiLWxNpia0pGSfrRJ1K/z+eps2lM4jCNEDHIQiyWJxwo0/xeJ7rxkM5w1CF
        YNFbI1rPmbILrpTIJfmyhLz5ENm1eGQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-ujXXtdLaMr6zUaSarD-xmA-1; Wed, 12 Feb 2020 11:40:40 -0500
X-MC-Unique: ujXXtdLaMr6zUaSarD-xmA-1
Received: by mail-wr1-f70.google.com with SMTP id j4so1040446wrs.13
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 08:40:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NrzhUur53Q4Y2ZEl1kiuBFTu/KwLXcTXVoqRdvHJiBI=;
        b=N/9EG18/lTV7HmO6uSY2lJJO9CVSXlxY+KJOT3663nLs5dJQ76+4lOsjf+XCO8vA7X
         87vdjr9JOCT/MdsVtnC5ZMCmvAQwED0laZbgkNiDdvyY87hCK7aoKrbKF0Ps9duOawTr
         0z8XoyvWrUMKbo5vHUVgQLYhZ1oDXA1MSDTwClXknITSjTXL1kGXzaimPotnO2XVaNWl
         BngpyrNPgXntrcTse0CYbj/ZnIOhDjUDs9kyU67garZNrH+yfWZ/3vfp6WuhEfCLQVi5
         1kG0B6Ql9BZsDZea+lpdFvtDBug76A950ILd3vZH5oEJpsfuYe5ttFnV8XRCv1AuuV6f
         c37Q==
X-Gm-Message-State: APjAAAUzMpVaE2tdQmT7i5O7hmvh0WVd8ssyvC3QviS3mP5oN+aQ+FKj
        cN0/9ArYUGDK/slSrnsE1dICKeP2Hk96HhnJ20PxmYn0ttaVhd5pm0GrDiuQhH0i8ldUAeFZ/jF
        KnPHIQRow25rG
X-Received: by 2002:adf:f288:: with SMTP id k8mr17060155wro.301.1581525639840;
        Wed, 12 Feb 2020 08:40:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqzXp2B+0mO+xq5e6mZFerIe0v8m3gwrAdj/HKSYiJvdfgdAfcAjS2vwUxPN1hDCGYWFBWWsgQ==
X-Received: by 2002:adf:f288:: with SMTP id k8mr17060137wro.301.1581525639611;
        Wed, 12 Feb 2020 08:40:39 -0800 (PST)
Received: from [192.168.178.40] ([151.30.86.140])
        by smtp.gmail.com with ESMTPSA id n8sm1179999wrx.42.2020.02.12.08.40.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 08:40:39 -0800 (PST)
Subject: Re: [PATCH RFC 0/4] KVM: MIPS: Provide arch-specific
 kvm_flush_remote_tlbs()
To:     Paul Burton <paulburton@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mips@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200207223520.735523-1-peterx@redhat.com>
 <44ba59d6-39a5-4221-1ae6-41e5a305d316@redhat.com>
 <20200212163004.cpd33ux4zslfc3es@lantea.localdomain>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <66e0a38c-a7f5-dcd1-d06b-b317588fad7a@redhat.com>
Date:   Wed, 12 Feb 2020 17:40:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200212163004.cpd33ux4zslfc3es@lantea.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/02/20 17:30, Paul Burton wrote:
> Hi Paolo,
> 
> On Wed, Feb 12, 2020 at 01:25:30PM +0100, Paolo Bonzini wrote:
>> MIPS folks, I see that arch/mips/kvm/mmu.c uses pud_index, so it's not
>> clear to me if it's meant to only work if CONFIG_PGTABLE_LEVELS=4 or
>> it's just bit rot.  Should I add a "depends on PGTABLE_LEVEL=4" to
>> arch/mips/Kconfig?
> 
> I'm no expert on this bit of code, but I'm pretty sure the systems
> KVM/VZ has been used on the most internally had PGTABLE_LEVEL=3.
> 
> I suspect this is actually a regression from commit 31168f033e37 ("mips:
> drop __pXd_offset() macros that duplicate pXd_index() ones"). Whilst
> that commit is correct that pud_index() & __pud_offset() are the same
> when pud_index() is actually provided, it doesn't take into account the
> __PAGETABLE_PUD_FOLDED case. There __pud_offset() was available but
> would always evaluate to zero, whereas pud_index() isn't defined...

Ok, I'll try to whip out a patch that handles __PAGETABLE_PUD_FOLDED.
On the other hand this makes me worry about how much KVM is being tested
by people that care about MIPS (even just compile-tested).

Paolo

