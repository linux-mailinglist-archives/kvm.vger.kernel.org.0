Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D1B47BC68
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 10:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbhLUJF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 04:05:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60227 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234350AbhLUJFY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Dec 2021 04:05:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640077523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rgPifuu1RB0k0LUOxT2X3VnLk1g+LzCMRjZsLuLn63g=;
        b=SvEAsypBMur7gpsEp+uWKbVp+vEI3c7+wNH7n8S9ZYUC0FCxYvjUL13USumW/sO2V5L8EJ
        jh/KlgOzGZZi7mWn8JhzswHmOFjSw1AJUYytbWCuZl7YXJ1Fg9I+rBQVvfNMPE83yZKmsN
        sFDa/VQfbRsJ0F6Mn5Gk5kaMdbCuzoA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-g-qS3-5oPz2oDE7YOkreRg-1; Tue, 21 Dec 2021 04:05:21 -0500
X-MC-Unique: g-qS3-5oPz2oDE7YOkreRg-1
Received: by mail-wr1-f72.google.com with SMTP id p15-20020adfaa0f000000b001a240b45c1fso4418055wrd.4
        for <kvm@vger.kernel.org>; Tue, 21 Dec 2021 01:05:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rgPifuu1RB0k0LUOxT2X3VnLk1g+LzCMRjZsLuLn63g=;
        b=rgVeVcQTkDfDVn7YLmHT7LORfg2bEgxE/fdw4hvR26/a1aJ4X7Eq9LFnofsnyRCj2t
         VyKR4VYPfeMB8UdOJYLwpL1L0ElqGZrzknOTR6n4I0zZUxPU80Qhi3WK7KbslpgrI8DQ
         btgZu2idjlmx79YDqBjbiEfPATThxEuxtfiNcnShnR2tu2b7EK7jgUTumvzqCqqzaH2v
         ssu2rSfzqqLlMu1cmmAabXbgBWFhiqxpLtjj12BaGqoTpUSVeXpIKceMzLKtFBFtdeE+
         hUOV9ebbaDtu1wWuMeFZYiLfVhBTinSiHRDov6N1hbzRSDyF+n49/6VJIad6EiYv1bxf
         kNjw==
X-Gm-Message-State: AOAM5304ThEfdY2ODJS8MulzRjGDUC8GZ7ZCwtFPqpcTPTQHlgJlgKgb
        /AHuvx9giFURNWW148ayjd7dkciwNQMgcPJPKSQSU8y6uMtPfK4NRSm8PXuKAquji7p4JFyRRws
        XbZnBFH3etIe/
X-Received: by 2002:adf:8165:: with SMTP id 92mr1808671wrm.199.1640077520323;
        Tue, 21 Dec 2021 01:05:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwz9dD/lyXn12XSkfz7PrwHF1Fi8hcgYYgOHY1FWx8GoepwZnjYExiR9qO3tS5VayQk7j0WEA==
X-Received: by 2002:adf:8165:: with SMTP id 92mr1808655wrm.199.1640077520096;
        Tue, 21 Dec 2021 01:05:20 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id c11sm1920328wmq.48.2021.12.21.01.05.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 01:05:19 -0800 (PST)
Message-ID: <5b0e2e4c-a7bc-b0a5-1af7-df937618b2e4@redhat.com>
Date:   Tue, 21 Dec 2021 10:05:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 23/23] kvm: x86: Disable RDMSR interception of
 IA32_XFD_ERR
Content-Language: en-US
To:     "Liu, Jing2" <jing2.liu@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc:     "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
 <20211217153003.1719189-24-jing2.liu@intel.com>
 <e6fd3fc5-ea06-30a5-29ce-1ffd6b815b47@redhat.com>
 <MWHPR11MB12451924FE9189E4B69E78A4A97C9@MWHPR11MB1245.namprd11.prod.outlook.com>
 <f465ec18-4a0d-2e1c-239e-cc93aa43226f@redhat.com>
 <MWHPR11MB1245CA82DBCE3D660CDE4756A97C9@MWHPR11MB1245.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <MWHPR11MB1245CA82DBCE3D660CDE4756A97C9@MWHPR11MB1245.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/21/21 10:00, Liu, Jing2 wrote:
> Thanks Paolo.
> 
> BTW do we want to put this together into patch 13 or 14, I guess you were saying patch 14 😊
> [PATCH v2 13/23] kvm: x86: Intercept #NM for saving IA32_XFD_ERR
> [PATCH v2 14/23] kvm: x86: Emulate IA32_XFD_ERR for guest

No, I meant patch 13 because it is where xfd_err is added to struct 
kvm_vcpu and the wrmsr is added on vmentry.

But really it is not a big deal.  You might as well keep it a separate 
patch ("patch 14.5") so we don't have to argue.

Paolo

