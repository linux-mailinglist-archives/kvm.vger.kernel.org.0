Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99C8DFDAD4
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 11:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfKOKKU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 05:10:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22725 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726930AbfKOKKT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 05:10:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573812618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=t1851B8N941Rz7PPSqrzu1Q1EGtwq1CeS2EBtMeagjk=;
        b=PaCd/owgCiMcq4Rh/S3z8Y9AdcOPm+wY9a1scCZY3TY0urgqtfRELyfInnaa9eBc7/G3UW
        WNPyDNBIOUP+5auwcRTXOa632Gt/pHNQpLiHc5jjyZxYUPx6Oya0UFbLDRtBDBjRLOx0Vb
        v6iPPb51kV26gnno5unAHMZDlhHrd3E=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-qnaw7-WBM4uKysHpqn-_Og-1; Fri, 15 Nov 2019 05:10:17 -0500
Received: by mail-wr1-f70.google.com with SMTP id 4so7404166wrf.19
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 02:10:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4U1nnbDS2kVHJEcmz7eSjL6TcFduQzcJVf/OFeeGAfc=;
        b=o5wkM38bhTz8lA7zk1XqfqKW8f3Kit4mS6ecpzZSeFr41Yps9uEGpP8Ahm9+W7mlEw
         CBw5X0cs21mfDUlbWhTJBUw663Rmb0QOhXT+wE7IxlKVx5oGbTwIVA+LCV6ewdxJE4PT
         zaszg/rJvGFsesrsLSJ2Bv+nxo8/thw5eZk77uivQ3PNqdhCnG8uhGP7GrTI9rCeJjYP
         3aby9SSfK7NRBZRMfd+H7UDmtaQ1a7VSJDSOFqBwarEGYKSBg5/XugyBdzsa1CpjitvQ
         1iwiFfzDFTCOaKd2ptqLTkMQAg9taIXQQihBhdrLhDzmYkIa5FmbQ/sDDJ22dAp5xgHY
         5E3w==
X-Gm-Message-State: APjAAAVwe1n5Cyyn81w6NI+k2pga6SnADTg3UKdh/q8GdLWX0t317dFq
        YHgjBXa+UdzJo2BcQ8h0muwwvc3MrwzuEeOTV3CYRNTpRDrraKTH0nnXwzdhmWh1gnD73a47J1G
        vXWqoEOlyDULF
X-Received: by 2002:a7b:c743:: with SMTP id w3mr14127384wmk.165.1573812615826;
        Fri, 15 Nov 2019 02:10:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqy4+YFJJa1zYa8p4uLPA490Q+SVHWwfndQ8NVq+KvtXr8ExWMuCpRO+Fq2h1O6L/ggdjTt0CA==
X-Received: by 2002:a7b:c743:: with SMTP id w3mr14127261wmk.165.1573812614644;
        Fri, 15 Nov 2019 02:10:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a15b:f753:1ac4:56dc? ([2001:b07:6468:f312:a15b:f753:1ac4:56dc])
        by smtp.gmail.com with ESMTPSA id a11sm9640787wmh.40.2019.11.15.02.10.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 02:10:14 -0800 (PST)
Subject: Re: [PATCH v2 05/16] KVM: VMX: Drop initialization of
 IA32_FEATURE_CONTROL MSR
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
References: <20191021234632.32363-1-sean.j.christopherson@intel.com>
 <20191022000820.1854-1-sean.j.christopherson@intel.com>
 <59cbc79a-fb06-f689-aa24-0ba923783345@redhat.com>
 <20191022151622.GA2343@linux.intel.com>
 <20191114183453.GI24045@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b0148465-37ae-15c0-9520-8061c7983002@redhat.com>
Date:   Fri, 15 Nov 2019 11:10:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191114183453.GI24045@linux.intel.com>
Content-Language: en-US
X-MC-Unique: qnaw7-WBM4uKysHpqn-_Og-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/11/19 19:34, Sean Christopherson wrote:
> On Tue, Oct 22, 2019 at 08:16:22AM -0700, Sean Christopherson wrote:
>> On Tue, Oct 22, 2019 at 12:51:01PM +0200, Paolo Bonzini wrote:
>>> On 22/10/19 02:08, Sean Christopherson wrote:
>>>> Remove the code to initialize IA32_FEATURE_CONTROL MSR when KVM is
>>>> loaded now that the MSR is initialized during boot on all CPUs that
>>>> support VMX, i.e. can possibly load kvm_intel.
>>>>
>>>> Reviewed-by: Jim Mattson <jmattson@google.com>
>>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>>> ---
>>>>  arch/x86/kvm/vmx/vmx.c | 48 +++++++++++++++++------------------------=
-
>>>>  1 file changed, 19 insertions(+), 29 deletions(-)
>>>
>>> I am still not sure about this...  Enabling VMX is adding a possible
>>> attack vector for the kernel, we should not do it unless we plan to do =
a
>>> VMXON.
>>
>> An attacker would need arbitrary cpl0 access to toggle CR4.VMXE and do
>> VMXON (and VMLAUNCH), would an extra WRMSR really slow them down?
>>
>> And practically speaking, how often do you encounter systems whose
>> firmware leaves IA32_FEATURE_CONTROL unlocked?

I honestly don't know... always on nested virtualization probably
doesn't count as an answer. :)

From a totally abstract point of view I like the idea of KVM being an
independent driver and thus the only place that touches VMX stuff
(including the relevant bit in IA32_FEATURE_CONTROL).  But I understand
that this doesn't really make any concrete difference, so I guess you
can go ahead with this.

>>> Why is it so important to operate with locked
>>> IA32_FEATURE_CONTROL (so that KVM can enable VMX and the kernel can
>>> still enable SGX if desired).
>>
>> For simplicity.  The alternative that comes to mind is to compute the
>> desired MSR value and write/lock the MSR on demand, e.g. add a sequence
>> similar to KVM's hardware_enable_all() for SGX, but that's a fair amount
>> of complexity for marginal benefit (IMO).
>>
>> If a user really doesn't want VMX enabled, they can clear the feature bi=
t
>> via the clearcpuid kernel param.=20
>>
>> That being said, enabling VMX in IA32_FEATURE_CONTROL if and only if
>> IS_ENABLED(CONFIG_KVM) is true would be an easy enhancement.
>=20
> Paolo, any follow up thoughts on this approach?

Yes, that would be a simple enhancement, useful at least for
documentation purpose.

Paolo

