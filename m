Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E3620A51D
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 20:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405702AbgFYSlT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 14:41:19 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45813 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728406AbgFYSlT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 14:41:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593110477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NtljPknipWmoNQ9oUxok9tXRRukdGS7uc/xqibf5dZ4=;
        b=cH3rDAxXzUMcvISCmIPNS2Ol+aLz1v7M0/OeFxtOOJGD+Ofsi3AXnugeiqUUhxrHmY4fsr
        erLIlv2f+EJDrKxx6ylJKmQFk63ujWHQGlC382Wzep13iH7zi8FZMcpqZLEIyVSOiBvFGq
        cHpAPA6OPKNFM6IhciG2KNB1Ryg06ts=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-sNwXqsnIMnChOuXR5iqtGQ-1; Thu, 25 Jun 2020 14:41:10 -0400
X-MC-Unique: sNwXqsnIMnChOuXR5iqtGQ-1
Received: by mail-wm1-f70.google.com with SMTP id s134so7935665wme.6
        for <kvm@vger.kernel.org>; Thu, 25 Jun 2020 11:41:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NtljPknipWmoNQ9oUxok9tXRRukdGS7uc/xqibf5dZ4=;
        b=niVtvhgzplcweK5y/rJrNrzHB+uNGoms53RzWOOLz95bwaLrQhh8ffzCVsai0gFYxE
         sM3zQul9BJQl+xSetFx5h2mEuNvw2KxNW1CL+ukWzUXD/gbAo6lNGt+fTeNLKBiHt1TM
         Ka5ENPCkl+X1YshNfrRQ51QKcusJrH/3GxIG0l6kHYdf7zVVmsV35Jd0UR0Bg8dxqxao
         Tqvt2VDdH9Eb3cp2l4xzkd1lTGq4zKCwbaxCiJvJhOlIpGikoNQWttvKW2N5lqwImvK1
         OtxIdl+kseJCFKQrmdOBBzvLjMoscsAfVJgcPfG4r7HZFiedh6KxmKuNhQDOD6D7Nh78
         8xMw==
X-Gm-Message-State: AOAM5333Q4UKsuT6S/whRBjD+e++KkqP7QTmw6TXBGYmi/mXcQw9gF4B
        Hmw6cO3DPUP8Jy3H6vw74CMJgzUmAk6NojniOBZTyomQU+ktOF0ZFzQZAMvwKQU9ehvB3gf4Upp
        WDFkO0pmvySzx
X-Received: by 2002:adf:c3c7:: with SMTP id d7mr37578739wrg.51.1593110469034;
        Thu, 25 Jun 2020 11:41:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxDkdo6fBoLIQ2BTrmJtiSx6zEyIw7AqgvmBaybGzyoX5djjflXBlX/plljeBCKiOoDgeVeQ==
X-Received: by 2002:adf:c3c7:: with SMTP id d7mr37578716wrg.51.1593110468816;
        Thu, 25 Jun 2020 11:41:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91d0:a5f0:9f34:4d80? ([2001:b07:6468:f312:91d0:a5f0:9f34:4d80])
        by smtp.gmail.com with ESMTPSA id u74sm14042762wmu.31.2020.06.25.11.41.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 11:41:08 -0700 (PDT)
Subject: Re: qemu polling KVM_IRQ_LINE_STATUS when stopped
To:     Kevin Locke <kevin@kevinlocke.name>, kvm@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>
References: <87a80pihlz.fsf@linux.intel.com>
 <20171018174946.GU5109@tassilo.jf.intel.com>
 <3d37ef15-932a-1492-3068-9ef0b8cd5794@redhat.com>
 <20171020003449.GG5109@tassilo.jf.intel.com>
 <22d62b58-725b-9065-1f6d-081972ca32c3@redhat.com>
 <20171020140917.GH5109@tassilo.jf.intel.com>
 <2db78631-3c63-5e93-0ce8-f52b313593e1@redhat.com>
 <20171020205026.GI5109@tassilo.jf.intel.com>
 <1560363269.13828538.1508539882580.JavaMail.zimbra@redhat.com>
 <20200625142651.GA154525@kevinolos>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1fbd0871-7a72-3e12-43af-d3c11c784d83@redhat.com>
Date:   Thu, 25 Jun 2020 20:41:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200625142651.GA154525@kevinolos>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/20 16:26, Kevin Locke wrote:
> I'm trying to understand the cause and what options might exist for
> addressing it.  Several questions:
> 
> 1. Do I understand correctly that the CPU usage is due to counting
>    RTC periodic timer ticks for replay when the guest is resumed?

Yes.

> 2. If so, would it be possible to calculate the number of ticks
>    required from the time delta at resume, rather than polling each
>    tick while paused?

Note that high CPU usage while the guest is paused is a bug.  Only high
CPU usage as soon as the guest resumes is the unavoidable part.

That's because Windows (at least older version) counts up by one for
every tick and so we have to inject thousands of ticks for it to catch up.

> 3. Presumably when restoring from a snapshot, Windows time must jump
>    forward from the time the snapshot was taken.  How does this differ
>    from resuming from a paused state?

It doesn't, and it sucks equally bad because you get high CPU usage as
soon as the snapshot is restored (in order to catch up with possibly
days of lost ticks!).

> 4. How is this handled if the host is suspended (S3) when the VM is
>    paused (or not paused) and ticks aren't counted on the host?

During S3, the VM is paused in a reset state (so all timers are off,
which might explain different/non-buggy behavior).  After wakeup,
Windows refreshes the clock from the RTC time of day.

> 5. I have not observed high CPU usage for paused VMs in VirtualBox.
>    Would it be worth investigating how they handle this?
> 
> From the discussion in https://bugs.launchpad.net/bugs/1851062 it
> appears that the issue does not occur for all Windows 10 VMs.  Does
> that fit the theory it is caused by RTC periodic timer ticks?

Windows 10 can use the Hyper-V synthetic timer instead of the RTC, which
shouldn't have the problem.

Paolo

