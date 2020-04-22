Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2591B3A18
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 10:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbgDVIah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 04:30:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56312 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725899AbgDVIag (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 04:30:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587544235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xdXZUPyGF30turDkkuJ8S+OVGBdCTDNI8I/2QA8s188=;
        b=gmj+3ZVwvva5jNOgu6+KjKqAY15jPN1m+v+7G5BEmrZcld6qGObJGKyJT50YCOqXVmIeCU
        vkWuW+Q5NMRTswvV8NkDHVwb/+c4hByUnhVdCgFMVaObTWPCKQHtiOwlnl1UpMyfi/3pB4
        RlT62y7ceS674jpWpt/aluetg0Tvke8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-CILrMvcBMTuNDnhUw546Iw-1; Wed, 22 Apr 2020 04:30:31 -0400
X-MC-Unique: CILrMvcBMTuNDnhUw546Iw-1
Received: by mail-wr1-f71.google.com with SMTP id f15so706508wrj.2
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 01:30:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xdXZUPyGF30turDkkuJ8S+OVGBdCTDNI8I/2QA8s188=;
        b=sfFthqgazV/iN/o1hyqaVhNzieF8Xh4ol4kBxVJ4gaJYZnK+Y9WXaN0/2/hSmlY3aP
         ayRgnchUyWgI4h2/z7zJKIky/OwVhGSSs8rl8cf8+gPyYGI9352nxYFBeNC9lQcFSDPP
         zzbMHR4y0Dd6+mlN0ZKcGRHBjIFfzTLtaeY5dliZoNqn/Rw1mwsWbuXpgQqEhwCCt9Ck
         EjgrXaAsV820Kr7SXlF9si5G9FUx5TsYqPDgRsZU0LldnLOjJfL0EdjlNxPuIrPEUOTd
         zqVxjwJebkfZFCqIW6+cBW2lw38azONlt/nFqjD5JmqlHRMcxMj7eWprA9CiDcgiyRf+
         Q89w==
X-Gm-Message-State: AGi0PuboDTKgHHslZPawRtzSkrrdRcUCpCmGOMvwjzxa1jzwFASBUaX9
        0JCsGxGZ8uQ5aG1hMaz75RnI1lfbFYkSdKnsfoGCQJDpAKqNHnePpRdbEUW5HBi525GpVcueicb
        nAlmIAubClkg6
X-Received: by 2002:a1c:bc09:: with SMTP id m9mr8859073wmf.145.1587544230463;
        Wed, 22 Apr 2020 01:30:30 -0700 (PDT)
X-Google-Smtp-Source: APiQypLpFBwBGNyoQUK/O0FVcdYE0qXJEbRp563dscpTozvXsy9s28LixXDBYASvXYCNZ99jqBGb5g==
X-Received: by 2002:a1c:bc09:: with SMTP id m9mr8859053wmf.145.1587544230218;
        Wed, 22 Apr 2020 01:30:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id f63sm6517057wma.47.2020.04.22.01.30.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 01:30:29 -0700 (PDT)
Subject: Re: [PATCH 2/2] kvm: nVMX: Single-step traps trump expired
 VMX-preemption timer
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Oliver Upton <oupton@google.com>, Peter Shier <pshier@google.com>
References: <20200414000946.47396-1-jmattson@google.com>
 <20200414000946.47396-2-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <83426123-eca6-568d-ac3e-36c4e3ca3030@redhat.com>
Date:   Wed, 22 Apr 2020 10:30:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200414000946.47396-2-jmattson@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/04/20 02:09, Jim Mattson wrote:
> Previously, if the hrtimer for the nested VMX-preemption timer fired
> while L0 was emulating an L2 instruction with RFLAGS.TF set, the
> synthesized single-step trap would be unceremoniously dropped when
> synthesizing the "VMX-preemption timer expired" VM-exit from L2 to L1.
> 
> To fix this, don't synthesize a "VMX-preemption timer expired" VM-exit
> from L2 to L1 when there is a pending debug trap, such as a
> single-step trap.

Do you have a testcase for these bugs?

Paolo

