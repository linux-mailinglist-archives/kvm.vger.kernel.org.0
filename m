Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B628CCE65E
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 17:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbfJGPFV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 11:05:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42734 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727975AbfJGPFU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 11:05:20 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E6645C058CA4
        for <kvm@vger.kernel.org>; Mon,  7 Oct 2019 15:05:19 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id r21so3444289wme.5
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2019 08:05:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2o0eUn9XQmaO3vyP+98zE6rGqN0+sCYt7aS5tzY/kSE=;
        b=d//p36e7HvWB3o1XkxcrGdvAQdmSXGINfZboU31GKr2rcTbTtcxJH0uShR0S80LgdL
         ufLpnrKsoqI5OEf3iesduD0MsX+LIf2q6Ck1YpWx4fkWPExces5RNEmt3OZRVOC5rJQw
         7LgWj1UgnfrRMP63s+q1qLX0liM4uMgq0YQ24nhYP776WJEr3AD8ihMKFFmuR0PPy9vF
         YigZpDUSIAIyVBKkTVyH4cukKpwtORFV43v7vOpqLyVrEVNOac4hMs//Y7GaJT+PDEHV
         Zz2WviMnvr6o47+tmGfPbeu2XPK5UBz2E59hYsoj6PgSBck4vAykhD18KOL0MDBpdPhl
         YZbg==
X-Gm-Message-State: APjAAAWIffOcVBIhPBM94qxNFUK2r0uUW7IM+qy4xfNfsIORNMIJM94H
        /MQvkLlYq+5Ts86nYPgC2+sulkYAj9fqHcdsGUmeLjWCCS/bIgm+eRGk59w+zzjmVzOPWZ+zdtH
        sir4vmBVvc2qS
X-Received: by 2002:a05:600c:2219:: with SMTP id z25mr20024668wml.109.1570460718618;
        Mon, 07 Oct 2019 08:05:18 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyIU66r9y4oav+Rzm1fzptGai1Lcazr1wdhLwhSB/QvFMIl4Mjhy4H/OXPK9OCnD92in26wxw==
X-Received: by 2002:a05:600c:2219:: with SMTP id z25mr20024634wml.109.1570460718321;
        Mon, 07 Oct 2019 08:05:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9dd9:ce92:89b5:d1f2? ([2001:b07:6468:f312:9dd9:ce92:89b5:d1f2])
        by smtp.gmail.com with ESMTPSA id r20sm30166993wrg.61.2019.10.07.08.05.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 08:05:17 -0700 (PDT)
Subject: Re: [PATCH 1/3] perf/core: Provide a kernel-internal interface to
 recalibrate event period
To:     "Liang, Kan" <kan.liang@linux.intel.com>,
        Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, peterz@infradead.org,
        Jim Mattson <jmattson@google.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
References: <20190930072257.43352-1-like.xu@linux.intel.com>
 <20190930072257.43352-2-like.xu@linux.intel.com>
 <6439df1c-df4a-9820-edb2-0ff41b581d37@redhat.com>
 <e2b00b05-a95a-3d03-7238-267c642a1fa0@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <4a2c164f-4a83-436b-c177-0d641d6be529@redhat.com>
Date:   Mon, 7 Oct 2019 17:05:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <e2b00b05-a95a-3d03-7238-267c642a1fa0@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/10/19 15:25, Liang, Kan wrote:
> 
>> On 30/09/19 09:22, Like Xu wrote:
>>> -static int perf_event_period(struct perf_event *event, u64 __user *arg)
>>> +static int _perf_event_period(struct perf_event *event, u64 value)
>>
>> __perf_event_period or perf_event_period_locked would be more consistent
>> with other code in Linux.
>>
> 
> But that will be not consistent with current perf code. For example,
> _perf_event_enable(), _perf_event_disable(), _perf_event_reset() and
> _perf_event_refresh().
> Currently, The function name without '_' prefix is the one exported and
> with lock. The function name with '_' prefix is the main body.
> 
> If we have to use the "_locked" or "__", I think we'd better change the
> name for other functions as well.

Oh, sorry I missed that.

Paolo
