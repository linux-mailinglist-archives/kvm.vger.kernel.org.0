Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81EFDADDB0
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 19:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbfIIRAM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 13:00:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56710 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727040AbfIIRAL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 13:00:11 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2130F2A09CB
        for <kvm@vger.kernel.org>; Mon,  9 Sep 2019 17:00:11 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id r21so101985wme.5
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2019 10:00:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D0EEdCwjKZAloFiFZzRmxXTgf/1c/anbaaWwH/4atiA=;
        b=Kl/8S7ul4WLc6ii/g01aB803gWYMQxoPmMbvaxC9Ee0z1ZBcV3tEIFZkgypyHbZKzy
         H2Fi9paPcAUGFJGYYbeoz23LjhiXNv2uPdgDHj0j3rUo4CpCxMXdIe6/djplSbAZkxkr
         ucCjQ/8Jzk4kSe2MvKPUwTsKWrdgxm+xqceOmx2GVIp7wL6t8wELwpxIwcelmAX2C48f
         UYRnGPGTa8W+TvPA2Mz3ltAxbN0KFqmfIbOGjf8n6xoH+VCtLaAhIrWCfR/5gd8q9eXQ
         2EEgPVXiU909FikseNyjCzM7YbbQZF7MA0PMBBaS3xdaWG8lasVhBMYgaBcOcbfOV4eo
         hUaA==
X-Gm-Message-State: APjAAAUVn4YdWlAGPgApdaj1vKN4JVBvVBGn8qPMJ5btbXYVE4K2cQqb
        ypa8BhJ/Zd9U2za/Lr++D6Y3r/dI1TW7RuFb9xwgpS6wcbrDn/G3PYJvKwdhQdxdwCa2umeZrDs
        Z8/1hdfON8YPQ
X-Received: by 2002:a5d:66d2:: with SMTP id k18mr19678350wrw.7.1568048409642;
        Mon, 09 Sep 2019 10:00:09 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzXJaVNu/2/fZCHTtIWw35qwKTZd4unUZx6BMsLts8oOV6M65uq4VD5n7+CBECGa01osKa5IQ==
X-Received: by 2002:a5d:66d2:: with SMTP id k18mr19678322wrw.7.1568048409413;
        Mon, 09 Sep 2019 10:00:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4580:a289:2f55:eec1? ([2001:b07:6468:f312:4580:a289:2f55:eec1])
        by smtp.gmail.com with ESMTPSA id d28sm16924627wrb.95.2019.09.09.10.00.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2019 10:00:08 -0700 (PDT)
Subject: Re: DANGER WILL ROBINSON, DANGER
To:     Jerome Glisse <jglisse@redhat.com>,
        Mircea CIRJALIU - MELIU <mcirjaliu@bitdefender.com>
Cc:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        Matthew Wilcox <willy@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-72-alazar@bitdefender.com>
 <20190809162444.GP5482@bombadil.infradead.org>
 <1565694095.D172a51.28640.@15f23d3a749365d981e968181cce585d2dcb3ffa>
 <20190815191929.GA9253@redhat.com> <20190815201630.GA25517@redhat.com>
 <VI1PR02MB398411CA9A56081FF4D1248EBBA40@VI1PR02MB3984.eurprd02.prod.outlook.com>
 <20190905180955.GA3251@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5b0966de-b690-fb7b-5a72-bc7906459168@redhat.com>
Date:   Mon, 9 Sep 2019 19:00:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190905180955.GA3251@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/09/19 20:09, Jerome Glisse wrote:
> Not sure i understand, you are saying that the solution i outline above
> does not work ? If so then i think you are wrong, in the above solution
> the importing process mmap a device file and the resulting vma is then
> populated using insert_pfn() and constantly keep synchronize with the
> target process through mirroring which means that you never have to look
> at the struct page ... you can mirror any kind of memory from the remote
> process.

If insert_pfn in turn calls MMU notifiers for the target VMA (which
would be the KVM MMU notifier), then that would work.  Though I guess it
would be possible to call MMU notifier update callbacks around the call
to insert_pfn.

Paolo
