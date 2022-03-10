Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02F24D3F99
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 04:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239186AbiCJDSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 22:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236766AbiCJDS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 22:18:29 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231AC37BD0;
        Wed,  9 Mar 2022 19:17:26 -0800 (PST)
Received: from mse-fl2.zte.com.cn (unknown [10.30.14.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4KDZ4N42zsz7jZws;
        Thu, 10 Mar 2022 11:17:24 +0800 (CST)
Received: from szxlzmapp06.zte.com.cn ([10.5.230.252])
        by mse-fl2.zte.com.cn with SMTP id 22A3HLHS017184;
        Thu, 10 Mar 2022 11:17:21 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from mapi (szxlzmapp07[null])
        by mapi (Zmail) with MAPI id mid14;
        Thu, 10 Mar 2022 11:17:21 +0800 (CST)
Date:   Thu, 10 Mar 2022 11:17:21 +0800 (CST)
X-Zmail-TransId: 2b0962296dc1c36cdb2d
X-Mailer: Zmail v1.0
Message-ID: <202203101117214141800@zte.com.cn>
In-Reply-To: <Yiia0S+pDNHlAhSE@zn.tnic>
References: 2bd92846-381b-f083-754a-89dfcdccc90c@redhat.com,202203091827565144689@zte.com.cn,Yiia0S+pDNHlAhSE@zn.tnic
Mime-Version: 1.0
From:   <wang.yi59@zte.com.cn>
To:     <bp@alien8.de>
Cc:     <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>,
        <dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xue.zhihong@zte.com.cn>, <up2wing@gmail.com>,
        <wang.liang82@zte.com.cn>, <liu.yi24@zte.com.cn>
Subject: =?UTF-8?B?UmU6W1BBVENIXSBLVk06IFNWTTogZml4IHBhbmljIG9uIG91dC1vZi1ib3VuZHMgZ3Vlc3QgSVJR?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 22A3HLHS017184
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.138.novalocal with ID 62296DC4.000 by FangMail milter!
X-FangMail-Envelope: 1646882244/4KDZ4N42zsz7jZws/62296DC4.000/10.30.14.239/[10.30.14.239]/mse-fl2.zte.com.cn/<wang.yi59@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 62296DC4.000/4KDZ4N42zsz7jZws
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Wed, Mar 09, 2022 at 06:27:56PM +0800, wang.yi59@zte.com.cn wrote:
> > The Signed-off-by chain is not wrong, I (Yi Wang) wrote this patch and Yi Liu
> > co-developed it.
> 
> What to do in such cases is well documented. For the future, make sure
> you look at
> 
> Documentation/process/submitting-patches.rst

Thanks, Boris.

I will go over the doc and pay more attention on the patch format in the future.

---
Best wishes
Yi Wang
