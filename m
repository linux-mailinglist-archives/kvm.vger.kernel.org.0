Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7161050B4
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 11:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfKUKiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 05:38:25 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35929 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726947AbfKUKiY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Nov 2019 05:38:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574332704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gcx4NotMnfWI8ryROCazs48WfO2wapfkiUCvjD+j/TI=;
        b=SAJ14eyiVA3k3vbrzT4vot/3FpIP+jl+IxKxrYKMyHergEcyZO6wRMTPDJjAb/c9dMww7Y
        iouJXs+t48OtX6QWG1dG/Pw0Yu4B0K+iPPEF+i4dpHGMZ+XqRB6sBWuJ2Ykxm8lIfOuvKs
        /w9+xqgvwyVYPNWKNU3g+1dFdPKUqCU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-UVAB1NCUOlGfaDVvGMBRYw-1; Thu, 21 Nov 2019 05:38:21 -0500
Received: by mail-wr1-f72.google.com with SMTP id h7so1881594wrb.2
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 02:38:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zCRBPyvdRSagG9bu6g7JLItNtcbbQJccmo18+XWsj1g=;
        b=mClIOUyIQJJDmFTR8L9R7TIskQDxxRJklVJNBiJjRL1lipCUCjoGAstO4zhPj7Htx/
         05gtx9x+uUFjjmPDGvLflgcSqbk/gPMpPPW0SreQAd2e0RuS9u3DyhxTzx+ApWO+cTnE
         2AX8WagBp71AwSGmS4eZV3FlgBF+i1GNrAgKCdXand0EyxytGfDEnjPV2DoX1CeeRWW4
         AJ6NCf29MKado9PngunoKV5r5CGe7AWwqgIWrOUrUoE1ql8inf1yHGOwa0oUfeousyl5
         xub10cs2Lndh5qEVPrJfCW25TRwKvHrjnUj2XmJRTJV2nj3jB5da9OtbMQfoxsgYpAji
         5XTw==
X-Gm-Message-State: APjAAAXWjiYSG/AR4ybY16LRZcJk2c2LJuyQfogctlZYBxcKBBHnWtPI
        iT26NNhHlGWlwUY/JT0k762FT38593iNI8TNa/rcr5otmU/C4vi9HCgeGtCs+al9P5RE8Xr8PvW
        GeQMKqfYDZRVX
X-Received: by 2002:adf:e803:: with SMTP id o3mr9693023wrm.326.1574332700002;
        Thu, 21 Nov 2019 02:38:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqyrXPnT74IzyupD1iCDtakTuMWQXc9sqwsiS9lodrPz+fHzBQXzWngw7Q9U6oB/kr7PmVmzpg==
X-Received: by 2002:adf:e803:: with SMTP id o3mr9692996wrm.326.1574332699760;
        Thu, 21 Nov 2019 02:38:19 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:71a5:6e:f854:d744? ([2001:b07:6468:f312:71a5:6e:f854:d744])
        by smtp.gmail.com with ESMTPSA id w17sm2896352wrt.45.2019.11.21.02.38.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 02:38:19 -0800 (PST)
Subject: Re: [PATCH v7 3/9] mmu: spp: Add SPP Table setup functions
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com
References: <20191119084949.15471-1-weijiang.yang@intel.com>
 <20191119084949.15471-4-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5b0da087-8ce0-2b01-5a1a-4d8c5f319d33@redhat.com>
Date:   Thu, 21 Nov 2019 11:38:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191119084949.15471-4-weijiang.yang@intel.com>
Content-Language: en-US
X-MC-Unique: UVAB1NCUOlGfaDVvGMBRYw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/19 09:49, Yang Weijiang wrote:
> +static int is_spp_shadow_present(u64 pte)
> +{
> +=09return pte & PT_PRESENT_MASK;
> +}
> +

This should not be needed, is_shadow_present_pte works well for SPP PTEs
as well (and in fact you're already using it here and there, so it's
confusing to have both).

Paolo

