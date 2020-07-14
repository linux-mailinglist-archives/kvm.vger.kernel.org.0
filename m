Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0484A21FD4C
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 21:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgGNT0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 15:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbgGNT0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 15:26:44 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E152CC061755
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 12:26:44 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z3so7973734pfn.12
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 12:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TexCCK4LHRS1wbNZcYVcFTOY5FAdLJyGx/1qfFPO5vM=;
        b=kbwOLBUhDvj8/uDEfsu7u8/d3XWmfll0pT0qH5OtdRfDe5glInUJ+sP2/aPkanJ0H+
         fodKye2YPyj7oQAth1guk4sfTK75gB8X/LL0k4A1olBGzONlotGgv/qQijvRjlWmirD3
         //lbIfz2rmtD/h4pRCe+6kuyrOq/ACbYDGem0XxrMx87OEgJW67On9Wt1TPA5VJMVfQJ
         FZvvLZ2fjIKtkBqxDD6dwsy1sgQWtfDjEVp5yvE1kvJ0+eyz4NsD82fnfcZ9H+k1Xi7Y
         ZPH8LujusZHGMJVYN6OJbajhF8dIL5266cU7srp4cTCUIf9J2+atEyT+3jhyLnNDwA6S
         hySQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TexCCK4LHRS1wbNZcYVcFTOY5FAdLJyGx/1qfFPO5vM=;
        b=eZon4Fj4KjPWd6FJLtGaCO0bg8JVDrqU2zL5PnXsPZkRh8JQBLE5pIYShT2tawYgiF
         18VdKYBXev3LxFgKihTjQUxQLilFWPWBtVguR5s8hwKrlNTViIWN9nJY91vwzdXuHJBH
         GVFF31J0FQUu1iX/YsTPAHVJhyMpcKME/HHW+yky0rOWYiUfM0AYdp3bCtin/vrssmyo
         EnnKRqNaf1fOZ2rpd6X9dY96bsd2U4VryvnhOx9ScpGUpsCxA1958LFz7l4DMQinFZ6W
         xMWBZWnrC4mWBA93CuyqcTiCAvGXTxPSZy+H619HfEn04X4X6XvmzzHC0bERz2++3Bty
         9Gjg==
X-Gm-Message-State: AOAM53324+s/CIY+DX3ZGcUA+HhNvqhWgZ7KbmCDr1XJ4N8E0eP8PJzb
        djPPtSc0mUiY73y+waF4LARZKONap28=
X-Google-Smtp-Source: ABdhPJzUeRYFzTGetgBYs+rhSpD7pAWRXAA+aIjG2Z9tiOSOM1sKz6bL75iabmoznXq4mK6RqhtCnw==
X-Received: by 2002:a63:e23:: with SMTP id d35mr4387409pgl.435.1594754804471;
        Tue, 14 Jul 2020 12:26:44 -0700 (PDT)
Received: from [192.168.1.11] (174-21-143-238.tukw.qwest.net. [174.21.143.238])
        by smtp.gmail.com with ESMTPSA id u74sm15800478pgc.58.2020.07.14.12.26.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 12:26:43 -0700 (PDT)
Subject: Re: [PATCH v3 1/9] host trust limitation: Introduce new host trust
 limitation interface
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, pair@us.ibm.com, pbonzini@redhat.com,
        dgilbert@redhat.com, frankja@linux.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        mst@redhat.com, cohuck@redhat.com, david@redhat.com,
        mdroth@linux.vnet.ibm.com, pasic@linux.ibm.com,
        qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        Richard Henderson <rth@twiddle.net>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
 <20200619020602.118306-2-david@gibson.dropbear.id.au>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <05f90104-98ff-016c-1179-15bf626d89b9@linaro.org>
Date:   Tue, 14 Jul 2020 12:26:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200619020602.118306-2-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/18/20 7:05 PM, David Gibson wrote:
> Several architectures have mechanisms which are designed to protect guest
> memory from interference or eavesdropping by a compromised hypervisor.  AMD
> SEV does this with in-chip memory encryption and Intel has a similar
> mechanism.  POWER's Protected Execution Framework (PEF) accomplishes a
> similar goal using an ultravisor and new memory protection features,
> instead of encryption.
> 
> To (partially) unify handling for these, this introduces a new
> HostTrustLimitation QOM interface.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  backends/Makefile.objs               |  2 ++
>  backends/host-trust-limitation.c     | 29 ++++++++++++++++++++++++
>  include/exec/host-trust-limitation.h | 33 ++++++++++++++++++++++++++++
>  include/qemu/typedefs.h              |  1 +
>  4 files changed, 65 insertions(+)
>  create mode 100644 backends/host-trust-limitation.c
>  create mode 100644 include/exec/host-trust-limitation.h

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
