Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6D22792A6
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 22:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbgIYUuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 16:50:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49766 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726587AbgIYUuO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 16:50:14 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601067013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3l0T9yYe9NbzcErpgFMneHQWiK+1fY8aylKjSft3rKY=;
        b=T6H+3AHR1XxVAa5gPVo2eaHe2/Kj0nk1zw6S77EXnRouRQaM81sUdsglQhz+E7d6cvAddl
        kM7o8or6Zlm5/vKSruFEOOsixDkNAqXiyETFbXcaRuQvU5it4X2sXFDZnP3nHJLQkJ9hzy
        DR6H09DjIwMEdxhD1TUujoHYBVWPfGE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-SHxbCgbtOwulj-6v5yNMiQ-1; Fri, 25 Sep 2020 16:50:11 -0400
X-MC-Unique: SHxbCgbtOwulj-6v5yNMiQ-1
Received: by mail-wr1-f71.google.com with SMTP id 33so1534178wrk.12
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 13:50:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3l0T9yYe9NbzcErpgFMneHQWiK+1fY8aylKjSft3rKY=;
        b=TjOkvaZcdF6ezum7jdJ1r5KI7F8O6ahXQmBxQK5Ep4mpkN2PaQ5aCck+i76p35vROG
         ML/ntyJe6o5cI1ijoVJ6cTKyURKpeyB1TdFLtun6VVwH7YArJATAdyHWXEzOmy7INO3T
         6V1uKUMyiREsIhBYLyAQfSgA7GVCoy3P04i+YRL33DdA9T4mmlwKI97gBckUSZyq6Qci
         i/91TA149PN7PYzZigRqHtbdLVZAuFd7iplMEluD9V/jbHjycYKzX9vAGfC/Zt4dxyz8
         YU90PS57rLZuj+39t72pSCj5c3qXfAwF6nd4bXAoe81RCvNsdj0EjqgrUU1H7JH2JRa6
         kwKA==
X-Gm-Message-State: AOAM5306DUe7L2rjvogX2ZxtRs9rAKhnd5muIvJv1q8AK5tj/gW23HGc
        JpwRgEiduQNPYkka7W2amgHRiroOH4vlqESGDwfmvJY05aVMG8hlIieSB6saAmqmM5pToj8jNaR
        zicYlac0kTn9k
X-Received: by 2002:a05:600c:2317:: with SMTP id 23mr374306wmo.183.1601067009867;
        Fri, 25 Sep 2020 13:50:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfBcvAqg33MQmqXRG0Dwa2ylGBcgivLaNHVhiSo9+k0jrr1zvmMT9x6crZ2aT1sUIBeAOSRg==
X-Received: by 2002:a05:600c:2317:: with SMTP id 23mr374277wmo.183.1601067009627;
        Fri, 25 Sep 2020 13:50:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id d19sm237257wmd.0.2020.09.25.13.50.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 13:50:08 -0700 (PDT)
Subject: Re: [RFC V2 0/9] x86/mmu:Introduce parallel memory virtualization to
 boost performance
To:     Ben Gardon <bgardon@google.com>,
        yulei zhang <yulei.kernel@gmail.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Haiwei Li <lihaiwei.kernel@gmail.com>
References: <cover.1598868203.git.yulei.kernel@gmail.com>
 <CANRm+CwhTVHXOV6HzawHS5E_ELA3nEw0AxY1-w8vX=EsADWGSw@mail.gmail.com>
 <CANRm+CydqYmVbYz2pkT28wjKFS4AvmZ_iS4Sn1rnHT6G1S_=Mw@mail.gmail.com>
 <CANgfPd8uvkYyHLJh60vSKp1ZDi9T0ZWM9SeXEUm-1da+DqxTEQ@mail.gmail.com>
 <CACZOiM1JTX3w567dzThM-nPUrUksPnxks4goafoALDq1z_iNsw@mail.gmail.com>
 <CANgfPd-ZRW676grgOmm2E2+_RtFaiJfspnKseHMKgsHGfepmig@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2592097d-3190-1862-b438-9e1b16616b82@redhat.com>
Date:   Fri, 25 Sep 2020 22:50:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd-ZRW676grgOmm2E2+_RtFaiJfspnKseHMKgsHGfepmig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 19:30, Ben Gardon wrote:
> Oh, thank you for explaining that. I didn't realize the goal here was
> to improve LM performance. I was under the impression that this was to
> give VMs a better experience on startup for fast scaling or something.
> In your testing with live migration how has this affected the
> distribution of time between the phases of live migration? Just for
> terminology (since I'm not sure how standard it is across the
> industry) I think of a live migration as consisting of 3 stages:
> precopy, blackout, and postcopy. In precopy we're tracking the VM's
> working set via dirty logging and sending the contents of its memory
> to the target host. In blackout we pause the vCPUs on the source, copy
> minimal data to the target, and resume the vCPUs on the target. In
> postcopy we may still have some pages that have not been copied to the
> target and so request those in response to vCPU page faults via user
> fault fd or some other mechanism.
> 
> Does EPT pre-population preclude the use of a postcopy phase?

I think so.

As a quick recap, turn postcopy migration handles two kinds of
pages---they can be copied to the destination either in background
(stuff that was dirty when userspace decided to transition to the
blackout phase) or on-demand (relayed from KVM to userspace via
get_user_pages and userfaultfd).  Normally only on-demand pages would be
served through userfaultfd, while with prepopulation every missing page
would be faulted in from the kernel through userfaultfd.  In practice
this would just extend the blackout phase.

Paolo

> I would
> expect that to make the blackout phase really long. Has that not been
> a problem for you?
> 
> I love the idea of partial EPT pre-population during precopy if you
> could still handle postcopy and just pre-populate as memory came in.
> 

