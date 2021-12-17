Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DFF479467
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 19:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240491AbhLQSwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 13:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234252AbhLQSwx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 13:52:53 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306C0C061574;
        Fri, 17 Dec 2021 10:52:53 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639767171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oEST+WkzZcW7J9JF+61X38oRv9DPDlSb+N6Bemo0zx0=;
        b=2BasIeVk3Py86ZDAO93yIs4oqN0uCPvabejBP26NqnKDRrERmKX0eM3Q8rEaQVbom9l8HI
        NdxQRvKJr3mB3fOC74XHSw7UV+2PtfrNSpWzOvc7CgAr5CpGs7XOpLemCuFuFwu4bboWtl
        5p/o7afN5kLgRUfxVHZ542hxb/QKVFGr5foYw1ez0ADh4oODC7saLW83JKG/tZB9zbJRzO
        4+PCy38MiHgLoNmcTN3T9O0KuFAI9jqahRyhJoTsYXVXVXYhVewAmVxRFIkEsroP3gCicD
        2UjXs9n6IkJeDRTZ7hfKh7JBVWmf0uxUf+KI4Hsfi8FY3Pnj0FDFDDYLNzEDjA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639767171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oEST+WkzZcW7J9JF+61X38oRv9DPDlSb+N6Bemo0zx0=;
        b=EG+RRv6LRXsq2pUwMviyK2O+1eoRFX3f9Mq4HKAK9ClYlcGWMYSk7EyWtOywEb+R7qcImy
        +sLM+zBcFeT1FTDA==
To:     Jing Liu <jing2.liu@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: Re: [PATCH v2 00/23] AMX Support in KVM
In-Reply-To: <20211217153003.1719189-1-jing2.liu@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
Date:   Fri, 17 Dec 2021 19:52:51 +0100
Message-ID: <87tuf7awsc.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 17 2021 at 07:29, Jing Liu wrote:
> This version is not intended for acceptance. But giving many moving
> pieces in v1 review it might be good to have an alignment on what 
> we have improved now.
>
> It's highly appreciated if you can help take a quick look and let
> us know any new issue before your holiday. We will continue working 
> on closing remaining TODOs and try to have a complete version ready 
> when you are back. :)

From my side this looks good. I let Paolo comment on the KVM bits.

Thanks

        tglx

