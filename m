Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87B48177198
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 09:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbgCCIxy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 03:53:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51728 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727112AbgCCIxx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 03:53:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583225632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uA9jSqeJ7YM+hlM0Q0AtYm6l/6Ib8O+uDltLoDfxB+M=;
        b=FQCbEyejigaDVf/O9fb3la57nVFhVeY8fBjzISJ/mLf6JtW3F+/DHdK6kgAqoU+dUVSI21
        P9P+baqjSjx43bIP/7wd2MeeYQTroBmbRugtJYAqKnm0wwoqLJfDXQx3PAjMero0EVugGe
        P9FMz1Xr+csgTU5pE/1Nw/SNqo1o/cs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-0_U6i6NhPniUtTJCBQWhHQ-1; Tue, 03 Mar 2020 03:53:50 -0500
X-MC-Unique: 0_U6i6NhPniUtTJCBQWhHQ-1
Received: by mail-wm1-f71.google.com with SMTP id w3so376400wmg.4
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 00:53:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uA9jSqeJ7YM+hlM0Q0AtYm6l/6Ib8O+uDltLoDfxB+M=;
        b=EfZTkCOXoJUqasLRRT0XPKiIlOSZkZFu4+SylgDfq2d5Arho8HoqrMj+NFKCpv8LNs
         vrF8/iikjndyLLTFJr6jBUvXaSWWYY/qCQniR24w85h4irAKvMyVMVS4Mp/WJADK1KK4
         XzpUW/9k8FUDKOl+ahPPG4POQ5jR0FpSXeff+tGxENBhHRjFSQk1wPcuRZKoHCjWO14v
         4R7gLcVMDydJrn/W/lqk8xinQMlbUy/kvj4I20OxIwmvpFdhXgHOK2mf5Moz+j7FQHGb
         7OLuociDAur2uFexdv+EwJf8T5YLjSdnKJNor4SZa5aZNKodR7Hl8Keu/ZG4Iurr9Sz9
         9NYQ==
X-Gm-Message-State: ANhLgQ1tikMonwACaSfV2/pU4VoRcadz7hgai8K0g1zkekt+zRmp1Skf
        IUFJ01MR0xdXy6RdLtnd3zcbRqn9cPbwlaK5WSqRaVBh/GzD4pDNptIbkjxEDQ7L0oZmNJS+XGF
        RMMN2NZr5SUy9
X-Received: by 2002:a05:600c:20c7:: with SMTP id y7mr1606816wmm.77.1583225629641;
        Tue, 03 Mar 2020 00:53:49 -0800 (PST)
X-Google-Smtp-Source: ADFU+vu19cWQ55lE5QJmKdvRAzYW7XwuOB682RJTOOcVGWM8jkkZxs+1Z+TsKH/j2igC9PJlcNhr6g==
X-Received: by 2002:a05:600c:20c7:: with SMTP id y7mr1606787wmm.77.1583225629387;
        Tue, 03 Mar 2020 00:53:49 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4c52:2f3b:d346:82de? ([2001:b07:6468:f312:4c52:2f3b:d346:82de])
        by smtp.gmail.com with ESMTPSA id b10sm2788680wmh.48.2020.03.03.00.53.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 00:53:48 -0800 (PST)
Subject: Re: [PATCH] kvm: selftests: Support dirty log initial-all-set test
To:     Jay Zhou <jianjay.zhou@huawei.com>, kvm@vger.kernel.org
Cc:     peterx@redhat.com, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangxinxin.wang@huawei.com, weidong.huang@huawei.com,
        liu.jinsong@huawei.com
References: <20200303080710.1672-1-jianjay.zhou@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0ec6b946-fa0e-6a18-0a49-f0b509cf2ced@redhat.com>
Date:   Tue, 3 Mar 2020 09:53:49 +0100
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

	dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
				  KVM_DIRTY_LOG_INITIALLY_SET);


Paolo

