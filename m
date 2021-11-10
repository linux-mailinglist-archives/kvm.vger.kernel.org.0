Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A15144CB65
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 22:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbhKJVr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 16:47:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233484AbhKJVr0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Nov 2021 16:47:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636580677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yfJvOP7J9ELxQ9AwnTP3X2AJo7h0fPodpf0gtDhHsyI=;
        b=doYvfc+6Dhrm3xvryPonn9yu3LCeHAacs8IqkmCr3hMBFC3UUcWjPk1RIZwTGQtiCm/c5T
        Qq2EHPNAKenThPKAKgKw2/FLZSgIMyI7cC9gu0R9UxhK8yaWg7zNisUXlcEe9YnqDk804s
        Rcz2hS3IIRTaIdWzUR5zCFby5fy2p1Y=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-5KldUoLYOVK-ousjiAU2fw-1; Wed, 10 Nov 2021 16:44:36 -0500
X-MC-Unique: 5KldUoLYOVK-ousjiAU2fw-1
Received: by mail-ed1-f71.google.com with SMTP id g3-20020a056402424300b003e2981e1edbso3585970edb.3
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:44:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yfJvOP7J9ELxQ9AwnTP3X2AJo7h0fPodpf0gtDhHsyI=;
        b=b8eraK27LxpbcYcD2x9B40vCsflVqxw/mW6yamo1tPjWwNZCBDjp1dBL9quGvZ0kNC
         85IimgZHCHF/rpqWUc7Uyz5KRsSy/xWovIJf5Is2ah13DnbmTd370POaw7gDOgV8850v
         ybIlP79WKUtSx2bubCYeikL4MRHh8Jc5mvsj1mbef6RlQ1UYsvRfJGPO1fnYEJVhsDlz
         tBxOtF061kL7XUILW2pugO7gjRHgsBlz4znh3Q/svhCFRFtwtqRACbqJlQFtnzlGXyAy
         VVdNZXTNGlmYQwOeD/2AmHQ6Pt6XTchIT2lB65aXu6B/tavHfmDrMWgeFCp5p4xoXxkh
         Ra7g==
X-Gm-Message-State: AOAM530zTyveduA/X3xm+ViZNfQoz8tN8huPooEOP+26F7xIheGEFpsv
        8dQaq7zgQbVgT3BXSah2R9Hc+Kp5E++MbhuFiTPDT4JQmslAXX3/YcryKHYThsUNeU444/oCmRt
        grCgsLn4HD9w7
X-Received: by 2002:a17:906:4c56:: with SMTP id d22mr2849636ejw.1.1636580675031;
        Wed, 10 Nov 2021 13:44:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz7WaSbEZVmEpSafJUYj/wegs3uXebBBj9RMa74f1DGPzrz9PRmOycKQ2EOGc72wO86yFUHJw==
X-Received: by 2002:a17:906:4c56:: with SMTP id d22mr2849611ejw.1.1636580674840;
        Wed, 10 Nov 2021 13:44:34 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id w24sm422822ejk.0.2021.11.10.13.44.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 13:44:34 -0800 (PST)
Message-ID: <ec57f5d2-f3bb-1fa6-bcdf-9217608756f5@redhat.com>
Date:   Wed, 10 Nov 2021 22:44:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v2 0/3] Regression test for L1 LDTR
 persistence bug
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
References: <20211015195530.301237-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211015195530.301237-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/15/21 21:55, Jim Mattson wrote:
> This issue is significant enough that it warrants a regression
> test. Unfortunately, at the moment, the best we can do is check for
> the LDTR persistence bug. I'd like to be able to trigger a
> save/restore from within the L2 guest, but AFAICT, there's no way to
> do that under qemu. Does anyone want to implement a qemu ISA test
> device that triggers a save/restore when its configured I/O port is
> written to?

The selftests infrastructure already has save/restore tests at 
instruction granularity (state_test.c) so you should have more luck that 
way; these tests are worthwhile anyway.

Paolo

