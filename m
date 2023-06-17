Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08C2734350
	for <lists+kvm@lfdr.de>; Sat, 17 Jun 2023 21:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbjFQT1j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Jun 2023 15:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbjFQT1i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Jun 2023 15:27:38 -0400
X-Greylist: delayed 107823 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 17 Jun 2023 12:27:37 PDT
Received: from MTA-09-4.privateemail.com (mta-09-4.privateemail.com [198.54.127.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B44819AF;
        Sat, 17 Jun 2023 12:27:37 -0700 (PDT)
Received: from mta-09.privateemail.com (localhost [127.0.0.1])
        by mta-09.privateemail.com (Postfix) with ESMTP id B926C18000AE;
        Sat, 17 Jun 2023 15:27:36 -0400 (EDT)
Received: from [192.168.2.177] (bras-base-toroon4332w-grc-19-174-93-80-116.dsl.bell.ca [174.93.80.116])
        by mta-09.privateemail.com (Postfix) with ESMTPA id A3C4E18000AA;
        Sat, 17 Jun 2023 15:27:32 -0400 (EDT)
Date:   Sat, 17 Jun 2023 15:27:25 -0400
From:   Hamza Mahfooz <someguy@effective-light.com>
Subject: Re: KVM page-fault on Kernel 6.3.8
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, regressions@lists.linux.dev,
        linux-kernel@vger.kernel.org
Message-Id: <PPWEWR.10XLY20A3VQ43@effective-light.com>
In-Reply-To: <ZIz3aPL3K6ZagyJ2@google.com>
References: <L2ZBWR.TERFR10NPZ281@effective-light.com>
        <ZIz3aPL3K6ZagyJ2@google.com>
X-Mailer: geary/43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
X-Virus-Scanned: ClamAV using ClamSMTP
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Fri, Jun 16 2023 at 04:59:36 PM -07:00:00, Sean Christopherson 
<seanjc@google.com> wrote:
> What makes you think this is KVM related?  I don't see anything KVM 
> related in

Well, it corresponds a QEMU crash.

> the splat.  The !PRESENT #PF is coming from aio_read(), not from KVM. 
>  The
> ?kvm_arch_vcpu_put line is just mispeculation from the unwinder.


