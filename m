Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E974F629E
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 17:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbiDFPDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 11:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235935AbiDFPDP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 11:03:15 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C17D30F0E4;
        Wed,  6 Apr 2022 04:48:27 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id n6so3626615ejc.13;
        Wed, 06 Apr 2022 04:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pjR3ZKgCNlG2r3MTFcz+8pEF96poMRdIaSe2ljO7/xk=;
        b=eYL4/LuqUIxaerOgfa3GApON8QrsWa5AjqMB1adkTFYzk4SvAT1JPOjeNKLba2t+Zn
         JfQyKbqmAEopHyZI69vxE9fnVkNnMGWMuYaP3UU1mgG0ZHwOmtTWz/oR+IXmtGrH3FnE
         9idHtS+A0oKDBbwr0d3DsWS8g2wNi7/a+TCLLeA2Q7de6VbTENizuPvydmGz+Ti5olKu
         NebDcUTxZ87tO5fLYItCwy5sTYAX38TKYKyW83BulP1WHFFMP4XzjDdSVHJa9mlnENZ3
         m3we0ZjCTHRygkBYQJzyBMXvqVyzCGW8z0fQup1BmqVy+5Lkzzg/+5bb4+dEnn4y9q4e
         oMgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pjR3ZKgCNlG2r3MTFcz+8pEF96poMRdIaSe2ljO7/xk=;
        b=3VtH46O3FklSNe1CY99NXOe065j+lsHSz4CmJC9aJY/nmXWfkivROJTF29yDlgucYm
         QyejY/RrFm2exVNp20TeswED4o5EK7hJ+E+cTXPcN0MK0BU3Kq923iiVioE7DoiPoCOT
         DiyDzXBwPDXZ4z1+90rrgRyapGzLz+EpT3eE/XwepUE5pj/HTz6FqYNVjFAp/iIkT/jO
         GpahZuY37lJEyYr7A9RIEbQZ/rnIQl7I/oE/VC9878xIX9Yo3Jhyba56Fs0Wx+Md7CYK
         WKMNrIc5E6M5Rfv6Bx7pfRPcf3NaK/egurWZwW1qx4h4k8XvyQNr4ma8N65obQrCdE78
         7QJw==
X-Gm-Message-State: AOAM531/QllZYH8EB+AvEGNwvOP8I7i/sJvKPyLxheR9OE+ate1Pv+qA
        WknyHENLEom3VVwsjvWIOm0=
X-Google-Smtp-Source: ABdhPJyo0WafdMO5+IasWWGJZeUfnt2xy0e4WcgANDB0CW3P+SCtYqf61F6AiNhMSMPZ2Zwx91rqxg==
X-Received: by 2002:a17:907:1b06:b0:6e7:f58a:9b91 with SMTP id mp6-20020a1709071b0600b006e7f58a9b91mr8070888ejc.291.1649245678783;
        Wed, 06 Apr 2022 04:47:58 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id k19-20020a1709062a5300b006c75a94c587sm6530560eje.65.2022.04.06.04.47.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 04:47:58 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <220361fd-6375-5874-cb1c-f7c22794f64f@redhat.com>
Date:   Wed, 6 Apr 2022 13:47:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 078/104] KVM: TDX: Implement interrupt injection
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <776d48b5c88ebf189ffac1eb94ef190bfc7210da.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <776d48b5c88ebf189ffac1eb94ef190bfc7210da.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please do not duplicate code, for example:

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
>   
> +void tdx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +	pi_clear_on(&tdx->pi_desc);
> +	memset(tdx->pi_desc.pir, 0, sizeof(tdx->pi_desc.pir));
> +}

This is the same as vmx_apicv_post_state_restore.  Please write this like:

void vt_apicv_post_state_restore(struct kvm_vcpu *vcpu)
{
	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
	pi_clear_on(pi);
	memset(pi->pir, 0, sizeof(pi->pir));
}


Otherwise,

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo
