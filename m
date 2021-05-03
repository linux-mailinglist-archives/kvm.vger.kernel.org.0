Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4213718ED
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 18:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhECQK2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 12:10:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48029 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231243AbhECQKN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 12:10:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620058160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MqlCI3A2oW6RhK7XQnWik09Euybp4fJ1e+usL2JIHoc=;
        b=F5acFlJ7b+KHaZfvTWrzecN1+5gNuuhiSZdX48fQ4BZL8vV3H/vQ2pzY7iMjI2IcWAjPfW
        Q3osBdmM5jbXu+pFczJK3cUtNrXP/amrzqOZVCtfIAXk5nMTc20uJSMxAVgjdAujfLt4rk
        4poKck3LsD1fg4pKxWtzE1e3WR4bLcs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-nSrI_tb8PGKokUWC2KPcMw-1; Mon, 03 May 2021 12:09:17 -0400
X-MC-Unique: nSrI_tb8PGKokUWC2KPcMw-1
Received: by mail-ej1-f70.google.com with SMTP id ne22-20020a1709077b96b02903803a047edeso2255859ejc.3
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 09:09:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MqlCI3A2oW6RhK7XQnWik09Euybp4fJ1e+usL2JIHoc=;
        b=MnkxbMV0D1zLmGI6/kECt4e4/WM9q8U0/3GYEVJwHDwvzLQBpNn+oQOYhP/c6sFU6L
         BmVt6Ikot0oQx4h1C0nZmS6yxjKyWTZ/TX1RcuQK0r5T5F2Q1SXrRW0FexC60ZbfOo7w
         nAXd0sO3vfAPzBjrRQ2ZKpDCMALB3tDIOgRBCJJ+9Hx3ul5iMvjohkYTskHKp22efhjI
         0FEQJh98xsDwQM7fsbY00tUAFTfi4vscQLOrFxEp55j53uTjXNEaI0EQEzwaE3qv13GJ
         MQ6TuLFlx2NyhV4gOE+m1lJLFuR9orH95cr28isZ5CGcvUdQX0DU+uhDRh0BdWUpkZyA
         8WgQ==
X-Gm-Message-State: AOAM530VtM0XbRCv4/ysagdDycu8wz+YC8xqpyUwwBqxpy2MKpbfR8FV
        Ou5Rd24jHVM2RCjKi0Af+uw8LlByuQ1DenqnLkChy8z9b5r1VgxB36JNCInkzzDSxv5+EfdWZE7
        iVlcqWS6y4C68
X-Received: by 2002:aa7:dd41:: with SMTP id o1mr5111017edw.361.1620058155975;
        Mon, 03 May 2021 09:09:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPH7/dNNthMj2kudKPlxyLeZ47OshMMj3WXvFEoCDQFCMZCn/Q421i8TwGCiRHpyKvAl47KQ==
X-Received: by 2002:aa7:dd41:: with SMTP id o1mr5110994edw.361.1620058155739;
        Mon, 03 May 2021 09:09:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y2sm52375ejg.123.2021.05.03.09.09.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 09:09:14 -0700 (PDT)
To:     Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20210428230528.189146-1-pbonzini@redhat.com>
 <61aa0633-d69c-f1b6-dc9f-6ca9442fbbab@redhat.com>
 <20210503152554.GA1697972@xps15>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] KVM, AMD PSP and ARM CoreSight changes for 5.13 merge
 window
Message-ID: <a09e313e-83f2-b9df-f2f0-468a283be07d@redhat.com>
Date:   Mon, 3 May 2021 18:09:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210503152554.GA1697972@xps15>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/21 17:25, Mathieu Poirier wrote:
>> Mathieu, can you confirm that your coresight branch will*not*  be sent by
>> the ARM maintainers as well?
> Confirmed.  Marc's tree is the only place where the ETE-TRBE functionality has
> been added.  It was specifically done that way to avoid having the same code in
> multiple branches and prevent merge conflicts.

Thanks for confirming!

Generally, what we do for x86 is exactly the opposite: the basic 
functionality is committed to the x86 tree, and then merged in _also_ by 
myself.  For example, this pull request includes a topic branch provided 
by the cgroup maintainer and one provided by the x86 maintainers, but in 
both cases they _also_ sent exactly the same commits to Linus.

It works well because git is pretty good at avoiding conflicts when the 
same branch is present in multiple branches.  Instead, cherry-picking 
introduces lots of merge conflicts.

There are other advantages in doing that.  For example, in this case I 
didn't (and don't) quite know what ETE and TRBE are, beyond what a quick 
Internet search tells me.  Sending this functionality to an ARM 
maintainer that is more acquainted with the feature would ensure that 
the new functionality is documented properly in the tags and therefore 
in the commit messages.

This is what Linux was mentioning when he said "Pull requests need to 
have explanations of what they pull - not just because it needs to go 
into the merge message, but because the maintainer needs to keep track 
of what's happening".  In this case, the maintainer was me; based on my 
own workflow and due to the lack of commit message I assumed that the 
branch was also going to go through the ARM tree (and doubted my 
assumption only when sending the pull request to Linus, i.e. way too late).

I am also guilty as charged of the "Merge branch 'kvm-sev-cgroup' into 
HEAD" commit message, where I should have pointed out that Tejun had a 
later branchpoint from 5.12-rc than I did, resulting in conflicts.

So Marc, let's heed Linus's advice and document all topic branches that 
we merge into the KVM/ARM and KVM/x86 trees, including whether they also 
go into other trees---which they should do almost all the time.

Thanks,

Paolo

> Let me know if you need more information.

