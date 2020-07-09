Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD3B21971C
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 06:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgGIENn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 00:13:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:60228 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgGIENn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 00:13:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 08AB6AF1A;
        Thu,  9 Jul 2020 04:13:42 +0000 (UTC)
Subject: Re: [patch V2 7/7] x86/kvm/vmx: Use native read/write_cr2()
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20200708195153.746357686@linutronix.de>
 <20200708195322.344731916@linutronix.de>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <6a465bb4-1e2e-7ad5-4842-00b07edd10cd@suse.com>
Date:   Thu, 9 Jul 2020 06:13:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200708195322.344731916@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08.07.20 21:52, Thomas Gleixner wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> read/write_cr2() go throuh the paravirt XXL indirection, but nested VMX in
> a XEN_PV guest is not supported.
> 
> Use the native variants.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Reviewed-by: Juergen Gross <jgross@suse.com>


Juergen
