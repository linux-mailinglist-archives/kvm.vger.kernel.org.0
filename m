Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EC041188F
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 17:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241926AbhITPpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 11:45:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33534 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241924AbhITPpM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 11:45:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632152625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XqisE4WfjzLEBI/vcCXLVbkyLu5RD1pa7H+m3eS6YPY=;
        b=RAJUBbLwa7hA2LIbUWjnwmVJYYXVAAAAFTVDz9MZkSFlCYjn7nWcclgx5YB8XZnnZpqVY2
        lAOjxq/0TJ3XpkVyoni7EpophYWOwm3yWu+0GeDPNJ+iy1H5GR+fDFskWkFsZ11NNG3eqk
        kykAPOhfqVryr+XmwldbJutEU7yrOik=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-voaKD0ZgOreqCap1Xyh4Kg-1; Mon, 20 Sep 2021 11:43:44 -0400
X-MC-Unique: voaKD0ZgOreqCap1Xyh4Kg-1
Received: by mail-wr1-f72.google.com with SMTP id q14-20020a5d574e000000b00157b0978ddeso6454693wrw.5
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 08:43:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XqisE4WfjzLEBI/vcCXLVbkyLu5RD1pa7H+m3eS6YPY=;
        b=eRj49dmWNgZmzfo5L1jqq3d9C2RxY5PYa9jWHIfkKq8zCCGWs09Sn0rvn2x34BdZej
         TjJ8/L1p1oqaALVKYWn5w9sx31aDP3rsSIadsVX07aEu8Buq4FuEBfNTqYB26bGIcm4Y
         M7hCjGoLJ9itLVTkU76tdbM2ZlF0uSZxoScbWl6H55o9gywvF4uogCPs68fe+g+s9beL
         SHjZOmw0IrYM++pgqjhSBqHGIPzvjcFOAzDOkpOGQb0hs0bzFDFB9TvePaxmoNOHDrwK
         wRYAsXYJK7F7MxuFkYa5woAb4EsU//TmXJv0O/wnjuVjn/nHwSpFRX46jhMwNXEK6+g5
         xqmQ==
X-Gm-Message-State: AOAM533KIce20EQOKlwDP2yLbWavKJVAT2wrwIzYAB6nEyg1/X+2YNak
        I2ZWqctdqCG0p6Vyg6dqNovbwFNWKOCTaOtBl8GSagdnsvEBfigaZZ80/WTlRt6gCyyp6Axg2uq
        fUV7TnLoTGH4h
X-Received: by 2002:a05:6000:362:: with SMTP id f2mr29435864wrf.197.1632152621933;
        Mon, 20 Sep 2021 08:43:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyAKD0kjI1mrMJOgGJDO9FB/RUyz+hEk7ECIPNr5br7Rcu6bWHLvzguml01v62wiLSCnQ3Y+w==
X-Received: by 2002:a05:6000:362:: with SMTP id f2mr29435827wrf.197.1632152621671;
        Mon, 20 Sep 2021 08:43:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l21sm15240572wmh.31.2021.09.20.08.43.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 08:43:41 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 09/17] x86 UEFI: Set up page tables
To:     Zixuan Wang <zixuanwang@google.com>, kvm@vger.kernel.org,
        drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-10-zixuanwang@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3fd467ae-63c9-adba-9d29-09b8a7beb92d@redhat.com>
Date:   Mon, 20 Sep 2021 17:43:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210827031222.2778522-10-zixuanwang@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/21 05:12, Zixuan Wang wrote:
> +static void setup_page_table(void)

It would also be nice if cstart64.S reused setup_page_table, but unlike 
GDT/IDT/TSS I guess it's not super-necessary.

Paolo

