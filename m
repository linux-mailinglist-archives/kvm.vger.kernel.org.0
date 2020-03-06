Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2198917B88C
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 09:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgCFIpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 03:45:33 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55824 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725901AbgCFIpd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Mar 2020 03:45:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583484332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NPUakhz1PfHoxZ0tbry8WaZvrV2+jq26d8FjwX0/vCU=;
        b=Grn+GPSJJZEDFSvX4BGZid9zeMdcHerUeCrXRpxd3szQxPB7TCpL9tC6TCtMX/cDbNejCw
        /1HDhcvYGhhnFpEaHK3KehQSDlXnSVY4qF9YGd+PfemA5o6I4KrfyVB8Rb9kcllTmsZnsy
        PhX9QlEqkKFhtuXw9E/ls1C1NrwOLsU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-yFalf9X4PeCC1EtKIsh5MQ-1; Fri, 06 Mar 2020 03:45:28 -0500
X-MC-Unique: yFalf9X4PeCC1EtKIsh5MQ-1
Received: by mail-wm1-f71.google.com with SMTP id g26so360145wmk.6
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2020 00:45:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NPUakhz1PfHoxZ0tbry8WaZvrV2+jq26d8FjwX0/vCU=;
        b=jKnt31R4xNp9KQSXtlMorcXK2f1T6kW79etVaXCHzCecVDeM2K6dTSdAHlTRzjbviw
         4qdKxtbh+9qupd9MlvYAg/9LmFrHn2r1Huh1p0ZKE7zb0YKFVcJk0w3HnKjCFNv6Q5LA
         X7nMhtgYwDizOIEHIyOL7e7XqqC0fypyDs1XT12gHU/eG71qHf/1Xr+A7viB66DaCZPH
         SCIzeYdxalQw/uW8vDI3zCdgHSXJ+3b6O+kHGCiip4CCwH0u8d8vd4vcLhBIxOphaINV
         lSo2FCgr3fBsgT893AtpSjBQj/Np+bpHoG7pKsxzgsOJvRwoEF0rWSaDGoFMzKeIwkqL
         y8Vg==
X-Gm-Message-State: ANhLgQ23/CAj5oR7UY/XWi+uGnb8HQbeN/DVvMEqVJtKDUrLgMdkCSpX
        H+9m34LMEZc/ZESsyAI/gO6lkIgdbaGxMLglIJvTuOiR38tZtASM3JQdU9evTaAz8ON8ewWIn/d
        rnI8tN2S2cgOj
X-Received: by 2002:adf:e38d:: with SMTP id e13mr2772220wrm.133.1583484327446;
        Fri, 06 Mar 2020 00:45:27 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuEMSmKXG0u6JbRxYLI8iuXjVLL2YaBM1kPo7etwUgNWuHn/SkYRbwru3mR9qW3MKYGvyvujA==
X-Received: by 2002:adf:e38d:: with SMTP id e13mr2772202wrm.133.1583484327233;
        Fri, 06 Mar 2020 00:45:27 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b99a:4374:773d:f32e? ([2001:b07:6468:f312:b99a:4374:773d:f32e])
        by smtp.gmail.com with ESMTPSA id v7sm41493907wrm.49.2020.03.06.00.45.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 00:45:26 -0800 (PST)
Subject: Re: [PATCH v2 0/7] KVM: x86: CPUID emulation and tracing fixes
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pu Wen <puwen@hygon.cn>
References: <20200305013437.8578-1-sean.j.christopherson@intel.com>
 <6071310f-dd4b-6a6d-5578-7b6f72a9b1be@redhat.com>
 <20200305171204.GI11500@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7d17c0c1-cdf0-f8cc-0cc4-4b9dda0b514d@redhat.com>
Date:   Fri, 6 Mar 2020 09:45:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200305171204.GI11500@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/20 18:12, Sean Christopherson wrote:
>>> In theory, everything up to the refactoring is non-controversial, i.e. we
>>> can bikeshed the refactoring without delaying the bug fixes.
>> Even the refactoring itself is much less controversial.  I queued
>> everything, there's always time to unqueue.
> Looks like the build-time assertions don't play nice with older versions of
> gcc :-(

Yes, I was quite surprised that they worked.  I suppose you could write
a macro that checks against 'G', 'e', 'n', 'u', 'i', 'n', 'e', 'I', 'n',
't', 'e', 'l'...

Paolo

