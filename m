Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BAD3B1716
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 11:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhFWJly (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 05:41:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24442 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230152AbhFWJlx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 05:41:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624441176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nk49XlXeHosOswVGCCNxHMrFlyXg5sckW14ipg09Etw=;
        b=ifnvWxl5uL0qoLZTJOoQnJSsE5V4Imw8CS0baXcFr2UJ7iyBeRx7Wr7i08dINGMbBWEYps
        zvXy9k6sZAtNdXHmlVnxNj1BtVO6Y+kCVmiDHkSRoykgzLjMfx3thy3clhVmqGf2PxSZcv
        R25yy7FzJkhqyGlgU4XglqD0n9VsNE4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-r0PdQkN7O9qK07qVDa3-_A-1; Wed, 23 Jun 2021 05:39:35 -0400
X-MC-Unique: r0PdQkN7O9qK07qVDa3-_A-1
Received: by mail-wr1-f69.google.com with SMTP id j1-20020adfb3010000b02901232ed22e14so855574wrd.5
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 02:39:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nk49XlXeHosOswVGCCNxHMrFlyXg5sckW14ipg09Etw=;
        b=DK0ye63KzWuSYqe24FKj3bkJnYZeAodnl1ak4MIHs/bOywJW2OHw5x107Y2BvAv5tk
         MXEIFqi4V8NHon6hIlPGhmxmwKnIQaFs+r1d9w+jK0ToAYmKuNuUMt8dykvBNR60+FEP
         ZNMpHuEx2SWa2u2yqLRQY9t6QjE4YiYSwyeikCGKSpTYeirlc4pR82QYSRR6XBTujSVC
         ZT1mOXpEKLTJafKbsSFIaipViPx+N28a7mxkf4naCkn4sL2314YZ1700JMynQH6M19Bp
         cwNwJ6XBoXNKvXmPE6CvnsgPdtk0/SgzOI5sFMcjAsIfYOnzDFBevbaEeMYVHuiuufu7
         4cyQ==
X-Gm-Message-State: AOAM532BMD64lgdVTL/4RxpN6wRVEfDcihta4vzU8yEKk2SZPL9TxcyB
        3v7xN6kmowVYBcaywvWagFRwUTmcWFwrJs3JdWnAdSomkgRlX0b8hc6f5t9qbzgjEtiTBRtsOa3
        Saet9T4CdrF0s
X-Received: by 2002:adf:f946:: with SMTP id q6mr10260013wrr.283.1624441173911;
        Wed, 23 Jun 2021 02:39:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhIlzIfSpKT+lNu6OZDVYqOFhFkR+ZB2WuZ/Xszdb1cxSHhgpp7LV9CAMtlxzmCLxqDCiCeg==
X-Received: by 2002:adf:f946:: with SMTP id q6mr10259987wrr.283.1624441173707;
        Wed, 23 Jun 2021 02:39:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s23sm5715276wmh.5.2021.06.23.02.39.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 02:39:33 -0700 (PDT)
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20210623074427.152266-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RFC] KVM: nSVM: Fix L1 state corruption upon return from
 SMM
Message-ID: <a3918bfa-7b4f-c31a-448a-aa22a44d4dfd@redhat.com>
Date:   Wed, 23 Jun 2021 11:39:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210623074427.152266-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/21 09:44, Vitaly Kuznetsov wrote:
> - RFC: I'm not 100% sure my 'smart' idea to use currently-unused HSAVE area
> is that smart. Also, we don't even seem to check that L1 set it up upon
> nested VMRUN so hypervisors which don't do that may remain broken. A very
> much needed selftest is also missing.

It's certainly a bit weird, but I guess it counts as smart too.  It 
needs a few more comments, but I think it's a good solution.

One could delay the backwards memcpy until vmexit time, but that would 
require a new flag so it's not worth it for what is a pretty rare and 
already expensive case.

Paolo

