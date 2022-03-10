Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F934D3F91
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 04:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239116AbiCJDNu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 22:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238713AbiCJDNr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 22:13:47 -0500
X-Greylist: delayed 60282 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Mar 2022 19:12:45 PST
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488DE13CD3;
        Wed,  9 Mar 2022 19:12:43 -0800 (PST)
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4KDYyy1glXz8QrkZ;
        Thu, 10 Mar 2022 11:12:42 +0800 (CST)
Received: from szxlzmapp02.zte.com.cn ([10.5.231.79])
        by mse-fl1.zte.com.cn with SMTP id 22A3CRSw048622;
        Thu, 10 Mar 2022 11:12:27 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from mapi (szxlzmapp07[null])
        by mapi (Zmail) with MAPI id mid14;
        Thu, 10 Mar 2022 11:12:27 +0800 (CST)
Date:   Thu, 10 Mar 2022 11:12:27 +0800 (CST)
X-Zmail-TransId: 2b0962296c9be96c0d9a
X-Mailer: Zmail v1.0
Message-ID: <202203101112273271527@zte.com.cn>
In-Reply-To: <3b1de531-a2b8-2638-0c8f-fc23fdf5473c@redhat.com>
References: 202203091827565144689@zte.com.cn,3b1de531-a2b8-2638-0c8f-fc23fdf5473c@redhat.com
Mime-Version: 1.0
From:   <wang.yi59@zte.com.cn>
To:     <pbonzini@redhat.com>
Cc:     <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xue.zhihong@zte.com.cn>, <up2wing@gmail.com>,
        <wang.liang82@zte.com.cn>, <liu.yi24@zte.com.cn>
Subject: =?UTF-8?B?UmU6W1BBVENIXSBLVk06IFNWTTogZml4IHBhbmljIG9uIG91dC1vZi1ib3VuZHMgZ3Vlc3QgSVJR?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 22A3CRSw048622
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.137.novalocal with ID 62296CAA.000 by FangMail milter!
X-FangMail-Envelope: 1646881962/4KDYyy1glXz8QrkZ/62296CAA.000/10.30.14.238/[10.30.14.238]/mse-fl1.zte.com.cn/<wang.yi59@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 62296CAA.000/4KDYyy1glXz8QrkZ
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On 3/9/22 11:27, wang.yi59@zte.com.cn wrote:
> >> Hi, the Signed-off-by chain is wrong.  Did Yi Liu write the patch (and
> >> you are just sending it)?
> > The Signed-off-by chain is not wrong, I (Yi Wang) wrote this patch and Yi Liu
> > co-developed it.
> > 
> 
> Ok, so it should be
> 
> Co-developed-by: Yi Liu <liu.yi24@zte.com.cn>
> Signed-off-by: Yi Liu <liu.yi24@zte.com.cn>
> Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
> 
> I'll fix it myself - thanks for the quick reply!

Thanks, Paolo.

---
Best wishes
Yi Wang
