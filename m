Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BA339A313
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 16:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbhFCO0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 10:26:11 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:41140 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbhFCO0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 10:26:10 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2F175219E0;
        Thu,  3 Jun 2021 14:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622730265; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tbjClczC5gLA40sfe00ZY+sFYsbC5ZyzMkvNM/TuESQ=;
        b=QtkRLvg20PZ7YGn5NdiCEJqPNf/Zv4bL7TFdEkY/JxW421v/6SjTYeMzpQJWDR8yeQ/n0B
        IXN/AKOLFp0q0dE3YTa/BNyMttqWLdwzjxcHUQqrh0isc6WUrEbF+Oa2zrr8ij5s4/qjBR
        tdd0CqmYVRj/rMGSry9xqlxnZn7wdFo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622730265;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tbjClczC5gLA40sfe00ZY+sFYsbC5ZyzMkvNM/TuESQ=;
        b=Sh/r/huz0fYA2VtYIU9Uh3QGx7jUNzl5QyUDMS/jCGiulDIPzy6ilhGFDHeW63qb9Dhi5D
        7yxfes146ZMYyVAw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 8E6E0118DD;
        Thu,  3 Jun 2021 14:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622730265; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tbjClczC5gLA40sfe00ZY+sFYsbC5ZyzMkvNM/TuESQ=;
        b=QtkRLvg20PZ7YGn5NdiCEJqPNf/Zv4bL7TFdEkY/JxW421v/6SjTYeMzpQJWDR8yeQ/n0B
        IXN/AKOLFp0q0dE3YTa/BNyMttqWLdwzjxcHUQqrh0isc6WUrEbF+Oa2zrr8ij5s4/qjBR
        tdd0CqmYVRj/rMGSry9xqlxnZn7wdFo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622730265;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tbjClczC5gLA40sfe00ZY+sFYsbC5ZyzMkvNM/TuESQ=;
        b=Sh/r/huz0fYA2VtYIU9Uh3QGx7jUNzl5QyUDMS/jCGiulDIPzy6ilhGFDHeW63qb9Dhi5D
        7yxfes146ZMYyVAw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id R/s+IBjmuGDDSQAALh3uQQ
        (envelope-from <cfontana@suse.de>); Thu, 03 Jun 2021 14:24:24 +0000
Subject: Re: [PATCH v2 0/2] Fixes for "Windows fails to boot"
To:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     "Michael S . Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>, qemu-devel@nongnu.org
References: <20210603123001.17843-1-cfontana@suse.de>
From:   Claudio Fontana <cfontana@suse.de>
Message-ID: <1da75e95-1255-652e-1ca3-d23a8f6bf392@suse.de>
Date:   Thu, 3 Jun 2021 16:24:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210603123001.17843-1-cfontana@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/3/21 2:29 PM, Claudio Fontana wrote:
> v1 -> v2:
>  * moved hyperv realizefn call before cpu expansion (Vitaly)
>  * added more comments (Eduardo)
>  * fixed references to commit ids (Eduardo)
> 
> The combination of Commits:
> f5cc5a5c ("i386: split cpu accelerators from cpu.c"...)                                                                              
> 30565f10 ("cpu: call AccelCPUClass::cpu_realizefn in"...) 
> 
> introduced two bugs that break cpu max and host in the refactoring,
> by running initializations in the wrong order.
> 
> This small series of two patches is an attempt to correct the situation.
> 
> Please provide your test results and feedback, thanks!
> 
> Claudio
> 
> Claudio Fontana (2):
>   i386: reorder call to cpu_exec_realizefn in x86_cpu_realizefn
>   i386: run accel_cpu_instance_init as instance_post_init
> 
>  target/i386/cpu.c         | 89 +++++++++++++++++++++++++--------------
>  target/i386/kvm/kvm-cpu.c | 12 +++++-
>  2 files changed, 68 insertions(+), 33 deletions(-)
> 

Btw, CI/CD is all green, but as mentioned, it does not seem to catch these kind of issues.

https://gitlab.com/hw-claudio/qemu/-/pipelines/314286751

C.

