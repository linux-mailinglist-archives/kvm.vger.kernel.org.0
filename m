Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 259CC18CBA8
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 11:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgCTKda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 06:33:30 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:43965 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726527AbgCTKd3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 06:33:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584700408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v+O0TKG7RluopsB5+yUxCz0n+VTKJBvttmlO7TI6cs8=;
        b=Ygr0LUwBSWhEqqPRHto5Rj7i4QCE7yHzN8F78O3YTAduZWXoNd5IbrwIBjKwb2/wIelAjR
        6QdvaSwJrnQfNp8SG5UI9XvfR5f8TJWslBH8hjrV/0JPvK+Tum5Y9KUCNBWFuSb1E7y732
        O3VOaYH0Cl6+4sExWipcqMn/yCX9Mjg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-psLs4Iv9MweQX3JuhxeUdQ-1; Fri, 20 Mar 2020 06:33:27 -0400
X-MC-Unique: psLs4Iv9MweQX3JuhxeUdQ-1
Received: by mail-wr1-f69.google.com with SMTP id e10so647071wru.6
        for <kvm@vger.kernel.org>; Fri, 20 Mar 2020 03:33:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v+O0TKG7RluopsB5+yUxCz0n+VTKJBvttmlO7TI6cs8=;
        b=ugEyR7A5X8zBCF/67i3iBU8Fu2LGS41nYGuR3pPjZPNc3yxLyOr+7mtkGYFpbFM0KJ
         yKuVlecxh73GX7djaMk4f5Q194eI0+4ISZqFXBGdhokZk3kd7i1UBL+0EokutzTIt/N/
         U2a7bfY+G6KVYR1AOFv2LL17PMOwyBS7nG6Dmrhmmw7+Aw7R5HKuwWFm3Fe9kThO9d89
         RovtPlGSjc3pAxPuwRFjw5a0sEZJtasLGaT3ks+nXLpyaIMgO5ul8jr9hyiMs9RONfKO
         5R9YtcjvM7HZE+GOwx4e6eWFyA+ZgThk1zGDBnp99Jw4yrNttU5XPp9JVMzAO6A+RH45
         gRkg==
X-Gm-Message-State: ANhLgQ1YCDr33MsRm4qNeQGUr1DjBJBmFwB3UeGPlL2OwZ5OH56+H5MM
        10hhGP17XDXRC0KSbGRcKCj07e1FWw5WhDYE9TBF45vTNqaAuRNoI8sQt5s0U75+SU5qxkO76+/
        p6CAj4t8akE9R
X-Received: by 2002:a7b:ce81:: with SMTP id q1mr9754274wmj.156.1584700406056;
        Fri, 20 Mar 2020 03:33:26 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vt/QEmQN3xweTWPa2FLy03BaS+TOE+v1glMmu3TqcsJub4MqPOEiz7Nyx/IluChnKlphGwSIQ==
X-Received: by 2002:a7b:ce81:: with SMTP id q1mr9754249wmj.156.1584700405771;
        Fri, 20 Mar 2020 03:33:25 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id 61sm8303356wrn.82.2020.03.20.03.33.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 03:33:25 -0700 (PDT)
Subject: Re: WARNING in vcpu_enter_guest
To:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     syzbot <syzbot+00be5da1d75f1cc95f6b@syzkaller.appspotmail.com>,
        bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, rkrcmar@redhat.com,
        syzkaller-bugs@googlegroups.com, vkuznets@redhat.com,
        wanpengli@tencent.com, x86@kernel.org
References: <000000000000f965b8059877e5e6@google.com>
 <00000000000081861f05a132b9cd@google.com>
 <20200319144952.GB11305@linux.intel.com>
 <20be9560-fce7-1495-3a83-e2b56dbc2389@redhat.com>
 <20200319173549.GC11305@linux.intel.com>
 <20200319173927.GD11305@linux.intel.com>
 <cd32ee6d-f30d-b221-8126-cf995ffca52e@redhat.com>
 <87k13f516q.fsf@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6686bde5-c1e8-5be5-f27a-61403c419a91@redhat.com>
Date:   Fri, 20 Mar 2020 11:33:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87k13f516q.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/03/20 01:18, Thomas Gleixner wrote:
>> No, it is possible to do that depending on the clock setup on the live
>> migration source.  You could cause the warning anyway by setting the
>> clock to a very high (signed) value so that kernel_ns + kvmclock_offset
>> overflows.
>
> If that overflow happens, then the original and the new host have an
> uptime difference in the range of >200 hundreds of years. Very realistic
> scenario...
> 
> Of course this can happen if you feed crap into the interface, but do
> you really think that forwarding all crap to a guest is the right thing
> to do?
> 
> As we all know the hypervisor orchestration stuff is perfect and would
> never feed crap into the kernel which happily proliferates that crap to
> the guest...

But the point is, is there a sensible way to detect it?  Only allowing
>= -2^62 and < 2^62 or something like that is an ad hoc fix for a
warning that probably will never trigger outside fuzzing.  I would
expect that passing the wrong sign is a more likely mistake than being
off by 2^63.

This data is available everywhere between strace, kernel tracepoints and
QEMU tracepoints or guest checkpoint (live migration) data.  I just
don't see much advantage in keeping the warning.

Paolo

