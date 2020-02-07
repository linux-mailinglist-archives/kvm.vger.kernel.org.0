Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 534A715516C
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 05:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbgBGEGB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 6 Feb 2020 23:06:01 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2944 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726674AbgBGEGB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 23:06:01 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 3670A817A9F1345D5665;
        Fri,  7 Feb 2020 12:05:37 +0800 (CST)
Received: from dggeme764-chm.china.huawei.com (10.3.19.110) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 7 Feb 2020 12:05:36 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme764-chm.china.huawei.com (10.3.19.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 7 Feb 2020 12:05:36 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Fri, 7 Feb 2020 12:05:36 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: nVMX: Fix some comment typos and coding style
Thread-Topic: [PATCH] KVM: nVMX: Fix some comment typos and coding style
Thread-Index: AdXda240t8ORXRyNe0WC/V8WZ/conQ==
Date:   Fri, 7 Feb 2020 04:05:36 +0000
Message-ID: <bc72431b89444fa3a127cf71065f71db@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi:
Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> On Thu, Feb 06, 2020 at 12:32:38PM +0100, Vitaly Kuznetsov wrote:
>> linmiaohe <linmiaohe@huawei.com> writes:
>> 
>> 
>> I have to admit that shadow MMU in KVM is not my strong side but this 
>> comment reads weird, I'd appreciate if someone could suggest a better 
>> alternative.
>
>	/* One off flag for a stupid corner case in shadow paging. */
>> 
>> >  	 */
>
>	/*
>	 * Indicates the guest is trying to write a gfn that contains one or
>	 * more of the PTEs used to translate the write itself, i.e. the access
>	 * is changing its own translation in the guest page tables.  KVM exits
>	 * to userspace if emulation of the faulting instruction fails and this
>	 * flag is set, as KVM cannot make forward progress.
>	 *
>	 * If emulation fails for a write to guest page tables, KVM unprotects
>	 * (zaps) the shadow page for the target gfn and resumes the guest to
>	 * retry the non-emulatable instruction (on hardware).  Unprotecting the
>	 * gfn doesn't allow forward progress for a self-changing access because
>	 * doing so also zaps the translation for the gfn, i.e. retrying the
>	 * instruction will hit a !PRESENT fault, which results in a new shadow
>	 * page and sends KVM back to square one.
>	 */
>> >  	bool write_fault_to_shadow_pgtable;

Thanks for your detail comment. This field confused me once.

Thanks to both for review! Will send v2.

