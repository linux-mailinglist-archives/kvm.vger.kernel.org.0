Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F17232CA5
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 09:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgG3Hfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 03:35:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54162 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726194AbgG3Hfl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 03:35:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596094539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hwsxrkhlCnIN5HR3vIYc+ahhqHCHSPry1smo3ch9XMo=;
        b=L9uou8JpepjSPvXHI5MzoQlJRuCA8t2oqsOl1YoVNreVCAZNLOnX2wuxGseYzGf83UzqsY
        XfJDo7yAtREO1cSK5a3w5PbqYdZj5FkGtV4XLq3H9H8mwdOIZgB9IIpSXcnZwsdQy0NNFG
        wn/0ZVWOeKhF/yOoq4Vq3Wc49p010yE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-9ZiS_FQNP0K9hKKAt60o2g-1; Thu, 30 Jul 2020 03:35:37 -0400
X-MC-Unique: 9ZiS_FQNP0K9hKKAt60o2g-1
Received: by mail-wr1-f71.google.com with SMTP id e14so4135768wrr.7
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 00:35:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hwsxrkhlCnIN5HR3vIYc+ahhqHCHSPry1smo3ch9XMo=;
        b=uVnS6KA489yndydJpMaaoO25e9IWP06MegUpDjeSQM68kVtpqTPk0XK6vAt8EaaXFC
         KNQbYpTUn9ToiNkufMxpnFGwwOw5WIgVtShu9gyDiI1kWbv5l/W5dEPy9Q8T7dSjES7G
         gdiUSXxMWFMmapIOm7HYsxmP82crMxbmiVg+dkP4Rf8cuXu9Eg1eNRm8Sth8GAGCuGko
         /KPiAVMAeazvMJhR9Ya0Z95qGMasDE8FA8F3o4FpCu/3nvWyu8neLc+tj6gSDVP+qHtM
         xsvcWOvDpbQsmQzIU2eSkHXFHFj1GA7fwP9ye9HAuVFpNbcO7/xCoSMChHw7v6BkFBF+
         9A+Q==
X-Gm-Message-State: AOAM533aLiUPWpEq7tauW4jSIqS52GArIJIU9HElCVCUkmvb4ns2GH62
        nKwuPYVDzOA87MeYvTUjpoMfXipfe5WXwTNOmR5U6a0SvESpUp0gsjDzJppbM66nJQKv4uzuDzR
        25E6KHjj0+tQ1
X-Received: by 2002:adf:eb05:: with SMTP id s5mr1618852wrn.0.1596094535775;
        Thu, 30 Jul 2020 00:35:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyw+6/y9PW1Lto8++vcPxjW/cqY70MIayFXsgH601bDJehG4+yEG8BBn0W0Ep0tIeo0967FIQ==
X-Received: by 2002:adf:eb05:: with SMTP id s5mr1618825wrn.0.1596094535548;
        Thu, 30 Jul 2020 00:35:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:101f:6e7:e073:454c? ([2001:b07:6468:f312:101f:6e7:e073:454c])
        by smtp.gmail.com with ESMTPSA id t2sm8724928wmb.25.2020.07.30.00.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 00:35:34 -0700 (PDT)
Subject: Re: A new name for kvm-unit-tests ?
To:     Wanpeng Li <kernellwp@gmail.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@redhat.com>, KVM <kvm@vger.kernel.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nadav Amit <namit@vmware.com>,
        Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <dc518389-945a-1887-7ad0-00ebaf9ae30e@redhat.com>
 <682fe35c-f4ea-2540-f692-f23a42c6d56b@de.ibm.com>
 <c8e83bff-1762-f719-924f-618bd29e7894@redhat.com>
 <CANRm+Czsb79JYAHcOm49tg=M2vHdOzh_XFaEcSS_RUPfX3dRuw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c92c6905-fcfb-ea5b-8c80-1025488adc98@redhat.com>
Date:   Thu, 30 Jul 2020 09:35:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CANRm+Czsb79JYAHcOm49tg=M2vHdOzh_XFaEcSS_RUPfX3dRuw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/20 09:13, Wanpeng Li wrote:
>>> I personally dislike renames as you will have old references lurking in
>>> the internet for decades. A rename will result in people continue to using
>>> the old code because the old name is the only thing that they know.
>>
>> +1 for keeping the old name.
>>
>> cpu-unit-tests might also not be completely fitting (I remember we
>> already do test, or will test in the future I/O stuff like PCI, CCW, ...).
>>
>> IMHO, It's much more a collection of tests to verify
>> architecture/standard/whatever compliance (including paravirtualized
>> interfaces if available).

Good point.

> Vote for keeping the old name.

Ok, so either old name or alternatively arch-unit-tests?  But the
majority seems to be for kvm-unit-tests, and if Nadav has no trouble
contributing to them I suppose everyone else can too.

Paolo

