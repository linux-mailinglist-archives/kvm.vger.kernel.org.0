Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4FF113F35
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 11:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbfLEKR6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 05:17:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44897 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728735AbfLEKR6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 05:17:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575541076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aVe+hiB0NVm35IcQxjwnWoKy5LGQA3iypj6zaIVprpM=;
        b=CHMhhTKdWKdUjrawSozoYlKx3odSfyqN6T+30601BZlW6Ts8JTvLlHOiWhkTpgDfC0lXjO
        GPqHkGYtQv87GNZRLIB2r2VYjUr6+lUdLG6y2BBjHVcLAj+/hwOwV90A3DPmBvxtJEMEGs
        NyCfxXfRMjgk6gUgBONxCVu5QJhR9QU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-dvFEoOs1NUSq13a5vBnguw-1; Thu, 05 Dec 2019 05:17:55 -0500
Received: by mail-wm1-f70.google.com with SMTP id o135so700095wme.2
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2019 02:17:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aVe+hiB0NVm35IcQxjwnWoKy5LGQA3iypj6zaIVprpM=;
        b=dLvteVIynN7X49V+pRDAQXNJzJYtBK42fYY3e6WyqSjDQBSbOuK6vTZ8qaolROeBC7
         HDhTzHqHOR/rivDRqpJLBfM+az4Fguh/IxhpDStgSX9GuLGSdi7maTA+tp3oSPcZtbKg
         J8H22O5muTGHDrm1oblQBtElgguNPFLAcjqKSIzA9ytZ7lZZ9pLVOKiMRHe6PAHPFZRJ
         AvwxqROWsECvamPoM6a6dAC374JoWIRNDr2Ez6GLKW71pwttyFF2ua5xKrKBiszNTJ13
         TFNq/dvtm9ZCPl3fF1lVbNm2YhIL8lA5r/G5dqP+km32ZQ1sYbVL1aK3P6UpCbo6oFY9
         I50g==
X-Gm-Message-State: APjAAAVacpGhDhHEim5blgnM4FX8PTy/TZe0XUmFbxMjSSb1uUkWlBS/
        oTagJKd7vCT2xDrK1oGffN5r00/ViiP+U+ZVOAXr5DSSuwgLJ6WWSbml8kYIfO70Ok6nTCq70M6
        47ucK9BWwKbc6
X-Received: by 2002:adf:fd91:: with SMTP id d17mr9674004wrr.340.1575541074813;
        Thu, 05 Dec 2019 02:17:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqyGdy2vE00g8ehE5AMbdnywSsS5LuhGHxYsDEhmqo75DP8TLwpiW3ASkcpj5mz5XJVf2fE86g==
X-Received: by 2002:adf:fd91:: with SMTP id d17mr9673984wrr.340.1575541074592;
        Thu, 05 Dec 2019 02:17:54 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:541f:a977:4b60:6802? ([2001:b07:6468:f312:541f:a977:4b60:6802])
        by smtp.gmail.com with ESMTPSA id y10sm1264712wmm.3.2019.12.05.02.17.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 02:17:54 -0800 (PST)
Subject: Re: [PATCH] KVM: vmx: remove unreachable statement in
 vmx_get_msr_feature()
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1575512678-22058-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8d252227-4993-d387-1c78-62ac8c32ebd9@redhat.com>
Date:   Thu, 5 Dec 2019 11:17:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1575512678-22058-1-git-send-email-linmiaohe@huawei.com>
Content-Language: en-US
X-MC-Unique: dvFEoOs1NUSq13a5vBnguw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/12/19 03:24, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> We have no way to reach the final statement, remove it.
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e7ea332ad1e8..e58a0daf0f86 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1781,8 +1781,6 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
>  	default:
>  		return 1;
>  	}
> -
> -	return 0;
>  }
>  
>  /*
> 

Queued, thanks.

Paolo

