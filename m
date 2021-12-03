Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132D4467320
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 09:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379154AbhLCIMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 03:12:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:60776 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1379138AbhLCIMj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 03:12:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638518953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K72XFDGEYeL3BH76EKWe4JnJXzEuCnG0ewjh8OGemjI=;
        b=V2HYlXhP3DPBS57VrK1hXliAxhNaVxmLKs8soSADVE8SQSHC5cRyEwkdP33tz78yDB5LtY
        WAeWxod5rZwE1KxM4k9ZJdaKPXZEdw9qLl0YFN9ahKhhfH9PXlG/YGsDHwyo00c7YWduHt
        XZZ/w/x3Fz5gDs/WmmRtGam01TDwK60=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-TOoQJzcXMq6zv5JOR5VvGg-1; Fri, 03 Dec 2021 03:09:12 -0500
X-MC-Unique: TOoQJzcXMq6zv5JOR5VvGg-1
Received: by mail-ed1-f71.google.com with SMTP id t9-20020aa7d709000000b003e83403a5cbso1847131edq.19
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 00:09:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=K72XFDGEYeL3BH76EKWe4JnJXzEuCnG0ewjh8OGemjI=;
        b=Mm935Pki7NU1xAcLD1Wu7pEjlpeUhftPWJSL3CsB1hn5f0tLqQ1H8lwAp3guj3VitE
         TqOSckya26lbPBHIs1jKIb5RX5bOxW8tdsryEmlBYTUyfmG3/fGz9xeF2joOAkZ+WbLa
         63nAkqenvT04mmFGIQeqbChQflqZzqnIYvhmDcDp+kNRdMwy+8aOitmnf1lkCqYQ9TG9
         ReQmrUfukHhylJQULXZGkJZEni8kE09srmFqBlu2NF2j6qGpXB5pZzv7oPSHlkQRGI8n
         9I0jPQqvmij7OwFbg5eXPrVeZNw6/XON7dxIBwdA9K4b4DlA+/i0zDzHOb447DL2G42s
         2/Gw==
X-Gm-Message-State: AOAM531R6iMXayu48UrmIzGz5UbLYZ6l8qqYaKTS7rYewpdymphCnQRy
        p3IBlJow6OMnG69KxHVcArR4QOeN2XQRjLjNKJXBuaxQTdIuzBKVAmCGlFHVJSlInplBFAkr5Th
        SNDJlCXk7pbPPysjjpUg//BiQH2p/Stf40uvnWJD7tWqyCg0vnKEBQwtfnCj8Wj5m
X-Received: by 2002:a17:907:94c6:: with SMTP id dn6mr21735493ejc.490.1638518951537;
        Fri, 03 Dec 2021 00:09:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6I4RP2/lUv59uHDaNyDb4H3IbpHUzm5Vz3ZMPuwbZxcR1ab3u+vSBZTxFJelWHLViNDfLrg==
X-Received: by 2002:a17:907:94c6:: with SMTP id dn6mr21735468ejc.490.1638518951273;
        Fri, 03 Dec 2021 00:09:11 -0800 (PST)
Received: from fedora (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id de15sm1357866ejc.70.2021.12.03.00.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 00:09:10 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Makarand Sonare <makarandsonare@google.com>,
        kvm <kvm@vger.kernel.org>
Subject: Re: KVM patches for Hyper-V improvements
In-Reply-To: <CA+qz5sqUKk46BcRKCyM1rdvtGL3QE7C8gDt0D7qx8_x_M8bKtQ@mail.gmail.com>
References: <CA+qz5sqUKk46BcRKCyM1rdvtGL3QE7C8gDt0D7qx8_x_M8bKtQ@mail.gmail.com>
Date:   Fri, 03 Dec 2021 09:09:09 +0100
Message-ID: <87r1au6rfe.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Makarand Sonare <makarandsonare@google.com> writes:

> Hello Vitaly,
>                   I am interested in knowing the exact set of KVM
> patches that were added for the Nested Hyper-V scenario. Could you
> please point me to them?

Hi Makarand,

are you interested in patches since some upstream kernel version or
since the beginning of time? Thing is, some Hyper-V enlightenments
benefit both Windows and Hyper-V and some are specific to Hyper-V. Out
of top of my head, 'direct synthetic timers', 'Enlightened VMCS', and
'Enlightened MSR-Bitmap' features are Hyper-V specific. Patch list is
pretty long, see for example

$ git log --author vkuznets@redhat.com --oneline -i --grep 'enlightened.*vmcs' arch/x86/kvm/

and 

$ git log --author vkuznets@redhat.com --oneline -i --grep 'direct.*syn' arch/x86/kvm/

Enlightened MSR-Bitmap is only in kvm/master:
ceef7d10dfb6 KVM: x86: VMX: hyper-v: Enlightened MSR-Bitmap support

The list is likely incomplete as there are pre-requisites for these
patches which may not have the required keywords. There were fixes in
other parts of KVM for nested Hyper-V as well but I don't know an easy
way to find them (grepping for 'Hyper-V/hyperv' in the log would be a
good start but we'll certainly miss something).

Please let me know if that's what you're looking for and I'll try to
give you more precise information.

-- 
Vitaly

