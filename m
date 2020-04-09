Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0281A320B
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 11:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgDIJnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 05:43:35 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27251 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726773AbgDIJnf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Apr 2020 05:43:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586425415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nIzy0tnj6FqxJz87TqjmoYX4nTo+jUF+UzNkvXq35po=;
        b=SWVeLr8Mw9d+Vf7DX+yL47ZVmVs7ldLf3IR5TJvD3tWW6DwLTBcSDy8Z+sbENUr8kf4L5F
        qP4fpbim5cqZR1roBqpLZ2UXWnorGBnv1p8iH279YzYOYr6GvZM+te5jip8JR0lhAt6yc7
        XEaKFKKHoYTxBqJmbMWk4zxgMgemuew=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-QtzPjVMDN2OU8_bs4P_d9A-1; Thu, 09 Apr 2020 05:43:33 -0400
X-MC-Unique: QtzPjVMDN2OU8_bs4P_d9A-1
Received: by mail-wr1-f70.google.com with SMTP id t8so151254wrq.22
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 02:43:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nIzy0tnj6FqxJz87TqjmoYX4nTo+jUF+UzNkvXq35po=;
        b=ZPdXgAb4Nx3d38wfj27xtb6eR5cmNnTYomEU3j3bd4pxVC+n5kYJPUblr5vAn9Sun2
         NJiH12q77S/Rnuz6iEekdlYaZRWMtslmDTr1Dr0hjhK/i5N8VvRa/FduOK3mtrlG3Y3d
         19golR6/udq+KB768HMLZtNsiuM3qv4Pjf+IlmXxn2zUxHp8kOCYV1irbgUgw6JvuXyL
         G9u2VobkrABPniBzZNQownQ0Ls2VgEy120amREYgsmkQ1BCihYh/EXaGUJjKEbAVdDAd
         fC3ViITSsAEU+Y00pGqH+h3HAkdGtDHGxc+nWISBg3K5K8os4mudk4jVOjKln1Q7UkW0
         S6eQ==
X-Gm-Message-State: AGi0PuZLzdg6RYhf5innOZOJsOiq+kY2RDn92sv4Bk0p0nsDLYG8mNhV
        PloDKVrHjQg2tOZl5grOd1Ni0Kh+CuKqoKvmqIcX0bh+rd6OHyeeD2+uWv5miQCiql7Y5sqRc8F
        Jew5nodnidXkO
X-Received: by 2002:a1c:a7d7:: with SMTP id q206mr5695586wme.45.1586425411855;
        Thu, 09 Apr 2020 02:43:31 -0700 (PDT)
X-Google-Smtp-Source: APiQypJgQiZCrWZvCGiHqYLqjts+lmOUoOTw70VVOHDzOH/wMxfRJcVDU494OZ3lliAXWnRamte4kQ==
X-Received: by 2002:a1c:a7d7:: with SMTP id q206mr5695574wme.45.1586425411623;
        Thu, 09 Apr 2020 02:43:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:bddb:697c:bea8:abc? ([2001:b07:6468:f312:bddb:697c:bea8:abc])
        by smtp.gmail.com with ESMTPSA id g3sm25430861wrw.47.2020.04.09.02.43.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 02:43:31 -0700 (PDT)
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
References: <20200407172140.GB64635@redhat.com>
 <772A564B-3268-49F4-9AEA-CDA648F6131F@amacapital.net>
 <87eeszjbe6.fsf@nanos.tec.linutronix.de>
 <ce81c95f-8674-4012-f307-8f32d0e386c2@redhat.com>
 <874ktukhku.fsf@nanos.tec.linutronix.de>
 <274f3d14-08ac-e5cc-0b23-e6e0274796c8@redhat.com>
 <20200408153413.GA11322@linux.intel.com>
 <ce28e893-2ed0-ea6f-6c36-b08bb0d814f2@redhat.com>
 <87d08hc0vz.fsf@nanos.tec.linutronix.de>
 <CALCETrWG2Y4SPmVkugqgjZcMfpQiq=YgsYBmWBm1hj_qx3JNVQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <47a7593e-e035-1b48-c6d7-cd6f78a2f6e2@redhat.com>
Date:   Thu, 9 Apr 2020 11:43:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CALCETrWG2Y4SPmVkugqgjZcMfpQiq=YgsYBmWBm1hj_qx3JNVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/04/20 06:50, Andy Lutomirski wrote:
> The big problem is that #VE doesn't exist on AMD, and I really think
> that any fancy protocol we design should work on AMD.  I have no
> problem with #VE being a nifty optimization to the protocol on Intel,
> but it should *work* without #VE.

Yes and unfortunately AMD does not like to inject a non-existing
exception.  Intel only requires the vector to be <=31, but AMD wants the
vector to correspond to an exception.

However, software injection is always possible and AMD even suggests
that you use software injection for ICEBP and, on older processors, the
INT instruction.

Paolo

