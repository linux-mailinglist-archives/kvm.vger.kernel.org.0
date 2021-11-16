Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840E1453645
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 16:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238484AbhKPPtJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 10:49:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46283 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237729AbhKPPtC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 10:49:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637077564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S5ieD8y2xapJMDpBNxLswvuhHU74jKB1oJVgEzv7nl4=;
        b=TugBVB8+TYEHb0R+qlRdGj4YfBLzEgpYSNwRWA07UwpIkF/BcDKp8gn/Q5oBD4Rx5ZXxKa
        IUc0+mPNVQhm1bT13G5WLxYQp3sx5h2NzWgfOqNbd8C4ozfdW6mHR9avXYAc5LqW0IOFEa
        oINPMB2RfosQ3gwQDPmUCYpakxX1CU8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-QfyiMcWqORqR01RxLfCrew-1; Tue, 16 Nov 2021 10:46:01 -0500
X-MC-Unique: QfyiMcWqORqR01RxLfCrew-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB142101F001;
        Tue, 16 Nov 2021 15:45:59 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6024960C0F;
        Tue, 16 Nov 2021 15:45:57 +0000 (UTC)
Message-ID: <2770fc4e-cbb2-07bc-681f-6f4a29827b7d@redhat.com>
Date:   Tue, 16 Nov 2021 16:45:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/1] selftests: KVM: Add /x86_64/sev_migrate_tests to
 .gitignore
Content-Language: en-US
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <YZPIPfvYgRDCZi/w@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YZPIPfvYgRDCZi/w@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 16:03, Arnaldo Carvalho de Melo wrote:
>    $ git status
>    nothing to commit, working tree clean
>    $
>    $ make -C tools/testing/selftests/kvm/ > /dev/null 2>&1
>    $ git status
> 
>    Untracked files:
>      (use "git add <file>..." to include in what will be committed)
>    	tools/testing/selftests/kvm/x86_64/sev_migrate_tests
> 
>    nothing added to commit but untracked files present (use "git add" to track)
>    $
> 
> Fixes: 6a58150859fdec76 ("selftest: KVM: Add intra host migration tests")
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Peter Gonda <pgonda@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>   tools/testing/selftests/kvm/.gitignore | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index d4a8301396833fc8..3763105029fb3b3c 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -23,6 +23,7 @@
>   /x86_64/platform_info_test
>   /x86_64/set_boot_cpu_id
>   /x86_64/set_sregs_test
> +/x86_64/sev_migrate_tests
>   /x86_64/smm_test
>   /x86_64/state_test
>   /x86_64/svm_vmcall_test
> 

Queued, thanks.

Paolo

