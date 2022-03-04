Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11BA24CCE16
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 07:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238562AbiCDGtT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 01:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbiCDGtR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 01:49:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D339C49F8A
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 22:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646376508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SYw46/juAkVUmAthbyDhSf57VAFYaSUG9vWYk421L9A=;
        b=TkIvDvAvwkFcxAyotONlGicDbzZ7TSN2owC8pYbRk/pVNGdCNysLzEm/cZykLkwPayZJ5g
        kjmwT+DoZElinFgShaxI2Nw5nEmn8bGSVO9aDx3XrnWpw1sOot+6W56TzK3qaaCgYbbDxp
        2I9N9PeXt2QRin7TqoCsXbfIgJCa0lc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-183-mtVZQD6NMuqSbxdqZ_eMHA-1; Fri, 04 Mar 2022 01:48:28 -0500
X-MC-Unique: mtVZQD6NMuqSbxdqZ_eMHA-1
Received: by mail-ed1-f69.google.com with SMTP id r9-20020a05640251c900b00412d54ea618so4107446edd.3
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 22:48:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SYw46/juAkVUmAthbyDhSf57VAFYaSUG9vWYk421L9A=;
        b=bIKsxlQNOYcfrmM4JhiFm4t9PYl1EwqkjAlE5zB88oy6TqmT4KcgoCBpQUPgEqrYFE
         oDG3e1u/+/AEBUL1+oLYZp5gq56+EFysiJXXFypWQ3qlHGXi5gRUHqRO//OZjPMNS8PB
         +DuzfuMZUKIoj65urCcw5rimqR8DT1azbicVyMRpmrEejK5c6qhX9/AA+kG7GXhjWnOH
         RrY03YR5Y8aSmTzpIswO4170UBMYLGMsQFqtWEr7nVsMp8SjcdeKqYAMcOhEYz8kVtA/
         jiLERv1u29BHGsTal/+kltvYJUPwMlS7VfI41SmTWzBOo7nTJpC49MxIZiK+Rp+a3FdL
         FJ5A==
X-Gm-Message-State: AOAM530O96a6BASPgLYzvv/DcL2l1yN0Q8ngES3t6MgFELV94+XdLo88
        S9JZ8RmjRpuQ5lUJWSKTUzyFxgEcey1jrCInO/0LbCmMRM7FXpoYXTFagjBlAA1B2K/twFj712T
        S04IC4S6JhDEd
X-Received: by 2002:a05:6402:50d4:b0:413:2a27:6b56 with SMTP id h20-20020a05640250d400b004132a276b56mr38090086edb.228.1646376506585;
        Thu, 03 Mar 2022 22:48:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy1wppOn/f0V2yisR+TjpMzXr2rsZtTf4v8keVhYhkYrwzXX2jWMUo09KtjajHgzmgLDaDAPw==
X-Received: by 2002:a05:6402:50d4:b0:413:2a27:6b56 with SMTP id h20-20020a05640250d400b004132a276b56mr38090071edb.228.1646376506390;
        Thu, 03 Mar 2022 22:48:26 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id f5-20020a1709067f8500b006da68bfdfc7sm1431372ejr.12.2022.03.03.22.48.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 22:48:25 -0800 (PST)
Message-ID: <eeac12f0-0a18-8c63-1987-494a2032fa9d@redhat.com>
Date:   Fri, 4 Mar 2022 07:48:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 21/30] KVM: x86/mmu: Zap invalidated roots via
 asynchronous worker
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-22-pbonzini@redhat.com> <YiExLB3O2byI4Xdu@google.com>
 <YiEz3D18wEn8lcEq@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YiEz3D18wEn8lcEq@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/3/22 22:32, Sean Christopherson wrote:

> The re-queue scenario happens if a root is queued and zapped, but is kept alive
> by a vCPU that hasn't yet put its reference.  If another memslot comes along before
> the (sleeping) vCPU drops its reference, this will re-queue the root.
> 
> It's not a major problem in this patch as it's a small amount of wasted effort,
> but it will be an issue when the "put" path starts using the queue, as that will
> create a scenario where a memslot update (or NX toggle) can come along while a
> defunct root is in the zap queue.

As of this patch it's not a problem because 
kvm_tdp_mmu_invalidate_all_roots()'s caller holds kvm->slots_lock, so 
kvm_tdp_mmu_invalidate_all_roots() is guarantee to queue its work items 
on an empty workqueue.  In effect the workqueue is just a fancy list. 
But as you point out in the review to patch 24, it becomes a problem 
when there's no kvm->slots_lock to guarantee that.  Then it needs to 
check that the root isn't already invalid.

>>> The only issue is that kvm_tdp_mmu_invalidate_all_roots() now assumes that
>>> there is at least one reference in kvm->users_count; so if the VM is dying
>>> just go through the slow path, as there is nothing to gain by using the fast
>>> zapping.
>> This isn't actually implemented.:-)
> Oh, and when you implement it (or copy paste), can you also add a lockdep and a
> comment about the check being racy, but that the race is benign?  It took me a
> second to realize why it's safe to use a work queue without holding a reference
> to @kvm.

I didn't remove the paragraph from the commit message, but I think it's 
unnecessary now.  The workqueue is flushed in kvm_mmu_zap_all_fast() and 
kvm_mmu_uninit_tdp_mmu(), unlike the buggy patch, so it doesn't need to 
take a reference to the VM.

I think I don't even need to check kvm->users_count in the defunct root 
case, as long as kvm_mmu_uninit_tdp_mmu() flushes and destroys the 
workqueue before it checks that the lists are empty.

I'll wait to hear from you later today before sending out v5.

Paolo

