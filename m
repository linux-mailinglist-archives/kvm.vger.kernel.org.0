Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77503EFE29
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 09:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239348AbhHRHqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 03:46:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47453 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239331AbhHRHqh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 03:46:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629272763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WCowTlaMQAD68xtCnxiOgZAAhU7pcJc15uXzKgwx1gA=;
        b=H/MEy0B+hJJrBr0LdAYdm/NQw7n4iKjMtW7HL044VrrW7viEvrjh1GBW8f8VTG/opoHuXl
        coUbapr8z0wwE8GDxkQriTqoKmRwE84t9QRkqeEP8BsM5U38yesuoMZXW/XfoPRjaX0o/l
        wgCJj7Bh2Crf33a6phh4O0yJPrJ4vz0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-v4NMTtVQPwG6AQnYb8ijKQ-1; Wed, 18 Aug 2021 03:46:02 -0400
X-MC-Unique: v4NMTtVQPwG6AQnYb8ijKQ-1
Received: by mail-ej1-f69.google.com with SMTP id k21-20020a1709062a55b0290590e181cc34so564335eje.3
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 00:46:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WCowTlaMQAD68xtCnxiOgZAAhU7pcJc15uXzKgwx1gA=;
        b=gSaJ2vPTC/pL+RzszynUhPMwnEhD5noYC5Ti2z5YNfIcVhyWY4w92NCvCPZE2+yLqA
         Lj5wYo6z6mLjWGYrBy27OmA/uI2S+MLWNlH3YhvMJvvgSZ56YaalpakdBM/ZUXz1+d5X
         zyGi4EDHTruxX/uhyJy3RHPf72bSSXsXpeRxQgkT1rumjiTLP3jrgJ2rL9L7viwcsu9q
         cdL8yWwjZkMqNcBiSPqSHV+UyxiQ+UoKzpeWkS+SaX9AclEPd8Mo+bAvxqn75XRrEiSH
         mJQXXXwt7VZ+QS3QvWe6F5TOIjE9813mAeLBUfYTRB+Y6V7WYdD5PqTUGusbFdrlPagE
         7vgQ==
X-Gm-Message-State: AOAM5315P4HdHLWdo0ruXCHfN/HcDabDgCoBfdr+ErQQ1/Ke941uhfAU
        b/okdTtf9vDvfXRJHBbBjTrMojU1FToYI6OF4pe8Cm+G0yNxuTCoIBi3qzCa3J5n7c/aaUB8hZB
        rgYwyf0/ek+xO
X-Received: by 2002:aa7:c952:: with SMTP id h18mr8764965edt.18.1629272760827;
        Wed, 18 Aug 2021 00:46:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhDmLt+U3d68thSr+ArCpDO4Vg0vRAT+H0A6FI4PylM3dlwrN11JjJ5ZfPGFw43nLyFFFuHw==
X-Received: by 2002:aa7:c952:: with SMTP id h18mr8764954edt.18.1629272760698;
        Wed, 18 Aug 2021 00:46:00 -0700 (PDT)
Received: from thuth.remote.csb (pd9e83070.dip0.t-ipconnect.de. [217.232.48.112])
        by smtp.gmail.com with ESMTPSA id v8sm1667329ejy.79.2021.08.18.00.45.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 00:46:00 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 2/4] s390x: lib: Simplify stsi_get_fc
 and move it to library
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <1628612544-25130-1-git-send-email-pmorel@linux.ibm.com>
 <1628612544-25130-3-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <887680c1-f5e7-0fdb-2195-e501e607c905@redhat.com>
Date:   Wed, 18 Aug 2021 09:45:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1628612544-25130-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/08/2021 18.22, Pierre Morel wrote:
> stsi_get_fc is now needed in multiple tests.
> 
> As it does not need to store information but only returns
> the machine level, suppress the address parameter.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   lib/s390x/asm/arch_def.h | 16 ++++++++++++++++
>   s390x/stsi.c             | 20 ++------------------
>   2 files changed, 18 insertions(+), 18 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

