Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91CD296C25
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 11:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S461521AbgJWJdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 05:33:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21583 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S461518AbgJWJdQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 05:33:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603445594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dhjktOBoRTQaSYJPiSgNw60+MzGJGvfEgx56IsafvOg=;
        b=OWVadWVkszPGgc74T9LE6vUKCa1zWH/Y2zKg+x8W9ynw/iJz91yjFqjVha6AYdLChNhPQj
        +BARz3MKFnX5tTD0Azj6G3RMqnNlVvAzIuY5hYDPosb+wxahHXUUpLs/V9FI7WWEJoCD9e
        W01rlVW/5IkUJjJW3mobv/nSpsLy4ww=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-p2W3s0erOqal0jTT4lXMtA-1; Fri, 23 Oct 2020 05:33:12 -0400
X-MC-Unique: p2W3s0erOqal0jTT4lXMtA-1
Received: by mail-wr1-f72.google.com with SMTP id t17so377340wrm.13
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 02:33:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dhjktOBoRTQaSYJPiSgNw60+MzGJGvfEgx56IsafvOg=;
        b=bqw1nE1C1YPZMThFRLeVg4ecBetcVIiM7EdYcgIT5KeeKFG1fyxk68OWVV94/k6kyd
         25T7wdW6lrLNXrWzwZMV7UUsT8M6UVMeQmHVCYMGm5l8LNAjQ9jMDHm5YLwvl9BppQYZ
         1ECT4SFhl/ecPhyjm3F8xcwiGWTX3KNPPciTko9j25aSlFTEbYBxVYKmGsYyJSkUXcTX
         dVzo8XDzwFVpbuSMnr0WNAOiHUqV5Twssnno43/FuEePze7Rx4NG2lQ6KzXVWRSufBPm
         /tOyfa2Y1oBr1HXKwVvUn1+8DdRNxFux/12AuFA04XenE31yGj6ijrMZlQf8oNXRmtZB
         lpSg==
X-Gm-Message-State: AOAM532QxMdd0vELclwB5urKF6ngYxpp6fihUkhgcmUH4zQIZkBsEHfP
        2CL/UIKObfW7RwooWc7thyrOtoPQ/JgudR+ddLBMkgWLOBwh0HfRcHdxluAuldKxQJ77UWqbxAK
        FffZA7G6F4PUP
X-Received: by 2002:a1c:4306:: with SMTP id q6mr1448473wma.189.1603445591335;
        Fri, 23 Oct 2020 02:33:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw03dE4BvokvwSb4DY1v456I8rv/1zCQjMQg386djUX5vLasV/K1FS7SwEMTZT11Lnp0+2jXQ==
X-Received: by 2002:a1c:4306:: with SMTP id q6mr1448442wma.189.1603445591095;
        Fri, 23 Oct 2020 02:33:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q8sm2147629wro.32.2020.10.23.02.33.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2020 02:33:10 -0700 (PDT)
To:     Peter Zijlstra <peterz@infradead.org>,
        Josh Don <joshdon@google.com>,
        g@hirez.programming.kicks-ass.net
Cc:     Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Xi Wang <xii@google.com>
References: <20201023032944.399861-1-joshdon@google.com>
 <20201023071905.GL2611@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/3] sched: better handling for busy polling loops
Message-ID: <ef03ceac-e7dc-f17a-8d4d-28adf90f6ded@redhat.com>
Date:   Fri, 23 Oct 2020 11:33:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201023071905.GL2611@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/10/20 09:19, Peter Zijlstra wrote:
>> +	/*
>> +	 * preemption needs to be kept disabled between prepare_to_busy_poll()
>> +	 * and end_busy_poll().
>> +	 */
>> +	BUG_ON(preemptible());
>> +	if (allow_resched)
>> +		preempt_enable();
>> +	else
>> +		preempt_enable_no_resched();
> NAK on @allow_resched
> 

Since KVM is the one passing false, indeed I see no reason for the
argument; you can just use preempt_enable().  There is no impact for
example on the tracking of how much time was spent polling; that
ktime_get() for the end of the polling period is done before calling
end_busy_poll().

Paolo

