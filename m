Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF7D4371CF
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 08:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhJVGgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 02:36:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52335 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230379AbhJVGgG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 02:36:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634884429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c1NT4YsOtNzkAlK5Cne+Aothcxr8Ri0vDpNi7WPQfls=;
        b=LqGINmVIjcMZt6StibItGN7uaWz8Jir1v/6gxYMIMesV8yNh9AU0dxCa3f4Y07H9fcnEUE
        Fj9xrU2M099IShwg9TzirIQTXIwGB3jpis1SVYhngsM9s5s9nhsVIK8sxQl1TKsmy4dA0C
        r2xt8L6giFzMHGoj0XUAXMjJ4XBBgiA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-j_lFSdZQNdWi7T_QvATJuA-1; Fri, 22 Oct 2021 02:33:47 -0400
X-MC-Unique: j_lFSdZQNdWi7T_QvATJuA-1
Received: by mail-wr1-f70.google.com with SMTP id r21-20020adfa155000000b001608162e16dso602963wrr.15
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 23:33:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=c1NT4YsOtNzkAlK5Cne+Aothcxr8Ri0vDpNi7WPQfls=;
        b=5J7F3RliSlMJjhICwOzYNCFYA5V57R30fse3jgnSPiXi6qqwy2m1M7cVbnSFwDlnEC
         cmgNNCzmO1Rjes7ddOGlGzzyHlyDUOrMaCOBllsSFj8pLlz6rpESG/V0yoAx4glOYd7F
         Ajjpsjc2lyGBBCoRxaqibe4tO3rb5z2NKupZoL72X0wWAczPh9no7Irb8RDADnGPcmC5
         V3ArhYqaCHrsKCRORtPx/f/uQSvSVRzvQSWqTAVSr4AJ/5gEd7WggL/PoEdgx8+emIbC
         XcDlVzuEdT1NaI2kQnbUve2qmNZyRhnxZj9en07wOFi7C+kLuXgbE3hjA0yKmrQ0eOSR
         gt/A==
X-Gm-Message-State: AOAM5315Crsrh1JKmvtPyp9B4eulRG5dbqRz6uiO9EAXdEwgJ1eriQDR
        GdRos5hxZ9UScixD7wgaPe3zi6R8T/QDl9xvlphgVtVci3ObJ3PuHnA4TTSujBESZOvyC5xNXaj
        uJfCseEYWuCzC
X-Received: by 2002:a05:600c:218:: with SMTP id 24mr2277549wmi.192.1634884426533;
        Thu, 21 Oct 2021 23:33:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTYZfVvouiiSodftXItcALsBOngFeTJ7793dnCEw8VEOUA+K7VM4rQUeNZ6wpHYbV4HaOIvQ==
X-Received: by 2002:a05:600c:218:: with SMTP id 24mr2277525wmi.192.1634884426270;
        Thu, 21 Oct 2021 23:33:46 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f17sm1779186wmf.44.2021.10.21.23.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 23:33:45 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 1/2] KVM: x86: Add vendor name to kvm_x86_ops, use it
 for error messages
In-Reply-To: <YXGn70lhcjulaO3r@google.com>
References: <20211018183929.897461-1-seanjc@google.com>
 <20211018183929.897461-2-seanjc@google.com>
 <87k0i6x0jk.fsf@vitty.brq.redhat.com> <YXGn70lhcjulaO3r@google.com>
Date:   Fri, 22 Oct 2021 08:33:44 +0200
Message-ID: <871r4dwotz.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Oct 21, 2021, Vitaly Kuznetsov wrote:
>> >  	if (ops->disabled_by_bios()) {
>> > -		pr_err_ratelimited("kvm: disabled by bios\n");
>> > +		pr_err_ratelimited("kvm: support for '%s' disabled by bios\n",
>> > +				   ops->runtime_ops->name);
>> 
>> 
>> I'd suggest we change this to 
>> 
>> 		pr_err_ratelimited("kvm: %s: virtualization disabled in BIOS\n",
>> 				   ops->runtime_ops->name);
>> 
>> or something like that as generally, it makes little sense to search for
>> 'KVM' in BIOS settings. You need too look for either 'Virtualization' or
>> VT-x/AMD-v.
>
> I'd prefer to avoid VT-x/AMD-v so as not to speculate on the module being loaded
> or the underlying hardware, e.g. I've no idea what Hygon, Zhaoxin, etc... use for
> "code" names.
>
> What about
>
> 		pr_err_ratelimited("kvm: virtualization support for '%s' disabled by BIOS\n",
> 				   ops->runtime_ops->name);
>
> to add the virtualization flavor but still make it clear that error is coming
> from the base kvm module.

Works for me, thanks! I just want to make sure people know what to do
when they see the message.

-- 
Vitaly

