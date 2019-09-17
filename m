Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28067B4FE7
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 16:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbfIQOHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 10:07:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34746 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726297AbfIQOHU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 10:07:20 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1E5BF33026D
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 14:07:20 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id v13so1343831wrq.23
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 07:07:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jS+ZWi+aIzVL4RGXZzRns8oVj2lE4iWxT+LDZNVf+Zo=;
        b=ejtuak6ZHboAlK4/o1T1tgLARMbHhoZEKACcGIyXYCKHatkUWg08OUi4GoYQYkZzsr
         TJsiY265144z0mFcDVfohYursl5edlhFJEm1wA5c+VCnTjdMF+ZATC7co/JtLGG41cdl
         euw1aupdkW4QstHXMzpmqJCKd5kVW2IT1UtCXCtZPe7Swg4KbsxVgKcRDgHgEg3cJ3pJ
         HRFemTIqFplHIof81A1KopZrxNZURJFlvLAq4sZBqEQ+9mSP+QhOzbiAD5fUeab68MZZ
         apN+1bDy0Ah4Dzb3jFPyewlMUXpWBljNtR1h9GWFROZiaAowYUIi/sa0EucIemDK0ppo
         RU2w==
X-Gm-Message-State: APjAAAVafa7N0NfbQq8h69AS59YwHxh4D+Zg1t3rJROygUMxa6RECdbo
        fVaCseVjwiJVxckUKH0dSUUVYB/hLODGZ+vkRz8JyaJnF2LNE3w4bmTcW7ls6Ztink0Md3lwD9v
        p/s5GhTIzZnKh
X-Received: by 2002:a5d:5403:: with SMTP id g3mr3107313wrv.338.1568729238785;
        Tue, 17 Sep 2019 07:07:18 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw8uoge2CoGr9jKjogtJP8t5aSiNDgVit1M/+Wy752+dibN7SEQXSGxTmF3SRmYokSmnGgUoQ==
X-Received: by 2002:a5d:5403:: with SMTP id g3mr3107294wrv.338.1568729238531;
        Tue, 17 Sep 2019 07:07:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id h17sm4148586wme.6.2019.09.17.07.07.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Sep 2019 07:07:17 -0700 (PDT)
Subject: Re: [PATCH 1/3] cpu/SMT: create and export cpu_smt_possible()
To:     Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org,
        the arch/x86 maintainers <x86@kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Roman Kagan <rkagan@virtuozzo.com>
References: <20190916162258.6528-1-vkuznets@redhat.com>
 <20190916162258.6528-2-vkuznets@redhat.com>
 <CALMp9eQP7Dup+mMuAiShNtH754R_Wwuvf63hezygh3TGR=a9rg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <4704aac9-cac2-f04d-8344-6642432c31e2@redhat.com>
Date:   Tue, 17 Sep 2019 16:07:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQP7Dup+mMuAiShNtH754R_Wwuvf63hezygh3TGR=a9rg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/09/19 19:16, Jim Mattson wrote:
>> KVM needs to know if SMT is theoretically possible, this means it is
>> supported and not forcefully disabled ('nosmt=force'). Create and
>> export cpu_smt_possible() answering this question.
> It seems to me that KVM really just wants to know if the scheduler can
> be trusted to avoid violating the invariant expressed by the Hyper-V
> enlightenment, NoNonArchitecturalCoreSharing. It is possible to do
> that even when SMT is enabled, if the scheduler is core-aware.
> Wouldn't it be better to implement a scheduler API that told you
> exactly what you wanted to know, rather than trying to infer the
> answer from various breadcrumbs?

Yes, however that scheduler API could also rely on something like
cpu_smt_possible(), at least in the case where core scheduling is not
active, so this is still a step in the right direction.

Paolo
