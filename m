Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC481AC544
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 16:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442138AbgDPOOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 10:14:55 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52818 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2442075AbgDPOOu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 10:14:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587046489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z4LbIjifhs31GrdZsatWJ4in6sP3uCDUI2SE3ic9y2k=;
        b=ArZ0D2bjYf2TMaXKvINvudE0T8F2xn0G6Wk4Mv20QGPfirv7VhlHnMh2D32X0fVwpCyKnR
        iUni2piZgyVMaqkjrs0rtEzUZaM8TPHtHito14ACtGZiHJS2C5cBQEYLiIV0mYXIsk+Ce6
        dy+L9g22pDRqFfKKN/q1uukob5nyENU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-2xOYE_AdOA-yxfEl18UXLg-1; Thu, 16 Apr 2020 10:14:45 -0400
X-MC-Unique: 2xOYE_AdOA-yxfEl18UXLg-1
Received: by mail-wr1-f69.google.com with SMTP id h14so1770975wrr.12
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 07:14:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z4LbIjifhs31GrdZsatWJ4in6sP3uCDUI2SE3ic9y2k=;
        b=LQZKwS0Z/RKtog7khaktv4HjDDjR6f9HLgeGR1DYVDkgYDqTBg0eYBpZFvOgrllfCq
         mC1vzSPTmsnxWOKxq240HGOEcHIJMY6FQWka2hQs1cnaWBcdvcStNSJ5JSMgknyQJ8/n
         pnmXY/cOMwklwiWAwHCeoX27GbTuouZGMAvIbbP19glIowMnWKt5S8iVV88sZizXQvpJ
         W1PyqNI4XsGkL+0GqOzdFTfFMDG3xFaFEWsOqbEzcTHSnfTUQSgT77DXoRX1Af/TioO+
         sf3KqpnZNVwHjpaER8lo/xCKwTexuZWZpHgWLjSmVTgHFQ/ArYor8XZscFHCtaPDSULN
         2Fwg==
X-Gm-Message-State: AGi0PuYrxYInoA+nuy5PzbkH1jXxjs6eM+ElJOVnq88H/P9PrtDGQzE6
        z8ZrPKbZya67TblA+bH+LxUoQOTkuPAUlZeGmo4e7I08jgZX1u2dxnUhQ8TQJJ9L5AZdjX8E4SX
        XpbooO0u0d1J8
X-Received: by 2002:adf:e848:: with SMTP id d8mr33883869wrn.209.1587046484438;
        Thu, 16 Apr 2020 07:14:44 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ+5qHqtVwzCgx7S8VpTriOqQUHASdbkuuPRsw8bJP55L1T+tlRS2o36NHVkciWfVcEHwcnNg==
X-Received: by 2002:adf:e848:: with SMTP id d8mr33883843wrn.209.1587046484184;
        Thu, 16 Apr 2020 07:14:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:399d:3ef7:647c:b12d? ([2001:b07:6468:f312:399d:3ef7:647c:b12d])
        by smtp.gmail.com with ESMTPSA id e5sm28732851wru.92.2020.04.16.07.14.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 07:14:43 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: fix compilation with modular PSP and
 non-modular KVM
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     ubizjak@gmail.com
References: <20200413075032.5546-1-pbonzini@redhat.com>
 <d8cab90f-8c9c-7f79-0913-ba0d8576206d@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a2965bb4-42f3-7961-aaba-66f031197dff@redhat.com>
Date:   Thu, 16 Apr 2020 16:14:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <d8cab90f-8c9c-7f79-0913-ba0d8576206d@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/04/20 15:57, Tom Lendacky wrote:
> On 4/13/20 2:50 AM, Paolo Bonzini wrote:
>> Use svm_sev_enabled() in order to cull all calls to PSP code.  Otherwise,
>> compilation fails with undefined symbols if the PSP device driver is
>> compiled
>> as a module and KVM is not.
> 
> The Kconfig support will set CONFIG_KVM_AMD_SEV to "n" in this
> situation, so it might be worth seeing if sev.o could be removed from
> the build at that point. I'll try and look at that when I get a chance,
> but I'm currently buried with a ton of other work.

It could be made to work, but you would have to add stubs to sev.h.

Paolo

