Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1052A0D35
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 19:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgJ3SQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 14:16:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22300 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726077AbgJ3SQ5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 14:16:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604081817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hQ9JbkxvNa0VjLQd06HFpKY/mjumkrtDAKSURNuwMaY=;
        b=WoLd4bj5ki0phUEDp88YWNjxuxXM7VLVIMIuuOJClL04e+P/+DgapMPZGeS7Gwk+B0KxlZ
        O8lYsej2JcTDoAe7XRoeVXR4enTLbDjvatYxFPcvUeDEXYHu0Pn0QmY64pp5alU5hosBDV
        hzoUoH9N+PyTjQr4vBLhKNaQ+d2FADc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-Cc2VnPU3NbaSN-w1vUSkLQ-1; Fri, 30 Oct 2020 14:16:54 -0400
X-MC-Unique: Cc2VnPU3NbaSN-w1vUSkLQ-1
Received: by mail-ed1-f71.google.com with SMTP id o2so3001658edw.1
        for <kvm@vger.kernel.org>; Fri, 30 Oct 2020 11:16:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hQ9JbkxvNa0VjLQd06HFpKY/mjumkrtDAKSURNuwMaY=;
        b=laXx1z/po0isPdAqx6zoIYoyUesAtYe8KMZCvjzXxzzDyMKrheQ5nDwHdmRznCIUO7
         qogOS12DBYwKjVwVRIuXy0eIeAkOpdVkx04cTAO3Hv4wp4aHIl24T1jVh25vOMIb2hVN
         l0XbtskjamPpMnqHXTPJBOVfcBPze+BbCaR3lXSBQGZbIqR73WF6EA0WJ3lLJyjXiBZ7
         EYdkON1FT39da8XQ+aock6NUmKj8DQNywciG9g3DG35AKtgZBDC9yjfzXdWK8GPCAXBv
         5gc+H+fUviOaUf5Gchgc/0zDH3iG7038UQWjUwkDWVXxkryJFcUpmJSrsBYcLX3swtfT
         3wyg==
X-Gm-Message-State: AOAM5307dGp5R+6fWxmCRSleKc3Mj6MjpbjpA5SamDCPVRD87Y0qV3wz
        9anmwhPRr1bCQeCQdAB9ZOGFCmTna+8XBV7iAB+TgNMkPMZVcPjJRX4d0FUWMvVDiUgOG2nVDq8
        KL5ZRC7zYM7S1
X-Received: by 2002:a17:906:c20f:: with SMTP id d15mr3678303ejz.341.1604081812910;
        Fri, 30 Oct 2020 11:16:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxORp9yhzCHXkXQ+SV0R3eIJai4qo4teWFQf7D18bUb6YmyTx02WLXvoVEuul2E5KtdAUsMg==
X-Received: by 2002:a17:906:c20f:: with SMTP id d15mr3678275ejz.341.1604081812714;
        Fri, 30 Oct 2020 11:16:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r24sm3338060eds.67.2020.10.30.11.16.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 11:16:51 -0700 (PDT)
Subject: Re: [PATCH] [v2] x86: apic: avoid -Wshadow warning in header
To:     David Laight <David.Laight@ACULAB.COM>,
        'Arvind Sankar' <nivedita@alum.mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     'Arnd Bergmann' <arnd@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
References: <20201028212417.3715575-1-arnd@kernel.org>
 <38b11ed3fec64ebd82d6a92834a4bebe@AcuMS.aculab.com>
 <20201029165611.GA2557691@rani.riverdale.lan>
 <93180c2d-268c-3c33-7c54-4221dfe0d7ad@redhat.com>
 <87v9esojdi.fsf@nanos.tec.linutronix.de>
 <20201029213512.GA34524@rani.riverdale.lan>
 <ad73f56e79d249b1b3614bccc85e2ca5@AcuMS.aculab.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <070f590f-b702-35f0-0b6c-c6455f08e9d5@redhat.com>
Date:   Fri, 30 Oct 2020 19:16:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <ad73f56e79d249b1b3614bccc85e2ca5@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/10/20 23:12, David Laight wrote:
>> https://godbolt.org/z/4dzPbM
>>
>> With -fno-strict-aliasing, the compiler reloads the pointer if you write
>> to the start of what it points to, but not if you write to later
>> elements.
> I guess it assumes that global data doesn't overlap.

Yeah, setting

	p = (struct s *) ((char *)&p) - 8;

invokes undefined behavior _for a different reason than strict aliasing_
(it's a pointer that is based on "p" but points before its start or
after one byte past its end).  So the compiler assumes that only the
first few bytes of a global can overlap it.

If you change the size of the fields from long to char in the compiler
explorer link above, every field forces a reload of the global.

Paolo

