Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD077113F31
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 11:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbfLEKQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 05:16:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49374 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729074AbfLEKQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 05:16:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575540980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oCu+v7Ov3efBPpGgrHHDYgqYZqM3nvcg/fPq5Gsmc/Q=;
        b=UYe62Ne73r7Fuf6dzJPlyoT/tktLQ4f17VNxgzVy3sheuJfyKtRdR8bJ6rknXe+cSFF3da
        ZW1c3Asx9XZJLTnP6lDvIAyn1GtC6/s+y1FyPMg3Rx8jbKMQstvW68gSfcrTy6CbuwwrZx
        3KMwAkftOjeHKgHBMuHtzxVbWcaGYWA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-dg6iBEzWOqaXx865zCDCeg-1; Thu, 05 Dec 2019 05:16:19 -0500
Received: by mail-wr1-f70.google.com with SMTP id l20so1321852wrc.13
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2019 02:16:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oCu+v7Ov3efBPpGgrHHDYgqYZqM3nvcg/fPq5Gsmc/Q=;
        b=FMOfsYzaf7PavP30cKZX+9o7C/0+cH0UOejeGVgHiwn5/71lU+hqbyQ+IeZZMO4vVV
         TF76tqVqeSXR9nwktam35iJVQtT8FyxEmF/41Ks+NyR1GrVKOE2hMVuM1lK/o1oAHzal
         vNGvkGUo3HlbW/Fux2rNulR1Jwu0Ppd8KyZ/gy2OvlrBZYQ9Z+gTr627GX4xIIv9Cj2h
         LL+GF7xMcWTVgEctWArbhoEmzfRdE9xHN35St9FWP02yyF6r0hC5XL4esE7Wo2k+R/oP
         m8rre7bg9fjw9Yop5wophDXZZsXQjCyu7kE7WZB+ip71jyoD215E730H0T/tR4DiyWyD
         Dyjw==
X-Gm-Message-State: APjAAAUpbzuNOp6i01/ceJ/kJxaSjQImusLyITRPP6/R7Dz2vHwS6eGy
        95KCDUs6w0brMja5wCOnabbTt+PenQqLhdLx6ceokb82TBiP3VnQMdDVy4T0ePZHyVoytPZ3X7G
        N067AuGby/Qdb
X-Received: by 2002:a5d:4a91:: with SMTP id o17mr9807359wrq.232.1575540977651;
        Thu, 05 Dec 2019 02:16:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqy6dzszP8w8p/bgdrENDTQp3RYlrXCG812A+kw447RAi90Njay97UlqFJCBmx5nQMLIEbcfZw==
X-Received: by 2002:a5d:4a91:: with SMTP id o17mr9807334wrq.232.1575540977425;
        Thu, 05 Dec 2019 02:16:17 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:541f:a977:4b60:6802? ([2001:b07:6468:f312:541f:a977:4b60:6802])
        by smtp.gmail.com with ESMTPSA id a64sm10949477wmc.18.2019.12.05.02.16.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 02:16:16 -0800 (PST)
Subject: Re: [PATCH 4/5] KVM: vmx: implement MSR_IA32_TSX_CTRL disable RTM
 functionality
To:     Jim Mattson <jmattson@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <1574101067-5638-1-git-send-email-pbonzini@redhat.com>
 <1574101067-5638-5-git-send-email-pbonzini@redhat.com>
 <CALMp9eTKMzg2pNEZxhqAejAquFg8NxKRrBzzNUKRY78JLGjS5A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d0653777-55c6-ebb9-7be7-5bdd259b66fa@redhat.com>
Date:   Thu, 5 Dec 2019 11:16:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eTKMzg2pNEZxhqAejAquFg8NxKRrBzzNUKRY78JLGjS5A@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: dg6iBEzWOqaXx865zCDCeg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/12/19 00:49, Jim Mattson wrote:
>>         if (!boot_cpu_has(X86_FEATURE_RTM))
>> -               data &= ~ARCH_CAP_TAA_NO;
>> +               data &= ~(ARCH_CAP_TAA_NO | ARCH_CAP_TSX_CTRL_MSR);
>>         else if (!boot_cpu_has_bug(X86_BUG_TAA))
>>                 data |= ARCH_CAP_TAA_NO;
>> -       else if (data & ARCH_CAP_TSX_CTRL_MSR)
>> -               data &= ~ARCH_CAP_MDS_NO;
>>
>> -       /* KVM does not emulate MSR_IA32_TSX_CTRL.  */
>> -       data &= ~ARCH_CAP_TSX_CTRL_MSR;
> Shouldn't kvm be masking off any bits that it doesn't know about here?
> Who knows what future features we may claim to support?

Good question, in the past the ARCH_CAPABILITIES were just "we don't
have this bug" so it made sense to pass everything through.  Now we have
TSX_CTRL that is of a different kind and arguably should have been a
CPUID bit, so we should indeed mask unknown capabilties.

Paolo

