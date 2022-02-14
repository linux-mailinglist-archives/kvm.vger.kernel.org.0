Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5C74B50DB
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 13:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353753AbiBNM5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 07:57:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353737AbiBNM5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 07:57:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23FAB4BFDF
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 04:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644843459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oXbXKwNefXUMxjvIv7PZR4ufdZvetqDxpNnWNZX3Q9w=;
        b=Cnt0Bq9sos2VKs4n7o3qVXMk5dcas0z612GkrnDAFWUoijRK9EPo5fZGOg4TXDYgjQ54p8
        nnIDfdSLG0cL0hzXrKl0xnIMsqBOApABM8+Jw+YI9jgBzp2/Qz9zl+n21Plafu4He1KjlT
        DOqSfr4ahfbE3l2BQ/5VnpzryZROhvQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-DsNK_9QFOSmwNcU9LgU42g-1; Mon, 14 Feb 2022 07:57:38 -0500
X-MC-Unique: DsNK_9QFOSmwNcU9LgU42g-1
Received: by mail-ej1-f70.google.com with SMTP id la22-20020a170907781600b006a7884de505so5799928ejc.7
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 04:57:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oXbXKwNefXUMxjvIv7PZR4ufdZvetqDxpNnWNZX3Q9w=;
        b=5Q8o/0DGU20Ec8M3gVFF8Ay9V3Xw8jexS2BXN9w8W4ZqkuYQqULtw1Bav36kycmf9m
         iWpwDkUFI7YJbsZQlyhsM2fCXsrk1iY4+NVlSCER9uYylzKXU6CN98gHIfqpdK9KzLKf
         HpkjnM5UPuMqB6NqtaYtgtd2atOs8rFeuuKNeKflxkRX0kwPY3lrxgFZDWzEttMZ6es5
         mzJAXK4mlTdByhoXTmH+Vqv1K1+rk8qPcsYQoDta+wgs2QSUW6hozG408pRjZl36XHlL
         5u9eGV2EAkQKTr/acYXq9/2F0lGF8Gl8WwUshdZQ6FGnHyEESdwv0oL/z4GwJQpqw7QK
         Yf+w==
X-Gm-Message-State: AOAM530ls4SaF/voqZVfvgogB8hPN+euWd/0UX1+rkU84/i6elBIejfO
        rKsEDq1zhDtTLzg6olxJBeDgdiV4ECGBw1TU+iqLJNy8XbKjg/cd8a9mNK9aAcnUnvgSfkBslVb
        ctVyJI7RQLMWY
X-Received: by 2002:a05:6402:3489:: with SMTP id v9mr15115246edc.249.1644843456846;
        Mon, 14 Feb 2022 04:57:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyU5DkSABeMnnwGxALr4cUufpghJY/IkWE1R3VTtIBjGPU4fKsIkDZmUYsm4G8pEfV5YGtv9A==
X-Received: by 2002:a05:6402:3489:: with SMTP id v9mr15115232edc.249.1644843456718;
        Mon, 14 Feb 2022 04:57:36 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id p5sm8932228ejr.105.2022.02.14.04.57.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 04:57:36 -0800 (PST)
Message-ID: <a3008754-86a8-88d6-df7f-a2770b0a2c93@redhat.com>
Date:   Mon, 14 Feb 2022 13:57:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2] KVM: SEV: Allow SEV intra-host migration of VM with
 mirrors
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>, linux-kernel@vger.kernel.org
References: <20220211193634.3183388-1-pgonda@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220211193634.3183388-1-pgonda@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/11/22 20:36, Peter Gonda wrote:
> +	list_cut_before(&dst->mirror_vms, &src->mirror_vms, &src->mirror_vms);
> +	list_for_each_entry_safe(mirror, tmp, &dst->mirror_vms,
> +				 mirror_entry) {

Is list_for_each_entry_safe actually necessary here?  (It would be if 
you used list_add/list_del instead of list_cut_before).

> +		kvm_get_kvm(dst_kvm);
> +		kvm_put_kvm(src_kvm);
> +		mirror->enc_context_owner = dst_kvm;
> +	}

Thanks,

Paolo

