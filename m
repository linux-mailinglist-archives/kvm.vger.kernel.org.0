Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A43C17B984
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 10:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgCFJo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 04:44:59 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25553 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726010AbgCFJo7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Mar 2020 04:44:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583487898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WbxIdYhTTjgVlUuu7acZggNhYjFYj5XT7w4bg+bKCpo=;
        b=Onj9kiOE+6sRUX8Pyw9bTJxHkGmbprAHh7OgMhFJLqpmEujvUAz1J4NJPP+9nXH/DU0XrI
        otuPBdFd2RhVlRsKe1B9xqBIx+6FvjE5CMbhrpn0QFLa2IU4bQvtSK7p3j7cTUFT2k3AXg
        hzdc1CySqRFEqpu3r/o7QQ7VZhl7Z3U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-pywpoBYVNSCrqm11C3pF_Q-1; Fri, 06 Mar 2020 04:44:57 -0500
X-MC-Unique: pywpoBYVNSCrqm11C3pF_Q-1
Received: by mail-wr1-f72.google.com with SMTP id n7so767813wro.9
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2020 01:44:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=WbxIdYhTTjgVlUuu7acZggNhYjFYj5XT7w4bg+bKCpo=;
        b=d45rDXFbNxJcAP7ncLoxwjs5Rr0RYuZkCMchaWiYLyae+YyfI7Mi4716dYKu/fbhf5
         uaGZGh/cT22cKBtYL3X5NkuNN0gPWNOiromdrY/l/mkO77Y1dfyDVYm5GwCsnrIwhVOB
         MQiluzDSriLPC+HiFEW0YiO01vAJQouETAxb5DFY93k2oTP3EwSiNurWd84+5KwVwJrc
         pq0+D8nT28EgQrqH5VMEx8emDTf26ft/kjs1regxifaaC4DAMYjHlTAfvpIh9MErsna6
         XFbawWpNanrjcZnlOZJWh2bccF0FDH6xVLlqW8hrGjVxBurTZpt1nhe2VKkbE6GdBRxz
         rWuw==
X-Gm-Message-State: ANhLgQ09sFLpJGq69Wt/N4RUh9M+fdJEp2pm+jEDg0+TQNBAD1QXFzqx
        //R9yE62zT09yVZk/d4BqQ4b2KUgRhMKTvZyLlI+vDxnhhtr1uYTPBpwNlAXSFRtmKYEz7QawiP
        fuLVJ9lS2Kz67
X-Received: by 2002:a1c:7919:: with SMTP id l25mr3019498wme.135.1583487895751;
        Fri, 06 Mar 2020 01:44:55 -0800 (PST)
X-Google-Smtp-Source: ADFU+vvxjBVBTvy10EKYcXioKSADNfuDaKvIrnd4UdrjOTMe11WoR4rkgftir/YuAN37Jpblb9nk5g==
X-Received: by 2002:a1c:7919:: with SMTP id l25mr3019483wme.135.1583487895545;
        Fri, 06 Mar 2020 01:44:55 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id p15sm12572147wma.40.2020.03.06.01.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 01:44:54 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        linmiaohe <linmiaohe@huawei.com>
Cc:     "rkrcmar\@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson\@intel.com" <sean.j.christopherson@intel.com>,
        "jmattson\@google.com" <jmattson@google.com>,
        "joro\@8bytes.org" <joro@8bytes.org>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "mingo\@redhat.com" <mingo@redhat.com>,
        "bp\@alien8.de" <bp@alien8.de>, "hpa\@zytor.com" <hpa@zytor.com>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86\@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] KVM: VMX: Use wrapper macro ~RMODE_GUEST_OWNED_EFLAGS_BITS directly
In-Reply-To: <1e3f7ff0-0159-98e8-ba21-8806c3a14820@redhat.com>
References: <f1b01b4903564f2c8c267a3996e1ac29@huawei.com> <1e3f7ff0-0159-98e8-ba21-8806c3a14820@redhat.com>
Date:   Fri, 06 Mar 2020 10:44:53 +0100
Message-ID: <87sgiles16.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 06/03/20 03:17, linmiaohe wrote:
>> Define a macro RMODE_HOST_OWNED_EFLAGS_BITS for (X86_EFLAGS_IOPL |
>> X86_EFLAGS_VM) as suggested by Vitaly seems a good way to fix this ?
>> Thanks.
>
> No, what if a host-owned flag was zero?  I'd just leave it as is.
>

I'm not saying my suggestion was a good idea but honestly I'm failing to
wrap my head around this. The suggested 'RMODE_HOST_OWNED_EFLAGS_BITS'
would just be a define for (X86_EFLAGS_IOPL | X86_EFLAGS_VM) so
technically the patch would just be nop, no?

-- 
Vitaly

