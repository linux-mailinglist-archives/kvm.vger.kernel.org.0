Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4C8365463
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 10:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhDTInk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 04:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbhDTInj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 04:43:39 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3776C061763;
        Tue, 20 Apr 2021 01:43:06 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id i3so18351595edt.1;
        Tue, 20 Apr 2021 01:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BwiYHNH+mzbQq1eWxaZN8VLk/WYh0GnoED1nQWvWtlM=;
        b=mJHYEsy0lrq44tQ+HV9EvTSkNRw4inlVFLXWsZclHsxdHs82zS976sBpxS7NIhN2ol
         GPECx+bHIZBqp6PX/BPIprETq8ACwhe00CnhkhatuOVpLRtpLeXgf+McP4cLTvR0Ci43
         j7jLt39ksPXVmJScAV9jUqCbVu2VI1HWEPp6sKIYANW0a3nN5L7DeR12QlYsRpwdJ/7G
         G9qSZWcUWWDSYallI4Q+mwgcsBa4t/9rFl3MFiAs0dk2tjjklZm1sty2kNbxep8o1Oaw
         nHO/Ltq4diyCeUzF9T/eeqWN7jBuorGKs5H42qHAcqBgBgcEjFS1v28rkCLjDwN4UT5L
         RoZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:from:to:cc:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BwiYHNH+mzbQq1eWxaZN8VLk/WYh0GnoED1nQWvWtlM=;
        b=q/lHnu4vHt+n8uVm3Y3PQIa9QxYUkZqrPvl9ALJNaSqI5GCGVgY1hcIeLefkO/TY17
         tT8h9BK6K3Q7auTgJfJLXKkNNpgGTL8LEykJ4qqk1WkDyI87mhD53rMkMg2dfCs2ps+r
         Pq4/irMeHTrJzA4tKV9Sw2EFrrf9+m+Zf4H3QTbX1ikYZco9nrdKh2UE4NfXPwAEI4Wr
         zSCQHN+5zQa6odZlh/viZ2YJCM9fPXOFrUQgrSgATL6aBY3m+W+LDfkrOKyiqG8phILd
         uZX+Q5D/ZdATIWXOac9lUFm+6qk0dRw5NK59z28FIsLuBWYy/0HZ619BWeNePRRSTNT8
         zPCg==
X-Gm-Message-State: AOAM531WKChE7ErNVS41IkqahJuPIKykHKoeUEIcYOsd8sxMkBKTmg8l
        8Pd6fLpDaPUOvumB0/wUZ/s=
X-Google-Smtp-Source: ABdhPJyC9JIykvgwTnfUEH0x4tVqlqI2+qe31PFE0KqeHFJLznCSXwIKZMHBi33MYbpDYp5vr1ObHA==
X-Received: by 2002:a05:6402:1109:: with SMTP id u9mr31265496edv.174.1618908185613;
        Tue, 20 Apr 2021 01:43:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id c13sm8995334edw.88.2021.04.20.01.43.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 01:43:05 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Subject: Re: [PATCH v13 05/12] KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA
 command
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <c5d0e3e719db7bb37ea85d79ed4db52e9da06257.1618498113.git.ashish.kalra@amd.com>
 <d4488123-daac-3687-6f8d-fb54d6bd4019@redhat.com>
Message-ID: <f713a9ff-925c-0eaf-c9d3-297efece6d26@redhat.com>
Date:   Tue, 20 Apr 2021 10:43:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <d4488123-daac-3687-6f8d-fb54d6bd4019@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/21 10:40, Paolo Bonzini wrote:
> On 15/04/21 17:55, Ashish Kalra wrote:
>> +    if (!guest_page)
>> +        goto e_free;
>> +
> 
> Missing unpin on error (but it won't be needed with Sean's patches that 
> move the data block to the stack, so I can fix this too).

No, sorry---the initialization order is different between 
send_update_data and receive_update_data, so it's okay.

Paolo
