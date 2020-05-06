Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0461C700F
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 14:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgEFMM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 08:12:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33290 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727777AbgEFMM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 08:12:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588767175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mGKAKOoXib9J9GLorrHt4wp5oK180n6GKU4cMIBxKAk=;
        b=flHknYVt0fKo7ce1PxKSwsHp1R5cRuaLnwFBHlxB/87xAHvAAxUx+azeeDZDnCWbDi/H+J
        zL3mcq+Hb2vtA0HU1r1eiIx6njCurANsE7CGup/C00/nUr2mAVBE6FwgNhgNPZ05L8eu7U
        79eoI/Cv84aLzDwKL0frAHF7bGBXFQU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-ZzkzU8rcOGOM5uUll5Di3g-1; Wed, 06 May 2020 08:12:52 -0400
X-MC-Unique: ZzkzU8rcOGOM5uUll5Di3g-1
Received: by mail-wm1-f69.google.com with SMTP id f17so674880wmm.5
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 05:12:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mGKAKOoXib9J9GLorrHt4wp5oK180n6GKU4cMIBxKAk=;
        b=EbpG4WdoJvG3x/tSg3kLwGfIB06vnUgTyEdC/Z2yaEMBEvF3KMpsctRvl0/fT4ZQ1c
         bdE5MTlszQykYjY85ZOxWnWCOkN2E4MQseDCHbbOxcoYMMogR569XgZyhF0HzdGiV+Da
         W9XT2JniifSFG4tKE7IeZXO+J0GCbNd2jjkFAeC3vgOMlg+YDoKh2DbDq/gKfLJ9sWHo
         4mATRFt2s7cCh5SYBuOVFn4R0rRKmyCQfQVB4Q4FwBZy3vMvxpB46opX2oj48gkcEm1T
         +9KmtRzaoKyn9btCpBQ9+LZadwAJKBML5lapGRgUZvuH8wK6Root4HCaAg7OnnUpE3dw
         JnDQ==
X-Gm-Message-State: AGi0PuajJFHnStcnY+DRvDnMBC16+0FQZHyVx8lM/Tl19M0T/gvCyECz
        AwYNfER4cjcEw9YyPS301P2MtCQ4LeYdfX+Zp2eYguEobNYO9JW+HhAXTgQLwWIy1A2zXRPAN7Y
        BGYB2R2i7o1yT
X-Received: by 2002:a1c:5403:: with SMTP id i3mr4520787wmb.10.1588767170595;
        Wed, 06 May 2020 05:12:50 -0700 (PDT)
X-Google-Smtp-Source: APiQypKzFzMB1AUH6OYu+u4u9EhJqeki41lDE4NjZD/BfMex3GyyxvZlvlNEqY2FSNPFuCVgRMQODA==
X-Received: by 2002:a1c:5403:: with SMTP id i3mr4520743wmb.10.1588767170169;
        Wed, 06 May 2020 05:12:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:11d7:2f21:f38b:17e? ([2001:b07:6468:f312:11d7:2f21:f38b:17e])
        by smtp.gmail.com with ESMTPSA id k23sm2529672wmi.46.2020.05.06.05.12.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 05:12:49 -0700 (PDT)
Subject: Re: [GIT PULL 0/1] KVM: s390: Fix for running nested under z/VM
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
References: <20200506115945.13132-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <918fcace-dac6-bc33-6713-19703fc96180@redhat.com>
Date:   Wed, 6 May 2020 14:12:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200506115945.13132-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/20 13:59, Christian Borntraeger wrote:
> Paolo,
> a fix for kvm/master.
> 
> The following changes since commit 2a173ec993baa6a97e7b0fb89240200a88d90746:
> 
>   MAINTAINERS: add a reviewer for KVM/s390 (2020-04-20 11:24:00 +0200)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.7-3
> 
> for you to fetch changes up to 5615e74f48dcc982655543e979b6c3f3f877e6f6:
> 
>   KVM: s390: Remove false WARN_ON_ONCE for the PQAP instruction (2020-05-05 11:15:05 +0200)
> 
> ----------------------------------------------------------------
> KVM: s390: Fix for running nested uner z/VM
> 
> There are circumstances when running nested under z/VM that would trigger a
> WARN_ON_ONCE. Remove the WARN_ON_ONCE. Long term we certainly want to make this
> code more robust and flexible, but just returning instead of WARNING makes
> guest bootable again.
> 
> ----------------------------------------------------------------
> Christian Borntraeger (1):
>       KVM: s390: Remove false WARN_ON_ONCE for the PQAP instruction
> 
>  arch/s390/kvm/priv.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 

Pulled, thanks.

Paolo

