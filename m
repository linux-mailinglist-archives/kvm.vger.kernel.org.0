Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 516851651EA
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 22:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbgBSVw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 16:52:26 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39053 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgBSVw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 16:52:26 -0500
Received: by mail-ed1-f65.google.com with SMTP id m13so31077120edb.6;
        Wed, 19 Feb 2020 13:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1Pl1p6onjyyNhZnPY6M71H8E4MdpgjmmIc7gcGFJmcs=;
        b=d5tYuItYhYfncdYE4Og9MRxjnnd33Snx7t9bJssD5ZBb84D8N/QLaRte5tQGuyFNDt
         2zDMAP6QKGbvPKA9cc8cDzzdMBOFBu/80DKBo1z7yPLdkaN+eZQzM5hwfVMdVn/0s8F6
         tCJTfBOARRxqWz4CakzSJZhBrneW4UWe/vJFQKwCS+JoC8n81civ0DP1ay0PxN2405WI
         GfpoLnql+Rytb7apFkz6cIymK6seZun4eQPBCA0fU8UlT9EdD5StiO8/t84nvBt0vqRS
         bsIHwxq8QEbwfkrrSzwrVP9xk58/70A2Aoi7UGlh0FDRU6O9WnmMb0QgcVzvfxkkPArb
         ItBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1Pl1p6onjyyNhZnPY6M71H8E4MdpgjmmIc7gcGFJmcs=;
        b=VmKzPvUpfPXB1IpnAfLTFSuwKsHPHEWXm7qvtzWqcdncopzlkR6i+HKGF+98MdND2x
         Xu62gug5TjQmI5L0Mdp7X7CoNu/WrcwnLJ2EtqJ03r6IZWs+ZnWrBdC09VLKdrusk1Lf
         NfUFWtt3TiBsE1fkIxGUvfsPMhVKV1mCxW7Nzq6DcM/yv0hoQeo55opa22DvD3kEVJr0
         B96q3iHNumxO+p7e/C95Elh+aJNhoTGSZB8ZJvxrbnnQXS1+gwGysrBXc2boL5WvK2Qk
         pvDsHmDCahyHU0ABonT4ymJP1eOcD3J2n3p9iKfIKqa+RCzpOYS/HFravUtSza0RP5R1
         3IcQ==
X-Gm-Message-State: APjAAAW/MYvvAdOYZgufGA3/P8F+UDnNyw4zt29ngNphPnRnkHQ1mt2+
        Zy2kLEPFtChT10ekUh6UvfXY7kC6GAoUOZKWl6c=
X-Google-Smtp-Source: APXvYqxwJR781+/L2fsg5egRTc2qzBZtIsZtnYnGzVeSuh8bgnU+GswsSgywE+2PeGqDBYOquuKRo4ETRnVoMbIScBw=
X-Received: by 2002:a17:906:934c:: with SMTP id p12mr26282804ejw.68.1582149144477;
 Wed, 19 Feb 2020 13:52:24 -0800 (PST)
MIME-Version: 1.0
References: <20200214143035.607115-1-e.velu@criteo.com> <20200214170508.GB20690@linux.intel.com>
 <70b4d8fa-57c0-055b-8391-4952dec32a58@criteo.com> <20200218184802.GC28156@linux.intel.com>
 <91db305a-1d81-61a6-125b-3094e75b4b3e@criteo.com> <20200219161827.GD15888@linux.intel.com>
 <646147a6-730b-0366-10db-ed74489ad11e@criteo.com> <ea2800cf-4c23-9cb5-5904-08a709f6d594@redhat.com>
In-Reply-To: <ea2800cf-4c23-9cb5-5904-08a709f6d594@redhat.com>
From:   Erwan Velu <erwanaliasr1@gmail.com>
Date:   Wed, 19 Feb 2020 22:52:12 +0100
Message-ID: <CAL2JzuzmdFApEQbjs14fL4uErjHf62nFRy8UYB=hTCRhxaKk0w@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: Print "disabled by bios" only once per host
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Erwan Velu <e.velu@criteo.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'll send a patch in this direction.
Thanks,

Le mer. 19 f=C3=A9vr. 2020 =C3=A0 18:51, Paolo Bonzini <pbonzini@redhat.com=
> a =C3=A9crit :
>
> On 19/02/20 17:53, Erwan Velu wrote:
> >
> >
> > I've been testing the ratelimited which is far better but still prints
> > 12 messages.
>
> 12 is already much better than 256.  Someone else will have an even
> bigger system requiring a larger delay, so I'd go with the default.
>
> Paolo
>
> > I saw the ratelimit is on about 5 sec, I wonder if we can explicit a
> > longer one for this one.
> >
> > I searched around this but it doesn't seems that hacking the delay is a
> > common usage.
> >
> > Do you have any insights/ideas around that ?
> >
> >
> > Switching to ratelimit could be done by replacing the actual call or ad=
d
> > a macro similar to  kvm_pr_unimpl() so it can be reused easily.
>
