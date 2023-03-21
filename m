Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB20A6C30A0
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 12:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjCULo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 07:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjCULoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 07:44:54 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E9B4AD0D;
        Tue, 21 Mar 2023 04:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=YcT7PB4t/7cxWmWebhwcKuntX/iD6KstxpOgiem5Qec=; b=FvJGN+kmQA7SRR9WYaqpOAtobe
        mB14sikwTGZkTFG5mDCfgulb/vv9o3OblHJ/thlob5SvlhTY3nVNc5cHGVfNHHckcELI/U97Yrm9z
        TIKDYWiWZ1Ek+iWsvouWKS6JqIWkaueeyrjmvWXVqX5XuAFMkMJkJhzSJcEpUJ8DJgwzbXJLInJsx
        aTQltg0hczX4wjjuuyFQE0UBQThYJ1CuKMpUgmCXnc3mBytGvXCMvZ0q+gSPPOn9+wbjOct32ti+q
        ZFIKNfKCDzTLKk+sxfi5jtHV7r5HTWRI//L7/A7o1uY6+7mYa7hDjtvgtauJ1oMQ28Z948zX+8nno
        knUDDv/Q==;
Received: from [193.117.214.244] (helo=[127.0.0.1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1peaPI-004FA6-0w;
        Tue, 21 Mar 2023 11:44:00 +0000
Date:   Tue, 21 Mar 2023 11:43:58 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Borislav Petkov <bp@alien8.de>,
        Usama Arif <usama.arif@bytedance.com>
CC:     tglx@linutronix.de, kim.phillips@amd.com, brgerst@gmail.com,
        piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com, David Woodhouse <dwmw@amazon.co.uk>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v15_04/12=5D_x86/smpboot=3A_Referenc?= =?US-ASCII?Q?e_count_on_smpboot=5Fsetup=5Fwarm=5Freset=5Fvector=28=29?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20230321114115.GGZBmX270DI11eXvM+@fat_crate.local>
References: <20230316222109.1940300-1-usama.arif@bytedance.com> <20230316222109.1940300-5-usama.arif@bytedance.com> <20230321114115.GGZBmX270DI11eXvM+@fat_crate.local>
Message-ID: <8D6C2EC1-7B53-410B-84C3-A1991A71DEB7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 21 March 2023 11:41:15 GMT, Borislav Petkov <bp@alien8=2Ede> wrote:
>On Thu, Mar 16, 2023 at 10:21:01PM +0000, Usama Arif wrote:
>> From: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>>=20
>> When bringing up a secondary CPU from do_boot_cpu(), the warm reset fla=
g
>> is set in CMOS and the starting IP for the trampoline written inside th=
e
>> BDA at 0x467=2E Once the CPU is running, the CMOS flag is unset and the
>> value in the BDA cleared=2E
>>=20
>> To allow for parallel bringup of CPUs, add a reference count to track t=
he
>> number of CPUs currently bring brought up, and clear the state only whe=
n
>
>s/bring //

"being", I think=2E
