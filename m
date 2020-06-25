Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F6B2099B5
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 08:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389961AbgFYGHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 02:07:36 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57202 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389406AbgFYGHg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 02:07:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593065255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FQbbjNDvvpUJ/1LEDglh3sGqlEX/HTTM/X4NUKusvZ8=;
        b=H8fiU1S9upN3+u6wZXQEZEyQ4ozaBvEJBZ0n7CGYnSX6tXf+P2T4nDcUSXX1uFUWrKQrLq
        P1mMB37yZiRxW2q14uY6vjfjgnwb9ffg2fcMFl33tuMYZrDZeobo2mQUvub/BKJQ6sV19N
        jKfc5U85Qkgdtu3nLG5MFh1UzzD67xY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-7ZFQa0EKME-cr98Kjm7nWw-1; Thu, 25 Jun 2020 02:07:33 -0400
X-MC-Unique: 7ZFQa0EKME-cr98Kjm7nWw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C153107ACCA
        for <kvm@vger.kernel.org>; Thu, 25 Jun 2020 06:07:32 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-150.ams2.redhat.com [10.36.112.150])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E59160C87;
        Thu, 25 Jun 2020 06:07:28 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] x86: move IDT away from address 0
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     mcondotta@redhat.com
References: <20200624165455.19266-1-pbonzini@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <97958669-4194-de78-48bf-2cee82868884@redhat.com>
Date:   Thu, 25 Jun 2020 08:07:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200624165455.19266-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/2020 18.54, Paolo Bonzini wrote:
> Address 0 is also used for the SIPI vector (which is probably something worth
> changing as well), and now that we call setup_idt very early the SIPI vector
> overwrites the first few bytes of the IDT, and in particular the #DE handler.
> 
> Fix this for both 32-bit and 64-bit, even though the different form of the
> descriptors meant that only 32-bit showed a failure.
> 
> Reported-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   x86/cstart.S   | 10 +++++++---
>   x86/cstart64.S | 11 ++++++++++-
>   2 files changed, 17 insertions(+), 4 deletions(-)

Thanks, this fixes the eventinj test for me!

Tested-by: Thomas Huth <thuth@redhat.com>

