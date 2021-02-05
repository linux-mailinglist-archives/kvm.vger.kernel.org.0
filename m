Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77A93107C8
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 10:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhBEJZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 04:25:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31286 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230346AbhBEJWK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 04:22:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612516843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ay95j8ZOJweqoeSHjCRRFfGdbMEYx6rMAyvOQfQnfuI=;
        b=CzetNAOtbMGBSbDOZrFs2ZiwI3tJiWXMe1etTXFAbOuVzjLjU7h3U7ElffxU+0ZghFPRHC
        tYUoeCi4jtYvyTmpYDhMtjIxCi+RFwh2hsnBxd92y7wbRqhDUwIPrlUtIHx60HkBzgO0y0
        zv+33H95ZnYQcyNjvkvtMEK5OON2P/c=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-QeOJWgmtOAGXbSXrhbnI9g-1; Fri, 05 Feb 2021 04:20:42 -0500
X-MC-Unique: QeOJWgmtOAGXbSXrhbnI9g-1
Received: by mail-ed1-f70.google.com with SMTP id i13so6436180edq.19
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 01:20:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ay95j8ZOJweqoeSHjCRRFfGdbMEYx6rMAyvOQfQnfuI=;
        b=L+6YOhEl2EjfZLKphM/ZfiRNrSDS727a12iRItzKw86pmU3fpkMWOyywtaIMNdKRI1
         GrFQxucW3pS7DLmAcuzC42a7+en9jlAGzSrlNf67+AeDqvudtKIOBxPST/isLg/LkjsJ
         Hx3+fDBcGJgDjsk697hDw745V4gK12eBiIixtPVoTQhPlCrHvU+bWVZPlyt4Yzbk7nIn
         0AAf3nNY4NS5NnH2K7KZqd1LC8UBL0LieQnK6U6GA8Mt0bEcxbxuVqkZojR3rht2oMWX
         vFYisE1DoU2GSjSD63g4ZIF6aeZ+r+8pk38pHszwU+oQudM//UVBpOtu4oXG751Rsijb
         l47Q==
X-Gm-Message-State: AOAM532hvswriMer0ltNanMYHk/5UDgvNeMBuOd3thhtuzhmA/JsA64X
        ydHqwh6+PCylYIkPc+r3Dohx0RURB2bhpyremc4njB1VJ5Vxbh7zNqthAGxHWa3aOtY7b/iIgsF
        8rvMXyb/3ho63
X-Received: by 2002:aa7:cc98:: with SMTP id p24mr2753568edt.126.1612516841170;
        Fri, 05 Feb 2021 01:20:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzU95X6x/jd0HaI7sckA1in5gXTVMvQUyFgo4kCKOezCNFIpUz++OHiVuzTw7O1f+9VUnnSIA==
X-Received: by 2002:aa7:cc98:: with SMTP id p24mr2753556edt.126.1612516840979;
        Fri, 05 Feb 2021 01:20:40 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u23sm3713829edt.87.2021.02.05.01.20.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 01:20:39 -0800 (PST)
Subject: Re: [PATCH v4 4/5] KVM: MMU: Add support for PKS emulation
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210205083706.14146-1-chenyi.qiang@intel.com>
 <20210205083706.14146-5-chenyi.qiang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dabceac5-876f-a145-fffc-73df917fa1ce@redhat.com>
Date:   Fri, 5 Feb 2021 10:20:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210205083706.14146-5-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/02/21 09:37, Chenyi Qiang wrote:
> |In addition to the pkey check for user pages, advertise pkr_mask also 
> to cache the conditions where protection key checks for supervisor pages 
> are needed. Add CR4_PKS in mmu_role_bits to track the pkr_mask update on 
> a per-mmu basis. In original cache conditions of pkr_mask, U/S bit in 
> page tables is a judgement condition and replace the PFEC.RSVD in page 
> fault error code to form the index of 16 domains. PKS support would 
> extend the U/S bits (if U/S=0, PKS check required). It adds an 
> additional check for cr4_pke/cr4_pks to ensure the necessity and 
> distinguish PKU and PKS from each other. |

Slight changes to the commit message:

   Up until now, pkr_mask had 0 bits for supervisor pages (the U/S bit in
   page tables replaces the PFEC.RSVD in page fault error code).
   For PKS support, fill in the bits using the same algorithm used for
   user mode pages, but with CR4.PKE replaced by CR4.PKS.  Because of
   this change, CR4.PKS must also be included in the MMU role.

Paolo

