Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF8A47BC10
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 09:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235785AbhLUIqw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 03:46:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23374 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234361AbhLUIqv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Dec 2021 03:46:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640076410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MZk6+BHjdh3P9084Tou7Ooqh6nDjDABDkvC7zaszK0w=;
        b=IdBlLIs8l20QC97OZ8nroUYTcXK9EhlnrzEwBK4MpgwlS7w4CabRFe0lYvtuRQcG6WpD27
        I1aJOTUTjc0rmlR0Y2/AgBXGtrRbPI0zDz1p/wOJxcR0EM2NgcMLgLtHA+pLjO1w0QxT1v
        Jnm5X1tap6374/X7ticdIm8ZK906O34=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-_C0CTytGMWKZV0VA2tzFnQ-1; Tue, 21 Dec 2021 03:46:49 -0500
X-MC-Unique: _C0CTytGMWKZV0VA2tzFnQ-1
Received: by mail-wm1-f70.google.com with SMTP id 187-20020a1c02c4000000b003335872db8dso2626575wmc.2
        for <kvm@vger.kernel.org>; Tue, 21 Dec 2021 00:46:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MZk6+BHjdh3P9084Tou7Ooqh6nDjDABDkvC7zaszK0w=;
        b=mkxVPoR00rccpCKqqPERoFMhBGJMTzlez3q/eOXJPvhLjH1IzAR26ekgTkujyXeUWs
         TwgEoTzLsOiRLBgFN2354nqi1TyGUxwIpGvO8z9se/L3t6OylTySfrXk55NSSyb4x82l
         7RSRPd34ie5GiTOc0PEPiCFvt6GLGPJ5dn9eqPwQfYf4ooSWnj8whPT51teWQnBqt22g
         5wu7UQzt+p2t4/xNs6b/chbJGI3cDwVA2yMm+4yafvC0MwIB+Pzhc3E3PG2gzWckrRcg
         IDK/aweRuppCLsnkMJ/ipGbyGeGniI0eWfEKA/9IogUtiuMCHgPSbi0KDNdY/Wu33rlb
         yBMg==
X-Gm-Message-State: AOAM530o2c+wQ5ixjXVvPnq7UJuB0smcrvaFKQkuYjjdim1k+ROOBgDq
        4kf7APtYub6ojrV+UXqat2eqyQoc9MkwiAeZ9Gf8a2BP9Ievi3ZjfzessSOp6F8eACb57u2bKUs
        kXuYUsvyCnIMY
X-Received: by 2002:a05:600c:6009:: with SMTP id az9mr1754779wmb.32.1640076408033;
        Tue, 21 Dec 2021 00:46:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwmnBZwI36XasGXlIbCL5DTmyAMHj70U6oBHzNIjWPE5ThZfSWfUSt0bapqZyKde4pus4iMhA==
X-Received: by 2002:a05:600c:6009:: with SMTP id az9mr1754765wmb.32.1640076407872;
        Tue, 21 Dec 2021 00:46:47 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id p13sm1684921wms.41.2021.12.21.00.46.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 00:46:47 -0800 (PST)
Message-ID: <015e7a47-19b1-9bee-14ff-c3ee4739a59c@redhat.com>
Date:   Tue, 21 Dec 2021 09:46:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 22/23] kvm: x86: Disable interception for IA32_XFD on
 demand
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
 <20211217153003.1719189-23-jing2.liu@intel.com>
 <6e95b6f7-44dc-7e48-4e6e-81cf85fc11c6@redhat.com>
 <MWHPR11MB1245BC0FA24DE0565D6952AAA97C9@MWHPR11MB1245.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <MWHPR11MB1245BC0FA24DE0565D6952AAA97C9@MWHPR11MB1245.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/21/21 07:42, Liu, Jing2 wrote:
>> Please instead add a "case" to vmx_set_msr:
> OK, it seems the passthrough setup is preferred in vmx.c.
> Do we also want a case in vmx_get_msr (for patch 11), even though
> no specific handling there?

No, thanks.

Paolo

