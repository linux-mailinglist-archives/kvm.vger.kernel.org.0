Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE8C678C56
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 00:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbjAWX56 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 18:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbjAWX5z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 18:57:55 -0500
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F421A2706
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 15:57:46 -0800 (PST)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1pK6h3-0002mb-HH; Tue, 24 Jan 2023 00:57:41 +0100
Message-ID: <352ba836-f75a-9597-436a-ed42f4186dd3@maciej.szmigiero.name>
Date:   Tue, 24 Jan 2023 00:57:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 2/2] KVM: selftests: Assign guest page size in sync area
 early in memslot_perf_test
Content-Language: en-US, pl-PL
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org,
        maz@kernel.org, oliver.upton@linux.dev, seanjc@google.com,
        shan.gavin@gmail.com
References: <20230118092133.320003-1-gshan@redhat.com>
 <20230118092133.320003-3-gshan@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
In-Reply-To: <20230118092133.320003-3-gshan@redhat.com>
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
> The guest page size in the synchronization area is needed by all test
> cases. So it's reasonable to set it in the unified preparation function
> (prepare_vm()).
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---

Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Thanks,
Maciej

