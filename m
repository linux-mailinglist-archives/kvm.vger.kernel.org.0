Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C422B439F
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 13:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbgKPMYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 07:24:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26396 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729949AbgKPMYk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 07:24:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605529479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UM/ABfi+/syVhnP4yG6m6X6R1GzVL7daF9JUOGGr584=;
        b=DsxQSrAmBgIAl7UWr/eV/0hsrXhxGEYFpOKfqwG0tBGVqDvNW1+Ti4ZB/sq+fCaD1ubHnO
        4CTT74srxney3UHTs5dG3arg3Io0txf++hLUlQ79N2OlzCqIPlVV+ojjdHbV7AEOgWDR7x
        O6MZUyBP2eFQuHQSeVz8daTR9dYiBRY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-uTFqHfIKNIik4khOsx1qOQ-1; Mon, 16 Nov 2020 07:24:37 -0500
X-MC-Unique: uTFqHfIKNIik4khOsx1qOQ-1
Received: by mail-wr1-f69.google.com with SMTP id y2so11122000wrl.3
        for <kvm@vger.kernel.org>; Mon, 16 Nov 2020 04:24:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UM/ABfi+/syVhnP4yG6m6X6R1GzVL7daF9JUOGGr584=;
        b=TE2tyjihXn8zrCoJArr7KPm+3OZ6jLq+WhcytX72q1sj94bDDsAtKybbI7o/RXzgGm
         f5jU1WZ/4d8axieCL5wv4QP45hF9GXoDwjG2DgL3AAUY0a5pAoer/QDA/zsEXCSSabf+
         kYa/t2UeMEYin+JglexKgsfJVc7CYJBKohxXEXQMnlX7oDw0v18pnDYnbZy4W186kySt
         +Fc/RVGd8Ur69uekGXdBWzIYGitr1g6OKM84QER3BVGRxgRFiajqrlLbFVBcrsm35CUI
         JyEYLzpQn8QTCiwimOQKaSn/AHnyDlk3FFv68rQWiILwGm68891fOF841D6aGMvh3fFY
         N2fw==
X-Gm-Message-State: AOAM530G5pDIN8TEYd2+SeO5wktjPpYBuki0gG/vcySnJnMPCx6DGHro
        rGukr6EbhGThLf0M7s2VUU1JrYiRGSb7XOaUq5L6g9MmDi94eeZq9kwD+3Rf9Xdou/iNMBpzDmt
        T11CRZDbr0O5B
X-Received: by 2002:a7b:cc94:: with SMTP id p20mr15636529wma.100.1605529476457;
        Mon, 16 Nov 2020 04:24:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwsfMZJA02JzcuICSoT8McAorEooar+jkl3VIbg+y9cNrGEcD4h0oz76if9obwM4WGwiuOxHQ==
X-Received: by 2002:a7b:cc94:: with SMTP id p20mr15636514wma.100.1605529476213;
        Mon, 16 Nov 2020 04:24:36 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v67sm20421976wma.17.2020.11.16.04.24.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 04:24:35 -0800 (PST)
Subject: Re: [PATCH v2 06/11] KVM: selftests: dirty_log_test: Remove create_vm
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
References: <20201111122636.73346-1-drjones@redhat.com>
 <20201111122636.73346-7-drjones@redhat.com>
 <5a580018-21ea-1222-b3aa-a6de284596ea@redhat.com>
 <20201116121648.w7szgu36fb2tqdi4@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ff778aca-d706-ffef-fb90-3b7fd81156fb@redhat.com>
Date:   Mon, 16 Nov 2020 13:24:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201116121648.w7szgu36fb2tqdi4@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/11/20 13:16, Andrew Jones wrote:
>> This one (even after fixing conflicts) breaks the dirty ring test.
>>
> Maybe the problem was patch 3/11 was missing? For me after rebasing
> 3/11 this patch applied cleaning and worked. The only change I made
> was to address Peter's nit.

Yes, the conflicts in patch 3 were a bit too large so I dropped it.  It 
wasn't clear from the commit message that it was required later on.

Paolo

