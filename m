Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63108720D4B
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 04:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236994AbjFCC1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 22:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235954AbjFCC1l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 22:27:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE84DE41;
        Fri,  2 Jun 2023 19:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=It052pGmMOChbkHC/frt/IYIkwgCKd1d9bqeq2VQcNA=; b=mlAK7UprlDcOWP/2iYNJyHnj1q
        4gzstn/vBBIAUUEEeCNwsH5nad0id8R6cN34ZtIpXYLiwW8y9w+C6Bj7xBmlbOJ0xLGMbSaMiwLoQ
        WWNqoCPXpjhMrmJSxhkiT1gIjiZxVBTET7hqNlnxd86ThNmb6SETSeksoqETe15VBSx4Bt+640zbJ
        eScMEDs1rHBBvn/SjGVX3bQ76MMLJYFMBGkWdI74L67dLrmHsrRYqGD29G+NL7+ZSJeJmSU3NlC/2
        NROwGCggaLwKraV4DaagUF+keJahhkJ8jD9/fRWaGepgmZQtsoSpPcxj/0GT910IwVo5mob6y10li
        CLBUGIzg==;
Received: from [2601:1c2:980:9ec0::2764]
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q5GzT-008Y1d-01;
        Sat, 03 Jun 2023 02:27:39 +0000
Message-ID: <1f315a3d-1ded-1116-641c-c00ddbd825de@infradead.org>
Date:   Fri, 2 Jun 2023 19:27:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2] KVM: MAINTAINERS: note that linux-kvm.org isn't
 current
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org
References: <20230525153204.27960-1-rdunlap@infradead.org>
 <ZHqSYbYscprsU2qT@google.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <ZHqSYbYscprsU2qT@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/2/23 18:07, Sean Christopherson wrote:
> On Thu, May 25, 2023, Randy Dunlap wrote:
>> www.linux-kvm.org is not kept current. It contains antiquated
>> and historical information. Don't send people to it for current
>> information on KVM.
> 
> It's definitely stale, though unless Red Hat (presumed hoster) plans on decomissioning
> the site, I'd prefer to keep the reference and instead improve the site.  We (Google)
> are planning on committing resources to update KVM documentation that doesn't belong
> in the kernel itself, and updating www.linux-kvm.org instead of creating something new
> seems like a no-brainer.  I can't promise an updates will happen super quickly, but I
> will do what I can to make 'em happen sooner than later.

Thanks for the reply, Sean.
I agree with your preferred plans and look forward to seeing them begin. :)

> Paolo?

cheers.
-- 
~Randy
