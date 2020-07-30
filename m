Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1A2233324
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 15:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgG3NdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 09:33:11 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:51909 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726275AbgG3NdK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jul 2020 09:33:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596115989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yoofDigctfM1LCNhluEuEXbsP3wkbmZPS2uj7H6BtlY=;
        b=SJ+2Iqbl/5Xh12uWq2Q8oF85Xz5uEq2Y1JaCSpv6Y8Gee7lNzyW2FmSU9FtsPerc39YQ5S
        S9fAgK0z9DXDIHASz9WRvF4iHkCDi1hUggMG1z4t3+sgjnRLGfWW2vZNeikbCEp37anjOg
        LIOct9ptzTzpHwnLa39xOElSBE1MlX0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-si5dTY1FOHiRfIDTZKgS9g-1; Thu, 30 Jul 2020 09:33:07 -0400
X-MC-Unique: si5dTY1FOHiRfIDTZKgS9g-1
Received: by mail-wm1-f69.google.com with SMTP id h6so1392891wml.8
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 06:33:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yoofDigctfM1LCNhluEuEXbsP3wkbmZPS2uj7H6BtlY=;
        b=r4itX9/Lmm+2JCup9oSdk0hzg03Mg/mSrVM/sUvISTJJssnbrhQTzVthqibVLvNVlm
         KOosVucz33bgpDmo9QbvwEl2JOmnQxwuX34G5rJb1y4mrENDg4N91i99plH7xrjBxrh8
         v/8m2xqy3xGLFl/fdbKv8aNONVAu0zeCBXPvwL0TP1YsisIChm7rcbbkw5Nj0Y+Nv9u7
         T2NqZrRHXgr+1lV6CfG1ILkoM/KJ0XzApqYIxqA/bFI3VW5AmDKz91ylMID+7ohLT6l+
         Ot50GHX00ehDpC8SN+Lyx8nYPEU/7XTBq/Rz+R+l2vjHaiLpLm+/mYGWWU5x+KfphoSo
         oL7A==
X-Gm-Message-State: AOAM5318kwIV21PZF5qNyrmWqgc3MYjw0o9g0LdoN7Dq2zkjJw/YbrPs
        6x/wN8b0K69cslDhOsNwrkUFRufz3JfumCHzYnpJ/eLnUHPDY+SY+FJZOLO4f3W4Ul6Af+G2N28
        hzKfc4930xX0O
X-Received: by 2002:adf:ce89:: with SMTP id r9mr3079763wrn.116.1596115986330;
        Thu, 30 Jul 2020 06:33:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwI77ayAVTtCtv5QswHU9dsUiT1TEFXBaIiLvjfRhzkS9BbkhD5lHHX3xFSwxH8ps6cUIqPHQ==
X-Received: by 2002:adf:ce89:: with SMTP id r9mr3079736wrn.116.1596115986066;
        Thu, 30 Jul 2020 06:33:06 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id w132sm2275720wma.32.2020.07.30.06.33.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 06:33:05 -0700 (PDT)
Subject: Re: A new name for kvm-unit-tests ?
To:     Andrew Jones <drjones@redhat.com>, Nadav Amit <namit@vmware.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@redhat.com>, KVM <kvm@vger.kernel.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <dc518389-945a-1887-7ad0-00ebaf9ae30e@redhat.com>
 <682fe35c-f4ea-2540-f692-f23a42c6d56b@de.ibm.com>
 <c8e83bff-1762-f719-924f-618bd29e7894@redhat.com>
 <CANRm+Czsb79JYAHcOm49tg=M2vHdOzh_XFaEcSS_RUPfX3dRuw@mail.gmail.com>
 <c92c6905-fcfb-ea5b-8c80-1025488adc98@redhat.com>
 <1B9660BF-6A81-475E-B80C-632C6D8F4BF9@vmware.com>
 <20200730113215.dakrrilcdz5p4z7e@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7b77d175-d119-0c69-c2ba-2068cfddbbf2@redhat.com>
Date:   Thu, 30 Jul 2020 15:33:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200730113215.dakrrilcdz5p4z7e@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/20 13:32, Andrew Jones wrote:
>> This should have practical implications. I remember, for example, that I had
>> a discussion with Paolo in the past regarding “xpass” being reported as a
>> failure. The rationale was that if a test that is expected to fail on KVM
>> (since KVM is known to be broken) surprisingly passes, there is some problem
>> that should be reported as a failure. I would argue that if the project is
>> hypervisor-agnostic, “xpass” is not a failure.
> We can use compile-time or run-time logic that depends on the target to
> decide whether a test should be a normal test (pass/fail) or an
> xpass/xfail test.

Yeah, that would be basically the old "errata" mechanism.

Probably we should have some kind of configure script that builds
"errata" files based on hypervisor, uname or whatnot.  (Upstream should
do the bare minimum, just the hypervisor).

Paolo

