Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9DCDD710E
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 10:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfJOIcP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 04:32:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51268 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbfJOIcP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 04:32:15 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 10F51C049E1A
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 08:32:15 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id v18so9746054wro.16
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 01:32:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P5PIeo7F8BONUmbx5z3F8WKmU2e7zzUSE3SYwbN/HB8=;
        b=ijUAmYl0koenKPR2P3pKgGNUtT3NZWqyWT+3GpRLWjjTP+9KB13oP5Kqr3JoAzWx+O
         l4na1bECkG0hmO5CBHZi0RMazqDH8Zf8qZXZFISy3GD0fIEn3GqW9Tb17PEuR87y2hSE
         9lTJNndOVxRmdL6j2g6TTWC1FRfd4H4CS7JEMMGSuxYdjp1fKTb+WflkFqetTBr9vNF+
         UCxcRiaSciVWzFvGqXAQhNav37laO+hLOy65ci6hv6yJHHEOv4q76eAqsz255+F8ovbg
         NdL8qpjtcBMXQnHmdiIEHttsKjQfoFIrb/g1omFDf0MlysBSn6XTMDhPmaZvsrPzTkpM
         DWgg==
X-Gm-Message-State: APjAAAXGP7he1a/2Aw1t8isR95QNcZDMndwc2FwfcUnTtqYxlQDe2ByH
        JUqiylSxx1Olzd6aKCR1g1Xxh+MRqZSPo07cCsuTcKSVolk69IJijtXDqoguMU9v0EIpAwocG82
        Cn2lLWXfq+Y++
X-Received: by 2002:adf:fd0a:: with SMTP id e10mr27570507wrr.55.1571128333664;
        Tue, 15 Oct 2019 01:32:13 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxrwQzt+PWn32MNk4JHIoXCkTdb8YUH7EkIrAtHisFtFyFyrwBRV58d5gOa3puF11f2x3ROYw==
X-Received: by 2002:adf:fd0a:: with SMTP id e10mr27570487wrr.55.1571128333388;
        Tue, 15 Oct 2019 01:32:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d001:591b:c73b:6c41? ([2001:b07:6468:f312:d001:591b:c73b:6c41])
        by smtp.gmail.com with ESMTPSA id a4sm17420727wmm.10.2019.10.15.01.32.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2019 01:32:12 -0700 (PDT)
Subject: Re: [PATCH 01/14] KVM: monolithic: x86: remove kvm.ko
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20190928172323.14663-1-aarcange@redhat.com>
 <20190928172323.14663-2-aarcange@redhat.com>
 <20191015013144.GC24895@linux.intel.com>
 <20191015031828.GE24895@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <259674b0-85e3-5266-4eaa-6314e8156f77@redhat.com>
Date:   Tue, 15 Oct 2019 10:32:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191015031828.GE24895@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/19 05:18, Sean Christopherson wrote:
>> The KVM config option should be changed to a bool and its help text
>> updated.  Maybe something similar to the help for VIRTUALIZATION to make
>> it clear that enabling KVM on its own does nothing.
> Making KVM a bool doesn't work well, keeping it a tristate and keying off
> KVM=y to force Intel or AMD (as done in the next patch) looks like the
> cleanest implementation.

Indeed, keeping the KVM option as tristate helps showing the right
suboptions, similar to what Andrea did in patch 2.  However, this patch
already breaks the CONFIG_KVM_INTEL=y && CONFIG_KVM_AMD=y case I think,
so it should be squashed with "KVM: monolithic: x86: disable linking vmx
and svm at the same time into the kernel".

> The help text should still be updated though.

The patch doesn't change the fact that enabling KVM on its own does
nothing, so the help text can be updated independently (patch welcome :)).

Thanks,

Paolo

