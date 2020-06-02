Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171131EB39B
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 05:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgFBDGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 23:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbgFBDGR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 23:06:17 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7216C061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 20:06:16 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id i12so692806pju.3
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 20:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xsQMtdzQ9Pp9Q1Pbe+tPvOkKNBDDtRrjGAPG8XpVmEE=;
        b=zC3h1COmHDHwYdzJlj3X8iD7eg6vFX9wkNV1CyF6RzbJzko9If0cdEiKx9DD7A0Vj8
         rw7pb+tig5b3JFQPu38nWJy5k7cbDwf82iSwOeFH83bOJ2lj0ViwJCNbGsw8UCasrSvn
         Lh3pMWHU/vb8mHC0o7RkJ58cZ5U58RQY504XHUJH4CxefDjEz9U+P5et3jJS9Rntr5nF
         wwYtlZ6+xh9TLWmog9qeqivdV6ubyykgciZB4zTh1iDYcYpHB1OV2pP1dFMxnAiuT1Y/
         WBkmKixB97hkoI3v8wbFNa22KtCCQIdQRYI4nuDmos4+tvuu+3ejh11nhgVZ/FMY6MMr
         7dCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xsQMtdzQ9Pp9Q1Pbe+tPvOkKNBDDtRrjGAPG8XpVmEE=;
        b=gd6T/DkLQm/XwodOuFTSz3wXk35ddCoRObj3a5GcheKSUKjCS0bSYC1YAJm+hfyALq
         CVye92Kpu/psXPa9e5BO5dk7Xd2DapBSwrRX4N2YOcb3Z4Z9BiR0HUguHGKEjBLe56V1
         I0/+RfGUdtdGE2gfST9IS5e/k+aX57xjsKfTdV2KSdOsigt4gN5QR7VuUZmk775yPk5n
         P1OCtczKJVNEbNlfthNyqsHgQHhFt9TUTH2STj4moi7Is+L9Cpu9KUKKGKjGdwvozhNT
         AcjcEmg/AwV1/mTUnTKnpXS+ojf1JEU1bmKDSZNHWBd60jSi3MhISR3Pgo7oi9uT3hxv
         3Fyg==
X-Gm-Message-State: AOAM531ngpnnmucqBenoH5amZpqc+M0mBi4p1LX8izBVDrSifAnItSeI
        gKno3uy505/UskSRPilhtK+vxQ==
X-Google-Smtp-Source: ABdhPJxmL69WPPUuZ+HeEZcPC+C/5oerSOyw052cbu+W0htAso8s9bpRyNK41PJt4c8MSX3iHsfFqQ==
X-Received: by 2002:a17:90b:50d:: with SMTP id r13mr2860959pjz.94.1591067176442;
        Mon, 01 Jun 2020 20:06:16 -0700 (PDT)
Received: from [192.168.1.11] (174-21-143-238.tukw.qwest.net. [174.21.143.238])
        by smtp.gmail.com with ESMTPSA id j186sm678118pfb.220.2020.06.01.20.06.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 20:06:15 -0700 (PDT)
Subject: Re: [RFC v2 03/18] target/i386: sev: Rename QSevGuestInfo
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-4-david@gibson.dropbear.id.au>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <db54b6ae-5bfe-b580-b6fd-6f80a3fd333a@linaro.org>
Date:   Mon, 1 Jun 2020 20:06:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-4-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/20 8:42 PM, David Gibson wrote:
> At the moment this is a purely passive object which is just a container for
> information used elsewhere, hence the name.  I'm going to change that
> though, so as a preliminary rename it to SevGuestState.
> 
> That name risks confusion with both SEVState and SevState, but I'll be
> working on that in following patches.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  target/i386/sev.c | 87 ++++++++++++++++++++++++-----------------------
>  1 file changed, 44 insertions(+), 43 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

