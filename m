Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0C0642747
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 12:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiLELNb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 06:13:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiLELN3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 06:13:29 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815FEE0F8;
        Mon,  5 Dec 2022 03:13:28 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id t18so662961pfq.13;
        Mon, 05 Dec 2022 03:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ezM354WUyURnk3aBsQpH9AdjtAKWzRvOHekOCgMnEDk=;
        b=dk1Lj7pW18BGK9twIOysIh8MsJrlRULxtQAQHL0nAE6ZSRbwUyuvpLW/MtXqGczu70
         15nZNU030tsE/fk/j6mpIFwTEtg74wtr+UP5CIPvjtVMfOiUZJbELxNpyWqy+jtiTMTw
         bg1YZG7c8Vjat+c9CO9xLoa6ioeoqizRfurtrx7WSUBnNqjWUP5GkdH7iSOSNDaHaQjc
         VBe3Byt2hBQaehkOJzOS6ilIGKNtkXU2e23e7y6kZNspltM4vBxNRLk9us9co42RQGJK
         Gjj+MSJ1P+GKdJJ4CgmT4g6+Yq+W1+xTZQjnNkVOlOam4BrMwlHtgc1zHue3lkRpd1bz
         LGwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ezM354WUyURnk3aBsQpH9AdjtAKWzRvOHekOCgMnEDk=;
        b=3tIDg5Pxxs8cwLGMIlrVL589B1c8U7uvy+crJQOtdWnmgIdP+OA2IgGB4wINAoqTQJ
         tNIrwHkyY+yHnl0FsBCSAdKqqxT0oAMhyukc38/faCQu1LVCUiabjSt9ubc38Rchmoo0
         NCHCNwkN0qh5FrdNkZInmNNf8WSgRUyOlFW6Mx2XXXLTBGB4fYIVp4VQXj9r9dHlvTXW
         U4v67F4gUGsfZ8/VzasiSc0j8EtG/mryHrLq6O7JrsoheSjrwtldmAq52WfZx/mdcJPG
         o8O0g/CPvWRW68AmA6lfmqzAwvZRvvYir5paKkkU5uoeArJWhURO1S4CmdFNxRrGTdFg
         aDQA==
X-Gm-Message-State: ANoB5pk6gk33hd9aUaRrUeclb8SAcQiq04gwUxbyMklAJ7l+lBM7Yjq+
        iBNjsAd3zA+Vtdg8Mq3tRng=
X-Google-Smtp-Source: AA0mqf5eTF5VHxGpJoYQjvvd4ghlWoN/5P16oE7OYcAx1IhroCZS30D0Ik5OidqTVUmLiuAaRaW2iQ==
X-Received: by 2002:aa7:8d5a:0:b0:560:eec2:d0ab with SMTP id s26-20020aa78d5a000000b00560eec2d0abmr84681403pfe.43.1670238807908;
        Mon, 05 Dec 2022 03:13:27 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id e9-20020a170902784900b001895d871c95sm10269420pln.70.2022.12.05.03.13.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 03:13:27 -0800 (PST)
Message-ID: <05188606-395e-acd0-b821-2526d5808aca@gmail.com>
Date:   Mon, 5 Dec 2022 19:13:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH] KVM: x86: remove unnecessary exports
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
References: <20221202183727.1033906-1-pbonzini@redhat.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20221202183727.1033906-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/12/2022 2:37 am, Paolo Bonzini wrote:
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -898,7 +898,6 @@ bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu)
>   		return false;
>   	return vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED;
>   }
> -EXPORT_SYMBOL_GPL(kvm_hv_assist_page_enabled);

The kvm_hv_verify_vp_assist() is used in svm object where 
kvm_hv_assist_page_enabled() is called,
so the deletion of this line now brings a link failure. The first version of the 
patch set did not catch
such a simple error, and I assume another discussion thread's in-flight changes 
were merged into.

We may add this line back to easily fix this merge conflict.

