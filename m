Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C5F48A612
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 04:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243706AbiAKDIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 22:08:52 -0500
Received: from mga17.intel.com ([192.55.52.151]:21785 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231326AbiAKDIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 22:08:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641870531; x=1673406531;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RMI1RbSj7Nf4sUd+ZkqJlzpz1NnGp0vcp4SZw2pUIQ4=;
  b=RSpicIQe+l5aR4AIzuC7Z2G+QfPrxtJX2eUH1qOY1k3rT6EwxePehKGR
   VcpNjVzxpM5q5aq+g1/U+HYQqByxWC+ikXsREKKcm9P/6HvQqxqx0xc5d
   80ca176wYGw+0I6CvsxB0yKyYcqGAU4RdQmqiHxfen2mMynEEZxRt09pF
   aL3kt1wUbPDK0911UGkoiibrke7aenkr/OkFxdj8DXwwkloDxtatHulJO
   Dk1LhvrNCn41twWI7BU27Y1Qm3tlRLuHgQRLEaiwKDsKIIah4gCa6JXB5
   dPYZynFvjofaS3G0BhWJm23OtMYQPbWhwzVzw2x45xSEsIW38zY7Y8isc
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="224085784"
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="224085784"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 19:08:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="622907157"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.105])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 19:08:40 -0800
Date:   Tue, 11 Jan 2022 11:19:34 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, kevin.tian@intel.com,
        tglx@linutronix.de, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 3/6] KVM: Remove opaque from
 kvm_arch_check_processor_compat
Message-ID: <20220111031933.GB2175@gao-cwp>
References: <20211227081515.2088920-1-chao.gao@intel.com>
 <20211227081515.2088920-4-chao.gao@intel.com>
 <Ydy8BCfE0jhJd5uE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ydy8BCfE0jhJd5uE@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 11:06:44PM +0000, Sean Christopherson wrote:
>On Mon, Dec 27, 2021, Chao Gao wrote:
>> No arch implementation uses this opaque now.
>
>Except for the RISC-V part, this can be a pure revert of commit b99040853738 ("KVM:
>Pass kvm_init()'s opaque param to additional arch funcs").  I think it makes sense
>to process it as a revert, with a short blurb in the changelog to note that RISC-V
>is manually modified as RISC-V support came along in the interim.

commit b99040853738 adds opaque param to kvm_arch_hardware_setup(), which isn't
reverted in this patch. I.e., this patch is a partial revert of b99040853738
plus manual changes to RISC-V. Given that, "process it as a revert" means
clearly say in changelog that this commit contains a partial revert of commit
b99040853738 ("KVM: Pass kvm_init()'s opaque param to additional arch funcs").

Right?
