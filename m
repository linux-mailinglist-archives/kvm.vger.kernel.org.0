Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED51678C53
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 00:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbjAWX5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 18:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjAWX5S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 18:57:18 -0500
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283DA36FFE
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 15:57:10 -0800 (PST)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1pK6gP-0002m1-GC; Tue, 24 Jan 2023 00:57:01 +0100
Message-ID: <b5a6f902-2d43-a7d6-5840-669760b6c9d7@maciej.szmigiero.name>
Date:   Tue, 24 Jan 2023 00:56:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US, pl-PL
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org,
        maz@kernel.org, oliver.upton@linux.dev, seanjc@google.com,
        shan.gavin@gmail.com
References: <20230118092133.320003-1-gshan@redhat.com>
 <20230118092133.320003-2-gshan@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 1/2] KVM: selftests: Remove duplicate VM in
 memslot_perf_test
In-Reply-To: <20230118092133.320003-2-gshan@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18.01.2023 10:21, Gavin Shan wrote:
> There are two VMs created in prepare_vm(), which isn't necessary.
> To remove the second created and unnecessary VM.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>

It's weird that we ended with two __vm_create_with_one_vcpu() calls,
it looks like the second one was accidentally (re-)introduced during
'kvmarm-6.2' merge, so maybe?:
Fixes: eb5618911af0 ("Merge tag 'kvmarm-6.2' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD")

Anyway, thanks for spotting this:
Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Thanks,
Maciej

