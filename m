Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E03B15544B
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 10:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgBGJIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 04:08:52 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20028 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726417AbgBGJIv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 04:08:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581066531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vwqq6UkPRy0m2wWurqdxwHhAqRvptisJI/4Mk62bZu0=;
        b=BNo7XZu3Gj3labhyewhH43iTCXwzrPxwTMfQYJNjvqr3op3EL/eLmlVld0q7xVg0D6bMHH
        tDG1+VIBjj9nQS6DwJ+IG68NFuBW4dh7ezkmEGKXSpsqCs6ayTsBH5WGu82OSdnVjsk9vD
        DN6nGJ4PZiJC2ajfiNSn4h5N19lVli0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-PjuyjBP1OF28RQqI1TgJsQ-1; Fri, 07 Feb 2020 04:08:49 -0500
X-MC-Unique: PjuyjBP1OF28RQqI1TgJsQ-1
Received: by mail-wr1-f72.google.com with SMTP id u18so928181wrn.11
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 01:08:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Vwqq6UkPRy0m2wWurqdxwHhAqRvptisJI/4Mk62bZu0=;
        b=IdiwP2cCGSj/Zck57akEqAQaZqIs7wVGeb44LC7U6qCKjFJ/cQ5plB86mY6e6cH4j+
         2U8jhAjRAoLX64UHfceJLNdaZzpPMs1fiTVp8cjXYiMubQpjQUpidmMW+8jB5oYkjAVI
         BpfTki7CJdIkXIZj7tKWIsO91Lqh+cwdShA4ZLRYT71SWnps0Ze+zOGy+jGr07Qwzr54
         g6bab4AwwUuN8akASwR7NLzl3cUdnmrwgpPo9b4wxzNudi8KQ77jMERPrS1eyqZkEtDK
         +Z1Q2T8TBCK9lazUTXTtcxWqrxIYNPH/LwruG+yangjAF7EEZGBfRajyhQ4tmGjh67nf
         uUaw==
X-Gm-Message-State: APjAAAUfpBdrhL5DTwsVYhL6BtsEPyWdcUkkTikxuBKbuGFYOQuLGgZX
        hKBE9s0qlxtkLX8PWRWS+eqSCiVtMi2odDs3eHoaQ7iLDQOev5Hoai3d0TRvyE2lfY8RplfD6EL
        WVftil1DImt+b
X-Received: by 2002:adf:e550:: with SMTP id z16mr3605811wrm.5.1581066528540;
        Fri, 07 Feb 2020 01:08:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqxS7NU/AK8OFWXcmEpnR0rOnuMo0hO1VFe1OHOo6u4Q1IgKjpWDlOrdnfcJUaJLg8zDQuLVrQ==
X-Received: by 2002:adf:e550:: with SMTP id z16mr3605794wrm.5.1581066528350;
        Fri, 07 Feb 2020 01:08:48 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 11sm2804255wmb.14.2020.02.07.01.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 01:08:47 -0800 (PST)
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
In-Reply-To: <736f8beabe2046fdab0631f28f9d2b1f@huawei.com>
References: <736f8beabe2046fdab0631f28f9d2b1f@huawei.com>
Date:   Fri, 07 Feb 2020 10:08:46 +0100
Message-ID: <87eev6g3xd.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> Hi:
> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
>>linmiaohe <linmiaohe@huawei.com> writes:
>>
>>> About nWMX.
>>> When nested_vmx_handle_enlightened_vmptrld() return 0, it do not 
>>> inject any exception or set rflags to Indicate VMLAUNCH instruction 
>>> failed and skip this instruction. This would cause nested_vmx_run() 
>>
>>Yes, it seems it can. 
>>
>>nested_vmx_handle_enlightened_vmptrld() has two possible places where it can fail:
>>
>>kvm_vcpu_map() -- meaning that the guest passed some invalid GPA.
>>revision id check -- meaning that the supplied eVMCS is unsupported/garbage.
>>
>>I think the right behavior would be to nested_vmx_failInvalid() in both these cases. We can also check what genuing Hyper-V does.
>>
>
> Many thanks for your reply. I think this would be a problem too. And would you like to fix this potential problem? I have no idea
> how to fix this correctly...

Yes,

let me check what happens on Hyper-V and I'll send a patch. The problem
should not be that severe as it only affect misbehaving L1 hypervisors.

-- 
Vitaly

