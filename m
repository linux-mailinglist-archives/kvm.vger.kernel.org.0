Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 295162D345
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 03:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfE2BZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 21:25:43 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41700 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfE2BZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 21:25:43 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so434344wrm.8
        for <kvm@vger.kernel.org>; Tue, 28 May 2019 18:25:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rqj4DN+mKFOFN2ElIEBtWrUBDtgBpL5CxV4R4XTM10o=;
        b=K/i4kT/i4mb6Y2uP8PCmhlggSnyVLnzQ8KFn3oN0mTT1m/ZbbB3iUwGEKLU6GZd/6B
         H2P7XobZd4FjpAbq4C/ZCDUDk+EldeYu1tGacmifPcpKobHwM5jqCYbC2iZy143t1EIC
         GzbBj8IA6G1j/Y6SxU9BWSDNX8apjz85XzTGfZzunKAjiQvFAnGAGA73N5zWLFpF61JZ
         aqYxi76SGCwcuSPaM0YlcBlVvAK0eDpzI1263Hw46sLrGmX02FtEbXA2QnorN1ZXtvgi
         nM1pTI23kAP/FHSQ5KggKyyRiAy3ySQetPsJ8W+25+XFAgX2TGyO84CM76cyaSmQ/+Yj
         Dglg==
X-Gm-Message-State: APjAAAX7jOcPemX+iqtKQSHkEkFfOBKSbX3cYkxYK3txXX3Xw4xwy39T
        sg1yG3SJJPL3KcoO7mdGcbqNBA==
X-Google-Smtp-Source: APXvYqwtWVxxE2Y3KBugsv4RW0JNUGuXKYKlfAWL8wp283sVlUi5mkh0LOf0h0ykT1V8TpWOn1NBog==
X-Received: by 2002:a5d:5189:: with SMTP id k9mr14487648wrv.329.1559093141154;
        Tue, 28 May 2019 18:25:41 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id s15sm10845265wrn.68.2019.05.28.18.25.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 18:25:40 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] KVM: x86: add support for user wait instructions
To:     Peter Zijlstra <peterz@infradead.org>, Tao Xu <tao3.xu@intel.com>
Cc:     rkrcmar@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jingqi.liu@intel.com
References: <20190524075637.29496-1-tao3.xu@intel.com>
 <20190524075637.29496-2-tao3.xu@intel.com>
 <20190527103003.GX2623@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bcf669c8-81f4-0024-5f66-c40c6d519c62@redhat.com>
Date:   Wed, 29 May 2019 03:25:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190527103003.GX2623@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/05/19 12:30, Peter Zijlstra wrote:
>> This patch adds support for UMONITOR, UMWAIT and TPAUSE instructions
>> in kvm, and by default dont't expose it to kvm and provide a capability
>> to enable it.
>
> I'm thinking this should be conditional on the guest being a 1:1 guest,
> and I also seem to remember we have bits for that already -- they were
> used to disable paravirt spinlocks for example.

This should be userspace's choice.  It would indeed be silly to enable
this while overcommitted, but KVM doesn't really care.

Paolo
