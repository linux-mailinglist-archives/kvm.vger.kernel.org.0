Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D32B2E1A11
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 09:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbgLWIg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Dec 2020 03:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727744AbgLWIg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Dec 2020 03:36:28 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D480C0613D3
        for <kvm@vger.kernel.org>; Wed, 23 Dec 2020 00:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wl/+7sBmp7Ybu/aCWQsO+cYmX+3JnfDT+1cSTdm/e40=; b=FJ2b25cKaLORJ++J+0aDC5D6iI
        wRX18pc3OqS9Wf3N4GXxT3nlgN8sxzhonjkfKJCVpEz3No8L8wK2BzSORUqZRzraONkGHt0SQoR+B
        dryptN9Or0Vz6vTToeUlvnu12Mxwl5xkkUABCCa8DF12Ed2rNVDpqLpBNGsDETmrDxUjZR1bRmxsU
        GyHtAeRsCJPHjCfn1NqOUWDsquPizLJsOR/zIbc4spO2Ri2P9/LOqytjsEQWhM3y2iZozPNM/TFN5
        3AaZl9JKBbDwMxgSVF5N22IxVkYo80FuE+2HJhL5GaUh9BmteKyh+iLCACsTgwuv9/IsipYvPM0Sm
        USV0bjIQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1krzcY-0007Um-EL; Wed, 23 Dec 2020 08:35:46 +0000
Date:   Wed, 23 Dec 2020 08:35:46 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
Subject: Re: [PATCH v3 02/17] KVM: x86/xen: fix Xen hypercall page msr
 handling
Message-ID: <20201223083546.GB27350@infradead.org>
References: <20201214083905.2017260-1-dwmw2@infradead.org>
 <20201214083905.2017260-3-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214083905.2017260-3-dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +	if (msr && (msr == vcpu->kvm->arch.xen_hvm_config.msr))
> +		return xen_hvm_config(vcpu, data);

Nit: no need for the inner braces.
