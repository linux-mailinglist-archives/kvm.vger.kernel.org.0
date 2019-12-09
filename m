Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4D8117134
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 17:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfLIQMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 11:12:23 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38766 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726379AbfLIQMW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Dec 2019 11:12:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575907942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uazzBTvhiErZt4quZMZBb1n6U9fDkqWNydS9BBYidxQ=;
        b=HLH4c0uSyDZOqe+dqPHTpzegiL+9GIpN7r3QC9zs/wVfbPomvkNntV4TlGA/iqHAm2Gpz/
        wwlzSfT+85C/BFJL4XEbo4BsIjPsF28tnwS1gmmd0WM6drj9wz+6SFNFRqY+H/GZ2Zo2pg
        EwFLw+550SyMaYXGcPVDaaTUrh7tTW4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-pIF2pZr0PgO0yjeuz7g03g-1; Mon, 09 Dec 2019 11:12:21 -0500
Received: by mail-wr1-f69.google.com with SMTP id f15so7757606wrr.2
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2019 08:12:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uazzBTvhiErZt4quZMZBb1n6U9fDkqWNydS9BBYidxQ=;
        b=iU2SA9HhACtxaNHsksfFRG0h1ObrIUT7Yer4+6qKv1rqKYMbHeJPF5kw7jM0zzZafB
         OlHFZRBjxTpyrczEp6xkXk/ah3s5eAT8q+2rx57Fb0inZDY969L7/Saj6yDX3JGVEheW
         3hkhSqh18IMYiv/NAUaJRdztfG2ld+UBooYUrZAewEujXP9vnOt2Ad4d6/AQKbg5UATh
         g7v84kzNJEB5GKjMTHZvGsjsHG1tQmcvzwds+/grfIW0xzWSC29v1p24lKD6ysd7WSz1
         jQ/32F1GlHcvhaU71GxQGl/RZ9A9BovvaDUCw+a92zR2ge1V3R1KcJyX6Z5zN8uPZlzf
         bjWA==
X-Gm-Message-State: APjAAAWRqwlaTwCNpPV/oSGeawyvvCOW0UMVgdJIAcDPLyg9899FToWf
        MBejlPfyEGFuWLJeYQGEifzftSIfv6sxNk91xVl/2bXd/hhakWttwX1Movtudj4+RLFQaBxk1Kf
        znZPdA7aD063B
X-Received: by 2002:a5d:670a:: with SMTP id o10mr3141209wru.227.1575907939741;
        Mon, 09 Dec 2019 08:12:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqxnWdi9kaO0bh1QNNzpywSBvNFURzXoRc13mamZ/UEHx0E6wlcPDH9TOAFGPiARCDf+HaQopQ==
X-Received: by 2002:a5d:670a:: with SMTP id o10mr3141183wru.227.1575907939503;
        Mon, 09 Dec 2019 08:12:19 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id c15sm27522103wrt.1.2019.12.09.08.12.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2019 08:12:18 -0800 (PST)
Subject: Re: [PATCH] kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS
 field
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Liran Alon <liran.alon@oracle.com>
References: <20191204214027.85958-1-jmattson@google.com>
 <b9067562-bbba-7904-84f0-593f90577fca@redhat.com>
 <CALMp9eRbiKnH15NBFk0hrh8udcqZvu6RHm0Nrfh4TikQ3xF6OA@mail.gmail.com>
 <CALMp9eTyhRwqsriLGg1xoO2sOPkgnKK1hV1U3C733xCjW7+VCA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f20972b7-ea45-6177-afa6-f980c9bd6d0f@redhat.com>
Date:   Mon, 9 Dec 2019 17:12:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eTyhRwqsriLGg1xoO2sOPkgnKK1hV1U3C733xCjW7+VCA@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: pIF2pZr0PgO0yjeuz7g03g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/12/19 22:30, Jim Mattson wrote:
>> I'll put one together, along with a test that shows the current
>> priority inversion between read-only and unsupported VMCS fields.
> I can't figure out how to clear IA32_VMX_MISC[bit 29] in qemu, so I'm
> going to add the test to tools/testing/selftests/kvm instead.
> 

With the next version of QEMU it will be "-cpu
host,-vmx-vmwrite-vmexit-fields".

Paolo

