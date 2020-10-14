Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996EB28DB43
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 10:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgJNI2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 04:28:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39129 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726554AbgJNI2J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Oct 2020 04:28:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602664090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MZZ9hnLpBSfUPYJnzrr8XxQqJEL/cKh9kdDj1jdY0mI=;
        b=IFVgoD7x1dyUKYaW6cxQSwHrhvoGn/NaVnSntmyO++GvCxCF+3BmqnOoeDTogb/Ddubw5v
        INOLSf00cWZVEKFO+c2FoIxZd5y+psr6XlK/2glOTBmTiKwOeKdnCNp6DgEWACrF4w6kbI
        CA88CpiSWdnkbSVMP/6qEM5ipnQ70rc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-VIOHDOMsNtuK-UaEL6VBrA-1; Wed, 14 Oct 2020 04:28:09 -0400
X-MC-Unique: VIOHDOMsNtuK-UaEL6VBrA-1
Received: by mail-ej1-f70.google.com with SMTP id k23so892678ejx.0
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 01:28:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MZZ9hnLpBSfUPYJnzrr8XxQqJEL/cKh9kdDj1jdY0mI=;
        b=bX8otfec3RAFMITPkwcLeP1w66kDQ/It419oGZaIEM679RI/RI/yX3sHhkYe54hFY5
         llZEotQfxpAhAPBZ69mRhjPLfBvtaPO7PgRnW6XLkoWjE8si+EzP+KKNxmz5iAA3mZ6m
         eNsPKxgMdX76uXQcx/+Oumhaf25Nzk+HueX1y4s30XqZbdqpOaE7kCMzypPECF3KMoPP
         uVinmnx2WWWsZz1hs5fAgrioP97KuDJXLhAWRbomeAM1WVWRx+JsW9WIT2PJZT4ZYSRT
         Rxh2R9LYSt30O/5XWmps71or3bnTbDvesgRA2/4k9PyM/lPYJ2UPlHWyxgmPcqaj8s0i
         KNOw==
X-Gm-Message-State: AOAM533Yjfw0p+qdkVdHWmpRfFMySKPLmTrcNKvk6uPr+U/+INsQUwkS
        BB1QW/KHuIIP7Imy9C/YxBAxJhA3/+o/xFbhTWlQAbRPUiwgDDHs6j2ywyoqUXJfrdVodB6w6y8
        K6x98I7Tvaw7v
X-Received: by 2002:a17:906:4e19:: with SMTP id z25mr4280724eju.44.1602664087760;
        Wed, 14 Oct 2020 01:28:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzum0nzPjm+ya3l+65XT3fFEQPrAM01mV7i4zpCRmhZN3Ic86tRPf+B9dOifSlQiZiw5WPMGw==
X-Received: by 2002:a17:906:4e19:: with SMTP id z25mr4280709eju.44.1602664087568;
        Wed, 14 Oct 2020 01:28:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e5f7:db3b:55ea:7337? ([2001:b07:6468:f312:e5f7:db3b:55ea:7337])
        by smtp.gmail.com with ESMTPSA id bu23sm1110816edb.69.2020.10.14.01.28.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 01:28:06 -0700 (PDT)
Subject: Re: Why guest physical addresses are not the same as the
 corresponding host virtual addresses in QEMU/KVM? Thanks!
To:     harry harry <hiharryharryharry@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, qemu-devel@nongnu.org,
        mathieu.tarral@protonmail.com, stefanha@redhat.com,
        libvir-list@redhat.com, kvm@vger.kernel.org
References: <CA+-xGqMd4_58_+QKetjOsubBqrDnaYF+YWE3TC3kEcNGxPiPfg@mail.gmail.com>
 <47ead258320536d00f9f32891da3810040875aff.camel@redhat.com>
 <CA+-xGqOm2sWbxR=3W1pWrZNLOt7EE5qiNWxMz=9=gmga15vD2w@mail.gmail.com>
 <20201012165428.GD26135@linux.intel.com>
 <CA+-xGqPkkiws0bxrzud_qKs3ZmKN9=AfN=JGephfGc+2rn6ybw@mail.gmail.com>
 <20201013045245.GA11344@linux.intel.com>
 <CA+-xGqO4DtUs3-jH+QMPEze2GrXwtNX0z=vVUVak5HOpPKaDxQ@mail.gmail.com>
 <20201013070329.GC11344@linux.intel.com>
 <CA+-xGqO37RzQDg5dnE_3NWMp6+u2L02GQDqoSr3RdedoMBugrg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <626a8667-be00-96b7-f21d-1ec7648ee1e6@redhat.com>
Date:   Wed, 14 Oct 2020 10:28:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CA+-xGqO37RzQDg5dnE_3NWMp6+u2L02GQDqoSr3RdedoMBugrg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/20 00:40, harry harry wrote:
> Q1: Is there any file like ``/proc/pid/pagemap'' to record the
> mappings between GPAs and HVAs in the host OS?

No, there isn't.

> Q2: Seems that there might be extra overhead (e.g., synchronization
> between EPT tables and host regular page tables; maintaining extra
> regular page tables and data structures), which is caused by the extra
> translation between GPAs to HVAs via memslots. Why doesn't KVM
> directly use GPAs as HVAs and leverage extended/nested page tables to
> translate HVAs (i.e., GPAs) to HPAs?

See my other answer.  What you are saying is simply not possible.

Paolo

