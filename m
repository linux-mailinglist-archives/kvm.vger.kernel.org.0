Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430921EB3B4
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 05:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgFBDQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 23:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbgFBDQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 23:16:16 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5DCC061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 20:16:16 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id v24so758262plo.6
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 20:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6vwdZtJMYIy5H75dzhNT2X27UM1ZC8bhL7w9ePOSU7U=;
        b=DkUpgVcA4ocMJ3P6LDdPJF2w2nlgpDXJf4KD43TmyrCUK/17aiwh/EDXZ8Pbf/Ikw3
         +LaHWWMwnLWIXLHFNu6UnsiY0/UpjkHlndRdJNXwq4ycQdcUS3FvUlZbARiLBtQHUYjy
         BVRVfH8FAEYi4uwHnfxMHeXubEZI4LDoPiSGkjIA3oRCQKPM9xmDTJ8xrgj4m9ApGmJq
         EOVucwEetRCstU8Vix5n8KhPP60i3WlyYJIuwjCFfL52EhORvrBzPdFqUHginKKqVpA6
         1s1Fv2pctgnmB111PNZDA8seKNEDJzS6kBkoRvOgd/z7Z0KBDCcG7P8OQcCqjeCqG7mo
         ZHwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6vwdZtJMYIy5H75dzhNT2X27UM1ZC8bhL7w9ePOSU7U=;
        b=hvROjOXNt4v+1eUCpU0hQsyVYSxqNig1U/PCqN3VTR/V0TexU7/IvMQUCJVN5+qrtj
         BnFqLT5FIPOSC6nW6dsIrVeRDgN9ErXvbAEqgsY2aOPAK9TnYpZsYKvKWLEiP683Q8U1
         u8CsWNF9Y7X3G/p9IGaaihRzuXLb5OJ2A9VX/FhB8p49SJuTRYg9zW/BvHsPPI+7hjML
         b9DPOmsfB+4ho6CC3JI7rZaO1q9Xc1+PwiUrt6iEKSHUDqqce+e9c0Kx4wNk+9w4jkEo
         zNLvrZ84dgL8TKF1vs+9xVB5ojPY0u8gmg1pnJvuodf/864/+eW4t9ItxSecx7+exkA1
         wgag==
X-Gm-Message-State: AOAM533+Dq0zT+JFh6Y3QibboD5EbaJG4gkxSX5nfCtW/fgin587kJox
        WldQj7byGGCAU4d450aVrMfTxw==
X-Google-Smtp-Source: ABdhPJx44UFfX+t1vNjTWxJU2WH3P2v7BuF8Sg+OatY+uEu13V3i6KaN3tFTA8tLmrDCjUg7erFDuw==
X-Received: by 2002:a17:90b:b14:: with SMTP id bf20mr2897250pjb.231.1591067775270;
        Mon, 01 Jun 2020 20:16:15 -0700 (PDT)
Received: from [192.168.1.11] (174-21-143-238.tukw.qwest.net. [174.21.143.238])
        by smtp.gmail.com with ESMTPSA id gd1sm748295pjb.14.2020.06.01.20.16.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 20:16:14 -0700 (PDT)
Subject: Re: [RFC v2 08/18] target/i386: sev: Remove redundant handle field
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-9-david@gibson.dropbear.id.au>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <2de86b15-8a79-3609-8101-c9cc4dcaf255@linaro.org>
Date:   Mon, 1 Jun 2020 20:16:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-9-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/20 8:42 PM, David Gibson wrote:
> The user can explicitly specify a handle via the "handle" property wired
> to SevGuestState::handle.  That gets passed to the KVM_SEV_LAUNCH_START
> ioctl() which may update it, the final value being copied back to both
> SevGuestState::handle and SEVState::handle.
> 
> AFAICT, nothing will be looking SEVState::handle before it and
> SevGuestState::handle have been updated from the ioctl().  So, remove the
> field and just use SevGuestState::handle directly.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  target/i386/sev.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

