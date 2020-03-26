Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA96D193C31
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 10:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgCZJqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 05:46:46 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:38233 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727933AbgCZJqn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Mar 2020 05:46:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585216002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nmP9/4eydnX5iyBBhajAJRXc7M9FYD0cP2/UdQw5GkI=;
        b=cUh93m2KuHhUoT7y+SDbgSN82+2hHeGhkuGEPIhhlk/dhRTRT6bhHowCCR6A91Vwl/QiMZ
        SQn6CIpJSypJlxHn47ZTI89E4BMRQuBVgHXIiUNpSna5cwXv4ph5y83zbkPM78v+FGKc9F
        fvXan+bpR58KIiM6jqqzEg8nKDTMq90=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-gl0PEYabO2-sMUMkxTpeig-1; Thu, 26 Mar 2020 05:46:39 -0400
X-MC-Unique: gl0PEYabO2-sMUMkxTpeig-1
Received: by mail-wm1-f70.google.com with SMTP id p18so2220121wmk.9
        for <kvm@vger.kernel.org>; Thu, 26 Mar 2020 02:46:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nmP9/4eydnX5iyBBhajAJRXc7M9FYD0cP2/UdQw5GkI=;
        b=X+FLBW4pwcDG0yQHOD6ipk8PQRDVO60Wg8eQtX69fGJeD2E/rVFX604RsoD8t/hrdr
         IlBVReqTYt6KXjx5jNfb/0jFwppwHR5Oub3+HGw+lV5FsVxmXxmWK+Zd0cGVoY8pnUVR
         wNY5sVJ24yBJz81F3R/3Jh5czgqr/9vETYqpyT+tMnlt+h9Mng+KkMyR9owP//ENryrX
         YKc8uS3L/9eWvQn0/QC5BkmV4LtZ7PlbY+/5xSpYKKhertkUW5GOUWsALSbe9sVyOO3l
         LRgwayPo5bVq1vRr2JuMT3fchB7j6hZigAH4X383m9rJatIC7zSvU7UnCUryOqSBARgK
         EQdw==
X-Gm-Message-State: ANhLgQ2Panr7AdsKS0KYttWRQT8Z6OpqsyaidXblW9ecD9XsdCWEz+uf
        ivRdRFPV9sjMbf8hjcq1HZAoI6beHuRdfnIgEh/po5gL5qCWA5Hgq+Uu5Ar5FLSPK+zbhE87Nze
        OhuAgYiae0UR/
X-Received: by 2002:a1c:6885:: with SMTP id d127mr2260422wmc.33.1585215998426;
        Thu, 26 Mar 2020 02:46:38 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vs2HiEIlBvxuqoG1NPUwv2DHm8ecXV4uGGxlIvnY/ct/LrMTIIEN3SuZPLvHBRJ1XX4In36cg==
X-Received: by 2002:a1c:6885:: with SMTP id d127mr2260399wmc.33.1585215998141;
        Thu, 26 Mar 2020 02:46:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e4f4:3c00:2b79:d6dc? ([2001:b07:6468:f312:e4f4:3c00:2b79:d6dc])
        by smtp.gmail.com with ESMTPSA id y189sm2854521wmb.26.2020.03.26.02.46.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 02:46:37 -0700 (PDT)
Subject: Re: [PATCH 0/3] KVM: X86: Single target IPI fastpath enhancement
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1585189202-1708-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <353a0717-4c97-9945-caa9-10037274f4a8@redhat.com>
Date:   Thu, 26 Mar 2020 10:46:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1585189202-1708-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/03/20 03:19, Wanpeng Li wrote:
> The original single target IPI fastpath patch forgot to filter the 
> ICR destination shorthand field. Multicast IPI is not suitable for 
> this feature since wakeup the multiple sleeping vCPUs will extend 
> the interrupt disabled time, it especially worse in the over-subscribe 
> and VM has a little bit more vCPUs scenario. Let's narrow it down to 
> single target IPI. In addition, this patchset micro-optimize virtual 
> IPI emulation sequence for fastpath.
> 
> Wanpeng Li (3):
>   KVM: X86: Delay read msr data iff writes ICR MSR
>   KVM: X86: Narrow down the IPI fastpath to single target IPI
>   KVM: X86: Micro-optimize IPI fastpath delay
> 
>  arch/x86/kvm/lapic.c |  4 ++--
>  arch/x86/kvm/lapic.h |  1 +
>  arch/x86/kvm/x86.c   | 14 +++++++++++---
>  3 files changed, 14 insertions(+), 5 deletions(-)
> 

Queued 2 for 5.6 and 1-3 for 5.7, thanks.

Paolo

