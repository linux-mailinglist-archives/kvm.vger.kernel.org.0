Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB56AF01D
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 19:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436967AbfIJRF7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 13:05:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62940 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436817AbfIJRF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 13:05:58 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 93FD685A07
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 17:05:58 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id f23so57780wmh.9
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 10:05:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jTN7yrs5BImP0ztJITVPxIbvfd1nbau/x4aKAUJCsuo=;
        b=LFBSBzhQT/69ILh3lJeGdrv36N/Vq8BgpIMuqdckHi7JIhO7ikGaTSoR2C/gnSp5p6
         hOpJcxeIU57XgZ+vD4j5e2AQ+fx/KbVaXGL60OMnX6JRmYPaQCBHfp1l3M1fwfrL0ppy
         SB0w4jpVPwRuS+h42TVCPahFaxCfGZf7+KnzJhjd3Irm/afa0iP5v+HD6QaovsRbpDt6
         IWNKq9eZFAjJ02ci8bVvAgLhNKxWH95BEZk/eQgjqBRyn6X0Jec515VPfZ5SI0fq/K4o
         W0vxXfg8HrLTw+NQMNn9LpSDr6uOAZOL/fDXRn2fIKEWSArj/nIb16EaUkbYzBU3IeRF
         tMXw==
X-Gm-Message-State: APjAAAWyh4XslJhqVlH8pkr59PaUoMr0SllzzZuk+ANFxuPczU5VAqyy
        Zuxuv3/I3jgsg65srR5mZ4J9TJferJ9ck1vwfnc0bpoX1IOYTKElNLbSQyw0hXyyhTY8fjC/zjY
        QHaXtYEBjL3Yd
X-Received: by 2002:a1c:1aca:: with SMTP id a193mr438445wma.120.1568135157319;
        Tue, 10 Sep 2019 10:05:57 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxDDrxFlAzzHxvk36XY/616PH7XZzouT/DdV+oNbe4DLA1Luuuk6vcsXkVP+/0EEEsUzxtZZA==
X-Received: by 2002:a1c:1aca:: with SMTP id a193mr438412wma.120.1568135156940;
        Tue, 10 Sep 2019 10:05:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1435:25df:c911:3338? ([2001:b07:6468:f312:1435:25df:c911:3338])
        by smtp.gmail.com with ESMTPSA id r20sm24253567wrg.61.2019.09.10.10.05.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2019 10:05:56 -0700 (PDT)
Subject: Re: [PATCH v4 0/4] KVM: X86: Some tracepoint enhancements
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20190906021722.2095-1-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <77e8aced-545f-24c6-6952-2f73a2231ce1@redhat.com>
Date:   Tue, 10 Sep 2019 19:05:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190906021722.2095-1-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/09/19 04:17, Peter Xu wrote:
> v4:
> - pick r-b
> - swap the last two patches [Sean]
> 
> v3:
> - use unsigned int for vcpu id [Sean]
> - a new patch to fix ple_window type [Sean]
> 
> v2:
> - fix commit messages, change format of ple window tracepoint [Sean]
> - rebase [Wanpeng]
> 
> Each small patch explains itself.  I noticed them when I'm tracing
> some IRQ paths and I found them helpful at least to me.
> 
> Please have a look.  Thanks,
> 
> Peter Xu (4):
>   KVM: X86: Trace vcpu_id for vmexit
>   KVM: X86: Remove tailing newline for tracepoints
>   KVM: VMX: Change ple_window type to unsigned int
>   KVM: X86: Tune PLE Window tracepoint
> 
>  arch/x86/kvm/svm.c     | 16 ++++++++--------
>  arch/x86/kvm/trace.h   | 34 ++++++++++++++--------------------
>  arch/x86/kvm/vmx/vmx.c | 18 ++++++++++--------
>  arch/x86/kvm/vmx/vmx.h |  2 +-
>  arch/x86/kvm/x86.c     |  2 +-
>  5 files changed, 34 insertions(+), 38 deletions(-)
> 

Queued, thanks.

Paolo
