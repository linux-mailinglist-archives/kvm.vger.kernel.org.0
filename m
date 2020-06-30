Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B2120F35C
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 13:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732807AbgF3LGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 07:06:13 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31630 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbgF3LGM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jun 2020 07:06:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593515170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cnFIGetcwbVSZpWesLt/qU2CyjQtIMdEkML+yF3k6Ak=;
        b=Gm+n3P1R+qS53LoGYWR3YvkYBmin4j1f7ettJxoAeakoa3NLYlZNBLxyc7aK8an6DikMNE
        d5m2GBRll9VhEGfiAcOlsCHazXN23baMk1j2wd9YbtXpwWQ5745hcQlR2tbbt/9DdqsmO6
        AyjV37vLAGuWzZR1lgks2N/jF+gVVqY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-suefEhYGMh-tbjpJ2TRc6w-1; Tue, 30 Jun 2020 07:06:09 -0400
X-MC-Unique: suefEhYGMh-tbjpJ2TRc6w-1
Received: by mail-wm1-f72.google.com with SMTP id z11so20706632wmg.5
        for <kvm@vger.kernel.org>; Tue, 30 Jun 2020 04:06:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cnFIGetcwbVSZpWesLt/qU2CyjQtIMdEkML+yF3k6Ak=;
        b=uaV6KKpQa8iukEQc0LdcHXlPJQCvrQPAgI9sbyzuCGELrU7NOpYBMmZ3tFsLTkAVAF
         ksImkeH0R7WlWtZOlVM+OwnGIZgmVj/B/JvUrF9PcehJZkXHMQ65JO+SDRWMId1pkZLg
         tql1XAxde6OxXJtWQxOqqeADykcjpZFF4vCw+3A4tTQjkUfrGVBNUiJ9Ke84XtpUk3pc
         ix0tAppPnKYspVMEVtaF9OckfpckgFL2U/zAdVsDZSNQPYeSrhu5+iGzO43qxSA8BN6F
         9/bpy0hDlbuyPE9rxALJ+F/A4kRDO46W7+vnivcsa1uwpgyZFJifADSXkoe9gK7Hxl6H
         pL6w==
X-Gm-Message-State: AOAM530Hd1I0xIabjZkGd9i6YeBIBPs+pAVCsl+BADqLxLm16eMa/9TG
        wIrkHlDhE9K0xaOknZ9d5QULkoMR2gyC8ERKwqZRjPeXx9HpQNueLfcH0fnB3gfAMbhpLC/recZ
        21zmxbwXHdpBZ
X-Received: by 2002:a5d:4b84:: with SMTP id b4mr22421190wrt.334.1593515167634;
        Tue, 30 Jun 2020 04:06:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBjypSCSAbWQNUFfpQuNm1ll95g6cdGIHaECloUwW4eKmJ0EHPo6DZFBDCz2eeeW7f9gmM4Q==
X-Received: by 2002:a5d:4b84:: with SMTP id b4mr22421175wrt.334.1593515167449;
        Tue, 30 Jun 2020 04:06:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:acad:d1d4:42b8:23e4? ([2001:b07:6468:f312:acad:d1d4:42b8:23e4])
        by smtp.gmail.com with ESMTPSA id b23sm3388374wmd.37.2020.06.30.04.06.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 04:06:06 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 4/5] x86: svm: wrong reserved bit in
 npt_rsvd_pfwalk_prepare
To:     Nadav Amit <namit@vmware.com>
Cc:     kvm@vger.kernel.org
References: <20200630094516.22983-1-namit@vmware.com>
 <20200630094516.22983-5-namit@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <eebb5fff-6090-e9ed-d604-d692054e9f6e@redhat.com>
Date:   Tue, 30 Jun 2020 13:06:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200630094516.22983-5-namit@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/06/20 11:45, Nadav Amit wrote:
> According to AMD manual bit 8 in PDPE is not reserved, but bit 7.

Indeed.  Maybe it was a problem in the previous versions because I
remember adding this check explicitly.  I've sent a patch.

Paolo

> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  x86/svm_tests.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 92cefaf..323031f 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -825,13 +825,13 @@ static void npt_rsvd_pfwalk_prepare(struct svm_test *test)
>      vmcb_ident(vmcb);
>  
>      pdpe = npt_get_pdpe();
> -    pdpe[0] |= (1ULL << 8);
> +    pdpe[0] |= (1ULL << 7);
>  }
>  
>  static bool npt_rsvd_pfwalk_check(struct svm_test *test)
>  {
>      u64 *pdpe = npt_get_pdpe();
> -    pdpe[0] &= ~(1ULL << 8);
> +    pdpe[0] &= ~(1ULL << 7);
>  
>      return (vmcb->control.exit_code == SVM_EXIT_NPF)
>              && (vmcb->control.exit_info_1 == 0x20000000eULL);
> 

