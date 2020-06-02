Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFFB61EB3FC
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 05:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgFBDyr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 23:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFBDyr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 23:54:47 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE0FC061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 20:54:45 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b201so327589pfb.0
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 20:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MLgaGNAcY4DzBGxSSksqhm3igUs2JVkoA7ZxL2vr8Rk=;
        b=V1c7lea6N0P6MTFf9d8CH8XQ/JTwhC+L0g3XyPE3mRxZwbu1PrhHp4iv54JKjsPElT
         97HkwITVKAOyl3Pz3SAkTNMiumewItfMTen9Iazl2zjWdagPLo/sZ3yM1xg/y/ApjH6W
         D8KMO5+hz6jKt/zSfM9G0axdckzYzSyQx12zfEfrvaTsi93thcNL5rAqtHw9ytJuRA1s
         qy1guGHeym0pmJhO3Wv11LabC/5d+Tdm6+s19UbSpJM2giEmBSJqIAXIPpD+I0gaaOgw
         yMmEl5zEf4BbAetgPvfaCspu3Q3QVk33wT6YQ4VRKF1GgEVu7ePr/+9nvWK+yC3Zu+Z/
         AimA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MLgaGNAcY4DzBGxSSksqhm3igUs2JVkoA7ZxL2vr8Rk=;
        b=QpW3fMXodkeFmP54skkwvRCVteNLm3S5MtEBzNtqT8XmyTCJED6Ood4ZvYZJzXudnc
         aB97AwCvFINO94ezCWt0sABT2j/YouXB8jFWFSdGN6lYZWextZV4ptedtop1ndcdNuEo
         MI3Ww98KDTWrKPFWbwdNE+7w4jZWZQ9qQ80X8zvURdU9kfJ2M6c1UB+AJUVu3ZYOnmj9
         N5LjBIaRZw2/H1TmbpojbskEcuMNf4yfz8IWZqfPCbs/q2Tu+AL1wSDeJvO53e/VJbZ6
         BWkIm41FWjOSyXKMLSokOXd4qbwVwx8d7pzHNKnuhbrFJt2IP/Uvay6oML0dF1oUycKz
         9iaw==
X-Gm-Message-State: AOAM532Wm4EbAU1m3wcK7wDgcnlYl0j0zoS9+OeD7kQXsbPU/fU2I1C3
        uZUSKm13aAbz8WvTSsrqy2xJHSFKZiA=
X-Google-Smtp-Source: ABdhPJyRTjC/w8+5+5sIm/dWueJIR1CmiWmheInGxu1keyfUES3FupWu5rJxoPsZObpkcz0+wsEBWA==
X-Received: by 2002:a63:64b:: with SMTP id 72mr22811956pgg.437.1591070085340;
        Mon, 01 Jun 2020 20:54:45 -0700 (PDT)
Received: from [192.168.1.11] (174-21-143-238.tukw.qwest.net. [174.21.143.238])
        by smtp.gmail.com with ESMTPSA id b140sm770096pfb.119.2020.06.01.20.54.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 20:54:44 -0700 (PDT)
Subject: Re: [RFC v2 14/18] guest memory protection: Rework the
 "memory-encryption" property
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-15-david@gibson.dropbear.id.au>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <4061fcf0-ba76-5124-74eb-401a0b91d900@linaro.org>
Date:   Mon, 1 Jun 2020 20:54:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-15-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/20 8:43 PM, David Gibson wrote:
> +++ b/include/hw/boards.h
> @@ -12,6 +12,8 @@
>  #include "qom/object.h"
>  #include "hw/core/cpu.h"
>  
> +typedef struct GuestMemoryProtection GuestMemoryProtection;
> +

I think this needs to be in include/qemu/typedefs.h,
and the other typedef in patch 10 needs to be moved there.

IIRC, clang warns about duplicate typedefs.


r~
