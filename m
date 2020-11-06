Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E711D2A9583
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 12:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgKFLeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 06:34:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32020 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726708AbgKFLeR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 06:34:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604662455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sjez0EYWnkwuVoRG6rli6p6siYwYNXUN23Sh6/FuNhQ=;
        b=Px7njaxPSYjXzsx6y6+mdv/T/gf9jM20kYdiOd4J+hcEz12xCFZdsUU/gerMPKAcQ8C2gM
        sKEcRHy2fHZnJvNAMtBNxVkUVR41WhWsYru14Oz+vMmLw2snwt5DtLZNjeuAIuBrqGdkuM
        CsPu07NFBajWXk+45VWsJeRQaxVznS4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-_ldXegQ8OBG8kJVEMLCcXA-1; Fri, 06 Nov 2020 06:34:13 -0500
X-MC-Unique: _ldXegQ8OBG8kJVEMLCcXA-1
Received: by mail-wr1-f69.google.com with SMTP id h11so359185wrq.20
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 03:34:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sjez0EYWnkwuVoRG6rli6p6siYwYNXUN23Sh6/FuNhQ=;
        b=Fkho/oRv0SHoRwGjBeH+rBHipiOjvSkbzCPOB4rNW3EZIfmAvP0ch4mby7FtDguTqD
         QvWACf1npe+J3G3ANKThYGFCaRglPcLBew/Aob6b93wDMIZPFFqwovDMe5ZJp+1i9Rsf
         qe8oZH85ULriCyxvy42m1ATPuqS2k1Bg0vPjFzaVyccxmvayy4HXTzX5WgeVAtxqM0F1
         3uRjYxEDA5kYoAm4aHGAsbdCF2pQU/hI3MmYIddFDFvzLQfIm1bmwk36t6ZfjwPZRY3e
         0Hags21i4M5RJ+qjDp6cm9neSiCb/8D+lT0YXtFLW81qwLzKMZ+7qPh33zct6UVk+75D
         UVyw==
X-Gm-Message-State: AOAM533qAwMqHHwKgt6Z9HnVG2AuyUcX7aDt8zMxLkm27TqQx3aKX6zI
        qCqNcAQHhOGPU5vZa3g2lofIFAaS4OxA0i9exj6fWKeuylxiqjVhVFVG4fxaNoFa92mATfzTE+x
        W34NG0o4ism9Y
X-Received: by 2002:a5d:51d0:: with SMTP id n16mr2123597wrv.43.1604662452730;
        Fri, 06 Nov 2020 03:34:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwkQaesVH+9iIujzekV9vls7gArWriwIHk/do7TWYSDqT2QKId/Q6vQU9sUQ4p4X1m/YlRtIA==
X-Received: by 2002:a5d:51d0:: with SMTP id n16mr2123572wrv.43.1604662452510;
        Fri, 06 Nov 2020 03:34:12 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id v6sm1825329wmj.6.2020.11.06.03.34.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 03:34:11 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 3/7] lib/asm: Add definitions of memory
 areas
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
 <20201002154420.292134-4-imbrenda@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1429868e-2348-e7a3-0668-4fc2439052f2@redhat.com>
Date:   Fri, 6 Nov 2020 12:34:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201002154420.292134-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/20 17:44, Claudio Imbrenda wrote:
> x86 gets
> * lowest area (24-bit addresses)
> * low area (32-bit addresses)
> * the rest

x86 if anything could use a 36-bit area; the 24-bit one is out of scope 
for what kvm-unit-tests does.

So something like this:

diff --git a/lib/x86/asm/memory_areas.h b/lib/x86/asm/memory_areas.h
index d704df3..952f5bd 100644
--- a/lib/x86/asm/memory_areas.h
+++ b/lib/x86/asm/memory_areas.h
@@ -1,20 +1,19 @@
  #ifndef MEMORY_AREAS_H
  #define MEMORY_AREAS_H

-#define AREA_NORMAL_PFN BIT(32-12)
+#define AREA_NORMAL_PFN BIT(36-12)
  #define AREA_NORMAL_NUMBER 0
  #define AREA_NORMAL 1

-#define AREA_LOW_PFN BIT(24-12)
-#define AREA_LOW_NUMBER 1
-#define AREA_LOW 2
+#define AREA_PAE_HIGH_PFN BIT(32-12)
+#define AREA_PAE_HIGH_NUMBER 1
+#define AREA_PAE_HIGH 2

-#define AREA_LOWEST_PFN 0
-#define AREA_LOWEST_NUMBER 2
-#define AREA_LOWEST 4
+#define AREA_LOW_PFN 0
+#define AREA_LOW_NUMBER 2
+#define AREA_LOW 4

-#define AREA_DMA24 AREA_LOWEST
-#define AREA_DMA32 (AREA_LOWEST | AREA_LOW)
+#define AREA_PAE (AREA_PAE | AREA_LOW)

  #define AREA_ANY -1
  #define AREA_ANY_NUMBER 0xff

Paolo

