Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A041EB3E0
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 05:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgFBDp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 23:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFBDpz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 23:45:55 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E19C061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 20:45:55 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 185so4450603pgb.10
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 20:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ItflNdMwIRaawQi3pcaC3Y6lcggQtCOHcO+2o5/8u9Y=;
        b=RABucGXppEqr6KP8YySKLXXwWfhW4TuuAqqX0clnVOZlWoR3IMmRs54S8ktD1x+qUH
         wkZKZNivTkp7c4bARAXNKTkGlmB/pX6aw4mcxI8NLB1uamfjYkSfly6FE0zYtRq3yGwn
         w/Pn4DAQkjd9m8IAUqKOhCcS81Q23wTFrv7U8+Zau9EICZMl6a3arB/XfTAY4/7gJCfV
         8J7FIBuF9sSjPWup0eKMK7FNm4NmhTQ8AgdSsPU4bLjoNdcAjkxclde8KC7mp2pmF4aG
         MgoUoWxIMV8RjCOujM9eQfqDnpUpOyqfRmk45QARp+1b7pXbibLEl/tlfUb3w1cuiLuy
         1KXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ItflNdMwIRaawQi3pcaC3Y6lcggQtCOHcO+2o5/8u9Y=;
        b=mvXsjelu2RXchXkrKQ60fw/rtetJxFv+VfBcmLXbMpH6idggH9VHnss3XVJjXT0uHe
         lPLg/6vwKJ1uqhBs+C1hl42n5D6y2BGsKrIlHguycpJfemQr1sC7XBkCeDrH1eXG4qAl
         h5p/doj55OUOUeXmlU/Rp1vCTaW1sVjTe4rUqdx6YovYUJInXkPSxWNhvgg6EQC4NHIZ
         hhalO7pRvIX+cawiZD7KOA8u+MRiHMntr2dvYMEh6DE9yPFzSBwGENc4R1I3H3QtCCOu
         lI1taCg2gj2i5zTa29wJVc4gh8QJjz3eK5uhMyEeNNqHjIEyfCxCaGWS2OWTfsyKRqGB
         QRzw==
X-Gm-Message-State: AOAM5331DyypJykk2KVmSOyHnyiij8m0QAC+RE8Nc3mhrYa6zDYJEyJT
        hA+RqdnbS7umBu3kPY0Ct0H4DQ==
X-Google-Smtp-Source: ABdhPJxbtCtKw8B937zuejhJH7SobzbyDGXbiVJ0onKcN68MtLpmF+MBKNAWPHGMs5R4PeXBDDQ6jA==
X-Received: by 2002:a63:5b63:: with SMTP id l35mr21756340pgm.34.1591069555169;
        Mon, 01 Jun 2020 20:45:55 -0700 (PDT)
Received: from [192.168.1.11] (174-21-143-238.tukw.qwest.net. [174.21.143.238])
        by smtp.gmail.com with ESMTPSA id x8sm747847pfm.202.2020.06.01.20.45.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 20:45:54 -0700 (PDT)
Subject: Re: [RFC v2 12/18] guest memory protection: Perform KVM init via
 interface
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-13-david@gibson.dropbear.id.au>
 <e0b5be25-db1f-ab7d-681b-bd8afdecf4e2@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <4a8eda0a-22de-57bf-254a-4289931a2293@linaro.org>
Date:   Mon, 1 Jun 2020 20:45:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <e0b5be25-db1f-ab7d-681b-bd8afdecf4e2@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/20 8:39 PM, Richard Henderson wrote:
> On 5/20/20 8:42 PM, David Gibson wrote:
>> +        if (object_dynamic_cast(obj, TYPE_GUEST_MEMORY_PROTECTION)) {
>> +            GuestMemoryProtection *gmpo = GUEST_MEMORY_PROTECTION(obj);
> 
> This duplicates the interface check.  You should use
> 
>   gmpo = (GuestMemoryProtection *)
>     object_dynamic_cast(obj, TYPE_GUEST_MEMORY_PROTECTION);
>   if (gmpo) {
> 
> AFICT.

Or ignore this nit, since you clean it up in patch 14.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

