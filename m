Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7D8240443
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 11:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgHJJxL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 05:53:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59029 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725846AbgHJJxL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 05:53:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597053190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IP2F52KSt4X5jHWk8vXdUJy0v08nuP4eh32SzgUyWLQ=;
        b=Puhkvom7/Ha2u57uDdC64uV6BPDMXL1grpfx95YRxtwI3gn7Q6kjUJymoqe9ky6cv078gQ
        x681d0Vth8SY6oWmnxjBYSPANBhlhu2X6xUehD8wXV2vq81YilOSBtXbw2xyr4vJ7ncq49
        3u0Ycc/dFp8Dufz/W2PTVVp0NxOFUXA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-YaRtKwn5MtufzxMRwcQp1Q-1; Mon, 10 Aug 2020 05:53:08 -0400
X-MC-Unique: YaRtKwn5MtufzxMRwcQp1Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 437EC19057B1;
        Mon, 10 Aug 2020 09:53:07 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BE9089539;
        Mon, 10 Aug 2020 09:53:05 +0000 (UTC)
Date:   Mon, 10 Aug 2020 11:53:02 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     jmattson@google.com, graf@amazon.com, pshier@google.com,
        oupton@google.com, kvm@vger.kernel.org
Subject: Re: [PATCH 6/6] selftests: kvm: Add test to exercise userspace MSR
 list
Message-ID: <20200810095302.ixmtlowbplabgj3g@kamzik.brq.redhat.com>
References: <20200804042043.3592620-1-aaronlewis@google.com>
 <20200804042043.3592620-7-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804042043.3592620-7-aaronlewis@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 03, 2020 at 09:20:43PM -0700, Aaron Lewis wrote:
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> index da4d89ad5419..a3489973e290 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> @@ -40,6 +40,9 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
>  	struct kvm_run *run = vcpu_state(vm, vcpu_id);
>  	struct ucall ucall = {};
>  
> +	if (uc)
> +		memset(uc, 0, sizeof(*uc));
> +
>  	if (run->exit_reason == KVM_EXIT_IO && run->io.port == UCALL_PIO_PORT) {
>  		struct kvm_regs regs;
>

This is a fix that should be in a separate patch, and please patch the
other architectures too.

Thanks,
drew  

