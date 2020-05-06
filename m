Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75D01C700B
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 14:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgEFMMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 08:12:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28590 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727067AbgEFMMf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 08:12:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588767154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ybp99ie0cZbrJsaPu3fRVqjLiBB0hnNYN5fy/Wmj9SE=;
        b=PKzxLcO4flN/sI7bOigI8pYa+i4s4esKBtks3puf5P8MrI8qcqZOrpGfU9O92v593KWTlD
        edWs1L3G2jJKTYYuv7mPOAF3B87T5UrcuptKzOFPnrpdlUF+ijnyO5YyWcy4U8/VMP78kl
        MwQZpNiFCBuB/2JVRcDTcEMmiPms8+Q=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-aTFivMjOMW-vyA70vT_Sqw-1; Wed, 06 May 2020 08:12:32 -0400
X-MC-Unique: aTFivMjOMW-vyA70vT_Sqw-1
Received: by mail-wm1-f69.google.com with SMTP id w2so1122585wmc.3
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 05:12:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ybp99ie0cZbrJsaPu3fRVqjLiBB0hnNYN5fy/Wmj9SE=;
        b=uc0nO+i+TnWmfKjWXlWzbv3PQMvZv2jbAZL2ErdgvEGXff3hkBWZ5VXGWvPrqsHe25
         sJHrZZ+7vkzfrT/fNC+AT5R/3FxXUtAX4vhIhqN5Ua/F592Tohrz8t00n4mD/0pIH8n1
         ntJh82eMLsJOhDzcA0CqhZsPD5sIFiPPFf40tsZtsRO68qOkPc1WBKoVXl/U5AaIFxGk
         tHBNuvq6CD0OWth33VWyjWjXOteaCkZhnQsZeo1DFGSdOzXHXyeSAzyySiCreKpqYsDQ
         SXck43XqnRCDyqYM/x1vZ87HPJQlxLjhBH4jrgXJfB5FvULguuPccqdCuo+69EBh22uM
         pN+g==
X-Gm-Message-State: AGi0PubI2pu6AWqOLxKFwaQGAj3sk/H4S/xRz8Mlim1ovkDx/lIYNuWt
        4jNBW2UN4RbuE28ydMI13SnbCj1eehyH7Jv0+s0wll04uMtkyyMcI92j67lS2/vXPt2iygSdLmi
        6UIUDkYe7gb/S
X-Received: by 2002:a1c:6402:: with SMTP id y2mr4149173wmb.116.1588767151387;
        Wed, 06 May 2020 05:12:31 -0700 (PDT)
X-Google-Smtp-Source: APiQypKA0dkO+kUYpZP4gWFbcPSl/DNfe0d39YUqIA7R6bHmLSW3U7w+KDm1VQ6rvIbX7CmDagIXNA==
X-Received: by 2002:a1c:6402:: with SMTP id y2mr4149141wmb.116.1588767150993;
        Wed, 06 May 2020 05:12:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:11d7:2f21:f38b:17e? ([2001:b07:6468:f312:11d7:2f21:f38b:17e])
        by smtp.gmail.com with ESMTPSA id p190sm2745441wmp.38.2020.05.06.05.12.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 05:12:30 -0700 (PDT)
Subject: Re: [GIT PULL 1/1] KVM: s390: Remove false WARN_ON_ONCE for the PQAP
 instruction
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Qian Cai <cailca@icloud.com>
References: <20200506115945.13132-1-borntraeger@de.ibm.com>
 <20200506115945.13132-2-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bcd98cbd-1e28-47a2-6cbd-668da4ddb9f5@redhat.com>
Date:   Wed, 6 May 2020 14:12:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200506115945.13132-2-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/20 13:59, Christian Borntraeger wrote:
> Running nested under z/VM can result in other intercepts as
> well as ECA_APIE is an effective bit: If one hypervisor layer has
> turned this bit off, the end result will be that we will get intercepts for
> all function codes. Usually the first one will be a query like PQAP(QCI).
> So the WARN_ON_ONCE is not right. Let us simply remove it.

Possibly stupid question since I can only recognize some words here. :)
But anyway... shouldn't z/VM trap this intercept when the guest has
turned off the bit, and only reflect the SIE exit based on the function
code?

Thanks,

Paolo

