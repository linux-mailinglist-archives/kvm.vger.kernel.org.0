Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD74E596C88
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 12:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238866AbiHQKFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 06:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235935AbiHQKFa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 06:05:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0E43F336
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 03:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660730728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ovSTwWXo6LVGMWDp+mSnidIK890Wzjq+Jo4Bdzb7tk=;
        b=QVhEPXlDroMMUCwhsyL2z7iMsEgHqpaUbcgJntueljoEk/MAMz8gamxPaAHhCFtBXDZ4SM
        cPYwg/iFpj/p0tECoxcS8gyXtlv3vckT/27r2nljg+ISWeV7tYDVOXzj22s66djroglZfH
        Ms2Ydymr8UyT7seBNTSmS48gpzb7WY8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-213-cP-MMtUtMg-reZjVCBxzbg-1; Wed, 17 Aug 2022 06:05:26 -0400
X-MC-Unique: cP-MMtUtMg-reZjVCBxzbg-1
Received: by mail-ej1-f71.google.com with SMTP id go15-20020a1709070d8f00b00730ab9dd8c6so2702473ejc.6
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 03:05:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=7ovSTwWXo6LVGMWDp+mSnidIK890Wzjq+Jo4Bdzb7tk=;
        b=lHzouU2RnPthNaKLQvPPdrqU8CPoroS3kOZFi7x/3Alr4CVu7XBShymO55AfrU51P4
         55URkdinUdB4lkyWQ9q0waMxBHBb4LJQhZMhv4gMtYEHN+/KN76DRWujyEk/ESTXTe6K
         /tpQ0dVIRJGdNdaPAnxK8yJSx1j0XAgB3SJHn9tcJSG5Q3GYbVNoOAy087Q5uQBMzmRe
         3ZGLXceAT++z17ghmlq1vNuo66IYyRuBSkO8oY3gZnBDpIMLEaIsyXirqsIQOWWauqTk
         JAneiYCca81Yf9vp3umDiaGGDqn0XAJurU+w5ODlL8IzL2pN6IwbJ4BjF/3LsT+0XQ1F
         /z0g==
X-Gm-Message-State: ACgBeo2sl0YCHKZSOkzKtgxklIqg2ozxx9a9XRy0eWuDXStx2BM3CmNk
        vuJu/JYJgL9g57cfISimtM0w0f9QFrmgLx4BrHKTKSSWAcHsk9gfw6g2gwZ58/HFiBKZ/KpQpkY
        +eIatXrmqLHIo
X-Received: by 2002:a05:6402:270e:b0:43d:e3e1:847a with SMTP id y14-20020a056402270e00b0043de3e1847amr22544894edd.130.1660730725613;
        Wed, 17 Aug 2022 03:05:25 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7gdpFVD/KkPhOKr1ix8d0bVv4onu+tFAPjBvkRKfUk4o/w0oSvrJEcC/TxKliVFh84H0h3nw==
X-Received: by 2002:a05:6402:270e:b0:43d:e3e1:847a with SMTP id y14-20020a056402270e00b0043de3e1847amr22544868edd.130.1660730725357;
        Wed, 17 Aug 2022 03:05:25 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id k8-20020a17090632c800b007262b7afa05sm6519162ejk.213.2022.08.17.03.05.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 03:05:24 -0700 (PDT)
Message-ID: <4789d370-ac0d-992b-7161-8422c0b7837c@redhat.com>
Date:   Wed, 17 Aug 2022 12:05:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        kvm@vger.kernel.org
References: <20220815230110.2266741-1-dmatlack@google.com>
 <20220815230110.2266741-2-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/9] KVM: x86/mmu: Always enable the TDP MMU when TDP is
 enabled
In-Reply-To: <20220815230110.2266741-2-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/16/22 01:01, David Matlack wrote:
> Delete the module parameter tdp_mmu and force KVM to always use the TDP
> MMU when TDP hardware support is enabled.
> 
> The TDP MMU was introduced in 5.10 and has been enabled by default since
> 5.15. At this point there are no known functionality gaps between the
> TDP MMU and the shadow MMU, and the TDP MMU uses less memory and scales
> better with the number of vCPUs. In other words, there is no good reason
> to disable the TDP MMU.
> 
> Dropping the ability to disable the TDP MMU reduces the number of
> possible configurations that need to be tested to validate KVM (i.e. no
> need to test with tdp_mmu=N), and simplifies the code.

The snag is that the shadow MMU is only supported on 64-bit systems; 
testing tdp_mmu=0 is not a full replacement for booting up a 32-bit 
distro, but it's easier (I do 32-bit testing only with nested virt). 
Personally I'd have no problem restricting KVM to x86-64 but I know 
people would complain.

What about making the tdp_mmu module parameter read-only, so that at 
least kvm->arch.tdp_mmu_enabled can be replaced by a global variable?

Paolo

