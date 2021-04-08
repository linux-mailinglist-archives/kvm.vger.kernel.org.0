Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9222358860
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 17:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhDHP2c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 11:28:32 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:37549 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbhDHP2b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 11:28:31 -0400
Received: by mail-wr1-f41.google.com with SMTP id j5so1611179wrn.4;
        Thu, 08 Apr 2021 08:28:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gK85oRtgx22IENeRH1/21Bbnbfi+BK9NhFcMbnn61dg=;
        b=fDBTCIKXvDVx+ASiRuSWzYdHbaSjoMWL5SGpNzd9E4zYgBlC99ycq6EjzOTNjS9wbr
         YWqlNVUHwexkz7/AsLYWIWXm8yMu6XiELq/RFN61OqaEWqzNsWmZrolmsInfFAMVWTZE
         caYrurGsU1Roq7KHdDJrfnTihiKggGzWKqyu1LJvyuyVRXJ/7g1xDOLnSMf9Q9+ybehl
         m6icQWA1bndByxUU3G/753qdCGi5kCoHmMNq/ljF05TUcq9AINfPpUaSlbUsnyUoslQZ
         QW1ztSmK7xyR4urHBxXJCqhFR+L5ulcaKS6eEdlYRBMoG/UuUkWIz0d80YnG/RD2vr6y
         1r8w==
X-Gm-Message-State: AOAM530DlcG5b+HIIthlLbgH8EplRSK4+3ZS6umVIJ6qVmmjZ6+m2IRI
        5TChaSuCL823wL4c0TrfiNE=
X-Google-Smtp-Source: ABdhPJwBs7+lemy10TbcuBFDCUmjcAV4v7fYGt4zEsgGsfoc3s8ff5k+qOcDXY5YNQsL2sdgcuKMyg==
X-Received: by 2002:adf:ea8b:: with SMTP id s11mr10744907wrm.282.1617895699363;
        Thu, 08 Apr 2021 08:28:19 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id h2sm3589854wmc.24.2021.04.08.08.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 08:28:18 -0700 (PDT)
Date:   Thu, 8 Apr 2021 15:28:17 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, graf@amazon.com,
        eyakovl@amazon.de, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/4] Add support for XMM fast hypercalls
Message-ID: <20210408152817.k4d4hjdqu7hsjllo@liuwe-devbox-debian-v2>
References: <20210407212926.3016-1-sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407212926.3016-1-sidcha@amazon.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 07, 2021 at 11:29:26PM +0200, Siddharth Chandrasekaran wrote:
> Hyper-V supports the use of XMM registers to perform fast hypercalls.
> This allows guests to take advantage of the improved performance of the
> fast hypercall interface even though a hypercall may require more than
> (the current maximum of) two general purpose registers.
> 
> The XMM fast hypercall interface uses an additional six XMM registers
> (XMM0 to XMM5) to allow the caller to pass an input parameter block of
> up to 112 bytes. Hyper-V can also return data back to the guest in the
> remaining XMM registers that are not used by the current hypercall.
> 
> Although the Hyper-v TLFS mentions that a guest cannot use this feature
> unless the hypervisor advertises support for it, some hypercalls which
> we plan on upstreaming in future uses them anyway. 

No, please don't do this. Check the feature bit(s) before you issue
hypercalls which rely on the extended interface.

Wei.
