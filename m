Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD4F48D9C5
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 15:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbiAMOga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 09:36:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31753 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235712AbiAMOgW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 09:36:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642084581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IgjOVeBDkVjVu0DqCL0W103eS8yEjSifpQfplyuzn/Y=;
        b=C6AMoAJ++bbJukIIgXarjgKgt+SQiDuY2zunoOpdc/aHvHVxhi/egTrMr7Cp10yPYFD3u9
        JfIg7fylWpgiA2NpNCvJC44RPsxxsQx5qy84m6ge8WwIV7byfYVECfl3GuIaauE0o82afv
        WV22IMncmPAwyGbyWD6FSD8/DfJm0Qs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-NiRLQPKcPASfkO6VND8C4g-1; Thu, 13 Jan 2022 09:36:20 -0500
X-MC-Unique: NiRLQPKcPASfkO6VND8C4g-1
Received: by mail-ed1-f70.google.com with SMTP id g11-20020a056402090b00b003f8fd1ac475so5546965edz.1
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 06:36:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IgjOVeBDkVjVu0DqCL0W103eS8yEjSifpQfplyuzn/Y=;
        b=cSSMp/I92Hm+8FrBOYbL8wgJ9NO0VAH/+SMe0cBtFqdx0YDtQgE/00RBdmSfG0ihpO
         4DiFtor9JDikdQhaOM39wG4h8O1XpOkaZu9Ztan/BbC71C8wur0N9aeTHjXf51+VkDi/
         Ht2hRZ/bZ4LdE6TjLwIS2vlGq718Q8M0nZC94y2wiQ2+3LxPxADtY7yzL0i5iw6PUh50
         dkkQtcZEploEqe/1obKumgH0kD22YJSrvlzRCram403Ej2Q+n84Spaj2sSQS/diS6KMr
         P1r2CyMdO8FqVhd4KP4iVZD6ENjO2rxBAamr/aePcdYqsHtxZYQWSMi1eTUTSyAlXKz3
         qEtg==
X-Gm-Message-State: AOAM532LhxTdYlwddVXTxfZ8asDDrly8XvdvPZX/v0inx62YmUZcpsGa
        t60cQAQei5tULIGcBFQ1539HVw3Z70uMEdBZOrtpg8sw1F6Ablofe6dq+eu5/bFWs8iTB99r3lV
        PpaoDgZwcC0XK
X-Received: by 2002:a17:907:6e0c:: with SMTP id sd12mr3795820ejc.536.1642084578969;
        Thu, 13 Jan 2022 06:36:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzOD4ZuNaqfWJsHOyQAzWBVTLHAz0c77AXhRgw1f3/AHOJfF9Qynw12hmuu+NaWD8zPJOqGKw==
X-Received: by 2002:a17:907:6e0c:: with SMTP id sd12mr3795799ejc.536.1642084578695;
        Thu, 13 Jan 2022 06:36:18 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id gb35sm941164ejc.36.2022.01.13.06.36.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jan 2022 06:36:17 -0800 (PST)
Message-ID: <bdad7add-408f-e649-c796-6f83420077fc@redhat.com>
Date:   Thu, 13 Jan 2022 15:36:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: KVM: Warn if mark_page_dirty() is called without an active vCPU
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     butterflyhuangxx@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <e8f40b8765f2feefb653d8a67e487818f66581aa.camel@infradead.org>
 <20220113120609.736701-1-borntraeger@linux.ibm.com>
 <e9e5521d-21e5-8f6f-902c-17b0516b9839@redhat.com>
 <b6d9785d769f98da0b057fac643b0f088e346a94.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <b6d9785d769f98da0b057fac643b0f088e346a94.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/22 13:30, David Woodhouse wrote:
> Are you proposing that as an officially documented part of the already
> horrid API, or a temporary measure:)

Hopefully temporary, but honestly you never know how these things go.

Paolo

