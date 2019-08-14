Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6453B8D0D2
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 12:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfHNKh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 06:37:58 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45689 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbfHNKhz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 06:37:55 -0400
Received: by mail-wr1-f68.google.com with SMTP id q12so20326437wrj.12
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2019 03:37:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oVgEV1g/UPelVsZcKcw9nOSje8rWLBWULtBtVoDSjso=;
        b=CzVFR0y/86LA4fF5/Z5odDRPBn5vmU2KBykJjbb2f7ePweZx1iOks0KWDSthsxD2YC
         SvDFvo0IEeJO0HlNiglcZh73jyD78xgiJLJLao5URI4nOOhRCj7qGO6J8J+g19JWV3AU
         qcVG1P75mbAgttfPdIwkSxzRn+uKllgYToTsXfS1bl4lPYM6vQ9unQoGVzZlfcyeAhoq
         Sj4MfXdZ4Mp1cp7inFZANQptowAlyt15XWGPWqqPpf33fttbbYBDeEES5rs0UWAeHao7
         a6dDb3jKirAYVmkxanM2xb4yfDy3/c31kKyRpgjjBxNtcOKYhrrmE7h55imml9B7af5j
         ic2w==
X-Gm-Message-State: APjAAAUHZmbdNGK6HL2in7aVp3vptfZRaDKos6Ryx3RcKlC2weDrqagX
        OGeYkRuL/FRH7vWNYhpnEugECA==
X-Google-Smtp-Source: APXvYqxPmIpqR9ZiKdjUNFmTa5cEt4XtlN46WXuRKyGyJO3GD/9oZYwpSywYiNiWytLJB09hSTpO/w==
X-Received: by 2002:adf:ed4a:: with SMTP id u10mr55236024wro.284.1565779072995;
        Wed, 14 Aug 2019 03:37:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:2cae:66cd:dd43:92d9? ([2001:b07:6468:f312:2cae:66cd:dd43:92d9])
        by smtp.gmail.com with ESMTPSA id a17sm2983732wmm.47.2019.08.14.03.37.51
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 03:37:52 -0700 (PDT)
Subject: Re: [RFC PATCH v6 01/92] kvm: introduce KVMI (VM introspection
 subsystem)
To:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
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
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>,
        =?UTF-8?Q?Mircea_C=c3=aerjaliu?= <mcirjaliu@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-2-alazar@bitdefender.com>
 <20190812202030.GB1437@linux.intel.com>
 <5d52a5ae.1c69fb81.5c260.1573SMTPIN_ADDED_BROKEN@mx.google.com>
 <5fa6bd89-9d02-22cd-24a8-479abaa4f788@redhat.com>
 <20190813150128.GB13991@linux.intel.com>
 <5d53d8d1.1c69fb81.7d32.0bedSMTPIN_ADDED_BROKEN@mx.google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e00a35b2-74ca-41b8-77a0-2cd37f55a8b6@redhat.com>
Date:   Wed, 14 Aug 2019 12:37:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5d53d8d1.1c69fb81.7d32.0bedSMTPIN_ADDED_BROKEN@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/08/19 11:48, Adalbert Lazăr wrote:
>> Why does closing the socket require destroying the kvmi object?  E.g. can
>> it be marked as defunct or whatever and only fully removed on a synchronous
>> unhook from userspace?  Re-hooking could either require said unhook, or
>> maybe reuse the existing kvmi object with a new socket.
> Will it be better to have the following ioctls?
> 
>   - hook (alloc kvmi and kvmi_vcpu structs)
>   - notify_imminent_unhook (send the KVMI_EVENT_UNHOOK event)
>   - unhook (free kvmi and kvmi_vcpu structs)

Yeah, that is nice also because it leaves the timeout policy to
userspace.  (BTW, please change references to QEMU to "userspace").

Paolo
