Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD20E1EB3A9
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 05:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgFBDJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 23:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgFBDJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 23:09:34 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC67CC061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 20:09:33 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id b7so559397pju.0
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 20:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VvxzxWZx+TyHBrmgXA2K8n0ZyRPTmFUcSIp3XjCjvD4=;
        b=naUI44ft1dQJA3l58usTfk2KS6Ggc54DVfQrNd6jHiUhE20SWFCO6MxOPt0RmjMuM6
         U1M3ypM27ZXR5imIgvZP/9fwi2YodSPA9GedP7Uns0zY8OunxJzqjtEENllAAKTNapaL
         SBs393T2z5mD9vNsyK9KZej6vRwZLbPW7pQ7cmSnevktdJ2EAPs+GsdUAoDqIaHwVdRJ
         sH9TZ0fX3F+GfPDdbwrlaSm90dIHwHhJei6bNVGXN5FxM0HAQjClzfSQV5L6CKA6OneN
         lsn171F8WyAfOiU8fGgBACyEv3192KtHB2+b7LqpriIm2S/1hQYBKWn4wTKrIK8VTBJk
         OpSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VvxzxWZx+TyHBrmgXA2K8n0ZyRPTmFUcSIp3XjCjvD4=;
        b=QVz2xXKLfBu4dxFhHSi+++NSCWAhk9Ecd88BEd8xdMBsSHUvmw3K2fhp5B2lUhueN9
         9tNrqU8SkeRGptBgarUdcg1WvOlfs7512MAJzG5XN0yKQz7fNKf0BATpDanzEe78YXjb
         QFaPr6SQ71YUdOawXcgMmfdo/WuZkTBgYrr5j7x6bNaqKzW9FC/jyM9PwMDLnHHbkDAs
         bOi2Dc6dAckiVkVqsjdq5K09U3WQa+1lcho17Y2I0rikgfJ0xwf4gfj6PlEahGWzY4yh
         cTkMUAeX7gXNOz9ueFcRtxQtH/sclkzuwRtx7OC42dshCUHDiC/fHoaxUQTRcaGYk2/2
         OR8A==
X-Gm-Message-State: AOAM532EEqBaX8lS1RpFpaDwxLn2sHb5IHYgdIv2vjtYRxzef3CsVeJX
        MY07J9CyEC9LVNqmIWPe6SVwNg==
X-Google-Smtp-Source: ABdhPJyfWqzuWy/R7g6LjoDWKD6Rb5P6iDpgHSuRnXqCRDKxiQkOC1VzJk+/40cfFBDhmYFnT+YvUw==
X-Received: by 2002:a17:90a:7bcb:: with SMTP id d11mr2832057pjl.209.1591067373533;
        Mon, 01 Jun 2020 20:09:33 -0700 (PDT)
Received: from [192.168.1.11] (174-21-143-238.tukw.qwest.net. [174.21.143.238])
        by smtp.gmail.com with ESMTPSA id g92sm767861pje.13.2020.06.01.20.09.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 20:09:32 -0700 (PDT)
Subject: Re: [RFC v2 06/18] target/i386: sev: Remove redundant cbitpos and
 reduced_phys_bits fields
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-7-david@gibson.dropbear.id.au>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <3abf6f25-1b47-ace0-1186-5874c75b2531@linaro.org>
Date:   Mon, 1 Jun 2020 20:09:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-7-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/20 8:42 PM, David Gibson wrote:
> The SEVState structure has cbitpos and reduced_phys_bits fields which are
> simply copied from the SevGuestState structure and never changed.  Now that
> SEVState is embedded in SevGuestState we can just access the original copy
> directly.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  target/i386/sev.c | 19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

