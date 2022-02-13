Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501634B3AAD
	for <lists+kvm@lfdr.de>; Sun, 13 Feb 2022 10:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbiBMJpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Feb 2022 04:45:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiBMJpW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Feb 2022 04:45:22 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585575C37F;
        Sun, 13 Feb 2022 01:45:15 -0800 (PST)
Received: from [192.168.0.2] (ip5f5aebcd.dynamic.kabel-deutschland.de [95.90.235.205])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id E29D361E64846;
        Sun, 13 Feb 2022 10:45:11 +0100 (CET)
Message-ID: <f63abe64-6d4f-1374-5fd3-874a34c1c22f@molgen.mpg.de>
Date:   Sun, 13 Feb 2022 10:45:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: Set environment variable `KVM` makes build fail
Content-Language: en-US
To:     Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        rcu <rcu@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
References: <d3e6a461-5b37-ecfb-d63c-d35af27f2682@molgen.mpg.de>
 <CAABZP2yOA2n-xux8uUC72vVYc14JfCawoOzp_pnTGDvY8cRSnw@mail.gmail.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <CAABZP2yOA2n-xux8uUC72vVYc14JfCawoOzp_pnTGDvY8cRSnw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Zhouyi,


Am 13.02.22 um 09:07 schrieb Zhouyi Zhou:, and

> Thank you for your trust in me.

Thank you for your help.

> I think the following patch has a good explanation of what happened ;-)
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/tools/testing/selftests/rcutorture/bin/torture.sh?id=a7d89cfb8e1269cb6d22453adba56b8d0218589f
> "The torture-test scripting's long-standing use of KVM as the
> environment variable tracking the pathname of the rcutorture directory
> now conflicts with allmodconfig builds due to the
> virt/kvm/Makefile.kvm file's use of this as a makefile variable"

Indeed. In my script I had added the remote for the rcu git archive, but 
forgot to actually fetch the objects and refs, and missed the error 
message in the output.

Sorry for the noise, though the variable name should probably 
namespaced, as at least for the name `KVM` the chance are higher (still 
very small) that it’s set in the environment.


Kind regards,

Paul
