Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972D74F44B9
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 00:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242587AbiDEOwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 10:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384621AbiDEOSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 10:18:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 490E811D7BA
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 06:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649163865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+4H3o/lgu3i0pcf5MrN0knfGAGcFyCTknMXedxYHF10=;
        b=Qk+hScf7jQIir96nc0QLeymUfF5A8ekYuIzw7+0o8ZgdSMqu+rDUYZysdDWuHEZqepo/w8
        qoe9gpgfMOtJJ4jZL6Z+3lhilG+jx9R1QsBx1YZ7FJMc5K6GFj3j31mIujVRJXtFYm47Rr
        Eo5efe3LTxiodJGwLE4O04vGDVNoTIY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-xfRAWuFHPEyGPel_ujcVNQ-1; Tue, 05 Apr 2022 09:04:24 -0400
X-MC-Unique: xfRAWuFHPEyGPel_ujcVNQ-1
Received: by mail-wr1-f72.google.com with SMTP id k20-20020adfc714000000b001e305cd1597so2439737wrg.19
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 06:04:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+4H3o/lgu3i0pcf5MrN0knfGAGcFyCTknMXedxYHF10=;
        b=tGQGHs4RwJhA0I7qhR78y28mf1PB5C5vYlmK6Ne4x/IHguZJOJ5Lpeodgx9YI52mmO
         vFZBFbid8QFz2I66jirl3OQC8HquVWpfXU4zhSMub6/6unWvSX0BBdQ5zdK+Po0r0jEV
         Z7oiaYg6BqKqm8G80gD1rcr2OLYK7zF01Xqo/fvuNGY0kN0AmV6ntmI5jLzjiv1VXdG4
         S/CPY3AcnbXojC2aZMfeHhbBygWA+OF3940/dWjtobL8M8fWgnc+Io7qhHYE7T5ne7NZ
         re8vVp6jrOkru5kTJM9d7s/Tin14PrvxFZKgdjfnxQQab60qE31kZINAObxcoMDgYRk8
         r/sQ==
X-Gm-Message-State: AOAM53225lE5UEMso5LMAYdGn4QQY/fYln+2oE4FyjPx29n/DvaMwKXy
        2E+eO4V71HByVNXSzzrnpSJgsI244kiRpeUAr868RY7jamYOoGnWNyf5etLbtzO5ME4LOcX/1uY
        u0VGmCKf1lA++
X-Received: by 2002:a05:600c:1c0e:b0:38c:ae37:c1d2 with SMTP id j14-20020a05600c1c0e00b0038cae37c1d2mr3022441wms.205.1649163862692;
        Tue, 05 Apr 2022 06:04:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTKXWIZeydbVrpApPxpI5TVS/gLhuIP6d8IrLPccqlzN5Ubrjxgzd+R1jeG967OIfKlV6SFg==
X-Received: by 2002:a1c:7519:0:b0:383:d29b:257 with SMTP id o25-20020a1c7519000000b00383d29b0257mr3095490wmc.172.1649163851954;
        Tue, 05 Apr 2022 06:04:11 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id o29-20020a05600c511d00b0038e3532b23csm2192280wms.15.2022.04.05.06.04.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 06:04:11 -0700 (PDT)
Message-ID: <a02a704a-e53d-6f1f-cd7f-a10b773475cc@redhat.com>
Date:   Tue, 5 Apr 2022 15:04:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 029/104] KVM: TDX: allocate/free TDX vcpu structure
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <e50caba2a40beaaee7fc1ade60d55d414d979d34.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <e50caba2a40beaaee7fc1ade60d55d414d979d34.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> +	/*
> +	 * In TDX case, tsc frequency is per-VM and determined by the parameter
> +	 * tdh_mng_init().  Forcibly set it instead of max_tsc_khz set by
> +	 * kvm_arch_vcpu_create().
> +	 *
> +	 * This function is called after kvm_arch_vcpu_create() calling
> +	 * kvm_set_tsc_khz().
> +	 */
> +	kvm_set_tsc_khz(vcpu, kvm_tdx->tsc_khz);
> +

I think this is not needed anymore, now that there is 
kvm->arch.default_tsc_khz.  If so, exporting the function is not needed 
either.

Paolo

