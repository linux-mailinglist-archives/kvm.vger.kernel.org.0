Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372952737CB
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 03:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbgIVBET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 21:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728518AbgIVBET (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 21:04:19 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71919C061755;
        Mon, 21 Sep 2020 18:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=m8E8Vf5qksBX37a4kASi4E/iaS+WWUnkAWa42nHAhjg=; b=qiS7ovRSDJLAlLlHxV8YScSA/D
        ADYpxv41falafRgnGRUfs95YRpjVnTMh/me+7fWgiWuwphbH+xkqtQATwDX+1AsL130ahDXvu1aTG
        QBZvocvQjkSgnt78eqsOiHoP6SyNIs5ckBxnzEsIPBuvIiLDOFan4mIFq3VH0rUSGRBR/W8ZAsmlE
        XgFb4CMnINWDpFB1CagNZ+fqhivG8Bdwwyf6ttEKg5z1+98W37Se7NAYxxo93bw21hrxn9ny43Bmw
        dhMtbytyrQuWEec9D2pvXQTRNcM5WaLpBQB6O3kpKWgdOPq9XzKTd4ztQJ/stzoa4eekv5tAl3t3+
        AxamSgRw==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKWj7-0004eS-Db; Tue, 22 Sep 2020 01:04:13 +0000
Subject: Re: [RFC Patch 1/2] KVM: SVM: Create SEV cgroup controller.
To:     Vipin Sharma <vipinsh@google.com>, thomas.lendacky@amd.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        tj@kernel.org, lizefan@huawei.com
Cc:     joro@8bytes.org, corbet@lwn.net, brijesh.singh@amd.com,
        jon.grimm@amd.com, eric.vantassell@amd.com, gingell@google.com,
        rientjes@google.com, kvm@vger.kernel.org, x86@kernel.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dionna Glaze <dionnaglaze@google.com>,
        Erdem Aktas <erdemaktas@google.com>
References: <20200922004024.3699923-1-vipinsh@google.com>
 <20200922004024.3699923-2-vipinsh@google.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <94c3407d-07ca-8eaf-4073-4a5e2a3fb7b8@infradead.org>
Date:   Mon, 21 Sep 2020 18:04:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200922004024.3699923-2-vipinsh@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 9/21/20 5:40 PM, Vipin Sharma wrote:
> diff --git a/init/Kconfig b/init/Kconfig
> index d6a0b31b13dc..1a57c362b803 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1101,6 +1101,20 @@ config CGROUP_BPF
>  	  BPF_CGROUP_INET_INGRESS will be executed on the ingress path of
>  	  inet sockets.
>  
> +config CGROUP_SEV
> +	bool "SEV ASID controller"
> +	depends on KVM_AMD_SEV
> +	default n
> +	help
> +	  Provides a controller for AMD SEV ASIDs. This controller limits and
> +	  shows the total usage of SEV ASIDs used in encrypted VMs on AMD
> +	  processors. Whenever a new encrypted VM is created using SEV on an
> +	  AMD processor, this controller will check the current limit in the
> +	  cgroup to which the task belongs and will deny the SEV ASID if the
> +	  cgroup has already reached its limit.
> +
> +	  Say N if unsure.

Something here (either in the bool prompt string or the help text) should
let a reader know w.t.h. SEV means.

Without having to look in other places...

thanks.
-- 
~Randy

