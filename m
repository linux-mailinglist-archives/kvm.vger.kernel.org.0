Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACB046EC46
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 16:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240565AbhLIPyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 10:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236224AbhLIPyw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 10:54:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C766C061746;
        Thu,  9 Dec 2021 07:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sxN5P3hkFS/XUVYb/EVx/cfMZDurUrLj730ZB7TF0fg=; b=YOfmjicmYYYyr4DiOMgP2M4DOb
        KTzMQqeZC3Iz0Pz5uIv3wvUy86oupcmELt67omzsG/v9mjITv8HNiZ6RqW0REH42eVUkuq4DCQtpO
        JlXMwfc1i9jGUM6VN5lV4t42m2CzCt4B1hlRukxDXCz+mraA5M1IVeyFKIG6+H4Q58FIB3oN+tdLe
        dTV0cYt9juefmVW4rgvlAsXE479p6ha2UfXsBAFaJe89VDxBNV4MUy/MuDvSpNd0axjalbkc5ay9d
        WYR2btrt4GoVM4UCD6ZW3hOKuRjehIOTpOclYLr2dLmIO/qg+ieq9Xdfl4+XpOfIfT+NU8X8AkA9k
        42A+TATQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvLh9-009U5c-6c; Thu, 09 Dec 2021 15:50:56 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2A68330026A;
        Thu,  9 Dec 2021 16:50:55 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0BA3C20181C79; Thu,  9 Dec 2021 16:50:55 +0100 (CET)
Date:   Thu, 9 Dec 2021 16:50:55 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
Subject: Re: [PATCH 09/11] x86/boot: Support parallel startup of secondary
 CPUs
Message-ID: <YbIl35L+8lH6RzE1@hirez.programming.kicks-ass.net>
References: <20211209150938.3518-1-dwmw2@infradead.org>
 <20211209150938.3518-10-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209150938.3518-10-dwmw2@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 09, 2021 at 03:09:36PM +0000, David Woodhouse wrote:

> +	lock
> +	btrl	$0, (%rax)


> +	lock
> +	btsw	$0, tr_lock

I find that really weird style, but whatever..
