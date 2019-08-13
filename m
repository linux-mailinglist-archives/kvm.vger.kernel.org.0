Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1EE58B7E3
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 14:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfHMMDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 08:03:03 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:51471 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726935AbfHMMDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 08:03:02 -0400
Received: by mail-wm1-f46.google.com with SMTP id 207so1261827wma.1
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 05:03:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MX7X0Tdt4CfdX/yOLamRc+yoXtYLHnncZUmS/xCOMp0=;
        b=JoXcS0Vj01rFXqozyjopA0NuwqrUu3c4jAb9fwdivA0hczWxYFN+bR7vqDEvPSgEix
         SjGR7JxKH46oRLVsM/sK3rnkp/oqu2GKNHf7lxRbqpCy7gTKOAkyfmeOFmzfB9mO1bn+
         22eYay0j0Cnb6PStU1uC5YMmT+ny1HuZXranKbzMbqRGpQgU1sqwSCf5VmhgI1t05Wfb
         n23LK3X96XE0BX6MRBKTI9HbVNy15wkk/LEhBd4QtBa9PyUJtG6hPWA087ErntbY8zrk
         L0xVRGJkunNgiDIQ9o3hhzFaNIUnmlSr5BlY3wlcVrm5gcAuOuhAl/flVqZZK6CFlaKI
         4f8Q==
X-Gm-Message-State: APjAAAWghz804wwIxgxpjWYLolonm+HB3EUdXpvTB0dCJBnD6Li0s/O9
        8LHVZyAS4R2mIB2W0nSVF+1tww==
X-Google-Smtp-Source: APXvYqx63jmoFRwdi2jV2fOjTMCgfgZMJXNx+Msiu64sQdnLWei7VvJgxwF+ydu6THkk6ZGBzqYBBg==
X-Received: by 2002:a1c:c005:: with SMTP id q5mr2650468wmf.59.1565697780602;
        Tue, 13 Aug 2019 05:03:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5193:b12b:f4df:deb6? ([2001:b07:6468:f312:5193:b12b:f4df:deb6])
        by smtp.gmail.com with ESMTPSA id p10sm1466831wma.8.2019.08.13.05.02.59
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 05:02:59 -0700 (PDT)
Subject: Re: DANGER WILL ROBINSON, DANGER
To:     Matthew Wilcox <willy@infradead.org>
Cc:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        kvm@vger.kernel.org, linux-mm@kvack.org,
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
 <ae0d274c-96b1-3ac9-67f2-f31fd7bbdcee@redhat.com>
 <20190813112408.GC5307@bombadil.infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b6735416-602a-a2f5-5099-7e87c5162a6b@redhat.com>
Date:   Tue, 13 Aug 2019 14:02:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190813112408.GC5307@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/19 13:24, Matthew Wilcox wrote:
>>>
>>> This is an awfully big patch to the memory management code, buried in
>>> the middle of a gigantic series which almost guarantees nobody would
>>> look at it.  I call shenanigans.
>> Are you calling shenanigans on the patch submitter (which is gratuitous)
>> or on the KVM maintainers/reviewers?
>
> On the patch submitter, of course.  How can I possibly be criticising you
> for something you didn't do?

No idea.  "Nobody would look at it" definitely includes me though.

In any case, water under the bridge.  The submitter did duly mark the
series as RFC, I don't see anything wrong in what he did apart from not
having testcases. :)

Paolo
