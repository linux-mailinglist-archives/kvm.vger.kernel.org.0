Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B6647BC09
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 09:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235756AbhLUIpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 03:45:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24670 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234214AbhLUIpa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Dec 2021 03:45:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640076330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9rV8HhpffgTGod9s0ughWcfrQecI/BkSIyj74DTgYWk=;
        b=O9fQ1pVE6rPIXjDWkc5G1WdcR9AkCxe7rsYNmmfUd3ANK0WrKUw1okcKso0njJL91mecxI
        Puo1Kfk1FUcN0//YoYyo3v9MBhexlYAzZAgEMjUzIeKZ3WZa+TTvBQZ/SbrTXa++36/Jek
        yPeZyWrudY2/NCUBz8loSVPnRkiw3ao=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-aoS3Ep7xM2KE90dFSU5qrg-1; Tue, 21 Dec 2021 03:45:29 -0500
X-MC-Unique: aoS3Ep7xM2KE90dFSU5qrg-1
Received: by mail-wr1-f72.google.com with SMTP id h12-20020adfa4cc000000b001a22dceda69so4418391wrb.16
        for <kvm@vger.kernel.org>; Tue, 21 Dec 2021 00:45:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9rV8HhpffgTGod9s0ughWcfrQecI/BkSIyj74DTgYWk=;
        b=tm7Bu9VuyUZU59PkwBjj/85/7eTSkwofs8bQtS7lnKW+gZd7ljaWwJB4zlQA5E1wwo
         Itn63VNdY9zZiRvapFk0znvDFdcKMr6UlgH5JaVQmRUyMimt2sX+Y5/rkqQv0xExkpnS
         +YvMfomqresN9ZwR11cLCfKBFuCNay+GvO4NcdZy3jQee6Rb9odu0qWQ1SVCbfF5T3lN
         t7IlvpHdMOXDlxVWcIPKcS1srR8xvd0OlMmx0LbhqWx5hFpijKJRq4XXNUWHvB1ba3PS
         oMTTzxvFnab5GjNPdCzC3U4ipCrPGYNhkuXKlFKz06XkflxWBBHp/+P4Cddtkmt/1XjF
         NbFg==
X-Gm-Message-State: AOAM532gvOurT/b9DuG0925OU7g4I5RhehX48GHV3/ONpEvzmcWnA7bC
        mER2eS7jfpn1qnI/OKTDNakinjNd7ifa8WF16AmsiJ6TTL36F+4FOisSSo9DOGB/aaq0Fxjw4XP
        LcItKHVhmTMJi
X-Received: by 2002:a05:600c:2112:: with SMTP id u18mr1748745wml.65.1640076327856;
        Tue, 21 Dec 2021 00:45:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw574NV4CCGuafyxA4+anH6S1/DFiMnrkDlvAqyGzi031e3+62rurhdWE9FTV1sPi58hhgrrw==
X-Received: by 2002:a05:600c:2112:: with SMTP id u18mr1748720wml.65.1640076327638;
        Tue, 21 Dec 2021 00:45:27 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id i4sm1619718wmd.34.2021.12.21.00.45.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 00:45:27 -0800 (PST)
Message-ID: <219a751e-ac2d-9ce1-9db7-7d5b1edd6bdd@redhat.com>
Date:   Tue, 21 Dec 2021 09:45:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 18/23] kvm: x86: Get/set expanded xstate buffer
Content-Language: en-US
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc:     "seanjc@google.com" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
 <20211217153003.1719189-19-jing2.liu@intel.com>
 <3ffa47eb-3555-5925-1c55-f89a07ceb4bc@redhat.com>
 <e0fd378de64f44fd8becfe67b02cb635@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <e0fd378de64f44fd8becfe67b02cb635@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/21/21 03:45, Wang, Wei W wrote:
>> KVM_GET_XSAVE2 and KVM_SET_XSAVE respectively write and read as many
>> bytes as are returned by KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2), when
>> invoked on the vm file descriptor.  Currently,
>> KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2) will only return a value that is
>> greater than 4096 bytes if any dynamic features have been enabled with
>> ``arch_prctl()``; this however may change in the future.
> Would this make people think that KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2) doesn’t
> return the value (i.e. return 0) if it is smaller than 4096?
> (i.e. KVM_GET_XSAVE2 doesn't work with size < 4096, which isn’t true)
> 
> I plan to just reword a bit:
> Currently, KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2) will only return a size value,
> and the value is greater than 4096 bytes if any dynamic features have been enabled with
> ``arch_prctl()``. More types of values could be returned in the future.

Next refinement:

The size value returned by KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2) will 
always be at least 4096.  Currently, it is only greater than 4096 if a 
dynamic feature has been enabled with ``arch_prctl()``, but this may 
change in the future.

(I'm not sure if the first sentence is true in the code, but if not it 
is a bug that has to be fixed :)).

Paolo

