Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA3D1EB3C1
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 05:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgFBDVK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 23:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgFBDVK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 23:21:10 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9106C061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 20:21:09 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 131so4377963pfv.13
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 20:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pldV5c0KP0qFT/A+GqTY1yOV4/MYneH4O4UQ/P/PL3k=;
        b=AnVwr6Z7usOyDJzyb9KogN3Y55/6LbY+BRAPDhus3XjoJnGs42iZHpWB/1tVqTwhDO
         D7uk/eQTDDSpvHRBRnRuVGrepJueRIuqdvhcrXRnPU6/1evz3nrdIJf2um4Cl2lMwGvp
         UiZUMu+t1ab5QHEn2EHP0XWpUI1BLcL1q8Cbj3MCo41IbYl8FBYUcGpDAUMVv7sHC3GU
         ZEf7qQ5/tKMSPffuZczv4b7McPlrGRhKZuC+V+ldQOyyZt36VPeQ0Gu8KOMBHMciqXk4
         yXusJAfHIoirxmL1AWHN51o6MXO+HEgpU47wxoqdYlER28tfzuQN3ps0PmmiSZrf2u4k
         H9+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pldV5c0KP0qFT/A+GqTY1yOV4/MYneH4O4UQ/P/PL3k=;
        b=OFle3iSFIKbSzaYrqS1+lYbkwr53W+5L3zTMJREEd4IrkLqTbTqXIvsEL2+FK3zI2C
         D2YcRg96MZqvcmMGjeAykIY8Z5Zmfanm86ihmFjp3tfrhYqDr5LBDAQYYJxIAOnPT+Je
         OMzDS+pStAyVOs7FX0U4nMrTtcXSjlUT+Uj+qDwxhh9zuu8cy4UBrBRtohcsQVIiHiwp
         Ue7SuD7YFPyPmzIDaVPuJW2sgc459mL672+rVBUqYziowJlqe290qYGLaJAK+n+EbYn/
         sr413OLajc/eSyFpvgGJaBXbZDNncg41ZO5o5ceg46U2wI0TDh+hb8MV6ILYtxCXJZbv
         aXgQ==
X-Gm-Message-State: AOAM532aQLf9qafIQIkyL7gcpCzkg1fc4UQGKduiqKRI0Vh659t7A/Bw
        MpAorqXR0bS/yT00rGbsWo739uBGXBc=
X-Google-Smtp-Source: ABdhPJw8AIn+8/l/R9wESu7wRvcSsnpNuj0whp+rqohxv0z0e+UbBQ8IrknQ0ZPQVs8BLOKjoKxhIA==
X-Received: by 2002:a63:e004:: with SMTP id e4mr20951893pgh.44.1591068069447;
        Mon, 01 Jun 2020 20:21:09 -0700 (PDT)
Received: from [192.168.1.11] (174-21-143-238.tukw.qwest.net. [174.21.143.238])
        by smtp.gmail.com with ESMTPSA id o3sm728599pfg.206.2020.06.01.20.21.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 20:21:08 -0700 (PDT)
Subject: Re: [RFC v2 11/18] guest memory protection: Handle memory encrption
 via interface
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-12-david@gibson.dropbear.id.au>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <857046d8-2731-66e6-b615-41e1d64b6308@linaro.org>
Date:   Mon, 1 Jun 2020 20:21:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-12-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/20 8:42 PM, David Gibson wrote:
> At the moment AMD SEV sets a special function pointer, plus an opaque
> handle in KVMState to let things know how to encrypt guest memory.
> 
> Now that we have a QOM interface for handling things related to guest
> memory protection, use a QOM method on that interface, rather than a bare
> function pointer for this.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  accel/kvm/kvm-all.c                    | 23 +++----
>  accel/kvm/sev-stub.c                   |  5 --
>  include/exec/guest-memory-protection.h |  2 +
>  include/sysemu/sev.h                   |  6 +-
>  target/i386/sev.c                      | 84 ++++++++++++++------------
>  5 files changed, 63 insertions(+), 57 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

