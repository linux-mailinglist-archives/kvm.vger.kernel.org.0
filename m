Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E549211C17B
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 01:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfLLAdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 19:33:52 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27670 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727239AbfLLAdv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 19:33:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576110830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kxaQEzM6oe0SiXHNkoXFhJo/PdqrG74qMgwC+pUR+EA=;
        b=fea64jzyLVvJiy0anhIysxzOE8z4ENwtMdRvA5xVklDDEHUKhsKNjTUgnN2kbMEmHUegon
        SMn2bPsfwqiDVFWl2cKSlYQCd+D/zOPRxxZFQnYmDjwV6wt6UiY4QrR9f3bY1l3cXf5Bnj
        q7pKx22lJplKxorPefSOHIQCzeOoeT0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-nSGyJUGUNneSQM8lvxoggA-1; Wed, 11 Dec 2019 19:33:49 -0500
X-MC-Unique: nSGyJUGUNneSQM8lvxoggA-1
Received: by mail-wr1-f71.google.com with SMTP id z10so300523wrt.21
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 16:33:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kxaQEzM6oe0SiXHNkoXFhJo/PdqrG74qMgwC+pUR+EA=;
        b=R9m9pjc7XBaVrqbSqtZVVPz/lSDf+n2ipfxZGPgr7q+sgFyvlSf+HG28mJE/e7pkXR
         VTwEpJZAz6EXWQic1mnNiXLHLVbhau5yl1haKhzQZaYt6ANytc1p4C9FlN2kQamOOIEA
         t0dijXC5NHpikjGV4VZIbmZsmwzGBj6sWnlD7oc9oz7x7PxewK4BkezUhcLiNQ2gkkmF
         p+Bx+nLx/5UwugaqoRP43YnS7fA6MiUAIVUplp+4og0bq4C+WCQBbyKDkLH/0+k4xEpu
         NVVqcregzwCdWZ+4Jb5mqKcZkZdgTFIps1JZwLgeum6OCl0oL0JBDEGClNlKn35QZK7j
         A/eA==
X-Gm-Message-State: APjAAAVkz+o2PSF2ST11UNLWE35OGfwB2lUKCmDHNTArL947mTakAD0S
        9hEp9k4OlcZ8TNMulaNVhj4kQ/ps25DQrG2nVKbC4m3l3x5vCEgcrCm+9aIZdXOCtoe9W4HGzNp
        B1NY1ZchQUncI
X-Received: by 2002:a7b:cb06:: with SMTP id u6mr2810622wmj.59.1576110828053;
        Wed, 11 Dec 2019 16:33:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqyD0amd5WvU7gq7wzj8WYH1A6wG/po1G1jtnvaFUH1dPZs63RNPSrP3jOjG29NHFqZXaTnK6A==
X-Received: by 2002:a7b:cb06:: with SMTP id u6mr2810593wmj.59.1576110827817;
        Wed, 11 Dec 2019 16:33:47 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id l22sm3975613wmj.42.2019.12.11.16.33.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 16:33:47 -0800 (PST)
Subject: Re: [PATCH v2 1/3] KVM: x86: assign two bits to track SPTE kinds
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Junaid Shahid <junaids@google.com>
References: <1569582943-13476-1-git-send-email-pbonzini@redhat.com>
 <1569582943-13476-2-git-send-email-pbonzini@redhat.com>
 <CANgfPd8G194y1Bo-6HR-jP8wh4DvdAsaijue_pnhetjduyzn4A@mail.gmail.com>
 <20191211191327.GI5044@linux.intel.com>
 <4e850c10-ff14-d95e-df22-0d0fd7427509@redhat.com>
 <20191212002902.GM5044@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5c39ee9b-3b58-f1c9-889d-6e012bbbac6c@redhat.com>
Date:   Thu, 12 Dec 2019 01:33:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191212002902.GM5044@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/19 01:29, Sean Christopherson wrote:
>>   */
>> -#define MMIO_SPTE_GEN_MASK		GENMASK_ULL(18, 0)
>> +#define MMIO_SPTE_GEN_MASK		GENMASK_ULL(17, 0)
>>  
>>  #define MMIO_SPTE_GEN_LOW_START		3
>>  #define MMIO_SPTE_GEN_LOW_END		11
>>  #define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
>>  						    MMIO_SPTE_GEN_LOW_START)
>>  
>> -#define MMIO_SPTE_GEN_HIGH_START	52
>> -#define MMIO_SPTE_GEN_HIGH_END		61
>> +/* Leave room for SPTE_SPECIAL_MASK.  */
>> +#define MMIO_SPTE_GEN_HIGH_START	PT64_SECOND_AVAIL_BITS_SHIFT
> I'd rather have GEN_HIGH_START be an explicit bit number and then add
> a BUILD_BUG_ON(GEN_HIGH_START < PT64_SECOND_AVAIL_BITS_SHIFT) to ensure
> the MMIO gen doesn't overlap other stuff.  That way we get a build error
> if someone changes PT64_SECOND_AVAIL_BITS_SHIFT, otherwise the MMIO gen
> will end up who knows where and probably overwrite NX or EPT.SUPPRESS_VE.
> 

Fair enough.  While at it I'll also add MMIO_SPTE_GEN_BITS (
	MMIO_SPTE_GEN_LOW_END - MMIO_SPTE_GEN_LOW_START + 1
	+ MMIO_SPTE_GEN_HIGH_END - MMIO_SPTE_GEN_HIGH_START + 1) and use it in
MMIO_SPTE_GEN_MASK.

Paolo

