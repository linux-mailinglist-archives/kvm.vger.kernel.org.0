Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDCE13906D
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 12:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgAMLwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 06:52:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26929 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726127AbgAMLwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 06:52:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578916342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fAtNK55yDbPKiBZA6iN0qoeGlR4L/c8UwxpFGcssRLE=;
        b=cQx7m3Dw8BJ8kVpz2Bgc+gXW1QNc8KFwKGLloS7mQdGsxOXNvCz9gLcz/v0mvLy/mJcux3
        WJ40wgxskwjEGYXfOcY46hN2N/Lf9ssBpxP4hYGcpWb1kbocykVoNzA9R8qRK01/SEU94Y
        2Plqgnp0E82oji7Zo9s69WiIMJIfnjc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-q2jIONNSNW6_PB_nf-EuMg-1; Mon, 13 Jan 2020 06:52:21 -0500
X-MC-Unique: q2jIONNSNW6_PB_nf-EuMg-1
Received: by mail-wm1-f70.google.com with SMTP id p2so2434785wma.3
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2020 03:52:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fAtNK55yDbPKiBZA6iN0qoeGlR4L/c8UwxpFGcssRLE=;
        b=p390W3U3CPPrU6yi58gBuy7yPiYoRhXHHgBBKB34V9T4dgQJb9KyFTVAztaWejnXi6
         /rVqiuizadGksiNUfJ/DMgK8dGrtMBvmNY5QksmeOpVRXYZWdrsnHyqFOgses68lM459
         OqWOaHO1bBlng+ICESN507OCYPdeKcXs5ib1XDhNNx0Zji+HAhNoqRMSuTLE+zDNVWjh
         etEiQk2rocS5bBIIOMNDfdAm87+oBpVliMiuE/ezIWMjO9tkGuMPpVxGclyqr0ab7KbI
         3kYCjVfYEYZnr9JIbgfaL96QMbtXsIMMCQcyquScIPVCIeGPo2Ud685d8J6dLWGiouN0
         WyQA==
X-Gm-Message-State: APjAAAW+9TQB745k+eOzdtKCOYPNRm4dsCfxipD+nQ1xlRi8BtgeJDmO
        HSO16n08vuhPLX+wj8nDLKKUbJ4C76bfWhYLAsgFIsAO0wnLCa3Ul4YVpF/t9EfOphfP1AhC60r
        vGZmgAVgPG7RS
X-Received: by 2002:a1c:7f4f:: with SMTP id a76mr20060473wmd.77.1578916340368;
        Mon, 13 Jan 2020 03:52:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqxZg2dccxP0IdOTlGnnmh5SXAppWHgMgGLJe1d7ybkkLljLcXiIb4/SCMEl9TwTbWQUxFL5bA==
X-Received: by 2002:a1c:7f4f:: with SMTP id a76mr20060454wmd.77.1578916340124;
        Mon, 13 Jan 2020 03:52:20 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:1475:5c37:e2e2:68ea? ([2001:b07:6468:f312:1475:5c37:e2e2:68ea])
        by smtp.gmail.com with ESMTPSA id u24sm14250566wml.10.2020.01.13.03.52.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2020 03:52:19 -0800 (PST)
Subject: Re: [PATCH RFC] sched/fair: Penalty the cfs task which executes
 mwait/hlt
To:     Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KarimAllah <karahmed@amazon.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        christopher.s.hall@intel.com, hubert.chrzaniuk@intel.com,
        len.brown@intel.com, thomas.lendacky@amd.com, rjw@rjwysocki.net
References: <1578448201-28218-1-git-send-email-wanpengli@tencent.com>
 <20200108155040.GB2827@hirez.programming.kicks-ass.net>
 <00d884a7-d463-74b4-82cf-9deb0aa70971@redhat.com>
 <CANRm+Cx0LMK1b2mJiU7edCDoRfPfGLzY1Zqr5paBEPcWFFALhQ@mail.gmail.com>
 <20200113104314.GU2844@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ee2b6da2-be8c-2540-29e9-ffbb9fdfd3fc@redhat.com>
Date:   Mon, 13 Jan 2020 12:52:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200113104314.GU2844@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/01/20 11:43, Peter Zijlstra wrote:
> So the very first thing we need to get sorted is that MPERF/TSC ratio
> thing. TurboStat does it, but has 'funny' hacks on like:
> 
>   b2b34dfe4d9a ("tools/power turbostat: KNL workaround for %Busy and Avg_MHz")
> 
> and I imagine that there's going to be more exceptions there. You're
> basically going to have to get both Intel and AMD to commit to this.
> 
> IFF we can get concensus on MPERF/TSC, then yes, that is a reasonable
> way to detect a VCPU being idle I suppose. I've added a bunch of people
> who seem to know about this.
> 
> Anyone, what will it take to get MPERF/TSC 'working' ?

Do we really need MPERF/TSC for this use case, or can we just track
APERF as well and do MPERF/APERF to compute the "non-idle" time?

Paolo

