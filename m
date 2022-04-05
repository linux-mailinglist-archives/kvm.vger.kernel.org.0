Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607BF4F498E
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442690AbiDEWTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445977AbiDEPnz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 11:43:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB92A19532E
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 07:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649167830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4VpbSrB1Dcjr9uq5ClWUOMNjtNo7OeAGb6rOgQHDZtI=;
        b=F7zRjJWjip76BGrBVGQa67kMD+g/eGkHjTdqoQRSb0af/sMak156rMayi6CVefJQRLpxls
        MnGo9QBdnDadF5G9RnRlUXbDTOAkrlO6T/rAmtTTIku/JHoEW8ATlsJn4OIREonyCS7DH5
        ivftIWOeRgAHgIRGcqrQz7RKISdWA/I=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-vMTH7H7ENF-AtAJ75izqNQ-1; Tue, 05 Apr 2022 10:10:29 -0400
X-MC-Unique: vMTH7H7ENF-AtAJ75izqNQ-1
Received: by mail-qt1-f199.google.com with SMTP id h11-20020a05622a170b00b002e0769b9018so8991306qtk.14
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 07:10:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4VpbSrB1Dcjr9uq5ClWUOMNjtNo7OeAGb6rOgQHDZtI=;
        b=qVL9beKR6jTCG2p8fdtKuy9AFlRyRrWHw3BFOV5lkRvzr6wXQPb9pACJ4CMrE0ZMll
         i81S6zeoWyen9E97mYSxSD5anq1msLb7JY3bqqvP5/qyq2eZzLcBwDYJ1XwKwNb3FPVZ
         C6NtAevYPq4qepmHsSP0w3nd9N+PoMBuvBKveKIZgLg6AFrkpwcxcVmPonrYzX8nEkzE
         NyrfwIrbQpYIUf2kpHjBb+46zJwt12HGpSRXgtyu00QOClv6DstVVeF8SrPo8ZdLp5G5
         yS3gqikFUv9tVj7WXeulKj2BIwSccj6WSplYgiAK5XlKX5grdYAq9hP11fq0rokOuGut
         XlHg==
X-Gm-Message-State: AOAM533IjFrvccE3tjr0+DGr239wVOQPDFh+X7TfEYf5Ob6h3tFjLIsb
        +yDPch0Jct+eOqSla+Nsvy0qzzVzwZESLcUNvf9fj0ls+n2+sMKpHeDcB90EAvj0nlknEHDGFdw
        W1X17F3EBNJ8W
X-Received: by 2002:a05:622a:1792:b0:2e1:cdb8:41f6 with SMTP id s18-20020a05622a179200b002e1cdb841f6mr3166055qtk.10.1649167828612;
        Tue, 05 Apr 2022 07:10:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkB5YEBJt1011IJ5YN9w3/3uCOCHgbQt6r2OE8C1Ts/Te+oRJXc//6zeW0BDSRbooWdA3G5w==
X-Received: by 2002:a05:622a:1792:b0:2e1:cdb8:41f6 with SMTP id s18-20020a05622a179200b002e1cdb841f6mr3166027qtk.10.1649167828337;
        Tue, 05 Apr 2022 07:10:28 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id d4-20020a37c404000000b0067d67adea0fsm8136342qki.84.2022.04.05.07.10.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 07:10:27 -0700 (PDT)
Message-ID: <6fb0889f-090d-740b-8ace-8b95b97ebf71@redhat.com>
Date:   Tue, 5 Apr 2022 16:10:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 037/104] KVM: x86/mmu: Allow non-zero init value
 for shadow PTE
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b74b3660f9d16deafe83f2670539a8287bef988f.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <b74b3660f9d16deafe83f2670539a8287bef988f.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
>   static void mmu_spte_clear_no_track(u64 *sptep)
>   {
> -	__update_clear_spte_fast(sptep, 0ull);
> +	__update_clear_spte_fast(sptep, shadow_init_value);
>   }
>   

Please WARN_ON_ONCE if shadow_init_value is nonzero, and then keep 0ull 
as the argument.

I have not thought much of the steps that are needed if were to flip 
both bit 0 and bit 63, so let's at least document that with a WARN.

Otherwise,

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

