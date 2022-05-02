Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398EE5172F8
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 17:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385956AbiEBPnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 11:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376413AbiEBPnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 11:43:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44C5B13E25
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 08:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651505965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZF1XCSE9BpLbLGqd+aMdN/ixk8WqlQNETxHiBvcFAEo=;
        b=bRaZUybwSsrRmaGNaYOdh2M76fjqS3XjiyGMRcOQAUz30DY0eOuk1fbSXLfKRDRHuFyM8T
        VCtN9VwxSMPTYQJ14ChBJLbk4N0zbcYLzhBpwNKGnzmFESdTnOtbIpEIu5re3CrifxC2Mx
        e4pIKfpJN6L0XLN3gR9ggZI3703vjA4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-5DVt4lb7NBipGrvkCDprJQ-1; Mon, 02 May 2022 11:39:24 -0400
X-MC-Unique: 5DVt4lb7NBipGrvkCDprJQ-1
Received: by mail-ed1-f69.google.com with SMTP id ee56-20020a056402293800b00425b0f5b9c6so8832773edb.9
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 08:39:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZF1XCSE9BpLbLGqd+aMdN/ixk8WqlQNETxHiBvcFAEo=;
        b=IduuQ6X4+po/C/fr4IxPqJtfo5PmTeuvL977DI7txhrvcmGVk5LsewMDEdlTYEL8Ip
         XidELzAiw8uj+pw8k/u6Tu5tV5s/iVjZVz7dA9k9NMECYrhXLesWfx+Mr97G5AeydYuz
         ky/mMKqVpqz7ufmjt1PcwX369ol3ml4c6buCCWDfnLtUzbMjsUKf12FgUtDPb3WlueWp
         LymNHZjX3Rs889y+rJiB7gGsuajFSnxbIh7iX7FS0aAj7Xj/af7PzbHBqcYZrIdZbsfS
         tsrgcqr96EMBzvMMcglfU7/gbCAa9y1/E/yXg/qXtcAaCycgmRKnacM0kY48+JpsnVfW
         uAFw==
X-Gm-Message-State: AOAM530AFHZWbAJbjK3pMthur/DUGKwqhy79hjI976y81Y+3m8kJY//P
        cevNeqiPiRaSihFL8rB/mBaMF5SIaX13L9EG9kyusl6sLucShUNULNEu6/kxlwd1KDIH12geiAX
        GMQSpklnG0Ntz
X-Received: by 2002:a05:6402:e9f:b0:41c:df21:b113 with SMTP id h31-20020a0564020e9f00b0041cdf21b113mr14128534eda.217.1651505963159;
        Mon, 02 May 2022 08:39:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNSW0QoKFTZ8zlcqWylcf7sv1LZgw1iIhvcn7gOPBPlprZOO+eArCO5O1mIvjKJ5ZlcDfxwA==
X-Received: by 2002:a05:6402:e9f:b0:41c:df21:b113 with SMTP id h31-20020a0564020e9f00b0041cdf21b113mr14128524eda.217.1651505962959;
        Mon, 02 May 2022 08:39:22 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id ig11-20020a1709072e0b00b006f3ef214e2dsm3839256ejc.147.2022.05.02.08.39.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 May 2022 08:39:22 -0700 (PDT)
Message-ID: <47855c4c-dc85-3ee8-b903-4acf0b94e4a9@redhat.com>
Date:   Mon, 2 May 2022 17:39:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [GIT PULL 0/1] KVM: s390: Fix lockdep issue in vm memop
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
References: <20220502153053.6460-1-borntraeger@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220502153053.6460-1-borntraeger@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/2/22 17:30, Christian Borntraeger wrote:
> Paolo,
> 
> one patch that is sitting already too long in my tree (sorry, was out of
> office some days).

Hi Christian,

at this point I don't have much waiting for 5.18.  Feel free to send it 
through the s390 tree.

Paolo

> The following changes since commit 3bcc372c9865bec3ab9bfcf30b2426cf68bc18af:
> 
>    KVM: s390: selftests: Add error memop tests (2022-03-14 16:12:27 +0100)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.18-1
> 
> for you to fetch changes up to 4aa5ac75bf79cbbc46369163eb2e3addbff0d434:
> 
>    KVM: s390: Fix lockdep issue in vm memop (2022-03-23 10:41:04 +0100)
> 
> ----------------------------------------------------------------
> KVM: s390: fix lockdep warning in new MEMOP call
> 
> ----------------------------------------------------------------
> Janis Schoetterl-Glausch (1):
>        KVM: s390: Fix lockdep issue in vm memop
> 
>   arch/s390/kvm/kvm-s390.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 

