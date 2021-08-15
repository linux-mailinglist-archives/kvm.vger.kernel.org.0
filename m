Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6CE3ECB9A
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 00:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhHOWKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 18:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhHOWKf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 18:10:35 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC13AC061764;
        Sun, 15 Aug 2021 15:10:04 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id k5so2921778lfu.4;
        Sun, 15 Aug 2021 15:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=qG3xd9FrDeupsPwKg/Vc42uAbKfVCy/1xjeqXZAMe1A=;
        b=th+Klh1ha4srMNZHDomFwGBf9bf/Xgs88c1y6ENI/KEc/xkX8VClsOaR2ZPmyrjCOS
         wPpGeISyXO/s/CeLZ81sOvlh6h+gPkbxPZJFeD7C59+QjKC0Qdt8CIVzwTh8Mt0FpBG6
         W4xVrXX7ZBgEbMUyGv9Zkk5NMmEz+qIczIyCROgux1YHO9nqYPRU3R+xnZcYOuWR2i4V
         9ENlx0/iVdaWWSMnPsABB9HD2mNwigENMApiUPIdEuJ6IWIVEcPLi/id1WyE4YS0rK56
         pjkDoX3XKjtpjbQOspK81S+cgaLux7R6D1iXlnbBjeLra0ujOOrvutp2fb9zOcnRbdn3
         C71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=qG3xd9FrDeupsPwKg/Vc42uAbKfVCy/1xjeqXZAMe1A=;
        b=d8KRkqvd9aeG/fq/7XkH1fabRTiL+FnXVFpTwAqn/vulvuJ6tPKAJocxumXLj4TA3v
         fNEW/I3KO2FKxqLfaSrGsuxmYbj5L8Pg5auQR0hssrSOwMXIG4mVSsRMPuojA9eauYYK
         nwHwHh88JFK5TfDhc+M/vNO04K94LKpM7JnQ1me6iER3ZWgAAE/RVLQEa/G5qmkwAFAN
         m8oquQSzbJG1awoGJyRtDEnbKnU/gwZoEKa3dWfbjsWh/ayzmcYGwdNe4mKlYDHdCXX3
         HVCk0gACiukQIZ6TfVXSFbLM2uBdsxkfbxs6oR3r4I/XVqegfN5ktV5OYYVrWgXu+Due
         J0yg==
X-Gm-Message-State: AOAM532hQVkH23+nvB9np8FcDkUkN1h0w5GWBywNi4mmRYBvcmH7EAgi
        XVG6gcgtZKfxn6TuGzG8LWw=
X-Google-Smtp-Source: ABdhPJzHciuPs15NMgtyIiX6wXXPm/vUzNwlYpgWhz1sWg1JDEPZTK3elB/fmoKLKeeS008NM5y0Vg==
X-Received: by 2002:a05:6512:152a:: with SMTP id bq42mr9340696lfb.68.1629065402500;
        Sun, 15 Aug 2021 15:10:02 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id a10sm769244lfl.215.2021.08.15.15.10.01
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sun, 15 Aug 2021 15:10:02 -0700 (PDT)
Message-ID: <611993B1.4070302@gmail.com>
Date:   Mon, 16 Aug 2021 01:22:41 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] x86: PIRQ/ELCR-related fixes and updates
References: <alpine.DEB.2.21.2107171813230.9461@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2107171813230.9461@angie.orcam.me.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Maciej,

20.07.2021 6:27, Maciej W. Rozycki:
[...]
>   Nikolai: for your system only 1/6 and 2/6 are required, though you are
> free to experiment with all the patches.  Mind that 3/6 mechanically
> depends on the earlier change for the SIO PIRQ router referred above.  In
> any case please use the debug patch for PCI code as well as the earlier
> patches for your other system and send the resulting bootstrap log for
> confirmation.

Here is a new log with 1/6 and 2/6 applied:

https://pastebin.com/0MgXAGtG

It looks like something went a bit unexpected ("runtime IRQ mapping not 
provided by arch").


Thank you,

Regards,
Nikolai
