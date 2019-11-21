Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA264104FE8
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 11:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfKUKDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 05:03:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37546 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726343AbfKUKDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 05:03:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574330581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M4v8h369ZsUMVA15kRJzaETn7xYxMuYIewbT6nQP1ZA=;
        b=M+OUQTEUmiRl1rHcBw00ViWPSOOQRNLdOhnq/l3Eo7b6U7Zhw9qUcr4pKXxMN6XMj/6zIT
        dazSmmpexmQQ8iyG+ShFeM5/FPI28uI0agWaKRRUblxEXyx0q5RTgpYprYpLlVKUJsYEf2
        55lVlYz8fIH5EoPRFC2I9cMkjHgFFhE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-h2tvIf5HOC-OzMT76IKtPg-1; Thu, 21 Nov 2019 05:02:58 -0500
Received: by mail-wr1-f69.google.com with SMTP id q6so1798445wrv.11
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 02:02:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QqX7sWs9fb5wtXIbtNAyNHpwoHRqIRPUhMneTaa0Ggk=;
        b=YvPRWEEHW5i6HExQ4nubGpkp9btVBjok4GX+1KNXBNLz/Fffp/y7tAG9grUmSwWBnx
         AaD4BkxGalAO6R6PxJqsA5HpVqFuOv3MFHbm+SCct67AUDdhl2Yd07j3h21WO8FTVy1s
         pJOsXl9kIbwxTdm23Cgpbme9LXvNRrKBxlFUM2DaINr1ynqj9+bYTgvUmfSt9KWQpti+
         3D6tmXOOPb131fFGCVInzuw5L1/UmB+qAS7hdou3HjOHRlnqDJuHIRhrUVQj2TXRCET7
         iYcdrZAEuhiUegyASjxeetRwCnLXEBU9pbAUHmPG91va6mWn2cJEqMjN0WtLUfZmsn5M
         Q2gw==
X-Gm-Message-State: APjAAAWC01oM3AjhpMyGr04a+GQG84ycx2fTtvvjW+w2uMUsNIlWdBlp
        7c0VhtkfTg+CS2r4JWLhJYy5CTME3yGqAa8ADMXaWARr6S4MRelXV8oMLGQm5km0PMSiHGFMmlx
        5FUW6xOkkr6bL
X-Received: by 2002:adf:ef45:: with SMTP id c5mr1491300wrp.200.1574330577306;
        Thu, 21 Nov 2019 02:02:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqyvsbGcaZuHudOd5MhASUTtyRm6oppNmcc6Q5zF+P+kMjkzlLT0M6CCnZ93IbdRlyDNmRcAIw==
X-Received: by 2002:adf:ef45:: with SMTP id c5mr1491280wrp.200.1574330577012;
        Thu, 21 Nov 2019 02:02:57 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:71a5:6e:f854:d744? ([2001:b07:6468:f312:71a5:6e:f854:d744])
        by smtp.gmail.com with ESMTPSA id y6sm2561699wrr.19.2019.11.21.02.02.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 02:02:56 -0800 (PST)
Subject: Re: [PATCH v7 1/9] Documentation: Introduce EPT based Subpage
 Protection and related ioctls
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com
References: <20191119084949.15471-1-weijiang.yang@intel.com>
 <20191119084949.15471-2-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dbf1f124-7864-b1e8-fae3-49448372d502@redhat.com>
Date:   Thu, 21 Nov 2019 11:02:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191119084949.15471-2-weijiang.yang@intel.com>
Content-Language: en-US
X-MC-Unique: h2tvIf5HOC-OzMT76IKtPg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/19 09:49, Yang Weijiang wrote:
> +
> +#define SUBPAGE_MAX_BITMAP   64

Please rename this to KVM_SUBPAGE_MAX_PAGES

> +struct kvm_subpage_info {
> +=09__u64 gfn;    /* the first page gfn of the contiguous pages */
> +=09__u64 npages; /* number of 4K pages */

This can be

=09u32 npages;
=09u32 flags;

Check that the flags are 0, and fail the ioctl if they aren't.  This
will make it easy to extend the API in the future.

> +=09__u32 access_map[SUBPAGE_MAX_BITMAP]; /* sub-page write-access bitmap=
 array */
> +};

Please make this access_map[0], since the number of entries actually
depends on npages.

Likewise, kvm_arch_vm_ioctl should read the header first, then allocate
memory for the access_map and read into it.  It's probably simpler if
you make kvm_vm_ioctl_get_subpages/kvm_vm_ioctl_set_subpages take
parameters like

int kvm_vm_ioctl_get_subpages(struct kvm *kvm, u64 gfn, u32 npages,
=09=09=09      u32 *access_map);
int kvm_vm_ioctl_set_subpages(struct kvm *kvm, u64 gfn, u32 npages,
=09=09=09      u32 *access_map);

Thanks,

Paolo

