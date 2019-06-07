Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3959E391DC
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 18:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730454AbfFGQY0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 12:24:26 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43648 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730150AbfFGQY0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 12:24:26 -0400
Received: by mail-wr1-f66.google.com with SMTP id r18so2751144wrm.10
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2019 09:24:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5oup8aDf0v+i4nY2iXLwyIEfJBWa+tQFAZ2fj1dhWlA=;
        b=Zv4mab8MrGCEp8956uB9K+1hcLTE9s7xP6ueu3WjK2MjmQybYC/lqiOVJ442a9e0wD
         cYFD0jqcUo7kFJ0QBPzwmU12kkLI7A0MiY7XrWRNI7l8ivz4SabikM6/Di2l5TyocoTi
         qQFQ8k03xUwYRumvXqivOeiNj1tyUhXlV5QMyM9dRAmQe72QECj0boXP2cFpaag6aB77
         j/5V4zy7wZexZxqWEbUu31nNPwBCupsXW+wbmNlCJ4V4GYJ77JkfYAHpqrBG2nFY0qwv
         pUwbkhzYV2zdyGdW7RuWlVW+VU/VTcF5z/Rnd6WTyuv/zd3GtPWnWsQiYL4wAUsEIure
         JEQg==
X-Gm-Message-State: APjAAAXB4m1X6MUtVblMqzqtS7cKf9xu3ejjWzmNnhyhvcE1m1u1S+Qw
        6I/IUvwvqPDwdrqThALMb0ow17lu070=
X-Google-Smtp-Source: APXvYqzLgpRRvfyTFa6/TEI5l10HeRd8tc36q34IPW/9wW2GzAxU5AlO2ZetyEIBACf1Y9qZK8wjWA==
X-Received: by 2002:adf:aa0a:: with SMTP id p10mr33931090wrd.125.1559924664702;
        Fri, 07 Jun 2019 09:24:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id w6sm2524953wro.71.2019.06.07.09.24.23
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 09:24:24 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Rename prepare_vmcs02_*_full to
 prepare_vmcs02_*_extra
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1559834652-105872-1-git-send-email-pbonzini@redhat.com>
 <20190606184117.GJ23169@linux.intel.com>
 <8382fd94-aed1-51b4-007e-7579a0f35ece@redhat.com>
 <20190607141847.GA9083@linux.intel.com>
 <5762005d-1504-bb41-9583-ec549e107ce5@redhat.com>
 <20190607160422.GE9083@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <525f4ee1-c111-aaa0-2dcd-6c5ce26e3088@redhat.com>
Date:   Fri, 7 Jun 2019 18:24:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190607160422.GE9083@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/06/19 18:04, Sean Christopherson wrote:
>> That's what came to mind first, but then "extended" had the same issue
>> as "full" (i.e. encompassing the "basic" set as well) so I decided you
>> knew better!
> Ah, I was thinking of "basic" and "extended" as separate states, but your
> interpretation is correct.
> 
> I probably have a slight preference for 'uncommon' over 'extra'?  I feel
> like they have equal odds of being misinterpreted, so pick your poison :-)

Among your proposals, in fact, I also thought of "uncommon" and "rare".
 Uncommon is a bit long so I'll go with "rare", knowing that the meat
reference will give me a chuckle every now and then.

Paolo
