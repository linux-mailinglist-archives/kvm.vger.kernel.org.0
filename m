Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6797C27F8C9
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 06:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgJAEwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 00:52:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32868 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725876AbgJAEwM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 00:52:12 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601527931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NKjfODfb+ESu0qyKcFG5xgs3P+S5ehxvQR19MLDQdYY=;
        b=Y81j6QlvvNWsAmHEkkHUQOnblWrB41rD0TB2ksvIkiL1HrtPXyer4mNZ39epF9/XGYpPnw
        bfSCZYA9EZKNUIbw8aRp4+hxqitu9+b43FdmvuQJEf0V39bYqQxBRbbRPW/MfwJKXv7ogs
        Y9RaCtJxYz+GmwiyKGgE8VwTU3241hs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-Ri76_tJBOMuPiN925uv7BQ-1; Thu, 01 Oct 2020 00:52:08 -0400
X-MC-Unique: Ri76_tJBOMuPiN925uv7BQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F34F802B7A;
        Thu,  1 Oct 2020 04:52:07 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD5D65D9D3;
        Thu,  1 Oct 2020 04:52:06 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] x86: Make Hyper-V tests x86_64 only
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20200929164325.30605-1-sean.j.christopherson@intel.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <a2003b45-f76e-1db3-046b-0be0fb4cdad1@redhat.com>
Date:   Thu, 1 Oct 2020 06:52:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200929164325.30605-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/09/2020 18.43, Sean Christopherson wrote:
> Skip the Hyper-V tests on i386, they explicitly run with kvm64 and crash
> immediately when run in i386, i.e. waste 90 seconds waiting for the
> timeout to fire.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  x86/unittests.cfg | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 3a79151..0651778 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -314,18 +314,21 @@ arch = x86_64
>  file = hyperv_synic.flat
>  smp = 2
>  extra_params = -cpu kvm64,hv_vpindex,hv_synic -device hyperv-testdev
> +arch = x86_64
>  groups = hyperv
>  
>  [hyperv_connections]
>  file = hyperv_connections.flat
>  smp = 2
>  extra_params = -cpu kvm64,hv_vpindex,hv_synic -device hyperv-testdev
> +arch = x86_64
>  groups = hyperv
>  
>  [hyperv_stimer]
>  file = hyperv_stimer.flat
>  smp = 2
>  extra_params = -cpu kvm64,hv_vpindex,hv_time,hv_synic,hv_stimer -device hyperv-testdev
> +arch = x86_64
>  groups = hyperv

Looks reasonable, but for some funny reason, this test seems to work on
Travis in the 32-bit builds:

https://travis-ci.com/github/huth/kvm-unit-tests/jobs/392615222#L699

Any idea why it is still working there?

 Thomas

