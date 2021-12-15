Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFA0475993
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 14:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237399AbhLONYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 08:24:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48152 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237419AbhLONYe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Dec 2021 08:24:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639574674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=faX0xzTuw4r5Ss1p1Z66O3C+rjUZMW4qDeU2/6j1vvQ=;
        b=B0tBW3Iv4VJi6HafhbAT2cNrO+1o1JkbEZeU86ah7IK/KSPLo13Nl7CbuHXcHLUpVqKslH
        +iiG+SWpPlbb7EFHFG5wEIrvsZYwkk4jv8LVU1YEYq609Cv6+lnaRhAsigB0vZT6m+DrSO
        L2YDG4ZWaG2ur0iRwmOOrE0VQZskDYU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-VDwPgsw-OBCga6fnWoz7UA-1; Wed, 15 Dec 2021 08:24:33 -0500
X-MC-Unique: VDwPgsw-OBCga6fnWoz7UA-1
Received: by mail-wr1-f70.google.com with SMTP id v17-20020adfedd1000000b0017c5e737b02so5888821wro.18
        for <kvm@vger.kernel.org>; Wed, 15 Dec 2021 05:24:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=faX0xzTuw4r5Ss1p1Z66O3C+rjUZMW4qDeU2/6j1vvQ=;
        b=p5WkhwBWQSXLUd2e3c1XyVDgzZkI28pPTaRPNS121Ejn/dp3X5UeM+kz50Q4NpuJy3
         Ixg8yl/I4kt+HJAPTMR43od+gW4l8eCzzvUtezEsSo9UN0T1wyrIWuggtJepLIHA8A2p
         9DuW1mK5DigYkkOzVW9jchpoG8HO1+YJ3CkFUczpj7ZeA1yYXMirrNb/jBKQ7RUSJIEl
         tz0PQE8LMV0vTPTEQ80WNqI/Ca5eJnZdFqzLoSn50ZEhDUuT5AcLWdnchBSgvBSrf2Is
         esGcd+ZDIrnCmAakbSRaAekFQbhve4YGkTwvWEe1wQds0oJ9Vq3H/TEqvMkEdURjJFQo
         PW9Q==
X-Gm-Message-State: AOAM532twIDujHCj/ebJS1EYn82QUg3iwADwJ0qIOvO9XP0DO2BNPjMv
        CaZdplDzzgfNDQGDdfq0rxz6FaHxdUiCXmek/zGQdmD67S7Kc0yy+EpiyRntA07/QmfJMXHB8SR
        qgwD6935mMGGC
X-Received: by 2002:a5d:4e92:: with SMTP id e18mr4477443wru.89.1639574672097;
        Wed, 15 Dec 2021 05:24:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxvYE115YTEnXyOnYw+6M9nPcYQcDwa5GAYcHppd/Ruc2VVaVYWw55fHwyFOHuOPUuAyhomuw==
X-Received: by 2002:a5d:4e92:: with SMTP id e18mr4477429wru.89.1639574671898;
        Wed, 15 Dec 2021 05:24:31 -0800 (PST)
Received: from [192.168.3.132] (p5b0c609b.dip0.t-ipconnect.de. [91.12.96.155])
        by smtp.gmail.com with ESMTPSA id b132sm1894704wmd.38.2021.12.15.05.24.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 05:24:31 -0800 (PST)
Message-ID: <3832e4ab-ffb7-3389-908d-99225ccea038@redhat.com>
Date:   Wed, 15 Dec 2021 14:24:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH v5 1/1] KVM: s390: Clarify SIGP orders versus
 STOP/RESTART
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211213210550.856213-1-farman@linux.ibm.com>
 <20211213210550.856213-2-farman@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20211213210550.856213-2-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13.12.21 22:05, Eric Farman wrote:
> With KVM_CAP_S390_USER_SIGP, there are only five Signal Processor
> orders (CONDITIONAL EMERGENCY SIGNAL, EMERGENCY SIGNAL, EXTERNAL CALL,
> SENSE, and SENSE RUNNING STATUS) which are intended for frequent use
> and thus are processed in-kernel. The remainder are sent to userspace
> with the KVM_CAP_S390_USER_SIGP capability. Of those, three orders
> (RESTART, STOP, and STOP AND STORE STATUS) have the potential to
> inject work back into the kernel, and thus are asynchronous.
> 
> Let's look for those pending IRQs when processing one of the in-kernel
> SIGP orders, and return BUSY (CC2) if one is in process. This is in
> agreement with the Principles of Operation, which states that only one
> order can be "active" on a CPU at a time.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---

In general, LGTM. As raised, with SIGP RESTART there are other cases we
could fix in the kernel, but they are of very low priority IMHO.

-- 
Thanks,

David / dhildenb

