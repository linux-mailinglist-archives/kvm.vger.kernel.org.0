Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDE633EE7E
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 11:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhCQKkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 06:40:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230064AbhCQKk2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Mar 2021 06:40:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615977627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+uA62LYXXYt34SbzMiUOo/GuFglM+koNWxYIoI0HaWE=;
        b=d5Z/nXPvdqcfX0LvzoLIcdsg7gNFgr5+v+NexEunJVjgcq5SLhQr7CO8bemWnFaG2WZGJa
        Dy1f8cJ26CPlkgFsWx6aQZrXhA9U3LeeM1IUQUZ66mvYvM3gOWoLBNPh5CFWlFLem/VoQO
        xo9fzCJyJJsxpnyeAYgrjmYtIClOaWo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-FPx1zgdFMB-jVigV9UNmXg-1; Wed, 17 Mar 2021 06:40:26 -0400
X-MC-Unique: FPx1zgdFMB-jVigV9UNmXg-1
Received: by mail-wr1-f69.google.com with SMTP id h30so18236123wrh.10
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 03:40:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+uA62LYXXYt34SbzMiUOo/GuFglM+koNWxYIoI0HaWE=;
        b=kUYA6Ui1FuPYxq+y3/6DCF9r2H+sNp5SjMMFPRW8NQveBOHdRDFD7IAR5idXWXT5lj
         I1Rg3kvgVmpz9uLMKG/vNDpe/bllDeaoMlzLor8doER0aX38TXuLMmHr4+hWmTL4y+3Q
         CVgW7H4ANQ0S0yY8GZah5eLQlcGbt85mhhfWGhylelPK8tMdRApVz4nznd1u8NmzXzna
         j6uDNe1ZUSZoRLunRK4eUF92egleKrjJiUghO+14aYm92HxbFJ9NamaPRT8E/lyb95HA
         MrkmimJ6EmFFiit5oXlbSmWTgqBX20AQtw2dZ1xoJvsHjZ1LIX41Y/fRRSl7N9biSFpp
         IA5g==
X-Gm-Message-State: AOAM53377AA+G5Lsag0Ti3bdcCKr2u1BN58qh2Hq3g+zZ6ed0qhtmw5v
        IG/GjdA4aA2JuQm7KQcpvNNAzAuF0I8SGPheaUY1FAfkJIiVaDcXkl9BA2cH24QOeON7fD3zx2n
        b00DvrXXPZhrg
X-Received: by 2002:a5d:4904:: with SMTP id x4mr3643789wrq.69.1615977624795;
        Wed, 17 Mar 2021 03:40:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBZF3gGd+0hYA9nqALSuEG9p1iV25XmceN6jt1DKaC69m024BQgq4l21LRQchOZyC/bGwd1A==
X-Received: by 2002:a5d:4904:: with SMTP id x4mr3643776wrq.69.1615977624655;
        Wed, 17 Mar 2021 03:40:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p16sm30048521wrt.54.2021.03.17.03.40.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 03:40:24 -0700 (PDT)
To:     Marc Zyngier <maz@kernel.org>, Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Shakeel Butt <shakeelb@google.com>
References: <1615959984-7122-1-git-send-email-wanpengli@tencent.com>
 <87mtv2i1s3.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: arm: memcg awareness
Message-ID: <e5fce698-9e21-5c71-c99b-a9af3f213e8f@redhat.com>
Date:   Wed, 17 Mar 2021 11:40:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <87mtv2i1s3.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/03/21 10:10, Marc Zyngier wrote:
>> @@ -366,7 +366,7 @@ static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>>   	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
>>   		return -EINVAL;
>>   
>> -	childp = (kvm_pte_t *)get_zeroed_page(GFP_KERNEL);
>> +	childp = (kvm_pte_t *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> No, this is wrong.
> 
> You cannot account the hypervisor page tables to the guest because we
> don't ever unmap them, and that we can't distinguish two data
> structures from two different VMs occupying the same page.

If you never unmap them, there should at least be a shrinker to get rid 
of unused pages in the event of memory pressure.

Paolo

