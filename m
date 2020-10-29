Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A2829F621
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 21:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgJ2UY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 16:24:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52638 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725764AbgJ2UY6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Oct 2020 16:24:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604003097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PEJzoaoz5VMGDeqxF/G2tWA8daQ/MCiANNC2CgTlcmM=;
        b=J4DS3BzTOrwfkvDnG3fNAxRUqKXKpdZc3xm7Zd97ebiL3Zhd7SKNUVcSxxLf98irPFxjBN
        WYm2S4Wv/YlS1X8++yUpWQjWy3yqxDTBVzXW2ClA+r/ifIhHdaG6EJ4YR24cMPHf8pzAQ4
        JqDSeDyOpJFZFbMzYexA9k2/So2xX8g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-3b9w05V-MBmfeqydHOkYTw-1; Thu, 29 Oct 2020 16:24:55 -0400
X-MC-Unique: 3b9w05V-MBmfeqydHOkYTw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A37708015A4;
        Thu, 29 Oct 2020 20:24:53 +0000 (UTC)
Received: from [10.36.112.194] (ovpn-112-194.ams2.redhat.com [10.36.112.194])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E5F7C5DA30;
        Thu, 29 Oct 2020 20:24:51 +0000 (UTC)
Subject: Re: [PATCH 0/4] KVM: selftests: Add get-reg-list regression test
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, Dave.Martin@arm.com,
        peter.maydell@linaro.org
References: <20201029201703.102716-1-drjones@redhat.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <e66c22cc-3b99-b367-97e4-7d299dae4ed8@redhat.com>
Date:   Thu, 29 Oct 2020 21:24:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201029201703.102716-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/29/20 9:16 PM, Andrew Jones wrote:
> Since Eric complained in his KVM Forum talk that there weren't any
> aarch64-specific KVM selftests, now he gets to review one. 

okay ... :-)

Eric
This test
> was inspired by recent regression report about get-reg-list losing
> a register between an old kernel version and a new one.
> 
> Thanks,
> drew
> 
> 
> Andrew Jones (4):
>   KVM: selftests: Don't require THP to run tests
>   KVM: selftests: Add aarch64 get-reg-list test
>   KVM: selftests: Update aarch64 get-reg-list blessed list
>   KVM: selftests: Add blessed SVE registers to get-reg-list
> 
>  tools/testing/selftests/kvm/.gitignore        |   2 +
>  tools/testing/selftests/kvm/Makefile          |   2 +
>  .../selftests/kvm/aarch64/get-reg-list-sve.c  |   3 +
>  .../selftests/kvm/aarch64/get-reg-list.c      | 841 ++++++++++++++++++
>  .../testing/selftests/kvm/include/kvm_util.h  |   1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  52 +-
>  6 files changed, 894 insertions(+), 7 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
>  create mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list.c
> 

