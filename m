Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAEF2108E4
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 12:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729716AbgGAKFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 06:05:45 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26894 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729057AbgGAKFo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Jul 2020 06:05:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593597943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=li9kQYxVCnOWZjNd5oQ1bpoIqi+vU3V1yJrJ39eSBFg=;
        b=RBVwPN/PALEhlJCeTmN1zGxhN+oURKXrR8g0+hI60FmMd6zQLYxIJTlsXfRTsMotz9BFGg
        jpJGPBwbruyP4/audVBRhJmi8WxiRJcYL14I9y0caTIIaPN4VnebVN2Q44ieuUtgaOUfbJ
        lZoHbjJH4Za/eD1DIIlRtICqSe746rA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-gD1oVM58Oc25VykIQsCcUQ-1; Wed, 01 Jul 2020 06:05:41 -0400
X-MC-Unique: gD1oVM58Oc25VykIQsCcUQ-1
Received: by mail-ej1-f72.google.com with SMTP id op28so12952079ejb.15
        for <kvm@vger.kernel.org>; Wed, 01 Jul 2020 03:05:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=li9kQYxVCnOWZjNd5oQ1bpoIqi+vU3V1yJrJ39eSBFg=;
        b=rr3rBqi8hYiqz8qFfSh2AScIKc37oOTUVVvIZjnrYDdpcQQS60uKL/YaQs9lF8oqgb
         WatcJApiQHuGZT0ZSn5oI3dW4+QcsIF9ZGrFdc0L9go/r0SrLqENJmR8TSYCydAuE9ND
         994NC3ETTpAtAEEMIiK9dii/ybh4t3BX7S/BzRZuWT2hEXdk3Ein09ZCiD3SlLwGeVeW
         Fh5wFyarP7M0c9Z25PtUQINEdYR4mn+ot0V2XiY/Kkz8cd+fkHOce5/evqG/5i+Z/SY5
         hy0SyUMx+EM0h2MhqFSZQueXvL6aNQZHFEHJRJbau832r3I7UxldmG1AFjQCahkcdw9b
         +Fgg==
X-Gm-Message-State: AOAM533qWPPOd13uDtStbImm/XLnxo3qV83hSwm6gDDB5CLkmpFiHoxX
        CwzoGrRhtk303mJ37sqP85o54KGPuLxwxvaR1qAETVS3JaNRdSrRj2qa/272gyxrx/vDGhxMe2+
        O/WQRH7B4QKIs
X-Received: by 2002:a17:907:7245:: with SMTP id ds5mr21983630ejc.1.1593597940403;
        Wed, 01 Jul 2020 03:05:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHvzskXgfVlBxP5vb4TvAlruikyK7KVp4OUyw+FNTlg8IZLazZ6bkS/SUTM94YDYowVPxbtA==
X-Received: by 2002:a17:907:7245:: with SMTP id ds5mr21983617ejc.1.1593597940213;
        Wed, 01 Jul 2020 03:05:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1142:70d6:6b9b:3cd1? ([2001:b07:6468:f312:1142:70d6:6b9b:3cd1])
        by smtp.gmail.com with ESMTPSA id p18sm4339638ejm.55.2020.07.01.03.05.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 03:05:39 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] scripts: Fix the check whether testname is
 in the only_tests list
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
References: <20200701094635.19491-1-pbonzini@redhat.com>
 <db772d67-a16a-086b-bfc3-e9348ea27c16@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a972d2db-4c41-3140-2716-f797ed27f440@redhat.com>
Date:   Wed, 1 Jul 2020 12:05:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <db772d67-a16a-086b-bfc3-e9348ea27c16@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/07/20 11:52, Thomas Huth wrote:
>>   +function find_word()
>> +{
>> +    grep -q " $1 " <<< " $2 "
>> +}
> 
> Ah, clever idea with the surrounding spaces here!

That's what you gain from learning to program in GW-BASIC, who wants
regular expression when you have INSTR.

But seriously: what do you think about adding "-F"?  The use of regex in
only_tests/only_group is not documented and might have surprising
effects.  If we want to keep it, we could replace spaces with newlines
and use ^$ in the regex.

Paolo

> Works great for me, so:
> Tested-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 

