Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43BF0121962
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 19:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfLPSuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 13:50:18 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24145 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727223AbfLPRv4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Dec 2019 12:51:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576518715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=agJTA0FhEzzrZiShheQLO++OwGjG46qf1y0t3cPS+yM=;
        b=UMBoMRt6c5yN98+hr/Qi3Nbe9ncRpMmdCLc5u/2vncAFnWwV95QUL9e9FdtnXVcguZS8vT
        Q7O08e87ePBL+kq00Zwksep0D5MuG11VVhNWe87xNkkjtM0MxD+zhnxsCzsjmNFuNeSDQ6
        U6xjnWeE8cTWDpSLiNcml3aD9Uy4bX8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-iuNC3rBHPDKcV7UbG8mI_Q-1; Mon, 16 Dec 2019 12:51:54 -0500
X-MC-Unique: iuNC3rBHPDKcV7UbG8mI_Q-1
Received: by mail-wr1-f70.google.com with SMTP id c6so4060988wrm.18
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 09:51:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=agJTA0FhEzzrZiShheQLO++OwGjG46qf1y0t3cPS+yM=;
        b=OswKqzQSiGsjq2UWaLwRXjm8yqjZog7qzFZ030slJnHAvRoad7/3TTXySZh5j+wow/
         XNb0VUGl0UKFwyYB+TGDRaEI/Q3XeG4BHmFSum0dP0zJJTcM7OGsQRDX33COWUiMPsJW
         bUawGY6XM6OmX3gFOCLntQ6sO1K3KdKY+/g8ECmIbrEVVBUlsEiCHPi/vwr9DnM5f81B
         wQ0upDoJyuk6Z+pusa4Iarn0DU+mcZ1vmk6xanIknWVH1tuhJUxx8q9b3hS9wNeWun4Q
         7jvy4OMQaQRxGxQztIEQl1iHjRrWC8Gvlrwt34oLinIFAaOh9xE4qrpVWk6jpqNnvarg
         xoUg==
X-Gm-Message-State: APjAAAVcypD7zW+s7+dAX7uYlV8b628m2me55PeaBN3C7E5wbPHLdVAa
        +HAWYxaxHJBRB4KTScqa+gfFbN3+rAV83ipj1E0gbMHG+kIUeQ5pHPk7J27ITm8454e73c3X3A3
        7Y9Rw6ZPkM8+1
X-Received: by 2002:a1c:488a:: with SMTP id v132mr178977wma.153.1576518712717;
        Mon, 16 Dec 2019 09:51:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqysP1+iegsWK4ZyImuYtLx05AvxMKrQzL/7fehKa36BQ68KaunRHEYunty3fNBokVJqTe4QIA==
X-Received: by 2002:a1c:488a:: with SMTP id v132mr178955wma.153.1576518712515;
        Mon, 16 Dec 2019 09:51:52 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id n67sm166187wmb.8.2019.12.16.09.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 09:51:51 -0800 (PST)
Subject: Re: [PATCH v2] kvm: x86: Add logical CPU to KVM_EXIT_FAIL_ENTRY info
To:     Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>, Oliver Upton <oupton@google.com>
References: <20191214002014.144430-1-jmattson@google.com>
 <81C338F8-851B-471C-8707-646283167D57@oracle.com>
 <CALMp9eTQf-htu-6R=VM+r8VmeBPwrVZArJaU6MnGD2m3hn+6jQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a319d0be-db7e-9650-62da-d70b2cc53709@redhat.com>
Date:   Mon, 16 Dec 2019 18:51:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eTQf-htu-6R=VM+r8VmeBPwrVZArJaU6MnGD2m3hn+6jQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/12/19 18:43, Jim Mattson wrote:
> That's a good point. We had one case of numerous VM-exits for INIT,
> and I'm pretty sure that was a defective CPU too.

We too, and that's the only conclusion we could reach.  And the other
one that I can remember was KVM_INTERNAL_ERROR_DELIVERY_EV with
EPT_VIOLATION exits, so I would add it to all KVM_EXIT_INTERNAL_ERROR.

Nowadays KVM_EXIT_FAIL_ENTRY would probably also be an internal error,
however it was somewhat more frequent back before Intel CPUs had
unrestricted guest support.

Paolo

