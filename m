Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E928203888
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 15:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbgFVN5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 09:57:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53804 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728994AbgFVN5S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 09:57:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592834237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Dbcv+orP1bMR1kWsR7V/IGamiGGqbmfinxnIa4z8Z8=;
        b=ghd2MWWWVankYhlgh/p9uHUfRvTQClOuOYk3RARH/a0AHlQHY3+HqE7SpVQAXXnRiAzFSu
        nJjikHGHCM2Y312ATtwKQ6UG7BeWn6XzUE2Wy/UKkD11CDqk8YoYUowO9q4nUs3lfAPcnU
        bDR+WIkjbvZn9re4lh0n41emmobXDfw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-X3DBbCjjOJGM23D2r6XLbQ-1; Mon, 22 Jun 2020 09:57:13 -0400
X-MC-Unique: X3DBbCjjOJGM23D2r6XLbQ-1
Received: by mail-wr1-f71.google.com with SMTP id o1so10808810wrm.17
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 06:57:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7Dbcv+orP1bMR1kWsR7V/IGamiGGqbmfinxnIa4z8Z8=;
        b=NIfyRMou+orwY6fHVtn70RmKENNTwIt5GfjApYIgA4HWIv54NGY39TelXeYFrHF8MC
         q/GlUBJWz9r40e2c/B6GySKCgtAyblJapNnxnSb+7L/sFRWGF/v1fvSxZgB2Po2aDshR
         OmEzfpfrmKsRVM3Jc9eS/FfAk/A/SDON8f9ShmSftwtk9dFdhbGAzLXf/uJr8giJv+0d
         9D0pfl7yeNbD5Xq0XVX+loybDkfMYDyVuPO7Q/LbUK5EFR1liRTUSsCO/VPiN3rP8cLr
         R+AD2yONDdEmho7tTUMFSIx66218dO9M4/3fS+/yQFKfxs4FJd5mTceFT6q6HZTGevi/
         leMg==
X-Gm-Message-State: AOAM532VEj2GezkeaJLaGgeshk/Fm0lZ+W1diKvNnQ1kfzMpVHkMkpq5
        iw5u2IsH7/9jTLIiwyyHrWfm1pN+nw4RN1O8HM6lCdH9YsOPQizZt3C8nH+dsqRTed/wp4gkaVn
        U6yWNM1u2+Asf
X-Received: by 2002:a5d:404e:: with SMTP id w14mr16864013wrp.268.1592834232342;
        Mon, 22 Jun 2020 06:57:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzuiM5HVFFPZD2gO2bgU4gQGbG7Bmz3Bvz9UhRdqeO2XWn6d0+3uQ8RW9PJMUn0dHE7+zS8lQ==
X-Received: by 2002:a5d:404e:: with SMTP id w14mr16863993wrp.268.1592834232066;
        Mon, 22 Jun 2020 06:57:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fd64:dd90:5ad5:d2e1? ([2001:b07:6468:f312:fd64:dd90:5ad5:d2e1])
        by smtp.gmail.com with ESMTPSA id e5sm18457392wrw.19.2020.06.22.06.57.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 06:57:11 -0700 (PDT)
Subject: Re: [PATCH v2 06/11] KVM: VMX: introduce vmx_need_pf_intercept
To:     Jim Mattson <jmattson@google.com>,
        Mohammed Gamal <mgamal@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Moger, Babu" <babu.moger@amd.com>
References: <20200619153925.79106-1-mgamal@redhat.com>
 <20200619153925.79106-7-mgamal@redhat.com>
 <CALMp9eQYRoB5vmxL0U7Mn0rWqotxLpUAJD15YX0DDYop1ZmuEg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f0078376-dbd6-dc0a-6a7f-a05ebaadba11@redhat.com>
Date:   Mon, 22 Jun 2020 15:57:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQYRoB5vmxL0U7Mn0rWqotxLpUAJD15YX0DDYop1ZmuEg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/06/20 00:45, Jim Mattson wrote:
>> +               /*
>> +                * TODO: if both L0 and L1 need the same MASK and MATCH,
>> +                * go ahead and use it?
>> +                */
> I'm not sure there's much "TODO", since L0's MASK and MATCH are both
> 0. So, if L1's MASK and MATCH are also both 0, we would go ahead and
> use 0's, which it seems we already do here:

True, the comment should be moved to patch 8.

Paolo

>> +               vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
>> +               vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, 0);

