Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A16616A6D2
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 14:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgBXNGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 08:06:19 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26251 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727329AbgBXNGT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 08:06:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582549578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yLmhaXFq9qnU+powtwGl3ZF8L7l7j/vIv8KeXymnTxo=;
        b=iTJq7wLB27n01j7zFr/Bo8/bVQm0omOwZgS0+gpoNdJ1+tcpHGmX/+6OC0oRLxuU/v0mbP
        kndk9Pd2Fn0fFfwRQ1btozd4BWpB9eroGu/r2UyAVQByGTZXS0z7v5r3bIq6wQd+Xx3WGy
        BDFkPE02Cvc25Mczq8Jx/70AK7ept94=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-VVbSNxWWNIufY1mQDIk43A-1; Mon, 24 Feb 2020 08:06:14 -0500
X-MC-Unique: VVbSNxWWNIufY1mQDIk43A-1
Received: by mail-wr1-f69.google.com with SMTP id h4so344086wrp.13
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 05:06:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yLmhaXFq9qnU+powtwGl3ZF8L7l7j/vIv8KeXymnTxo=;
        b=UHMuY+dsRdZccF8y5yo4ASeDpMEBnmjsUhNrulM/0FEmmZAmqleJ1jpK88XdrPinmb
         Dw4JxMeV/dBzmcrWBCs91rLNZlUG5Q0uef04yHfYW7Jmu6F5HnFpPs/Xw47yp0ZuGjPQ
         18kEoQKQGE8o/Scc/Zv3rK7YuDDxfK/ATUxhhJDAJHXQlZbyLw5YsLPXPqq+sN7dbVNL
         Ep+n3ZD1zi85BKFyxyIg8uQU9l6T2D8EvQBbkEkFVmYMVfLRSsOHyiqP9Sge6E9KtQz1
         WX8biWm2HTxwqcH9JBMOXlXiQ1TfvSlj+E/C23rfZTz8VlopJGM9OP3L5rKkbfwIrDDd
         0uXA==
X-Gm-Message-State: APjAAAXYJAhVBbVZAJDSQgsKfKv0RaCu6ZQFfchjpZDBY1Me83TvoBoD
        wwiZy7DtA56rr2FlRBAdJqRTzVWT3EGknKKvKYoaGVjvGENP5Q0n5I63XWDurIEpD7g6+jkUve7
        IXbn+DmILXv3K
X-Received: by 2002:a1c:4c13:: with SMTP id z19mr21756304wmf.75.1582549573340;
        Mon, 24 Feb 2020 05:06:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqwNszRPZTmFvXNqR5FAhlQK3xRk59jChIGRkQ+lE5gH+dc2avcK6QahS2yJd9dGwfTXfTlLtg==
X-Received: by 2002:a1c:4c13:: with SMTP id z19mr21756269wmf.75.1582549572739;
        Mon, 24 Feb 2020 05:06:12 -0800 (PST)
Received: from [192.168.178.40] ([151.21.175.179])
        by smtp.gmail.com with ESMTPSA id o9sm19006167wrw.20.2020.02.24.05.06.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 05:06:12 -0800 (PST)
Subject: Re: kvm-unit-tests : Kconfigs and extra kernel args for full coverage
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        kvm list <kvm@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, yzt356@gmail.com,
        jmattson@google.com, namit@vmware.com,
        sean.j.christopherson@intel.com,
        Basil Eljuse <Basil.Eljuse@arm.com>,
        Andrew Jones <drjones@redhat.com>, alexandru.elisei@arm.com
References: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b0b69234-b971-6162-9a7c-afb42fa2b581@redhat.com>
Date:   Mon, 24 Feb 2020 14:06:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/02/20 13:53, Naresh Kamboju wrote:
> [Sorry for the spam]
> 
> Greeting from Linaro !
> We are running kvm-unit-tests on our CI Continuous Integration and
> testing on x86_64 and arm64 Juno-r2.
> Linux stable branches and Linux mainline and Linux next.
> 
> Few tests getting fail and skipped, we are interested in increasing the
> test coverage by adding required kernel config fragments,
> kernel command line arguments and user space tools.

The remainins SKIPs mostly depend on hardware, for example "svm" only
runs on AMD machines and "pku" only on more recent Intel processors than
you have.

> FAIL  vmx (408624 tests, 3 unexpected failures, 2 expected
> failures, 5 skipped)

This could be fixed in a more recent kernel.

Paolo

