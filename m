Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8556CD2E46
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 18:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbfJJQE0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 12:04:26 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53796 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725901AbfJJQE0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Oct 2019 12:04:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570723464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=3SdedBbwP9ly3IDtgHUST6OS/qG0JYGTT+oEOYjuUFA=;
        b=Nc+9PD6zpEEa2aVE5USX0D6FDG2q3hev02PzsG5QreZVyUM2ESOOsDctOUxjrgjp4WWmx8
        hIyOhAUMJi1gfnxFMXPWNB+aSpQ9l4dPVFkdLWrtIRyhrVMhatEW0WKMgL9Cd9sajmZcNU
        /Mxd20lU/P/dccppqp1dfphCPz+CX0k=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-_-mQpZeIPtia230GxfQw9g-1; Thu, 10 Oct 2019 12:04:23 -0400
Received: by mail-wr1-f69.google.com with SMTP id z17so2961853wru.13
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 09:04:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pQ3pITPkggvTfIS/fIEijWZX5PZc/La9e+sQ/rZk2Y4=;
        b=L5o6D9PHLa7Wdr0gl/24m6n1SB6jijCm2UCRxcYbBnujfiCslxtawjQ6uugIU8Jiu4
         h5eDlDfOL4RsCQQo5qcYb30bBWfBWbs7b27s5yLCekRr9YbBLXChxA3jjdqc9Ij/yxVv
         TGxZXJVpxu9rvS9jbfpa6Y/RETlglKTPViS//Fp3B9WpDRckPgRYBCJQwSeJSIug8ujv
         UyFSWMa4IkRYHNCv80YqUKy7s8tXJJ8f+x4qcPA56fYGv7GpC1ToVnAbVM7nw6QcOHFX
         g2hkuvHo/sdopqxLMhy+1f3xBvCguDE/QfrejrjF1znpeSe6bheOJESapaucGom0kGlf
         /WOw==
X-Gm-Message-State: APjAAAVkXydMTZmSrpJckbLBBzvwOP3wm/zYcet7BOo4lzjC/Q56r4qU
        nRh5iuV6Amgxrfs9XDWhWDyH7OAxOBHMr5b+NHQ46tIrTMrAPJGzmn1mb3PRvW3yvgt3u5whIpJ
        ZB7l3XO2fE7tP
X-Received: by 2002:adf:ed43:: with SMTP id u3mr9175218wro.236.1570723462067;
        Thu, 10 Oct 2019 09:04:22 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx5ADAJufjyriPK8nT5Qx6/JZsQlEUDmllTBUHztcrWtcLtbvQpKZRIzkpYSOzgKz3ZW+7Tuw==
X-Received: by 2002:adf:ed43:: with SMTP id u3mr9175189wro.236.1570723461778;
        Thu, 10 Oct 2019 09:04:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e? ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
        by smtp.gmail.com with ESMTPSA id r65sm7822021wmr.9.2019.10.10.09.04.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2019 09:04:21 -0700 (PDT)
Subject: Re: [Patch 3/6] kvm: svm: Add support for XSAVES on AMD
To:     Aaron Lewis <aaronlewis@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
References: <20191009004142.225377-1-aaronlewis@google.com>
 <20191009004142.225377-3-aaronlewis@google.com>
 <20191009064425.mxxiegsyr7ugiqum@linutronix.de>
 <CAAAPnDHUAxHAfxUMsG0-zbBVGZ1EJx3bB+z327c1HrCYgH2o0g@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e58ee15a-63f1-6496-5236-2659739c6515@redhat.com>
Date:   Thu, 10 Oct 2019 18:04:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAAAPnDHUAxHAfxUMsG0-zbBVGZ1EJx3bB+z327c1HrCYgH2o0g@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: _-mQpZeIPtia230GxfQw9g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/10/19 16:42, Aaron Lewis wrote:
>>> Hoist support for IA32_XSS so it can be used for both AMD and Intel,
>>> instead of for just Intel.
>>>
>>> AMD has no equivalent of Intel's "Enable XSAVES/XRSTORS" VM-execution
>>> control. Instead, XSAVES is always available to the guest when supporte=
d
>>> on the host.
>>
>> You could add that implement the XSAVES check based on host's features
>> and move the MSR_IA32_XSS msr R/W from Intel only code to the common
>> code.
>
> Isn't this covered by my comments?  I mention that we are hoisting
> IA32_XSS to common code in the first comment, then in the second
> comment I say that XSAVES is available in the guest when supported on
> the host.

Yes, I agree.

Perhaps you can add something like "Fortunately, right now Linux does
not use MSR_IA32_XSS so the guest's usage of XSAVES will be a glorified
XSAVEC, and cannot bypass vmexits for MSR loads and stores".

Paolo

