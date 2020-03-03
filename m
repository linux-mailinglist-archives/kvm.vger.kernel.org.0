Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDB7177913
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 15:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729714AbgCCOeO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 09:34:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40450 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728998AbgCCOeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 09:34:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583246053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cAECegmA0wMswJz0VGyHZTs27RHr8iBmN3HXQbf5sSI=;
        b=GhVcgt2IpbCVY47JbYVbrz/2ij2UH/IuhvBKnO5BF+MZHD4beP0vvP1M3c4zcUbYw8PiZn
        YQ5PcmqrYt6INcuSCs5/TNDVthm2oni7IysoraZdx8LXqvoaZFxhv7w5CQPLuo+1vsBvTi
        RbKjU0etsxV3VCASWInvV4owxjDLCLY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-ErdylsYcNuG7NSxD2aSlUQ-1; Tue, 03 Mar 2020 09:34:11 -0500
X-MC-Unique: ErdylsYcNuG7NSxD2aSlUQ-1
Received: by mail-wr1-f69.google.com with SMTP id j32so1294770wre.13
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 06:34:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cAECegmA0wMswJz0VGyHZTs27RHr8iBmN3HXQbf5sSI=;
        b=AH/4VGaU9rJyVYIWLCbko5fExK5K2Ugkww2bgSHzdvP0rYiSIQ+xFAwxHb1KTXTeGA
         8oFWf1mfcCgaU5tut9v1eBjNxonav5lOkVdpEGT0rYUsLOHGwTqoZgzPmczt2sE6MzLQ
         1CeBh0r+g8SMXIAMrJEMqtNH9N5JMoQ7qLVvUUnqTWUWdZlHkqFnPYe5yB74z3SqLHAV
         QoQ1NX9EVQARk3HehZiC8E7vDzR5FDCU8DXRpo450yqnvescLXX63mcM0Gg+3YHDtN3d
         ihVU/hboeP61LjVuyYSbI+9lcDDwBfuJqmv8x1ao4JK32aizP/ZnL+n2B55h63tYNOdT
         fKzQ==
X-Gm-Message-State: ANhLgQ1t8JCSvLcuIdGgirPP3kudbPwDLYJJKn/7h7XRVZ/bQ5mzawBz
        Z32RjIV2W5cjVeGYCEWvgH71mVeUVoZPDVstoT4ZVgLkv2RjcXHekbLHAQC5eXx4VD59WOSMk1S
        lWUD8ePCFy2kw
X-Received: by 2002:a1c:2d86:: with SMTP id t128mr1310635wmt.38.1583246050153;
        Tue, 03 Mar 2020 06:34:10 -0800 (PST)
X-Google-Smtp-Source: ADFU+vs4Xhhl22Q6UveZHccZdqz7Hiv0gpABcJv3zhrPJc3f3VR/4ZTJvCmJCVZWGmA8KaX2/Dcm/g==
X-Received: by 2002:a1c:2d86:: with SMTP id t128mr1310615wmt.38.1583246049954;
        Tue, 03 Mar 2020 06:34:09 -0800 (PST)
Received: from [192.168.178.40] ([151.20.254.94])
        by smtp.gmail.com with ESMTPSA id t133sm4741832wmf.31.2020.03.03.06.34.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 06:34:09 -0800 (PST)
Subject: Re: [PATCH v2 21/66] KVM: x86: Use supported_xcr0 to detect MPX
 support
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
 <20200302235709.27467-22-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c2faf73b-56e4-a398-430d-ad6f0afed6e4@redhat.com>
Date:   Tue, 3 Mar 2020 15:34:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200302235709.27467-22-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/20 00:56, Sean Christopherson wrote:
>  
>  bool kvm_mpx_supported(void)
>  {
> -	return ((host_xcr0 & (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR))
> -		 && kvm_x86_ops->mpx_supported());
> +	return supported_xcr0 & (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
>  }

Better check that both bits are set.

Paolo

