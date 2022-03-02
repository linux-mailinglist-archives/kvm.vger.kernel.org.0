Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABDA34CB12D
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 22:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245238AbiCBVXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 16:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245209AbiCBVWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 16:22:53 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF5149CBD;
        Wed,  2 Mar 2022 13:22:09 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id m42-20020a05600c3b2a00b00382ab337e14so2991179wms.3;
        Wed, 02 Mar 2022 13:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NNsXs6B0mkQsRfhmchTQTvbzvxg8yOQsBkzzzvqG0SY=;
        b=b5KHAflqBLRoTvjB5mPfNSHdOErVE6ht0KMWFnlK8YuUg9SinMOAF06br4RUbUo5yj
         XzBk2ilgIUVGeM7bfSYyvQCBM9+e5zKH1qa6XmdEF+dq+/0rhlil0dd8S7SV7ZqmOHwA
         MIVJJbVqRoNDm/c3BKXCsVfBbzwJbI3ES/N0VZNeMkPk42/rZ3i3TNA6lBOf1oApeenm
         yL6axBHAcFpy1jnHIrck7m2V75Nmvy4+YLhAiEcShaFfz2kJyj0H3uZl9cVooTDWIg9v
         HjJ3lnkkZH01Z2pCzrFilB7WY5TaAg0x2zGaUxboswNXeNl6/JghZz2DiEOkgp3bQL62
         qPtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NNsXs6B0mkQsRfhmchTQTvbzvxg8yOQsBkzzzvqG0SY=;
        b=qG/4vxT/R9BNaI7MRHpt/A9LmqOwjpG1JJBuSSAiO1vFQqzVqZQV1VwjynrNmdD74x
         N5HBZBCvoPog3YzGBUxGdqxqZwAeiM4o1brk4Bhgj7uGcR73UvJlpXv2KUD74ukIhhUd
         CNoqc5+8iU00mUOT/kQ2m451OGhdsFbDTki9mQf6xD4dAUaOeFai3izRumYiBVdn+DTK
         lQTZS+WD4VAVMiTSvEtN9DJvCpB4WC8DcNczpYhAJo4hWMsUmIKBZf7oGY9E3+gYKvyt
         ITTSpPbnyClaW+rqKZtmDUDX7QrVhqnjdWJNMXAhkzqI2X5SdFmWvYiVREwzHmMF4/HM
         HB/g==
X-Gm-Message-State: AOAM532z0ntou+lZAk2Fa2I0tCgqMEJh7emA0wlLp9qji7eftAMykEuJ
        pXsw5N4VLxRId5upqltkVl8=
X-Google-Smtp-Source: ABdhPJzJ/bUanXsI9+rA8QSoAEfJH+HjTQjbsHGDOCvaQvvYD/m/X4nAY1aZePpETlixxwV2ziWqwg==
X-Received: by 2002:a05:600c:350f:b0:381:738e:d678 with SMTP id h15-20020a05600c350f00b00381738ed678mr1404016wmq.124.1646256128203;
        Wed, 02 Mar 2022 13:22:08 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id f13-20020adff8cd000000b001f03439743fsm121087wrq.75.2022.03.02.13.22.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 13:22:07 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <94b5c78d-3878-1a6c-ab53-37daf3d6eb9c@redhat.com>
Date:   Wed, 2 Mar 2022 22:22:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 22/28] KVM: x86/mmu: Zap defunct roots via asynchronous
 worker
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-23-seanjc@google.com>
 <b9270432-4ee8-be8e-8aa1-4b09992f82b8@redhat.com>
 <Yh+xA31FrfGoxXLB@google.com>
 <f4189f26-eff9-9fd0-40a1-69ac7759dedf@redhat.com>
 <Yh/GoUPxMRyFqFc5@google.com>
 <442859af-6454-b15e-b2ad-0fc7c4e22909@redhat.com>
 <Yh/X3m1rjYaY2s0z@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yh/X3m1rjYaY2s0z@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/2/22 21:47, Sean Christopherson wrote:
> On Wed, Mar 02, 2022, Paolo Bonzini wrote:
>> For now let's do it the simple but ugly way.  Keeping
>> next_invalidated_root() does not make things worse than the status quo, and
>> further work will be easier to review if it's kept separate from this
>> already-complex work.
> 
> Oof, that's not gonna work.  My approach here in v3 doesn't work either.  I finally
> remembered why I had the dedicated tdp_mmu_defunct_root flag and thus the smp_mb_*()
> dance.
> 
> kvm_tdp_mmu_zap_invalidated_roots() assumes that it was gifted a reference to
> _all_ invalid roots by kvm_tdp_mmu_invalidate_all_roots().  This works in the
> current code base only because kvm->slots_lock is held for the entire duration,
> i.e. roots can't become invalid between the end of kvm_tdp_mmu_invalidate_all_roots()
> and the end of kvm_tdp_mmu_zap_invalidated_roots().

Yeah, of course that doesn't work if kvm_tdp_mmu_zap_invalidated_roots() 
calls kvm_tdp_mmu_put_root() and the worker also does the same 
kvm_tdp_mmu_put_root().

But, it seems so me that we were so close to something that works and is 
elegant with the worker idea.  It does avoid the possibility of two 
"puts", because the work item is created on the valid->invalid 
transition.  What do you think of having a separate workqueue for each 
struct kvm, so that kvm_tdp_mmu_zap_invalidated_roots() can be replaced 
with a flush?  I can probably do it next Friday.

Paolo

> 
> Marking a root invalid in kvm_tdp_mmu_put_root() breaks that assumption, e.g. if a
> new root is created and then dropped, it will be marked invalid but the "fast zap"
> will not have a reference.  The "defunct" flag prevents this scenario by allowing
> the "fast zap" path to identify invalid roots for which it did not take a reference.
> By virtue of holding a reference, "fast zap" also guarantees that the roots it needs
> to invalidate and put can't become defunct.
> 
> My preference would be to either go back to a variant of v2, or to implement my
> "second list" idea.
> 
> I also need to figure out why I didn't encounter errors in v3, because I distinctly
> remember underflowing the refcount before adding the defunct flag...

