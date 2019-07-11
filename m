Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBC6C65637
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 13:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbfGKL6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 07:58:08 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37113 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728194AbfGKL6I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 07:58:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so5998636wrr.4
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 04:58:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LhDp88Y3fWDqOYh1pThyRovlQ3TYPl2m85EbCDxmY+o=;
        b=lsZjIIXpRHRFrkWnHH58CNcMTwGMiidW9OPUg24uosOYy5EeWbQiI03Cf7Gby2cffJ
         VvLzlDcMSyl3O5+OjrhTxWtmprYnvsF8NfO4ZmykBDE+YaBf6+KpiFf6h0TThwXKfFnu
         rgSD2tjH74YxkPDdUdIwc2H156kCdIqfTj53kQUwOzkB8/tuKvmeK3MeUPun6NxFpwSb
         T8SyXX9EwRTpKf3T2AGatR7MC1Yv+HGBT9GIiqeuXNFC3IQUXUjTxUoMDH7e+jnfj9T2
         sUDlbOLQSWCE2isnwdNQF+pDuwt5oH6qloGqvoCeTy8Vm/VgI4MoTeIdPqGoaWenMTa1
         6UCw==
X-Gm-Message-State: APjAAAXaABxcZPnv6AfBh8tYpvuBm4NxT6HVHDicPOP/7b9ASg+wylwx
        tNi5mc5TUUMRxb1IjgRd+tlzJO5wUL8=
X-Google-Smtp-Source: APXvYqyZ+EaNkMvzB6qQoxYUOT/tewHWhtGXmANS3yH+XaXHzBlRGqpv7h4YWkTd2dsNSPebLIHxzA==
X-Received: by 2002:adf:dcc2:: with SMTP id x2mr445302wrm.55.1562846285847;
        Thu, 11 Jul 2019 04:58:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id g10sm4549780wrw.60.2019.07.11.04.58.04
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 04:58:05 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: x86: PMU Event Filter
To:     Eric Hankland <ehankland@google.com>,
        Wei Wang <wei.w.wang@intel.com>, rkrcmar@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, kvm@vger.kernel.org
References: <CAOyeoRUUK+T_71J=+zcToyL93LkpARpsuWSfZS7jbJq=wd1rQg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <21fd772c-2267-2122-c878-f80185d8ca86@redhat.com>
Date:   Thu, 11 Jul 2019 13:58:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAOyeoRUUK+T_71J=+zcToyL93LkpARpsuWSfZS7jbJq=wd1rQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/07/19 03:25, Eric Hankland wrote:
> - Add a VM ioctl that can control which events the guest can monitor.

... and finally:

- the patch whitespace is damaged

- the filter is leaked when the VM is destroyed

- kmalloc(GFP_KERNEL_ACCOUNT) is preferrable to vmalloc because it
accounts memory to the VM correctly.

Since this is your first submission, I have fixed up everything.

Paolo
