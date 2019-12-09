Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2E9811728A
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 18:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfLIRNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 12:13:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53403 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725904AbfLIRNE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 12:13:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575911582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f6PZ95wtNVfj/X9kN8WIcEKGJxTBnEw0ztVn4B1F/zk=;
        b=CLkqQy21EzimtO1AmQQil10uOjXyHLxdgDKQsKeWq6VRPyPYTyqUyYCqxCHq2DO7P77SXy
        ML7siyFaC4oaEUcUR93fq5Bmfu9yateo6zmIKnIepHzo649w34Q1Bv1FXt5lPposmIMCeI
        RoQTtXL9cHHaWqUGqmKrrzySt1QqIbA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-rOhFc31EMv-8PRfsfD_sQw-1; Mon, 09 Dec 2019 12:12:59 -0500
Received: by mail-wm1-f69.google.com with SMTP id s25so29745wmj.3
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2019 09:12:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f6PZ95wtNVfj/X9kN8WIcEKGJxTBnEw0ztVn4B1F/zk=;
        b=Ca9KJwTzqu0uPvc8Wb9Gkp2bSxEZZkwkluMWITZgw7W4dJNrEmI/LD2UYWGrfjJE+L
         W1g1jTW+z8gTbCsIMZWXaWWLjfKNBiAb6hfK5kFu/jzJGJu8RByCQau/zqM1sMK+8DiF
         SCMQGFBTlnRK/A21mDCoPTc3KQ1yj9FpiR+j8jA+y1T2eGITNoa+/rrPb/mC3aCBcMDg
         DHAa9eUKUC+wLtvia75StJJUqS9tr2AQ+nyAq2ypOLSMxGXOjj1+p1tlw2KanzH0XJhT
         BenIBdsQ4HjzeeHPctMoiKu33gD8+9zEd2RS5KH0soHwzDEEOcSrow0HHEI9mi3fyWUm
         CH6Q==
X-Gm-Message-State: APjAAAVSjD62chJfe7t9kZBoKcudNtOIGp0Qbq//0d5UVt7+ImXm34PU
        Whoo1zMgBs7WZS9uOeIujY3Lq0ncuL2WvxQVE6/pyLx2IHjmHkRMkeHlOpLKu09lnUKTHoK9vzD
        unPKfSVvaDMcs
X-Received: by 2002:a5d:51cc:: with SMTP id n12mr3331760wrv.177.1575911578401;
        Mon, 09 Dec 2019 09:12:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqxi2GtLWTX09ZvDFMqcT4Qanu7ITQSBGmbpKIPdh5ZKpfssYsZ2JiixWZNTEbJ6yD3tTuv6/Q==
X-Received: by 2002:a5d:51cc:: with SMTP id n12mr3331731wrv.177.1575911578049;
        Mon, 09 Dec 2019 09:12:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id x7sm120379wrq.41.2019.12.09.09.12.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2019 09:12:57 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] gitlab-ci.yml: Remove ioapic from the x86
 tests
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>
References: <20191205151610.19299-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d592da1d-2a5f-a005-0002-9fde866ed421@redhat.com>
Date:   Mon, 9 Dec 2019 18:12:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191205151610.19299-1-thuth@redhat.com>
Content-Language: en-US
X-MC-Unique: rOhFc31EMv-8PRfsfD_sQw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/12/19 16:16, Thomas Huth wrote:
> The test recently started to fail (likely do to a recent change to
> "x86/ioapic.c). According to Nitesh, it's not required to keep this
> test running with TCG, and we already check it with KVM on Travis,
> so let's simply disable it here now.

It works for me though:

$ /usr/bin/qemu-system-x86_64 -nodefaults -device pc-testdev -device
isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device
pci-testdev -machine accel=tcg -kernel x86/ioapic.flat
enabling apic
paging enabled
cr0 = 80010011
cr3 = 61d000
cr4 = 20
x2apic not detected
PASS: version register read only test
PASS: id register only bits [24:27] writable
PASS: arbitration register set by id
PASS: arbtration register read only
PASS: edge triggered intr
PASS: level triggered intr
PASS: ioapic simultaneous edge interrupts
PASS: coalesce simultaneous level interrupts
PASS: sequential level interrupts
PASS: retriggered level interrupts without masking
PASS: masked level interrupt
PASS: unmasked level interrupt
PASS: masked level interrupt
PASS: unmasked level interrupt
PASS: retriggered level interrupts with mask
PASS: TMR for ioapic edge interrupts (expected false)
PASS: TMR for ioapic level interrupts (expected false)
PASS: TMR for ioapic level interrupts (expected true)
PASS: TMR for ioapic edge interrupts (expected true)
SUMMARY: 19 tests

