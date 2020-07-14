Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31AC21FD76
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 21:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbgGNTgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 15:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728768AbgGNTgn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 15:36:43 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB61C061755
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 12:36:43 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id a24so2393609pfc.10
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 12:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AkzKjzcpZZ6V+5dJ0AMAwarmuZaZ2SA0/OwS5u5zcM4=;
        b=vYy66G492hs2XKYL3b5dB74Arnw4CsxTIXh7FeiaRagkuDjpTx3ne0EeL7QmmB2IcC
         J1goyCePmLtY6nKpp4ULo+kqABje0BLqEMlGhl8CHr5E4xuQjq8NbBkRl+dL0+csQs0i
         yGpE/RZzIGsHFIE7rARLb8h3cUCiZ2RopxN1GB6fJHvisvzc+loCjTxqZr7opBMt7Hf9
         10W2JWyUo6/1IC6hbotN9GYQHVP2dLW8/WQKeRDrK1O8Tsrc/drErqTWcmATUOA1GxZN
         JO9cFRg4XY3XWj+RidgbE43gXb9TAO+Z3HM4viIlnXBlChRNhggD+03yp8AI56H0CJhp
         Zi9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AkzKjzcpZZ6V+5dJ0AMAwarmuZaZ2SA0/OwS5u5zcM4=;
        b=HmjXRLLKBex9I4jYD22dWHmIBuZT9ayjHep75lhtOvRAquEOVl+4zJDRS0QtoutrV8
         KLkyXUbZGPafXZt5zhZgtGkbjrSh9oicySAlVvJejZwOqRzIIxSjfoSTRTTCdO0A/zPC
         YamGxR62HZ0F7DW6IsVKG2WJq77cW3/R7pvlEFev95V5mRnNb6BHkbNpu6V0acJHyYIp
         ubeS689tEM2PhsybJ/txj0ilsRMuj54SgKiR3BkIk4HQMap90XJ+U2gEtC/DNtQjoLnY
         2K40cXm5MXAFR23Nhg4ruuLdCZwdKlzBmI5q8ND5jgDUVt+ZgHbshzMIqoxJFZ8CFKMw
         zV8Q==
X-Gm-Message-State: AOAM530HFNLhqwSATg0HHa2nVLplcPITTAehMsvlsnP71jHDsOp+R/v6
        0UgBe0K8xr/ZCXFZDblIOcIm5Q==
X-Google-Smtp-Source: ABdhPJyk+YQYzkm1sKfFrb+5sfZnL7XVVX/5Q8HvLPikfWqZpa2+trtI7HKDbgp13C/zKy+X/Yuh5Q==
X-Received: by 2002:a63:c947:: with SMTP id y7mr4487627pgg.357.1594755403330;
        Tue, 14 Jul 2020 12:36:43 -0700 (PDT)
Received: from [192.168.1.11] (174-21-143-238.tukw.qwest.net. [174.21.143.238])
        by smtp.gmail.com with ESMTPSA id a30sm8517pfr.87.2020.07.14.12.36.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 12:36:42 -0700 (PDT)
Subject: Re: [PATCH v3 4/9] host trust limitation: Rework the
 "memory-encryption" property
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, pair@us.ibm.com, pbonzini@redhat.com,
        dgilbert@redhat.com, frankja@linux.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        mst@redhat.com, cohuck@redhat.com, david@redhat.com,
        mdroth@linux.vnet.ibm.com, pasic@linux.ibm.com,
        qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        Richard Henderson <rth@twiddle.net>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
 <20200619020602.118306-5-david@gibson.dropbear.id.au>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <33b0169a-1c9a-276f-361f-b27c39f366b6@linaro.org>
Date:   Tue, 14 Jul 2020 12:36:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200619020602.118306-5-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/18/20 7:05 PM, David Gibson wrote:
> Currently the "memory-encryption" property is only looked at once we get to
> kvm_init().  Although protection of guest memory from the hypervisor isn't
> something that could really ever work with TCG, it's not conceptually tied
> to the KVM accelerator.
> 
> In addition, the way the string property is resolved to an object is
> almost identical to how a QOM link property is handled.
> 
> So, create a new "host-trust-limitation" link property which sets this QOM
> interface link directly in the machine.  For compatibility we keep the
> "memory-encryption" property, but now implemented in terms of the new
> property.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  accel/kvm/kvm-all.c | 23 +++++++----------------
>  hw/core/machine.c   | 41 ++++++++++++++++++++++++++++++++++++-----
>  include/hw/boards.h |  2 +-
>  3 files changed, 44 insertions(+), 22 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
