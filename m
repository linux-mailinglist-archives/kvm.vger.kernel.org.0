Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BBC28599D
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 09:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgJGHfc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 03:35:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35860 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726041AbgJGHfb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 03:35:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602056130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ca/p2ZhO8Ysd4U+qHMxJRMC1tWokUm/TueisztofumM=;
        b=FpnqJfATMgStaX1q6oSL/P8h20SbbuI1UuxZm1e8SAEoJQuu3NwJqOv+Qyqm6L+WrYAaOE
        RhZOGMXhFi2OSDWzDFST2E5tq1Idq94wSCUlH7tX1g1bvdYg9ZWLkE/EYknLcyAt18XBNW
        6Qjd2WKwE/sY/e1wBGhhZvk2qgxe+N8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-AWhKKxscOsWHAFwkKYoysg-1; Wed, 07 Oct 2020 03:35:28 -0400
X-MC-Unique: AWhKKxscOsWHAFwkKYoysg-1
Received: by mail-wr1-f71.google.com with SMTP id b6so608118wrn.17
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 00:35:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ca/p2ZhO8Ysd4U+qHMxJRMC1tWokUm/TueisztofumM=;
        b=VSP2yQHHm/cEKfBoRsId4mU8D8Sf0g7+C7bQwCkhD96iHWqUM4jhjP7sWqv9dGfCUj
         WLQw/OOo6W6d7AVhiv+zUza/nas444YPA6wP/bkyxB8YTnYipLiwDKg1yF9OwANHcLGE
         /X/r/paXzpsHueqOUFskmKUNwE9eiSX2ft3QzlqULYE0ZWtn3tkjxkPmgKqCccGYO06j
         /SmbrxepU2HbPbp0tG6MqqhKX4XmBPHTrB261+lGhwi12Fak+0v8kYdiFNQvPvz1KrqT
         v23oznragPv18wzdImbNjopL7yIWVnb7de/lW7v7RI2+4HXASuU0gGlg2b3TP6lH5Bjv
         3Bug==
X-Gm-Message-State: AOAM531EBqnAcPVvlbsmDGNVmE5XioczYLjXRJBw58ZL4dv9CQZk/uqN
        s2C+zCI3Kmtpy27veM9YH0fFnxRBL3wqqv2epkRDVJHDT4pJSOfJjSIKMWlpd/tA6e2ANtdLllW
        knzsEVgv014QK
X-Received: by 2002:a1c:152:: with SMTP id 79mr1780785wmb.90.1602056127107;
        Wed, 07 Oct 2020 00:35:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyav6MjH305d11GWO15adQpuSkcTWmJgU+kPXFFIxX6xnjHwRnw+7hSyu74oyLQK72jnLidJA==
X-Received: by 2002:a1c:152:: with SMTP id 79mr1780758wmb.90.1602056126828;
        Wed, 07 Oct 2020 00:35:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d2f4:5943:190c:39ff? ([2001:b07:6468:f312:d2f4:5943:190c:39ff])
        by smtp.gmail.com with ESMTPSA id o186sm1495383wmb.12.2020.10.07.00.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 00:35:26 -0700 (PDT)
Subject: Re: [PATCH v2 1/9] s390x/pci: Move header files to include/hw/s390x
To:     Richard Henderson <rth@twiddle.net>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, alex.williamson@redhat.com, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <1601669191-6731-1-git-send-email-mjrosato@linux.ibm.com>
 <1601669191-6731-2-git-send-email-mjrosato@linux.ibm.com>
 <20201006173259.1ec36597.cohuck@redhat.com>
 <e9f6c3e1-9341-b0d0-9fb2-b34ebd19bcba@linux.ibm.com>
 <1c118c1d-8c9b-9b7b-d1ec-2080aaa1c1a3@twiddle.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9e5c775d-76e1-dee4-56ee-8e8ebee1676f@redhat.com>
Date:   Wed, 7 Oct 2020 09:35:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1c118c1d-8c9b-9b7b-d1ec-2080aaa1c1a3@twiddle.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/10/20 19:33, Richard Henderson wrote:
> On 10/6/20 11:43 AM, Matthew Rosato wrote:
>>> Looks good, but...
>>>
>>> <meta>Is there any way to coax out a more reviewable version of this
>>> via git mv?</meta>
>>>
>>
>> I tried git mv, but a diff between the old patch and the new patch looks the
>> same (other than the fact that I squashed the MAINTAINERS hit in)
> 
> git format-patch --find-renames[=<pct>]
> 
> Though I'm surprised it's not doing that by default.

Yeah, diff.renames should default to true.  But you can try

git config --global diff.renames true

and if it fails

git config diff.renames true

Paolo

