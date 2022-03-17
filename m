Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEB84DC273
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 10:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbiCQJRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 05:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbiCQJRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 05:17:17 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0251D2078;
        Thu, 17 Mar 2022 02:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647508561; x=1679044561;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AgYkRzO8ksOYyWWAS/gpvfK0lt7Rzm9dkVzVmq0l0/w=;
  b=VtTiW6qwvMVvGT+q7WlAVJxpMqyb8DjRMDZ5g7wROL6sSCX/r8WbXc/1
   PHnMlEIyc5lTEcliKyAYq6OvbxLQEokq/bMMo3Vzammac5b9TglYxPVg7
   mhjfpy3GiDdaPfzsRrKZrVaPUxPXBxh0maAq3PgrzxBgFaqUUFxaBoDY7
   YHvyp5IHuud28MqKHAv+PdqGqQXkBnoWR64BJIhOyUYVXNjUYVaRb0/9U
   zRm9h9THmnerguXJ7KbVw+pYUYqE+pM/xVcW3vB0VNrmIiKVrVpVPGwa+
   ytHiUEjVQiCM2bKELvjfIG/sjjX5ZZ+OO6GMYSViVS3E6wTwPknPVVeer
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="236767996"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="236767996"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 02:15:58 -0700
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="557852602"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 02:15:44 -0700
Date:   Thu, 17 Mar 2022 17:15:41 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     seanjc@google.com, maz@kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, kevin.tian@intel.com, tglx@linutronix.de
Cc:     Albert Ou <aou@eecs.berkeley.edu>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Heiko Carstens <hca@linux.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        James Morse <james.morse@arm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Jia He <justin.he@arm.com>, Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Garry <john.garry@huawei.com>,
        Juergen Gross <jgross@suse.com>, kvmarm@lists.cs.columbia.edu,
        kvm-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nathan Chancellor <nathan@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Mackerras <paulus@samba.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Qi Liu <liuqi115@huawei.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Will Deacon <will@kernel.org>, x86@kernel.org
Subject: Re: [PATCH v4 0/6] Improve KVM's interaction with CPU hotplug
Message-ID: <20220317091539.GA7257@gao-cwp>
References: <20220216031528.92558-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216031528.92558-1-chao.gao@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping. Anyone can help to review this series (particularly patch 3-5)?

FYI, Sean gave his Reviewed-by to patch 1,2,5 and 6.
