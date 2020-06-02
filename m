Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4166B1EB3BA
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 05:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgFBDSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 23:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbgFBDSV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 23:18:21 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34CFC061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 20:18:21 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d66so4396013pfd.6
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 20:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OkFIi5Mxf3fvPsHj+oX7KiNnRIh3rdVzURh4uHgDtIY=;
        b=M//U9dV1UjwjmeNNOods+7qc5yBfWVVW6bBZXVhq0Kobt83OuicJO4gCwgjjJWgkJD
         e0SUe3iPCahcHuKTnOVsSO3kPJxYw9a2S1LvvQ5hAmgFKFf+kjOvQfwOfRp2JeWE3yeI
         KNF0FGwnIcat1L20aKdEwD9IIjpJMqUMOWufMRZAdA5hWA1GyBEFVh86ERcMGa0yC5km
         NSfp4jMGmP+7FKgXRmhcBNCWM89a6PHgsR7uxfkJ3B6jRPAhAlTYl0DoHQfqXHV9GaBd
         OkHxa2pUMW8mljYyFBLJ3bGNeg4+UXu5wh4AOwDklzYeAHJa7YN3AwKh0NshrygfWYAE
         PtAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OkFIi5Mxf3fvPsHj+oX7KiNnRIh3rdVzURh4uHgDtIY=;
        b=tjnTZGDIafWEx0WKQ7bY6W/RiIUgORWbrRGHaFERZVzWBEQhbd7r0mx77207PT3Pj4
         YPEiyIRLuFC8DEOO00UQKJHgBq2eJNXv5Y5nXTPPkLynxC2bQEb28szBozTu+iwbXo9s
         nVcwiGUaRoAkrnD6wZPja6Gnby6XOxECbsamvrfHlwnihirkQh+2P39wXK8c54XxPCok
         K57ZfRq/WYIuBFmkwWnV42WMDFC/Y2nxt3/3bSP7TjWLkIJrphFRdae4gaGSuyhw9vY7
         057TEOawZNVYr0nCdvaVCFQ3RE5vdqh4pLNYkj+fk9Xowrx5gli6LrAki5Ryxx8mHt3k
         O1Yg==
X-Gm-Message-State: AOAM530RB4UCVAHptSFL8KOpqYHy12kpqmu52EZD+zwnmZq7WDePXHDO
        j3Y8zIZUdEjVXIYa8AL4v2tsIUsWxAg=
X-Google-Smtp-Source: ABdhPJwNGG9GWJajoXpr3g6vvaivD/1cTPCj7p9XmmjiW6KU7Do9GR3B4HKwd3VTxsbJtG+W28/q8w==
X-Received: by 2002:a62:8c42:: with SMTP id m63mr23039485pfd.106.1591067901032;
        Mon, 01 Jun 2020 20:18:21 -0700 (PDT)
Received: from [192.168.1.11] (174-21-143-238.tukw.qwest.net. [174.21.143.238])
        by smtp.gmail.com with ESMTPSA id e124sm709630pfh.140.2020.06.01.20.18.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 20:18:20 -0700 (PDT)
Subject: Re: [RFC v2 09/18] target/i386: sev: Unify SEVState and SevGuestState
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-10-david@gibson.dropbear.id.au>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <fc66c595-9a10-65f0-37c0-83ff1d5e42ed@linaro.org>
Date:   Mon, 1 Jun 2020 20:18:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-10-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/20 8:42 PM, David Gibson wrote:
> SEVState is contained with SevGuestState.  We've now fixed redundancies
> and name conflicts, so there's no real point to the nested structure.  Just
> move all the fields of SEVState into SevGuestState.
> 
> This eliminates the SEVState structure, which as a bonus removes the
> confusion with the SevState enum.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  target/i386/sev.c | 79 ++++++++++++++++++++---------------------------
>  1 file changed, 34 insertions(+), 45 deletions(-)

Yay!

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

