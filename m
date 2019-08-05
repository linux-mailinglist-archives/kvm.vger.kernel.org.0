Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B22F5820B2
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 17:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbfHEPsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 11:48:19 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46298 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbfHEPsT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 11:48:19 -0400
Received: by mail-wr1-f67.google.com with SMTP id z1so84909043wru.13
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 08:48:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+APdg992bZ0oRRkRFf34r5YQsAc0QiyZb6EG2cGQrZc=;
        b=WibwFZGsrthBWQAn5Pm1W6btipPYNDtCCgZmv06niXiIEfVDYZmqv2WvJcI6C7LY55
         FnrjnAa6zhIYXJLjCyCIWYYbfU1aDbDoyQalJ8JBhpKyyHjoNm67gpiISz7NfxKj4TRO
         J6EjKeFukm1Pk/DY2A8nif9ORhzopAdxMcFMWy7aRAeEp5LByihJJS/Yn7XhLdX53aP8
         KoGIJMclcCHGYHoFxUk+hEt4HCTuXtnIX2l0MiI3NM95jQcvxtv7b+jd9A3GPyQ0daTd
         GC7/sz1+TB5WGdRNpdnU31aoLDFB3/YzelFd6P29z+zrtXE3jB3SIXc+F7zBG6e1+4k3
         Ml9A==
X-Gm-Message-State: APjAAAViu+fLCyCGXHdhpUBjETD+sS+w0t3ljogmOlJmXvALb67dya4x
        SRFGs+tWm2FxxjNWsqkjIQStUQ==
X-Google-Smtp-Source: APXvYqz4HdsMgydpHvuXq8L97rT6K5yfgYcAxLS8myU32TmmmvCZsdQRCZXIj0/aehnLvGi/WfQMNw==
X-Received: by 2002:a5d:5647:: with SMTP id j7mr20893476wrw.191.1565020097350;
        Mon, 05 Aug 2019 08:48:17 -0700 (PDT)
Received: from [192.168.178.40] ([151.21.165.91])
        by smtp.gmail.com with ESMTPSA id c11sm144380104wrq.45.2019.08.05.08.48.16
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 08:48:16 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] KVM: remove kvm_arch_has_vcpu_debugfs()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Radim Krm <rkrcmar@redhat.com>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <20190731185556.GA703@kroah.com>
 <6ddc98b6-67d9-1ea4-77d8-dcaf0b5a94cc@redhat.com>
 <20190805153605.GA27752@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2da5d82a-e88c-903a-1f8b-338f06c76d6b@redhat.com>
Date:   Mon, 5 Aug 2019 17:48:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805153605.GA27752@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/08/19 17:36, Greg KH wrote:
> On Sat, Aug 03, 2019 at 08:23:25AM +0200, Paolo Bonzini wrote:
>> On 31/07/19 20:55, Greg KH wrote:
>>> There is no need for this function as all arches have to implement
>>> kvm_arch_create_vcpu_debugfs() no matter what, so just remove this call
>>> as it is pointless.
>>>
>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>> Cc: "Radim Krm" <rkrcmar@redhat.com>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> Cc: Ingo Molnar <mingo@redhat.com>
>>> Cc: Borislav Petkov <bp@alien8.de>
>>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>>> Cc: <x86@kernel.org>
>>> Cc: <kvm@vger.kernel.org>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>>> v2: new patch in the series
>>
>> Let's remove kvm_arch_arch_create_vcpu_debugfs too for non-x86 arches.
>>
>> I'll queue your 2/2.
> 
> Great, so what about 1/2?  I have no objection to your patch for this.

I'll queue my own replacement of 1/2, together with your 2/2.  Both
should reach Linus later this week.

Paolo

