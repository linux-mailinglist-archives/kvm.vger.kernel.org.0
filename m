Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E446B50EC62
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 01:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236770AbiDYXES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 19:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236620AbiDYXEQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 19:04:16 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5B6403C2;
        Mon, 25 Apr 2022 16:01:11 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nj7hT-0002D9-QS; Tue, 26 Apr 2022 01:00:59 +0200
Message-ID: <656aaf33-8c70-8b06-2cdc-fd2685a1348b@maciej.szmigiero.name>
Date:   Tue, 26 Apr 2022 01:00:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220423021411.784383-1-seanjc@google.com>
 <20220423021411.784383-12-seanjc@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v2 11/11] KVM: SVM: Drop support for CPUs without NRIPS
 (NextRIP Save) support
In-Reply-To: <20220423021411.784383-12-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23.04.2022 04:14, Sean Christopherson wrote:
> Drop support for CPUs without NRIPS along with the associated module
> param.  Requiring NRIPS simplifies a handful of paths in KVM, especially
> paths where KVM has to do silly things when nrips=false but supported in
> hardware as there is no way to tell the CPU _not_ to use NRIPS.
> 
> NRIPS was introduced in 2009, i.e. every AMD-based CPU released in the
> last decade should support NRIPS.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Not-signed-off-by: Sean Christopherson <seanjc@google.com>

To be honest, I think completely removing KVM support (rather than just nSVM)
for these older AMD CPUs is a bit too much.
I totally envision complaints coming after this change reaches distro kernels.

After all, even older Yonah parts remain supported on the VMX side.

Thanks,
Maciej
