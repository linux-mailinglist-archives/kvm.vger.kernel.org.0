Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C775143ED4
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 15:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbgAUOBx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 09:01:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34074 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729073AbgAUOBx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 09:01:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579615312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ObeXmqek/4gMe0mE2cafb7CORKdf30UezDwWR6GNf18=;
        b=TjKozO3jJpVThNALgMcBEMkMycO7K7GGHv+35w3Pg3s2S/Nc+Jk4AM9z+EMT0ojgfDG5cZ
        jKCPT1d4dgHrZuiEXqR6KiWE0xhVGkd4McqKc3qSJEWAAjqzHrWf484qPCBoM/z1kNB/+q
        VwP1eRhWLuMdgUUehYZAAfKy3LikpKk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-Fdx-JbzsN92qdFkgAVsxjg-1; Tue, 21 Jan 2020 09:01:51 -0500
X-MC-Unique: Fdx-JbzsN92qdFkgAVsxjg-1
Received: by mail-wr1-f72.google.com with SMTP id d8so1338185wrq.12
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 06:01:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ObeXmqek/4gMe0mE2cafb7CORKdf30UezDwWR6GNf18=;
        b=jgsUfWmLRgQb5kj+474dIXXDh2KcEp19WN5we4WLsAG2sQuawu2Jr4gV5FMMwKobup
         2G8WWVqLFeoYgOCFF1YL5EAZW3JIuZPG6in8ArEPvPdWpbaX9IbuqZSaVwYhppoFpRRm
         Z0wZM6YNPn6867e8a4WWHSnjZPJJRmWO4OBP3jgly9k/fQ6oydfFoNBsEjoK185ZhKut
         RZ6iOTSjkUOee6erxv5Rkc67BNgoKlXksMSZEybWEL/2FN2lxWCN5EeMaiGyxskMXQPo
         kAbzA7MZq7AWPskN7w3lJ2TDsVWQu7ssQ1GrdxqmPVX8mco5Q3qLVIrv/1bMw85yrwe2
         czAQ==
X-Gm-Message-State: APjAAAUqvmXrf2iYz2qUtNC68BxWb2RDV4Fz8m/CJ6S+2lAuOpOxtU/t
        JnzwofoFNoFmR5e65qcMdzPBLxggjsOMZWaoXB7Fjbc/OuK5EsqW7CET/bV0TZkXz2ZMVnpgApN
        uK8lH0QuaqEol
X-Received: by 2002:a5d:5091:: with SMTP id a17mr5379868wrt.362.1579615309986;
        Tue, 21 Jan 2020 06:01:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqwzfFj1xWSvzPORiOR/mf0Fi+pdgBIZMpJKph7cqo+XOocycXWbBw3t6BRfxNV4UAbABwCvtA==
X-Received: by 2002:a5d:5091:: with SMTP id a17mr5379826wrt.362.1579615309620;
        Tue, 21 Jan 2020 06:01:49 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id q68sm4632988wme.14.2020.01.21.06.01.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 06:01:49 -0800 (PST)
Subject: Re: [RESEND PATCH v10 06/10] vmx: spp: Set up SPP paging table at
 vmentry/vmexit
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmattson@google.com, yu.c.zhang@linux.intel.com,
        alazar@bitdefender.com, edwin.zhai@intel.com
References: <20200102061319.10077-1-weijiang.yang@intel.com>
 <20200102061319.10077-7-weijiang.yang@intel.com>
 <20200110175537.GF21485@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <80977d05-405e-826a-3d13-1757427f246b@redhat.com>
Date:   Tue, 21 Jan 2020 15:01:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200110175537.GF21485@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/01/20 18:55, Sean Christopherson wrote:
> Unless there is a *very* good reason for these shenanigans, spp.c needs
> to built via the Makefile like any other source.  If this is justified
> for whatever reason, then that justification needs to be very clearly
> stated in the changelog.

Well, this #include is the reason why I moved mmu.c to mmu/spp.c.  It
shouldn't be hard to create a mmu_internal.h header for things that have
to be shared between mmu.c and spp.c, but I'm okay with having the
#include "spp.c" for now and cleaning it up later.  The spp.c file,
albeit ugly, provides hints as to what to put in that header; without it
it's a pointless exercise.

Note that there isn't anything really VMX specific even in the few vmx_*
functions of spp.c.  My suggestion is just to rename them to kvm_mmu_*.

Paolo

