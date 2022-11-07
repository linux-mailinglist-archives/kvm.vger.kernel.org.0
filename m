Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509ED61FB1E
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 18:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbiKGRV1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 12:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbiKGRV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 12:21:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECFD140E5
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 09:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667841629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W/RetZ1GSClvSmEVsreiUXtKscEDL2whf8S9HCXvlE4=;
        b=ZI/pR8Turwsuk77qvkBEw/2PVW6x2QF5vXZixxfdJQC0dcNuQN/AI4RO6iu6ch7L6C+yLO
        2bhB26IlJ73UcwHYEBvey18gw0cfuDWDCHCIwhxgwnPmylY6t3ChX9/JyWRAQff3EnD/lf
        AS/kfHwvbqBHkt2ea3PFr45AiuyVGVg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-65-yAc0o728NPOgZKgvQ2QPDA-1; Mon, 07 Nov 2022 12:20:28 -0500
X-MC-Unique: yAc0o728NPOgZKgvQ2QPDA-1
Received: by mail-wm1-f72.google.com with SMTP id x10-20020a05600c420a00b003cfa33f2e7cso2181521wmh.2
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 09:20:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W/RetZ1GSClvSmEVsreiUXtKscEDL2whf8S9HCXvlE4=;
        b=j6/DXdCJZAExlWrlkgtql1oqrPdkq0vUKIrm6imcaPNgfTT+MBDVnQg7BmugNNWWlL
         7vWjj1/LqLip+2v0sjvcUnDYGhkNhur+hNdTAucVATnrxT6KGybidFBqICTVU1qy1VX7
         JetWGHxTB+bMQd+29p80trUETQpyLgoLMrwbslqWwyaPn7LHynPeobYdHxp5qktchJJR
         LHsrr1o0o/4I6CCdE0CA4RUIQqgPb2LDVIeZTLTnvCvV3GllIofL9WT0hmqg19LCoIFO
         JZKX1dKMnk8o/TVVbc5xuKCaraHcFvgQELCY35h5WHEPw8+mBwtFXebdll+a1j+gjl9l
         hOVw==
X-Gm-Message-State: ACrzQf2Tg9dUBNux+XEOox1KmLoVXipDwK3G6rr1FQsHvIXGQOmMocDR
        D5d99BU3XpIZ/Ls5EVev+y4oK6pWHYnaBEcwKVBwOh27Sr1EqYB0jA2E8e1sJcC2lufVdy6QaS3
        MRFTfKTJ4KNvh
X-Received: by 2002:a5d:6385:0:b0:22e:3498:9adb with SMTP id p5-20020a5d6385000000b0022e34989adbmr640376wru.335.1667841627277;
        Mon, 07 Nov 2022 09:20:27 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7PifGCw22NSPEedADMFQmmHbUq0+zu0QT1d0ArAWKERGor4bClObxFnriwdXEkbdF9zYKBaQ==
X-Received: by 2002:a5d:6385:0:b0:22e:3498:9adb with SMTP id p5-20020a5d6385000000b0022e34989adbmr640372wru.335.1667841627053;
        Mon, 07 Nov 2022 09:20:27 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id s25-20020adfa299000000b00236b2804d79sm8294132wra.2.2022.11.07.09.20.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 09:20:25 -0800 (PST)
Message-ID: <c8f036f4-6ab1-efbe-dd60-b934c21cb21d@redhat.com>
Date:   Mon, 7 Nov 2022 18:20:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] KVM: VMX: Do not trap VMFUNC instructions for L1 guests.
Content-Language: en-US
To:     Yu Zhang <yu.c.zhang@linux.intel.com>, seanjc@google.com,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20221107082727.1355797-1-yu.c.zhang@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221107082727.1355797-1-yu.c.zhang@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/7/22 09:27, Yu Zhang wrote:
> VMFUNC is not supported for L1 guests, and executing VMFUNC in
> L1 shall generate a #UD directly. Just disable it in secondary
> proc-based execution control for L1, instead of intercepting it
> and inject the #UD again.
> 
> Signed-off-by: Yu Zhang<yu.c.zhang@linux.intel.com>

Is this for TDX or similar?  The reason for a patch should be mentioned 
in the commit message.

Paolo

