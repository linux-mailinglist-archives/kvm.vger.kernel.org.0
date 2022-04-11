Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF83E4FB31B
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 06:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244318AbiDKE5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 00:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiDKE5p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 00:57:45 -0400
Received: from out0-153.mail.aliyun.com (out0-153.mail.aliyun.com [140.205.0.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4462112601;
        Sun, 10 Apr 2022 21:55:32 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047188;MF=darcy.sh@antgroup.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---.NOBzDY7_1649652927;
Received: from localhost(mailfrom:darcy.sh@antgroup.com fp:SMTPD_---.NOBzDY7_1649652927)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 11 Apr 2022 12:55:28 +0800
From:   "SU Hang" <darcy.sh@antgroup.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <bp@alien8.de>, "SU Hang" <darcy.sh@antgroup.com>,
        <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
        "Lai Jiangshan" <jiangshan.ljs@antgroup.com>,
        <jmattson@google.com>, <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
        <tglx@linutronix.de>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <x86@kernel.org>
Subject: Re: [PATCH v2 2/2] KVM: x86/mmu: Derive EPT violation RWX bits from EPTE RWX bits
Date:   Mon, 11 Apr 2022 12:55:27 +0800
Message-Id: <20220411045527.13421-1-darcy.sh@antgroup.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <Yj0NOQOYEAG+Dz7+@google.com>
References: <Yj0NOQOYEAG+Dz7+@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I sincerely apologize to you and Palo for making this mistake due to my
negligence and lack of testing. Since the patches only care about macro
substitutions and no function changes, this makes me sloppy. Now I realize my
mistake.

Ashamed Hang
