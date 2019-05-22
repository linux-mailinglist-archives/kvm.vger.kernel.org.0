Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D64F261BB
	for <lists+kvm@lfdr.de>; Wed, 22 May 2019 12:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbfEVK1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 06:27:11 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34668 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728602AbfEVK1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 06:27:11 -0400
Received: by mail-wm1-f67.google.com with SMTP id j187so4369281wma.1
        for <kvm@vger.kernel.org>; Wed, 22 May 2019 03:27:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YxQpOSS3n4cm4WBavduVAfTQcURqnSOE6/a2H2tAcYc=;
        b=Qui2M8Y8fH9HBHly7Ak55OYnOcgGGB4nR9TzxTSIfWu6tgw2CoViCn2TM/im1KlVmA
         XEWc3OF8ZieHR2MBmAicao7QtxlNRLkY2foHVvhsKLpdoBtKajQoTVF6M8zEBKkukUak
         RnrblpBYD7YPTeThSw4LO9r5LyrvWw79YqZoETtM4yqJbqAIEkxIcx8Kq1uSBkk6W6Yn
         JcCF92GUc14hFLAKHtkE2oT3pyaXTiNHpEsIJCgq2g9nqAQd9HgXpWmL0WgV71Hq2Z98
         P9pnINQBJ+FPEqP+qrunZNUoBPR1OlRtoU11XocHMNRAbgLMlqjc+tACOkC6ztvGhlmE
         kqPA==
X-Gm-Message-State: APjAAAW4AsHxdhmeD7DeNoYC+gYANFLVQRTYve6gP/rPUAwbbvtm/JDa
        dW13Z79Pf+IdEbFT+GKL//GA/ELnJ54=
X-Google-Smtp-Source: APXvYqxzpKYu4eisAOH6Jw4h/EAZeV7uDO25xNniPd/davQJ6YKI9kVcvW4y6Ds9KvF3c6X1jSOIgA==
X-Received: by 2002:a1c:6783:: with SMTP id b125mr6806916wmc.41.1558520828809;
        Wed, 22 May 2019 03:27:08 -0700 (PDT)
Received: from [10.32.181.147] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id i25sm6813421wmb.46.2019.05.22.03.27.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 03:27:08 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: x86/pmu: do not mask the value that is written
 to fixed PMUs
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1558366951-19259-1-git-send-email-pbonzini@redhat.com>
 <1558366951-19259-3-git-send-email-pbonzini@redhat.com>
 <20190520190158.GE28482@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c0db3010-96a7-c58e-ee08-a5703e40b3f4@redhat.com>
Date:   Wed, 22 May 2019 12:27:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520190158.GE28482@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/19 21:01, Sean Christopherson wrote:
> Would it make sense to inject a #GP if the guest attempts to set bits that
> are reserved to be zero, e.g. based on guest CPUID?

Yes, though it was not clear from the SDM quote that hardware enforces
that (I guess the hint is that they "must" be written as zero rather
than "should").

I'll include this patch in my next pull request with fixed commit
message, and do the #GP change separately.

Paolo
