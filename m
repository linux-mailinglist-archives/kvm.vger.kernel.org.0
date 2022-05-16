Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A742529367
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 00:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238952AbiEPWMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 18:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiEPWMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 18:12:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B5912A729
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 15:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652739172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mOLynXxIcf1eQmVHJTgI16Qe2901pe4A9MbmTzOTJLg=;
        b=VbDDFLvNzUpzGGXcGsFx7tjoBDdcVtYNsjT/ikIQO6KjBWF3x9YOvR5LUGPjvQ5IuSCE4f
        CCsbc2+ERkA0dr5AQHlZSn8coqU2Iw1XJnlIxGKy24a7Kvlvj8zf/N0mCTb1dztjn1TNJI
        vU+/EdBguQL2HB9wyTUs4/19Ug+8au0=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-p_qGdD1COguM6byaM8fxaQ-1; Mon, 16 May 2022 18:12:51 -0400
X-MC-Unique: p_qGdD1COguM6byaM8fxaQ-1
Received: by mail-io1-f71.google.com with SMTP id s129-20020a6b2c87000000b00657c1a3b52fso11199201ios.21
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 15:12:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mOLynXxIcf1eQmVHJTgI16Qe2901pe4A9MbmTzOTJLg=;
        b=D+cfw6TR+0mMNvtF7De+7oMH04+jllJn6zKnF6TEeVTWgp8/FQJC5cjVJwkehA+6DL
         ovsvOP7sh9dND3xoUttmnoSaaPrP24PIoT4J1BFujIdkkR3iLD0CtfKN2ooULmrj9Eb4
         gQnM0KgQmR4d/3yfefh69/Z1rebFBOM1kMi20PWo8WKOUmxA9+CCteJFY08pBkpAUG3x
         uGZtAk8XJEDZzZZVaLaOjHHM84Ph2EoRduTGzp8/l5KyhvtIFbllxhRksT5NgE4gkuuF
         ez+O14Q36AIiyRp5qF9Zs8Wvr92zfcvQjhnabQCCBrvTn+luBmzQ34ztCti/CEkBfcg3
         VDdw==
X-Gm-Message-State: AOAM530MqW+c8BUbJk+DPlWwI1pFoQwwDvLI5bAZthf22aZFEd9JOxgj
        /jkj/XCwNZT0SzORDpYGuiniwm1vtDsJLxIQxCEKa+Kjt8yHVGiHmLXqlcwPZX02qzUeh5xxUX6
        SszL2EuZR2HEC
X-Received: by 2002:a02:964e:0:b0:32e:1153:1c69 with SMTP id c72-20020a02964e000000b0032e11531c69mr7070644jai.49.1652739170587;
        Mon, 16 May 2022 15:12:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBC3NroV2d/YMX8ZEu2ZdkkwX0HD1doBJ2fWsXhh2wWEDEFqSmDvIewyMu0dr3PXn2k9RneQ==
X-Received: by 2002:a02:964e:0:b0:32e:1153:1c69 with SMTP id c72-20020a02964e000000b0032e11531c69mr7070633jai.49.1652739170357;
        Mon, 16 May 2022 15:12:50 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id f34-20020a0284a5000000b0032e295fec1bsm1389938jai.88.2022.05.16.15.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 15:12:49 -0700 (PDT)
Date:   Mon, 16 May 2022 18:12:48 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/9] KVM: selftests: Move VMX_EPT_VPID_CAP_AD_BITS to
 vmx.h
Message-ID: <YoLMYIb7hbAsiYW0@xz-m1.local>
References: <20220429183935.1094599-1-dmatlack@google.com>
 <20220429183935.1094599-6-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220429183935.1094599-6-dmatlack@google.com>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 06:39:31PM +0000, David Matlack wrote:
> This is a VMX-related macro so move it to vmx.h. While here, open code
> the mask like the rest of the VMX bitmask macros.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

