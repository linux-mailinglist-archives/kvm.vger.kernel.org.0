Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A52017719B
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 09:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgCCIyS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 03:54:18 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20432 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727659AbgCCIyS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 03:54:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583225656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OjsWUXqjUWqBSkSGCD4PbdKz2btlJQttY4xDooxfz/U=;
        b=ADh48kCNYCMHEDMMIE7F2ggKcYH6TV9UqPz9VPM/pbLe1ikNBRhKVVhqlyIo/sOTGKBbev
        hyS2IAI8pmIpKd/UxqCuA4Tb5YfM2us/WDmgaoL0MP37oYLCBeto878fzxXyY7voYv7A9p
        ohgTOT7Ojf8DsE9yD+uLsgay3dMYFtg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-vIlAfgy9OQmk3NN8C4EYQw-1; Tue, 03 Mar 2020 03:54:15 -0500
X-MC-Unique: vIlAfgy9OQmk3NN8C4EYQw-1
Received: by mail-wr1-f71.google.com with SMTP id w11so908168wrp.20
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 00:54:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OjsWUXqjUWqBSkSGCD4PbdKz2btlJQttY4xDooxfz/U=;
        b=GVGAuJyG0lDiZcb7J2rV4B2a7B7wsAn+/iQYBZivRpSfdtFhRC6b/gMwYfUxtr2Qwa
         3hCgVfV1EwaOXrXw1ruGrEFuVJwlqsvr8+g8/Exw3aLKSH37tCPaXCDCI8GMZsF/7oJ6
         dL72H6wu7794jbaz9w2sjSepzgqyd45YPBzKWzo1UFMTUu6XbAJSYSWq7t6cCJc7R4Q3
         oQosPYwDk7GHfwE21nM5ue8E5IrEHppmhGh9toyTFCvzSu0eWPqMvrbh0Y9DgXneE9Kf
         gwN9y8l8m8dPlXJ1UxtaIT+RDMsCKaRwznO4U/RQkHjZJjYMVB8D3rhvRVA/MGOAtYXq
         PWXQ==
X-Gm-Message-State: ANhLgQ211vHYpKdNQ1C13eimZxgbkxUoxVG1OhtizsEsrO5NoKadXpIy
        1ks4tcquTIAkZE3MAJinIHNtUrNwZGTbA7vDUnP6YfMwv8IQUgg/9QqB4JZCBWznkGQG68UM863
        qWJaXSkTWdLJ5
X-Received: by 2002:adf:ce12:: with SMTP id p18mr4208154wrn.88.1583225653992;
        Tue, 03 Mar 2020 00:54:13 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtxioLATY0Il+f/lYtoQmrW/DITC8fuFwFe+1VWyWHfMfdr9VUldKUP1b6K08oPMsyN/DiChQ==
X-Received: by 2002:adf:ce12:: with SMTP id p18mr4208133wrn.88.1583225653782;
        Tue, 03 Mar 2020 00:54:13 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4c52:2f3b:d346:82de? ([2001:b07:6468:f312:4c52:2f3b:d346:82de])
        by smtp.gmail.com with ESMTPSA id t124sm3204441wmg.13.2020.03.03.00.54.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 00:54:13 -0800 (PST)
Subject: Re: [PATCH] kvm: selftests: Support dirty log initial-all-set test
To:     Jay Zhou <jianjay.zhou@huawei.com>, kvm@vger.kernel.org
Cc:     peterx@redhat.com, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangxinxin.wang@huawei.com, weidong.huang@huawei.com,
        liu.jinsong@huawei.com
References: <20200303080710.1672-1-jianjay.zhou@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f0c2dcb8-4415-eec9-d181-fb29d206c55c@redhat.com>
Date:   Tue, 3 Mar 2020 09:54:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303080710.1672-1-jianjay.zhou@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/20 09:07, Jay Zhou wrote:
>  #ifdef USE_CLEAR_DIRTY_LOG
> -	if (!kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2)) {
> -		fprintf(stderr, "KVM_CLEAR_DIRTY_LOG not available, skipping tests\n");
> +	dirty_log_manual_caps =
> +		kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
> +	if (!dirty_log_manual_caps) {
> +		fprintf(stderr, "KVM_CLEAR_DIRTY_LOG not available, "
> +				"skipping tests\n");
> +		exit(KSFT_SKIP);
> +	}
> +	if (dirty_log_manual_caps != KVM_DIRTY_LOG_MANUAL_CAPS &&
> +		dirty_log_manual_caps != KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE) {
> +		fprintf(stderr, "KVM_CLEAR_DIRTY_LOG not valid caps "
> +				"%"PRIu64", skipping tests\n",
> +				dirty_log_manual_caps);
>  		exit(KSFT_SKIP);
>  	}
>  #endif
> 

Thanks, instead of this final "if" it should be enough to do

	dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
				  KVM_DIRTY_LOG_INITIALLY_SET);


Otherwise looks good, I'll test it and eventually apply both patches.

Paolo

