Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990601B8764
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 17:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgDYPcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 11:32:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38166 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726062AbgDYPcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 11:32:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587828727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BzRp1k5dc8WKlXfsFPGhR2nlnYOxZPdvqIx1ngvuQb8=;
        b=h0Z2jXz9bWRc3Y40V+5WILpEPRXo2oooGg+MdZHviPGd5077e7yAvqEfzaWPDll+J1KYJ5
        1l6qMw7ccCSe0b04MKuSns5bRUJIwXIPfNEdTOIC30dylskmXqYmSrwTR8eLu5YMNwxEq3
        aXM23YXQB6eKgFHoU5DdGPuhd+QxNwk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-yqLa5A5tOwWadgUdo_pzyw-1; Sat, 25 Apr 2020 11:32:03 -0400
X-MC-Unique: yqLa5A5tOwWadgUdo_pzyw-1
Received: by mail-wr1-f69.google.com with SMTP id f4so5435864wrp.14
        for <kvm@vger.kernel.org>; Sat, 25 Apr 2020 08:32:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BzRp1k5dc8WKlXfsFPGhR2nlnYOxZPdvqIx1ngvuQb8=;
        b=mvKhwxOsjI5j32x+Hm2CiUDmlMPefPzNZdJC4pBnBSct3q7akQuGB4ZohTLpMvJVqd
         hAUuKeeWzgS3RhEDVlux6Xxqe46eKrb78HletllN8bTGwomSt6MT952o8yPc1YOvs7O9
         97oIJs9n16FImB1WJb1/bdf4+jjYIL5d++5+xUMzZZI+JQMjXqG9gAkra/xX18AQqX2N
         xGI6OoWJyCk3a5GL6uriUqgeSfvs6wC6ewbjwV90oZXZd0hb1LYo6H5hLhlA3CDbPBtJ
         AxgMFcWQ8skNXtjfik1XUhBQ+BB0vvt/Ne7dCT93s3VHOkn+aiL/iwRXaT1tty/UMT1e
         l5Og==
X-Gm-Message-State: AGi0PuZ5BLotKz2fh3aKxgjeL75qhUQAUqr9d+ZeX7DyAn91K2LThtE2
        XqbAG9pGxaGjvXC1ZOfy6TZBjTjpFR2+vR2gQM8UH59wzAzCLkjbqsnuBr0M7TMW1PZmTxBh9lv
        xsjefwOWh9/vr
X-Received: by 2002:a5d:4301:: with SMTP id h1mr18013779wrq.144.1587828721999;
        Sat, 25 Apr 2020 08:32:01 -0700 (PDT)
X-Google-Smtp-Source: APiQypKxxnDSm/VF3uk0PKMA3ZoLYy6mbz4JxZCdemvQx51TsVlUG0uJlpkeUpyPFw2DqwsfIQNYcQ==
X-Received: by 2002:a5d:4301:: with SMTP id h1mr18013766wrq.144.1587828721754;
        Sat, 25 Apr 2020 08:32:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d0a0:f143:e9e4:2926? ([2001:b07:6468:f312:d0a0:f143:e9e4:2926])
        by smtp.gmail.com with ESMTPSA id y40sm14033685wrd.20.2020.04.25.08.32.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Apr 2020 08:32:01 -0700 (PDT)
Subject: Re: [PATCH v11 7/9] KVM: X86: Add userspace access interface for CET
 MSRs
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-8-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <08457f11-f0ac-ff4b-80b7-e5380624eca0@redhat.com>
Date:   Sat, 25 Apr 2020 17:31:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326081847.5870-8-weijiang.yang@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/03/20 09:18, Yang Weijiang wrote:
> There're two different places storing Guest CET states, states
> managed with XSAVES/XRSTORS, as restored/saved
> in previous patch, can be read/write directly from/to the MSRs.
> For those stored in VMCS fields, they're access via vmcs_read/
> vmcs_write.
> 
> To correctly read/write the CET MSRs, it's necessary to check
> whether the kernel FPU context switch happened and reload guest
> FPU context if needed.

I have one question here, it may be just a misunderstanding.

As I understand it, the PLx_SSP MSRs are only used when the current
privilege level changes; the processor has a hidden SSP register for the
current privilege level, and the SSP can be accessed via VMCS only.

These patches do not allow saving/restoring this hidden register.
However, this should be necessary in order to migrate the virtual
machine.  The simplest way to plumb this is through a KVM-specific MSR
in arch/x86/include/uapi/asm/kvm_para.h.  This MSR should only be
accessible to userspace, i.e. only if msr_info->host_initiated.

Testing CET in the state-test selftest is a bit hard because you have to
set up S_CET and the shadow stack, but it would be great to have a
separate test similar to tools/testing/selftests/x86_64/smm_test.  It's
not an absolute requirement for merging, but if you can put it on your
todo list it would be better.

Thanks,

Paolo

