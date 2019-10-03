Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88490CAF5C
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 21:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731842AbfJCTij (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 15:38:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59508 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731750AbfJCTij (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 15:38:39 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EDA87C05AA64
        for <kvm@vger.kernel.org>; Thu,  3 Oct 2019 19:38:38 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id s19so917612wmj.0
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 12:38:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7QLgfjpHoSlZ+ECWPNFBD+JW0vOaubyrwbW7qiEpfTs=;
        b=RfFrJ0u/j+EhRtR+AlzPKvmTMjFYI6NOkZqJJElmmEF6UagHFkP1u/JscvIZzHTQP5
         ssRMRI1CIagUeXbfhesIQT/DrgxGKaA1uXnmQniK9oRfXETMbQbJTThHzEKm1qyzUNEd
         9VJhCm0vF0T16VjU+u1e/VQ4GJlVjhmekEV+NYaNmBkDdZx05IEZFNkwBsSxa7nCwe32
         ZmdaOgxyePhWxUYT72+9oRTNA58A1BN8CTq6AmXC6FQwaihrTGVFU9ul3m5ZrTf0KodB
         ga093zsRZ0NWaXJJhWxy+ccRHkbXDi9FngyvRRR7g1GZXcqXYYd7ehrRngdgwQLAh60q
         dGrA==
X-Gm-Message-State: APjAAAWEOs8FlfOAjCTtWsqjhw6Ce02dYvkem59x8QBoXyfaw2HEClEC
        4YrcZcHcfQslLSw7V8c1vol8ojWpFwhjmpe3E6AMS18O3tUz6mONkKddAVZWPGVbyo3T/KKvAKQ
        ajeJ/rAWcI75x
X-Received: by 2002:adf:e28e:: with SMTP id v14mr8548952wri.184.1570131517629;
        Thu, 03 Oct 2019 12:38:37 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwaEc996x92Bjfkrt/7/Bp3ePgLBVpbOA1h0uSvOWcidOkSjdp4RwK4EnTkpGFal4Tmi9DFQw==
X-Received: by 2002:adf:e28e:: with SMTP id v14mr8548930wri.184.1570131517306;
        Thu, 03 Oct 2019 12:38:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e56d:fbdf:8b79:c79c? ([2001:b07:6468:f312:e56d:fbdf:8b79:c79c])
        by smtp.gmail.com with ESMTPSA id q124sm5331957wma.5.2019.10.03.12.38.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 12:38:36 -0700 (PDT)
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
References: <DB7PR02MB3979D1143909423F8767ACE2BBB60@DB7PR02MB3979.eurprd02.prod.outlook.com>
 <20191002192714.GA5020@redhat.com>
 <ab461f02-e6cd-de0f-b6ce-0f5a95798eaa@redhat.com>
 <20191002141542.GA5669@redhat.com>
 <f26710a4-424f-730c-a676-901bae451409@redhat.com>
 <20191002170429.GA8189@redhat.com>
 <dd0ca0d3-f502-78a1-933a-7e1b5fb90baa@redhat.com>
 <20191003154233.GA4421@redhat.com>
 <d62a6720-e069-4e03-6a3a-798c020786f7@redhat.com>
 <DB7PR02MB39796440DC81A5B53E86F029BB9F0@DB7PR02MB3979.eurprd02.prod.outlook.com>
 <20191003183108.GA3557@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <afe2cf69-5c2c-95af-88ce-f3814fece2e2@redhat.com>
Date:   Thu, 3 Oct 2019 21:38:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003183108.GA3557@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/10/19 20:31, Jerome Glisse wrote:
> So in summary, the source qemu process has anonymous vma (regular
> libc malloc for instance). The introspector qemu process which
> mirror the the source qemu use mmap on /dev/kvm (assuming you can
> reuse the kvm device file for this otherwise you can introduce a
> new kvm device file). 

It should be a new device, something like /dev/kvmmem.  BitDefender's
RFC patches already have the right userspace API, that was not an issue.

Paolo
