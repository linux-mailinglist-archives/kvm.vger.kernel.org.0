Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5AB81EB398
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 05:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgFBDFG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 23:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbgFBDFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 23:05:06 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E005CC061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 20:05:05 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id s10so4427427pgm.0
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 20:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q79/v9H68cK5C7XX/viEJpmvLwAnEc6hXS/nhR9uUF8=;
        b=x7ntDC8Ib5bkOenoqR8y3uyp5xoI3xwAzgNK0yIr4WUIwyXXdCOMGsaq119eKu7gAK
         OVKkVVcj1ZpPLVwwN7/Or0qn4avipMUJ1QdlkG3zRanX0P3hPjCDX+mxkGiz/k9SxhVu
         BViti91rShW/ARbvD9553W/nKmRUZeWFC7W9tiDUZcGjcjw0Ru3OcN027qHBPyqMD4ng
         FrSg0NhQ2Y6RaZixzctKEHMm/P7jw7FG8QEckdn2w+EXHG0RREyc1s2s6f1RdnM9kdyf
         acWYWihWVu1CNRU/UYPbZGJ9Ltf0RZIkmp9fFu54s5n5acgQzcQ/QNdl7EuRWujztzgT
         Tn7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q79/v9H68cK5C7XX/viEJpmvLwAnEc6hXS/nhR9uUF8=;
        b=drpOyNwaawwX1658CgK5jzA6n+scjUQEMezNfSHzltX3GHTLKIlH4iY8Rn+fZd4/JO
         Fe1jWxTjprGEoURlr4/ja7bp7AnDit1JNXWrm34Yt4LviffAJwBHAPkxHx+D4Vg1vj/q
         AoOPM+UvKCuawc7++P9+7QfkLw6DaZSndwlbg2g1nGCEyb48tVWL32JJN4wC55ss/CLZ
         gSqgJNvY9HtmtikmqTwEriFSlCW0JurkAeDOyFSXsASbzbl+UXdCTSVItauGX6EEpbMz
         NPIrY/kwA0Qq+9Rtnfd6gDXkfYPmYXo5UjPRtCrSo6ushp6Ndu8JGob6Njg0lYQx4D8g
         sX0g==
X-Gm-Message-State: AOAM532fD6oDW/wnIVaYhH7hLIIJyfTZhpuRQ2TnfUrdhAUMNG6o8ZiI
        2qRkeDRYu+ot9NpMESCivc7x6w==
X-Google-Smtp-Source: ABdhPJzxyp0zM22v1JilGfXzqa6umsvBbwONRFIsa9RFtgb+wH8jU90xAfGAOoORAvgHwo2B4ELLLw==
X-Received: by 2002:a63:565b:: with SMTP id g27mr20998356pgm.166.1591067105385;
        Mon, 01 Jun 2020 20:05:05 -0700 (PDT)
Received: from [192.168.1.11] (174-21-143-238.tukw.qwest.net. [174.21.143.238])
        by smtp.gmail.com with ESMTPSA id s15sm691624pgv.5.2020.06.01.20.05.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 20:05:04 -0700 (PDT)
Subject: Re: [RFC v2 02/18] target/i386: sev: Move local structure definitions
 into .c file
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-3-david@gibson.dropbear.id.au>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <871c356b-5652-71e0-1f2a-72f75c4743e2@linaro.org>
Date:   Mon, 1 Jun 2020 20:05:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-3-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/20 8:42 PM, David Gibson wrote:
> Neither QSevGuestInfo nor SEVState (not to be confused with SevState) is
> used anywhere outside target/i386/sev.c, so they might as well live in
> there rather than in a (somewhat) exposed header.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  target/i386/sev.c      | 44 ++++++++++++++++++++++++++++++++++++++++++
>  target/i386/sev_i386.h | 44 ------------------------------------------
>  2 files changed, 44 insertions(+), 44 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

