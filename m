Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5D779E20
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 03:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730762AbfG3Btv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 21:49:51 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36581 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730747AbfG3Btu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 21:49:50 -0400
Received: by mail-pl1-f196.google.com with SMTP id k8so28230918plt.3
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2019 18:49:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tb2CceiNBlcVhvjgrVkye3nXKUalzRxTgsF+cYJnxAw=;
        b=X8wfgGCEpow9JrIiEBkLkYhntY2rQmQm1S3BdGv+Mc0Ast27bPb7hS4RzJW+7aPzNY
         JKR31esUGhtDJ5xhbAdV+s4iczdR/Hg8pkkHQxXU7tcI4o1n6q9ouIDFeO7xDKg1+Xiv
         LaC+EnmVJdXh6T+bo+Y+k8Jwv1ZX59PhFTxNVnb/BSljJBilDu1QeMxg0WwzbcE9jN6N
         9anEsPCdHG0Lieu/eo9TP+Vj2SBu4Kn7eIUXCrjI83hx1GBPDVUac0ZWCTwbTwbsY/Oq
         WggocKvSLJIJfCCqtGriRoV8C6v/a6UpfsCiBixcYFCtlgG9QslvewKDGFFSU2qOIf3V
         4wQQ==
X-Gm-Message-State: APjAAAWMXnn17lzntrkgUMXjmcOC124wK8EK9sFPdUBDlhHoyrvmkCsf
        UEEKFq4O3KTq7rYNQtNG9xwmfA==
X-Google-Smtp-Source: APXvYqzA84Qg9Zvu8mx/qYRERVUM/8HHq5uWnG6VJooOFKr5pRiC/wRgWpEbIT1ENNWMc7qN1xsccQ==
X-Received: by 2002:a17:902:7c90:: with SMTP id y16mr114699498pll.238.1564451390161;
        Mon, 29 Jul 2019 18:49:50 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e13sm76185684pff.45.2019.07.29.18.49.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 18:49:49 -0700 (PDT)
Date:   Tue, 30 Jul 2019 09:49:40 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Peter Xu <zhexu@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/3] KVM: X86: Trace vcpu_id for vmexit
Message-ID: <20190730014940.GD19232@xz-x1>
References: <20190729053243.9224-1-peterx@redhat.com>
 <20190729053243.9224-2-peterx@redhat.com>
 <20190729162815.GF21120@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190729162815.GF21120@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 29, 2019 at 09:28:15AM -0700, Sean Christopherson wrote:
> On Mon, Jul 29, 2019 at 01:32:41PM +0800, Peter Xu wrote:
> > It helps to pair vmenters and vmexis with multi-core systems.
> 
> Typo "vmexis".  The wording is also a bit funky.  How about:
> 
> Tracing the ID helps to pair vmenters and vmexits for guests with
> multiple vCPUs.

Sure thing.  Thanks,

-- 
Peter Xu
