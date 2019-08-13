Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8C08B415
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 11:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbfHMJ3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 05:29:13 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39665 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbfHMJ3M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 05:29:12 -0400
Received: by mail-wm1-f66.google.com with SMTP id i63so831896wmg.4
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 02:29:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HlAEpqymIE/2aXmWh9O2C6f1zWhZyF+vIZxr8hLy7E8=;
        b=ogMTSFSp6/5qD7QNpJ+bVDWuolW07yskkKFXi/Xt/SVCWiF+RjA5tWNg0Fs7ph3bUv
         /Zlup0zUb7JQ4TNCOvdbW6GTHA97Ws8hx0EDCuXZg0+DSMNZZqyk9IICwtHTcK9Wvuq3
         mlpFbaYcrPmtYDj1xxDPW+WHG0Vu+7uouiXy+qEs9lRTN9vhal/1aWSxm7XxrWjZ8xZf
         HWqc6mePDPdWtr1d+W+lX3fZlVWjnBixb3l9z4vmCEMRm+8k4QGgGRnpQcF+0JZsz5KJ
         LBQGmF5PT7BIgaHixkgcXXYS5NbqvFdYnlY+MjHBdY711TelsBi5jKtFsi7HPF3WLvIa
         pM4Q==
X-Gm-Message-State: APjAAAVUwMmENWBAyjJfhcZJj3udw6sfVr/o9nQGdJqUQhBBmH1nwd21
        vCj0WMfRn09IdLdgKd29LW5LQORlVbc=
X-Google-Smtp-Source: APXvYqzrOiKUATXICk0r/wqqOqYzdUlD6b5RE1HxjJCFGhp5IL3oELH2ehl1knzxc0AKbs6tiQAFDw==
X-Received: by 2002:a7b:c198:: with SMTP id y24mr2019539wmi.131.1565688550614;
        Tue, 13 Aug 2019 02:29:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5d12:7fa9:fb2d:7edb? ([2001:b07:6468:f312:5d12:7fa9:fb2d:7edb])
        by smtp.gmail.com with ESMTPSA id f134sm1257977wmg.20.2019.08.13.02.29.09
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 02:29:10 -0700 (PDT)
Subject: Re: DANGER WILL ROBINSON, DANGER
To:     Matthew Wilcox <willy@infradead.org>,
        =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        virtualization@lists.linux-foundation.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@kvack.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>,
        =?UTF-8?Q?Mircea_C=c3=aerjaliu?= <mcirjaliu@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-72-alazar@bitdefender.com>
 <20190809162444.GP5482@bombadil.infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ae0d274c-96b1-3ac9-67f2-f31fd7bbdcee@redhat.com>
Date:   Tue, 13 Aug 2019 11:29:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809162444.GP5482@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/19 18:24, Matthew Wilcox wrote:
> On Fri, Aug 09, 2019 at 07:00:26PM +0300, Adalbert Lazăr wrote:
>> +++ b/include/linux/page-flags.h
>> @@ -417,8 +417,10 @@ PAGEFLAG(Idle, idle, PF_ANY)
>>   */
>>  #define PAGE_MAPPING_ANON	0x1
>>  #define PAGE_MAPPING_MOVABLE	0x2
>> +#define PAGE_MAPPING_REMOTE	0x4
> Uh.  How do you know page->mapping would otherwise have bit 2 clear?
> Who's guaranteeing that?
> 
> This is an awfully big patch to the memory management code, buried in
> the middle of a gigantic series which almost guarantees nobody would
> look at it.  I call shenanigans.

Are you calling shenanigans on the patch submitter (which is gratuitous)
or on the KVM maintainers/reviewers?

It's not true that nobody would look at it.  Of course no one from
linux-mm is going to look at it, but the maintainer that looks at the
gigantic series is very much expected to look at it and explain to the
submitter that this patch is unacceptable as is.

In fact I shouldn't have to to explain this to you; you know better than
believing that I would try to sneak it past the mm folks.  I am puzzled.

Paolo
