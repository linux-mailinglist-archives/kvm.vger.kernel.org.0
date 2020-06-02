Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632AD1EB3A1
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 05:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgFBDHc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 23:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbgFBDHc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 23:07:32 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131C2C061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 20:07:31 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id a45so556313pje.1
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 20:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dA2hMTzLI2RiavnaymrbP0LC+zeelSfH6iYBBbIldTI=;
        b=BFaDyC9aO+HrAZirnXV3Q/cek0ShMpf9u3NfXeXEKy5zzgErEyG/Yk5yXhWNRM0ebW
         Kf+GffLb+65t6NLuJ0p7Kaa5wx78TrbVOps9oSOkDOTInJdoVo7M0u9JsUEA8vKq6p24
         RDmjVo8Szy3XGaG227/MmkJsa7hZ5pVr1AdFw/8tgJ2gvN1bUfmM6YBkLIOAmfEXcFLm
         xsdfgHyOxZ0eVJ6BT5LhEf44oN9GhGrvO8gz1tiDAT7+l1i1MTlx+EQ7hPP6MoZsqOB/
         YwQbdKV5PyMNLkawFbloeoNq6dPwnjygHvMmtJB8zRYMvq+8As4fNMvpoZSnWxBuFnv7
         nhrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dA2hMTzLI2RiavnaymrbP0LC+zeelSfH6iYBBbIldTI=;
        b=WAtNOUzf6YcLuD+2J1u9Adysl9ex4kUCyxhRiVdOdd/tE/Wd3q71Qv3pMHGYcIq6YQ
         5HO2qXpwSfP76e9c4oj5m5tZmMESrev/WbF9KfxXWkpb0Bf32yyzrgsN0oNsRUCzbp8F
         Hqm3wFGayFuYNfvJ5GTmK49ci2x2SY7r00+hzh2Fb2RTtWzZgI9uzeGp63PjssG/J7J7
         FkCumr+dBNoktCo+RP/NazdOcgRkAn63jjp/Cm9yj4FP1ohnXQp2C7PR3+H/kh4obNVa
         27oeD370Ba5u0DZPP1pE7kH/mIUmA2m0OJkxcwePAGU+s7TZwgDcu3/hsfTz3B7l99m/
         fHwQ==
X-Gm-Message-State: AOAM533xYHKMoC1C72DlmK29tDE5btFptr1Ud0wWZEmjNV7qwuYdL0Ee
        Y23YTr6HxhsGjOQ78bwk1PeLOg==
X-Google-Smtp-Source: ABdhPJwtA0mWYYf/q4GRy+YMdTvRVgTk9rzVjQFFBiSTWOgIuNrhGFnowhWRlchx8yFawb+JLhgE6w==
X-Received: by 2002:a17:902:7c8e:: with SMTP id y14mr11665811pll.312.1591067250649;
        Mon, 01 Jun 2020 20:07:30 -0700 (PDT)
Received: from [192.168.1.11] (174-21-143-238.tukw.qwest.net. [174.21.143.238])
        by smtp.gmail.com with ESMTPSA id ep10sm706673pjb.25.2020.06.01.20.07.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 20:07:30 -0700 (PDT)
Subject: Re: [RFC v2 04/18] target/i386: sev: Embed SEVState in SevGuestState
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-5-david@gibson.dropbear.id.au>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <10ae7ddc-1305-4455-7146-d97e2091de86@linaro.org>
Date:   Mon, 1 Jun 2020 20:07:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-5-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/20 8:42 PM, David Gibson wrote:
> Currently SevGuestState contains only configuration information.  For
> runtime state another non-QOM struct SEVState is allocated separately.
> 
> Simplify things by instead embedding the SEVState structure in
> SevGuestState.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  target/i386/sev.c | 54 +++++++++++++++++++++++++----------------------
>  1 file changed, 29 insertions(+), 25 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

