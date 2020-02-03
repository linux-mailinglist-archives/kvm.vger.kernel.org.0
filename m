Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCFC150395
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 10:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgBCJuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 04:50:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42173 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727225AbgBCJsm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 04:48:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580723321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3SgSFVMx/Ezsv5qsLAwM5EInWLOhNPJNOwKrGHDCpr0=;
        b=AVNMQbRkfdb2kBEqhBQ8/J9bkv0JfAWYJ0Y5g990k2xMpeoTOfcCal8UfsFjbYlN9rUsAd
        9QRGHRz4NyH5ohEnqz5OcVqMWMyXyhb1Xd1UgfIJirsQ0Ljv6YGaxcQc5qFw/ZJoiYlYT9
        K/0gNc5WE400aQSAxnSMe7WkMLb/qsg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-5TaXiVz9MKOMwLbVAZxfbw-1; Mon, 03 Feb 2020 04:48:37 -0500
X-MC-Unique: 5TaXiVz9MKOMwLbVAZxfbw-1
Received: by mail-wm1-f71.google.com with SMTP id z7so3809443wmi.0
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 01:48:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=3SgSFVMx/Ezsv5qsLAwM5EInWLOhNPJNOwKrGHDCpr0=;
        b=ETEqPXwItvgpNp8TWHAklDbZR4N5UY0iHtZTABkX5eU9RhAXPhCRPo8gYrML27ZSOi
         +aXlhLuRbQo3o5CCkNUldpuzY77VWM8AuEgYcKnMiE92NNSXiMWAxnDMNVkC4Ns//pxw
         W9cbqenz7HkTYf41SLg1NVHFK2YSm06BPKvX79QVIUwC71Vqo1RH9Z7NhfKHdpeRM2lg
         E5ht4Lj5aIoPMIr5QZ4AyJef35JAj1Ynu+SmEIErSb6EnXReYOQeVoQibDssobaMrijz
         7YHqcX3fpskbYSDtdu1jPYC08e0C+/b1d6tqtRpwKDll8Hsj1ySuBnLgz4vgds6Fdzx8
         ebeQ==
X-Gm-Message-State: APjAAAWyfmTO6ON+YxFEJSy5x+tgtsVnW0/RYzH4fgbTomjFka9oh/om
        tt6rYV8WplLH0sM2ogJh2Yfch2LlEMKhalv2Huo+TyEzgRQkz0rN+16jug1BPQz76wOtHBUJxQd
        VSoYHvGAfYuZy
X-Received: by 2002:a1c:451:: with SMTP id 78mr26769179wme.125.1580723316809;
        Mon, 03 Feb 2020 01:48:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqwKe/mFnwg44MggQEmr6tADJLSSeVxx0EmmhwIfpgZGVe/0/aRtIdZ6WRbo1jL3V/pl7Tkq9w==
X-Received: by 2002:a1c:451:: with SMTP id 78mr26769140wme.125.1580723316577;
        Mon, 03 Feb 2020 01:48:36 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id z25sm22532796wmf.14.2020.02.03.01.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 01:48:36 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: nVMX: set rflags to specify success in handle_invvpid() default case
In-Reply-To: <668e0827d62c489cbf52b7bc5d27ba9b@huawei.com>
References: <668e0827d62c489cbf52b7bc5d27ba9b@huawei.com>
Date:   Mon, 03 Feb 2020 10:48:35 +0100
Message-ID: <87zhe0ngr0.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> I'm sorry for reply in such a big day. I'am just backing from a really
> hard festival. :(

Let the force be with you guys! We really hope the madness is going to
be over soon. Stay safe!

-- 
Vitaly

