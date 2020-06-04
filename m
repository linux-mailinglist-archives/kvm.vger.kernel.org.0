Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076FC1EE6F3
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 16:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgFDOvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 10:51:48 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22696 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729122AbgFDOvr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 10:51:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591282304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WIdcxFhD5AtIVkPJFsdl+nC/MNFSl7sTcg1QPkwUn+c=;
        b=f8iBVyVMAa/LoX3DaeWQRMGPwqoD/fO6GiUVzjyeE/PwU8LwEFwzaf+M+qMlkAS1MPILQd
        aUdY5c4QyQqrYQhdY34EWmf+IstNWtEJfbGaAnqtBfXuWTrgEhiXMrAI3OVZcd0fWwQ2RA
        R510NxqxGT1vzd+Kzf8HyDLbvag4/U4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-GKHNphrfNmyuTHkt_z2ZDQ-1; Thu, 04 Jun 2020 10:51:41 -0400
X-MC-Unique: GKHNphrfNmyuTHkt_z2ZDQ-1
Received: by mail-wr1-f69.google.com with SMTP id s17so2512991wrt.7
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 07:51:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WIdcxFhD5AtIVkPJFsdl+nC/MNFSl7sTcg1QPkwUn+c=;
        b=pMK1dbqw4CChYZuwNWJ/7IoMtZb3uQBtiQLeFvcfQSvZMmnMb3MGJqQEVR/N0qfq2q
         AvjaiK+YJFQ+cDQWyxmUBPBlVfIffRL9evIISN6keFhM1wAaZj6wyVfor9AeWig3NJCh
         j9VO/nDimMzVenYJGZc6cLXJJtHGkIXx5OnSqnkz04M9P5OsTC6EY6biHWHG8ypoSvxb
         8HjJBLaX116MjlbTDz/NktZl/gStORjSs4FcZte4F7Kw7cjz4iqBTes8oslZU4qSyVgY
         v0lOyemSOnWcytS0DeQ2oV7yh9FB7kdtMDjKXGoJtRAUMdLObDdQpQMcUhiysAFq43LT
         GlZA==
X-Gm-Message-State: AOAM530l8v80SHGhSC0JFrnEfGEPybKZw7WJVts7if3y4d8SfmjWBG59
        cbnFyGdgb1p9F2ekR6s9oQU3AbrEQBUiIvZLjLQRe4gjkgceZPnPzTLvXpaV8tL2jSAzcQ5Qva4
        uftifu5DzxbKG
X-Received: by 2002:a05:6000:47:: with SMTP id k7mr4551740wrx.233.1591282300534;
        Thu, 04 Jun 2020 07:51:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvmMZ510Bkq3KbMg+snEpYUDO48TreSV2Rt+EqrjFgex72sSVvOqOGnU0ka/WNGTdF79ldmA==
X-Received: by 2002:a05:6000:47:: with SMTP id k7mr4551726wrx.233.1591282300321;
        Thu, 04 Jun 2020 07:51:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0c0:5d2e:1d35:17bb? ([2001:b07:6468:f312:a0c0:5d2e:1d35:17bb])
        by smtp.gmail.com with ESMTPSA id f71sm7130039wmf.22.2020.06.04.07.51.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 07:51:39 -0700 (PDT)
Subject: Re: PAE mode save/restore broken
To:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
References: <CALMp9eS2UtMazBew2yndKVXC0QnnBW2bvbU_d+27Hp7Fw2NXFg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <48454efb-455f-5505-f92c-7f78836d5b91@redhat.com>
Date:   Thu, 4 Jun 2020 16:51:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eS2UtMazBew2yndKVXC0QnnBW2bvbU_d+27Hp7Fw2NXFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/06/20 02:11, Jim Mattson wrote:
> I can only assume that no one cares that KVM_GET_SREGS/KVM_SET_SREGS
> is broken for PAE mode guests (i.e. KVM_GET_SREGS doesn't capture the
> PDPTRs and KVM_SET_SREGS re-reads them from memory).
> 
> Presumably, since AMD's nested paging is broken for PAE mode guests,
> the kvm community has made the decision not to get things right for
> Intel either. Can anyone confirm? This was all before my time.

Yes, pretty much.  The PDPTRs are not part of the saved state, we just
treat them as a small third level in the radix tree.  Of course, for
nested VMX they are properly synced to the VMCS12 and serialized by
KVM_SET_NESTED_STATE.

Out of curiosity are there OSes that rely on the PDPTRs remaining cached
until the next CR3 load?

Paolo

