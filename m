Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB334F9AA6
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 18:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbiDHQdc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 12:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbiDHQd3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 12:33:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9311F1C945E
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 09:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649435483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ezLScb0qdXlLkCxr8k3PZJ3/cAq1WRV512yu5EznY7Q=;
        b=OFu/AgnAEWAwchySWkEKtuQTooL7PJmguDAu6EJh03JTUoclVE31DvvdS25xbD+F/PnpLl
        ezM6hN4GLCj1LBHkBs1SnMNJrmrFAM8GhPYhKDWb95/sUD+SLqzeDb8ZxDhK0NBMbQteIa
        EahUTbtbuD88pau5IH1AxFzb+2duLH4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-VuX8ryAZPC6EHGZ9qnu78w-1; Fri, 08 Apr 2022 12:31:22 -0400
X-MC-Unique: VuX8ryAZPC6EHGZ9qnu78w-1
Received: by mail-wm1-f71.google.com with SMTP id i6-20020a05600c354600b0038be262d9d9so6162457wmq.8
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 09:31:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ezLScb0qdXlLkCxr8k3PZJ3/cAq1WRV512yu5EznY7Q=;
        b=eadNGN2KvxRjv0EFWN+WjV3f6eAv8RymNw+cVkOqV6zX+W5QFuInI3yK4H1sECeXuk
         mkQdoeWD10Oz2eQs3IpreNMCiAt55HrJW3GQqjtkkziZqhQkWcG7zZ3OYndXsXw7eA+y
         FfqgMCwfDWMYFWy6GppO0mIfel9LVdw6F6cmD1gB76LqNoQyJjb35aY9DiUeF6VcFMeA
         s9655iUY6jX1ZvXeDQkxte02xzTSx2Y/S0cYYn4X+zAczGbDRRDilSTiGeEkE90wRpf0
         g8GA/HhobMEYq+EGRVPTpSA0EaSw/rsIUBpXC400cVfaIxnwYPuibWH0chc+nBFMJzdV
         uIlw==
X-Gm-Message-State: AOAM531kSy4XAuySuBAa87dqHNmBqVn29MJVG2LNlp23+CyyFSWRQ3BS
        QukpaIHnGGatllmnJDi67he8yP2Xq53ie6A5WNWXX7LEf6W7fIw7NyG6ojX/3JMa//ak7zZByRI
        rU3T24idY+Czb
X-Received: by 2002:a5d:548e:0:b0:206:cdc:ff90 with SMTP id h14-20020a5d548e000000b002060cdcff90mr15013828wrv.629.1649435481316;
        Fri, 08 Apr 2022 09:31:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCB5NscNj/iZkhXNq3pILYqo7/vfybBBnq7QfRmjpblGzXeWKUQmZgNePGg763G/vT+dXKDg==
X-Received: by 2002:a5d:548e:0:b0:206:cdc:ff90 with SMTP id h14-20020a5d548e000000b002060cdcff90mr15013816wrv.629.1649435481124;
        Fri, 08 Apr 2022 09:31:21 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id i13-20020a0560001acd00b002078e242847sm3133436wry.97.2022.04.08.09.31.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 09:31:20 -0700 (PDT)
Message-ID: <d28770af-f764-e5a2-1de6-e9d3bc8e27f1@redhat.com>
Date:   Fri, 8 Apr 2022 18:31:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.18, take #1
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     Andrew Jones <drjones@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Will Deacon <will@kernel.org>, Yu Zhe <yuzhe@nfschina.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
References: <20220408150746.260017-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220408150746.260017-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/8/22 17:07, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's the first batches of fixes for 5.18 (most of it courtesy of
> Oliver). The two important items here are a MMU rwlock fix when
> splitting block mappings, and a debugfs registration issue resulting
> in a potentially spectacular outcome.

Pulled, thanks.  I am not sure I will be able to send it out before 
Monday, though.

Paolo

