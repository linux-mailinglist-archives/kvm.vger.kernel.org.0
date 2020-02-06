Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAE11543A2
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 13:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbgBFMAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 07:00:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21188 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727478AbgBFMAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 07:00:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580990407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v8ERAvS/lPT4MzKVP8d82U8DllNPl13YWQpK8VIBCME=;
        b=NUnkZHqCOT3a5JJVzbrGdLKHfmjeM/BZtVovtdYzcNKd1wiuaglZMSZttRCJ/EviVUtXZx
        BNWLqD2nB5sGUtLxHbQ61cTCeVFXVDNtldJn5VmQUiZ0MYcvXs9XLYniBWP4Nj6R2vXfKT
        lA+wAdhY5MDo+L4dI0Sbr+MCxM+loZ0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-6BSgrSl8M1iWD3z1mCR7NA-1; Thu, 06 Feb 2020 07:00:05 -0500
X-MC-Unique: 6BSgrSl8M1iWD3z1mCR7NA-1
Received: by mail-wr1-f70.google.com with SMTP id z15so3296664wrw.0
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 04:00:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=v8ERAvS/lPT4MzKVP8d82U8DllNPl13YWQpK8VIBCME=;
        b=dUwuXqvIkaFrdXTQFZlPWOkrsX3Qwk54qoEhZ563A7JHuQKutTf+8qnNyRSB9YPIMJ
         0gFPFulIE5j7zc9cATWbGPEUTjB8WwPZK2MYDSG3O2yJzk5Ixv+EJiMIFEggA7HgqMqg
         mrFoalNUW3ffGAJudr+KmRP2o6LXkUE/wAr0VEnIhx03pEZKPb8Ebom7xWOOs0SX0ylG
         DXN3dIX2dlahKnsDA6r8cedCYHW5yl2P7f+JST4eyOG2Bne5dn+4wwOo/2d7bajuBBn8
         xc12DLUeGaGk3xmx+yEAh07akJwWQiUItmOEJTbSaIfHc+1QY9nqIktMkm/0q0IJZ4nu
         SFTg==
X-Gm-Message-State: APjAAAWRkTXcVXzZS4KWgbVtee12ouXaXTGUECGVFY4O05+I/x9UOAcj
        jMfPNxi+baJuJmAXh5bHcRaNWL5+td9MQ6HogC9RmCq2Bu4/QYquKRaLxjZxQphfPA9uwaSaJSa
        tCsX3eGY7XCad
X-Received: by 2002:a5d:61d1:: with SMTP id q17mr3580779wrv.156.1580990404615;
        Thu, 06 Feb 2020 04:00:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqwC6q32rm004as5CvA+zkHRxLROqM8kNia/xuwpoa1Vv8rJWzIg/lFfBMvWPPA43PDHB1G0+Q==
X-Received: by 2002:a5d:61d1:: with SMTP id q17mr3580734wrv.156.1580990404214;
        Thu, 06 Feb 2020 04:00:04 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id x21sm3296915wmi.30.2020.02.06.04.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 04:00:03 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar\@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson\@intel.com" <sean.j.christopherson@intel.com>,
        "wanpengli\@tencent.com" <wanpengli@tencent.com>,
        "jmattson\@google.com" <jmattson@google.com>,
        "joro\@8bytes.org" <joro@8bytes.org>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "mingo\@redhat.com" <mingo@redhat.com>,
        "bp\@alien8.de" <bp@alien8.de>, "hpa\@zytor.com" <hpa@zytor.com>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86\@kernel.org" <x86@kernel.org>
Subject: Re: [Question] some questions about vmx
In-Reply-To: <70c0804949234ad8b6c1834cc9b109ca@huawei.com>
References: <70c0804949234ad8b6c1834cc9b109ca@huawei.com>
Date:   Thu, 06 Feb 2020 13:00:02 +0100
Message-ID: <877e10gc3h.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> About nWMX.
> When nested_vmx_handle_enlightened_vmptrld() return 0, it do not inject any exception or set rflags to
> Indicate VMLAUNCH instruction failed and skip this instruction. This would cause nested_vmx_run()
> return 1 and resume guest and retry this instruction. When the error causing nested_vmx_handle_enlightened_vmptrld()
> failed can't be handled, would deadloop ouucr ?

Yes, it seems it can. 

nested_vmx_handle_enlightened_vmptrld() has two possible places where it
can fail:

kvm_vcpu_map() -- meaning that the guest passed some invalid GPA.
revision id check -- meaning that the supplied eVMCS is
unsupported/garbage.

I think the right behavior would be to nested_vmx_failInvalid() in both
these cases. We can also check what genuing Hyper-V does.

-- 
Vitaly

