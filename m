Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC16375D4C
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 01:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhEFXG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 19:06:28 -0400
Received: from mail-ej1-f52.google.com ([209.85.218.52]:37841 "EHLO
        mail-ej1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhEFXGZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 19:06:25 -0400
Received: by mail-ej1-f52.google.com with SMTP id w3so10709452ejc.4;
        Thu, 06 May 2021 16:05:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=xiYsX+pQ+W+XclZNAbSUgXe8vQZK960XlPejiQx4G+I=;
        b=umw/x2klhJpQj/yDrADVNyma3sN0BplIYB3pGtpZ1U+Z78+JRhy/klM5bjK0Y/jVBa
         HeQ49S64RSW5dtulAmitPOQmbqNqqcIrUAfZ3deO/rkJGPofwLhn0aWt3KQTGY5U/Bg0
         B7NZZLpZ+2y5RBtHj1lH9SoFwdvy7u3AsIEr3Ruadz9qagxv8kQ6Oiqqxj+15ilO8ViE
         v0pGdllQsfolTYRQJ3U1bzWVJdtIA0Q6l1A5klGo18vawEwekrzKg6RloqDdm6YehwG7
         Py69k4nANU0HS8wNGqAxXMPbBcIKfpyGpsEvSOwfIZB/FicKCrvIAiHM4EftC2MnFkHn
         RXlA==
X-Gm-Message-State: AOAM5326D0ZUXjMfwiyAHnHpzgvGTH74sCsH94hgR/zD+eC3kMA+QTrP
        Layws4zZ8LR4LeRWGtjJPh0=
X-Google-Smtp-Source: ABdhPJxfEa+LefWTL1HLMhIgkl4H2WnscZs0bTzFRszejT/IRNra9eIDiRqzVXWDMFGjuBQ+Kat2lQ==
X-Received: by 2002:a17:906:b1cc:: with SMTP id bv12mr6803610ejb.407.1620342325288;
        Thu, 06 May 2021 16:05:25 -0700 (PDT)
Received: from localhost (net-188-152-97-238.cust.dsl.teletu.it. [188.152.97.238])
        by smtp.gmail.com with ESMTPSA id v26sm2341203ejk.66.2021.05.06.16.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 16:05:24 -0700 (PDT)
Date:   Fri, 7 May 2021 01:05:18 +0200
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 21/24] KVM: x86/mmu: Tweak auditing WARN for A/D bits to
 !PRESENT (was MMIO)
Message-ID: <20210507010518.26aa74f0@linux.microsoft.com>
In-Reply-To: <20210225204749.1512652-22-seanjc@google.com>
References: <20210225204749.1512652-1-seanjc@google.com>
        <20210225204749.1512652-22-seanjc@google.com>
Organization: Microsoft
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Feb 2021 12:47:46 -0800
Sean Christopherson <seanjc@google.com> wrote:

> Tweak the MMU_WARN that guards against weirdness when querying A/D
> status to fire on a !MMU_PRESENT SPTE, as opposed to a MMIO SPTE.
> Attempting to query A/D status on any kind of !MMU_PRESENT SPTE, MMIO
> or otherwise, indicates a KVM bug.  Case in point, several now-fixed
> bugs were identified by enabling this new WARN.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

You made the 1.000.000th commit, congrats!

$ git log --oneline --reverse |sed '1000000!d'
8f366ae6d8c5 KVM: x86/mmu: Tweak auditing WARN for A/D bits to !PRESENT (was MMIO)

Cheers,
-- 
per aspera ad upstream
