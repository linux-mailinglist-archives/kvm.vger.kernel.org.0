Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455E22B82A3
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 18:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbgKRRFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 12:05:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33310 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727296AbgKRRFY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Nov 2020 12:05:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605719123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g2Sa7Dk+sRaVjGw/kocptUkYSTQ4KlbBdgTfGZ6iYVI=;
        b=KSar3OJREcMCVWRPNfh5oMss2zC+g9MIGhCDg//dFO5r8Z1q2BqP3nYYb5FPhGKa/z8NHw
        w5UsY02D3YsT3t95Om1uqqmzHL9glJjvyzib1tgqDEE+pS90WJjUQQwfyLNlZqwL+XqBHj
        +0JQJY8VwBKF1S1XTydVntcw/DBiu6U=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-7N5NNz5zM_KNux8RxdL_eA-1; Wed, 18 Nov 2020 12:05:21 -0500
X-MC-Unique: 7N5NNz5zM_KNux8RxdL_eA-1
Received: by mail-ed1-f70.google.com with SMTP id i89so1064220edd.15
        for <kvm@vger.kernel.org>; Wed, 18 Nov 2020 09:05:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g2Sa7Dk+sRaVjGw/kocptUkYSTQ4KlbBdgTfGZ6iYVI=;
        b=SaZD1c//UyMvaJNnhjTS9s3TJJhVMU198t2niSTP+O96YehgkVrWG31fHTtzIf6Q7/
         sBIC2Uu9vTY7SbhZdWL9VIjwi391MMMopIVDSwJN6U5VNP5+RTYsX3TBOziSqRIqvzRg
         az7PxhBtWtq4sVfU80V/d4BUvZdRiE2bqi2+jN3IToFz8rBEN+4wu8tIlKQwB9BTJtxq
         Qx2nqtCa8TLw8yRaRMH+pDbt5BOzMDEWqQNcXFkFMrL0EAhzTi4dU+zryIbzkj36uXVp
         GKpfWLRBbXUHQCTmVDOdE1k6miPgtGvtqyuNUV+3XeSNH4wYweMbgPoWmb3rTC2AGa3d
         7eDw==
X-Gm-Message-State: AOAM533wbFRWSLct/7Po6REqFp9/v9VCh2ugZdyW1u/JticAKi6XW7zf
        KPMKutHDnWnMGjNynS3x11PIZP4QTzW6KENM9Sg/XU+11yi0AaXo+yEIBHK1HD5G+JcjPOAqnkB
        RwUknyPjVJSxj
X-Received: by 2002:aa7:d1c6:: with SMTP id g6mr26334330edp.130.1605719119183;
        Wed, 18 Nov 2020 09:05:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzgwh2sv6DLtuw6oIcxYVFRbTJQEgIArwhuwYd5WcEHzJokzEqwDN8h59ePpZ8Kvx8efo3nCg==
X-Received: by 2002:aa7:d1c6:: with SMTP id g6mr26334287edp.130.1605719118783;
        Wed, 18 Nov 2020 09:05:18 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u15sm5518502edt.24.2020.11.18.09.05.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 09:05:17 -0800 (PST)
Subject: Re: [GIT PULL 0/2] KVM: s390: Fix for destroy page ultravisor call
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <20201118170116.8239-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0e6ed560-9e75-e596-174b-8f10a078c761@redhat.com>
Date:   Wed, 18 Nov 2020 18:05:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201118170116.8239-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/11/20 18:01, Christian Borntraeger wrote:
> Paolo,
> 
> one more fix for 5.10 in addition with an update of the MAINTAINERS
> file. The uv.c file is mostly used by KVM and Heiko asked that we take
> care of this patch.
> 
> The following changes since commit 6cbf1e960fa52e4c63a6dfa4cda8736375b34ccc:
> 
>    KVM: s390: remove diag318 reset code (2020-11-11 09:31:52 +0100)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.10-2
> 
> for you to fetch changes up to 735931f9a51ab09cf795721b37696b420484625f:
> 
>    MAINTAINERS: add uv.c also to KVM/s390 (2020-11-18 13:09:21 +0100)
> 
> ----------------------------------------------------------------
> KVM: s390: Fix for destroy page ultravisor call
> 
> - handle response code from older firmware
> - add uv.c to KVM: s390/s390 maintainer list
> 
> ----------------------------------------------------------------
> Christian Borntraeger (2):
>        s390/uv: handle destroy page legacy interface
>        MAINTAINERS: add uv.c also to KVM/s390
> 
>   MAINTAINERS           | 1 +
>   arch/s390/kernel/uv.c | 9 ++++++++-
>   2 files changed, 9 insertions(+), 1 deletion(-)
> 

Pulled, thanks.

Paolo

