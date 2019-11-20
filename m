Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65A481039FA
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 13:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729707AbfKTMVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 07:21:42 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57342 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729133AbfKTMVm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Nov 2019 07:21:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574252501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0y+Va4NBLdVxptKCFSjrSqw/jstEexITDbBbQwJO4B4=;
        b=Xyug8OkG/mvCkH7/dqLfjvdMuxYCAf4RpIh+rb8GIqf4VTzri0mwWQxREJRynSPqnp8f45
        yptG3PaQdYIv0JQ5fp+QBNBNl4VUFVbhzi2+bLIcDp4et9MXGeFYsRsEOmAKq38Ghm2ovd
        vPN8XZxwg0qZf5q/7N9BXXfFEZ1C8Qo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-tQlcq4eYM4Wq2hkVsEIusQ-1; Wed, 20 Nov 2019 07:21:39 -0500
Received: by mail-wr1-f70.google.com with SMTP id l3so21037530wrx.21
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2019 04:21:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3CRYoC+FXuRRRB1nkQ2UTEB7lD0/kwekRSpLwkYD6lI=;
        b=KfPjjCmClVWZMXhj7iGu4MnHM9WO/x1A9O14ZVIwGvc6f4wyM6eVnaY24JTQ8UbLYI
         uIl0xzecIDTW2nm5lDZp5hsf6bATFKg4Tpsh8AcncbJI//VcPkVLXP79NwHLIvpMqC1O
         1Q+cMNhMOO8PFXyz1+FCOYC0TXUAyiMYbOu41nNxya4MzFQER7HiyD8isCPMSWlSORk6
         NXOA+8vf4Kwq6tuhKjjraD255dj2WG14VNwZjRy5eyZcGdTP+CODI/69lqia8CWHsle9
         TWows00/mI780j6VIB0K/R4uwkNPuoDIOvweAWItMqKvOlANy4W/oQ5pXAtdKos9swBf
         QUVA==
X-Gm-Message-State: APjAAAWcamQMmhHmuWBYj6z+/9SZ/AbK5WwLJKZ14ey4ftu1R1FfG+3f
        +wWv8/RJAyuf1NTxY11yO/Z8CtLCAFsCX40EVgAQ61CPZ/FBiqMeNl2apN4QT7fgYSVSENOHcPv
        XvoHwDbIRoKUW
X-Received: by 2002:adf:dc81:: with SMTP id r1mr3153628wrj.84.1574252497877;
        Wed, 20 Nov 2019 04:21:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqyKPOrrwukpzYwVmy5KkrfH43kXkleuhypNH0euma/SjTaLdY4e1rCrLeWxMJWnK4K36Jyv+Q==
X-Received: by 2002:adf:dc81:: with SMTP id r1mr3153590wrj.84.1574252497590;
        Wed, 20 Nov 2019 04:21:37 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:dc24:9a59:da87:5724? ([2001:b07:6468:f312:dc24:9a59:da87:5724])
        by smtp.gmail.com with ESMTPSA id u16sm31686955wrr.65.2019.11.20.04.21.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 04:21:36 -0800 (PST)
Subject: Re: [PATCH 4/5] KVM: vmx: implement MSR_IA32_TSX_CTRL disable RTM
 functionality
To:     Jim Mattson <jmattson@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <1574101067-5638-1-git-send-email-pbonzini@redhat.com>
 <1574101067-5638-5-git-send-email-pbonzini@redhat.com>
 <CALMp9eQ=QXD5sFCADtFY0Bc9wWcn2nhq7XdahD-g4DBSgARYJw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <656c0af1-6c56-8a08-ff86-745409f6968c@redhat.com>
Date:   Wed, 20 Nov 2019 13:21:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQ=QXD5sFCADtFY0Bc9wWcn2nhq7XdahD-g4DBSgARYJw@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: tQlcq4eYM4Wq2hkVsEIusQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/19 22:06, Jim Mattson wrote:
>> +               switch (index) {
>> +               case MSR_IA32_TSX_CTRL:
>> +                       /* No need to pass TSX_CTRL_CPUID_CLEAR through.=
  */
>> +                       vmx->guest_msrs[j].mask =3D ~(u64)TSX_CTRL_CPUID=
_CLEAR;
>> +                       break;
> Why even bother with the special case here? Does this make the wrmsr fast=
er?
>=20

No, but it can avoid the wrmsr altogether if the guest uses the same
DISABLE_RTM setting but a different value for CPUID_CLEAR.

More important, while I am confident re-enabling TSX while in the kernel
and only restoring MSR_IA32_TSX_CTRL on return to userspace, I'm more
wary of changing CPUID bits while the kernel is running.  I will update
the comment.

Paolo

