Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1C2717332E
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 09:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgB1IqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 03:46:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24058 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726287AbgB1IqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 03:46:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582879576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DniqYTbN+x5CT96Mk51QmCB3SzOjbyBDXwojZbMjovY=;
        b=T+Jh6USunCOdp31unW3s3QcbRimIyQn3gYJ17UCoA5BkpfKtNSHYY5kyJppnNfPJWmHzAR
        NdkwNNDQSFOf7ZMWEe7tyOA5qcUSO6zh/20WYTtf1mDGCC7W6FfYca6/gxdSV5RBOMTH+/
        s7VtIjXZ/1YhT3MY+FlrzdT32SeGua0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-ZpJ_x_B1N32ocOUPYvfakg-1; Fri, 28 Feb 2020 03:46:14 -0500
X-MC-Unique: ZpJ_x_B1N32ocOUPYvfakg-1
Received: by mail-wm1-f71.google.com with SMTP id o24so428235wmh.0
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 00:46:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DniqYTbN+x5CT96Mk51QmCB3SzOjbyBDXwojZbMjovY=;
        b=bDObdZ2TSgEMyrQ2ESIlPoCqMTteUz/fVHLhtON+ZnAy4sk/wZ7JNm9CAKrEBlEKKQ
         /HDjBV5mlfGPKJ8Ih4HoVwzRBAM5ubisFpIWnaiYGOuprNq7NFXlZNarcSAzBdvx5Z+I
         efvVfJJfKvDJ8+46Sygv5fScmUJf/csIWF3EquvXlbYj8TvMR4rNyUEJsU5FFTm1Oqm9
         oYk+zFbk18xuuELy5zgiGsJeMfOkYYqD7CU5N7/Dli073br7nsnOaGd8CWxAq2th/MZ1
         gvqkMfyo2ajuYxd3D35AI0YQ0LTIQvZa+OY/ODoO/hvnhfXBFzH9hC4OTfagsMNdehF5
         Y4Rg==
X-Gm-Message-State: APjAAAXsbTefiHpexpyolYtLj2K5fq+pb9TBLwa2n3epMcWb2Z9LwbiB
        NSLl5bf7IyF90vBpF3TAoGrsWc7/IgCjOKWlTcdNeTS/EnIENNflT/ZUdviFfAEaZmyGwWWzycG
        M5VmKg3xRSA9A
X-Received: by 2002:a7b:ca58:: with SMTP id m24mr3913784wml.129.1582879573429;
        Fri, 28 Feb 2020 00:46:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqxIXBQSqnsfQaO7I7rg0h4eoBg+y4OioioQJskwEc2kREvl4ILOh1QAMufeM4cFxtqBOcgq5Q==
X-Received: by 2002:a7b:ca58:: with SMTP id m24mr3913752wml.129.1582879573103;
        Fri, 28 Feb 2020 00:46:13 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:30cb:d037:e500:2b47? ([2001:b07:6468:f312:30cb:d037:e500:2b47])
        by smtp.gmail.com with ESMTPSA id m21sm1166528wmi.27.2020.02.28.00.46.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 00:46:12 -0800 (PST)
Subject: Re: [PATCH] KVM: SVM: Inhibit APIC virtualization for X2APIC guest
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>
References: <20200228003523.114071-1-oupton@google.com>
 <bde391f9-1f87-dfc9-c0d6-ccd80d537e7d@redhat.com>
 <20200228084501.GA11772@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9bbdff9b-cca3-f41a-1952-d529360ec834@redhat.com>
Date:   Fri, 28 Feb 2020 09:46:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200228084501.GA11772@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/02/20 09:45, Oliver Upton wrote:
>> - a PV CPUID leaf to tell <=255 vCPUs on AMD virtualization _not_ to use
>> x2apic.
>>
> If a VMM didn't want the guest to use x2APIC in the first place, shouldn't
> it instead omit x2APIC from the guest CPUID? I can see a point for this
> if folks are inclined to use the same CPUID for VMs regardless of shape.
> Just a thought to tackle later down the road :)

Yes, it's mostly for simplicity of configuration.

Paolo

