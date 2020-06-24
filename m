Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746DA206D06
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 08:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389479AbgFXGuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 02:50:40 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56838 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389214AbgFXGuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jun 2020 02:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592981438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bmgzEdsW5xKNCYqU5zzbiOw4uX+8fJU9lxC550BH36A=;
        b=YumIx9Qh8ce8rSor2x5Ls+AbVbTJK2QWFXhDRtgo4A6dzEKxxQuVmw6ax4TEDJpeaJhuyr
        ysqJ8QLFHxSHq66woFxoVWS4AogSPcXCKkiPq6BGuQhYryb8r+54ap078qGs5kQyLOFzcL
        llJQCyA2unAirq5mt8Elko/LvsGM0ws=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-fXwNDDBbM8Oys4soHt5MUA-1; Wed, 24 Jun 2020 02:50:36 -0400
X-MC-Unique: fXwNDDBbM8Oys4soHt5MUA-1
Received: by mail-wm1-f69.google.com with SMTP id g187so1913119wme.0
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 23:50:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bmgzEdsW5xKNCYqU5zzbiOw4uX+8fJU9lxC550BH36A=;
        b=mAfipjcqsHoPEBOxLFTSaiRS7DFp5/BIiVWzArmtQm+2I8gq/t48/yuA6JINFrbaqn
         j7lEmtgloJtOvrWSTkJWLNTWJ7WiwJR0sJDuZhgChQbHgUKBQ7hynSP9qhdHGlIxd1K9
         9MEGNSINLx1b5MnQfDF4MqnDm6Am8hIfzVvWgUcGx72EZULwVa/v23MIHVTp1jEY/32M
         WKQ2LVlnGo3El2klhbgsAraKYQlyMromiK3nxov4GS1eL1QEB4C7fhWXyLD4MCkyLq5c
         t8StrI/VXbYZKW9xFeoBxxylh7DXqBYG0G3vtAqDOv3Wy5fmyufJ5ZUMJ8/8+Namm18J
         I/jg==
X-Gm-Message-State: AOAM532jJITGXVA6bcqgMUo0Di/GLRcgop6biRJhZTyxjLwdbnr4S2Eg
        aRQmARLTqIZ4fSWMRu5/QeZgr5Ib7SST1+0ZImcsDdYOXuRv7aXcK/0SeKrl6QRRiOOCMn/TYv1
        2S4TxUhYzhOcf
X-Received: by 2002:adf:e68d:: with SMTP id r13mr24469167wrm.141.1592981435184;
        Tue, 23 Jun 2020 23:50:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWt/WkQ0/wQ6hfsQIBhIo1dqzI5Qp98SsKkcGT/ANvXAnuF+0KqJDX6VZulJ4Zn3nCoVe5oA==
X-Received: by 2002:adf:e68d:: with SMTP id r13mr24469151wrm.141.1592981434958;
        Tue, 23 Jun 2020 23:50:34 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id a3sm6656686wmb.7.2020.06.23.23.50.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 23:50:34 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests RFC] Revert "SVM: move guest past HLT"
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20200623082711.803916-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2e9999fc-a41a-2832-6dec-4c6db7296c19@redhat.com>
Date:   Wed, 24 Jun 2020 08:50:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200623082711.803916-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/20 10:27, Vitaly Kuznetsov wrote:
> 'nmi_hlt' test returns somewhat weird result:
> 
> ...
> PASS: direct NMI + hlt
> PASS: NMI intercept while running guest
> PASS: intercepted NMI + hlt
> PASS: nmi_hlt
> SUMMARY: 4 tests, 1 unexpected failures
> 
> Trying to investigate where the failure is coming from I was tweaking
> the code around and with tiny meaningless changes I was able to observe
>  #PF, #GP, #UD and other 'interesting' results. Compiler optimization
> flags also change the outcome so there's obviously a corruption somewhere.
> Adding a meaningless 'nop' to the second 'asm volatile ("hlt");' in
> nmi_hlt_test() saves the day so it seems we erroneously advance RIP
> twice, the advancement in nmi_hlt_finished() is not needed.
> 
> The outcome, however, contradicts with the commit message in 7e7aa86f74
> ("SVM: move guest past HLT"). With that commit reverted, all tests seem
> to pass but I'm not sure what issue the commit was trying to fix, thus
> RFC.
> 
> This reverts commit 7e7aa86f7418a8343de46583977f631e55fd02ed.

Hmm it's possible that the commit was working around something bad in
nested SVM in the middle of the development.  I cannot see the
unexpected failure, but reverting the patch does not seem to have any
ill effect.  I pushed the patch, thanks.

Paolo

